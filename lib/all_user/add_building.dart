import 'package:flutter/material.dart';
import 'package:polispace/all_user/list_room.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:polispace/constants/colors.dart';

final supabase = Supabase.instance.client;

class AddBuildingPage extends StatefulWidget {
  const AddBuildingPage({super.key});

  @override
  State<AddBuildingPage> createState() => _AddBuildingPageState();
}

class _AddBuildingPageState extends State<AddBuildingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController idBangunanController = TextEditingController();
  final TextEditingController namaBangunanController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveBuilding() async {
    try {
      await supabase.from('tblBuilding').insert({
        'BuildingID': idBangunanController.text.trim(),
        'BuildingName': namaBangunanController.text.trim(),
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Tambah Gedung",
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
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(24),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.1),
            //       blurRadius: 10,
            //       offset: const Offset(0, 4),
            //     ),
            //   ],
            // ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID Gedung
                  _buildTextField(
                    controller: idBangunanController,
                    label: 'ID Gedung',
                    hint: 'Masukkan ID Gedung',
                    icon: Icons.tag,
                  ),
                  const SizedBox(height: 10),
                  // Nama Gedung
                  _buildTextField(
                    controller: namaBangunanController,
                    label: 'Nama Gedung',
                    hint: 'Masukkan Nama Gedung',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     _buildButton(
                  //       text: 'Save',
                  //       color: Colors.green.shade500,
                  //       icon: Icons.save,
                  //       onPressed: () {
                  //         if (_formKey.currentState!.validate()) {
                  //           saveBuilding();

                  //           if (!mounted) return;
                  //           Navigator.pop(context, true);
                  //         }
                  //       },
                  //     ),
                  //     _buildButton(
                  //       text: 'Clear',
                  //       color: Colors.red.shade500,
                  //       icon: Icons.delete,
                  //       onPressed: () {
                  //         idBangunanController.clear();
                  //         namaBangunanController.clear();
                  //       },
                  //     ),
                  //   ],
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveBuilding();

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

  Widget _buildButton({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 130,
      height: 45,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
