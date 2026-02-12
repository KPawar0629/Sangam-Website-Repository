<html>
<div>
  <p><strong><span style="font-size:22px">Dear ${ticket.fullName},</span></strong></p>

  <p>${event.notesOnTickets}</p>

  <p><strong><span style="font-size:18px">Event details</span></strong></p>
  <p>
    <strong>Event name: </strong> ${event.eventName}<br>
    <strong>Event date: </strong> ${event.eventDateTime}<br>
    <strong>Venue:</strong> ${event.eventLocation}<br>
  </p>
  
  <p><strong><span style="font-size:18px">Your Ticket Reservation Summary</span></strong></p>
  <table style="border-collapse: collapse; border: 2px dashed black;">
    <thead>
      <tr>
        <th style="border: 2px solid black;">Ticket No.</th>
        <th style="border: 2px solid black;">Ticket Type</th>
        <th style="border: 2px solid black;">Amount</th>
      </tr>
    </thead>
    <tbody>
  <#list details as detail>    
      <tr>
        <td style="border: 2px solid black;">Ticket #${(detail_index +1)}</td>
        <td style="border: 2px solid black;">${detail.pricingOptionName}<br>${descMap[detail.pricingOptionName]}</td>
        <td style="border: 2px solid black;">$${detail.amount}</td>
      <tr>                            
  </#list>
    </tbody>
  </table>
  <p>
  <strong>Total Amount: $${ticket.totalAmount}</strong>
  </p>

  <p><strong>Team Sangam</strong></p> 

  <div style="background-color:#f9f9fa;border-radius:6px;padding:12px">
  <p><strong>Need help or have questions?</strong> <a href="mailto:sbdesis@gmail.com" target="_blank">
        Contact the event organizer</a></p>
  <br>
  </div>
  
  
</div>
</html>