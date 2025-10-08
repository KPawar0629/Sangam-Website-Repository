package com.sangam.sangam.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Cookie;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sangam.sangam.service.UserService;

/**
 * Controller responsible for handling application errors and displaying a custom error page.
 * Implements Spring Boot's ErrorController to provide a consistent error handling experience.
 */
@Controller
public class CustomErrorController implements ErrorController {
    
    @Autowired
    private UserService userService;
    
    /**
     * Handles all error requests and returns the custom error page.
     * Preserves user authentication status and adds error details to the model.
     * 
     * @param request HTTP request containing error attributes
     * @param model Spring MVC Model for view attributes
     * @return the custom error view template
     */
    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        // Get error status code
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        Object message = request.getAttribute(RequestDispatcher.ERROR_MESSAGE);
        Object exception = request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        
        // Add error information to the model
        if (status != null) {
            model.addAttribute("status", status);
        }
        
        if (message != null) {
            model.addAttribute("message", message);
        }
        
        if (exception != null) {
            model.addAttribute("error", "An unexpected error occurred: " + exception);
        }
        
        // Maintain authentication status
        String authToken = null;
        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(var cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        
        if(authToken != null) {
            if(userService.validateToken(authToken)) {
                var user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            }
        }
        
        return "error";
    }
}