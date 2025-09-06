package com.sangam.sangam.repo;

import com.sangam.sangam.model.TicketMaster;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface TicketMasterRepository extends MongoRepository<TicketMaster, String> {

    List<TicketMaster> findByEventId(String eventId);

    List<TicketMaster> findByEmail(String email);
}
