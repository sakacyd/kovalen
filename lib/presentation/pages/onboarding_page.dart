import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kovalen/core/utils/pick_image.dart';
import 'package:kovalen/main_page.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/core/common/entities/interest.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/selectable_pill.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_text_field.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static route() =>
      MaterialPageRoute(
        builder: (context) => const OnboardingPage(),
      );

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _fullNameController = TextEditingController();
  final _avatarUrlController = TextEditingController();
  File? _avatarFile;
  final _gpaController = TextEditingController();
  final _customTujuanBelajarController = TextEditingController();

  String? _selectedUniversity;
  String? _selectedProgram;
  String? _selectedSemester;
  String? _selectedGender;
  String? _selectedTujuanBelajar;
  String? _selectedGayaBelajar;

  final Set<String> _selectedInterests = {};
  static const int _maxInterests = 5;

  int _currentSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(OnboardingLoadUniversities());
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _avatarUrlController.dispose();
    _gpaController.dispose();
    _customTujuanBelajarController.dispose();
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

  void _pickAvatar() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        _avatarFile = file;
      });
    }
  }

  void _nextSection() {
    if (_currentSectionIndex == 0) {
      if (_fullNameController.text.isEmpty || _avatarFile == null || _selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi informasi dasar dan foto profil terlebih dahulu')),
        );
        return;
      }
      setState(() => _currentSectionIndex = 1);
    } else if (_currentSectionIndex == 1) {
      if (_selectedProgram == null || _selectedSemester == null || _selectedUniversity == null || _gpaController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi latar belakang akademik terlebih dahulu')),
        );
        return;
      }
      final double parsedGpa = double.tryParse(_gpaController.text) ?? 0.0;
      if (parsedGpa < 0.0 || parsedGpa > 4.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nilai IPK harus berada di rentang 0.00 hingga 4.00')),
        );
        return;
      }
      setState(() => _currentSectionIndex = 2);
    } else {
      if (_selectedInterests.isEmpty || _selectedTujuanBelajar == null || _selectedGayaBelajar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lengkapi pilihan fokus & minat terlebih dahulu')),
        );
        return;
      }
      String finalTujuanBelajar = _selectedTujuanBelajar!;
      if (_selectedTujuanBelajar == 'Lain-lain') {
        if (_customTujuanBelajarController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lengkapi tujuan belajar lainnya terlebih dahulu')),
          );
          return;
        }
        finalTujuanBelajar = _customTujuanBelajarController.text.trim();
      }

      final double parsedGpa = double.tryParse(_gpaController.text) ?? 0.0;
      context.read<OnboardingBloc>().add(
        OnboardingSubmit(
          fullName: _fullNameController.text,
          avatarUrl: '', // This will be overwritten by backend upload
          avatarFile: _avatarFile,
          universityId: _selectedUniversity!,
          studyProgramId: _selectedProgram!,
          semester: int.parse(_selectedSemester!),
          gender: _selectedGender!,
          tujuanBelajar: finalTujuanBelajar,
          gayaBelajar: _selectedGayaBelajar!,
          gpa: parsedGpa,
          interests: _selectedInterests.toList(),
        ),
      );
    }
  }

  void _previousSection() {
    if (_currentSectionIndex > 0) {
      setState(() => _currentSectionIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: CustomAppBar(
          titleWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressIndicator(_currentSectionIndex >= 0),
            const SizedBox(width: 8),
            _buildProgressIndicator(_currentSectionIndex >= 1),
            const SizedBox(width: 8),
            _buildProgressIndicator(_currentSectionIndex >= 2),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Akademik',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bantu kami mencocokkan Anda dengan partner belajar yang memiliki ritme dan fokus serupa.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_currentSectionIndex == 0) _buildSection1(),
                    if (_currentSectionIndex == 1) _buildSection2(),
                    if (_currentSectionIndex == 2) _buildSection3(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: BlocConsumer<OnboardingBloc, OnboardingState>(
                listener: (context, state) {
                  if (state is OnboardingFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is OnboardingSuccess) {
                    Navigator.pushReplacement(context, MainPage.route());
                  }
                },
                builder: (context, state) {
                  return Row(
                    children: [
                      if (_currentSectionIndex > 0) ...[
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: state is OnboardingLoading ? null : _previousSection,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Theme.of(context).colorScheme.primary),
                            ),
                            child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: state is OnboardingLoading ? null : _nextSection,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is OnboardingLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentSectionIndex == 2 ? 'Selesai' : 'Lanjutkan',
                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                    if (_currentSectionIndex < 2) ...[
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Informasi Dasar', Icons.person_outline),
        const SizedBox(height: 24),
        _buildAvatarPicker(),
        const SizedBox(height: 24),
        CustomTextField(
          label: 'Nama Lengkap',
          hint: 'Masukkan nama lengkap',
          controller: _fullNameController,
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
                    activeColor: Theme.of(context).colorScheme.primary,
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
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Latar Belakang Akademik', Icons.school_outlined),
        const SizedBox(height: 24),
        BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            List<DropdownMenuItem<String>> uniItems = [];
            List<DropdownMenuItem<String>> progItems = [];

            if (state is OnboardingDataLoaded) {
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

            return Column(
              children: [
                CustomDropdown<String>(
                  label: 'Universitas',
                  hint: 'Pilih Universitas',
                  value: _selectedUniversity,
                  items: uniItems,
                  onChanged: (val) {
                    setState(() {
                      _selectedUniversity = val;
                      _selectedProgram = null; 
                    });
                    if (val != null) {
                      context.read<OnboardingBloc>().add(OnboardingLoadStudyPrograms(val));
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomDropdown<String>(
                  label: 'Program Studi',
                  hint: 'Pilih Program Studi',
                  value: _selectedProgram,
                  items: progItems,
                  onChanged: (val) =>
                      setState(() => _selectedProgram = val),
                ),
              ],
            );
          }
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: CustomDropdown<String>(
                label: 'Semester Saat Ini',
                hint: 'Semester',
                value: _selectedSemester,
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Semester 1')),
                  DropdownMenuItem(value: '2', child: Text('Semester 2')),
                  DropdownMenuItem(value: '3', child: Text('Semester 3')),
                  DropdownMenuItem(value: '4', child: Text('Semester 4')),
                  DropdownMenuItem(value: '5', child: Text('Semester 5')),
                  DropdownMenuItem(value: '6', child: Text('Semester 6')),
                  DropdownMenuItem(value: '7', child: Text('Semester 7')),
                  DropdownMenuItem(value: '8', child: Text('Semester 8+')),
                ],
                onChanged: (val) =>
                    setState(() => _selectedSemester = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'IPK (G-PA)',
                hint: '0.00',
                controller: _gpaController,
                icon: Icons.grade_outlined,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(text: newValue.text.replaceAll(',', '.'));
                  }),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  onChanged: (value) => setState(() => _selectedTujuanBelajar = value),
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                RadioListTile<String>(
                  title: const Text('Nugas Sehari-hari/Mingguan'),
                  value: 'Nugas sehari-hari atau mingguan',
                  groupValue: _selectedTujuanBelajar,
                  onChanged: (value) => setState(() => _selectedTujuanBelajar = value),
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                RadioListTile<String>(
                  title: const Text('Skripsi/Tugas Akhir'),
                  value: 'Skripsi/Tugas Akhir',
                  groupValue: _selectedTujuanBelajar,
                  onChanged: (value) => setState(() => _selectedTujuanBelajar = value),
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                RadioListTile<String>(
                  title: const Text('Lain-lain'),
                  value: 'Lain-lain',
                  groupValue: _selectedTujuanBelajar,
                  onChanged: (value) => setState(() => _selectedTujuanBelajar = value),
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
                    onChanged: (value) => setState(() => _selectedGayaBelajar = value),
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Offline'),
                    value: 'Offline',
                    groupValue: _selectedGayaBelajar,
                    onChanged: (value) => setState(() => _selectedGayaBelajar = value),
                    contentPadding: EdgeInsets.zero,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'Pilih Topik Minat Belajar',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              '${_selectedInterests.length}/$_maxInterests Terpilih',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(
                    color:
                        _selectedInterests.length == _maxInterests
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Pilih hingga $_maxInterests topik untuk memfokuskan pencarian studi Anda.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if (state is OnboardingDataLoaded) {
              return _buildInterestsGroup(state.availableInterests);
            }
            return const Center(child: CircularProgressIndicator());
          }
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 48 : 24,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
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
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
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
        Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ],
    );
  }

  Widget _buildAvatarPicker() {
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
                      : null,
                  child: _avatarFile == null
                      ? const Icon(Icons.person, size: 56, color: AppPallete.onSurfaceVariant)
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
                      border: Border.all(color: AppPallete.surface, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt, color: AppPallete.onPrimary, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _buildInterestsGroup(Map<String, Map<String, List<Interest>>> groupedByType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: groupedByType.keys.map((typeName) {
        final groupedByCategory = groupedByType[typeName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                typeName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
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
                          isSelected: _selectedInterests.contains(interest.id),
                          onTap: () => _toggleInterest(interest.id),
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
