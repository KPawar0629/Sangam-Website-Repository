package com.sangam.sangam.controller;

import com.sangam.sangam.model.TicketDetails;
import com.sangam.sangam.service.TicketDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Controller responsible for managing individual ticket details
 * Handles CRUD operations for the TicketDetails entity
 */
@Controller
public class TicketDetailsController {

    @Autowired
    private TicketDetailsService service;

    /**
     * Creates or updates a ticket detail record
     * 
     * @param ticketId ID of the parent ticket master
     * @param detailsId ID of the ticket detail to update (null for new)
     * @param ticketOption Pricing option ID for this ticket
     * @param ticketFor Name of the person this ticket is for
     * @param ticketerAge Age of the ticket holder
     * @param eventId ID of the associated event
     * @param model Spring MVC Model for view attributes
     * @return redirect to the ticket form for the event
     */
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
            // Update existing ticket detail
            ticketDetails = service.findTicketDetailsById(detailsId);
            if (ticketDetails == null) {
                model.addAttribute("error", "Ticket Details not found!");
                return "redirect:/tickets/" + ticketId;
            }
        } else {
            // Create new ticket detail
            ticketDetails = new TicketDetails();
            ticketDetails.setDetailId(UUID.randomUUID().toString().split("-")[0]);
            ticketDetails.setTicketId(ticketId);
        }

        ticketDetails.setPricingOptionId(ticketOption);
        ticketDetails.setFullName(ticketFor);
        service.addOrUpdateTicketDetails(ticketDetails);
        return "redirect:/tickets/new/" + eventId;
    }

    /**
     * Deletes a specific ticket detail record
     * Note: This method has an issue - it attempts to read the ticket details after deletion
     * 
     * @param ticketDetailsId ID of the ticket detail to delete
     * @return redirect to the parent ticket view
     */
    @DeleteMapping("/ticket_details/delete/{ticketDetailsId}")
    public String deleteTicketDetails(@PathVariable String ticketDetailsId) {
        // This is problematic - should get the ticketId before deletion
        service.deleteTicketDetails(ticketDetailsId);
        // This will always be null since we already deleted it
        TicketDetails ticketDetails = service.findTicketDetailsById(ticketDetailsId);
        String ticketId = ticketDetails != null ? ticketDetails.getTicketId() : "";
        return "redirect:/tickets/" + ticketId;
    }

    /**
     * Retrieves all ticket details for a specific ticket master
     * Note: This endpoint has a URL path conflict with getTicketDetailsById
     * 
     * @param ticketId ID of the parent ticket master
     * @return List of ticket detail records (raw, not a view)
     */
    @GetMapping("/ticket_details/{ticketId}")
    public List<TicketDetails> getAllTicketDetailsByTicketId(@PathVariable String ticketId) {
        return service.findTicketDetailsByTicketId(ticketId);
    }

    /**
     * Retrieves a specific ticket detail record by ID
     * Note: This endpoint has a URL path conflict with getAllTicketDetailsByTicketId
     * 
     * @param ticketDetailsId ID of the ticket detail to retrieve
     * @return The ticket detail record (raw, not a view)
     */
    @GetMapping("/ticket_details/{ticketDetailsId}")
    public TicketDetails getTicketDetailsById(@PathVariable String ticketDetailsId) {
        return service.findTicketDetailsById(ticketDetailsId);
    }
}
