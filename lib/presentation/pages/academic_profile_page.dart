import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/custom_text_field.dart';
import 'package:kovalen/presentation/widgets/custom_dropdown.dart';
import 'package:kovalen/presentation/bloc/profile_settings_bloc.dart';
import 'package:kovalen/presentation/bloc/profile_bloc.dart';
import 'package:kovalen/presentation/widgets/confirmation_modal.dart';
import 'package:kovalen/presentation/widgets/selectable_pill.dart';

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
  final Set<String> _selectedInterests = {};
  static const int _maxInterests = 5;

  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingsBloc>().add(ProfileSettingsLoadUniversities());

    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      _nameController.text = appUserState.user.fullName;
      _selectedUniversity = appUserState.user.universityId;
      _selectedStudyProgram = appUserState.user.studyProgramId;
      _semesterController.text = appUserState.user.semester.toString();
      _gpaController.text = appUserState.user.gpa.toString();
      _avatarUrl = appUserState.user.avatarUrl;

      if (_selectedUniversity != null && _selectedUniversity!.isNotEmpty) {
        context.read<ProfileSettingsBloc>().add(
          ProfileSettingsLoadStudyPrograms(_selectedUniversity!),
        );
      }
    }

    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSuccess) {
      _selectedInterests.addAll(profileState.interests.map((e) => e.id));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _semesterController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interestId) {
    setState(() {
      if (_selectedInterests.contains(interestId)) {
        _selectedInterests.remove(interestId);
      } else {
        if (_selectedInterests.length < _maxInterests) {
          _selectedInterests.add(interestId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maksimal 5 minat yang dapat dipilih.'),
            ),
          );
        }
      }
    });
  }

  bool get _hasUnsavedChanges {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      return _nameController.text != appUserState.user.fullName ||
          _selectedUniversity != appUserState.user.universityId ||
          _selectedStudyProgram != appUserState.user.studyProgramId ||
          _semesterController.text != appUserState.user.semester.toString() ||
          _gpaController.text != appUserState.user.gpa.toString() ||
          _avatarUrl != appUserState.user.avatarUrl;
    }
    // Compare interests
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSuccess) {
      final initialInterests = profileState.interests.map((e) => e.id).toSet();
      if (_selectedInterests.length != initialInterests.length ||
          !_selectedInterests.containsAll(initialInterests)) {
        return true;
      }
    }
    return false;
  }

  void _saveProfile() async {
    final double parsedGpa = double.tryParse(_gpaController.text) ?? 0.0;

    if (parsedGpa < 0.0 || parsedGpa > 4.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nilai IPK harus berada di rentang 0.00 hingga 4.00'),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate() &&
        _selectedUniversity != null &&
        _selectedStudyProgram != null) {
      final shouldSave = await ConfirmationModal.show(
        context: context,
        title: 'Simpan Perubahan?',
        content: 'Apakah Anda yakin ingin menyimpan perubahan profil akademik ini?',
        confirmText: 'Simpan',
        cancelText: 'Batal',
      );

      if (shouldSave == true) {
        if (!mounted) return;
        context.read<ProfileSettingsBloc>().add(
          UpdateProfileSettingsData(
            fullName: _nameController.text,
            avatarUrl: _avatarUrl,
            universityId: _selectedUniversity!,
            studyProgramId: _selectedStudyProgram!,
            semester: int.tryParse(_semesterController.text) ?? 1,
            gpa: parsedGpa,
            interests: _selectedInterests.toList(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      listener: (context, state) {
        if (state is UpdateProfileSettingsSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil berhasil diperbarui')),
          );
          Navigator.pop(context);
        } else if (state is ProfileSettingsFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          if (_hasUnsavedChanges) {
            final shouldPop = await ConfirmationModal.show(
              context: context,
              title: 'Buang Perubahan?',
              content: 'Anda memiliki perubahan yang belum disimpan. Yakin ingin membuangnya?',
              confirmText: 'Buang',
              cancelText: 'Batal',
            );
            if (shouldPop == true) {
              if (!context.mounted) return;
              Navigator.pop(context);
            }
          } else {
            if (!context.mounted) return;
            Navigator.pop(context);
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
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  builder: (context, state) {
                    List<DropdownMenuItem<String>> uniItems = [];
                    List<DropdownMenuItem<String>> progItems = [];

                    if (state is ProfileSettingsDataLoaded) {
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

                    String? safeUniversity;
                    if (_selectedUniversity != null && _selectedUniversity!.isNotEmpty) {
                      if (uniItems.any((e) => e.value == _selectedUniversity)) {
                        safeUniversity = _selectedUniversity;
                      } else if (uniItems.isEmpty) {
                        safeUniversity = _selectedUniversity;
                        final userState = context.read<AppUserCubit>().state;
                        final uniName = userState is AppUserLoggedIn ? userState.user.universityName : null;
                        uniItems.add(
                          DropdownMenuItem(
                            value: _selectedUniversity,
                            child: Text(uniName ?? 'Memuat...'),
                          ),
                        );
                      } else {
                        // University loaded but not in list, keep it to show name or reset
                        safeUniversity = _selectedUniversity;
                        final userState = context.read<AppUserCubit>().state;
                        final uniName = userState is AppUserLoggedIn ? userState.user.universityName : null;
                        if (uniName != null) {
                           uniItems.add(DropdownMenuItem(value: _selectedUniversity, child: Text(uniName)));
                        } else {
                           safeUniversity = null; // fallback to hint
                        }
                      }
                    }

                    String? safeStudyProgram;
                    if (_selectedStudyProgram != null && _selectedStudyProgram!.isNotEmpty) {
                      if (progItems.any((e) => e.value == _selectedStudyProgram)) {
                        safeStudyProgram = _selectedStudyProgram;
                      } else if (progItems.isEmpty) {
                        safeStudyProgram = _selectedStudyProgram;
                        final userState = context.read<AppUserCubit>().state;
                        final progName = userState is AppUserLoggedIn ? userState.user.studyProgramName : null;
                        progItems.add(
                          DropdownMenuItem(
                            value: _selectedStudyProgram,
                            child: Text(progName ?? 'Memuat...'),
                          ),
                        );
                      } else {
                        // Programs loaded but not in list, add it to show name or reset
                        safeStudyProgram = _selectedStudyProgram;
                        final userState = context.read<AppUserCubit>().state;
                        final progName = userState is AppUserLoggedIn ? userState.user.studyProgramName : null;
                        if (progName != null) {
                           progItems.add(DropdownMenuItem(value: _selectedStudyProgram, child: Text(progName)));
                        } else {
                           safeStudyProgram = null; // fallback to hint
                        }
                      }
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
                              context.read<ProfileSettingsBloc>().add(
                                ProfileSettingsLoadStudyPrograms(val),
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
                const SizedBox(height: 32),
                Divider(color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Minat Belajar',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      '${_selectedInterests.length}/$_maxInterests Terpilih',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _selectedInterests.length == _maxInterests
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih hingga $_maxInterests topik untuk memfokuskan pencarian studi Anda.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  builder: (context, state) {
                    if (state is ProfileSettingsDataLoaded) {
                      return Wrap(
                        spacing: 8,
                        runSpacing: 12,
                        children: state.availableInterests.map((interest) {
                          return SelectablePill(
                            label: interest.name,
                            isSelected: _selectedInterests.contains(interest.id),
                            onTap: () => _toggleInterest(interest.id),
                          );
                        }).toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  builder: (context, state) {
                    if (state is ProfileSettingsLoading) {
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
