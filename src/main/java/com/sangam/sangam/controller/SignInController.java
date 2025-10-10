package com.sangam.sangam.controller;

import com.sangam.sangam.model.*;
import com.sangam.sangam.service.DressCompetitionService;
import com.sangam.sangam.service.EventPricingService;
import com.sangam.sangam.service.EventService;
import com.sangam.sangam.service.ParticipationService;
import com.sangam.sangam.service.SendEmailService;
import com.sangam.sangam.service.TicketDetailsService;
import com.sangam.sangam.service.TicketMasterService;
import com.sangam.sangam.service.UserService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import java.io.File;
import java.lang.StackWalker.Option;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.*;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Controller responsible for user authentication, dashboard, and various operational views
 * including check-in, payments, event statistics, and participant management.
 * 
 * Note: This controller handles more functionality than its name suggests and should be
 * refactored to separate concerns into DashboardController, CheckInController, etc.
 */
@Controller
public class SignInController {

    private static final Logger logger = LoggerFactory.getLogger(SignInController.class);

    @Autowired
    private UserService userService;
    @Autowired
    private EventService eventService;
    @Autowired
    private TicketDetailsService ticketDetailsService;
    @Autowired
    private TicketMasterService ticketMasterService;
    @Autowired
    private EventPricingService eventPricingService;
    @Autowired
    private SendEmailService emailService;
    @Autowired
    private ParticipationService participationService;
    @Autowired
    private DressCompetitionService dressCompetitionService;

    /**
     * Root URL handler - redirects to the dashboard
     * 
     * @return redirect view to dashboard
     */
    @GetMapping("/")
    public RedirectView redirectToTarget() {
        return new RedirectView("/dashboard");
    }

    /**
     * Displays the sign-in page
     * 
     * @return the signin view
     */
    @GetMapping("/signin")
    public String showSignInPage() {
        return "signin";
    }

