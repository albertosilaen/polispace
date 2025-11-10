import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polispace/all_user/home.dart';
import 'package:polispace/constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingStatus extends StatefulWidget {
  const BookingStatus({super.key});

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> {
  final supabase = Supabase.instance.client;
  List<dynamic> bookings = [];
  bool isLoading = true;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _loadAccessID();
  }

  Future<void> _loadAccessID() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID');

    if (userId == null || userId.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    if (!mounted) return;
    setState(() => _userID = userId);

    await fetchBookings(userId);
  }

  Future<void> fetchBookings(String userId) async {
    try {
      final response = await supabase
          .from('tblRoomBooking')
          .select('''
          BookingID,
          BookingDate,
          StartTime,
          EndTime,
          Reason,
          StatusID,
          tblRoom (
            RoomID,
            RoomName,
            tblBuilding (
              BuildingID,
              BuildingName
            )
          )
        ''')
          .eq('UserID', userId)
          .order('BookingDate', ascending: false);

      setState(() {
        bookings = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String getStatusText(int statusId) {
    switch (statusId) {
      case 1:
        return 'Waiting';
      case 2:
        return 'Approved';
      case 3:
        return 'Rejected';
      default:
        return '-';
    }
  }

  Color getStaturBackColor(int statusId) {
    switch (statusId) {
      case 1:
        return Color(0xFFD9F4F8);
      case 2:
        return Color(0xFFD4F4D4);
      case 3:
        return Color(0xFFFDE7FE);
      default:
        return Colors.grey;
    }
  }

  Color getStatusColor(int statusId) {
    switch (statusId) {
      case 1:
        return Color(0xFF268DAF);
      case 2:
        return Color(0xFF41A06A);
      case 3:
        return Color(0xFFFE02B9);
      default:
        return Colors.grey;
    }
  }

  String _formatTimeRange(String timeRange) {
    if (timeRange.contains('-')) {
      final parts = timeRange.split('-');
      final start = parts[0].trim();
      final end = parts.length > 1 ? parts[1].trim() : '';
      return "${_formatTime(start)} - ${_formatTime(end)}";
    }
    return _formatTime(timeRange);
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5); // ambil HH:mm
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Riwayat Peminjaman",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookings.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada riwayat peminjaman",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    if (_userID != null) await fetchBookings(_userID!);
                  },
                  child: ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final item = bookings[index];
                      final statusId = item['StatusID'] ?? 0;
                      return _buildStatusCard(
                        gedung:
                            item['tblRoom']['tblBuilding']['BuildingName']
                                ?.split('.')[0] ??
                            '-',
                        ruangan:
                            '${item['tblRoom']['RoomID']} - ${item['tblRoom']['RoomName']}',
                        jam:
                            "${item['StartTime'] ?? '-'} - ${item['EndTime'] ?? '-'}",
                        tanggal: item['BookingDate'] ?? '-',
                        reason: item['Reason'] ?? '-',
                        status: getStatusText(statusId),
                        statusColor: getStatusColor(statusId),
                        statusBackColor: getStaturBackColor(statusId),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String gedung,
    required String ruangan,
    required String jam, // kombinasi StartTime-EndTime
    required String tanggal,
    required String reason,
    required String status,
    required Color statusColor,
    required Color statusBackColor,
  }) {
    String formattedJam = _formatTimeRange(jam);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFD9D9D9), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gedung,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              ruangan,
              style: TextStyle(fontSize: 14, color: AppColors.textLight),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'EEE, dd MMM yyyy',
                  ).format(DateTime.parse(tanggal)),
                  style: TextStyle(fontSize: 16, color: AppColors.secondary),
                ),
                Text(
                  formattedJam,
                  style: TextStyle(fontSize: 16, color: AppColors.secondary),
                ),
              ],
            ),
            SizedBox(height: 12),

            Container(
              color: statusBackColor,
              padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
              child: Text(status, style: TextStyle(color: statusColor)),
            ),
            const Divider(color: Color(0xFFD9D9D9)),
            Row(
              children: [
                const Icon(Icons.access_time, size: 22),
                SizedBox(width: 3),
                Text('Requested 07 Nov 2025', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      //   child: Column(
      //     children: [
      //       Table(
      //         columnWidths: const {
      //           0: FixedColumnWidth(90),
      //           1: FixedColumnWidth(10),
      //           2: FlexColumnWidth(),
      //         },
      //         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      //         children: [
      //           _buildRow('Gedung', gedung),
      //           _buildRow('Ruangan', ruangan),
      //           _buildRow('Tanggal', tanggal),
      //           _buildRow('Jam', formattedJam),
      //           _buildRow(
      //             'Reason',
      //             reason == '-' ? '-' : reason,
      //             italic: reason != '-',
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 10),
      //       Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(50),
      //         ),
      //         child: Text(
      //           status,
      //           style: TextStyle(
      //             color: statusColor,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 14,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  TableRow _buildRow(String label, String value, {bool italic = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(':'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: TextStyle(
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}
