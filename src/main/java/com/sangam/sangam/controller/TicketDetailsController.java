package com.sangam.sangam.controller;

import com.sangam.sangam.model.TicketDetails;
import com.sangam.sangam.service.TicketDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@Controller
public class TicketDetailsController {

    @Autowired
    private TicketDetailsService service;

    @PostMapping("/ticket_details")
    public String createOrUpdateTicketDetails(
            @RequestParam String ticketId,
            @RequestParam(required = false) String detailsId,
            @RequestParam String ticketOption,
            @RequestParam String ticketFor,
            @RequestParam int ticketerAge,
            @RequestParam String eventId,
            Model model
    ) {
        TicketDetails ticketDetails;
        if (detailsId != null && !detailsId.isEmpty()) {
            ticketDetails = service.findTicketDetailsById(detailsId);
            if (ticketDetails == null) {
                model.addAttribute("error", "Ticket Details not found!");
                return "redirect:/tickets/" + ticketId;
            }
        } else {
            ticketDetails = new TicketDetails();
            ticketDetails.setDetailId(UUID.randomUUID().toString().split("-")[0]);
            ticketDetails.setTicketId(ticketId);
        }

        ticketDetails.setPricingOptionId(ticketOption);
        ticketDetails.setFullName(ticketFor);
        service.addOrUpdateTicketDetails(ticketDetails);
        return "redirect:/tickets/new/" + eventId;
    }

    @DeleteMapping("/ticket_details/delete/{ticketDetailsId}")
    public String deleteTicketDetails(@PathVariable String ticketDetailsId) {
        service.deleteTicketDetails(ticketDetailsId);
        // Assuming `service.findTicketDetailsById(ticketDetailsId)` is used to fetch the ticketId for redirection
        TicketDetails ticketDetails = service.findTicketDetailsById(ticketDetailsId);
        String ticketId = ticketDetails != null ? ticketDetails.getTicketId() : "";
        return "redirect:/tickets/" + ticketId;
    }

    @GetMapping("/ticket_details/{ticketId}")
    public List<TicketDetails> getAllTicketDetailsByTicketId(@PathVariable String ticketId) {
        return service.findTicketDetailsByTicketId(ticketId);
    }

    @GetMapping("/ticket_details/{ticketDetailsId}")
    public TicketDetails getTicketDetailsById(@PathVariable String ticketDetailsId) {
        return service.findTicketDetailsById(ticketDetailsId);
    }
}
