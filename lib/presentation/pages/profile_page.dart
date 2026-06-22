import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/bloc/auth_bloc.dart';
import 'package:kovalen/presentation/pages/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const ProfilePage());
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        // Anda bisa menambahkan aksi atau tombol di sini nantinya
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOut());
            Navigator.pushAndRemoveUntil(
              context,
              SignInPage.route(),
              (route) => false,
            );
          },
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
