package com.sangam.sangam.controller;

import com.sangam.sangam.model.EventPricing;
import com.sangam.sangam.service.EventPricingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * Controller responsible for managing event pricing options
 * Handles creation, updating, deletion, and retrieval of ticket pricing tiers
 */
@Controller
public class EventPricingController {
    @Autowired
    private EventPricingService service;

    /**
     * API endpoint for creating a new event pricing option via JSON
     * 
     * @param eventPricing The event pricing data in request body
     * @return The created event pricing object
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EventPricing createEventPricing(@RequestBody EventPricing eventPricing) {
        return service.addEventPricing(eventPricing);
    }

    /**
     * Creates or updates an event pricing option from form submission
     * Handles date formatting and status calculation
     * 
     * @param eventId ID of the parent event
     * @param eventPricingId Optional ID if updating existing pricing
     * @param ticketType Name of the pricing option (e.g., "Adult", "Child")
     * @param description Detailed description of the pricing option
     * @param ratePerTicket Price per ticket
     * @param startDate Start date when this pricing option becomes available
     * @param endDate End date when this pricing option expires
     * @param model Spring MVC Model for view attributes
     * @return redirect to event edit page
     */
    @PostMapping("/event_pricing")
    public String createOrUpdateEventPricing(
            @RequestParam String eventId,
            @RequestParam(required = false) String eventPricingId,
            @RequestParam String ticketType,
            @RequestParam String description,
            @RequestParam double ratePerTicket,
            @RequestParam String startDate,
            @RequestParam String endDate,
            Model model
    ) {
        System.out.println("Start date this format: " + startDate);
        System.out.println("End date this format: " + endDate);

        String startDateTime = startDate;
        String endDateTime = endDate;

        // Parse the input string to LocalDateTime
        LocalDateTime startLocalDateTime = LocalDateTime.parse(startDateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        LocalDateTime endLocalDateTime = LocalDateTime.parse(endDateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        // Convert LocalDateTime to ZonedDateTime with the desired time zone (PDT)
        ZoneId zoneId = ZoneId.of("America/Los_Angeles"); // PDT time zone
        ZonedDateTime startZonedDateTime = startLocalDateTime.atZone(zoneId);
        ZonedDateTime endZonedDateTime = endLocalDateTime.atZone(zoneId);

        // Define the output format
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss z yyyy");

        String thisIs = startZonedDateTime.format(outputFormatter);
        String isThis = endZonedDateTime.format(outputFormatter);
        String startPricingTime = thisIs.replace("GMT-07:00", "PDT");
        String endPricingTime = isThis.replace("GMT-07:00", "PDT");

        // Find existing pricing or create new one
        EventPricing eventPricing;
        if (eventPricingId != null && !eventPricingId.isEmpty()) {
            eventPricing = service.findEventPricingById(eventPricingId);
            if (eventPricing == null) {
                model.addAttribute("error", "Pricing not found!");
                return "redirect:/events/edit/" + eventId;
            }
        } else {
            eventPricing = new EventPricing();
            eventPricing.setId(UUID.randomUUID().toString().split("-")[0]);
            eventPricing.setEventId(eventId);
        }

        // Update pricing fields
        eventPricing.setPricingName(ticketType);
        eventPricing.setPricingDesc(description);
        eventPricing.setPricingRate(ratePerTicket);
        eventPricing.setStartDate(startDate);
        eventPricing.setEndDate(endDate);
        eventPricing.setEndDateFormatted(endPricingTime);
        eventPricing.setStartDateFormatted(startPricingTime);
        eventPricing.setStatus(resetStatus(eventPricing));
        service.addOrUpdateEventPricing(eventPricing);
        return "redirect:/events/edit/" + eventId;
    }

    /**
     * Determines and updates the status of a pricing option based on its time validity
     * 
     * Possible statuses:
     * - "Not Started!" - Current time is before the pricing start date
     * - "Active" - Current time is between start and end dates
     * - "Completed!" - Current time is after the pricing end date
     * 
     * @param pricing The pricing option to check status for
     * @return The calculated status string
     */
    public String resetStatus(EventPricing pricing) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");
    
        String startDateTimeStr = pricing.getStartDateFormatted();
        String endDateTimeStr = pricing.getEndDateFormatted();
    
        ZonedDateTime startDateTime = ZonedDateTime.parse(startDateTimeStr, formatter);
        ZonedDateTime endDateTime = ZonedDateTime.parse(endDateTimeStr, formatter);
    
        ZonedDateTime nowDateTime = ZonedDateTime.now();
    
        if (nowDateTime.isBefore(startDateTime)) {
            return "Not Started!";
        } else if (nowDateTime.isBefore(endDateTime)) {
            return "Active";
        } else {
            return "Completed!";
        }
    }

    

    /**
     * Deletes a pricing option and redirects back to event edit page
     * 
     * @param eventPricingId ID of the pricing option to delete
     * @param session HTTP session
     * @return redirect to the event edit view
     */
    @GetMapping("/event_pricing/delete/{eventPricingId}")
    public String deleteEventPricing(@PathVariable String eventPricingId, HttpSession session) {
        EventPricing eventPricing = service.findEventPricingById(eventPricingId);
        if (eventPricing != null) {
            service.deleteEventPricing(eventPricingId);
        }
        String eventId = eventPricing != null ? eventPricing.getEventId() : "";
        return "redirect:/events/edit/" + eventId;
    }

    /**
     * API endpoint to get all pricing options for an event
     * Note: This endpoint has a URL path conflict with getEventPricingById
     * 
     * @param eventId ID of the event to get pricing options for
     * @return List of event pricing options
     */
    @GetMapping("/eventpricing/{eventId}")
    public List<EventPricing> getAllEventPricingsByEventId(@PathVariable String eventId) {
        return service.findEventPricingsByEventId(eventId);
    }

    /**
     * API endpoint to get a specific pricing option by ID
     * Note: This endpoint has a URL path conflict with getAllEventPricingsByEventId
     * 
     * @param eventPricingId ID of the pricing option to retrieve
     * @return The event pricing option
     */
    @GetMapping("/eventpricing/{eventPricingId}")
    public EventPricing getEventPricingById(@PathVariable String eventPricingId) {
        return service.findEventPricingById(eventPricingId);
    }

    /**
     * API endpoint to update a pricing option via JSON
     * 
     * @param eventPricing The updated pricing data
     * @return The updated pricing option
     */
    @PutMapping("/eventpricing/update")
    public EventPricing updateEventPricing(@RequestBody EventPricing eventPricing) {
        return service.updateEventPricing(eventPricing);
    }

    /**
     * API endpoint to delete a pricing option
     * Note: This endpoint duplicates functionality with /event_pricing/delete/{eventPricingId}
     * 
     * @param eventPricingId ID of the pricing option to delete
     * @return Result message from the service
     */
    @DeleteMapping("/{eventPricingId}")
    public String deleteEventPricing(@PathVariable String eventPricingId) {
        return service.deleteEventPricing(eventPricingId);
    }
}
