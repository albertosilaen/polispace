import 'package:flutter/material.dart';
import 'package:polispace/all_user/list_room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:polispace/constants/colors.dart';

final supabase = Supabase.instance.client;

class AddRoomPage extends StatefulWidget {
  const AddRoomPage({super.key});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBuildingID;

  final TextEditingController idRuanganController = TextEditingController();
  final TextEditingController namaRuanganController = TextEditingController();

  List<dynamic> buildingList = [];

  @override
  void initState() {
    super.initState();
    fetchBuildings();
  }

  Future<void> fetchBuildings() async {
    final response = await supabase.from('tblBuilding').select();

    setState(() {
      buildingList = response;
    });
  }

  Future<void> saveRoom() async {
    try {
      await supabase.from('tblRoom').insert({
        'RoomID': idRuanganController.text.trim(),
        'RoomName': namaRuanganController.text.trim(),
        'BuildingID': selectedBuildingID,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ruangan berhasil disimpan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.27;
    double imageWidth =
        containerHeight + (MediaQuery.of(context).size.height * 0.05);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            "Tambah Ruangan",
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
                MaterialPageRoute(builder: (context) => const ListRoomPage()),
              );
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Gedung', style: TextStyle(fontSize: 16)),

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedBuildingID,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.business,
                          color: AppColors.secondary,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textLight),
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
                      hint: const Text('Pilih Gedung'),
                      items: buildingList.map<DropdownMenuItem<String>>((b) {
                        return DropdownMenuItem<String>(
                          value: b['BuildingID'] as String,
                          child: Text(b['BuildingName'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBuildingID = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih gedung terlebih dahulu' : null,
                    ),

                    const SizedBox(height: 10),

                    // ID Ruangan
                    _buildTextField(
                      controller: idRuanganController,
                      label: 'ID Ruangan',
                      hint: 'Masukkan ID Ruangan',
                      icon: Icons.tag,
                    ),

                    const SizedBox(height: 10),

                    // Nama Ruangan
                    _buildTextField(
                      controller: namaRuanganController,
                      label: 'Nama Ruangan',
                      hint: 'Masukkan Nama Ruangan',
                      icon: Icons.door_front_door,
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveRoom();

                            if (!mounted) return;
                            Navigator.pop(context, true);
                          }
                        },
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: hint,
            prefixIcon: Icon(icon, color: AppColors.secondary),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textLight),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Field tidak boleh kosong'
              : null,
        ),
      ],
    );
  }
}
