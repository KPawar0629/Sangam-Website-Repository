package com.sangam.sangam.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "Events")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Event {
    @Id
    private String eventId;
    private String eventName;
    private String eventDescription;
    private String eventLocation;
    private String eventDateTime;
    private String eventDateTimeOrig;
    private String eventCreatedBy;
    private String eventCreatedAt;
    private String notesOnTickets;
    private String lastModifiedBy;
    private String lastModifiedAt;
    private int published;
    private String publishedBy;
    private String publishedAt;
    private String status;
    private String eventDateTimeLanding;
    private int participationAllowed;
    private String participationStartDate;
    private String participationEndDate;
    private String partiStatus;
    private String eventType;
    private String rsvpYes;
    private Integer rsvpCount;
    private String rsvpStartDate;
    private String rsvpEndDate;
    private String imageUrl;
}
