<!DOCTYPE html>
<html>
<head>
    <title>Kode OTP Reset Password</title>
</head>
<body style="font-family: Arial, sans-serif; color: #333; line-height: 1.6;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
        <h2 style="color: #4CAF50; text-align: center;">Reset Password</h2>
        <p>Halo,</p>
        <p>Anda menerima email ini karena kami menerima permintaan reset password untuk akun Anda di {{ config('app.name') }}.</p>
        <p>Berikut adalah kode OTP 6 digit Anda:</p>
        <div style="text-align: center; margin: 20px 0;">
            <span style="font-size: 24px; font-weight: bold; padding: 10px 20px; background-color: #f4f4f4; border-radius: 4px; letter-spacing: 2px;">
                {{ $otp }}
            </span>
        </div>
        <p>Kode ini berlaku selama 15 menit. Jika Anda tidak meminta reset password, abaikan email ini.</p>
        <p>Terima kasih,<br>{{ config('app.name') }} Team</p>
    </div>
</body>
</html>
