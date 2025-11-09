import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polispace/constants/colors.dart';
import 'package:polispace/mahasiswa/statusbooking.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/request_room_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Requestroom extends StatefulWidget {
  final String roomId;
  final String roomName;

  const Requestroom({Key? key, required this.roomId, required this.roomName})
    : super(key: key);

  @override
  _RequestroomState createState() => _RequestroomState();
}

class _RequestroomState extends State<Requestroom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  int? _accessID;
  String? _userID;
  String? _selectedResponsible;
  List<Map<String, dynamic>> _dosen = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDosenList();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _accessID = prefs.getInt('AccessID');
      _userID = prefs.getString('UserID');
    });
  }

  Future<void> _loadDosenList() async {
    final dosen = await RequestRoomService().getDosenList();
    if (!mounted) return;
    setState(() {
      _dosen = dosen;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final formattedTime = DateFormat('HH:mm').format(
        DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
      );

      setState(() {
        controller.text = formattedTime;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_userID == null || _accessID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User tidak terdeteksi, silakan login ulang')),
      );
      return;
    }

    // 🔹 Panggil service Supabase
    final message = await RequestRoomService().requestRoom(
      roomID: widget.roomId,
      userID: _userID!,
      date: _dateController.text,
      startTime: _fromTimeController.text,
      endTime: _toTimeController.text,
      reason: _activityController.text,
      approval1: _accessID == 2
          ? (_selectedResponsible ?? '')
          : (_userID ?? ''),
      accessID: _accessID!,
    );

    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil melakukan pengajuan')),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HistoryPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, leading: BackButton()),
      body: ListView(
        children: [
          Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.roomId,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.roomName,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_accessID == 2)
                            const Text(
                              'Penanggung Jawab',
                              style: TextStyle(fontSize: 16),
                            ),
                          if (_accessID == 2)
                            SizedBox(
                              child: DropdownButtonFormField2<String>(
                                isExpanded: true,
                                value: _selectedResponsible,
                                decoration: const InputDecoration(
                                  labelText: 'Pilih Penanggung Jawab',
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: AppColors.secondary,
                                    size: 20,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                ),
                                items: _dosen
                                    .map(
                                      (d) => DropdownMenuItem<String>(
                                        value: d['UserID'].toString(),
                                        child: Text(
                                          d['Name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedResponsible = value;
                                  });
                                },

                                validator: (value) {
                                  if (_accessID == 2 &&
                                      (value == null || value.isEmpty)) {
                                    return 'Silakan pilih penanggung jawab';
                                  }
                                  return null;
                                },

                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  scrollPadding: EdgeInsets.zero,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),
                          const Text(
                            'Tanggal Penggunaan',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Penggunaan',
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: AppColors.secondary,
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.textLight,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                  width: 2,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan pilih tanggal penggunaan';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _fromTimeController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: "Jam Mulai",
                                    prefixIcon: Icon(Icons.access_time),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.secondary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onTap: () =>
                                      _selectTime(context, _fromTimeController),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Silakan pilih jam mulai';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _toTimeController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: "Jam Selesai",
                                    prefixIcon: Icon(Icons.access_time),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.secondary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onTap: () =>
                                      _selectTime(context, _toTimeController),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Silakan pilih jam selesai';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Kegiatan',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            maxLines: 3,
                            controller: _activityController,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.textLight,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.secondary,
                                  width: 2,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan isi kegiatan';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _save,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                textStyle: const TextStyle(fontSize: 18),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                              ),
                              child: const Text('Simpan'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
