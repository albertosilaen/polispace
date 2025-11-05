import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:polispace/autentikasi/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<dynamic>? _subscription;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await supabase.auth.signOut();
    // Delay minimal 2 detik
    await Future.delayed(const Duration(seconds: 2));

    // Langsung navigasi ke halaman berikutnya
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "POLISPACE",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: const Color(0xFF2D71F8),
              ),
            ),
            const Text(
              '"Satu ruangan, banyak kemudahan"',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: const Color(0xFF2D71F8),
              strokeWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}
