package com.sangam.sangam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection="DressCompetition")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class DressCompetition {
    @Id
    private String id;
    private String category;
    private String eventId;
    private String fullName;
    private String parentName;
    private String phoneNumber;
    private String ticketCode;
}
