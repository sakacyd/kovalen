import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/presentation/pages/home_page.dart';
import 'package:kovalen/presentation/pages/matchmaking_page.dart';
import 'package:kovalen/presentation/pages/messages_page.dart';
import 'package:kovalen/presentation/pages/profile_page.dart';
// ... import lainnya
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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => context.read<BottomNavCubit>().changeTab(i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppPallete.surface,
            selectedItemColor: AppPallete.primary,
            unselectedItemColor: AppPallete.textOutline,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_add),
                label: 'Matchmaking',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
