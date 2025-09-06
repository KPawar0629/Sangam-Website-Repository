package com.sangam.sangam.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "EventPricing")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventPricing {
    @Id
    private String id;
    private String eventId;
    private String pricingName;
    private String pricingDesc;
    private double pricingRate;
    private String startDate;
    private String endDate;
    private String valid;
    private String startDateFormatted;
    private String endDateFormatted;
    private String status;
}
