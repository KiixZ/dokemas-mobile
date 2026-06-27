import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  UserModel? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;
  String? get token => _token;

  // Cek token di SharedPreferences (dipanggil saat aplikasi dibuka di SplashScreen)
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');

    if (savedToken != null) {
      _token = savedToken;
      _isLoggedIn = true;
      notifyListeners();

      // Coba fetch user data terbaru
      await fetchUser();
    } else {
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  // Fungsi fetch data user (/api/me)
  Future<void> fetchUser() async {
    if (_token == null) return;

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.me),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'] ?? data['data'] ?? data;
        _user = UserModel.fromJson(userData);
        notifyListeners();
      } else {
        // Jika token tidak valid / expired
        await logout();
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  // Fungsi Login
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _user = UserModel.fromJson(data['user']);
        _isLoggedIn = true;

        // Simpan token ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        notifyListeners();
        return null; // null berarti sukses (tidak ada error)
      } else {
        debugPrint('Login failed: ${response.body}');
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Email atau password salah';
      }
    } catch (e) {
      debugPrint('Error login: $e');
      return 'Terjadi kesalahan koneksi. Pastikan internet lancar.';
    }
  }


  // Fungsi Register
  Future<String?> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _user = UserModel.fromJson(data['user']);
        _isLoggedIn = true;

        // Simpan token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);

        notifyListeners();
        return null; // Sukses
      } else {
        debugPrint('Register failed: ${response.body}');
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal mendaftar. Periksa kembali data Anda.';
      }
    } catch (e) {
      debugPrint('Error register: $e');
      return 'Terjadi kesalahan koneksi. Pastikan internet lancar.';
    }
  }

  // Fungsi Ubah Profil (Name & Email)
  Future<String?> updateProfileInfo(String name, String email) async {
    if (_token == null) return 'Anda belum login.';
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'] ?? data['data'] ?? data;
        _user = UserModel.fromJson(userData);
        notifyListeners();
        return null; // Sukses
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal mengubah profil.';
      }
    } catch (e) {
      debugPrint('Error update profil: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // Fungsi Ubah Profil Lengkap (Name, Email, dan opsional Avatar file)
  Future<String?> updateProfile({
    required String name,
    required String email,
    XFile? avatarFile,
  }) async {
    if (_token == null) return 'Anda belum login.';
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.updateAvatar),
      );
      
      request.headers['Authorization'] = 'Bearer $_token';
      request.headers['Accept'] = 'application/json';

      request.fields['name'] = name;
      request.fields['email'] = email;

      if (avatarFile != null) {
        final bytes = await avatarFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'avatar',
            bytes,
            filename: avatarFile.name,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'] ?? data['data'] ?? data;
        _user = UserModel.fromJson(userData);
        
        // Evict image cache to force reload of the new avatar
        if (_user?.avatarUrl != null) {
          NetworkImage(_user!.avatarUrl).evict();
        }
        
        notifyListeners();
        return null; // Sukses
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal memperbarui profil.';
      }
    } catch (e) {
      debugPrint('Error update profile: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // Fungsi Ubah Password
  Future<String?> updatePassword(String currentPassword, String password, String passwordConfirmation) async {
    if (_token == null) return 'Anda belum login.';
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.updateProfile),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      if (response.statusCode == 200) {
        return null; // Sukses
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['message'] ?? 'Gagal mengubah password.';
      }
    } catch (e) {
      debugPrint('Error update password: $e');
      return 'Terjadi kesalahan koneksi.';
    }
  }

  // Fungsi Logout
  Future<void> logout() async {
    try {
      if (_token != null) {
        await http.post(
          Uri.parse(ApiConfig.logout),
          headers: {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        );
      }
    } catch (e) {
      debugPrint('Error logout: $e');
    }

    _token = null;
    _user = null;
    _isLoggedIn = false;

    // Hapus token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');

    notifyListeners();
  }
}
