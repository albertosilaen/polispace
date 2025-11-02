import 'package:flutter/material.dart';

class ListPengajuan extends StatelessWidget {
  const ListPengajuan({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> jadwal = [
      {
        'ruangan': 'RUANGAN 001',
        'nama': 'Indra Wahyudi - 33123456',
        'jam': '08:00 - 10:00',
      },
      {
        'ruangan': 'RUANGAN 001',
        'nama': 'Indra Wahyudi - 33123456',
        'jam': '10:00 - 12:00',
      },
      {
        'ruangan': 'RUANGAN 001',
        'nama': 'Indra Wahyudi - 33123456',
        'jam': '13:00 - 15:00',
      },
      {
        'ruangan': 'RUANGAN 002',
        'nama': 'Ayu Lestari - 33124567',
        'jam': '08:00 - 10:00',
      },
      {
        'ruangan': 'RUANGAN 003',
        'nama': 'Rian Saputra - 33125678',
        'jam': '10:00 - 12:00',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white, // pink muda
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Jadwal Penggunaan Ruangan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jadwal.length,
        itemBuilder: (context, index) {
          final data = jadwal[index];
          return _buildScheduleCard(
            data['ruangan']!,
            data['nama']!,
            data['jam']!,
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(String ruangan, String nama, String jam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom kiri: nama ruangan & peminjam
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ruangan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nama,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            // Kolom kanan: jam
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                jam,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B3B3B),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
