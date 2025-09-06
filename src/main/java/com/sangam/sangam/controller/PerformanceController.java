package com.sangam.sangam.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sangam.sangam.model.Event;
import com.sangam.sangam.model.Participation;
import com.sangam.sangam.service.EventService;
import com.sangam.sangam.service.ParticipationService;
import com.sangam.sangam.service.SendEmailService;

import freemarker.core.ParseException;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import jakarta.mail.MessagingException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class PerformanceController {

    @Autowired
    private ParticipationService participationService;
    @Autowired
    private EventService eventService;
    @Autowired
    private SendEmailService emailService;
    
    @GetMapping("/performance/{eventId}")
    public String showPerformancePage(@PathVariable String eventId, Model model) {
        Event event = eventService.findEventById(eventId);
        model.addAttribute("event", event);
        return "/performance";
    }

    @PostMapping("/performance/new/{eventId}")
    public String addPerformance(
        @PathVariable String eventId,
        @RequestParam String name,
        @RequestParam String type,
        @RequestParam String category,
        @RequestParam String groupName,
        @RequestParam String ageGroup,
        @RequestParam String contactName,
        @RequestParam String contactEmail,
        @RequestParam String contactPhone,
        @RequestParam String comments,
        @RequestParam String mics,
        @RequestParam String chairs,
        @RequestParam String bgMusic,
        @RequestParam String checkHidden,
        HttpServletResponse response,
        Model model  
    ) {
        if(checkHidden.equals("")){
            Event event = eventService.findEventById(eventId);

            if(event != null) {
                Participation participation = new Participation();
                participation.setParticipationId(UUID.randomUUID().toString().split("-")[0]);
                participation.setParticipatorName(name);
                participation.setTypeOfPerformance(type);
                participation.setWhoWillPerform(category);
                participation.setNameOfGroup(groupName);
                participation.setAgeGroup(ageGroup);
                participation.setContactPerName(contactName);
                participation.setContactEmail(contactEmail);
                participation.setContactPhone(contactPhone);
                participation.setNotes(comments);
                participation.setEventId(event.getEventId());
                if(bgMusic.equals("no")) {
                    participation.setBgNeeded(0);
                } else if (bgMusic.equals("yes")) {
                    participation.setBgNeeded(1);
                }
                participation.setNoOfChairs(Integer.parseInt(chairs));
                participation.setNoOfMics(Integer.parseInt(mics));
                
                
                participationService.addOrUpdateParticipation(participation);
                
                model.addAttribute("event", event);
                model.addAttribute("participant", participation);
                emailService.sendPerformanceEmail(participation.getContactEmail(), model);
                try {
                    String encodedMessage = URLEncoder.encode("Thanks for participating for " + event.getEventName() + " event. Please check your email for more details on additional requirements!", "UTF-8");
                    Cookie msgCookie = new Cookie("message", encodedMessage);
                    msgCookie.setHttpOnly(true);
                    msgCookie.setSecure(false);
                    msgCookie.setPath("/");
                    response.addCookie(msgCookie);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                return "redirect:/dashboard";
            }
            try {
                String encodedMessage = URLEncoder.encode("Event not found for participation. Please reload and try again!", "UTF-8");
                Cookie msgCookie = new Cookie("message", encodedMessage);
                msgCookie.setHttpOnly(true);
                msgCookie.setSecure(false);
                msgCookie.setPath("/");
                response.addCookie(msgCookie);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "redirect:/dashboard";
    }

    @GetMapping("/participation/checkin/{partiCode}")
    public String getMethodName(@PathVariable String partiCode) {
        var participation = participationService.getParticipationById(partiCode);
        if(participation.isPresent() && !participation.isEmpty()) {
            var part = participation.get();
            if(part.getCheckedIn() == 0) {
                part.setCheckedIn(1);
            } else if (part.getCheckedIn() == 1) {
                part.setCheckedIn(0);
            }
            participationService.addOrUpdateParticipation(part);
        }
        return "redirect:/participant_list";
    }

    @PostMapping("/participation/edit")
    public String editParticipation(
        @RequestParam String partiCode,
        @RequestParam String partiName,
        @RequestParam String type,
        @RequestParam String who,
        @RequestParam String group,
        @RequestParam String age,
        @RequestParam String contactName,
        @RequestParam String contactEmail,
        @RequestParam String contactPhone,
        @RequestParam String notes,
        @RequestParam String mics,
        @RequestParam String chairs,
        @RequestParam String order) {

            var participation = participationService.getParticipationById(partiCode);
            if(participation.isPresent() && !participation.isEmpty()) {
                var parti = participation.get();
                parti.setParticipatorName(partiName);
                parti.setTypeOfPerformance(type);
                parti.setWhoWillPerform(who);
                parti.setNameOfGroup(group);
                parti.setAgeGroup(age);
                parti.setContactPerName(contactName);
                parti.setContactEmail(contactEmail);
                parti.setContactPhone(contactPhone);
                parti.setNotes(notes);
                try {
                    parti.setNoOfMics(Integer.parseInt(mics));
                    parti.setNoOfChairs(Integer.parseInt(chairs));
                    parti.setOrderNumber(Integer.parseInt(order));
                } catch (Exception e) {
                    
                }
                
                participationService.addOrUpdateParticipation(parti);
            }
            
            return "redirect:/participant_list";
    }

    @GetMapping("participation/details/send")
    public String sendBulkParticipationDetails() throws TemplateNotFoundException, MalformedTemplateNameException, ParseException, MessagingException, IOException, TemplateException {
        sendBulkEmailsParticipation();
        return "redirect:/participant_list";
    }

    @Async
    public void sendBulkEmailsParticipation() throws TemplateNotFoundException, MalformedTemplateNameException, ParseException, MessagingException, IOException, TemplateException {
        var participations = participationService.getAllParticipation();
        for(var participation : participations) {
            emailService.sendPerformanceDetailsEmail(participation.participationId, participation.getEventId());
        }
    }
    
}
