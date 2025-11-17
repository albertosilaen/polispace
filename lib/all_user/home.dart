import 'package:flutter/material.dart';
import 'package:polispace/all_user/booking_approval_list.dart';
import 'package:polispace/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:polispace/all_user/booking_status.dart';
import 'package:polispace/all_user/list_room.dart';
import 'package:polispace/service/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? _accessID;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _accessID = prefs.getInt('AccessID');
      _userName = prefs.getString('Name');
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
              MaterialPageRoute(builder: (context) => BookingStatus()),
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
              MaterialPageRoute(builder: (context) => BookingStatus()),
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
              MaterialPageRoute(builder: (context) => BookingApprovalList()),
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
              MaterialPageRoute(builder: (context) => BookingApprovalList()),
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
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          color: Colors.white,
          onPressed: _logout,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/Learning-bro.png',
                      width: 250,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Halo, $_userName',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Gunakanlah ruangan sesuai dengan fungsinya',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...menuList, // gunakan spread operator
                  // const SizedBox(height: 16),
                  // ElevatedButton(
                  //   onPressed: _logout,
                  //   style: ElevatedButton.styleFrom(
                  //     padding: EdgeInsets.symmetric(vertical: 20),
                  //     backgroundColor: Colors.red,
                  //     foregroundColor: Colors.white,
                  //   ),
                  //   child: const Text('Logout'),
                  // ),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.soft.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
