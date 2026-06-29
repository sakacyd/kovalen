import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/presentation/pages/home_page.dart';
import 'package:kovalen/presentation/pages/matchmaking_page.dart';
import 'package:kovalen/presentation/pages/messages_page.dart';
import 'package:kovalen/presentation/pages/profile_page.dart';
import 'package:kovalen/core/theme/app_pallete.dart'; // Pastikan ini di-import

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static route() => MaterialPageRoute(builder: (_) => const MainPage());

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomePage(),
      MatchmakingPage(),
      MessagesPage(),
      ProfilePage(),
    ];

    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, index) {
        return Scaffold(
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) =>
                  context.read<BottomNavCubit>().changeTab(i),
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              indicatorColor: Theme.of(context).colorScheme.primaryContainer,
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  selectedIcon: Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.people_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  selectedIcon: Icon(
                    Icons.people,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Matchmaking',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  selectedIcon: Icon(
                    Icons.chat_bubble,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Pesan',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  selectedIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
