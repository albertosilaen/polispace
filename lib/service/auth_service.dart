import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:polispace/splash.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 LOGIN
  Future<Object?> loginWithCode(String code, String password) async {
    try {
      final response = await _supabase
          .from('tblProfile')
          .select('UserID, Email, AccessID')
          .eq('Code', code)
          .maybeSingle();

      if (response == null) {
        return 'Kode tidak ditemukan';
      }

      // ✅ pastikan jadi Map<String, dynamic>
      final data = Map<String, dynamic>.from(response);

      final loginResponse = await _supabase.auth.signInWithPassword(
        email: data['Email'],
        password: password,
      );

      if (loginResponse.user != null) {
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  Future<void> saveSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('AccessID', userData['AccessID']);
    await prefs.setString('UserID', userData['UserID']);
    await prefs.setString('Email', userData['Email']);
  }

  /// 🔹 REGISTER
  Future<String?> register({
    required String nim,
    required String name,
    required String email,
    required String password,
    required int accessID,
  }) async {
    try {
      final getNim = await _supabase
          .from('tblProfile')
          .select('Code')
          .eq('Code', nim)
          .maybeSingle();

      if (getNim != null) {
        return 'NIM/NIDN sudah terdaftar';
      }

      // 1️⃣ Register user ke Auth
      final signUpResponse = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = signUpResponse.user;
      if (user == null) {
        return 'Gagal membuat akun Supabase Auth';
      }

      // 2️⃣ Simpan ke tabel tblProfile
      await _supabase.from('tblProfile').insert({
        'UserID': user.id,
        'Name': name,
        'Code': nim,
        'Email': email,
        'AccessID': accessID,
      });

      // 4️⃣ Logout setelah registrasi agar tidak auto-login
      await _supabase.auth.signOut();

      return null; // sukses
    } on AuthException catch (e) {
      return 'Auth error: ${e.message}';
    } on PostgrestException catch (e) {
      return 'Database error: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  /// 🔹 Ambil daftar role dari tabel `tblAccess`
  Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      final response = await _supabase
          .from('tblAccess')
          .select('AccessID, AccessName');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Logout
  Future<void> signOut(BuildContext context) async {
    await _supabase.auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Arahkan ke halaman Splash setelah logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false, // hapus semua halaman sebelumnya
    );
  }

  Future<void> signOutSplash() async {
    await _supabase.auth.signOut();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 🔹 Ambil user aktif
  User? get currentUser => _supabase.auth.currentUser;
}
