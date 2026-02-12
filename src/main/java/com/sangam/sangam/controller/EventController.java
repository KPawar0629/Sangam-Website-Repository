package com.sangam.sangam.controller;

import com.sangam.sangam.model.DressCompetition;
import com.sangam.sangam.model.Event;
import com.sangam.sangam.model.EventPricing;
import com.sangam.sangam.model.Participation;
import com.sangam.sangam.model.TicketDetails;
import com.sangam.sangam.model.TicketMaster;
import com.sangam.sangam.model.User;
import com.sangam.sangam.service.DressCompetitionService;
import com.sangam.sangam.service.EventPricingService;
import com.sangam.sangam.service.EventService;
import com.sangam.sangam.service.ParticipationService;
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
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.LocalDate;


@Controller
public class EventController {

    private static final Logger logger = LoggerFactory.getLogger(SignInController.class);


    @Autowired
    private EventService service;
    @Autowired
    private EventPricingService pricingService;
    @Autowired
    private TicketMasterService ticketMasterService;
    @Autowired
    private TicketDetailsService ticketDetailsService;
    @Autowired
    private ParticipationService participationService;
    @Autowired
    private UserService userService;
    @Autowired
    private DressCompetitionService competitionService;

    @GetMapping("/events/new")
    public String showCreateEventForm(Model model, HttpServletRequest request) {
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
                model.addAttribute("event", new Event());
                return "/event_form";
            } else {
                return "redirect:/signin";
            }
        } else {
            return "redirect:/signin";
        }
    }

    @GetMapping("/events/edit/{eventId}")
    public String showEditEventForm(@PathVariable String eventId, @RequestParam(required = false) String pricingId,Model model, HttpServletRequest request) {
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
        Event event = service.findEventById(eventId);
        if(event.getEventType() == null) {
            event.setEventType("paid");
            event.setRsvpYes("null");
            event.setRsvpStartDate("null");
            event.setRsvpEndDate("null");
            service.createOrUpdateEvent(event, user);
        }
        model.addAttribute("event", event);
        List<EventPricing> eventPricings = pricingService.findEventPricingsByEventId(event.getEventId());
        model.addAttribute("eventPricings", eventPricings);

        if(pricingId != null && !pricingId.isEmpty()) {
            EventPricing pricing = pricingService.findEventPricingById(pricingId);
            model.addAttribute("pricing", pricing);
        }

        return "/event_form";


    }

    @PostMapping("/events")
    public String handleEventCreationOrUpdate(
            @RequestParam(required = false) String eventId,
            @RequestParam String eventName,
            @RequestParam String eventDescription,
            @RequestParam String eventLocation,
            @RequestParam String eventDateTime,
            @RequestParam String notesOnTickets,
            @RequestParam String eventType,
            @RequestParam String imageUrl,
            @RequestParam(required = false) String rsvpCheck,
            @RequestParam(required = false) String rsvpStart,
            @RequestParam(required = false) String rsvpEnd,
            @RequestParam(required = false) String partiCheck,
            @RequestParam(required = false) String partiStart,
            @RequestParam(required = false) String partiEnd,
            @RequestParam(required = false) String rsvpCount,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model
    ) {
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

        Event event;
        if (eventId != null && !eventId.isEmpty()) {
            event = service.findEventById(eventId);
            if(event == null) {
                model.addAttribute("error", "Event not found!");
                System.out.println("Event not found!");
                return "/event_list";
            }
        } else {
            Optional<Event> existingEvent = service.findEventByName(eventName);

            if (service.eventCount() >= 10) {
                model.addAttribute("error", "Too many events! Wait for some events to finish or delete some!");
                System.out.println("Too many events!");
                return "/event_list";
            }

            if (existingEvent.isPresent()) {
                model.addAttribute("error", "Event already exists!");
                return "/event_form";
            }

            event = new Event();
            event.setEventId(UUID.randomUUID().toString().split("-")[0]);
            event.setEventCreatedAt(new Date().toString());
            if (user != null) {
                event.setEventCreatedBy(user.getUserId());
            }
            event.setLastModifiedBy("null");
            event.setLastModifiedAt("null");
            event.setPublished(0);
            event.setPublishedBy("null");
            event.setPublishedBy("null");
            event.setParticipationAllowed(0);
            event.setParticipationStartDate("null");
            event.setParticipationEndDate("null");
        }

        String inputDateTime = eventDateTime;

        // Parse the input string to LocalDateTime
        LocalDateTime localDateTime = LocalDateTime.parse(inputDateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        // Convert LocalDateTime to ZonedDateTime with the desired time zone (PDT)
        ZoneId zoneId = ZoneId.of("America/Los_Angeles"); // PDT time zone
        ZonedDateTime zonedDateTime = localDateTime.atZone(zoneId);

        // Define the output format
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss z yyyy");

        String thisIs = zonedDateTime.format(outputFormatter);
        String dateEventTime = thisIs.replace("GMT-07:00", "PDT");
        // Format the ZonedDateTime to the desired string format
        event.setEventDateTime(dateEventTime);
        event.setEventDateTimeOrig(eventDateTime);
        event.setEventName(eventName);
        event.setEventDescription(eventDescription);
        event.setEventLocation(eventLocation);
        event.setNotesOnTickets(notesOnTickets);
        event.setStatus(resetStatus(event));
        event.setEventDateTimeLanding(landingPageFormatter(eventDateTime));
        if(partiCheck != null) {
            if (partiCheck.equals("no")) {
                event.setParticipationAllowed(0);
            } else if(partiCheck.equals("yes")) {
                event.setParticipationAllowed(1);
                event.setParticipationStartDate(partiStart);
                event.setParticipationEndDate(partiEnd);
                event.setPartiStatus(service.partiStatusChecker(event));
            }
        }

        if(eventType.equals("paid")) {
            event.setEventType("paid");
        } else {
            event.setEventType("free");
        }

        event.setImageUrl(imageUrl);
        event.setRsvpYes(rsvpCheck);
        if (rsvpCheck != null && rsvpCheck.equals("yes")) {
            event.setRsvpStartDate(rsvpStart != null ? rsvpStart : "null");
            event.setRsvpEndDate(rsvpEnd != null ? rsvpEnd : "null");
            event.setRsvpCount(Integer.valueOf(rsvpCount));
        } else {
            event.setRsvpStartDate("null");
            event.setRsvpEndDate("null");
        }



        service.createOrUpdateEvent(event, user);
        try {
            String encodedMessage = URLEncoder.encode("Event Created or Updated!", "UTF-8");
            Cookie msgCookie = new Cookie("message", encodedMessage);
            msgCookie.setHttpOnly(true);
            msgCookie.setSecure(false);
            msgCookie.setPath("/");
            response.addCookie(msgCookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/event_list";
    }

    public String landingPageFormatter(String date) {
        DateTimeFormatter inputFormatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a");

        LocalDateTime dateTime = LocalDateTime.parse(date, inputFormatter);

        String outputDateTime = dateTime.format(outputFormatter);

        return outputDateTime;
    }

    public String resetStatus(Event event) {
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss z yyyy");

        // Define the date strings
        String date1Str = new Date().toString();
        String date2Str = event.getEventDateTime();

        // Parse the date strings into ZonedDateTime objects
        ZonedDateTime date1 = ZonedDateTime.parse(date1Str, outputFormatter.withZone(ZoneId.of("America/Los_Angeles")));
        ZonedDateTime date2 = ZonedDateTime.parse(date2Str, outputFormatter.withZone(ZoneId.of("America/Los_Angeles")));


        if (date1.isAfter(date2)) {
            if (event.getPublished() == 1) {
                event.setStatus("Completed!");
                return "Completed!";
            } else {
                event.setStatus("Passed without publish!");
                return "Passed without publish!";
            }
        } else if (date1.isBefore(date2)) {
            if (event.getPublished() == 1) {
                event.setStatus("Active");
                return "Active";
            } else {
                event.setStatus("Draft");
                return "Draft";
            }
        } else {
            if (event.getPublished() == 1) {
                event.setStatus("Happening Now!");
                return "Happening Now!";
            } else {
                event.setStatus("Dropped!");
                return "Dropped!";
            }
        }
    }



    @GetMapping("/event_list")
    public String getAllEvents(Model model, HttpServletRequest request, HttpServletResponse response) {
        List<Event> events = service.findAllEvents();

        String authToken = null;
        String message = null;

        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(var cookie : cookies) {
                if(cookie.getName().equals("authToken")) {
                    authToken = cookie.getValue();
                }
                if(cookie.getName().equals("message")) {
                    try {
                        String decodedMessage = URLDecoder.decode(cookie.getValue(), "UTF-8");
                        message = decodedMessage;
                        Cookie msgCookie = new Cookie("message", null);
                        msgCookie.setMaxAge(0);
                        response.addCookie(msgCookie);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
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

        if(message != null) {
            model.addAttribute("message", message);
            System.out.println("added this attribute " + message);
        }

        for (Event event : events) {
            event.setStatus(resetStatus(event));
            service.createOrUpdateEvent(event, user);
        }
        model.addAttribute("events", events);
        return "/event_list";
    }

//    @GetMapping("/events/{eventId}")
//    public String getEventById(@PathVariable String eventId, Model model) {
//        Event foundEvent = service.findEventById(eventId);
//        model.addAttribute("event", foundEvent);
//        return("/event_detail/e" + foundEvent.getEventId());
//    }

    @GetMapping("/name/{eventName}")
    public String getEventsByName(@PathVariable String eventName, Model model) {
        List<Event> events = service.findEventsByName(eventName);
        model.addAttribute("events", events);
        return "/event_list";
    }

//    @PutMapping
//    public String updateEvent(@RequestBody Event event, Model model) {
//        Event updatedEvent = service.updateEvent(event);
//        model.addAttribute("event", updatedEvent);
//        return "/event_detail";
//    }

    @GetMapping("/events/publish/{eventId}")
    public String publishOrUnpublishEvent(@PathVariable String eventId, HttpServletRequest request, Model model, HttpServletResponse response) {
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

        if(user != null) {
            Event event = service.findEventById(eventId);
            if(event.getEventType() == null) {
                event.setEventType("paid");
                event.setRsvpYes("null");
                event.setRsvpStartDate("null");
                event.setRsvpEndDate("null");
                service.createOrUpdateEvent(event, null);
            }
            if(event.getPublished() == 0) {
                event.setPublished(1);
                event.setPublishedBy(user.getUserId());
                event.setPublishedAt(new Date().toString());
                resetStatus(event);
                try {
                    String encodedMessage = URLEncoder.encode("Event Published Successfully!", "UTF-8");
                    Cookie msgCookie = new Cookie("message", encodedMessage);
                    msgCookie.setHttpOnly(true);
                    msgCookie.setSecure(false);
                    msgCookie.setPath("/");
                    response.addCookie(msgCookie);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                event.setPublished(0);
                event.setPublishedBy("null");
                event.setPublishedAt("null");
                resetStatus(event);
                try {
                    String encodedMessage = URLEncoder.encode("Event Unpublished Successfully!", "UTF-8");
                    Cookie msgCookie = new Cookie("message", encodedMessage);
                    msgCookie.setHttpOnly(true);
                    msgCookie.setSecure(false);
                    msgCookie.setPath("/");
                    response.addCookie(msgCookie);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            service.createOrUpdateEvent(event, user);
            model.addAttribute("events", service.findAllEvents());



            return "redirect:/event_list";

        } else {
            return "/signin";
        }
    }

    @GetMapping("/events/delete/{eventId}")
    public String deleteEvent(@PathVariable String eventId, Model model, HttpServletResponse response, HttpServletRequest request) {
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

        List<EventPricing> eventPricings = pricingService.findEventPricingsByEventId(eventId);
        for(EventPricing eventPricing : eventPricings) {
            pricingService.deleteEventPricing(eventPricing.getId());
        }
        List<TicketMaster> ticketMasters = ticketMasterService.findTicketMasterByEventId(eventId);
        for(TicketMaster ticketMaster : ticketMasters) {
            List<TicketDetails> ticketDetails = ticketDetailsService.findTicketDetailsByTicketId(ticketMaster.getTicketMasterId());
            for(TicketDetails ticketDetail : ticketDetails) {
                ticketDetailsService.deleteTicketDetails(ticketDetail.getDetailId());
            }
            ticketMasterService.deleteTicketMaster(ticketMaster.getTicketMasterId());
        }
        List<Participation> participations = participationService.getByEventId(eventId);
        for(Participation participation : participations) {
            participationService.deleteParticipation(participation.getParticipationId());
        }

        try {
            String encodedMessage = URLEncoder.encode(service.deleteEvent(eventId), "UTF-8");
            Cookie msgCookie = new Cookie("message", encodedMessage);
            msgCookie.setHttpOnly(true);
            msgCookie.setSecure(false);
            msgCookie.setPath("/");
            response.addCookie(msgCookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/event_list";
    }

    @GetMapping("/competition/{eventId}")
    public String getMethodName(@PathVariable String eventId, Model model) {
        model.addAttribute("event", service.findEventById(eventId));
        var details = ticketDetailsService.findAllTicketDetails();
        var codes = new ArrayList<String>();
        for (var detail : details) {
            codes.add(detail.getUniqueCode());
        }
        var already = competitionService.findAll();
        var alreadyy = new ArrayList<String>();
        for (var al : already) {
            alreadyy.add(al.getTicketCode());
        }
        model.addAttribute("ticketDetails", codes);
        model.addAttribute("already", alreadyy);
        return "/competition";
    }

    @PostMapping("/competition/new")
    public String newCompetitionEntry(
        @RequestParam(required = false) String hiddenCheck,
        @RequestParam String eventInput,
        @RequestParam String categoryType,
        @RequestParam String fullName,
        @RequestParam(required = false) String parentName,
        @RequestParam String phone,
        @RequestParam String ticketCode,
        Model model,
        HttpServletResponse response
    ) {

        if((categoryType.equals("Adult - Male") || categoryType.equals("Adult - Female")) && competitionService.findByCategory(categoryType).size() < 15) {
            System.out.println(competitionService.findByCategory(categoryType).size() + categoryType);
            if(hiddenCheck == null || hiddenCheck.isEmpty()) {
                DressCompetition comp = new DressCompetition();
                comp.setCategory(categoryType);
                comp.setEventId(eventInput);

                comp.setFullName(fullName);
                if(parentName != null && !parentName.isEmpty()) {
                    comp.setParentName(parentName);
                } else {
                    comp.setParentName("null");
                }
                comp.setPhoneNumber(phone);
                comp.setTicketCode(ticketCode);
                comp.setId(UUID.randomUUID().toString().split("-")[0]);

                competitionService.addOrUpdateEntry(comp);
            }

            try {
                String encodedMessage = URLEncoder.encode("Thank you for registering.<br>Sangam Team will contact you in next few days. Please checkin to the event by 3:30 PM in order to be eligible for the competition.", "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false);
                msgCookie.setPath("/");
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "redirect:/dashboard";
        } else if ((categoryType.equals("Teen - Boys") || categoryType.equals("Teen - Girls") || categoryType.equals("Kids - Boys") || categoryType.equals("Kids - Girls")) && competitionService.findByCategory(categoryType).size() < 10) {
            System.out.println(competitionService.findByCategory(categoryType).size() + categoryType +"2");
            if(hiddenCheck == null || hiddenCheck.isEmpty()) {
                DressCompetition comp = new DressCompetition();
                comp.setCategory(categoryType);
                comp.setEventId(eventInput);

                comp.setFullName(fullName);
                if(parentName != null && !parentName.isEmpty()) {
                    comp.setParentName(parentName);
                } else {
                    comp.setParentName("null");
                }
                comp.setPhoneNumber(phone);
                comp.setTicketCode(ticketCode);
                comp.setId(UUID.randomUUID().toString().split("-")[0]);

                competitionService.addOrUpdateEntry(comp);
            }

            try {
                String encodedMessage = URLEncoder.encode("Thank you for registering.<br>Sangam Team will contact you in next few days. Please checkin to the event by 3:30 PM in order to be eligible for the competition.", "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false);
                msgCookie.setPath("/");
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "redirect:/dashboard";
        } else {
            System.out.println(competitionService.findByCategory(categoryType).size() + categoryType +"3");

            try {
                String encodedMessage = URLEncoder.encode("Awwww snap, unfortunately we have reached our maximum number of participants for the " + categoryType + " category. Best luck next time!", "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false);
                msgCookie.setPath("/");
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "redirect:/dashboard";
        }

    }

    @GetMapping("/event_details")
    public String showEventDetails(@RequestParam String eventId, Model model, HttpServletRequest request) {
        Event event = service.findEventById(eventId);
        model.addAttribute("event", event);
        List<EventPricing> eventPricings = pricingService.findEventPricingsByEventId(event.getEventId());
        for (EventPricing pricing : eventPricings) {
                pricingService.resetStatus(pricing);
        }
        model.addAttribute("pricings", eventPricings);
        return "event_detail";
    }
}
