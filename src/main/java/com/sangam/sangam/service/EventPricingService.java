package com.sangam.sangam.service;

import com.sangam.sangam.model.EventPricing;
import com.sangam.sangam.repo.EventPricingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.format.DateTimeFormatter;
import java.time.ZonedDateTime;


import java.util.List;
import java.util.Optional;

@Service
public class EventPricingService {
    @Autowired
    private EventPricingRepository repository;

    public EventPricing addEventPricing(EventPricing eventPricing) {
        return repository.save(eventPricing);
    }

    public EventPricing findEventPricingById(String id) {
        return repository.findById(id).get();
    }

    public List<EventPricing> findAllEventPricing() {
        return repository.findAll();
    }

    public List<EventPricing> findEventPricingsByEventId(String eventId) {
        return repository.findByEventId(eventId);
    }

    public EventPricing updateEventPricing(EventPricing eventPricing) {
        EventPricing existingPricing = repository.findById(eventPricing.getId()).get();
        existingPricing.setPricingName(eventPricing.getPricingName());
        existingPricing.setPricingRate(eventPricing.getPricingRate());
        existingPricing.setPricingDesc(eventPricing.getPricingDesc());
        return repository.save(existingPricing);
    }

    public String deleteEventPricing(String id) {
        repository.deleteById(id);
        return "Event Pricing deleted";
    }

    public long eventPricingCountPerEvent(String eventId) {
        return repository.findByEventId(eventId).size();
    }

    public EventPricing addOrUpdateEventPricing(EventPricing eventPricing) {
        if(eventPricing.getId() != null && !eventPricing.getId().isEmpty()) {
            Optional<EventPricing> existingEventPricing = repository.findById(eventPricing.getId());
            if(existingEventPricing.isPresent()) {
                EventPricing updatedPricing = existingEventPricing.get();
                updatedPricing.setPricingName(eventPricing.getPricingName());
                updatedPricing.setPricingRate(eventPricing.getPricingRate());
                updatedPricing.setPricingDesc(eventPricing.getPricingDesc());
                updatedPricing.setStartDate(eventPricing.getStartDate());
                updatedPricing.setEndDate(eventPricing.getEndDate());
                updatedPricing.setEndDateFormatted(eventPricing.getEndDateFormatted());
                updatedPricing.setStartDateFormatted(eventPricing.getStartDateFormatted());
                updatedPricing.setStatus(eventPricing.getStatus());

                return repository.save(updatedPricing);
            }
        }
        return repository.save(eventPricing);
    }


    public void resetStatus(EventPricing pricing) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEE MMM dd HH:mm:ss zzz yyyy");
    
        String startDateTimeStr = pricing.getStartDateFormatted();
        String endDateTimeStr = pricing.getEndDateFormatted();
    
        ZonedDateTime startDateTime = ZonedDateTime.parse(startDateTimeStr, formatter);
        ZonedDateTime endDateTime = ZonedDateTime.parse(endDateTimeStr, formatter);
    
        ZonedDateTime nowDateTime = ZonedDateTime.now();
    
        if (nowDateTime.isBefore(startDateTime)) {
            pricing.setStatus("Not Started!");
            repository.save(pricing);
        } else if (nowDateTime.isBefore(endDateTime)) {
            pricing.setStatus("Active");
            repository.save(pricing);
        } else {
           pricing.setStatus("Completed!");
           repository.save(pricing);
        }
    }
}
