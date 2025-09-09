<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden;">
    
    <div style="padding: 20px 30px; background-color: #4a5568; color: #ffffff; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">${event.eventName}</h1>
        <h2 style="margin: 10px 0 0 0; font-size: 20px; font-weight: normal;">Ticket Reservation</h2>
    </div>

    <div style="padding: 30px;">
      <p style="font-size: 18px; color: #333333; margin-bottom: 25px;"><strong>Dear ${ticket.fullName},</strong></p>

      <p style="font-size: 16px; color: #555555; line-height: 1.6;">Thank you for your reservation. We have received your payment and your tickets are confirmed. Below is a summary of your transaction.</p>
      
      <#if event.notesOnTickets?has_content>
        <p style="font-size: 15px; color: #555555; line-height: 1.6; background-color: #e9f5ff; border-left: 4px solid #007bff; padding: 15px; margin: 20px 0;">${event.notesOnTickets}</p>
      </#if>

      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Event Details</h2>
      <p style="font-size: 16px; color: #555555; line-height: 1.7;">
        <strong>Event:</strong> ${event.eventName}<br>
        <strong>Date:</strong> ${event.eventDateTime}<br>
        <strong>Venue:</strong> ${event.eventLocation}<br>
      </p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Your Ticket Reservation Summary</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
          <tr>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Ticket No.</th>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Ticket Type</th>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: right; font-size: 14px; color: #333;">Amount</th>
          </tr>
        </thead>
        <tbody>
      <#list details as detail>    
          <tr>
            <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">Ticket #${(detail_index +1)}</td>
            <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">
                <strong>${detail.pricingOptionName}</strong>
                <#if descMap[detail.pricingOptionName]?? && descMap[detail.pricingOptionName]?has_content>
                    <br><span style="font-size: 13px; color: #6c757d;">${descMap[detail.pricingOptionName]}</span>
                </#if>
            </td>
            <td style="border: 1px solid #dee2e6; padding: 12px; text-align: right; font-size: 16px;">$${detail.amount}</td>
          </tr>                            
      </#list>
        </tbody>
      </table>
      <div style="text-align: right; margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 6px;">
        <strong style="font-size: 20px; color: #28a745;">Total Amount: $${ticket.totalAmount}</strong>
      </div>

      <p style="margin-top: 30px; font-size: 16px; color: #555555;"><strong>Team Sangam</strong></p> 
    </div>

    <div style="background-color:#f1f1f1; border-top: 1px solid #dddddd; padding: 20px 30px; text-align: center;">
      <p style="margin: 0; font-size: 14px; color: #666666;"><strong>Need help or have questions?</strong> <a href="mailto:sbdesis@gmail.com" target="_blank" style="color: #007bff; text-decoration: none;">
            Contact the event organizer</a></p>
    </div>
  </div>
</body>
</html>