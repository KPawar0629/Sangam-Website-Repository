package com.sangam.sangam.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "TicketDetails")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TicketDetails {
    @Id
    private String detailId;
    private String ticketId;
    private String pricingOptionId;
    private String pricingOptionName;
    private String fullName;
    private int checkedIn;
    private String checkedInBy;
    private String checkedInAt;
    private String uniqueCode;
    private double amount;
    private String ticketBought;
    private int paidStatus;
    private String eventId;
}
