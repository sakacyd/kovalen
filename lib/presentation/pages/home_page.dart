import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
      appBar: AppBar(
        backgroundColor: AppPallete.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppPallete.stroke, height: 1),
        ),
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 12),
            Text(
              'Kovalen',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(color: AppPallete.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppPallete.textSecondary,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                          text: state.user.fullName,
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
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppPallete.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppPallete.stroke),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.groups,
                                    size: 20,
                                    color: AppPallete.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'GRUP AKTIF',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              /* Text(
                                '${state.user.activeGroupsCount}',
                                style: Theme.of(context).textTheme.displayLarge,
                              ), */
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppPallete.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppPallete.stroke),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.handshake,
                                    size: 20,
                                    color: AppPallete.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'MATCH HARI INI',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  /* Text(
                                    '${state.user.matchesTodayCount}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(color: AppPallete.primary),
                                  ), */
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppPallete.success.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    /* child: Text(
                                      '+${state.user.newMatchesCount} Baru',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: AppPallete.success),
                                    ), */
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                          color: AppPallete.primary.withOpacity(0.25),
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
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Algoritma & Struktur Data membutuhkan partner.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
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

                  /* SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.user.activeStudyGroups.length,
                      itemBuilder: (context, index) {
                        final group = state.user.activeStudyGroups[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppPallete.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppPallete.stroke),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(group['color']),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        group['initial'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppPallete.background,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      group['time'],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                group['title'],
                                style: Theme.of(context).textTheme.displaySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                group['desc'],
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppPallete.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ), */
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
