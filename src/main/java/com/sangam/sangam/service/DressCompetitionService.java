package com.sangam.sangam.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sangam.sangam.model.DressCompetition;
import com.sangam.sangam.repo.DressCompetitionRepository;

@Service
public class DressCompetitionService {
    @Autowired
    private DressCompetitionRepository repository;

    public void addOrUpdateEntry(DressCompetition comp) {
        Optional<DressCompetition> found = repository.findById(comp.getId());
        if(found.isPresent() && !found.isEmpty()) {
            DressCompetition updatedComp = found.get();
            updatedComp.setCategory(comp.getCategory());
            updatedComp.setEventId(comp.getEventId());
            updatedComp.setFullName(comp.getFullName());
            updatedComp.setParentName(comp.getParentName());
            updatedComp.setPhoneNumber(comp.getPhoneNumber());
            updatedComp.setTicketCode(comp.getTicketCode());

            repository.save(updatedComp);
        }

        repository.save(comp);
    }

    public Optional<DressCompetition> findById(String id) {
        return repository.findById(id);
    }

    public List<DressCompetition> findByEventId(String id) {
        return repository.findByEventId(id);
    }

    public void deleteEntry(String id) {
        repository.deleteById(id);
    }

    public List<DressCompetition> findByCategory(String category) {
        return repository.findByCategory(category);
    }
    
    public List<DressCompetition> findAll() {
        return repository.findAll();
    }
}
