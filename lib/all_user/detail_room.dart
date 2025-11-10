import 'package:flutter/material.dart';
import 'package:polispace/constants/colors.dart';
import 'package:polispace/all_user/request_room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomDetail extends StatefulWidget {
  final String roomId;
  final String roomName;

  const RoomDetail({super.key, required this.roomId, required this.roomName});

  @override
  State<RoomDetail> createState() => _RoomStatusState();
}

class _RoomStatusState extends State<RoomDetail> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  Map<String, List<Map<String, dynamic>>> groupedBookings = {};
  Map<String, dynamic> room = {};
  int? _accessID;

  @override
  void initState() {
    super.initState();
    _loadBookings();
    _loadAccessID();
  }

  Future<void> _loadAccessID() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _accessID = prefs.getInt('AccessID');
    });
  }

  Future<void> _loadBookings() async {
    try {
      // ambil data ruangan
      final dataRoom = await supabase
          .from('tblRoom')
          .select('RoomID, RoomName, BuildingID, tblBuilding(BuildingName)')
          .eq('RoomID', widget.roomId)
          .single();

      // ambil data booking berdasarkan RoomID
      final dataRoomBooking = await supabase
          .from('tblRoomBooking')
          .select('*')
          .eq('RoomID', widget.roomId)
          .eq('StatusID', 2)
          .order('BookingDate', ascending: true)
          .order('StartTime', ascending: true);

      // ubah menjadi List<Map>
      final List<Map<String, dynamic>> bookings =
          List<Map<String, dynamic>>.from(dataRoomBooking);

      // group berdasarkan tanggal (BookingDate)
      final Map<String, List<Map<String, dynamic>>> grouped = {};

      for (final booking in bookings) {
        final date = booking['BookingDate'];
        grouped.putIfAbsent(date, () => []);
        grouped[date]!.add(booking);
      }

      setState(() {
        room = dataRoom;
        groupedBookings = grouped;
        loading = false;
      });
    } catch (e) {
      debugPrint('Error load bookings: $e');
      setState(() => loading = false);
    }
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return '-';
    try {
      final parsed = DateFormat("HH:mm:ss").parse(timeStr);
      return DateFormat("HH:mm").format(parsed);
    } catch (_) {
      return timeStr; // fallback jika format tidak cocok
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, leading: BackButton()),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // Bagian header gambar
                Container(
                  width: double.infinity,
                  height: containerHeight,
                  color: AppColors.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/building.png',
                        width: imageWidth,
                      ),
                    ],
                  ),
                ),

                // Detail ruangan dan isi booking
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room['RoomID'] ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        room['RoomName'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Jika data booking kosong, tampilkan pesan
                      if (groupedBookings.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              "Belum ada peminjaman ruangan.",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textLight,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        // Jika ada data booking, tampilkan daftar per tanggal
                        ...groupedBookings.entries.map((entry) {
                          final date = entry.key;
                          final formattedDate = DateFormat(
                            'EEE, dd MMM yyyy',
                          ).format(DateTime.parse(date));
                          final bookings = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  if (_accessID == 2 || _accessID == 3)
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RequestRoom(
                                              roomId: widget.roomId,
                                              roomName: widget.roomName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.secondary,
                                            width: 1,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.add,
                                            size: 14,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // daftar booking per tanggal
                              ...bookings.map((status) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: AppColors.primary,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          status['tblUser']?['UserName'] ??
                                              'Unknown',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${_formatTime(status['StartTime'])} - ${_formatTime(status['EndTime'])}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          status['Reason'] ?? '-',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 8),
                            ],
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
