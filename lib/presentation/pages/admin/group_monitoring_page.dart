import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/bloc/admin/admin_bloc.dart';
import 'package:kovalen/presentation/pages/admin/group_monitoring_detail_page.dart';
import 'package:kovalen/init_dependencies.dart';

class GroupMonitoringPage extends StatefulWidget {
  const GroupMonitoringPage({super.key});

  @override
  State<GroupMonitoringPage> createState() => _GroupMonitoringPageState();
}

class _GroupMonitoringPageState extends State<GroupMonitoringPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(AdminFetchGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pemantauan Grup'),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminGroupsLoaded) {
            final groups = state.groups;
            if (groups.isEmpty) {
              return const Center(child: Text('Tidak ada grup obrolan aktif.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.groups, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    title: Text(group.name ?? 'Grup Tanpa Nama'),
                    subtitle: Text('ID: ${group.id.substring(0, 8)}...'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => serviceLocator<AdminBloc>(),
                            child: GroupMonitoringDetailPage(
                              roomId: group.id,
                              groupName: group.name ?? 'Grup Tanpa Nama',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Gagal memuat grup.'));
        },
      ),
    );
  }
}
