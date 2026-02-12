package com.sangam.sangam.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sangam.sangam.model.Participation;
import com.sangam.sangam.repo.ParticipationRepository;

@Service
public class ParticipationService {
    @Autowired
    private ParticipationRepository repository;

    public Participation createParticipation(Participation participation) {
        return repository.save(participation);
    }

    public Optional<Participation> getParticipationById(String partiId) {
        return repository.findById(partiId);
    }

    public List<Participation> getAllParticipation() {
        return repository.findAll();
    }

    public List<Participation> getByEventId(String eventId) {
        return repository.findByEventId(eventId);
    }

    public void addOrUpdateParticipation(Participation participation) {
        Optional<Participation> found = repository.findById(participation.getParticipationId());
        if(found.isPresent() && !found.isEmpty()) {
            Participation updatedParticipation = found.get();
            updatedParticipation.setParticipatorName(participation.getParticipatorName());
            updatedParticipation.setTypeOfPerformance(participation.getTypeOfPerformance());
            updatedParticipation.setWhoWillPerform(participation.getWhoWillPerform());
            updatedParticipation.setNameOfGroup(participation.getNameOfGroup());
            updatedParticipation.setAgeGroup(participation.getAgeGroup());
            updatedParticipation.setContactPerName(participation.getContactPerName());
            updatedParticipation.setContactEmail(participation.getContactEmail());
            updatedParticipation.setContactPhone(participation.getContactPhone());
            updatedParticipation.setNotes(participation.getNotes());
            updatedParticipation.setBgNeeded(participation.getBgNeeded());
            updatedParticipation.setNoOfChairs(participation.getNoOfChairs());
            updatedParticipation.setNoOfMics(participation.getNoOfMics());

            repository.save(updatedParticipation);
        }

        repository.save(participation);
    }

    public void deleteParticipation(String partiId) {
        repository.deleteById(partiId);
    }
}
