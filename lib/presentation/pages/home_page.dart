import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/common/cubits/bottom_nav_cubit.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/home_bloc.dart';
import 'package:kovalen/presentation/bloc/messages_tab_cubit.dart';
import 'package:kovalen/presentation/pages/message_room_page.dart';
import 'package:kovalen/presentation/bloc/profile_settings_bloc.dart';
import 'package:kovalen/presentation/widgets/stats_card.dart';
import 'package:kovalen/presentation/widgets/group_item.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/bloc/message_room/room_detail_bloc.dart';

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
            listener: (context, state) {
              if (state is UpdateProfileSettingsSuccess) {
                context.read<HomeBloc>().add(LoadHomeData());
              } else if (state is ProfileSettingsFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<RoomDetailBloc, RoomDetailState>(
            listener: (context, state) {
              if (state is GroupRoomDetailLoaded) {
                // Refresh home data when room details change
                context.read<HomeBloc>().add(LoadHomeData());
              }
            },
          ),
        ],

        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeSuccess) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
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
                      '${state.user.studyProgramName ?? state.user.studyProgramId} • Semester ${state.user.semester}',
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
                            value: '${state.stats.activeGroups}',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsCard(
                            logo: Icons.handshake,
                            title: 'Match',
                            value: '${state.stats.totalMatches}',
                            secondValue: '${state.stats.matchesToday}',
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(color: AppPallete.onPrimary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.randomInterest != null 
                                      ? '${state.randomInterest} membutuhkan partner.' 
                                      : 'Temukan rekan belajar yang cocok dengan Anda.',
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
                        GestureDetector(
                          onTap: () {
                            context.read<BottomNavCubit>().changeTab(2);
                            context.read<MessagesTabCubit>().changeTab(1);
                          },
                          child: Text(
                            'Lihat Semua',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppPallete.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (state.activeGroups.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: Text('Belum ada grup aktif'),
                        ),
                      )
                    else
                      Column(
                        children: List.generate(state.activeGroups.length, (index) {
                          final group = state.activeGroups[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessageRoomPage(
                                    roomId: group.id,
                                    name: group.name ?? 'Grup Belajar',
                                    avatarUrl: null,
                                    isGroup: group.type == 'group'
                                  ),
                                ),
                              );
                            },
                            child: GroupItem(
                              title: group.name ?? 'Grup Belajar',
                              subtitle: 'Grup Aktif',
                              time: '',
                              isAccentColors: index % 2 != 0,
                              imageUrl: group.avatarUrl,
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              );
            } else if (state is HomeFailure) {
              return Center(
                child: Text('Gagal memuat beranda: ${state.message}', textAlign: TextAlign.center),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
