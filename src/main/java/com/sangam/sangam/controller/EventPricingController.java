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

@Controller
public class EventPricingController {
    @Autowired
    private EventPricingService service;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public EventPricing createEventPricing(@RequestBody EventPricing eventPricing) {
        return service.addEventPricing(eventPricing);
    }

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

    

    @GetMapping("/event_pricing/delete/{eventPricingId}")
    public String deleteEventPricing(@PathVariable String eventPricingId, HttpSession session) {
        EventPricing eventPricing = service.findEventPricingById(eventPricingId);
        if (eventPricing != null) {
            service.deleteEventPricing(eventPricingId);
        }
        String eventId = eventPricing != null ? eventPricing.getEventId() : "";
        return "redirect:/events/edit/" + eventId;
    }

    @GetMapping("/eventpricing/{eventId}")
    public List<EventPricing> getAllEventPricingsByEventId(@PathVariable String eventId) {
        return service.findEventPricingsByEventId(eventId);
    }

    @GetMapping("/eventpricing/{eventPricingId}")
    public EventPricing getEventPricingById(@PathVariable String eventPricingId) {
        return service.findEventPricingById(eventPricingId);
    }

    @PutMapping("/eventpricing/update")
    public EventPricing updateEventPricing(@RequestBody EventPricing eventPricing) {
        return service.updateEventPricing(eventPricing);
    }

    @DeleteMapping("/{eventPricingId}")
    public String deleteEventPricing(@PathVariable String eventPricingId) {
        return service.deleteEventPricing(eventPricingId);
    }
}
