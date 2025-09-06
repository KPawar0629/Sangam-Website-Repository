package com.sangam.sangam.repo;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.sangam.sangam.model.DressCompetition;
import java.util.List;
import java.util.Optional;


public interface DressCompetitionRepository extends MongoRepository<DressCompetition, String>{
    List<DressCompetition> findByEventId(String eventId);
    List<DressCompetition> findByCategory(String category);
}
