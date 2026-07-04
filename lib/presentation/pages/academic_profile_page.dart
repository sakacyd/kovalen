import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/custom_text_field.dart';
import 'package:kovalen/presentation/widgets/custom_dropdown.dart';
import 'package:kovalen/presentation/bloc/profile_bloc.dart';

class AcademicProfilePage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const AcademicProfilePage());

  const AcademicProfilePage({super.key});

  @override
  State<AcademicProfilePage> createState() => _AcademicProfilePageState();
}

class _AcademicProfilePageState extends State<AcademicProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _semesterController = TextEditingController();
  final _gpaController = TextEditingController();

  String? _selectedUniversity;
  String? _selectedStudyProgram;
  String _avatarUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(ProfileLoadUniversities());

    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      _nameController.text = appUserState.user.fullName;
      _selectedUniversity = appUserState.user.universityId;
      _selectedStudyProgram = appUserState.user.studyProgramId;
      _semesterController.text = appUserState.user.semester.toString();
      _gpaController.text = appUserState.user.gpa.toString();
      _avatarUrl = appUserState.user.avatarUrl;

      if (_selectedUniversity != null && _selectedUniversity!.isNotEmpty) {
        context.read<ProfileBloc>().add(
          ProfileLoadStudyPrograms(_selectedUniversity!),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _semesterController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() &&
        _selectedUniversity != null &&
        _selectedStudyProgram != null) {
      context.read<ProfileBloc>().add(
        UpdateProfileData(
          fullName: _nameController.text,
          avatarUrl: _avatarUrl,
          universityId: _selectedUniversity!,
          studyProgramId: _selectedStudyProgram!,
          semester: int.tryParse(_semesterController.text) ?? 1,
          gpa: double.tryParse(_gpaController.text) ?? 0.0,
          interests: const [],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          Navigator.pop(context);
        } else if (state is ProfileFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppPallete.background,
        appBar: CustomAppBar(
          title: 'Profil Akademik',
          showAvatar: false,
          actions: [
            TextButton(
              onPressed: _saveProfile,
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
                _buildAvatarSection(),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  controller: _nameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<String>> uniItems = [];
                    List<DropdownMenuItem<String>> progItems = [];

                    if (state is ProfileDataLoaded) {
                      uniItems = state.universities.map((u) {
                        return DropdownMenuItem(
                          value: u.id,
                          child: Text(u.name),
                        );
                      }).toList();

                      progItems = state.studyPrograms.map((p) {
                        return DropdownMenuItem(
                          value: p.id,
                          child: Text('${p.educationLevel} - ${p.name}'),
                        );
                      }).toList();
                    }

                    String? safeUniversity =
                        uniItems.any((e) => e.value == _selectedUniversity)
                        ? _selectedUniversity
                        : (uniItems.isNotEmpty ? null : _selectedUniversity);

                    if (safeUniversity == _selectedUniversity &&
                        uniItems.isEmpty &&
                        _selectedUniversity != null) {
                      uniItems.add(
                        DropdownMenuItem(
                          value: _selectedUniversity,
                          child: Text('Memuat...'),
                        ),
                      );
                    }

                    String? safeStudyProgram =
                        progItems.any((e) => e.value == _selectedStudyProgram)
                        ? _selectedStudyProgram
                        : (progItems.isNotEmpty ? null : _selectedStudyProgram);

                    if (safeStudyProgram == _selectedStudyProgram &&
                        progItems.isEmpty &&
                        _selectedStudyProgram != null) {
                      progItems.add(
                        DropdownMenuItem(
                          value: _selectedStudyProgram,
                          child: Text('Memuat...'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomDropdown<String>(
                          label: 'Universitas',
                          hint: 'Pilih Universitas',
                          value: safeUniversity,
                          items: uniItems,
                          onChanged: (val) {
                            setState(() {
                              _selectedUniversity = val;
                              _selectedStudyProgram = null;
                            });
                            if (val != null) {
                              context.read<ProfileBloc>().add(
                                ProfileLoadStudyPrograms(val),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomDropdown<String>(
                          label: 'Program Studi',
                          hint: 'Pilih Program Studi',
                          value: safeStudyProgram,
                          items: progItems,
                          onChanged: (val) {
                            setState(() {
                              _selectedStudyProgram = val;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Semester',
                        hint: '1-14',
                        controller: _semesterController,
                        icon: Icons.school_outlined,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'IPK',
                        hint: '0.00 - 4.00',
                        controller: _gpaController,
                        icon: Icons.grade_outlined,
                      ),
                    ),
                  ],
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        String avatarUrl = _avatarUrl;

        return Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppPallete.surfaceContainerHighest,
                backgroundImage: avatarUrl.isNotEmpty
                    ? NetworkImage(avatarUrl)
                    : null,
                child: avatarUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 48,
                        color: AppPallete.onSurfaceVariant,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppPallete.surface, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: AppPallete.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
