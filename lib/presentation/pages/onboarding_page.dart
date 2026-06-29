import 'package:flutter/material.dart';
import 'package:kovalen/main_page.dart';
import '../../core/theme/app_pallete.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/selectable_pill.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static route() =>
      MaterialPageRoute(builder: (context) => const OnboardingPage());

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  String? _selectedProgram;
  String? _selectedSemester;

  final List<String> _availableInterests = [
    "Machine Learning",
    "Data Structure",
    "UI/UX Design",
    "Kalkulus Dasar",
    "Statistika",
    "Web Development",
    "Bahasa Inggris",
  ];
  final Set<String> _selectedInterests = {};
  static const int _maxInterests = 5;

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < _maxInterests) {
          _selectedInterests.add(interest);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppPallete.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressIndicator(true),
            const SizedBox(width: 8),
            _buildProgressIndicator(false),
            const SizedBox(width: 8),
            _buildProgressIndicator(false),
          ],
        ),
        centerTitle: true,
        actions: const [
          SizedBox(width: 48), // Balance for leading icon
        ],
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
                        color: AppPallete.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bantu kami mencocokkan Anda dengan partner belajar yang memiliki ritme dan fokus serupa.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPallete.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomDropdown<String>(
                      label: 'Program Studi',
                      hint: 'Pilih Program Studi',
                      value: _selectedProgram,
                      items: const [
                        DropdownMenuItem(
                          value: 'cs',
                          child: Text('Ilmu Komputer'),
                        ),
                        DropdownMenuItem(
                          value: 'is',
                          child: Text('Sistem Informasi'),
                        ),
                        DropdownMenuItem(
                          value: 'te',
                          child: Text('Teknik Elektro'),
                        ),
                        DropdownMenuItem(
                          value: 'ds',
                          child: Text('Data Science'),
                        ),
                        DropdownMenuItem(
                          value: 'mg',
                          child: Text('Manajemen Bisnis'),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedProgram = val),
                    ),
                    const SizedBox(height: 24),
                    CustomDropdown<String>(
                      label: 'Semester Saat Ini',
                      hint: 'Pilih Semester',
                      value: _selectedSemester,
                      items: const [
                        DropdownMenuItem(value: '1', child: Text('Semester 1')),
                        DropdownMenuItem(value: '2', child: Text('Semester 2')),
                        DropdownMenuItem(value: '3', child: Text('Semester 3')),
                        DropdownMenuItem(value: '4', child: Text('Semester 4')),
                        DropdownMenuItem(value: '5', child: Text('Semester 5')),
                        DropdownMenuItem(value: '6', child: Text('Semester 6')),
                        DropdownMenuItem(value: '7', child: Text('Semester 7')),
                        DropdownMenuItem(
                          value: '8',
                          child: Text('Semester 8+'),
                        ),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedSemester = val),
                    ),
                    const SizedBox(height: 32),
                    const Divider(color: AppPallete.stroke),
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
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color:
                                    _selectedInterests.length == _maxInterests
                                    ? AppPallete.primary
                                    : AppPallete.textOutline,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih hingga $_maxInterests topik untuk memfokuskan pencarian studi Anda.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPallete.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 12,
                      children: _availableInterests.map((interest) {
                        return SelectablePill(
                          label: interest,
                          isSelected: _selectedInterests.contains(interest),
                          onTap: () => _toggleInterest(interest),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppPallete.background,
                border: Border(
                  top: BorderSide(color: AppPallete.stroke.withOpacity(0.5)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -8),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MainPage.route());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.primary,
                  foregroundColor: AppPallete.surface,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lanjutkan',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppPallete.surface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(bool isActive) {
    return Container(
      height: 6,
      width: 32,
      decoration: BoxDecoration(
        color: isActive ? AppPallete.primary : AppPallete.surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