    /**
     * Handles user sign-in form submission
     * Validates credentials and sets auth token via cookies
     * 
     * @param email User's email address
     * @param password User's password (note: stored in plaintext, security issue)
     * @param session HTTP session for storing user data
     * @param redirectAttributes Redirect attributes for messages
     * @param model Spring MVC Model for view attributes
     * @param response HTTP response for setting cookies
     * @return redirect to dashboard on success or signin view with error on failure
     */
    @PostMapping("/signin")
    public String handleSignIn(
            @RequestParam String email,
            @RequestParam String password,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            Model model,
            HttpServletResponse response
    ) {
        Optional<User> user = userService.findUserByEmail(email);

        if(user.isPresent() && user.get().getPassword().equals(password)) {
            // Generate and set authentication token
            String authToken = UUID.randomUUID().toString();
            Cookie authCookie = new Cookie("authToken", authToken);
            userService.setToken(user.get(), authToken);
            authCookie.setHttpOnly(true);
            authCookie.setSecure(false); // Note: Should be true in production with HTTPS
            response.addCookie(authCookie);
            
            // Set success message cookie
            try {
                String encodedMessage = URLEncoder.encode("Login Successful!", "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false); // Note: Should be true in production with HTTPS
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }

            return "redirect:/dashboard";
        } else {
            model.addAttribute("message", "Invalid email or password");
            return "signin";
        }
    }

    /**
     * Displays the main dashboard with published events
     * Handles authentication via cookies
     * Updates event participation status
     * Processes flash messages
     * 
     * @param session HTTP session
     * @param model Spring MVC Model for view attributes
     * @param request HTTP request to retrieve cookies
     * @param response HTTP response for clearing message cookies
     * @return the dashboard view
     */
    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model, HttpServletRequest request, HttpServletResponse response) {
        // Load all event pricing options
        List<EventPricing> pricings = eventPricingService.findAllEventPricing();
        model.addAttribute("pricings", pricings);

        // Load and filter events - only show published ones
        List<Event> events = eventService.findAllEvents();
        for (int i = 0; i < events.size(); i++) {
            if (events.get(i).getPublished() == 0) {
                events.remove(i);
                i = i - 1;
            } else {
                if(events.get(i).getParticipationAllowed() == 1) {
                    eventService.updatePartiStatusChecker(events.get(i));
                }
            }
        }
        
        // Update pricing status for each event
        for (Event event: events) {
            List<EventPricing> eventPricings = eventPricingService.findEventPricingsByEventId(event.getEventId());
            for (EventPricing pricing : eventPricings) {
                eventPricingService.resetStatus(pricing);
            }
        }

        // Extract authentication and message from cookies
        String authToken = null;
        String message = null;

        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(var cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    logger.info("found cookie for " + cookie.getValue());
                    authToken = cookie.getValue();
                }
                if(cookie.getName().equals("message")) {
                    try {
                        String decodedMessage = URLDecoder.decode(cookie.getValue(), "UTF-8");
                        message = decodedMessage;
                        // Clear the message cookie after reading
                        Cookie msgCookie = new Cookie("message", null);
                        msgCookie.setMaxAge(0);
                        response.addCookie(msgCookie);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        // Add user to model if authenticated
        if(authToken != null) {
            if(userService.validateToken(authToken)) {
                var user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            }
        }
        
        // Add flash message if present
        if(message != null) {
            model.addAttribute("message", message);
        }

        model.addAttribute("events", events);
        model.addAttribute("showing", compStatus()); // Competition status flag
        return "dashboard";
    }

    public boolean compStatus() {
        String startDateTime = "2024-10-19T17:00";
        String endDateTime = "2024-10-20T17:00";

        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        LocalDateTime startDateTimeFormatted = LocalDateTime.parse(startDateTime, formatter);
        LocalDateTime endDateTimeFormatted = LocalDateTime.parse(endDateTime, formatter);
        LocalDateTime now = LocalDateTime.now();

        if (now.isBefore(startDateTimeFormatted)) {
            return false;
        } else if (now.isBefore(endDateTimeFormatted)) {
            return true;
        } else {
            return false;
        }
    }

    @GetMapping("/actions_ticket")
    public String showCheckInOrPayment(HttpSession session, Model model) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        model.addAttribute("loggedInUser", loggedInUser);
        session.setAttribute("loggedInUser", loggedInUser);
        return "checkin_list";



//        if(loggedInUser != null) {
//            model.addAttribute("userEmail", loggedInUser.getEmail());
//            model.addAttribute("userName", loggedInUser.getFullName());
//            return "dashboard";
//        }
    }

    @GetMapping("/checkin")
    public String showCheckIn(@RequestParam(value = "eventId", required = false) String eventId, HttpSession session, Model model, HttpServletRequest request) {
        // Authentication using cookies (same pattern as other methods)
        String authToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (var cookie : cookies) {
                if (cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        var user = new User();
        if (authToken != null) {
            if (userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        // Load ticket details for check-in (filtered by event if specified)
        List<TicketDetails> details;
        if (eventId != null && !eventId.isEmpty()) {
            details = ticketDetailsService.findByEventId(eventId);
        } else {
            details = ticketDetailsService.findAllTicketDetails();
        }
        model.addAttribute("details", details);
        model.addAttribute("selectedEventId", eventId);

        // Load all events for the dropdown filter
        List<Event> events = eventService.findAllEvents();
        Map<String, Event> eventsMap = new HashMap<>();
        for (Event event : events) {
            eventsMap.put(event.getEventId(), event);
        }
        model.addAttribute("events", events);
        model.addAttribute("eventsMap", eventsMap);

        // Load users map for displaying who checked in each ticket
        Map<String, User> users = new HashMap<>();
        for (TicketDetails detail : details) {
            if (detail.getCheckedInBy() != null) {
                Optional<User> checkedInByUser = userService.getUserByUserId(detail.getCheckedInBy());
                checkedInByUser.ifPresent(u -> users.put(detail.getCheckedInBy(), u));
            }
        }
        model.addAttribute("users", users);

        return "checkin_list";
    }

    @GetMapping("/about_us")
    public String showAboutUsPage(HttpSession session, Model model, HttpServletRequest request) {
        String authToken = null;

        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(var cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    logger.info("found cookie for " + cookie.getValue());
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

        return "/aboutus";
    }

    @GetMapping("/signout")
    public String handleSignOut(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    Cookie authCookie = new Cookie("authToken", null);
                    authCookie.setMaxAge(0);
                    response.addCookie(authCookie);
                }
            }
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/actions_tickets/checkIn")
    public String handleCheckIn(
            @RequestParam int checkInCode,
            Model model,
            HttpSession session
    ) {
        User loggedInUser = (User) model.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
            if (loggedInUser == null) {
                return "redirect:/dashboard";
            }
        }
        Optional<TicketDetails> details = Optional.ofNullable(ticketDetailsService.findByUniqueId(checkInCode));
        if (details.isPresent() && details.get().getCheckedIn() != 1) {
            TicketDetails ticketDetails = details.get();
            ticketDetails.setCheckedIn(1);
            ticketDetails.setCheckedInBy(loggedInUser.getUserId());
            ticketDetails.setCheckedInAt(new Date().toString());
            ticketDetailsService.addOrUpdateTicketDetails(ticketDetails);
            return "redirect:/actions_ticket";
        } else {
            return "redirect:/dashboard";
        }
    }

//    @PostMapping("/actions_ticket/payment")
//    public String handlePayment(
//            @RequestParam String firstName,
//            Model model,
//            HttpSession session
//    ) {
//        User loggedInUser = (User) model.getAttribute("loggedInUser");
//        if (loggedInUser == null) {
//            loggedInUser = (User) session.getAttribute("loggedInUser");
//            if (loggedInUser == null) {
//                return "redirect:/dashboard";
//            }
//        }
//
//        List<TicketMaster> ticketers = ticketMasterService.findTicketMasterByFirstName(firstName);
//        model.addAttribute("firstName", firstName);
//        model.addAttribute("ticketers", ticketers);
//        model.addAttribute("loggedInUser", loggedInUser);
//        return "/payment_list";
//    }

    @GetMapping("/actions_ticket/payments/{masterId}")
    public String showPaymentReciept(@PathVariable String masterId, Model model, HttpSession session) {
        TicketMaster master = ticketMasterService.findTicketMasterById(masterId);
        model.addAttribute("master", master);
        List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(master.getTicketMasterId());
        model.addAttribute("details", details);

        if(session.getAttribute("loggedInUser") != null) {
            return "/payment_detail";
        } else {
            return "redirect:/signin";
        }
    }


    // Payments

    @GetMapping("/payment_list")
    public String getAllTicket(@RequestParam(value = "eventId", required = false) String eventId, Model model, HttpServletRequest request) {
        List<TicketMaster> masters;
        if (eventId != null && !eventId.isEmpty()) {
            masters = ticketMasterService.findTicketMasterByEventId(eventId);
        } else {
            masters = ticketMasterService.findAllTicketMasters();
        }

        Map<String, User> users = new HashMap<>();
        model.addAttribute("ticketers", masters);
        for (TicketMaster master : masters) {
            if (master.getPaymentReceived() == 1) {
                Optional<User> user = userService.getUserByUserId(master.getPaymentReceivedBy());
                user.ifPresent(u -> users.put(master.getPaymentReceivedBy(), u));
            }
        }

        String authToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (var cookie : cookies) {
                if (cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        var user = new User();
        if (authToken != null) {
            if (userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        model.addAttribute("users", users);
        return "/payment_list";
    }

    // Payments

    @GetMapping("/payment_list/{eventId}")
    public String getAllTicketByEvent(@PathVariable String eventId) {
        // redirect with simple param instead of serializing large objects to flash attributes
        try {
            return "redirect:/payment_list?eventId=" + URLEncoder.encode(eventId, "UTF-8");
        } catch (Exception e) {
            return "redirect:/payment_list";
        }
    }

    /*
     * REMOVE THE ENTIRE METHOD BELOW.
     * This method conflicts with the receivePayment method in TicketMasterController.
     * The logic has been consolidated there.
     */
    // @GetMapping("/payment/{masterId}")
    // public String confirmPayment(@PathVariable("masterId") String masterId, Model model, HttpServletRequest request) {
    //     TicketMaster master = ticketMasterService.findTicketMasterById(masterId);
    //     master.setPaymentReceived(1);
    //     HttpSession session = request.getSession();
    //     String userId = (String) session.getAttribute("userId");
    //     master.setPaymentReceivedBy(userId);
    //     DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
    //     master.setPaymentReceivedAt(dtf.format(LocalDateTime.now()));
    //     ticketMasterService.addOrUpdateTicketMaster(master);
    //     return "redirect:/payment_list";
    // }

    @PostMapping("/confirmCheckIn")
    public String confirmCheckIn(
            @RequestParam("ticketIds") String[] ticketIds, 
            @RequestParam(value = "eventId", required = false) String eventId,
            HttpServletRequest request) {
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
                request.getSession().setAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        // Process each selected ticket for check-in
        for (String ticketId : ticketIds) {
            Optional<TicketDetails> details = ticketDetailsService.findTicketDetailsByDetailsId(ticketId);

            if (details.isPresent()) {
                TicketDetails ticketDetails = details.get();
                ticketDetails.setCheckedIn(1);
                ticketDetails.setCheckedInBy(user.getUserId());
                ticketDetails.setCheckedInAt(new Date().toString());
                ticketDetailsService.addOrUpdateTicketDetails(ticketDetails);
            }
        }

        // Redirect back to the check-in page, preserving the event filter if specified
        return eventId != null && !eventId.isEmpty() 
            ? "redirect:/checkin?eventId=" + eventId
            : "redirect:/checkin";
    }

    @GetMapping("/event/stats/{eventId}")
    public String getEventStats(@PathVariable String eventId, Model model, HttpServletRequest request) {
        String authToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (var cookie : cookies) {
                if (cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        var user = new User();
        if (authToken != null) {
            if (userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        Event event = eventService.findEventById(eventId);
        if (event == null) {
            return "redirect:/event_list";
        }

        if (event.getEventType().equals("free") && event.getRsvpYes() != null && event.getRsvpYes().equals("yes")) {
            List<TicketMaster> rsvps = ticketMasterService.findTicketMasterByEventId(eventId);
            int totalRsvp = 0;
            int checkedIn = 0;
            Map<String, Integer> rsvpMap = new HashMap<>();

            for (TicketMaster rsvp : rsvps) {
                if (rsvp.isRsvp()) {
                    totalRsvp += rsvp.getRsvpCount();
                    String key = rsvp.getFullName() + " (" + rsvp.getEmail() + ")";
                    rsvpMap.put(key, rsvp.getRsvpCount());
                    // Count checked in from ticket details
                    List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(rsvp.getTicketMasterId());
                    for (TicketDetails detail : details) {
                        if (detail.getCheckedIn() == 1) {
                            checkedIn++;
                        }
                    }
                }
            }

            model.addAttribute("isRsvpEvent", true);
            model.addAttribute("totalRsvp", totalRsvp);
            model.addAttribute("totalCheckedIn", checkedIn);
            model.addAttribute("rsvpMap", rsvpMap);
            model.addAttribute("event", event);
            return "event_stats";
        }

        // For paid events
        List<TicketDetails> details = ticketDetailsService.findByEventId(eventId);
        model.addAttribute("event", event);
        model.addAttribute("isRsvpEvent", false);
        model.addAttribute("totalTickets", details.size());
        double amount = 0;
        double paid = 0;
        int checkedIn = 0;
        Map<String, Integer> pricingCounts = new HashMap<>();
        Map<String, Double> paymentsReceivedCounts = new HashMap<>();
        Map<String, Double> pricingMoney = new HashMap<>();
        Map<String, Integer> checkInCount = new HashMap<>();
        
        for (TicketDetails detail : details) {
            amount += detail.getAmount();
            if (detail.getPaidStatus() == 1) {
                paid += detail.getAmount();
            }
            if (detail.getCheckedIn() == 1) {
                checkedIn++;
            }
            String pricingOption = detail.getPricingOptionName();
            pricingCounts.put(pricingOption, pricingCounts.getOrDefault(pricingOption, 0) + 1);
            paymentsReceivedCounts.put(pricingOption, paymentsReceivedCounts.getOrDefault(pricingOption, 0.0) + detail.getAmount());
            pricingMoney.put(pricingOption, pricingMoney.getOrDefault(pricingOption, 0.0) + detail.getAmount());
            checkInCount.put(pricingOption, checkInCount.getOrDefault(pricingOption, 0) + (detail.getCheckedIn() == 1 ? 1 : 0));
        }

        model.addAttribute("totalAmount", amount);
        model.addAttribute("totalPaid", paid);
        model.addAttribute("totalCheckedIn", checkedIn);
        model.addAttribute("pricingCounts", pricingCounts);
        model.addAttribute("receiveTotal", paymentsReceivedCounts);
        model.addAttribute("totalAmountTypes", pricingMoney);
        model.addAttribute("checkInTypes", checkInCount);
        return "event_stats";
    }
    @GetMapping("/participant_list")
    public String getAllParticipants(@RequestParam(value = "eventId", required = false) String eventId, Model model, HttpServletRequest request) {
        List<Participation> participants = participationService.getAllParticipation();

        if (eventId != null && !eventId.isEmpty()) {
            List<Participation> filtered = new ArrayList<>();
            for (Participation p : participants) {
                if (eventId.equals(p.getEventId())) {
                    filtered.add(p);
                }
            }
            participants = filtered;
        }

        model.addAttribute("participants", participants);
        model.addAttribute("selectedEventId", eventId);

        String authToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (var cookie : cookies) {
                if (cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
            }
        }
        var user = new User();
        if (authToken != null) {
            if (userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        return "/participant_list";
    }

    @GetMapping("/participation/delete/{participationId}")
    public String deleteParticipation(@PathVariable String participationId) {
        var parti = participationService.getParticipationById(participationId);
        String eventId = "";
        if(parti.isPresent() & !parti.isEmpty()) {
            eventId = parti.get().getEventId();
            participationService.deleteParticipation(participationId);
        }
        
        if (eventId != null && !eventId.isEmpty()) {
            try {
                return "redirect:/participant_list?eventId=" + URLEncoder.encode(eventId, "UTF-8");
            } catch (java.io.UnsupportedEncodingException e) {
                return "redirect:/participant_list";
            }
        }
        return "redirect:/participant_list";
    }

}
