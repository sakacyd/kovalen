import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/bloc/admin/admin_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/user.dart';
import 'package:intl/intl.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(AdminFetchUsersEvent());
  }

  void _showRoleDialog(
    BuildContext context,
    User targetUser,
    String currentUserId,
    String currentUserRole,
  ) {
    if (currentUserRole != 'owner') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hanya Owner yang dapat mengubah role pengguna.'),
        ),
      );
      return;
    }

    if (targetUser.id == currentUserId) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Role Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Jadikan Admin'),
                leading: const Icon(Icons.admin_panel_settings),
                onTap: () {
                  context.read<AdminBloc>().add(
                    AdminChangeUserRoleEvent(
                      userId: targetUser.id,
                      newRole: 'admin',
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Jadikan Pelanggan'),
                leading: const Icon(Icons.person),
                onTap: () {
                  context.read<AdminBloc>().add(
                    AdminChangeUserRoleEvent(
                      userId: targetUser.id,
                      newRole: 'pelanggan',
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    User targetUser,
    String currentUserId,
    String currentUserRole,
  ) {
    if (targetUser.id == currentUserId) return;
    if (targetUser.role == 'owner') return;

    if (currentUserRole == 'admin' && targetUser.role != 'pelanggan') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin hanya dapat menghapus akun Pelanggan.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengguna?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus akun ${targetUser.fullName}? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AdminBloc>().add(
                  AdminDeleteUserEvent(userId: targetUser.id),
                );
                Navigator.pop(context);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showStatusDialog(
    BuildContext context,
    User targetUser,
    String currentUserId,
    String currentUserRole,
  ) {
    if (targetUser.id == currentUserId) return;
    if (targetUser.role == 'owner') return;

    if (currentUserRole == 'admin' && targetUser.role != 'pelanggan') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin hanya dapat mengubah status Pelanggan.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Status Pengguna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (targetUser.status != 'active')
                ListTile(
                  title: const Text('Aktifkan Kembali (Unban)'),
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  onTap: () {
                    context.read<AdminBloc>().add(
                      AdminChangeUserStatusEvent(
                        userId: targetUser.id,
                        status: 'active',
                        suspendedUntil: null,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              if (targetUser.status != 'banned')
                ListTile(
                  title: const Text('Ban Permanen'),
                  leading: const Icon(Icons.block, color: Colors.red),
                  onTap: () {
                    context.read<AdminBloc>().add(
                      AdminChangeUserStatusEvent(
                        userId: targetUser.id,
                        status: 'banned',
                        suspendedUntil: null,
                      ),
                    );
                    Navigator.pop(context);
                  },
                ),
              if (targetUser.status != 'suspended')
                ListTile(
                  title: const Text('Suspend Sementara'),
                  leading: const Icon(Icons.timer, color: Colors.orange),
                  onTap: () {
                    Navigator.pop(context);
                    _showSuspendDurationDialog(context, targetUser);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSuspendDurationDialog(BuildContext context, User targetUser) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Durasi Suspend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSuspendOption(
                context,
                targetUser,
                '1 Hari',
                const Duration(days: 1),
              ),
              _buildSuspendOption(
                context,
                targetUser,
                '3 Hari',
                const Duration(days: 3),
              ),
              _buildSuspendOption(
                context,
                targetUser,
                '7 Hari',
                const Duration(days: 7),
              ),
              _buildSuspendOption(
                context,
                targetUser,
                '30 Hari',
                const Duration(days: 30),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuspendOption(
    BuildContext context,
    User targetUser,
    String label,
    Duration duration,
  ) {
    return ListTile(
      title: Text(label),
      onTap: () {
        final suspendedUntil = DateTime.now().add(duration);
        context.read<AdminBloc>().add(
          AdminChangeUserStatusEvent(
            userId: targetUser.id,
            status: 'suspended',
            suspendedUntil: suspendedUntil,
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  String _buildSubtitle(User user) {
    String sub =
        'Role: ${user.role} | Skor: ${user.ratingScore.toStringAsFixed(1)} (${user.ratingCount})';
    if (user.status == 'banned') {
      sub += '\nStatus: Banned';
    } else if (user.status == 'suspended' && user.suspendedUntil != null) {
      final formatter = DateFormat('dd MMM yyyy, HH:mm');
      sub +=
          '\nStatus: Suspended (s.d. ${formatter.format(user.suspendedUntil!.toLocal())})';
    } else {
      sub += '\nStatus: Active';
    }
    return sub;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AppUserCubit>().state;
    String currentUserId = '';
    String currentUserRole = '';

    if (authState is AppUserLoggedIn) {
      currentUserId = authState.user.id;
      currentUserRole = authState.user.role;
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Manajemen Pengguna'),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is AdminError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AdminActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminUsersLoaded) {
            final users = state.users;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                bool canManage = false;
                if (currentUserRole == 'owner' &&
                    user.role != 'owner' &&
                    user.id != currentUserId) {
                  canManage = true;
                } else if (currentUserRole == 'admin' &&
                    user.role == 'pelanggan') {
                  canManage = true;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatarUrl.isNotEmpty
                          ? NetworkImage(user.avatarUrl)
                          : null,
                      child: user.avatarUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      user.fullName.isNotEmpty ? user.fullName : 'Tanpa Nama',
                    ),
                    subtitle: Text(_buildSubtitle(user)),
                    isThreeLine: true,
                    trailing: canManage
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'role') {
                                _showRoleDialog(
                                  context,
                                  user,
                                  currentUserId,
                                  currentUserRole,
                                );
                              } else if (value == 'status') {
                                _showStatusDialog(
                                  context,
                                  user,
                                  currentUserId,
                                  currentUserRole,
                                );
                              } else if (value == 'delete') {
                                _showDeleteDialog(
                                  context,
                                  user,
                                  currentUserId,
                                  currentUserRole,
                                );
                              }
                            },
                            itemBuilder: (context) {
                              final items = <PopupMenuEntry<String>>[];
                              if (currentUserRole == 'owner') {
                                items.add(
                                  const PopupMenuItem(
                                    value: 'role',
                                    child: Text('Ubah Role'),
                                  ),
                                );
                              }
                              items.add(
                                const PopupMenuItem(
                                  value: 'status',
                                  child: Text('Ubah Status (Ban/Suspend)'),
                                ),
                              );
                              items.add(
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Hapus Permanen',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              );
                              return items;
                            },
                          )
                        : null,
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Tidak ada data pengguna.'));
        },
      ),
    );
  }
}
