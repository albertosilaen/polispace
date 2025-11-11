import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polispace/all_user/booking_approval_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingApprovalList extends StatefulWidget {
  const BookingApprovalList({super.key});

  @override
  State<BookingApprovalList> createState() => _BookingApprovalListState();
}

class _BookingApprovalListState extends State<BookingApprovalList> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> approvalList = [];
  int? _accessID;
  String _userID = '';
  bool isLoading = true;
  String requesterName = '';
  String requesterCode = '';

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final accessId = prefs.getInt('AccessID');
    final userId = prefs.getString('UserID') ?? '';

    if (!mounted) return;

    setState(() {
      _accessID = accessId;
      _userID = userId;
    });

    await _loadApprovalList();
  }

  Future<void> _loadApprovalList() async {
    try {
      if (_accessID == null || _userID.isEmpty) return;

      List<Map<String, dynamic>> response = [];

      if (_accessID == 3) {
        response = await supabase
            .from('tblRoomBooking')
            .select()
            .eq('Approval1', _userID)
            .eq('Approval1Status', 1)
            .order('BookingDate', ascending: false);
      } else {
        response = await supabase
            .from('tblRoomBooking')
            .select()
            .eq('Approval1Status', 2)
            .isFilter('Approval2', null)
            .not('Approval1Date', 'is', null)
            .order('BookingDate', ascending: false);
      }

      List<Map<String, dynamic>> newList = [];
      for (var e in response) {
        await _loadRequesterName(e['UserID'].toString());
        final date = _formatDate(e['BookingDate']);
        newList.add({
          'bookingId': e['BookingID'],
          'ruangan': e['RoomID'],
          'nama': requesterCode + ' - ' + requesterName,
          'date': date,
          'jam':
              "${(e['StartTime'] as String).substring(0, 5)} - ${(e['EndTime'] as String).substring(0, 5)}",
        });
      }

      if (!mounted) return;
      setState(() {
        approvalList = newList;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadRequesterName(String reqUserID) async {
    try {
      final response = await supabase
          .from('tblProfile')
          .select('Code, Name')
          .eq('UserID', reqUserID)
          .maybeSingle();

      setState(() {
        requesterName = response?['Name'] ?? 'Tidak diketahui';
        requesterCode = response?['Code'] ?? 'Kosong';
      });
    } catch (e) {
      return;
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    final date = DateTime.tryParse(dateStr);
    if (date == null) return '-';
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Daftar Pengajuan Ruangan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : approvalList.isEmpty
          ? const Center(
              child: Text("Tidak ada pengajuan menunggu persetujuan"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: approvalList.length,
              itemBuilder: (context, index) {
                final data = approvalList[index];
                return _buildScheduleCard(
                  data['bookingId']!,
                  data['ruangan']!,
                  data['nama']!,
                  data['date']!,
                  data['jam']!,
                );
              },
            ),
    );
  }

  Widget _buildScheduleCard(
    int bookingId,
    String ruangan,
    String nama,
    String tanggal,
    String jam,
  ) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingApprovalForm(bookingId: bookingId),
          ),
        );

        if (result == true) {
          _loadApprovalList();
        }
      },

      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF9BC4FF),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ruangan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nama,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Kolom kanan (jam)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
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
      ),
    );
  }
}
