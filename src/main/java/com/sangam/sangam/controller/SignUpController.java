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

/**
 * Controller responsible for handling user registration
 * Includes security code validation and role assignment
 */
@Controller
public class SignUpController {

    @Autowired
    private UserService userService;
    @Autowired
    private SendEmailService emailService;

    /**
     * Displays the registration page
     * 
     * @param model Spring MVC Model for view attributes
     * @return the signup view
     */
    @GetMapping("/signup")
    public String showSignUpPage(Model model) {
        return "signup";
    }

    /**
     * Processes user registration form submission
     * Validates email uniqueness and security code
     * Assigns role based on security code (admin or staff)
     * Sends welcome email to new users
     * 
     * @param name User's full name
     * @param email User's email address
     * @param password User's password (note: stored in plaintext, security issue)
     * @param phone User's phone number
     * @param code Security code to validate registration and assign role
     * @param model Spring MVC Model for view attributes
     * @param redirectAttributes Redirect attributes for flash messages
     * @return redirect to signin on success, or signup view with errors
     */
    @PostMapping("/signup")
    public String handleSignUp(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam String phone,
            @RequestParam String code,
            Model model,
            RedirectAttributes redirectAttributes) {
        // Check if email is already registered
        Optional<User> existingUser = userService.findUserByEmail(email);
        if (existingUser.isPresent()) {
            model.addAttribute("error", "Email already exists");
            return "signup";
        }

        // Validate security code
        if(!("SAN2024DIW".equals(code) || "SANGAMWEB".equals(code))) {
            // Preserve form inputs for better user experience
            model.addAttribute("name", name);
            model.addAttribute("email", email);
            model.addAttribute("password", password);
            model.addAttribute("phone", phone);
            model.addAttribute("error", "Invalid security code.");
            return "/signup";
        }

        // Create new user
        User newUser = new User();
        newUser.setUserId(UUID.randomUUID().toString().split("-")[0]);
        newUser.setFullName(name);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setPhone(phone);
        newUser.setAccount_created(new Date().toString());
        
        // Assign role based on security code
        if("SAN2024DIW".equals(code)) {
            newUser.setRole("admin");
        } else {
            newUser.setRole("staff");
        }

        // Save user and send welcome email
        userService.addUser(newUser);
        model.addAttribute("user", newUser);
        emailService.sendUserCreateEmail(model);

        redirectAttributes.addFlashAttribute("message", "User Signup completed! Thanks for registering with Sangam.");

        return "redirect:/signin";
    }

    /**
     * Generates a random 6-digit code
     * Note: This method appears to be unused in the current implementation
     * 
     * @return a random integer between 100000 and 999999
     */
    public int newCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return code;
    }
}
