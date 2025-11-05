import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 🔹 LOGIN
  Future<String?> loginWithCode(String code, String password) async {
    try {
      final response = await _supabase
          .from('tblProfile')
          .select('UserID, Email')
          .eq('Code', code)
          .maybeSingle();

      if (response == null) {
        return 'Kode tidak ditemukan';
      }

      final loginResponse = await _supabase.auth.signInWithPassword(
        email: response['Email'],
        password: password,
      );

      if (loginResponse.user != null) {
        return null; // sukses
      } else {
        return 'Login gagal';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
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
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// 🔹 Ambil user aktif
  User? get currentUser => _supabase.auth.currentUser;
}
