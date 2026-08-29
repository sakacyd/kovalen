import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/bloc/admin/admin_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:intl/intl.dart';

class GroupMonitoringDetailPage extends StatefulWidget {
  final String roomId;
  final String groupName;

  const GroupMonitoringDetailPage({
    super.key,
    required this.roomId,
    required this.groupName,
  });

  @override
  State<GroupMonitoringDetailPage> createState() =>
      _GroupMonitoringDetailPageState();
}

class _GroupMonitoringDetailPageState extends State<GroupMonitoringDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(
      AdminFetchGroupDetailsEvent(roomId: widget.roomId),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Jadwal'),
              Tab(text: 'Rekaman Aktivitas'),
            ],
            indicatorColor: AppPallete.primary,
            labelColor: AppPallete.primary,
            unselectedLabelColor: AppPallete.textSecondary,
          ),
        ),
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminGroupDetailsLoaded) {
              return TabBarView(
                children: [
                  // Tab Jadwal
                  state.schedules.isEmpty
                      ? const Center(child: Text('Belum ada jadwal grup.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = state.schedules[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: Icon(
                                  schedule.isCompleted
                                      ? Icons.check_circle
                                      : Icons.schedule,
                                  color: schedule.isCompleted
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                title: Text(schedule.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dibuat: ${_formatDate(schedule.createdAt.toString())}',
                                    ),
                                    if (schedule.locationUrl != null &&
                                        schedule.locationUrl!.isNotEmpty)
                                      Text(
                                        'Lokasi: ${schedule.locationUrl}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                  // Tab Rekaman Aktivitas
                  state.activities.isEmpty
                      ? const Center(
                          child: Text('Belum ada rekaman aktivitas grup.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.activities.length,
                          itemBuilder: (context, index) {
                            final activity = state.activities[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aktivitas',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(activity.activitySummary),
                                    const SizedBox(height: 12),
                                    if (activity.materialCovered != null &&
                                        activity
                                            .materialCovered!
                                            .isNotEmpty) ...[
                                      Text(
                                        'Materi',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(activity.materialCovered!),
                                      const SizedBox(height: 12),
                                    ],
                                    if (activity.nextGoals != null &&
                                        activity.nextGoals!.isNotEmpty) ...[
                                      Text(
                                        'Target Berikutnya',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(activity.nextGoals!),
                                      const SizedBox(height: 12),
                                    ],
                                    Text(
                                      'Waktu Rekaman: ${_formatDate(activity.createdAt.toString())}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppPallete.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              );
            }

            return const Center(child: Text('Gagal memuat detail grup.'));
          },
        ),
      ),
    );
  }
}
