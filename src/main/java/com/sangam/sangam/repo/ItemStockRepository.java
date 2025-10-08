package com.sangam.sangam.repo;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.sangam.sangam.model.ItemStock;

import java.util.List;

@Repository
public interface ItemStockRepository extends MongoRepository<ItemStock, String> {
    List<ItemStock> findByHandlerId(String handlerId);
    List<ItemStock> findByIsActive(boolean isActive);
    List<ItemStock> findByItemNameContainingIgnoreCase(String itemName);
}