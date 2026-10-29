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
import com.subrat.clinic.service.ServicePriceService;
import com.subrat.clinic.service.SiteSettingService;

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
import java.nio.charset.StandardCharsets;
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
    private ObjectMapper objectMapper;

    // Home page
    @GetMapping("/")
    public String showHomePage(Model model) throws Exception {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", clinicians());
        model.addAttribute("servicePrices", servicePriceService.findAll());
        model.addAttribute("doctorFeesJson", bookingFeeJson());
        model.addAttribute("consultationFee", siteSettingService.getConsultationFee());
        return "index";
    }

    // Standalone booking form (book_appointment.jsp)
    @GetMapping("/book_appointment")
    public String showBookAppointmentForm(Authentication authentication, Model model) throws Exception {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", clinicians());
        model.addAttribute("servicePrices", servicePriceService.findAll());
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
            if (price == null || price.getFee() == null) {
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
        String html = buildReceiptHtml(appointment);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType("text", "html", StandardCharsets.UTF_8));
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename("DentCare-Receipt-" + appointment.getPaymentReference() + ".html")
                .build());
        return new ResponseEntity<>(html.getBytes(StandardCharsets.UTF_8), headers,
                org.springframework.http.HttpStatus.OK);
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
    public String showAboutPage() {
        return "about";
    }

    @GetMapping("/service")
    public String showService() {
        return "service";
    }

    @GetMapping("/testimonial")
    public String showTestimonial() {
        return "testimonial";
    }

    @GetMapping("/team")
    public String showTeamPage(Model model) {
        model.addAttribute("doctors", clinicians());
        return "team";
    }

    @GetMapping("/price")
    public String showPricingPage(Model model) {
        model.addAttribute("servicePrices", servicePriceService.findAll());
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

    private String buildReceiptHtml(Appointment appointment) {
        String siteName = escape(siteSettingService.get("siteName"));
        String address = escape(siteSettingService.get("footerAddress"));
        String phone = escape(siteSettingService.get("footerPhone"));
        String email = escape(siteSettingService.get("footerEmail"));
        String title = escape(siteSettingService.get("receiptTitle"));
        String note = escape(siteSettingService.get("receiptNote"));
        String footer = escape(siteSettingService.get("receiptFooter"));
        String method = appointment.getPaymentMethod() == null
                ? "—" : escape(appointment.getPaymentMethod().getLabel());
        String amount = appointment.getAmount() == null ? "0.00"
                : appointment.getAmount().setScale(2, java.math.RoundingMode.HALF_UP).toPlainString();

        return """
                <!DOCTYPE html>
                <html lang="en"><head><meta charset="utf-8">
                <title>%s · %s</title>
                <style>
                  body{font-family:Segoe UI,Arial,sans-serif;background:#f4f7fa;color:#172b4d;margin:0;padding:32px}
                  .sheet{max-width:720px;margin:0 auto;background:#fff;border:1px solid #e3eaf2;border-radius:14px;overflow:hidden}
                  .head{background:#0f766e;color:#fff;padding:26px 32px;display:flex;justify-content:space-between;gap:16px;flex-wrap:wrap}
                  .head h1{margin:0;font-size:22px}.head p{margin:4px 0 0;color:#cdeee8;font-size:13px}
                  .body{padding:28px 32px}.grid{display:grid;grid-template-columns:1fr 1fr;gap:16px 24px;margin-bottom:22px}
                  .label{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#7a8aa0}
                  .value{font-weight:600;margin-top:3px}
                  table{width:100%%;border-collapse:collapse}td{padding:10px 0;border-bottom:1px dashed #e3eaf2}
                  td:last-child{text-align:right;font-weight:600}.total td{border-bottom:0;font-size:18px;color:#0f766e}
                  .note{background:#f1faf8;border:1px solid #d5eee9;border-radius:9px;padding:12px 14px;font-size:13px;color:#315b56;margin-top:18px}
                  .foot{border-top:1px solid #e3eaf2;padding:16px 32px;color:#7a8aa0;font-size:12px}
                  @media print{body{background:#fff;padding:0}.sheet{border:0;border-radius:0}}
                </style></head><body><div class="sheet">
                  <div class="head"><div><h1>%s</h1><p>%s · %s · %s</p></div><div style="text-align:right"><div style="font-size:12px;color:#cdeee8">REFERENCE</div><strong>%s</strong></div></div>
                  <div class="body">
                    <div class="grid">
                      <div><div class="label">Patient</div><div class="value">%s</div></div>
                      <div><div class="label">Doctor</div><div class="value">%s</div></div>
                      <div><div class="label">Visit type</div><div class="value">%s</div></div>
                      <div><div class="label">Service</div><div class="value">%s</div></div>
                      <div><div class="label">Appointment</div><div class="value">%s at %s</div></div>
                      <div><div class="label">Status</div><div class="value">%s</div></div>
                    </div>
                    <table>
                      <tr><td>Payment method</td><td>%s</td></tr>
                      <tr><td>Payment detail</td><td>%s</td></tr>
                      <tr><td>Payment status</td><td>%s</td></tr>
                      <tr><td>Booking reference</td><td>%s</td></tr>
                      <tr><td>Paid on</td><td>%s</td></tr>
                      <tr class="total"><td>Amount</td><td>₹%s</td></tr>
                    </table>
                    <div class="note">%s</div>
                  </div>
                  <div class="foot">%s<br>%s</div>
                </div></body></html>
                """.formatted(
                title, siteName, siteName, address, phone, email,
                escape(appointment.getPaymentReference()),
                escape(appointment.getPatientName()),
                escape(appointment.getDoctorName()),
                appointment.getAppointmentType().getLabel(),
                escape(appointment.getService()),
                appointment.getAppointmentDate(), appointment.getAppointmentTime(),
                appointment.getStatus().getLabel(),
                method,
                escape(appointment.getPaymentDetail()),
                appointment.getPaymentStatus().getLabel(),
                escape(appointment.getPaymentReference()),
                escape(appointment.getPaidAtDisplay()),
                amount, note, footer, title);
    }

    private String escape(String value) {
        if (value == null || value.isBlank()) {
            return "—";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
