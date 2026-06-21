// main_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/presentation/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static route() => MaterialPageRoute(builder: (_) => const MainPage());

  @override
  Widget build(BuildContext context) {
    final pages = const [HomePage()];

    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, index) {
        return Scaffold(
          body: IndexedStack(index: index, children: pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) => context.read<BottomNavCubit>().changeTab(i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: 'Assignments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
            ],
          ),
        );
      },
    );
  }
}
