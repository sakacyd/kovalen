import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/widgets/custom_app_bar.dart';
import 'package:kovalen/presentation/bloc/admin/admin_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/core/common/entities/user.dart';

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

  void _showRoleDialog(BuildContext context, User targetUser, String currentUserId, String currentUserRole) {
    if (currentUserRole != 'owner') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hanya Owner yang dapat mengubah role admin.')),
      );
      return;
    }

    if (targetUser.id == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda tidak dapat mengubah role Anda sendiri.')),
      );
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
                    AdminChangeUserRoleEvent(userId: targetUser.id, newRole: 'admin'),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Jadikan Pelanggan'),
                leading: const Icon(Icons.person),
                onTap: () {
                  context.read<AdminBloc>().add(
                    AdminChangeUserRoleEvent(userId: targetUser.id, newRole: 'pelanggan'),
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

  void _showDeleteDialog(BuildContext context, User targetUser, String currentUserId, String currentUserRole) {
    if (currentUserRole != 'owner') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hanya Owner yang dapat menghapus pengguna secara permanen.')),
      );
      return;
    }

    if (targetUser.id == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda tidak dapat menghapus akun Anda sendiri.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pengguna?'),
          content: Text('Apakah Anda yakin ingin menghapus akun ${targetUser.fullName}? Tindakan ini tidak dapat dibatalkan.'),
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AdminActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage(user.avatarUrl) : null,
                      child: user.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
                    ),
                    title: Text(user.fullName.isNotEmpty ? user.fullName : 'Tanpa Nama'),
                    subtitle: Text('Role: ${user.role} | Skor: ${user.ratingScore.toStringAsFixed(1)} (${user.ratingCount})'),
                    trailing: currentUserRole == 'owner' ? PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'role') {
                          _showRoleDialog(context, user, currentUserId, currentUserRole);
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, user, currentUserId, currentUserRole);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'role',
                          child: Text('Ubah Role'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Hapus Permanen', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ) : null,
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
