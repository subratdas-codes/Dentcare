package com.subrat.clinic.controller;

import com.subrat.clinic.model.ContactMessage;
import com.subrat.clinic.service.ContactMessageService;
import com.subrat.clinic.service.MailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ContactController {

    @Autowired
    private MailService mailService;

    @Autowired
    private ContactMessageService contactMessageService;

    @PostMapping("/contact")
    public String submitContact(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String subject,
                                @RequestParam String message,
                                RedirectAttributes redirectAttributes) {
        String cleanName = name == null ? "" : name.trim();
        String cleanEmail = email == null ? "" : email.trim();
        String cleanSubject = subject == null ? "" : subject.trim();
        String cleanMessage = message == null ? "" : message.trim();
        if (cleanName.length() < 2 || cleanEmail.isEmpty() || !cleanEmail.contains("@")
                || cleanSubject.isEmpty() || cleanMessage.length() < 5) {
            redirectAttributes.addFlashAttribute("error",
                    "Please enter your name, a valid email, a subject and a message.");
            return "redirect:/contact";
        }

        ContactMessage stored = new ContactMessage();
        stored.setName(cleanName);
        stored.setEmail(cleanEmail);
        stored.setSubject(cleanSubject);
        stored.setMessage(cleanMessage);
        contactMessageService.save(stored);

        mailService.sendContactMessage(cleanName, cleanEmail, cleanSubject, cleanMessage);
        redirectAttributes.addFlashAttribute("success",
                "Thank you, " + cleanName + "! Your message has been sent. Our team will reply soon.");
        return "redirect:/contact";
    }
}
