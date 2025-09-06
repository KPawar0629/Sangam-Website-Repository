package com.sangam.sangam.repo;

import com.sangam.sangam.model.TicketDetails;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface TicketDetailsRepository extends MongoRepository<TicketDetails, String> {
    List<TicketDetails> findByTicketId(String ticketId);

    TicketDetails findByUniqueCode(int uniqueId);

    Optional<TicketDetails> findByDetailId(String id);

    List<TicketDetails> findByEventId(String eventId);
}
