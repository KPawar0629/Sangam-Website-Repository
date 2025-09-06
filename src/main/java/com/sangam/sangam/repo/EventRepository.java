package com.sangam.sangam.repo;

import com.sangam.sangam.model.Event;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface EventRepository extends MongoRepository<Event, String> {
    List<Event> findByEventName(String name);
}
