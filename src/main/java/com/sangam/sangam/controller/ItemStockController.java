package com.sangam.sangam.controller;

import com.sangam.sangam.model.ItemStock;
import com.sangam.sangam.model.User;
import com.sangam.sangam.service.ItemStockService;
import com.sangam.sangam.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Optional;

@Controller
public class ItemStockController {

    @Autowired
    private ItemStockService itemStockService;

    @Autowired
    private UserService userService;

    // Helper method to authenticate user
    private User authenticateUser(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("authToken")) {
                    String authToken = cookie.getValue();
                    if (userService.validateToken(authToken)) {
                        Optional<User> loggedInUser = userService.getUserByToken(authToken);
                        if (loggedInUser.isPresent()) {
                            return loggedInUser.get();
                        }
                    }
                }
            }
        }
        return null;
    }

    @GetMapping("/itemstock")
    public String itemStockList(Model model, HttpServletRequest request, 
                                @RequestParam(required = false) String search) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Check if user is admin
        if (!loggedInUser.getRole().equals("admin") && !loggedInUser.getRole().equals("staff")) {
            return "redirect:/dashboard";
        }
        
        List<ItemStock> itemStockList;
        if (search != null && !search.isEmpty()) {
            itemStockList = itemStockService.searchItemStockByName(search);
        } else {
            itemStockList = itemStockService.getAllItemStock();
        }
        
        // Create a map of handler IDs to Users
        java.util.Map<String, User> handlerMap = new java.util.HashMap<>();
        for (ItemStock item : itemStockList) {
            if (item.getHandlerId() != null && !item.getHandlerId().isEmpty()) {
                userService.getUserByUserId(item.getHandlerId())
                    .ifPresent(user -> handlerMap.put(item.getHandlerId(), user));
            }
        }
        
        model.addAttribute("itemStockList", itemStockList);
        model.addAttribute("loggedInUser", loggedInUser);
        model.addAttribute("handlers", handlerMap);
        return "itemstock_list";
    }

    @GetMapping("/itemstock/add")
    public String showAddItemForm(Model model, HttpServletRequest request) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Check if user is admin
        if (!loggedInUser.getRole().equals("admin") && !loggedInUser.getRole().equals("staff")) {
            return "redirect:/dashboard";
        }
        
        // Get all admin users for the dropdown
        List<User> adminUsers = userService.getUsersByRole("admin");
        
        model.addAttribute("itemStock", new ItemStock());
        model.addAttribute("loggedInUser", loggedInUser);
        model.addAttribute("adminUsers", adminUsers);
        model.addAttribute("isEdit", false);
        return "itemstock_form";
    }

    @PostMapping("/itemstock/save")
    public String saveItemStock(@ModelAttribute ItemStock itemStock, 
                               HttpServletRequest request,
                               @RequestParam(required = false) Boolean isEdit) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Check if user is admin
        if (!loggedInUser.getRole().equals("admin") && !loggedInUser.getRole().equals("staff")) {
            return "redirect:/dashboard";
        }
        
        // Set handler ID if not provided
        if (itemStock.getHandlerId() == null || itemStock.getHandlerId().isEmpty()) {
            itemStock.setHandlerId(loggedInUser.getUserId());
        }
        
        // Save or update item stock
        if (isEdit != null && isEdit) {
            itemStockService.updateItemStock(itemStock.getStockId(), itemStock);
        } else {
            itemStockService.saveItemStock(itemStock);
        }
        
        return "redirect:/itemstock";
    }

    @GetMapping("/itemstock/edit/{stockId}")
    public String showEditItemForm(@PathVariable String stockId, 
                                 Model model, 
                                 HttpServletRequest request) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Check if user is admin
        if (!loggedInUser.getRole().equals("admin") && !loggedInUser.getRole().equals("staff")) {
            return "redirect:/dashboard";
        }
        
        Optional<ItemStock> itemStockOptional = itemStockService.getItemStockById(stockId);
        if (!itemStockOptional.isPresent()) {
            return "redirect:/itemstock";
        }
        
        // Get all admin users for the dropdown
        List<User> adminUsers = userService.getUsersByRole("admin");
        
        model.addAttribute("itemStock", itemStockOptional.get());
        model.addAttribute("loggedInUser", loggedInUser);
        model.addAttribute("adminUsers", adminUsers);
        model.addAttribute("isEdit", true);
        return "itemstock_form";
    }

    @GetMapping("/itemstock/delete/{stockId}")
    public String deleteItemStock(@PathVariable String stockId, HttpServletRequest request) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Only admin can delete
        if (!loggedInUser.getRole().equals("admin")) {
            return "redirect:/itemstock";
        }
        
        itemStockService.deleteItemStock(stockId);
        return "redirect:/itemstock";
    }

    @GetMapping("/itemstock/toggle/{stockId}")
    public String toggleItemStatus(@PathVariable String stockId, HttpServletRequest request) {
        User loggedInUser = authenticateUser(request);
        if (loggedInUser == null) {
            return "redirect:/signin";
        }
        
        // Check if user is admin or staff
        if (!loggedInUser.getRole().equals("admin") && !loggedInUser.getRole().equals("staff")) {
            return "redirect:/dashboard";
        }
        
        Optional<ItemStock> itemStockOptional = itemStockService.getItemStockById(stockId);
        if (itemStockOptional.isPresent()) {
            ItemStock itemStock = itemStockOptional.get();
            itemStock.setActive(!itemStock.isActive()); // Toggle active status
            itemStockService.saveItemStock(itemStock);
        }
        
        return "redirect:/itemstock";
    }
}