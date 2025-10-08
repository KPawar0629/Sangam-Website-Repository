package com.sangam.sangam.service;

import com.sangam.sangam.model.ItemStock;
import com.sangam.sangam.repo.ItemStockRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItemStockService {

    @Autowired
    private ItemStockRepository itemStockRepository;

    public List<ItemStock> getAllItemStock() {
        return itemStockRepository.findAll();
    }

    public Optional<ItemStock> getItemStockById(String stockId) {
        return itemStockRepository.findById(stockId);
    }

    public List<ItemStock> getItemStockByHandlerId(String handlerId) {
        return itemStockRepository.findByHandlerId(handlerId);
    }

    public List<ItemStock> getActiveItemStock() {
        return itemStockRepository.findByIsActive(true);
    }

    public List<ItemStock> searchItemStockByName(String itemName) {
        return itemStockRepository.findByItemNameContainingIgnoreCase(itemName);
    }

    public ItemStock saveItemStock(ItemStock itemStock) {
        return itemStockRepository.save(itemStock);
    }

    public void deleteItemStock(String stockId) {
        itemStockRepository.deleteById(stockId);
    }

    public ItemStock updateItemStock(String stockId, ItemStock updatedItemStock) {
        Optional<ItemStock> existingItemStock = itemStockRepository.findById(stockId);
        
        if (existingItemStock.isPresent()) {
            ItemStock itemToUpdate = existingItemStock.get();
            
            // Update fields
            itemToUpdate.setItemName(updatedItemStock.getItemName());
            itemToUpdate.setItemDescription(updatedItemStock.getItemDescription());
            itemToUpdate.setPurchaseDate(updatedItemStock.getPurchaseDate());
            itemToUpdate.setPurchaseAmount(updatedItemStock.getPurchaseAmount());
            itemToUpdate.setHandlerId(updatedItemStock.getHandlerId());
            itemToUpdate.setActive(updatedItemStock.isActive());
            
            return itemStockRepository.save(itemToUpdate);
        } else {
            // If the item doesn't exist, create it with the provided ID
            updatedItemStock.setStockId(stockId);
            return itemStockRepository.save(updatedItemStock);
        }
    }
}