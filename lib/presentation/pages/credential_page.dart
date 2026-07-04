import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/auth_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/custom_text_field.dart';

class CredentialPage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => const CredentialPage(),
      );

  const CredentialPage({super.key});

  @override
  State<CredentialPage> createState() => _CredentialPageState();
}

class _CredentialPageState extends State<CredentialPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveCredentials() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kata sandi baru tidak cocok')),
        );
        return;
      }
      
      // Dispatch event to BLoC
      context.read<AuthBloc>().add(
            AuthChangePassword(newPassword: _newPasswordController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kata sandi berhasil diperbarui')),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.background,
        appBar: CustomAppBar(
        title: 'Kredensial',
        showAvatar: false,
        actions: [
          TextButton(
            onPressed: _saveCredentials,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: AppPallete.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ubah kata sandi Anda secara berkala untuk menjaga keamanan akun.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPallete.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Kata Sandi Saat Ini',
                hint: 'Masukkan kata sandi saat ini',
                controller: _currentPasswordController,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text(
                    'Lupa kata sandi?',
                    style: TextStyle(
                      color: AppPallete.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Kata Sandi Baru',
                hint: 'Masukkan kata sandi baru',
                controller: _newPasswordController,
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Konfirmasi Kata Sandi Baru',
                hint: 'Ulangi kata sandi baru',
                controller: _confirmPasswordController,
                icon: Icons.lock_reset_outlined,
                isPassword: true,
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
