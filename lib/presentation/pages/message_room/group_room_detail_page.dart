import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/message_room/room_detail_bloc.dart';

class GroupRoomDetailPage extends StatefulWidget {
  final String roomId;

  const GroupRoomDetailPage({super.key, required this.roomId});

  static route({required String roomId}) => MaterialPageRoute(
    builder: (context) => GroupRoomDetailPage(roomId: roomId),
  );

  @override
  State<GroupRoomDetailPage> createState() => _GroupRoomDetailPageState();
}

class _GroupRoomDetailPageState extends State<GroupRoomDetailPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<RoomDetailBloc>().add(FetchGroupRoomDetailEvent(widget.roomId));
  }

  void _editGroupName(String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppPallete.surface,
          title: const Text('Edit Nama Grup', style: TextStyle(color: AppPallete.onSurface)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama grup baru',
            ),
            style: const TextStyle(color: AppPallete.onSurface),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty && newName != currentName) {
                  context.read<RoomDetailBloc>().add(
                    UpdateGroupProfileEvent(roomId: widget.roomId, name: newName),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(String currentName) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<RoomDetailBloc>().add(
        UpdateGroupProfileEvent(
          roomId: widget.roomId,
          name: currentName,
          avatarFile: File(image.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        title: const Text('Profil Grup'),
        backgroundColor: AppPallete.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppPallete.onSurfaceVariant),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppPallete.stroke, height: 1.0),
        ),
      ),
      body: BlocConsumer<RoomDetailBloc, RoomDetailState>(
        listener: (context, state) {
          if (state is RoomDetailFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RoomDetailLoading) {
            return const Center(child: CircularProgressIndicator(color: AppPallete.primary));
          } else if (state is GroupRoomDetailLoaded) {
            final room = state.room;
            final participants = state.participants;
            final name = room.name ?? 'Grup Tanpa Nama';

            return RefreshIndicator(
              onRefresh: () async {
                context.read<RoomDetailBloc>().add(FetchGroupRoomDetailEvent(widget.roomId));
              },
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  // Group Image
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPallete.surfaceContainer,
                            image: room.avatarUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(room.avatarUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            border: Border.all(color: AppPallete.stroke, width: 2),
                          ),
                          child: room.avatarUrl == null
                              ? const Icon(Icons.group, size: 64, color: AppPallete.onSurfaceVariant)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _pickImage(name),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppPallete.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: AppPallete.surface, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Group Name
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppPallete.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppPallete.primary, size: 20),
                          onPressed: () => _editGroupName(name),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${participants.length} Partisipan',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppPallete.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: AppPallete.stroke),
                  const SizedBox(height: 16),
                  
                  // Participants List
                  Text(
                    'DAFTAR PARTISIPAN',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.2,
                          color: AppPallete.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: participants.length,
                    itemBuilder: (context, index) {
                      final participant = participants[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: AppPallete.surfaceContainer,
                          backgroundImage: participant.avatarUrl.isNotEmpty
                              ? NetworkImage(participant.avatarUrl)
                              : null,
                          child: participant.avatarUrl.isEmpty
                              ? Text(
                                  participant.fullName[0].toUpperCase(),
                                  style: const TextStyle(color: AppPallete.onSurface),
                                )
                              : null,
                        ),
                        title: Text(
                          participant.fullName,
                          style: const TextStyle(color: AppPallete.onSurface, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          participant.studyProgramName ?? participant.studyProgramId,
                          style: const TextStyle(color: AppPallete.textSecondary),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
