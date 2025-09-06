package com.sangam.sangam.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "Participation")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Participation {
    @Id
    public String participationId;
    public String participatorName;
    public String typeOfPerformance;
    public String whoWillPerform;
    public String nameOfGroup;
    public String ageGroup;
    public String contactPerName;
    public String contactEmail;
    public String contactPhone;
    public String notes;
    public String eventId;
    public int bgNeeded;
    public int noOfMics;
    public int noOfChairs;
    public int checkedIn;
    public int orderNumber;
}
