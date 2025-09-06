package com.sangam.sangam.service;

import com.sangam.sangam.model.Event;
import com.sangam.sangam.model.EventPricing;
import com.sangam.sangam.model.User;
import com.sangam.sangam.repo.EventPricingRepository;
import com.sangam.sangam.repo.EventRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;
    @Autowired
    private EventPricingRepository pricingRepository;

    public Event createOrUpdateEvent(Event event, User user) {
        User loggedInUser = user;

        if (event.getEventId() != null && !event.getEventId().isEmpty()) {
            Optional<Event> existingEvent = eventRepository.findById(event.getEventId());
            if (existingEvent.isPresent()) {
                Event updatedEvent = existingEvent.get();
                updatedEvent.setEventName(event.getEventName());
                updatedEvent.setEventDescription(event.getEventDescription());
                updatedEvent.setEventLocation(event.getEventLocation());
                updatedEvent.setEventDateTime(event.getEventDateTime());
                updatedEvent.setNotesOnTickets(event.getNotesOnTickets());
                updatedEvent.setLastModifiedBy(loggedInUser.getUserId());
                updatedEvent.setLastModifiedAt(new Date().toString());
                updatedEvent.setPublished(event.getPublished());
                updatedEvent.setPublishedAt(event.getPublishedAt());
                updatedEvent.setPublishedBy(event.getPublishedBy());
                updatedEvent.setEventDateTimeOrig(event.getEventDateTimeOrig());
                updatedEvent.setEventDateTimeLanding(event.getEventDateTimeLanding());
                updatedEvent.setParticipationAllowed(event.getParticipationAllowed());
                updatedEvent.setParticipationStartDate(event.getParticipationStartDate());
                updatedEvent.setParticipationEndDate(event.getParticipationEndDate());
                updatedEvent.setPartiStatus(event.getPartiStatus());
                updatedEvent.setEventType(event.getEventType());
                updatedEvent.setImageUrl(event.getImageUrl());
                updatedEvent.setRsvpYes(event.getRsvpYes());
                updatedEvent.setStatus(event.getStatus());
                updatedEvent.setRsvpCount(event.getRsvpCount());
                updatedEvent.setRsvpStartDate(event.getRsvpStartDate());
                updatedEvent.setRsvpEndDate(event.getRsvpEndDate());

                return eventRepository.save(updatedEvent);
            }
        }
        return eventRepository.save(event);

    }

    public Event updatePartiStatusChecker(Event event) {
        event.setPartiStatus(partiStatusChecker(event));
        return eventRepository.save(event);
    }

    public List<Event> findAllEvents() {
        return eventRepository.findAll();
    }

    public Event findEventById(String id) {
        return eventRepository.findById(id).orElse(null);
    }

    public Optional<Event> findEventByName(String name) {
        return eventRepository.findByEventName(name).stream().findFirst();
    }

    // public Event updateEvent(Event event) {
    //     Event existingEvent = eventRepository.findById(event.getEventId()).get();
    //     existingEvent.setEventName(event.getEventName());
    //     existingEvent.setEventDescription(event.getEventDescription());
    //     existingEvent.setEventLocation(event.getEventLocation());
    //     existingEvent.setEventDateTime(event.getEventDateTime());
    //     existingEvent.setNotesOnTickets(event.getNotesOnTickets());

    //     return eventRepository.save(existingEvent);
    // }

    public String deleteEvent(String id) {
        eventRepository.deleteById(id);
        return "Event deleted";
    }

    public String partiStatusChecker(Event event) {
        String startDate = event.getParticipationStartDate();
        String endDate = event.getParticipationEndDate();
        
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;
        LocalDate startDateFormatted = LocalDate.parse(startDate, formatter);
        LocalDate endDateFormatted = LocalDate.parse(endDate, formatter);
        LocalDate today = LocalDate.now();

        if(today.isBefore(startDateFormatted)) {
            return "Not Started";
        } else if(today.isBefore(endDateFormatted)) {
            return "Active";
        } else {
            return "Completed";
        }
    }

    public long eventCount() {
        return eventRepository.count();
    }

    public List<Event> findEventsByName(String eventName) {
        return eventRepository.findByEventName(eventName);
    }

    public List<EventPricing> findEventPricingByEventId(String eventId) {
        return pricingRepository.findByEventId(eventId);
    }

    public boolean isRsvpActive(Event event) {
        if (event.getRsvpYes() == null || !event.getRsvpYes().equals("yes") ||
            event.getRsvpStartDate() == null || event.getRsvpEndDate() == null ||
            event.getRsvpStartDate().equals("null") || event.getRsvpEndDate().equals("null")) {
            return false;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE;
        LocalDate startDate = LocalDate.parse(event.getRsvpStartDate(), formatter);
        LocalDate endDate = LocalDate.parse(event.getRsvpEndDate(), formatter);
        LocalDate today = LocalDate.now();

        return !today.isBefore(startDate) && !today.isAfter(endDate);
    }
}
