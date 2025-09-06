package com.sangam.sangam.service;

import com.sangam.sangam.model.TicketDetails;
import com.sangam.sangam.repo.TicketDetailsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TicketDetailsService {
    @Autowired
    private TicketDetailsRepository repository;

    public TicketDetails addTicketDetails(TicketDetails ticketDetails) {
        return repository.save(ticketDetails);
    }

    public TicketDetails findTicketDetailsById(String id) {
        return repository.findById(id).get();
    }

    public Optional<TicketDetails> findTicketDetailsByDetailsId(String id) {
        return repository.findByDetailId(id);
    }

    public List<TicketDetails> findAllTicketDetails() {
        return repository.findAll();
    }

    public List<TicketDetails> findByEventId(String eventId) {
        return repository.findByEventId(eventId);
    }


    public List<TicketDetails> findTicketDetailsByTicketId(String ticketId) {
        return repository.findByTicketId(ticketId);
    }

    public TicketDetails findByUniqueId(int uniqueId) {
        return repository.findByUniqueCode(uniqueId);
    }

//    public TicketDetails updateTicketDetails(TicketDetails ticketDetails, HttpSession session) {
//        User loggedUser = (User) session.getAttribute("loggedInUser");
//        TicketDetails existingPricing = repository.findById(ticketDetails.getId()).get();
//        existingPricing.setCheckedIn(ticketDetails.getCheckedIn());
//        existingPricing.set(ticketDetails.getPricingDesc());
//        return repository.save(existingPricing);
//    }

    public String deleteTicketDetails(String ticketId) {
        repository.deleteById(ticketId);
        return "Ticket Details deleted";
    }

    public long ticketDetailsCountPerTicket(String ticketId) {
        return repository.findByTicketId(ticketId).size();
    }

    public TicketDetails addOrUpdateTicketDetails(TicketDetails ticketDetails) {
        if(ticketDetails.getDetailId() != null && !ticketDetails.getDetailId().isEmpty()) {
            Optional<TicketDetails> existingTicketDetail = repository.findById(ticketDetails.getDetailId());
            if(existingTicketDetail.isPresent()) {
                
                TicketDetails updatedDetails = existingTicketDetail.get();
                updatedDetails.setCheckedIn(ticketDetails.getCheckedIn());
                updatedDetails.setPricingOptionId(ticketDetails.getPricingOptionId());
                updatedDetails.setFullName(ticketDetails.getFullName());
                updatedDetails.setCheckedInBy(ticketDetails.getCheckedInBy());
                updatedDetails.setCheckedInAt(ticketDetails.getCheckedInAt());
                updatedDetails.setPaidStatus(ticketDetails.getPaidStatus());
                
                updatedDetails.setEventId(ticketDetails.getEventId());
                TicketDetails saved = repository.save(updatedDetails);
                return saved;
            }
        }
        return repository.save(ticketDetails);
    }
}
