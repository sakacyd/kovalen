import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.stroke),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, color: AppTheme.primary, size: 40),
                const SizedBox(height: 16),
                Text(
                  'Kovalen',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: AppTheme.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan masuk menggunakan kredensial universitas Anda.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                const CustomTextField(
                  label: 'Email Institusi',
                  hint: 'nama@kampus.ac.id',
                  icon: Icons.mail_outline,
                  infoText: 'Gunakan email dengan domain .ac.id atau .edu',
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kata Sandi',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      'Lupa sandi?',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: AppTheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  label: '',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),

                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AuthAuthenticated) {
                      // Navigator.pushReplacementNamed(context, '/main'); // Arahkan ke Halaman Utama
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                  LoginSubmitted(
                                    email: 'test@kampus.ac.id',
                                    password: 'password',
                                  ),
                                );
                              },
                        child: state is AuthLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Masuk',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.login,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Divider(color: AppTheme.stroke),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Belum memiliki profil akademik? '),
                      TextSpan(
                        text: 'Daftar sekarang',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
