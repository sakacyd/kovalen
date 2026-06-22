import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/auth_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_text_field.dart';
import 'package:kovalen/main_page.dart';
import 'package:kovalen/presentation/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
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
              color: AppPallete.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppPallete.stroke),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, color: AppPallete.primary, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    'Kovalen',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppPallete.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan masuk menggunakan kredensial universitas Anda.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'Email Institusi',
                    hint: 'nama@kampus.ac.id',
                    controller: emailController,
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
                      GestureDetector(
                        onTap: () {
                          // Handle forgot password logic
                        },
                        child: Text(
                          'Lupa sandi?',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppPallete.primary),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    label: '',
                    hint: '••••••••',
                    controller: passwordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),

                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      } else if (state is AuthSuccess) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MainPage.route(),
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      AuthSignIn(
                                        email: emailController.text.trim(),
                                        password: passwordController.text
                                            .trim(),
                                      ),
                                    );
                                  }
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
                  Divider(color: AppPallete.stroke),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPallete.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Belum memiliki profil akademik? ',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        TextSpan(
                          text: 'Daftar sekarang',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppPallete.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, SignUpPage.route());
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
