import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/academic_info_grid.dart';
import '../widgets/interests_section.dart';
import '../widgets/profile_actions.dart';
import 'package:kovalen/presentation/pages/sign_in_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppPallete.background, // Menerapkan Clean Minimalism theme background
      appBar: AppBar(
        backgroundColor: AppPallete.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                "https://media.licdn.com/dms/image/v2/D4E03AQEAaljZW5GfGA/profile-displayphoto-shrink_800_800/B4EZTv2HgUGgAc-/0/1739190730588?e=1784160000&v=beta&t=GssgASVk2ADNUgTa1MFqrDejDRJEEiJ7RJUvTND5VrI",
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Kovalen',
              style: TextStyle(
                color: AppPallete.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppPallete.primary,
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppPallete.stroke.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Menangkap momen ketika user berhasil keluar (state kembali ke Initial)
          if (state is AuthInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              SignInPage.route(), // Kembali ke halaman Login
              (route) =>
                  false, // Menghapus semua riwayat halaman sebelumnya (agar tidak bisa di-back)
            );
          } else if (state is AuthFailure) {
            // Munculkan snackbar jika proses logout gagal (misal karena jaringan)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileHeader(
                      name: state.user.fullName,
                      university: 'Universitas Pancasila',
                      avatarUrl:
                          'https://media.licdn.com/dms/image/v2/D4E03AQEAaljZW5GfGA/profile-displayphoto-shrink_800_800/B4EZTv2HgUGgAc-/0/1739190730588?e=1784160000&v=beta&t=GssgASVk2ADNUgTa1MFqrDejDRJEEiJ7RJUvTND5VrI',
                    ),
                    const SizedBox(height: 28),
                    AcademicInfoGrid(
                      programStudi: state.user.studyProgram,
                      semester: state.user.semester,
                      ipk: 0,
                    ),
                    const SizedBox(height: 16),
                    const InterestsSection(
                      interests: [
                        'Flutter',
                        'Dart',
                        'UI/UX Design',
                        'Machine Learning',
                      ],
                    ),
                    const SizedBox(height: 32),
                    const ProfileActions(),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            // UBAH/TAMBAHKAN BAGIAN INI
            // Menampilkan loading saat data profil sedang diambil
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppPallete.primary),
              );
            }

            // Fallback default jika state masih ProfileInitial atau terjadi ProfileFailure
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
