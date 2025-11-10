import 'package:supabase_flutter/supabase_flutter.dart';

class RequestRoomService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDosenList() async {
    try {
      final response = await _supabase
          .from('tblProfile')
          .select('UserID, Name')
          .eq('AccessID', 3)
          .order('Name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching dosen list: $e');
      return [];
    }
  }

  Future<String?> requestRoom({
    required String roomID,
    required String userID,
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
    required String approval1,
    required int accessID,
  }) async {
    try {
      await _supabase.from('tblRoomBooking').insert({
        'RoomID': roomID,
        'UserID': userID,
        'BookingDate': date,
        'StartTime': startTime,
        'EndTime': endTime,
        'Reason': reason,
        'StatusID': 1,
        'Approval1': approval1,
        'Approval1Status': accessID == 3 ? 2 : 1,
        'Approval1Date': accessID == 3
            ? DateTime.now().toIso8601String()
            : null,
      });

      return null;
    } on PostgrestException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }
}
