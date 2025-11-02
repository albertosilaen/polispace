import 'package:flutter/material.dart';
import 'package:polispace/mahasiswa/statusbooking.dart';
import 'package:polispace/splash.dart';
import 'package:polispace/mahasiswa/listroom.dart';
import 'package:polispace/autentikasi/login.dart';
import 'package:polispace/autentikasi/register.dart';
import 'package:polispace/penanggung_jawab/bookinglist.dart';
import 'package:polispace/laboran/addroom.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoliSpace',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const TambahRuanganPage(),
      routes: {
        '/signup': (context) => RegisterPage(),
        '/signin': (context) => LoginPage(),
      },
    );
  }
}
