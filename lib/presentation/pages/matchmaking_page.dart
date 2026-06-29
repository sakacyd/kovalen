import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';
import '../widgets/view_toggle.dart';
import '../widgets/matchmaking_card.dart';

class MatchmakingPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const MatchmakingPage());
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppPallete.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppPallete.stroke,
            height: 1.0,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppPallete.stroke),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDWRzl8gFXuHrRChlm3fL_BIHNN5fxyKpo9mM9Vqb7j8TmRijU7B-0lNLhXfD92t32Ok5YmwtRC6bEm2ZvHo7BMo58RM-m4wBdZZy4mQ14eq5EJoZMln81X0T29qOCOgtRo5JSl977ZpqxeDGRjtyXHJI0nBWSwJQUPpfVKv6Ic1MaCKfd9y0tUoMQYgKx7COwmegmc1P1aS6ihJluRQVDbor2cDQlkAQK25rvQCN4VrBhFj5AX6xVncLy5zMj2HCgMPJmPGn1DIOQd',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Kovalen',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppPallete.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppPallete.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
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
            child: _isCardView ? _buildCardView() : _buildMapView(),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView() {
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
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  )
                ],
              ),
            ),
          ),
          // Active Card
          const Positioned.fill(
            bottom: 16,
            child: MatchmakingCard(
              name: 'Nadia Larasati',
              semester: '5',
              major: 'Ilmu Komputer',
              distance: '0.8 km (Fakultas MIPA)',
              matchPercentage: 85,
              imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBIFwWqJqSSmmCcJ3gXyskISvdu3eWF1s8X4z0ODVa39VvL9JcmBKoO4AaNXX4w8STFkQkh0XwHNg1ya7yR27QgAly8d-A_C7WAFmQ-6kgoLy127TLJFozN9ffmjchGieCqm3FVsPBA6bxE3AEPlijuO7mHOV-YzwkNfuOI9sqbgbmcd_3OPTAK_4f1VOBdv2VopIjMdMhpIzSOGOtp11EU9XN3KYqR1Wx1jOJjxUiAbFyL2vqDUydTMM7vebra_S140Rf1dv88tnG1',
              interests: ['Machine Learning', 'UI/UX Design', 'Data Science'],
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
