package com.sangam.sangam.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.sangam.sangam.model.User;
import com.sangam.sangam.service.UserService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

/**
 * Controller responsible for handling donation-related routes
 */
@Controller
public class DonateController {

    @Autowired
    private UserService userService;

    /**
     * Displays the donation page with a "coming soon" message
     *
     * @param model    Spring MVC Model for view attributes
     * @param response HTTP response for cookie management
     * @param request  HTTP request to retrieve cookies for authentication
     * @return the donate template view name or redirect to signin if not authenticated
     */
    @GetMapping("/donate")
    public String donatePage(Model model, HttpServletResponse response, HttpServletRequest request) {
        String authToken = null;

        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(var cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        var user = new User();
        if(authToken != null) {
            if(userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }
        return "donate";
    }
}