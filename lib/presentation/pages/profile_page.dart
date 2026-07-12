import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/bloc/profile_settings_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/academic_info_grid.dart';
import '../widgets/interests_section.dart';
import '../widgets/profile_actions.dart';
import '../widgets/custom_app_bar.dart';

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
      backgroundColor: AppPallete.background,
      appBar: const CustomAppBar(showAvatar: false),
      body: BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
        listener: (context, state) {
          if (state is UpdateProfileSettingsSuccess) {
            context.read<ProfileBloc>().add(LoadProfileData());
          } else if (state is ProfileSettingsFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileHeader(
                        name: state.user.fullName,
                        university:
                            state.user.universityName ??
                            state.user.universityId,
                        avatarUrl: state.user.avatarUrl,
                        ratingScore: state.user.ratingScore,
                        ratingCount: state.user.ratingCount,
                      ),
                      const SizedBox(height: 32),
                      AcademicInfoGrid(
                        programStudi:
                            state.user.studyProgramName ??
                            state.user.studyProgramId,
                        semester: state.user.semester,
                        ipk: state.user.gpa,
                      ),
                      const SizedBox(height: 24),
                      InterestsSection(
                        interests: state.interests.isNotEmpty
                            ? state.interests.map((e) => e.name).toList()
                            : ['Belum ada minat yang dipilih'],
                      ),
                      const SizedBox(height: 32),
                      const ProfileActions(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(color: AppPallete.primary),
            );
          },
        ),
      ),
    );
  }
}
