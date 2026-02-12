package com.sangam.sangam.repo;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;
import com.sangam.sangam.model.Participation;

public interface ParticipationRepository extends MongoRepository<Participation, String>{

    List<Participation> findByEventId(String eventId);
    
}
