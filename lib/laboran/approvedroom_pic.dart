import 'package:flutter/material.dart';
import 'package:polispace/constants/colors.dart';

class VerifyRoomPagePIC extends StatelessWidget {
  const VerifyRoomPagePIC({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.27,
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Dorong ke bawah
              children: [Image.asset('assets/images/building.png', width: 300)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gedung Utama - 701',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed convallis nibh non congue fringilla.',
                  style: TextStyle(fontSize: 14, color: AppColors.textLight),
                ),
                SizedBox(height: 24),
                Text(
                  'Penanggung Jawab',
                  style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                
                SizedBox(height: 6),
                TextFormField(
                  initialValue: 'Harimawan-331235458',
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                SizedBox(height: 16),
                const Text(
                  'Tanggal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue:
                      'Senin, 12 Desember 2023',
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jam Mulai',
                            style:
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: '19:00',
                            readOnly: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.access_time),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jam Selesai',
                            style:
                                TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            initialValue: '22:00',
                            readOnly: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.access_time),
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Alasan Meminjam Ruangan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tulis alasan di sini...',
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                          elevation: 3,
                        ),
                        onPressed: () {
                          // TODO: Integrasikan ke fungsi backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ruangan Diverifikasi')),
                          );
                        },
                        child: const Text(
                          'Verify',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                        ),
                        onPressed: () {
                          // TODO: Integrasikan ke fungsi backend
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ruangan Ditolak')),
                          );
                        },
                        child: const Text(
                          'Deny',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
