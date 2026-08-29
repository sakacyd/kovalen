import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/matching_preferences_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';

class MatchingPreferencesPage extends StatefulWidget {
  const MatchingPreferencesPage({super.key});

  static Route route() =>
      MaterialPageRoute(builder: (context) => const MatchingPreferencesPage());

  @override
  State<MatchingPreferencesPage> createState() =>
      _MatchingPreferencesPageState();
}

class _MatchingPreferencesPageState extends State<MatchingPreferencesPage> {
  double _distancePreference = 15.0; // Default

  @override
  void initState() {
    super.initState();
    context.read<MatchingPreferencesBloc>().add(LoadMatchingPreferences());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Preferensi Pencocokan',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<MatchingPreferencesBloc, MatchingPreferencesState>(
        listener: (context, state) {
          if (state is MatchingPreferencesLoaded) {
            setState(() {
              _distancePreference = state.maxDistance;
            });
          } else if (state is MatchingPreferencesSaved) {
            setState(() {
              _distancePreference = state.maxDistance;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Preferensi berhasil disimpan!')),
            );
            Navigator.of(context).pop();
          } else if (state is MatchingPreferencesFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MatchingPreferencesLoading &&
              _distancePreference == 15.0) {
            return const Center(child: CircularProgressIndicator());
          }

          if ((state is MatchingPreferencesLoaded ||
                  state is MatchingPreferencesSaved) &&
              _distancePreference !=
                  (state is MatchingPreferencesLoaded
                      ? state.maxDistance
                      : (state as MatchingPreferencesSaved).maxDistance) &&
              _distancePreference == 15.0) {
            // Safe initial set if we didn't get to listener somehow, usually listener handles it.
            _distancePreference = (state is MatchingPreferencesLoaded
                ? state.maxDistance
                : (state as MatchingPreferencesSaved).maxDistance);
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jarak Maksimum',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Atur jarak maksimum untuk mencari partner belajar di sekitar Anda.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPallete.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Jarak',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '${_distancePreference.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPallete.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _distancePreference,
                  min: 1.0,
                  max: 100.0,
                  divisions: 99,
                  label: '${_distancePreference.round()} km',
                  activeColor: AppPallete.primary,
                  inactiveColor: AppPallete.surfaceContainerHighest,
                  onChanged: (value) {
                    setState(() {
                      _distancePreference = value;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    context.read<MatchingPreferencesBloc>().add(
                      SaveMatchingPreferencesEvent(_distancePreference),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.primary,
                    foregroundColor: AppPallete.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state is MatchingPreferencesLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Preferensi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
