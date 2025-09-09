<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4;">
  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); overflow: hidden;">
    
    <div style="padding: 20px 30px; background-color: #4a5568; color: #ffffff; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">Performance Confirmation</h1>
    </div>

    <div style="padding: 30px;">
      <p style="font-size: 18px; color: #333333; margin-bottom: 25px;"><strong>Dear ${participant.contactPerName},</strong></p>

      <p style="font-size: 16px; color: #555555; line-height: 1.6;">Thank you for participating in the ${event.eventName} and helping to make it more enjoyable. Below are the details of your performance entry.</p>
      
      <h2 style="font-size: 20px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 30px; margin-bottom: 20px;">Your Participation Details</h2>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tbody>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa; width: 40%;"><strong>Participation Code</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.participationId}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Performer Name</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.participatorName}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Type of Performance</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.typeOfPerformance}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Category</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.whoWillPerform}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Group Name</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.nameOfGroup}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Age Group</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.ageGroup}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Contact Person</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.contactPerName}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Email</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.contactEmail}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Phone</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.contactPhone}</td>
            </tr>
            <tr>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px; background-color: #f8f9fa;"><strong>Comments</strong></td>
                <td style="border: 1px solid #dee2e6; padding: 12px; font-size: 16px;">${participant.notes}</td>
            </tr>
        </tbody>
      </table>

      <div style="font-size: 15px; color: #555555; line-height: 1.6; background-color: #e9f5ff; border-left: 4px solid #007bff; padding: 15px; margin: 20px 0;">
        <p style="margin:0 0 10px 0;">Please upload your performance mp3 file to the link below if needed before ${event.participationEndDate}.</p>
        <p style="margin:0 0 10px 0;">File should be named as: <strong>"Participant Name_Participant Id".mp3</strong></p>
        <p style="margin:0;"><a href="https://drive.google.com/drive/folders/1S5FZSSas9F_ENPxsiGdyIGSddp40fnjo?usp=sharing" style="color: #0056b3; text-decoration: none; font-weight: bold;">Upload Performance File</a></p>
      </div>

      <p style="margin-top: 30px; font-size: 16px; color: #555555;"><strong>Sangam Entertainment Team</strong></p> 
    </div>

    <div style="background-color:#f1f1f1; border-top: 1px solid #dddddd; padding: 20px 30px; text-align: center;">
      <p style="margin: 0; font-size: 14px; color: #666666;"><strong>Need help or have questions?</strong> <a href="mailto:inception.kaustubh@gmail.com" target="_blank" style="color: #007bff; text-decoration: none;">
            Contact the event organizer</a></p>
    </div>
  </div>
</body>
</html>