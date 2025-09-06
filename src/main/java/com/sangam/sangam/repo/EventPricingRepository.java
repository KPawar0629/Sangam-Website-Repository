package com.sangam.sangam.repo;

import com.sangam.sangam.model.EventPricing;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface EventPricingRepository extends MongoRepository<EventPricing, String> {
    List<EventPricing> findByEventId(String eventId);
}
