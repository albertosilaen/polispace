import 'package:flutter/material.dart';
import 'package:polispace/penanggung_jawab/bookinglist_pj.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polispace/mahasiswa/statusbooking.dart';
import 'package:polispace/all_user/listroom.dart';
import 'package:polispace/service/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _accessID;

  @override
  void initState() {
    super.initState();
    _loadAccessID();
  }

  Future<void> _loadAccessID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessID = prefs.getInt('AccessID');
    });
  }

  Future<void> _logout() async {
    await AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_accessID == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Tentukan daftar menu sesuai role
    List<Widget> menuList = [];

    if (_accessID == 2) {
      // Mahasiswa
      menuList = [
        _buildMenu(
          icon: Icons.meeting_room,
          title: 'Peminjaman Ruangan',
          subtitle: 'Ajukan peminjaman ruangan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListRoomPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildMenu(
          icon: Icons.history,
          title: 'Status Peminjaman',
          subtitle: 'Status pengajuan ruangan anda',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage()),
            );
          },
        ),
      ];
    } else if (_accessID == 3) {
      // Penanggung Jawab
      menuList = [
        _buildMenu(
          icon: Icons.meeting_room,
          title: 'Peminjaman Ruangan',
          subtitle: 'Ajukan peminjaman ruangan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListRoomPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildMenu(
          icon: Icons.history,
          title: 'Status Peminjaman',
          subtitle: 'Status pengajuan ruangan anda',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage()),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildMenu(
          icon: Icons.list,
          title: 'Daftar Pengajuan',
          subtitle: 'Daftar pengajuan ruangan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPengajuanPJ()),
            );
          },
        ),
      ];
    } else if (_accessID == 4) {
      // PIC / Laboran
      menuList = [
        _buildMenu(
          icon: Icons.list,
          title: 'Daftar Pengajuan',
          subtitle: 'Daftar peminjam ruangan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPengajuanPJ()),
            );
          },
        ),
        const SizedBox(height: 20),
        _buildMenu(
          icon: Icons.meeting_room,
          title: 'Status Ruangan',
          subtitle: 'Detail status ruangan',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListRoomPage()),
            );
          },
        ),
      ];
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              decoration: const BoxDecoration(
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
                    child: Image.asset(
                      'assets/images/home_mahasiswa.png',
                      width: 250,
                    ),
                  ),
                  const Text(
                    'Halo, .......',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Text(
                    'Gunakanlah ruangan sesuai dengan fungsinya',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...menuList, // gunakan spread operator

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF9BC4FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
