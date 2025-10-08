package com.sangam.sangam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "ItemStock")
public class ItemStock {
    @Id
    private String stockId;
    private String itemName;
    private String itemDescription;
    private String purchaseDate;
    private float purchaseAmount;
    private String handlerId;
    private boolean isActive;
}
