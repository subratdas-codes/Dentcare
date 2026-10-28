package com.subrat.clinic.controller;

import com.subrat.clinic.model.Appointment;
import com.subrat.clinic.model.PaymentMethod;
import com.subrat.clinic.model.PaymentStatus;
import com.subrat.clinic.model.ServicePrice;
import com.subrat.clinic.service.AppointmentService;
import com.subrat.clinic.service.DoctorService;
import com.subrat.clinic.service.ServicePriceService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

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
	private ServicePriceService servicePriceService;

    // Home page
    @GetMapping("/")
    public String showHomePage(Model model) {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("servicePrices", servicePriceService.findAll());
        return "index";
    }

    // Standalone booking form (book_appointment.jsp)
    @GetMapping("/book_appointment")
    public String showBookAppointmentForm(Model model) {
        model.addAttribute("appointment", new Appointment());
        model.addAttribute("doctors", doctorService.findAll());
        model.addAttribute("servicePrices", servicePriceService.findAll());
        return "book_appointment";
    }

    // Step 1: create the appointment, then send the patient to checkout.
    @PostMapping("/book")
    public String bookAppointment(
            @RequestParam String patientName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String doctorName,
            @RequestParam("service") String serviceType,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.TIME) LocalTime appointmentTime,
            RedirectAttributes redirectAttributes
    ) {
        ServicePrice price = servicePriceService.findByServiceName(serviceType);
        if (price == null || price.getFee() == null) {
            redirectAttributes.addFlashAttribute("error",
                    "The selected service is not available right now. Please choose another service.");
            return "redirect:/book_appointment";
        }
        if (appointmentDate == null || appointmentDate.isBefore(LocalDate.now())) {
            redirectAttributes.addFlashAttribute("error", "Please choose today or a future appointment date.");
            return "redirect:/book_appointment";
        }
        if (isBlank(patientName) || isBlank(email) || isBlank(phone) || isBlank(doctorName)
                || appointmentTime == null) {
            redirectAttributes.addFlashAttribute("error", "Please complete all appointment details.");
            return "redirect:/book_appointment";
        }

        Appointment appointment = new Appointment();
        appointment.setPatientName(patientName.trim());
        appointment.setEmail(email.trim().toLowerCase(Locale.ROOT));
        appointment.setPhone(phone.trim());
        appointment.setDoctorName(doctorName.trim());
        appointment.setService(price.getServiceName());
        appointment.setAppointmentDate(appointmentDate);
        appointment.setAppointmentTime(appointmentTime);
        appointment.setAmount(price.getFee());
        appointment.setPaymentStatus(PaymentStatus.PENDING);
        appointment.setPaymentReference(createReference());

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
        if (appointment.getPaymentStatus() == PaymentStatus.PENDING) {
            return "redirect:/booking/pay/" + appointment.getPaymentReference();
        }
        model.addAttribute("appointment", appointment);
        return "booking_confirmation";
    }

    // Logged-in patient: list own appointments
    @GetMapping("/my/appointments")
    public String userAppointments(Authentication authentication, Model model) {
        String email = authentication.getName();
        List<Appointment> userAppointments = appointmentService.findByEmail(email);
        model.addAttribute("appointments", userAppointments);
        return "my_appointments";
    }

    // Logged-in patient: cancel own appointment
    @PostMapping("/my/appointments/cancel/{id}")
    public String cancelAppointment(@PathVariable Long id, Authentication authentication) {
        Appointment appointment = appointmentService.getById(id);
        if (appointment != null && authentication != null) {
            String email = authentication.getName();
            if (appointment.getEmail() != null && appointment.getEmail().equalsIgnoreCase(email)) {
                appointmentService.deleteById(id);
            }
        }
        return "redirect:/my/appointments?cancelled=true";
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
    public String showTeamPage() {
        return "team";
    }

    @GetMapping("/price")
    public String showPricingPage(Model model) {
        model.addAttribute("servicePrices", servicePriceService.findAll());
        return "price";
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
