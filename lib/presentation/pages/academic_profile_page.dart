import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/utils/pick_image.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/widgets/custom_text_field.dart';
import 'package:kovalen/presentation/widgets/custom_dropdown.dart';
import 'package:kovalen/presentation/bloc/profile_settings_bloc.dart';
import 'package:kovalen/presentation/bloc/profile_bloc.dart';
import 'package:kovalen/presentation/widgets/confirmation_modal.dart';
import 'package:kovalen/presentation/widgets/selectable_pill.dart';
import 'package:kovalen/core/common/entities/interest.dart';

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

  final _gpaController = TextEditingController();
  final _customTujuanBelajarController = TextEditingController();

  String? _selectedSemester;
  String? _selectedUniversity;
  String? _selectedStudyProgram;
  String? _selectedGender;
  String? _selectedTujuanBelajar;
  String? _selectedGayaBelajar;
  String _avatarUrl = '';
  File? _avatarFile;
  final Set<String> _selectedAcademicInterests = {};
  final Set<String> _selectedNonAcademicInterests = {};
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
      int sem = appUserState.user.semester;
      _selectedSemester = sem >= 8 ? '8' : sem.toString();
      _selectedGender = appUserState.user.gender;
      final predefinedTujuan = [
        'Persiapan UTS',
        'Nugas sehari-hari atau mingguan',
        'Skripsi/Tugas Akhir',
      ];
      if (predefinedTujuan.contains(appUserState.user.tujuanBelajar)) {
        _selectedTujuanBelajar = appUserState.user.tujuanBelajar;
      } else if (appUserState.user.tujuanBelajar != null &&
          appUserState.user.tujuanBelajar!.isNotEmpty) {
        _selectedTujuanBelajar = 'Lain-lain';
        _customTujuanBelajarController.text =
            appUserState.user.tujuanBelajar ?? '';
      }
      _selectedGayaBelajar = appUserState.user.gayaBelajar;

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
      for (var interest in profileState.interests) {
        if (interest.category?.type == 'academic') {
          _selectedAcademicInterests.add(interest.id);
        } else {
          _selectedNonAcademicInterests.add(interest.id);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gpaController.dispose();
    _customTujuanBelajarController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interestId, String typeName) {
    setState(() {
      final targetSet = typeName == 'Akademik'
          ? _selectedAcademicInterests
          : _selectedNonAcademicInterests;
      if (targetSet.contains(interestId)) {
        targetSet.remove(interestId);
      } else {
        if (targetSet.length < _maxInterests) {
          targetSet.add(interestId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Maksimal $_maxInterests minat $typeName yang dapat dipilih.',
              ),
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
          _selectedSemester !=
              (appUserState.user.semester >= 8
                  ? '8'
                  : appUserState.user.semester.toString()) ||
          _selectedGender != appUserState.user.gender ||
          (_selectedTujuanBelajar == 'Lain-lain'
              ? _customTujuanBelajarController.text.trim() !=
                    appUserState.user.tujuanBelajar
              : _selectedTujuanBelajar != appUserState.user.tujuanBelajar) ||
          _selectedGayaBelajar != appUserState.user.gayaBelajar ||

          _gpaController.text != appUserState.user.gpa.toString() ||
          _avatarUrl != appUserState.user.avatarUrl;
    }
    // Compare interests
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSuccess) {
      final initialAcademic = profileState.interests
          .where((e) => e.category?.type == 'academic')
          .map((e) => e.id)
          .toSet();
      final initialNonAcademic = profileState.interests
          .where((e) => e.category?.type != 'academic')
          .map((e) => e.id)
          .toSet();
      if (_selectedAcademicInterests.length != initialAcademic.length ||
          !_selectedAcademicInterests.containsAll(initialAcademic) ||
          _selectedNonAcademicInterests.length != initialNonAcademic.length ||
          !_selectedNonAcademicInterests.containsAll(initialNonAcademic)) {
        return true;
      }
    }
    return false;
  }

  void _pickAvatar() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        _avatarFile = file;
      });
    }
  }

  void _saveProfile() async {
    if (_gpaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nilai IPK wajib diisi')));
      return;
    }

    final double parsedGpa = double.tryParse(_gpaController.text) ?? 0.0;

    if (parsedGpa < 0.0 || parsedGpa > 4.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nilai IPK harus berada di rentang 0.00 hingga 4.00'),
        ),
      );
      return;
    }

    if (_selectedAcademicInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal pilih 1 minat akademik')),
      );
      return;
    }

    if (_selectedNonAcademicInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal pilih 1 minat non-akademik')),
      );
      return;
    }

    if (_formKey.currentState!.validate() &&
        _selectedUniversity != null &&
        _selectedStudyProgram != null &&
        _selectedGender != null &&
        _selectedTujuanBelajar != null &&
        _selectedGayaBelajar != null) {
      final shouldSave = await ConfirmationModal.show(
        context: context,
        title: 'Simpan Perubahan?',
        content:
            'Apakah Anda yakin ingin menyimpan perubahan profil akademik ini?',
        confirmText: 'Simpan',
        cancelText: 'Batal',
      );

      if (shouldSave == true) {
        if (!mounted) return;

        String finalTujuanBelajar = _selectedTujuanBelajar!;
        if (_selectedTujuanBelajar == 'Lain-lain') {
          if (_customTujuanBelajarController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Lengkapi tujuan belajar lainnya terlebih dahulu',
                ),
              ),
            );
            return;
          }
          finalTujuanBelajar = _customTujuanBelajarController.text.trim();
        }

        context.read<ProfileSettingsBloc>().add(
          UpdateProfileSettingsData(
            fullName: _nameController.text,
            avatarUrl: _avatarUrl,
            avatarFile: _avatarFile,
            universityId: _selectedUniversity!,
            studyProgramId: _selectedStudyProgram!,
            semester: int.tryParse(_selectedSemester ?? '1') ?? 1,
            gender: _selectedGender!,
            tujuanBelajar: finalTujuanBelajar,
            gayaBelajar: _selectedGayaBelajar!,

            gpa: parsedGpa,
            interests: [
              ..._selectedAcademicInterests,
              ..._selectedNonAcademicInterests,
            ],
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
              content:
                  'Anda memiliki perubahan yang belum disimpan. Yakin ingin membuangnya?',
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
                  _buildSectionHeader('Informasi Dasar', Icons.person_outline),
                  const SizedBox(height: 24),
                  _buildAvatarSection(),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama lengkap',
                    controller: _nameController,
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Kelamin',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Laki-laki'),
                              value: 'Laki-laki',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Perempuan'),
                              value: 'Perempuan',
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildSectionHeader(
                    'Latar Belakang Akademik',
                    Icons.school_outlined,
                  ),
                  const SizedBox(height: 24),
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
                      if (_selectedUniversity != null &&
                          _selectedUniversity!.isNotEmpty) {
                        if (uniItems.any(
                          (e) => e.value == _selectedUniversity,
                        )) {
                          safeUniversity = _selectedUniversity;
                        } else if (uniItems.isEmpty) {
                          safeUniversity = _selectedUniversity;
                          final userState = context.read<AppUserCubit>().state;
                          final uniName = userState is AppUserLoggedIn
                              ? userState.user.universityName
                              : null;
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
                          final uniName = userState is AppUserLoggedIn
                              ? userState.user.universityName
                              : null;
                          if (uniName != null) {
                            uniItems.add(
                              DropdownMenuItem(
                                value: _selectedUniversity,
                                child: Text(uniName),
                              ),
                            );
                          } else {
                            safeUniversity = null; // fallback to hint
                          }
                        }
                      }

                      String? safeStudyProgram;
                      if (_selectedStudyProgram != null &&
                          _selectedStudyProgram!.isNotEmpty) {
                        if (progItems.any(
                          (e) => e.value == _selectedStudyProgram,
                        )) {
                          safeStudyProgram = _selectedStudyProgram;
                        } else if (progItems.isEmpty) {
                          safeStudyProgram = _selectedStudyProgram;
                          final userState = context.read<AppUserCubit>().state;
                          final progName = userState is AppUserLoggedIn
                              ? userState.user.studyProgramName
                              : null;
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
                          final progName = userState is AppUserLoggedIn
                              ? userState.user.studyProgramName
                              : null;
                          if (progName != null) {
                            progItems.add(
                              DropdownMenuItem(
                                value: _selectedStudyProgram,
                                child: Text(progName),
                              ),
                            );
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
                        child: CustomDropdown<String>(
                          label: 'Semester Saat Ini',
                          hint: 'Semester',
                          value: _selectedSemester,
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text('Semester 1'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('Semester 2'),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text('Semester 3'),
                            ),
                            DropdownMenuItem(
                              value: '4',
                              child: Text('Semester 4'),
                            ),
                            DropdownMenuItem(
                              value: '5',
                              child: Text('Semester 5'),
                            ),
                            DropdownMenuItem(
                              value: '6',
                              child: Text('Semester 6'),
                            ),
                            DropdownMenuItem(
                              value: '7',
                              child: Text('Semester 7'),
                            ),
                            DropdownMenuItem(
                              value: '8',
                              child: Text('Semester 8+'),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedSemester = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: 'IPK',
                          hint: '0.00 - 4.00',
                          controller: _gpaController,
                          icon: Icons.grade_outlined,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            TextInputFormatter.withFunction((
                              oldValue,
                              newValue,
                            ) {
                              return newValue.copyWith(
                                text: newValue.text.replaceAll(',', '.'),
                              );
                            }),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.]'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Fokus & Minat', Icons.lightbulb_outline),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tujuan Belajar',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Persiapan UTS/UAS'),
                            value: 'Persiapan UTS',
                            groupValue: _selectedTujuanBelajar,
                            onChanged: (value) =>
                                setState(() => _selectedTujuanBelajar = value),
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          RadioListTile<String>(
                            title: const Text('Nugas Sehari-hari/Mingguan'),
                            value: 'Nugas sehari-hari atau mingguan',
                            groupValue: _selectedTujuanBelajar,
                            onChanged: (value) =>
                                setState(() => _selectedTujuanBelajar = value),
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          RadioListTile<String>(
                            title: const Text('Skripsi/Tugas Akhir'),
                            value: 'Skripsi/Tugas Akhir',
                            groupValue: _selectedTujuanBelajar,
                            onChanged: (value) =>
                                setState(() => _selectedTujuanBelajar = value),
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          RadioListTile<String>(
                            title: const Text('Lain-lain'),
                            value: 'Lain-lain',
                            groupValue: _selectedTujuanBelajar,
                            onChanged: (value) =>
                                setState(() => _selectedTujuanBelajar = value),
                            contentPadding: EdgeInsets.zero,
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      if (_selectedTujuanBelajar == 'Lain-lain') ...[
                        const SizedBox(height: 8),
                        CustomTextField(
                          label: 'Tujuan Belajar Lainnya',
                          hint: 'Ketik tujuan belajar Anda...',
                          controller: _customTujuanBelajarController,
                          icon: Icons.edit_outlined,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gaya Belajar',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Online'),
                              value: 'Online',
                              groupValue: _selectedGayaBelajar,
                              onChanged: (value) =>
                                  setState(() => _selectedGayaBelajar = value),
                              contentPadding: EdgeInsets.zero,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Offline'),
                              value: 'Offline',
                              groupValue: _selectedGayaBelajar,
                              onChanged: (value) =>
                                  setState(() => _selectedGayaBelajar = value),
                              contentPadding: EdgeInsets.zero,
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Minat Akademik', Icons.school),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Pilih Topik Minat Akademik',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_selectedAcademicInterests.length}/$_maxInterests Terpilih',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              _selectedAcademicInterests.length == _maxInterests
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih minimal 1 hingga $_maxInterests topik akademik untuk memfokuskan pencarian studi Anda.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                    builder: (context, state) {
                      if (state is ProfileSettingsDataLoaded) {
                        final academicInterests = {
                          'Akademik':
                              state.availableInterests['Akademik'] ??
                              <String, List<Interest>>{},
                        };
                        return _buildInterestsGroup(academicInterests);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  const SizedBox(height: 32),
                  _buildSectionHeader(
                    'Minat Non-Akademik',
                    Icons.palette_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Pilih Topik Minat Non-Akademik',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${_selectedNonAcademicInterests.length}/$_maxInterests Terpilih',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              _selectedNonAcademicInterests.length ==
                                  _maxInterests
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih minimal 1 hingga $_maxInterests topik non-akademik yang sesuai dengan minat Anda.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                    builder: (context, state) {
                      if (state is ProfileSettingsDataLoaded) {
                        final nonAcademicInterests = {
                          'Non Akademik':
                              state.availableInterests['Non Akademik'] ??
                              <String, List<Interest>>{},
                        };
                        return _buildInterestsGroup(nonAcademicInterests);
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ],
    );
  }

  Widget _buildAvatarSection() {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        String avatarUrl = _avatarUrl;

        return Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: AppPallete.surfaceContainerHighest,
                      backgroundImage: _avatarFile != null
                          ? FileImage(_avatarFile!) as ImageProvider
                          : (avatarUrl.trim().startsWith('http')
                                ? NetworkImage(avatarUrl.trim())
                                : null),
                      onBackgroundImageError:
                          _avatarFile == null &&
                              avatarUrl.trim().startsWith('http')
                          ? (exception, stackTrace) {}
                          : null,
                      child:
                          _avatarFile == null &&
                              !avatarUrl.trim().startsWith('http')
                          ? const Icon(
                              Icons.person,
                              size: 56,
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
                          border: Border.all(
                            color: AppPallete.surface,
                            width: 3,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppPallete.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // We could optionally allow them to edit the URL manually here too,
              // but since they already click "edit" or it's fetched, let's keep it simple.
              // We'll leave out the URL textfield here to save space or let them use the pencil.
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterestsGroup(
    Map<String, Map<String, List<Interest>>> groupedByType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: groupedByType.keys.map((typeName) {
        final groupedByCategory = groupedByType[typeName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...groupedByCategory.keys.map((catName) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: groupedByCategory[catName]!.map((interest) {
                        return SelectablePill(
                          label: interest.name,
                          isSelected:
                              _selectedAcademicInterests.contains(
                                interest.id,
                              ) ||
                              _selectedNonAcademicInterests.contains(
                                interest.id,
                              ),
                          onTap: () => _toggleInterest(interest.id, typeName),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}
