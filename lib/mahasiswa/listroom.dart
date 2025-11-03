import 'package:flutter/material.dart';

class RuanganPage extends StatefulWidget {
  const RuanganPage({super.key});

  @override
  State<RuanganPage> createState() => _RuanganPageState();
}

class _RuanganPageState extends State<RuanganPage> {
  // List kategori
  final List<String> categories = ["Gedung Utama", "Tower A", "Techno", "RTF"];

  // Kategori yang sedang aktif
  String selectedCategory = "Gedung Utama";

  // Data ruangan per kategori
  final Map<String, List<String>> roomsByCategory = {
    "Gedung Utama": [
      "GU 601, Ruang Komputer",
      "GU 602, Ruang Kelas",
      "GU 605, Ruang Animasi",
      "GU 701, Ruang Tata Usaha",
      "GU 702, Ruang Komputer",
      "GU 705, Ruang Rendering",
    ],
    "Tower A": [
      "TA 101, Ruang Dosen",
      "TA 102, Ruang Rapat",
      "TA 201, Ruang Kelas",
      "TA 202, Ruang Multimedia",
    ],
    "Techno": [
      "TC 301, Lab Elektronika",
      "TC 302, Ruang Proyek",
      "TC 303, Ruang Server",
    ],
    "RTF": [
      "RTF 401, Ruang Produksi",
      "RTF 402, Ruang Editing",
      "RTF 403, Studio Rekaman",
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Ambil list ruangan berdasarkan kategori aktif
    final List<String> currentRooms = roomsByCategory[selectedCategory] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas abu-abu
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
                      Container(width: 2, height: 70, color: Colors.black26),
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

            // Tombol kategori gedung
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          categories.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: _buildCategoryButton(
                              categories[index],
                              selectedCategory == categories[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: const Color(0xFF2D71F8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // List ruangan sesuai kategori
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  for (final room in currentRooms) _buildRoomItem(room),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D71F8),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk tombol kategori
  Widget _buildCategoryButton(String title, bool isActive) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = title;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? const Color(0xFF2D71F8)
            : Colors.grey.shade400,
        foregroundColor: Colors.white,
      ),
      child: Text(title),
    );
  }

  // Widget helper untuk item ruangan
  Widget _buildRoomItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
