package com.subrat.clinic.controller;

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

    @PostMapping("/contact")
    public String submitContact(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String subject,
                                @RequestParam String message,
                                RedirectAttributes redirectAttributes) {
        mailService.sendContactMessage(name, email, subject, message);
        redirectAttributes.addFlashAttribute("success",
                "Thank you, " + name + "! Your message has been sent.");
        return "redirect:/contact";
    }
}