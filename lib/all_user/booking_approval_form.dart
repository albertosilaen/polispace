import 'package:flutter/material.dart';
import 'package:polispace/constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingApprovalForm extends StatefulWidget {
  final int bookingId;

  const BookingApprovalForm({super.key, required this.bookingId});

  @override
  State<BookingApprovalForm> createState() => _BookingApprovalFormState();
}

class _BookingApprovalFormState extends State<BookingApprovalForm> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  Map<String, dynamic>? bookingData;
  String? profileName;
  int? _accessID;
  String? _userID;

  @override
  void initState() {
    super.initState();
    _loadBookingData();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _accessID = prefs.getInt('AccessID');
      _userID = prefs.getString('UserID');
    });
  }

  Future<void> _loadBookingData() async {
    try {
      final dataBooking = await supabase
          .from('tblRoomBooking')
          .select(
            'BookingDate, StartTime, EndTime, RoomID, Reason, UserID, tblRoom(RoomName), Approval1, Approval1Date, Approval1Status',
          )
          .eq('BookingID', widget.bookingId)
          .single();

      final dataProfile = await supabase
          .from('tblProfile')
          .select('Name')
          .eq('UserID', dataBooking['UserID'])
          .maybeSingle();

      setState(() {
        bookingData = dataBooking;
        profileName = dataProfile?['Name'] ?? 'Tidak diketahui';
        loading = false;
      });
    } catch (e) {
      debugPrint('Error load booking data: $e');
      setState(() => loading = false);
    }
  }

  Future<void> updateApproval(int type) async {
    try {
      if (type == 1) {
        // ✅ Approve
        await supabase
            .from('tblRoomBooking')
            .update({
              'StatusID': _accessID == 3 ? 4 : 2,
              'Approval1': _accessID == 3 ? _userID : bookingData?['Approval1'],
              'Approval1Date': _accessID == 3
                  ? DateTime.now().toIso8601String()
                  : bookingData?['Approval1Date'],
              'Approval1Status': _accessID == 3
                  ? 2
                  : bookingData?['Approval1Status'],
              'Approval2': _accessID == 3 ? null : _userID,
              'Approval2Date': _accessID == 3
                  ? null
                  : DateTime.now().toIso8601String(),
              'Approval2Status': _accessID == 3 ? null : 2,
            })
            .eq('BookingID', widget.bookingId);
      } else {
        // ❌ Reject
        await supabase
            .from('tblRoomBooking')
            .update({
              'StatusID': 3,
              'Approval1': _accessID == 3 ? _userID : bookingData?['Approval1'],
              'Approval1Date': _accessID == 3
                  ? DateTime.now().toIso8601String()
                  : bookingData?['Approval1Date'],
              'Approval1Status': _accessID == 3
                  ? 3
                  : bookingData?['Approval1Status'],
              'Approval2': _accessID == 3 ? null : _userID,
              'Approval2Date': _accessID == 3
                  ? null
                  : DateTime.now().toIso8601String(),
              'Approval2Status': _accessID == 3 ? null : 3,
            })
            .eq('BookingID', widget.bookingId);
      }
    } catch (e) {
      debugPrint('Error load booking data: $e');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (bookingData == null) {
      return const Scaffold(body: Center(child: Text('Data tidak ditemukan')));
    }

    final booking = bookingData!;
    final date = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(DateTime.parse(booking['BookingDate']));
    final startTime = booking['StartTime'].toString().substring(0, 5);
    final endTime = booking['EndTime'].toString().substring(0, 5);

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.27,
            color: AppColors.primary,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: 12,
                    top: 12,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/building.png',
                      width: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['RoomID'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    booking['tblRoom']['RoomName'],
                    style: TextStyle(fontSize: 14, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Penanggung Jawab',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: profileName,
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tanggal',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    initialValue: date,
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: startTime,
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              initialValue: endTime,
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
                  TextField(
                    controller: TextEditingController(
                      text: booking['Reason'] ?? 'Tidak ada alasan',
                    ),
                    readOnly: true,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
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
                          onPressed: () async {
                            await updateApproval(1); // ✅ Approve

                            if (!mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ruangan berhasil disetujui'),
                              ),
                            );

                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'Approve',
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
                          onPressed: () async {
                            await updateApproval(2); // ❌ Reject

                            if (!mounted) return;
                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ruangan telah ditolak'),
                              ),
                            );

                            Navigator.pop(context, true);
                          },
                          child: const Text(
                            'Reject',
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
          ),
        ],
      ),
    );
  }
}
