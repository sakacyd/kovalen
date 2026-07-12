import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/presentation/pages/home_page.dart';
import 'package:kovalen/presentation/pages/matchmaking_page.dart';
import 'package:kovalen/presentation/pages/messages_page.dart';
import 'package:kovalen/presentation/pages/profile_page.dart';
import 'package:kovalen/presentation/pages/admin/admin_dashboard_page.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/services/location_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static route() => MaterialPageRoute(builder: (_) => const MainPage());

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    // Cold start location update 1x
    LocationService(Supabase.instance.client).updateLocation1x();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, userState) {
        bool isAdminOrOwner = false;
        if (userState is AppUserLoggedIn) {
          final role = userState.user.role;
          isAdminOrOwner = role == 'admin' || role == 'owner';
        }

        final pages = [
          const HomePage(),
          const MatchmakingPage(),
          const MessagesPage(),
          const ProfilePage(),
          if (isAdminOrOwner) const AdminDashboardPage(),
        ];

        return BlocBuilder<BottomNavCubit, int>(
          builder: (context, index) {
            // Fallback in case index goes out of bounds when logging out / changing roles
            final currentIndex = index >= pages.length ? 0 : index;
            
            return Scaffold(
              body: IndexedStack(index: currentIndex, children: pages),
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
                  selectedIndex: currentIndex,
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
                    if (isAdminOrOwner)
                      NavigationDestination(
                        icon: Icon(
                          Icons.admin_panel_settings_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        selectedIcon: Icon(
                          Icons.admin_panel_settings,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        label: 'Admin',
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }
}
