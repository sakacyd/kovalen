import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/home_bloc.dart';
import 'package:kovalen/presentation/widgets/stats_card.dart';
import 'package:kovalen/presentation/widgets/group_item.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.displaySmall,
                      children: [
                        const TextSpan(text: 'Selamat datang, '),
                        TextSpan(
                          text: state.user.fullName.trim().split(' ').first,
                          style: const TextStyle(color: AppPallete.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${state.user.studyProgram} • Semester ${state.user.semester}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppPallete.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bento Stats
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          logo: Icons.groups,
                          title: 'Grup Aktif',
                          value: '${state.user.semester}',
                          secondValue: '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatsCard(
                          logo: Icons.handshake,
                          title: 'Match Hari Ini',
                          value: '${state.user.semester}',
                          secondValue: '${state.user.semester}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Prominent Banner Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppPallete.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppPallete.primary.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cari Rekan Belajar',
                                style: Theme.of(context).textTheme.displaySmall
                                    ?.copyWith(color: AppPallete.onPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Algoritma & Struktur Data membutuhkan partner.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppPallete.onPrimary.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<BottomNavCubit>().changeTab(1);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppPallete.onPrimary.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search,
                              color: AppPallete.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Active Groups List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Grup Belajar Aktif',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        'Lihat Semua',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppPallete.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: [
                      const GroupItem(
                        title: 'Algoritma & Struktur Data',
                        subtitle: '3/4 Anggota - Online',
                        time: 'Hari ini, 19:00',
                        isAccentColors: false,
                      ),
                      const GroupItem(
                        title: 'Mobile Development (Flutter)',
                        subtitle: '2/5 Anggota - Perpustakaan',
                        time: 'Besok, 10:00',
                        isAccentColors: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
