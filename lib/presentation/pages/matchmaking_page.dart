import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_pallete.dart';
import '../bloc/matchmaking_bloc.dart';
import '../widgets/view_toggle.dart';
import '../widgets/matchmaking_card.dart';
import '../widgets/custom_app_bar.dart';
import '../../core/common/entities/match_profile.dart';
import 'package:kovalen/presentation/pages/matching_preferences_page.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  bool _isCardView = true;

  @override
  void initState() {
    super.initState();
    context.read<MatchmakingBloc>().add(LoadMatchmakingData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: CustomAppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.push(context, MatchingPreferencesPage.route());
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: ViewToggle(
              isCardView: _isCardView,
              onToggle: () {
                setState(() {
                  _isCardView = !_isCardView;
                });
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<MatchmakingBloc, MatchmakingState>(
              listener: (context, state) {
                if (state is MatchmakingMatchFound) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('It\'s a Match! 🎉'),
                      backgroundColor: AppPallete.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MatchmakingLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppPallete.primary),
                  );
                } else if (state is MatchmakingFailure) {
                  return Center(child: Text(state.message));
                } else if (state is MatchmakingSuccess || state is MatchmakingMatchFound) {
                  final matches = (state is MatchmakingSuccess) 
                      ? state.matches 
                      : (state as MatchmakingMatchFound).matches;
                      
                  if (matches.isEmpty) {
                    return const Center(child: Text('No matches found'));
                  }
                  return _isCardView
                      ? _buildCardView(matches)
                      : _buildMapView();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView(List<MatchProfile> matches) {
    // For simplicity, showing just the first match in the UI, or could use PageView
    final match = matches.first;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Background Card
                Positioned(
                  top: 16,
                  left: 8,
                  right: 8,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppPallete.stroke),
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.onSurface.withValues(alpha: 0.04),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                // Active Card
                Positioned.fill(
                  bottom: 16,
                  child: MatchmakingCard(
                    name: match.user.fullName,
                    semester: match.user.semester.toString(),
                    major:
                        match.user.studyProgramName ??
                        match.user.studyProgramId,
                    distance: '${match.distanceInKm.toStringAsFixed(1)} km',
                    matchPercentage: match.matchPercentage,
                    imageUrl: match.user.avatarUrl,
                    interests: match.interests.map((e) => e.name).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.close,
                color: AppPallete.error,
                onTap: () {
                  context.read<MatchmakingBloc>().add(
                    SwipeUserEvent(swipedId: match.user.id, isLiked: false),
                  );
                },
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                icon: Icons.favorite,
                color: AppPallete.primary,
                onTap: () {
                  context.read<MatchmakingBloc>().add(
                    SwipeUserEvent(swipedId: match.user.id, isLiked: true),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppPallete.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }

  Widget _buildMapView() {
    return Center(
      child: Text(
        'Map View Placeholder',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
