import 'package:flutter/material.dart';

class RuanganPage extends StatelessWidget {
  const RuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6C6FF), // Warna ungu muda background
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas abu-abu dengan info Gedung dan Ruang
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Bagian Gedung
                      Expanded(
                        child: Column(
                          children: const [
                            Text(
                              "Gedung",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "3",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Garis pemisah
                      Container(
                        width: 2,
                        height: 70,
                        color: Colors.black26,
                      ),

                      // Bagian Ruang
                      Expanded(
                        child: Column(
                          children: const [
                            Text(
                              "Ruang",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "9",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Atur jadwalmu, manfaatkan ruangmu",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol filter kategori gedung
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryButton("Gedung Utama", true),
                  _buildCategoryButton("Tower A", false),
                  _buildCategoryButton("Techno", false),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List Ruangan
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildRoomItem("GU 601, Ruang Komputer"),
                  _buildRoomItem("GU 602, Ruang Kelas"),
                  _buildRoomItem("GU 605, Ruang Animasi"),
                  _buildRoomItem("GU 701, Ruang Tata Usaha"),
                  _buildRoomItem("GU 702, Ruang Komputer"),
                  _buildRoomItem("GU 705, Ruang Rendering"),
                ],
              ),
            ),

            // Tombol Tambah
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6EFF6E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Aksi tambah ruangan
                  },
                  child: const Text(
                    "+",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk tombol kategori
  Widget _buildCategoryButton(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade400 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.black : Colors.black54,
        ),
      ),
    );
  }

  // Widget helper untuk item ruangan
  Widget _buildRoomItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
