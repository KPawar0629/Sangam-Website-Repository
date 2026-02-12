<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
    <div>
        <p style="font-size: 22px"><strong>Dear ${rsvp.fullName},</strong></p>
        <p>Thank you for reserving your spot for the event. Below are the details of your RSVP.</p>

        <p><strong><span style="font-size:18px">Event details</span></strong></p>
        <p><strong>Event name:</strong> ${event.eventName}<br>
        <strong>Event date:</strong> ${event.eventDateTime}<br>
        <strong>Venue:</strong> ${event.eventLocation}<br></p>

        <p><strong><span style="font-size:18px">Your RSVP details:</span></strong></p>

        <table style="border-collapse: collapse; border: 2px dashed black;">
            <thead>
            <tr>
                <th style="border: 2px dashed black;">RSVP No.</th>
                <th style="border: 2px dashed black;">Number of People</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td style="border: 2px dashed black;">${rsvp.ticketMasterId}</td>
                <td style="border: 2px dashed black;">${rsvp.rsvpCount}</td>
            </tr>
            </tbody>
        </table>

        <p>Total People: ${rsvp.rsvpCount}</p>

        <#if event.notesOnTickets?? && event.notesOnTickets != "null">
        <p><strong>Notes:</strong> ${event.notesOnTickets}</p>
        </#if>

        <p><strong>Team Sangam</strong></p>
        <div style="background-color:#f9f9fa;border-radius:6px;padding:12px">
            <p style="padding:0;margin:0"><strong>Need help or have questions?</strong> <a href="mailto:sbdesis@gmail.com" target="_blank">
                Contact the event organizer</a></p>
        </div><br>
    </div>
</body>
</html>
