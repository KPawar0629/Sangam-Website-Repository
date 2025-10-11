# Bulk Email with QR Code Feature - Implementation Guide

## Overview
A new feature has been added to send ticket confirmation emails with QR codes in bulk to all ticket holders for a specific event.

## Files Created/Modified

### 1. New Utility Class: `QRCodeGenerator.java`
**Location:** `src/main/java/com/sangam/sangam/util/QRCodeGenerator.java`

This utility class generates QR code images using the ZXing library (already in dependencies).

**Key Method:**
```java
public static byte[] generateQRCodeImage(String text, int width, int height)
```
- Generates a PNG QR code image as a byte array
- Uses high error correction level for better scanning reliability
- UTF-8 character encoding support

### 2. Modified Service: `SendEmailService.java`
**Location:** `src/main/java/com/sangam/sangam/service/SendEmailService.java`

**New Methods Added:**

#### `bulkSendTicketEmailsWithQR(String eventId)`
- **Purpose:** Bulk sends ticket emails with QR codes to all ticket masters for a specific event
- **Parameters:** 
  - `eventId` - ID of the event
- **Features:**
  - Retrieves all ticket masters for the event
  - Sends individual emails with QR codes
  - Provides detailed logging of success/failure counts
  - Handles errors gracefully (continues even if some emails fail)

#### `sendTicketEmailWithQR(TicketMaster ticketMaster, Event event)` (Private)
- Sends a single email with QR code to one ticket master
- Generates QR code based on ticket master ID
- Embeds QR code as inline image in the email
- Uses the `email_tickets_qr.ftl` template

### 3. New Email Template: `email_tickets_qr.ftl`
**Location:** `src/main/resources/templates/email_tickets_qr.ftl`

Similar to `email_tickets.ftl` but includes:
- One prominent QR code (200x200px) at the top of the email
- QR code represents the ticket master ID for check-in purposes
- Clean, professional styling

## How to Use

### Option 1: From a Controller
Add this method to any controller (e.g., `TicketMasterController.java`):

```java
@GetMapping("/tickets/send-qr-emails/{eventId}")
public String sendBulkTicketEmailsWithQR(@PathVariable String eventId, RedirectAttributes redirectAttributes) {
    try {
        emailService.bulkSendTicketEmailsWithQR(eventId);
        redirectAttributes.addFlashAttribute("message", "Bulk ticket emails with QR codes are being sent!");
    } catch (Exception e) {
        redirectAttributes.addFlashAttribute("error", "Failed to send emails: " + e.getMessage());
    }
    return "redirect:/payment_list?eventId=" + eventId;
}
```

### Option 2: Programmatic Call
```java
@Autowired
private SendEmailService emailService;

// Send bulk emails for a specific event
emailService.bulkSendTicketEmailsWithQR("your-event-id-here");
```

## QR Code Data Format
The QR code contains the **Ticket Master ID** which can be used for:
- Quick check-in at the event
- Ticket verification
- Attendance tracking

Example QR code data: `a1b2c3d4` (the ticketMasterId)

## Email Content
Each email includes:
1. **QR Code** - One large QR code for the ticket master
2. **Event Details** - Event name, date, and location
3. **Ticket List** - All tickets purchased under this ticket master with:
   - Ticket number
   - Ticket type
   - Unique ticket code
4. **Total Amount** - Total payment received
5. **Disclaimer** - Liability waiver and refund policy
6. **Nonprofit Information** - Sangam organization details

## Technical Details

### Dependencies Used
- **ZXing (Google)** - QR code generation (already in pom.xml)
  - `com.google.zxing:core:3.5.2`
  - `com.google.zxing:javase:3.5.2`
- **Jakarta Mail** - Email sending with inline images
- **FreeMarker** - HTML template processing

### Email Format
- Inline image attachment (QR code embedded in email body)
- Content-ID based embedding for better email client compatibility
- PNG format for QR codes

### Error Handling
- Continues processing even if individual emails fail
- Logs success and failure counts
- Detailed error messages in console

## Testing

To test the feature:

1. **Create a test endpoint** (or use existing admin panel)
2. **Call the method** with a valid event ID
3. **Check logs** for processing status
4. **Verify emails** are received with QR codes
5. **Test QR code scanning** with any QR scanner app

## Future Enhancements

Possible improvements:
- Add UI button in the payment list page to trigger bulk send
- Add email sending progress tracking
- Store email sending history
- Allow filtering (e.g., only send to unpaid/paid customers)
- Customizable QR code data format
- QR code scanning interface for check-in

## Notes
- The method is `@Async`, so it runs in the background
- QR codes are 200x200 pixels for optimal scanning
- Uses high error correction level (Level H) for reliability
- Each QR code is unique per ticket master
