import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polispace/constants/colors.dart';

class RoomSubmission extends StatefulWidget {
  @override
  _RoomSubmissionState createState() => _RoomSubmissionState();
}

class _RoomSubmissionState extends State<RoomSubmission> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();

  String? _selectedResponsible;
  final List<String> _personResponsibles = ['Mahasiswa', 'Dosen'];

  final data = {
    "id": 1,
    "name": "Gedung Utama-701",
    "status-grouping": [
      {
        "dateid": "Mon, 12 Nov, 2025",
        "status": [
          {
            "id": 1,
            "student_id": "312356445",
            "student_name": "Kurniyawan",
            "reason": "Presentasi untuk asesmen tengah semester",
            "from": "17:00",
            "to": "21:00",
          },
          {
            "id": 2,
            "student_id": "312356445",
            "student_name": "Bakwan",
            "reason": "Diskusi project based learning",
            "from": "21:00",
            "to": "22:00",
          },
        ],
      },
      {
        "dateid": "Tue, 13 Nov, 2025",
        "status": [
          {
            "id": 3,
            "student_id": "312356445",
            "student_name": "Kurniyawan",
            "reason": "Presentasi untuk asesmen tengah semester",
            "from": "17:00",
            "to": "21:00",
          },
          {
            "id": 2,
            "student_id": "312356445",
            "student_name": "Bakwan",
            "reason": "Diskusi project based learning",
            "from": "21:00",
            "to": "22:00",
          },
          {
            "id": 3,
            "student_id": "312356445",
            "student_name": "Kurniyawan",
            "reason": "Presentasi untuk asesmen tengah semester",
            "from": "17:00",
            "to": "21:00",
          },
        ],
      },
    ],
  };

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

  void _save() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Berhasil melakukan pengajuan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: BackButton(),
      ),
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
                Image.asset('assets/images/building.png', width: imageWidth),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'].toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed convallis nibh non congue fringilla.',
                  style: TextStyle(fontSize: 14, color: AppColors.textLight),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Penanggung Jawab',
                            style: TextStyle(fontSize: 16),
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedResponsible,
                            decoration: const InputDecoration(
                              labelText: 'Pilih Penanggung Jawab',
                              prefixIcon: Icon(
                                Icons.people,
                                color: AppColors.secondary,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                            ),
                            items: _personResponsibles.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedResponsible = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan pilih penaggung jawab';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tanggal Penggunaan',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: _dateController,
                            decoration: InputDecoration(
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
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Silakan pilih tanggal penggunaan';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Jam Mulai',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextFormField(
                                      controller: _fromTimeController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: "Jam Mulai",
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
                                        prefixIcon: Icon(Icons.access_time),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      onTap: () => _selectTime(
                                        context,
                                        _fromTimeController,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Silakan pilih jam mulai';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Jam Selesai',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    TextField(
                                      controller: _toTimeController,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: "Jam Selesai",
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
                                        prefixIcon: Icon(Icons.access_time),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                      ),
                                      onTap: () => _selectTime(
                                        context,
                                        _toTimeController,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kegiatan',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            controller: _activityController,
                            decoration: InputDecoration(
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
                          ),
                          const Text(
                            'Deskripsi Kegiatan / Alasan Peminjaman. Contoh: Rapat UKM, Latihan Paduan Suara, Persiapan Lomba, dll.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            textStyle: TextStyle(fontSize: 18),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                          child: Text('Simpan'),
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
      )
    );
  }
}
