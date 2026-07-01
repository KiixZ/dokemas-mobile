<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Mail\ResetPasswordOtpMail;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;

class PasswordResetController extends Controller
{
    /**
     * Lupa Password
     * 
     * Request OTP untuk mereset password. OTP akan dikirimkan ke email pengguna.
     * 
     * @tags Auth
     * @unauthenticated
     */
    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email', 'exists:users,email'],
        ]);

        $email = $request->email;

        // Generate 6 digit OTP
        $otp = str_pad(random_int(100000, 999999), 6, '0', STR_PAD_LEFT);

        // Delete existing token if any
        DB::table('password_reset_tokens')->where('email', $email)->delete();

        // Insert new OTP
        DB::table('password_reset_tokens')->insert([
            'email' => $email,
            'token' => Hash::make($otp),
            'created_at' => Carbon::now(),
        ]);

        // Send Email
        Mail::to($email)->send(new ResetPasswordOtpMail($otp));

        return response()->json([
            'message' => 'Instruksi reset password telah dikirim ke email Anda.'
        ]);
    }

    /**
     * Verifikasi OTP Reset Password
     * 
     * Memeriksa apakah OTP yang dimasukkan valid dan belum kedaluwarsa (berlaku 15 menit).
     * 
     * @tags Auth
     * @unauthenticated
     */
    public function verifyOtp(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email'],
            'otp' => ['required', 'string', 'size:6'],
        ]);

        $this->validateOtp($request->email, $request->otp);

        return response()->json([
            'message' => 'OTP valid.'
        ]);
    }

    /**
     * Reset Password
     * 
     * Mengatur ulang password menggunakan OTP yang valid.
     * 
     * @tags Auth
     * @unauthenticated
     */
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => ['required', 'email'],
            'otp' => ['required', 'string', 'size:6'],
            'password' => ['required', 'confirmed', Password::min(6)],
        ]);

        $email = $request->email;
        $otp = $request->otp;

        // Validasi OTP
        $this->validateOtp($email, $otp);

        // Update User Password
        $user = User::where('email', $email)->first();
        if (!$user) {
            throw ValidationException::withMessages([
                'email' => ['Pengguna tidak ditemukan.'],
            ]);
        }

        $user->password = $request->password; // mutator will hash it, or we should hash it if no mutator
        $user->save();

        // Hapus token yang sudah dipakai
        DB::table('password_reset_tokens')->where('email', $email)->delete();

        return response()->json([
            'message' => 'Password berhasil direset. Silakan login dengan password baru Anda.'
        ]);
    }

    /**
     * Helper to validate OTP.
     */
    private function validateOtp(string $email, string $otp)
    {
        $resetRecord = DB::table('password_reset_tokens')->where('email', $email)->first();

        if (!$resetRecord) {
            throw ValidationException::withMessages([
                'otp' => ['OTP tidak valid atau sudah kedaluwarsa.'],
            ]);
        }

        // Check expiration (e.g., 15 minutes)
        $createdAt = Carbon::parse($resetRecord->created_at);
        if ($createdAt->addMinutes(15)->isPast()) {
            DB::table('password_reset_tokens')->where('email', $email)->delete();
            throw ValidationException::withMessages([
                'otp' => ['OTP sudah kedaluwarsa. Silakan minta kode baru.'],
            ]);
        }

        // Verify hash
        if (!Hash::check($otp, $resetRecord->token)) {
            throw ValidationException::withMessages([
                'otp' => ['OTP yang Anda masukkan salah.'],
            ]);
        }

        return true;
    }
}
