<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f0f0f0;">
  <div style="max-width: 600px; margin: 20px auto; background-color: #ffffff; border: 2px solid #d9534f; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
    
    <div style="padding: 20px 30px; background-color: #d9534f; color: #ffffff; text-align: center;">
        <h1 style="margin: 0; font-size: 24px;">⚠️ SECURITY ALERT ⚠️</h1>
    </div>

    <div style="padding: 30px;">
      <h2 style="font-size: 22px; color: #c9302c; margin-top: 0; margin-bottom: 20px; text-align: center;">New User Account Created</h2>
      
      <p style="font-size: 16px; color: #333; line-height: 1.6;">A new user account has been registered in the system. Please review the details below immediately.</p>
      
      <h3 style="font-size: 18px; color: #333333; border-bottom: 2px solid #eeeeee; padding-bottom: 10px; margin-top: 25px; margin-bottom: 15px;">User Details</h3>
      <table style="width: 100%; border-collapse: collapse;">
        <tbody>
          <tr>
            <td style="padding: 12px; border: 1px solid #ddd; background-color: #f9f9f9; font-size: 16px; width: 30%;"><strong>User Name:</strong></td>
            <td style="padding: 12px; border: 1px solid #ddd; font-size: 16px;">${user.fullName}</td>
          </tr>
          <tr>
            <td style="padding: 12px; border: 1px solid #ddd; background-color: #f9f9f9; font-size: 16px;"><strong>Email:</strong></td>
            <td style="padding: 12px; border: 1px solid #ddd; font-size: 16px;">${user.email}</td>
          </tr>
          <tr>
            <td style="padding: 12px; border: 1px solid #ddd; background-color: #f9f9f9; font-size: 16px;"><strong>Phone:</strong></td>
            <td style="padding: 12px; border: 1px solid #ddd; font-size: 16px;">${user.phone}</td>
          </tr>
        </tbody>
      </table>

      <div style="margin-top: 30px; padding: 15px; background-color: #fff3cd; border-left: 5px solid #ffeeba; color: #856404; font-size: 16px; line-height: 1.6;">
        <p style="margin: 0;"><strong>ACTION REQUIRED:</strong> If you do not recognize this user or suspect unauthorized activity, please take immediate action to secure the account.</p>
      </div>
    </div>

    <div style="background-color:#f1f1f1; border-top: 1px solid #dddddd; padding: 20px 30px; text-align: center;">
      <p style="margin: 0; font-size: 14px; color: #666666;">This is an automated security notification.</p>
    </div>
  </div>
</body>