package com.sangam.sangam.controller;

import com.sangam.sangam.model.User;
import com.sangam.sangam.service.UserService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

/**
 * Controller responsible for user management operations including listing,
 * modifying, retrieving, and deleting users.
 */
@Controller
public class UserController {
    @Autowired
    private UserService service;

    /**
     * Displays a list of all users in the system
     * Requires user authentication
     * 
     * @param model Spring MVC Model for view attributes
     * @param request HTTP request to retrieve cookies for authentication
     * @return the user list view or redirect to signin if not authenticated
     */
    @GetMapping("/user_list")
    public String getAllUsers(Model model, HttpServletRequest request) {
        // Get all users and add to model
        List<User> users = service.findAllUsers();
        model.addAttribute("users", users);
        
        // Authentication check
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
            if(service.validateToken(authToken)) {
                user = service.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";   
            }
        } else {
            return "redirect:/signin";
        }
        
        return "/user_list";
    }

    /**
     * Retrieves a user by ID
     * Note: This returns a raw User object, not a view - used for API/AJAX calls
     * 
     * @param userId ID of the user to retrieve
     * @return User object if found, or a new empty User object if not found
     */
    @GetMapping("/{userId}")
    public User getUser(@PathVariable String userId) {
        Optional<User> optionalUser = service.findUserById(userId);
        if(optionalUser.isPresent())
        {
            return optionalUser.get();
        } else {
            return new User();
        }
    }

    /**
     * Finds users by full name
     * Note: This returns raw User objects, not a view - used for API/AJAX calls
     * 
     * @param userName Full name to search for
     * @return List of matching User objects
     */
    @GetMapping("/userName/{userName}")
    public List<User> findUserWithFullName(@PathVariable String userName) {
        return service.findUserByFullName(userName);
    }

    /**
     * Modifies an existing user's information
     * 
     * @param userId ID of the user to update
     * @param fullName Updated full name
     * @param email Updated email address
     * @param password Updated password (note: stored in plaintext, security issue)
     * @param phone Updated phone number
     * @return redirect to the user list view
     */
    @PostMapping("/user/modify")
    public String modifyUser(
        @RequestParam String userId,
        @RequestParam String fullName,
        @RequestParam String email,
        @RequestParam String password,
        @RequestParam String phone
    ) {
        var thisUser = service.findUserById(userId);
        if(thisUser.isPresent()) {
            var updatingUser = thisUser.get();
            updatingUser.setFullName(fullName);
            updatingUser.setEmail(email);
            updatingUser.setPhone(phone);
            updatingUser.setPassword(password);
            service.updateUser(updatingUser);
            return "redirect:/user_list";
        }
        return "/user_list";
    }

    /**
     * Deletes a user by ID
     * 
     * @param userId ID of the user to delete
     * @return Result message from the service
     */
    @DeleteMapping("/{userId}")
    public String deleteUser(@PathVariable String userId) {
        return service.deleteUser(userId);
    }

}
