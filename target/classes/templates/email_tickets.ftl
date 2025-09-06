<html>
    <div>
        <p style="font-size: 22px"><strong>Dear ${ticket.fullName},</strong></p>
        <p>We received payments for your tickets. Below are the ticket details. DO NOT share ticket code with anyone. Ticket codes will be used to check you in at the registration desk on the event day.</p>

        <p><strong><span style="font-size:18px">Event details:</span></strong></p>
        <p><strong>Event name:</strong> ${event.eventName}<br><strong>Event date:</strong> ${event.eventDateTime}<br><strong>Venue:</strong> ${event.eventLocation}<br></p>

        <p><strong><span style="font-size:18px">Your tickets:</span></strong></p>

        <table style="border-collapse: collapse; border: 2px dashed black;">
            <thead>
            <tr>
                <th style="border: 2px dashed black;">Ticket No.</th>
                <th style="border: 2px dashed black;">Ticket Type</th>
                <th style="border: 2px dashed black;">Ticket Code</th>
            </tr>
            </thead>
            <tbody>
        <#list details as detail>
            
            <tr>
            <td style="border: 2px dashed black;">Ticket #${(detail_index +1)}</td>
            <td style="border: 2px dashed black;">${detail.pricingOptionName}<br>${descMap[detail.pricingOptionName]}</td>
            <td style="border: 2px dashed black;">${detail.uniqueCode}</td>
            </tr>                        
        </#list>
            </tbody>
        </table>

        <p>Total Amount: $${ticket.totalAmount}</p>

        <p><strong>Disclaimer:</strong><br>
All Sales are FINAL.<br>

All tickets are NON-REFUNDABLE and NON-TRANSFERABLE.<br>
<br>

<strong>Liability Waiver:</strong><br><br>
By purchasing this ticket, you agree to attend the event at your own risk. The organizers, volunteers, and venue management shall not be held responsible for any injury, loss, theft, damage to personal property, or other incidents that may occur before, during, or after the event.<br><br>

Attendees are responsible for their own safety and belongings. Children must be supervised by a parent or guardian at all times.<br>

</p>

        <p><strong>Team Sangam</strong></p>
        
        
    </div>
</html>