package com.sangam.sangam.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "TicketMasters")
public class TicketMaster {
    @Id
    private String ticketMasterId;
    private String eventId;
    private String dateBought;
    private String fullName;
    private String email;
    private double totalAmount;
    private int totalTickets;
    private int paymentReceived;
    private String paymentReceivedBy;
    private String paymentReceivedAt;
    private String phoneNumber;
    private boolean isRsvp;
    private int rsvpCount;
    private String sentQrCode; // "true" if QR code email sent, empty/null otherwise
}