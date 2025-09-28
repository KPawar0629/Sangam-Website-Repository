package com.sangam.sangam.controller;

import com.sangam.sangam.model.Event;
import com.sangam.sangam.model.EventPricing;
import com.sangam.sangam.model.TicketDetails;
import com.sangam.sangam.model.TicketMaster;
import com.sangam.sangam.model.User;
import com.sangam.sangam.service.EventPricingService;
import com.sangam.sangam.service.EventService;
import com.sangam.sangam.service.SendEmailService;
import com.sangam.sangam.service.TicketDetailsService;
import com.sangam.sangam.service.TicketMasterService;
import com.sangam.sangam.service.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Controller
public class TicketMasterController {

    @Autowired
    private TicketMasterService ticketMasterService;
    @Autowired
    private EventService eventService;
    @Autowired
    private EventPricingService eventPricingService;
    @Autowired
    private TicketDetailsService ticketDetailsService;
    @Autowired
    private SendEmailService emailService;
    @Autowired
    private UserService userService;

    @GetMapping("/tickets/new/{eventId}")
    public String showTicketForm(Model model, HttpSession session, @PathVariable String eventId) {
        Event event = eventService.findEventById(eventId);
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        model.addAttribute("loggedInUser", loggedInUser);

        List<EventPricing> eventPricings = eventPricingService.findEventPricingsByEventId(eventId);

        model.addAttribute("eventPricings", eventPricings);
        model.addAttribute("event", event);

        return "/ticket";
    }

