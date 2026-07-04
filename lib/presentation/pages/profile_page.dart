import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/academic_info_grid.dart';
import '../widgets/interests_section.dart';
import '../widgets/profile_actions.dart';
import 'package:kovalen/presentation/pages/sign_in_page.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
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
      appBar: const CustomAppBar(),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileInitial) {
            Navigator.pushAndRemoveUntil(
              context,
              SignInPage.route(),
              (route) => false,
            );
          } else if (state is ProfileFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, appUserState) {
            if (appUserState is AppUserLoggedIn) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProfileHeader(
                                name: appUserState.user.fullName,
                                university:
                                    appUserState.user.universityName ??
                                    appUserState.user.universityId,
                                avatarUrl: appUserState.user.avatarUrl,
                              ),
                              const SizedBox(height: 20),
                              AcademicInfoGrid(
                                programStudi:
                                    appUserState.user.studyProgramName ??
                                    appUserState.user.studyProgramId,
                                semester: appUserState.user.semester,
                                ipk: appUserState.user.gpa,
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
                              const Spacer(),
                              const SizedBox(height: 16),
                              const ProfileActions(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
