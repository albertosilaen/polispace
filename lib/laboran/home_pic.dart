import 'package:flutter/material.dart';

class HomePIC extends StatelessWidget {
  const HomePIC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              // Bagian Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
                decoration: BoxDecoration(
                  color: Color(0xFF9BC4FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child:
                      Image.asset(
                        'assets/images/home_pic.png',
                        width: 250,),
                    ),
                    Text(
                      'Halo, .......',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.normal,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      'Gunakanlah ruangan sesuai dengan fungsinya',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                        color: Color(0xFF1F2937)),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
        
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Menu 2
                    _buildMenu(
                      icon: Icons.list,
                      title: 'List Peminjaman',
                      subtitle: 'Daftar peminjam ruangan',
                      onTap: () {
                        // Aksi ketika menu ditekan
                      },
                    ),
                    SizedBox(height: 20),
                    // Menu 3
                    _buildMenu(
                      icon: Icons.history,
                      title: 'Status Peminjaman',
                      subtitle: 'Status pengajuan ruangan anda',
                      onTap: () {
                        // Aksi ketika menu ditekan
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }

  // Widget Menu Kustom
  Widget _buildMenu({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF9BC4FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // warna bayangan
                      blurRadius: 2,        // seberapa lembut bayangannya
                      offset: Offset(2, 2),  // posisi bayangan (x, y)
                    ),
                  ],
        ),
        child: Row(
          children: [
            // Kotak ikon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            SizedBox(width: 16),
            // Teks
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Color(0xFF1F2937)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}