import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> riwayat = [
      {
        'gedung': 'Gedung Utama',
        'ruangan': '601',
        'jam': '08:00 - 10:00',
        'tanggal': '10 Oktober 2025',
        'reason': '-',
        'status': 'Waiting',
      },
      {
        'gedung': 'Gedung Utama',
        'ruangan': '702',
        'jam': '08:00 - 10:00',
        'tanggal': '10 Oktober 2025',
        'reason': '-',
        'status': 'Approved',
      },
      {
        'gedung': 'Gedung Utama',
        'ruangan': '605',
        'jam': '08:00 - 10:00',
        'tanggal': '10 Oktober 2025',
        'reason': 'Ruangan sedang digunakan',
        'status': 'Rejected',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Status Peminjaman Ruangan",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: riwayat.length,
                  itemBuilder: (context, index) {
                    final data = riwayat[index];
                    return _buildStatusCard(
                      gedung: data['gedung']!,
                      ruangan: data['ruangan']!,
                      jam: data['jam']!,
                      tanggal: data['tanggal']!,
                      reason: data['reason']!,
                      status: data['status']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String gedung,
    required String ruangan,
    required String jam,
    required String tanggal,
    required String reason,
    required String status,
  }) {
    // Warna status berbeda
    Color statusColor;
    switch (status) {
      case 'Approved':
        statusColor = Colors.green;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gedung  : $gedung"),
          Text("Ruangan : $ruangan"),
          Text("Jam     : $jam"),
          Text("Tanggal : $tanggal"),
          Text("Reason  : $reason",
              style: TextStyle(
                fontStyle: reason == '-' ? FontStyle.normal : FontStyle.italic,
                color: reason == '-' ? Colors.black : Colors.black87,
              )),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
