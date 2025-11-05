import 'package:flutter/material.dart';
import 'package:polispace/splash.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://lkrnlpyibmvmmuyhsbar.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxrcm5scHlpYm12bW11eWhzYmFyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE3NDU4MzEsImV4cCI6MjA3NzMyMTgzMX0.-0YNLkK-T2Z9PD5bOrEs_R8drcWmFblLVZzWFAy6tkE',
  );

  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoliSpace',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
