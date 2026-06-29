import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_pallete.dart';
import '../bloc/matchmaking_bloc.dart';
import '../widgets/view_toggle.dart';
import '../widgets/matchmaking_card.dart';
import '../widgets/custom_app_bar.dart';

class MatchmakingPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => MatchmakingBloc()..add(LoadMatchmakingData()),
          child: const MatchmakingPage(),
        ),
      );
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  bool _isCardView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
            child: BlocBuilder<MatchmakingBloc, MatchmakingState>(
              builder: (context, state) {
                if (state is MatchmakingLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppPallete.primary));
                } else if (state is MatchmakingFailure) {
                  return Center(child: Text(state.message));
                } else if (state is MatchmakingSuccess) {
                  if (state.matches.isEmpty) {
                    return const Center(child: Text('No matches found'));
                  }
                  return _isCardView ? _buildCardView(state.matches) : _buildMapView();
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
                  )
                ],
              ),
            ),
          ),
          // Active Card
          Positioned.fill(
            bottom: 16,
            child: MatchmakingCard(
              name: match.name,
              semester: match.semester,
              major: match.major,
              distance: match.distance,
              matchPercentage: match.matchPercentage,
              imageUrl: match.imageUrl,
              interests: match.interests,
            ),
          ),
        ],
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
