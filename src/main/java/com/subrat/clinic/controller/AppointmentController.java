package com.subrat.clinic.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.AppointmentStatus;
import com.subrat.clinic.model.AppointmentType;
import com.subrat.clinic.model.Doctor;
import com.subrat.clinic.model.Patient;
import com.subrat.clinic.model.PaymentMethod;
import com.subrat.clinic.model.PaymentStatus;
import com.subrat.clinic.model.ServicePrice;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorFeeService;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.PatientService;
import com.subrat.clinic.service.ReceiptPdfService;
import com.subrat.clinic.service.ServicePriceService;
import com.subrat.clinic.service.SiteSettingService;
import com.subrat.clinic.service.TestimonialService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Controller
public class AppointmentController {

    private static final String REFERENCE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final Pattern UPI_PATTERN =
            Pattern.compile("^[A-Za-z0-9._-]{2,}@[A-Za-z]{2,}$");

    private final SecureRandom random = new SecureRandom();

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private ServicePriceService servicePriceService;

    @Autowired
    private DoctorFeeService doctorFeeService;

    @Autowired
    private SiteSettingService siteSettingService;

    @Autowired
    private TestimonialService testimonialService;

    @Autowired
    private ReceiptPdfService receiptPdfService;

    @Autowired
    private ObjectMapper objectMapper;

    // Home page
    @GetMapping("/")
    public String showHomePage(Model model) throws Exception {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", clinicians());
        model.addAttribute("servicePrices", servicePriceService.findActive());
        model.addAttribute("testimonials", testimonialService.findActive());
        model.addAttribute("doctorFeesJson", bookingFeeJson());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        return "index";
    }

    // Standalone booking form (book_appointment.jsp)
    @GetMapping("/book_appointment")
    public String showBookAppointmentForm(Authentication authentication, Model model) throws Exception {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", clinicians());
        model.addAttribute("servicePrices", servicePriceService.findActive());
        model.addAttribute("doctorFeesJson", bookingFeeJson());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        model.addAttribute("booker", authentication == null ? null
                : patientService.findByEmail(authentication.getName()));
        return "book_appointment";
    }

    // Step 1: create the appointment, then send the patient to checkout.
    @PostMapping("/book")
    public String bookAppointment(
            Authentication authentication,
            @RequestParam String patientName,
            @RequestParam String phone,
            @RequestParam(required = false) Long doctorId,
            @RequestParam(required = false) String doctorName,
            @RequestParam(required = false) String appointmentType,
            @RequestParam(required = false) String service,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime appointmentTime,
            RedirectAttributes redirectAttributes
    ) {
        if (authentication == null) {
            return "redirect:/login";
        }
        Doctor doctor = doctorId != null ? doctorService.findById(doctorId) : doctorService.findByName(doctorName);
        if (doctor == null || doctor.isAdmin()) {
            redirectAttributes.addFlashAttribute("error", "Choose an available doctor.");
            return "redirect:/book_appointment";
        }
        if (appointmentDate == null || appointmentDate.isBefore(LocalDate.now())) {
            redirectAttributes.addFlashAttribute("error", "Please choose today or a future appointment date.");
            return "redirect:/book_appointment";
        }
        if (appointmentTime == null) {
            redirectAttributes.addFlashAttribute("error", "Choose an appointment time.");
            return "redirect:/book_appointment";
        }
        if (isBlank(patientName) || patientName.trim().length() < 2 || isBlank(phone)) {
            redirectAttributes.addFlashAttribute("error", "Enter your name and phone number.");
            return "redirect:/book_appointment";
        }

        AppointmentType type = "CONSULTATION".equalsIgnoreCase(appointmentType)
                ? AppointmentType.CONSULTATION : AppointmentType.TREATMENT;

        String serviceName;
        BigDecimal amount;
        if (type == AppointmentType.CONSULTATION) {
            serviceName = "General Consultation";
            amount = doctorFeeService.resolveFee(doctor, type, null,
                    siteSettingService.getConsultationFee());
        } else {
            ServicePrice price = servicePriceService.findByServiceName(service);
            if (price == null || !price.isActive() || price.getFee() == null) {
                redirectAttributes.addFlashAttribute("error",
                        "The selected treatment is not available right now. Please choose another treatment.");
                return "redirect:/book_appointment";
            }
            serviceName = price.getServiceName();
            amount = doctorFeeService.resolveFee(doctor, type, serviceName, price.getFee());
        }

        boolean slotTaken = appointmentService.getAll().stream()
                .filter(a -> a.getStatus() != AppointmentStatus.CANCELLED)
                .filter(a -> a.getAppointmentDate() != null && a.getAppointmentDate().equals(appointmentDate))
                .filter(a -> a.getAppointmentTime() != null && a.getAppointmentTime().equals(appointmentTime))
                .anyMatch(a -> (a.getDoctorId() != null && a.getDoctorId().equals(doctor.getId()))
                        || (a.getDoctorName() != null && a.getDoctorName().equalsIgnoreCase(doctor.getName())));
        if (slotTaken) {
            redirectAttributes.addFlashAttribute("error",
                    "That doctor is already booked at this date and time. Please choose another slot.");
            return "redirect:/book_appointment";
        }

        Patient patient = patientService.findByEmail(authentication.getName());
        Appointment appointment = new Appointment();
        appointment.setPatientName(patientName.trim());
        appointment.setEmail(authentication.getName());
        appointment.setPhone(phone.trim());
        appointment.setDoctorId(doctor.getId());
        appointment.setDoctorName(doctor.getName());
        appointment.setService(serviceName);
        appointment.setAppointmentType(type);
        appointment.setStatus(AppointmentStatus.BOOKED);
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);
        appointment.setAmount(amount);
        appointment.setPaymentStatus(PaymentStatus.PENDING);
        appointment.setPaymentReference(createReference());
        if (patient != null && patient.getPhone() != null && patient.getPhone().isBlank()) {
            patient.setPhone(phone.trim());
            patientService.save(patient);
        }

