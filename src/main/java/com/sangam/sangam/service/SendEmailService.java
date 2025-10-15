package com.sangam.sangam.service;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
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
import com.sangam.sangam.util.QRCodeGenerator;

import freemarker.core.ParseException;
import freemarker.template.Configuration;
import freemarker.template.MalformedTemplateNameException;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateNotFoundException;
import jakarta.activation.DataSource;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.util.ByteArrayDataSource;

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

     private String fromEmailId = "sbdesis@gmail.com";
//    private String fromEmailId = "inception.kaustubh@gmail.com";

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
            TicketMaster ticketMaster = (TicketMaster) model.getAttribute("ticket");
            
            System.out.println("Sending ticket email with QR code to: " + recipient);
            
            // Now always send the QR code version
            sendTicketEmailWithQR(ticketMaster, event);
            
            System.out.println("Ticket email with QR code sent successfully!");

        } catch (Exception e) {
            System.err.println("Error sending ticket email: " + e.getMessage());
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

    /**
     * Bulk sends ticket emails with QR codes to all PAID ticket masters for a specific event
     * Only sends to ticket holders who have completed payment (paymentReceived == 1)
     * 
     * @param eventId ID of the event to send tickets for
     * @return Map containing success count, failure count, and skipped count
     */
    public Map<String, Integer> bulkSendTicketEmailsWithQR(String eventId) {
        Map<String, Integer> result = new HashMap<>();
        result.put("success", 0);
        result.put("failure", 0);
        result.put("skipped", 0);
        
        try {
            System.out.println("Starting bulk send of ticket emails with QR codes for event: " + eventId);
            
            // Get event details
            Event event = eventService.findEventById(eventId);
            if (event == null) {
                throw new IllegalArgumentException("Event not found with ID: " + eventId);
            }
            
            // Get all ticket masters for this event
            List<TicketMaster> allTicketMasters = ticketMasterService.findTicketMasterByEventId(eventId);
            
            if (allTicketMasters == null || allTicketMasters.isEmpty()) {
                System.out.println("No ticket masters found for event: " + eventId);
                return result;
            }
            
            // Filter to only include ticket masters who have paid AND haven't received QR code yet
            List<TicketMaster> eligibleTicketMasters = new ArrayList<>();
            int unpaidCount = 0;
            int alreadySentCount = 0;
            
            for (TicketMaster ticketMaster : allTicketMasters) {
                // Check if paid
                if (ticketMaster.getPaymentReceived() != 1) {
                    unpaidCount++;
                    continue;
                }
                
                // Check if QR code already sent
                if (ticketMaster.getSentQrCode() != null && ticketMaster.getSentQrCode().equals("true")) {
                    alreadySentCount++;
                    System.out.println("Skipping (already sent QR code): " + ticketMaster.getEmail());
                    continue;
                }
                
                eligibleTicketMasters.add(ticketMaster);
            }
            
            if (eligibleTicketMasters.isEmpty()) {
                System.out.println("No eligible ticket masters found for event: " + eventId);
                System.out.println("Total: " + allTicketMasters.size() + ", Unpaid: " + unpaidCount + ", Already sent: " + alreadySentCount);
                result.put("skipped", allTicketMasters.size());
                return result;
            }
            
            System.out.println("Found " + eligibleTicketMasters.size() + " eligible ticket masters (paid & not sent yet)");
            System.out.println("Unpaid: " + unpaidCount + ", Already sent QR: " + alreadySentCount);
            
            int successCount = 0;
            int failureCount = 0;
            
            // Send email to each eligible ticket master
            for (TicketMaster ticketMaster : eligibleTicketMasters) {
                try {
                    sendTicketEmailWithQRBulk(ticketMaster, event);
                    successCount++;
                    System.out.println("Successfully sent email to: " + ticketMaster.getEmail());
                } catch (Exception e) {
                    failureCount++;
                    System.err.println("Failed to send email to: " + ticketMaster.getEmail());
                    e.printStackTrace();
                }
            }
            
            result.put("success", successCount);
            result.put("failure", failureCount);
            result.put("skipped", unpaidCount + alreadySentCount);
            
            System.out.println("Bulk email send completed. Success: " + successCount + ", Failures: " + failureCount + ", Skipped: " + (unpaidCount + alreadySentCount) + " (Unpaid: " + unpaidCount + ", Already sent: " + alreadySentCount + ")");
            
        } catch (Exception e) {
            System.err.println("Error in bulk send operation: " + e.getMessage());
            e.printStackTrace();
        }
        
        return result;
    }

    /**
     * Sends a single ticket email with QR code to a ticket master
     * 
     * @param ticketMaster The ticket master to send the email to
     * @param event The event associated with the ticket
     * @throws Exception if email sending fails
     */
    public void sendTicketEmailWithQRBulk(TicketMaster ticketMaster, Event event) throws Exception {
        String emailSubject = event.getEventName() + " Ticket - QR Code";
        
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);
        
        helper.setFrom(fromEmailId);
        helper.setTo(ticketMaster.getEmail());
        helper.setSubject(emailSubject);
        
        // Get ticket details
        List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(ticketMaster.getTicketMasterId());
        
        // Prepare model for template
        Map<String, Object> model = new HashMap<>();
        model.put("event", event);
        model.put("ticket", ticketMaster);
        model.put("details", details);
        
        // Add pricing descriptions
        HashMap<String, Object> pricingDescMap = new HashMap<>();
        for (TicketDetails detail : details) {
            try {
                String pricingDesc = eventPricingService.findEventPricingById(detail.getPricingOptionId()).getPricingDesc();
                pricingDescMap.put(detail.getPricingOptionName(), pricingDesc);
            } catch (Exception e) {
                System.err.println("Could not get pricing description for: " + detail.getPricingOptionName());
            }
        }
        model.put("descMap", pricingDescMap);
        
        // Generate QR code based on ticket master ID
        System.out.println("Generating QR code for ticket master ID: " + ticketMaster.getTicketMasterId());
        byte[] qrCodeImage = QRCodeGenerator.generateQRCodeImage(ticketMaster.getTicketMasterId(), 200, 200);
        System.out.println("QR code generated successfully, size: " + qrCodeImage.length + " bytes");
        
        // Process template
        String htmlBody = getFreeMarkerTemplateContent("email_tickets_qr_bulk.ftl", model);
        
        helper.setText(htmlBody, true);
        
        // Attach QR code as inline image with Content-ID matching the template
        DataSource qrDataSource = new ByteArrayDataSource(qrCodeImage, "image/png");
        helper.addInline("qrcode_" + ticketMaster.getTicketMasterId(), qrDataSource);
        System.out.println("QR code attached as inline image with CID: qrcode_" + ticketMaster.getTicketMasterId());
        
        mailSender.send(mimeMessage);
        System.out.println("Email sent successfully to: " + ticketMaster.getEmail());
        
        // Update ticket master to mark QR code as sent
        ticketMaster.setSentQrCode("true");
        ticketMasterService.updateTicketMaster(ticketMaster);
        System.out.println("Updated sentQrCode flag to 'true' for ticket master: " + ticketMaster.getTicketMasterId());
    }

    /**
     * Sends a single ticket email with QR code to a ticket master
     *
     * @param ticketMaster The ticket master to send the email to
     * @param event The event associated with the ticket
     * @throws Exception if email sending fails
     */
    public void sendTicketEmailWithQR(TicketMaster ticketMaster, Event event) throws Exception {
        String emailSubject = event.getEventName() + " Ticket Payment Received";

        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

        helper.setFrom(fromEmailId);
        helper.setTo(ticketMaster.getEmail());
        helper.setSubject(emailSubject);

        // Get ticket details
        List<TicketDetails> details = ticketDetailsService.findTicketDetailsByTicketId(ticketMaster.getTicketMasterId());

        // Prepare model for template
        Map<String, Object> model = new HashMap<>();
        model.put("event", event);
        model.put("ticket", ticketMaster);
        model.put("details", details);

        // Add pricing descriptions
        HashMap<String, Object> pricingDescMap = new HashMap<>();
        for (TicketDetails detail : details) {
            try {
                String pricingDesc = eventPricingService.findEventPricingById(detail.getPricingOptionId()).getPricingDesc();
                pricingDescMap.put(detail.getPricingOptionName(), pricingDesc);
            } catch (Exception e) {
                System.err.println("Could not get pricing description for: " + detail.getPricingOptionName());
            }
        }
        model.put("descMap", pricingDescMap);

        // Generate QR code based on ticket master ID
        System.out.println("Generating QR code for ticket master ID: " + ticketMaster.getTicketMasterId());
        byte[] qrCodeImage = QRCodeGenerator.generateQRCodeImage(ticketMaster.getTicketMasterId(), 200, 200);
        System.out.println("QR code generated successfully, size: " + qrCodeImage.length + " bytes");

        // Process template
        String htmlBody = getFreeMarkerTemplateContent("email_tickets_qr.ftl", model);

        helper.setText(htmlBody, true);

        // Attach QR code as inline image with Content-ID matching the template
        DataSource qrDataSource = new ByteArrayDataSource(qrCodeImage, "image/png");
        helper.addInline("qrcode_" + ticketMaster.getTicketMasterId(), qrDataSource);
        System.out.println("QR code attached as inline image with CID: qrcode_" + ticketMaster.getTicketMasterId());

        mailSender.send(mimeMessage);
        System.out.println("Email sent successfully to: " + ticketMaster.getEmail());

        // Update ticket master to mark QR code as sent
        ticketMaster.setSentQrCode("true");
        ticketMasterService.updateTicketMaster(ticketMaster);
        System.out.println("Updated sentQrCode flag to 'true' for ticket master: " + ticketMaster.getTicketMasterId());
    }
}
