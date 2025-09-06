package com.sangam.sangam.controller;

import com.sangam.sangam.model.User;
import org.springframework.ui.Model;

import com.sangam.sangam.service.SendEmailService;
import com.sangam.sangam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
public class SignUpController {

    @Autowired
    private UserService userService;
    @Autowired
    private SendEmailService emailService;

    @GetMapping("/signup")
    public String showSignUpPage(Model model) {
        return "signup";
    }

    @PostMapping("/signup")
    public String handleSignUp(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            @RequestParam String code,
            Model model,
            RedirectAttributes redirectAttributes) {
        Optional<User> existingUser = userService.findUserByEmail(email);

        if (existingUser.isPresent()) {
            model.addAttribute("error", "Email already exists");
            return "signup";
        }

        if(!("SAN2024DIW".equals(code) || "SANGAMWEB".equals(code))) {
            model.addAttribute("name", name);
            model.addAttribute("email", email);
            model.addAttribute("password", password);
            model.addAttribute("phone", phone);
            model.addAttribute("error", "Invalid security code.");
            return "/signup";
        }

        User newUser = new User();
        newUser.setUserId(UUID.randomUUID().toString().split("-")[0]);
        newUser.setFullName(name);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setPhone(phone);
        newUser.setAccount_created(new Date().toString());
        if("SAN2024DIW".equals(code)) {
            newUser.setRole("admin");
        } else {
            newUser.setRole("staff");
        }

        userService.addUser(newUser);
        model.addAttribute("user", newUser);
        emailService.sendUserCreateEmail(model);

        redirectAttributes.addFlashAttribute("message", "User Signup completed! Thanks for registering with Sangam.");

        return "redirect:/signin";
    }

    public int newCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return code;
    }
}
