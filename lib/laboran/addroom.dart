import 'package:flutter/material.dart';

class TambahRuanganPage extends StatefulWidget {
  const TambahRuanganPage({super.key});

  @override
  State<TambahRuanganPage> createState() => _TambahRuanganPageState();
}

class _TambahRuanganPageState extends State<TambahRuanganPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGedung;
  final TextEditingController idRuanganController = TextEditingController();
  final TextEditingController namaRuanganController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  final List<String> gedungList = ['Gedung Utama', 'Gedung B', 'Gedung C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'Tambah Ruangan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: 150,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown Gedung
                    const Text(
                      'Gedung',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedGedung,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      hint: const Text('Pilih Gedung'),
                      items: gedungList
                          .map(
                            (gedung) => DropdownMenuItem(
                              value: gedung,
                              child: Text(gedung),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGedung = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Pilih gedung terlebih dahulu' : null,
                    ),

                    const SizedBox(height: 16),

                    // ID Ruangan
                    _buildTextField(
                      controller: idRuanganController,
                      label: 'ID Ruangan',
                      hint: 'Masukkan ID Ruangan',
                    ),

                    const SizedBox(height: 16),

                    // Nama Ruangan
                    _buildTextField(
                      controller: namaRuanganController,
                      label: 'Nama Ruangan',
                      hint: 'Masukkan Nama Ruangan',
                    ),

                    const SizedBox(height: 16),

                    // Lokasi
                    _buildTextField(
                      controller: lokasiController,
                      label: 'Lokasi',
                      hint: 'Masukkan Lokasi Ruangan',
                    ),

                    const SizedBox(height: 28),

                    // Tombol Save & Delete
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildButton(
                          text: 'Save',
                          color: Colors.green.shade500,
                          icon: Icons.save,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Ruangan berhasil disimpan!'),
                                ),
                              );
                            }
                          },
                        ),
                        _buildButton(
                          text: 'Delete',
                          color: Colors.red.shade500,
                          icon: Icons.delete,
                          onPressed: () {
                            idRuanganController.clear();
                            namaRuanganController.clear();
                            lokasiController.clear();
                            setState(() {
                              selectedGedung = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) => value == null || value.isEmpty
              ? 'Field tidak boleh kosong'
              : null,
        ),
      ],
    );
  }

  // Reusable Button
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
