<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden;">
    
    <div style="padding: 20px 30px; background-color: #4a5568; color: #ffffff; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">Your Event Tickets</h1>
    </div>

    <div style="padding: 30px;">
      <p style="font-size: 18px; color: #333333; margin-bottom: 25px;"><strong>Dear ${ticket.fullName},</strong></p>

      <p style="font-size: 16px; color: #555555; line-height: 1.6;">We have received payment for your tickets. Below are your ticket details. <strong>DO NOT share these ticket codes with anyone.</strong> They will be used to check you in at the registration desk on the event day.</p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Event Details</h2>
      <p style="font-size: 16px; color: #555555; line-height: 1.7;">
        <strong>Event:</strong> ${event.eventName}<br>
        <strong>Date:</strong> ${event.eventDateTime}<br>
        <strong>Venue:</strong> ${event.eventLocation}<br>
      </p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Your Tickets</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
          <tr>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Ticket No.</th>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Ticket Type</th>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Ticket Code</th>
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
            <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; font-family: 'Courier New', Courier, monospace;"><strong>${detail.uniqueCode}</strong></td>
          </tr>                        
      </#list>
        </tbody>
      </table>
      <div style="text-align: right; margin-top: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 6px;">
        <strong style="font-size: 20px; color: #28a745;">Total Amount: $${ticket.totalAmount}</strong>
      </div>

      <div style="margin-top: 30px; padding: 20px; background-color: #fffbe6; border-left: 4px solid #ffc107; font-size: 15px; color: #555555; line-height: 1.6;">
        <h3 style="font-size: 18px; color: #333333; margin-top: 0; margin-bottom: 15px;">Disclaimer & Liability Waiver</h3>
        <p style="margin: 0 0 10px 0;">All sales are FINAL. All tickets are NON-REFUNDABLE and NON-TRANSFERABLE.</p>
        <p style="margin: 0 0 10px 0;">By purchasing this ticket, you agree to attend the event at your own risk. The organizers, volunteers, and venue management shall not be held responsible for any injury, loss, theft, damage to personal property, or other incidents that may occur before, during, or after the event.</p>
        <p style="margin: 0;">Attendees are responsible for their own safety and belongings. Children must be supervised by a parent or guardian at all times.</p>
      </div>

      <!-- Nonprofit Information -->
      <div style="text-align: center; margin-top: 25px; margin-bottom: 25px;">
        <div style="background-color: #d1ecf1; border: 1px solid #bee5eb; color: #0c5460; padding: 15px; border-radius: 6px; display: inline-block; max-width: 500px;">
          <div style="font-weight: bold; margin-bottom: 8px;">SANGAM Santa Barbara Inc. is a 501(c)(3) Non-Profit Public Organization.</div>
          <div style="font-size: 13px; color: #6c757d; margin-bottom: 5px;">Federal Tax ID: 39-3121864</div>
          <div style="font-size: 13px; color: #6c757d;">Your contributions support our community programs.</div>
        </div>
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