        appointmentService.save(appointment);
        return "redirect:/booking/pay/" + appointment.getPaymentReference();
    }

    // Step 2: payment method and simulated gateway.
    @GetMapping("/booking/pay/{reference}")
    public String showPaymentPage(@PathVariable String reference, Model model) {
        Appointment appointment = appointmentService.findByReference(reference);
        if (appointment == null) {
            return "redirect:/book_appointment?error=notfound";
        }
        if (appointment.isCancelled()) {
            return "redirect:/booking/confirmation/" + appointment.getPaymentReference();
        }
        if (appointment.getPaymentStatus() != PaymentStatus.PENDING) {
            return "redirect:/booking/confirmation/" + appointment.getPaymentReference();
        }
        model.addAttribute("appointment", appointment);
        return "booking_payment";
    }

    @PostMapping("/booking/pay/{reference}")
    public String processPayment(
            @PathVariable String reference,
            @RequestParam(required = false) String method,
            @RequestParam(required = false) String bankName,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String cardNumber,
            @RequestParam(required = false) String cardName,
            @RequestParam(required = false) String cardExpiry,
            @RequestParam(required = false) String cardCvv,
            RedirectAttributes redirectAttributes
    ) {
        Appointment appointment = appointmentService.findByReference(reference);
        if (appointment == null) {
            return "redirect:/book_appointment?error=notfound";
        }
        if (appointment.isCancelled()) {
            return "redirect:/booking/confirmation/" + appointment.getPaymentReference();
        }
        if (appointment.getPaymentStatus() != PaymentStatus.PENDING) {
            return "redirect:/booking/confirmation/" + appointment.getPaymentReference();
        }

        PaymentMethod paymentMethod;
        try {
            paymentMethod = PaymentMethod.valueOf(
                    method == null ? "" : method.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException exception) {
            redirectAttributes.addFlashAttribute("paymentError", "Choose a valid payment method.");
            return "redirect:/booking/pay/" + reference;
        }

        String error = null;
        String detail = null;

        switch (paymentMethod) {
            case NETBANKING -> {
                if (isBlank(bankName)) {
                    error = "Choose your bank to continue with net banking.";
                } else {
                    detail = paymentMethod.getLabel() + " - " + bankName.trim();
                }
            }
            case UPI -> {
                if (isBlank(upiId) || !UPI_PATTERN.matcher(upiId.trim()).matches()) {
                    error = "Enter a valid UPI ID, for example name@bank.";
                } else {
                    detail = "UPI - " + upiId.trim();
                }
            }
            case DEBIT_CARD, CREDIT_CARD -> {
                String digits = cardNumber == null ? "" : cardNumber.replaceAll("[^0-9]", "");
                if (!digits.matches("\\d{13,19}")) {
                    error = "Enter a valid card number.";
                } else if (!isValidExpiry(cardExpiry)) {
                    error = "Enter a valid expiry date in MM/YY format.";
                } else if (cardCvv == null || !cardCvv.trim().matches("\\d{3,4}")) {
                    error = "Enter the 3 or 4 digit CVV.";
                } else if (isBlank(cardName)) {
                    error = "Enter the name printed on the card.";
                } else {
                    // Full card numbers and CVVs are never stored.
                    detail = paymentMethod.getLabel() + " ending " + digits.substring(digits.length() - 4);
                }
            }
            case QR -> detail = "UPI QR scan";
            case CASH -> detail = "Pay at clinic reception";
        }

        if (error != null) {
            redirectAttributes.addFlashAttribute("paymentError", error);
            return "redirect:/booking/pay/" + reference;
        }

        appointment.setPaymentMethod(paymentMethod);
        appointment.setPaymentDetail(detail);
        if (paymentMethod == PaymentMethod.CASH) {
            appointment.setPaymentStatus(PaymentStatus.PAY_AT_CLINIC);
            appointment.setPaidAt(null);
        } else {
            appointment.setPaymentStatus(PaymentStatus.PAID);
            appointment.setPaidAt(LocalDateTime.now());
        }
        appointmentService.save(appointment);

        return "redirect:/booking/confirmation/" + appointment.getPaymentReference();
    }

    // Step 3: success / receipt page with the booking reference.
    @GetMapping("/booking/confirmation/{reference}")
    public String showConfirmation(@PathVariable String reference, Model model) {
        Appointment appointment = appointmentService.findByReference(reference);
        if (appointment == null) {
            return "redirect:/book_appointment?error=notfound";
        }
        if (appointment.getPaymentStatus() == PaymentStatus.PENDING && !appointment.isCancelled()) {
            return "redirect:/booking/pay/" + appointment.getPaymentReference();
        }
        model.addAttribute("appointment", appointment);
        return "booking_confirmation";
    }

    // Downloadable, print-ready receipt. The reference ID acts as the access token.
    @GetMapping("/booking/receipt/{reference}/download")
    public ResponseEntity<byte[]> downloadReceipt(@PathVariable String reference) {
        Appointment appointment = appointmentService.findByReference(reference);
        if (appointment == null) {
            return ResponseEntity.notFound().build();
        }
        byte[] pdf = receiptPdfService.generate(appointment);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename("DentCare-Receipt-" + appointment.getPaymentReference() + ".pdf")
                .build());
        headers.setContentLength(pdf.length);
        return new ResponseEntity<>(pdf, headers, org.springframework.http.HttpStatus.OK);
    }

    // Live fee feed used by the booking form. It keeps an open booking page in
    // sync with admin approvals without requiring a page reload or a restart.
    @GetMapping(value = "/api/booking/fees", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> bookingFees() {
        Map<String, Object> payload = new java.util.LinkedHashMap<>();
        payload.put("consultationFee", siteSettingService.getConsultationFee());
        payload.put("doctorFees", doctorFeeService.approvedFeeMap());
        payload.put("services", servicePriceService.findActive().stream().map(price -> {
            Map<String, Object> item = new java.util.LinkedHashMap<>();
            item.put("name", price.getServiceName());
            item.put("fee", price.getFee());
            item.put("description", price.getDescription());
            return item;
        }).toList());
        return payload;
    }

    // Logged-in patient: upcoming, history and cancelled appointments.
    @GetMapping("/my/appointments")
    public String userAppointments(Authentication authentication,
                                   @RequestParam(defaultValue = "upcoming") String view,
                                   Model model) {
        String email = authentication.getName();
        List<Appointment> all = appointmentService.findByEmail(email);
        LocalDate today = LocalDate.now();

        List<Appointment> upcoming = all.stream()
                .filter(a -> a.getStatus() == AppointmentStatus.BOOKED
                        && a.getAppointmentDate() != null && !a.getAppointmentDate().isBefore(today))
                .sorted(Comparator.comparing(Appointment::getAppointmentDate)
                        .thenComparing(Appointment::getAppointmentTime))
                .toList();
        List<Appointment> history = all.stream()
                .filter(a -> a.getStatus() == AppointmentStatus.COMPLETED
                        || (a.getAppointmentDate() != null && a.getAppointmentDate().isBefore(today)
                        && a.getStatus() != AppointmentStatus.CANCELLED))
                .toList();
        List<Appointment> cancelled = all.stream()
                .filter(a -> a.getStatus() == AppointmentStatus.CANCELLED)
                .toList();

        String selected = switch (view == null ? "" : view.toLowerCase(Locale.ROOT)) {
            case "history" -> "history";
            case "cancelled" -> "cancelled";
            default -> "upcoming";
        };
        List<Appointment> visible = switch (selected) {
            case "history" -> history;
            case "cancelled" -> cancelled;
            default -> upcoming;
        };

        BigDecimal totalPaid = all.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PAID)
                .map(Appointment::getAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        model.addAttribute("appointments", visible);
        model.addAttribute("upcoming", upcoming);
        model.addAttribute("history", history);
        model.addAttribute("cancelled", cancelled);
        model.addAttribute("selectedView", selected);
        model.addAttribute("totalCount", all.size());
        model.addAttribute("totalPaid", totalPaid);
        return "my_appointments";
    }

    // Logged-in patient: receipts and payment history.
    @GetMapping("/my/receipts")
    public String userReceipts(Authentication authentication, Model model) {
        List<Appointment> receipts = appointmentService.findByEmail(authentication.getName()).stream()
                .filter(a -> a.getPaymentStatus() != PaymentStatus.PENDING
                        && a.getPaymentReference() != null)
                .toList();
        BigDecimal totalPaid = receipts.stream()
                .filter(a -> a.getPaymentStatus() == PaymentStatus.PAID)
                .map(Appointment::getAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        model.addAttribute("receipts", receipts);
        model.addAttribute("totalPaid", totalPaid);
        return "my_receipts";
    }

    // Logged-in patient: cancel own appointment (kept in history, not deleted).
    @PostMapping("/my/appointments/cancel/{id}")
    public String cancelAppointment(@PathVariable Long id,
                                    Authentication authentication,
                                    RedirectAttributes redirectAttributes) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment != null && authentication != null) {
            String email = authentication.getName();
            if (appointment.getEmail() != null && appointment.getEmail().equalsIgnoreCase(email)
                    && appointment.getStatus() == AppointmentStatus.BOOKED) {
                appointment.setStatus(AppointmentStatus.CANCELLED);
                appointment.setCancelledAt(LocalDateTime.now());
                appointmentService.save(appointment);
                redirectAttributes.addFlashAttribute("success", "Appointment cancelled. It is now in your cancelled list.");
                return "redirect:/my/appointments?view=cancelled";
            }
        }
        redirectAttributes.addFlashAttribute("error", "That appointment could not be cancelled.");
        return "redirect:/my/appointments";
    }

    // Static pages
    @GetMapping("/contact")
    public String showContactPage() {
        return "contact";
    }

    @GetMapping("/about")
    public String showAboutPage(Model model) {
        model.addAttribute("servicePrices", servicePriceService.findActive());
        return "about";
    }

    @GetMapping("/service")
    public String showService(Model model) {
        model.addAttribute("servicePrices", servicePriceService.findActive());
        return "service";
    }

    @GetMapping("/testimonial")
    public String showTestimonial(Model model) {
        model.addAttribute("testimonials", testimonialService.findActive());
        return "testimonial";
    }

    @GetMapping("/team")
    public String showTeamPage(Model model) {
        model.addAttribute("doctors", clinicians());
        return "team";
    }

    @GetMapping("/price")
    public String showPricingPage(Model model) {
        model.addAttribute("servicePrices", servicePriceService.findActive());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        return "price";
    }

    private List<Doctor> clinicians() {
        return doctorService.findAll().stream()
                .filter(doctor -> !doctor.isAdmin())
                .collect(Collectors.toList());
    }

    private String bookingFeeJson() throws Exception {
        return objectMapper.writeValueAsString(doctorFeeService.approvedFeeMap());
    }

    private String createReference() {
        String datePart = LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE);
        for (int attempt = 0; attempt < 25; attempt++) {
            StringBuilder reference = new StringBuilder("DC-").append(datePart).append('-');
            for (int i = 0; i < 6; i++) {
                reference.append(REFERENCE_ALPHABET.charAt(random.nextInt(REFERENCE_ALPHABET.length())));
            }
            String value = reference.toString();
            if (appointmentService.findByReference(value) == null) {
                return value;
            }
        }
        throw new IllegalStateException("Unable to allocate a booking reference");
    }

    private boolean isValidExpiry(String expiry) {
        if (expiry == null) {
            return false;
        }
        String value = expiry.trim();
        if (!value.matches("(0[1-9]|1[0-2])/\\d{2}")) {
            return false;
        }
        int month = Integer.parseInt(value.substring(0, 2));
        int year = 2000 + Integer.parseInt(value.substring(3));
        return !YearMonth.of(year, month).isBefore(YearMonth.now());
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
