class ApiConfig {
  // Ganti URL ini sesuai dengan URL backend yang sedang aktif
  // Pastikan diakhiri tanpa slash (/) jika endpoint sudah menggunakan /
  static const String baseUrl = 'https://porto-backend-dokemas.rryxja.easypanel.host/api';
  
  // Endpoint URL Helper
  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout = '$baseUrl/logout';
  static const String me = '$baseUrl/me';
  static const String updateProfile = '$baseUrl/update-profile';
}
