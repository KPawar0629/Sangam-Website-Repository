<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden;">
    
    <div style="padding: 20px 30px; background-color: #4a5568; color: #ffffff; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">RSVP Confirmation</h1>
    </div>

    <div style="padding: 30px;">
      <p style="font-size: 18px; color: #333333; margin-bottom: 25px;"><strong>Dear ${rsvp.fullName},</strong></p>

      <p style="font-size: 16px; color: #555555; line-height: 1.6;">Thank you for reserving your spot for the event. Below are the details of your RSVP.</p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Event Details</h2>
      <p style="font-size: 16px; color: #555555; line-height: 1.7;">
        <strong>Event:</strong> ${event.eventName}<br>
        <strong>Date:</strong> ${event.eventDateTime}<br>
        <strong>Venue:</strong> ${event.eventLocation}<br>
      </p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Your RSVP Details</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
          <tr>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">RSVP No.</th>
            <th style="background-color: #f8f9fa; border: 1px solid #dee2e6; padding: 12px; text-align: left; font-size: 14px; color: #333;">Number of People</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${rsvp.ticketMasterId}</td>
            <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${rsvp.rsvpCount}</td>
          </tr>                            
        </tbody>
      </table>

      <div style="margin-top: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 6px;">
        <h2 style="font-size: 20px; color: #333333; margin-top: 0; margin-bottom: 15px;">Food Options (Pre-Order by March 8th, 2025)</h2>
        
        <div style="margin-bottom: 15px;">
            <h3 style="font-size: 17px; margin: 0 0 5px 0;">Veggie Combo (Prepaid) - $12.00</h3>
            <p style="margin: 0; color: #6c757d; font-size: 15px;">Includes: Vegetable Biryani, Raita, Samosas, Jalebi</p>
        </div>

        <div style="margin-bottom: 20px;">
            <h3 style="font-size: 17px; margin: 0 0 5px 0;">Non-Veg Combo (Prepaid) - $14.00</h3>
            <p style="margin: 0; color: #6c757d; font-size: 15px;">Includes: Chicken Biryani, Raita, Samosas, Jalebi</p>
        </div>

        <h3 style="font-size: 17px; margin: 15px 0 5px 0;">Payment Options</h3>
        <ul style="margin: 0; padding-left: 20px; font-size: 15px; color: #555555; line-height: 1.6;">
            <li>Venmo/Zelle to <strong>408-373-7372</strong> (Add Description: <em>Holi2025</em> - <em>RSVP NAME</em>)</li>
            <li>Cash at Masala Spice Restaurant</li>
            <li>Credit Card at Masala Spice Restaurant (Note: $3 surcharge per transaction)</li>
        </ul>
      </div>

      <div style="margin-top: 20px; padding: 20px; background-color: #fffbe6; border-left: 4px solid #ffc107; font-size: 15px; color: #555555;">
        <h2 style="font-size: 20px; color: #333333; margin-top: 0; margin-bottom: 15px;">Onsite Prices & Free Offerings</h2>
        <ul style="margin: 0; padding-left: 20px; line-height: 1.6;">
            <li>Veggie Combo: $14.00</li>
            <li>Non-Veg Combo: $16.00</li>
            <li>Lassi: $4.00 (Mango, Sweet, Salted, Rose Milk, Thandai)</li>
            <li><strong>FREE:</strong> Colors, Tea, Water, Bollywood Music (First come, first serve)</li>
        </ul>
      </div>

      <p style="margin-top: 30px; font-size: 16px; color: #555555;"><strong>Team Sangam</strong></p> 
    </div>

    <div style="background-color:#f1f1f1; border-top: 1px solid #dddddd; padding: 20px 30px; text-align: center;">
      <p style="margin: 0; font-size: 14px; color: #666666;"><strong>Need help or have questions?</strong> <a href="mailto:inception.kaustubh@gmail.com" target="_blank" style="color: #007bff; text-decoration: none;">
            Contact the event organizer</a></p>
    </div>
  </div>
</body>
</html>
