import 'package:kasir_kosmetic/core/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthService {
  final SupabaseClient _client = SupabaseClientService.instance;

  Future<String?> login(String email, String password) async {
    final hasConnection = await InternetConnectionChecker.instance.hasConnection;
    if (!hasConnection) {
      return "Tidak ada koneksi internet. Periksa jaringan Anda.";
    }

    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user == null) {
        return "Login gagal. Email atau password salah.";
      }

      return null;
    } catch (e) {
      final error = e.toString();

      if (error.contains("Invalid login credentials")) {
        return "Email atau password salah.";
      } else if (error.contains("Email not confirmed")) {
        return "Email belum diverifikasi.";
      } else if (error.contains("User not found")) {
        return "Akun tidak ditemukan.";
      }

      return "Login gagal. Periksa koneksi internet atau coba lagi.";
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;
}
