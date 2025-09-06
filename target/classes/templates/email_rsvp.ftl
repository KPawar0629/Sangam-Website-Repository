<html>
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

        <div class="content">
        <h2>Food Options (Pre-Order by March 8th, 2025)</h2>

        <div class="food-info">
            <h3>Veggie Combo (Prepaid)</h3>
            <ul>
                <li>Price: $12.00</li>
                <li>Includes: Vegetable Biryani, Raita, Samosas, Jalebi</li>
            </ul>
        </div>

        <div class="food-info">
            <h3>Non-Veg Combo (Prepaid)</h3>
            <ul>
                <li>Price: $14.00</li>
                <li>Includes: Chicken Biryani, Raita, Samosas, Jalebi</li>
            </ul>
        </div>

        <h3>Payment Options</h3>
        <div class="payment-options">
            <ul>
                <li>Venmo/Zelle to <strong>408-373-7372</strong> (Add Description: <em>Holi2025</em> - <em>RSVP NAME</em>)</li>
                <li>Cash at Masala Spice Restaurant</li>
                <li>Credit Card at Masala Spice Restaurant (Note: $3 surcharge per transaction)</li>
            </ul>
        </div>

        <div class="onsite-prices mb-4">
            <h2>Onsite Prices</h2>
            <ul>
                <li>Veggie Combo: $14.00</li>
                <li>Non-Veg Combo: $16.00</li>
                <li>Lassi: $4.00 (Available Flavors: Mango, Sweet, Salted, Rose Milk, Thandai)</li>
            </ul>
        </div>

        <div class="free-items">
            <h3>FREE Offerings: <h6>***FIRST COME, FIRST SERVE***</h6></h3>
            <ul>
                <li>Colors (1 per adult - Additional colors can be brought or purchased)</li>
                <li>Tea</li>
                <li>Water</li>
                <li>Bollywood Music</li>
            </ul>
        </div>
        </div>

        <p><strong>Team Sangam</strong></p>
        <div style="background-color:#f9f9fa;border-radius:6px;padding:12px">
            <p style="padding:0;margin:0"><strong>Need help or have questions?</strong> <a href="mailto:inception.kaustubh@gmail.com" target="_blank">
                Contact the event organizer</a></p>
        </div><br>
    </div>
</html>
