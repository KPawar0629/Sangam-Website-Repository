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

@Controller
public class UserController {
    @Autowired
    private UserService service;

    @GetMapping("/user_list")
    public String getAllUsers(Model model, HttpServletRequest request) {
        List<User> users = service.findAllUsers();
        model.addAttribute("users", users);
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

    @GetMapping("/userName/{userName}")
    public List<User> findUserWithFullName(@PathVariable String userName) {
        return service.findUserByFullName(userName);
    }

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

    @DeleteMapping("/{userId}")
    public String deleteUser(@PathVariable String userId) {
        return service.deleteUser(userId);
    }

}
