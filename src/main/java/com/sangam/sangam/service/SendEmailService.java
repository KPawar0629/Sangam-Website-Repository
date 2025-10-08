package com.sangam.sangam.service;

import java.io.IOException;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import com.sangam.sangam.model.Event;
import com.sangam.sangam.model.TicketMaster;
import com.sangam.sangam.model.TicketDetails;

import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class SendEmailService {
    @Autowired
    private JavaMailSender mailSender;
    @Autowired
    private EventService eventService;
    @Autowired
    private TicketMasterService ticketMasterService;
    @Autowired
    private TicketDetailsService ticketDetailsService;
    @Autowired
    private Configuration freemarkerConfig;
    @Autowired
    private EventPricingService eventPricingService;
    @Autowired
    private ParticipationService participationService;

    @Autowired
    private FreeMarkerConfigurer freeMarkerConfigurer;

    // private String fromEmailId = "sbdesis@gmail.com";
    private String fromEmailId = "inception.kaustubh@gmail.com";

    @Async
    public void sendPaymentEmailAsync(String recipient, Model model) {
        sendPaymentEmail(recipient, model);
    }

    @Async
    public void sendPaymentEmail(String recipient, Model model) {
        try {
            Event event = (Event) model.getAttribute("event");
            String emailSubject = event.getEventName() + " Tickets Reservation!";

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);

            mimeMessageHelper.setFrom(fromEmailId);
            mimeMessageHelper.setTo(recipient);
            mimeMessageHelper.setSubject(emailSubject);

            Map<String, Object> modelMap = model.asMap();
            String htmlBody = getFreeMarkerTemplateContent("email_payment.ftl", modelMap);
            System.out.println("Back from template");
            mimeMessageHelper.setText(htmlBody, true);
            mailSender.send(mimeMessage);
            System.out.println("Sent email");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Async
    public void sendUserCreateEmail(Model model) {
        try {
            Event event = (Event) model.getAttribute("event");
            String emailSubject = "Sangam Web : New User Registered!";

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);

            mimeMessageHelper.setFrom(fromEmailId);
            mimeMessageHelper.setTo("sbdesis@gmail.com");
            mimeMessageHelper.setSubject(emailSubject);

            Map<String, Object> modelMap = model.asMap();
            String htmlBody = getFreeMarkerTemplateContent("email_user_created.ftl", modelMap);
            mimeMessageHelper.setText(htmlBody, true);
            mailSender.send(mimeMessage);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    @Async
    public void sendPaymentReminder(String masterId, String eventId) {
        try {
            Event event = eventService.findEventById(eventId);
            TicketMaster ticket = ticketMasterService.findTicketMasterById(masterId);
            List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(masterId);
            
            String emailSubject = "Payment Reminder: " + event.getEventName() + " Tickets!";

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);

            mimeMessageHelper.setFrom(fromEmailId);
            mimeMessageHelper.setTo(ticket.getEmail());
            mimeMessageHelper.setSubject(emailSubject);

            Map<String, Object> model = new HashMap<>();
            model.put("event", event);
            model.put("ticket", ticket);
            model.put("details", details);
            
            HashMap<String, Object> pricingDescMap = new HashMap<>();
            for(TicketDetails detail : details) {
                String pricingDesc = eventPricingService.findEventPricingById(detail.getPricingOptionId()).getPricingDesc();
                pricingDescMap.put(detail.getPricingOptionName(), pricingDesc);
            }
            model.put("descMap", pricingDescMap);

            String htmlBody = getFreeMarkerTemplateContent("email_payment.ftl", model);
            mimeMessageHelper.setText(htmlBody, true);
            mailSender.send(mimeMessage);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Async
    public void sendTicketEmail(String recipient, Model model) {
        try {
            Event event = (Event) model.getAttribute("event");
            String emailSubject = event.getEventName() + " Ticket Payment Received!";
            System.out.println("Sending ticket email!");
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
            System.out.println("Sending ticket email! 2");

            helper.setFrom(fromEmailId);
            helper.setTo(recipient);
            helper.setSubject(emailSubject);
            System.out.println("Sending ticket email! 3");

            Map<String, Object> modelMap = model.asMap();
            String htmlBody = getFreeMarkerTemplateContent("email_tickets.ftl", modelMap);
            System.out.println("Back from template now!");
            System.out.println("Sending ticket email! 4");

            helper.setText(htmlBody, true);
            mailSender.send(mimeMessage);
            System.out.println("And sent now!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Async
    public void sendPerformanceEmail(String recipient, Model model) {
        try {
            Event event = (Event) model.getAttribute("event");
            String emailSubject = event.getEventName() + " Participation Entry Received!";

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

            helper.setFrom(fromEmailId);
            helper.setTo(recipient);
            helper.setSubject(emailSubject);

            Map<String, Object> modelMap = model.asMap();
            String htmlBody = getFreeMarkerTemplateContent("email_performance.ftl", modelMap);

            helper.setText(htmlBody, true);
            mailSender.send(mimeMessage);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Async
    public void sendPerformanceDetailsEmail(String partiId, String eventId) throws MessagingException, TemplateNotFoundException, MalformedTemplateNameException, ParseException, IOException, TemplateException {
        Event event = (Event) eventService.findEventById(eventId);
        var participation = participationService.getParticipationById(partiId).get();
        String emailSubject = event.getEventName() + " Participation Details!";

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

        helper.setFrom(fromEmailId);
        helper.setTo(participation.getContactEmail());
        helper.setSubject(emailSubject);

        Map<String, Object> model = new HashMap<>();
        model.put("event", event);
        model.put("participant", participation);

        Template template = freemarkerConfig.getTemplate("email_performance_sequence.ftl");
        StringWriter stringWriter = new StringWriter();
        template.process(model, stringWriter);
        String htmlBody = stringWriter.getBuffer().toString();
        helper.setText(htmlBody, true);
        mailSender.send(mimeMessage);
    }

    @Async
    public void sendRsvpEmail(String recipient, Map<String, Object> model) {
        try {
            Event event = (Event) model.get("event");
            String emailSubject = "RSVP Confirmation for " + event.getEventName();

            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);

            mimeMessageHelper.setFrom(fromEmailId);
            mimeMessageHelper.setTo(recipient);
            mimeMessageHelper.setSubject(emailSubject);

            String htmlBody = getFreeMarkerTemplateContent("email_rsvp.ftl", model);
            mimeMessageHelper.setText(htmlBody, true);
            mailSender.send(mimeMessage);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    private String getFreeMarkerTemplateContent(String templateName, Map<String, Object> model) throws MessagingException {
        try {
            System.out.println("In template now!");
            var template = freeMarkerConfigurer.getConfiguration().getTemplate(templateName);
            return FreeMarkerTemplateUtils.processTemplateIntoString(template, model);
        } catch (Exception e) {
            throw new MessagingException("Failed to process FreeMarker template", e);
        }
    }
}
