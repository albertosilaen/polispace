import 'package:flutter/material.dart';
import 'package:polispace/service/auth_service.dart';
import 'package:polispace/autentikasi/login.dart';
import 'package:polispace/constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthService _authService = AuthService();
  String? _selectedRole;
  List<Map<String, dynamic>> _roles = [];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _authService.getRoles();
      setState(() {
        _roles = roles;
      });
    } catch (e) {
      print('Error load roles: $e');
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final nim = _nimController.text.trim();
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final selectedAccess = _roles.firstWhere(
      (r) => r['AccessName'] == _selectedRole,
      orElse: () => {},
    );

    final accessID = selectedAccess['AccessID'];

    final errorMessage = await _authService.register(
      nim: nim,
      name: name,
      email: email,
      password: password,
      accessID: accessID,
    );

    if (!mounted) return;

    if (errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign up to',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Polispace',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                /// ROLE DROPDOWN
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Role',
                    prefixIcon: Icon(Icons.people, color: AppColors.secondary),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.textLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.secondary,
                        width: 2,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  items: _roles
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item['AccessName'],
                          child: Text(item['AccessName']),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRole = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Silakan pilih role' : null,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _nimController,
                  label: 'NIM/NIDN',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.people,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  obscure: true,
                ),
                const SizedBox(height: 10),

                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  obscure: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Password tidak sesuai';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
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
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.secondary),
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) => (value == null || value.isEmpty) ? 'Isi $label' : null,
    );
  }
}
