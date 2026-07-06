import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/bloc/profile_settings_bloc.dart';
import 'package:kovalen/presentation/pages/sign_in_page.dart';
import 'package:kovalen/presentation/pages/academic_profile_page.dart';
import 'package:kovalen/presentation/pages/credential_page.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      );

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state is ProfileSettingsInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            SignInPage.route(),
            (route) => false,
          );
        } else if (state is ProfileSettingsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.background,
        appBar: const CustomAppBar(
          title: 'Pengaturan Akun',
          showAvatar: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileSummary(context),
              const SizedBox(height: 24),
              _buildSettingsGroup(
                context,
                title: 'Akun & Profil',
                items: [
                  SettingsItem(
                    icon: Icons.person_outline,
                    title: 'Profil Akademik',
                    onTap: () {
                      Navigator.push(context, AcademicProfilePage.route());
                    },
                  ),
                  SettingsItem(
                    icon: Icons.lock_outline,
                    title: 'Kredensial',
                    onTap: () {
                      Navigator.push(context, CredentialPage.route());
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSettingsGroup(
                context,
                title: 'Preferensi',
                items: [
                  SettingsItem(
                    icon: Icons.tune_outlined,
                    title: 'Preferensi Pencocokan',
                    onTap: () {},
                  ),
                  SettingsItem(
                    icon: Icons.notifications_none_outlined,
                    title: 'Notifikasi',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSettingsGroup(
                context,
                title: 'Bantuan & Privasi',
                items: [
                  SettingsItem(
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    onTap: () {},
                  ),
                  SettingsItem(
                    icon: Icons.security_outlined,
                    title: 'Kebijakan Privasi',
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.read<ProfileSettingsBloc>().add(ProfileSettingsSignOut());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.surface,
                  foregroundColor: AppPallete.error,
                  elevation: 0,
                  side: const BorderSide(color: AppPallete.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Keluar'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSummary(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if (state is AppUserLoggedIn) {
          final user = state.user;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPallete.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppPallete.stroke),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppPallete.surfaceContainerHighest,
                  backgroundImage: user.avatarUrl.trim().startsWith('http')
                      ? NetworkImage(user.avatarUrl.trim())
                      : null,
                  onBackgroundImageError: user.avatarUrl.trim().startsWith('http')
                      ? (exception, stackTrace) {}
                      : null,
                  child: !user.avatarUrl.trim().startsWith('http')
                      ? const Icon(
                          Icons.person,
                          size: 32,
                          color: AppPallete.onSurfaceVariant,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppPallete.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context, {
    required String title,
    required List<SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppPallete.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppPallete.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppPallete.stroke),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}