    @PostMapping("/add_ticket")
    public String handleTicketSubmission(
            @RequestParam String eventInput,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam Map<String, String> params,
            @RequestParam String checkHidden,
            HttpServletResponse response,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        if(checkHidden.equals("")) {
            TicketMaster ticketMaster = new TicketMaster();
            Event event = eventService.findEventById(eventInput);
            ticketMaster.setTicketMasterId(UUID.randomUUID().toString().split("-")[0]);
            ticketMaster.setFullName(fullName);
            ticketMaster.setEmail(email);
            ticketMaster.setEventId(eventInput);
            ticketMaster.setDateBought(new Date().toString());
            ticketMaster.setPhoneNumber(phone);
            ticketMaster.setPaymentReceived(0);
            ticketMaster.setPaymentReceivedAt("null");
            ticketMaster.setPaymentReceivedBy("null");

            // Handle RSVP for free events
            if (event.getEventType().equals("free") && event.getRsvpYes() != null && event.getRsvpYes().equals("yes")) {
                String rsvpCountStr = params.get("rsvpCount");
                if (rsvpCountStr != null && !rsvpCountStr.isEmpty()) {
                    int rsvpCount = Integer.parseInt(rsvpCountStr);
                    if (rsvpCount > 6) {
                        try {
                            String encodedMessage = URLEncoder.encode("Maximum 6 people allowed per RSVP", "UTF-8");
                            Cookie msgCookie = new Cookie("message", encodedMessage);
                            msgCookie.setHttpOnly(true);
                            msgCookie.setSecure(false);
                            response.addCookie(msgCookie);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        return "redirect:/dashboard";
                    }
                    ticketMaster.setRsvp(true);
                    ticketMaster.setRsvpCount(rsvpCount);
                    ticketMaster.setTotalTickets(rsvpCount);
                    ticketMaster.setTotalAmount(0.0);
                    ticketMasterService.addTicketMaster(ticketMaster);

                    Map<String, Object> emailModel = new HashMap<>();
                    emailModel.put("event", event);
                    emailModel.put("rsvp", ticketMaster);
                    emailService.sendRsvpEmail(ticketMaster.getEmail(), emailModel);

                    // Create a single ticket detail for RSVP
                    TicketDetails ticketDetails = new TicketDetails();
                    ticketDetails.setFullName(ticketMaster.getFullName());
                    ticketDetails.setTicketId(ticketMaster.getTicketMasterId());
                    ticketDetails.setDetailId(UUID.randomUUID().toString().split("-")[0]);
                    ticketDetails.setPricingOptionId("rsvp");
                    ticketDetails.setPricingOptionName("RSVP");
                    ticketDetails.setAmount(0.0);
                    ticketDetails.setCheckedIn(0);
                    ticketDetails.setCheckedInAt("null");
                    ticketDetails.setCheckedInBy("null");
                    ticketDetails.setUniqueCode(String.valueOf(getRandomCode()));
                    ticketDetails.setTicketBought(ticketMaster.getDateBought());
                    ticketDetails.setPaidStatus(1); // RSVP is always marked as paid since it's free
                    ticketDetails.setEventId(ticketMaster.getEventId());
                    ticketDetailsService.addTicketDetails(ticketDetails);

                    try {
                        String encodedMessage = URLEncoder.encode("RSVP confirmed successfully!", "UTF-8");
                        Cookie msgCookie = new Cookie("message", encodedMessage);
                        msgCookie.setHttpOnly(true);
                        msgCookie.setSecure(false);
                        response.addCookie(msgCookie);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    return "redirect:/dashboard";
                }
            }

            // Handle paid tickets
            ticketMasterService.addTicketMaster(ticketMaster);
            double price = 0;
            int tickets = 0;

            for(Map.Entry<String, String> entry : params.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();


                if(key.startsWith("pricing_")) {
                    String pricingId = key.substring("pricing_".length());
                    int numberOfTickets = 0;
                    if(!Objects.equals(value, ""))
                    {
                        numberOfTickets = Integer.parseInt(value);
                    }
                        if(numberOfTickets <= 6) {
                            for (int i = 0; i < numberOfTickets; i++) {
                            TicketDetails ticketDetails = new TicketDetails();
                            ticketDetails.setFullName(ticketMaster.getFullName());
                            ticketDetails.setTicketId(ticketMaster.getTicketMasterId());
                            ticketDetails.setDetailId(UUID.randomUUID().toString().split("-")[0]);
                            ticketDetails.setPricingOptionId(pricingId);
                            EventPricing pricing = eventPricingService.findEventPricingById(pricingId);
                            ticketDetails.setPricingOptionName(pricing.getPricingName());
                            ticketDetails.setAmount(pricing.getPricingRate());
                            ticketDetails.setCheckedIn(0);
                            ticketDetails.setCheckedInAt("null");
                            ticketDetails.setCheckedInBy("null");
                            ticketDetails.setUniqueCode(String.valueOf(getRandomCode()));
                            ticketDetails.setTicketBought(ticketMaster.getDateBought());
                            ticketDetails.setPaidStatus(0);
                            ticketDetails.setEventId(ticketMaster.getEventId());
                            price += eventPricingService.findEventPricingById(ticketDetails.getPricingOptionId()).getPricingRate();
                            tickets += 1;
                            ticketDetailsService.addTicketDetails(ticketDetails);
                        }} else {
                            try {
                                String encodedMessage = URLEncoder.encode("Max Tickets Can Only Be 6", "UTF-8");
                                Cookie msgCookie = new Cookie("message", encodedMessage);
                                msgCookie.setHttpOnly(true);
                                msgCookie.setSecure(false);
                                response.addCookie(msgCookie);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            ticketMasterService.deleteTicketMaster(ticketMaster.getTicketMasterId());
                            return "redirect:/dashboard";
                        }
                }
            }

            ticketMaster.setTotalAmount(price);
            ticketMaster.setTotalTickets(tickets);
            List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(ticketMaster.getTicketMasterId());

            ticketMasterService.updateTicketMaster(ticketMaster);
            model.addAttribute("ticket", ticketMaster);
            model.addAttribute("event", event);
            model.addAttribute("details", details);
            HashMap<String, Object> pricingDescMap = new HashMap<>();
            for(TicketDetails detail : details) {
                String pricingDesc = eventPricingService.findEventPricingById(detail.getPricingOptionId()).getPricingDesc();
                pricingDescMap.put(detail.getPricingOptionName(), pricingDesc);
            }
            model.addAttribute("descMap",pricingDescMap);
            emailService.sendPaymentEmail(ticketMaster.getEmail(), model);

            try {
                String encodedMessage = URLEncoder.encode(event.getNotesOnTickets(), "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false);
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "redirect:/dashboard";
        } else {
            return "redirect:/dashboard";
        }
    }


    @GetMapping("/tickets/confirmation")
    public String showConfirmation(Model model) {
        return "ticket_confirmation";
    }

    @GetMapping("/tickets/{ticketId}")
    public String getTicketById(@PathVariable String ticketId, Model model) {
        Optional<TicketMaster> ticketMaster = Optional.ofNullable(ticketMasterService.findTicketMasterById(ticketId));
        if (ticketMaster.isPresent()) {
            model.addAttribute("ticketMaster", ticketMaster.get());
            return "ticket_detail";
        } else {
            model.addAttribute("error", "Ticket not found");
            return "error";
        }
    }

    @GetMapping("/tickets")
    public String getAllTickets(Model model) {
        List<TicketMaster> tickets = ticketMasterService.findAllTicketMasters();
        model.addAttribute("tickets", tickets);
        return "ticket_list";
    }

    @GetMapping("/payment/{masterId}")
    public String receivePayment(@PathVariable String masterId, HttpSession session, RedirectAttributes redirectAttributes, HttpServletRequest request, Model model) {
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

        TicketMaster master = ticketMasterService.findTicketMasterById(masterId);
        String eventId = "";

        if (master != null) {
            List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(master.getTicketMasterId());
            for (TicketDetails ticketDetails : details) {
                ticketDetails.setPaidStatus(1);
                ticketDetailsService.addOrUpdateTicketDetails(ticketDetails);
            }
            eventId = master.getEventId();
            master.setPaymentReceived(1);
            master.setPaymentReceivedBy(user.getUserId());
            DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
            master.setPaymentReceivedAt(dtf.format(LocalDateTime.now()));
            ticketMasterService.updateTicketMaster(master);
            HashMap<String, Object> pricingDescMap = new HashMap<>();
            for(TicketDetails detail : details) {
                String pricingDesc = eventPricingService.findEventPricingById(detail.getPricingOptionId()).getPricingDesc();
                pricingDescMap.put(detail.getPricingOptionName(), pricingDesc);
            }
            Event event = eventService.findEventById(master.getEventId());
            model.addAttribute("descMap", pricingDescMap);
            model.addAttribute("event", event);
            model.addAttribute("ticket", master);
            model.addAttribute("details", details);
            emailService.sendTicketEmail(master.getEmail(), model);


            // Add a flash attribute to signal a successful update
            redirectAttributes.addFlashAttribute("message", "Payment for " + master.getFullName() + " received successfully!");
        }

        // Pass the eventId as a query parameter in the redirect
        if (eventId != null && !eventId.isEmpty()) {
            redirectAttributes.addAttribute("eventId", eventId);
        }
        
        return "redirect:/payment_list";
    }

    @GetMapping("/tickets/undo/{masterId}")
    public String undoPayment(@PathVariable String masterId, RedirectAttributes redirectAttributes) {
        TicketMaster master = ticketMasterService.findTicketMasterById(masterId);
        String eventId = "";

        if (master != null) {
            eventId = master.getEventId();
            List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(master.getTicketMasterId());
            for(TicketDetails detail : details) {
                detail.setPaidStatus(0);
                ticketDetailsService.addOrUpdateTicketDetails(detail);
            }
            master.setPaymentReceived(0);
            master.setPaymentReceivedBy(null);
            master.setPaymentReceivedAt(null);
            ticketMasterService.updateTicketMaster(master);
            redirectAttributes.addFlashAttribute("message", "Payment for " + master.getFullName() + " undone.");
        }

        if (eventId != null && !eventId.isEmpty()) {
            redirectAttributes.addAttribute("eventId", eventId);
        }

        return "redirect:/payment_list";
    }

    @GetMapping("/tickets/delete/{masterId}")
    public String deleteTicket(@PathVariable String masterId, RedirectAttributes redirectAttributes) {
        TicketMaster master = ticketMasterService.findTicketMasterById(masterId);
        String eventId = "";

        if (master != null) {
            eventId = master.getEventId();
            List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(master.getTicketMasterId());
            for(TicketDetails detail : details) {
                ticketDetailsService.deleteTicketDetails(detail.getDetailId());
            }
            ticketMasterService.deleteTicketMaster(masterId);
            redirectAttributes.addFlashAttribute("message", "Ticket for " + master.getFullName() + " deleted.");
        }

        if (eventId != null && !eventId.isEmpty()) {
            redirectAttributes.addAttribute("eventId", eventId);
        }

        return "redirect:/payment_list";
    }

    @GetMapping("/payment/all/{eventId}")
    public String sendPaymentReminder(@PathVariable String eventId, RedirectAttributes redirectAttributes, HttpServletRequest request, Model model) {
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
            if(userService.validateToken(authToken)) {
                user = userService.getUserByToken(authToken).get();
                model.addAttribute("loggedInUser", user);
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }

        // Get event details
        Event event = eventService.findEventById(eventId);
        if (event == null) {
            redirectAttributes.addFlashAttribute("message", "Event not found!");
            return "redirect:/event_list";
        }

        // Get all unpaid tickets for this specific event
        List<TicketMaster> allTickets = ticketMasterService.findTicketMasterByEventId(eventId);
        List<TicketMaster> unpaidTickets = new ArrayList<>();
        
        for (TicketMaster ticket : allTickets) {
            if (ticket.getPaymentReceived() == 0) {
                unpaidTickets.add(ticket);
            }
        }

        if (unpaidTickets.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No unpaid tickets found for " + event.getEventName());
            return "redirect:/event_list";
        }

        // Send reminder emails to unpaid tickets
        int emailsSent = 0;
        for (TicketMaster ticket : unpaidTickets) {
            try {
                emailService.sendPaymentReminder(ticket.getTicketMasterId(), eventId);
                emailsSent++;
            } catch (Exception e) {
                System.err.println("Failed to send email to: " + ticket.getEmail() + " - " + e.getMessage());
            }
        }

        redirectAttributes.addFlashAttribute("message", "Payment reminders sent to " + emailsSent + " unpaid ticket holders for " + event.getEventName());
        return "redirect:/event_list";
    }

    public static int getRandomCode() {
        Random rnd = new Random();
        int number = rnd.nextInt(999999);
        return number;
    }
}