import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/message_room/message_room_bloc.dart';
import 'package:kovalen/presentation/bloc/messages_bloc.dart';
import 'package:kovalen/presentation/bloc/message_room/room_detail_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';
import 'package:kovalen/presentation/pages/group_schedule_page.dart';
import 'package:kovalen/presentation/pages/message_room/personal_room_detail_page.dart';
import 'package:kovalen/presentation/pages/message_room/group_room_detail_page.dart';
import 'package:kovalen/init_dependencies.dart';

class MessageRoomPage extends StatefulWidget {
  final String roomId;
  final String name;
  final String? avatarUrl;
  final bool isGroup;
  final String? partnerId;

  const MessageRoomPage({
    super.key,
    required this.roomId,
    required this.name,
    this.avatarUrl,
    this.isGroup = false,
    this.partnerId,
  });

  static route({
    required String roomId,
    required String name,
    String? avatarUrl,
    bool isGroup = false,
    String? partnerId,
  }) => MaterialPageRoute(
    builder: (context) =>
        MessageRoomPage(roomId: roomId, name: name, avatarUrl: avatarUrl, isGroup: isGroup, partnerId: partnerId),
  );

  @override
  State<MessageRoomPage> createState() => _MessageRoomPageState();
}

class _MessageRoomPageState extends State<MessageRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MessageRoomBloc>().add(LoadMessageRoomMessages(widget.roomId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<MessageRoomBloc>().add(
        SendMessageRoomMessageEvent(widget.roomId, content),
      );
      _messageController.clear();
      // Wait for UI to update then scroll down
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _showAddGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPallete.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return BlocProvider(
          create: (_) => serviceLocator<RoomDetailBloc>(),
          child: Builder(
            builder: (blocContext) {
              return BlocListener<RoomDetailBloc, RoomDetailState>(
                listener: (context, state) {
                  if (state is RoomDetailFailure) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message, style: const TextStyle(color: AppPallete.error))),
                    );
                  } else if (state is AddUserToGroupSuccess) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Berhasil menambahkan ${widget.name} ke grup"),
                        backgroundColor: AppPallete.success,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.7,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag Handle
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppPallete.stroke,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Undang ke Grup',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppPallete.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pilih grup untuk menambahkan ${widget.name}.',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppPallete.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppPallete.stroke),
                        Flexible(
                          child: BlocBuilder<MessagesBloc, MessagesState>(
                            builder: (context, messagesState) {
                              if (messagesState is MessagesSuccess) {
                                final groupRooms = messagesState.rooms.where((r) => r.type == 'group').toList();
                                
                                if (groupRooms.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(32),
                                    child: Center(
                                      child: Text(
                                        'Anda belum bergabung dengan grup manapun.',
                                        style: TextStyle(color: AppPallete.onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: groupRooms.length,
                                  itemBuilder: (context, index) {
                                    final group = groupRooms[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: AppPallete.surfaceContainer,
                                        backgroundImage: group.avatarUrl != null && group.avatarUrl!.trim().startsWith('http')
                                            ? NetworkImage(group.avatarUrl!.trim())
                                            : null,
                                        child: group.avatarUrl == null || !group.avatarUrl!.trim().startsWith('http')
                                            ? Text(
                                                (group.name?.isNotEmpty ?? false) ? group.name![0].toUpperCase() : 'G',
                                                style: const TextStyle(
                                                  color: AppPallete.onSurface,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : null,
                                      ),
                                      title: Text(
                                        group.name ?? 'Group',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: AppPallete.textPrimary,
                                        ),
                                      ),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) {
                                            return AlertDialog(
                                              backgroundColor: AppPallete.surface,
                                              title: const Text('Konfirmasi', style: TextStyle(color: AppPallete.textPrimary)),
                                              content: Text(
                                                'Apakah Anda yakin ingin menambahkan ${widget.name} ke grup ${group.name}?',
                                                style: const TextStyle(color: AppPallete.onSurfaceVariant),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(dialogContext),
                                                  child: const Text('Batal', style: TextStyle(color: AppPallete.onSurfaceVariant)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(dialogContext);
                                                    if (widget.partnerId != null) {
                                                      blocContext.read<RoomDetailBloc>().add(
                                                        AddUserToGroupEvent(
                                                          roomId: group.id,
                                                          userId: widget.partnerId!,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Ya, Tambahkan', style: TextStyle(color: AppPallete.primary, fontWeight: FontWeight.bold)),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    final currentUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        backgroundColor: AppPallete.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppPallete.onSurfaceVariant),
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppPallete.stroke, height: 1.0),
        ),
        title: BlocBuilder<MessagesBloc, MessagesState>(
          builder: (context, messagesState) {
            String currentName = widget.name;
            String? currentAvatarUrl = widget.avatarUrl;

            if (messagesState is MessagesSuccess) {
              try {
                final room = messagesState.rooms.firstWhere((r) => r.id == widget.roomId);
                currentName = room.name ?? room.otherUser?.fullName ?? widget.name;
                currentAvatarUrl = room.type == 'group' ? room.avatarUrl : room.otherUser?.avatarUrl;
              } catch (_) {
                // Room not found, fallback to widget fields
              }
            }

            return GestureDetector(
              onTap: () {
                if (widget.isGroup) {
                  Navigator.push(context, GroupRoomDetailPage.route(roomId: widget.roomId));
                } else if (widget.partnerId != null) {
                  Navigator.push(context, PersonalRoomDetailPage.route(userId: widget.partnerId!));
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppPallete.surfaceContainer,
                      border: Border.all(color: AppPallete.stroke),
                      image: currentAvatarUrl != null && currentAvatarUrl.trim().startsWith('http')
                          ? DecorationImage(
                              image: NetworkImage(currentAvatarUrl.trim()),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            )
                          : null,
                    ),
                    child: currentAvatarUrl == null || !currentAvatarUrl.trim().startsWith('http')
                        ? Center(
                            child: Text(
                              currentName.isNotEmpty ? currentName[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: AppPallete.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppPallete.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppPallete.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppPallete.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          if (widget.isGroup)
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              tooltip: 'Jadwal Pertemuan',
              onPressed: () {
                Navigator.push(context, GroupSchedulePage.route(roomId: widget.roomId));
              },
            ),
          if (!widget.isGroup)
            IconButton(
              icon: const Icon(Icons.group_add_outlined),
              tooltip: 'Undang ke Grup',
              onPressed: () => _showAddGroupBottomSheet(context),
            ),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: AppPallete.surfaceBright,
              child: BlocConsumer<MessageRoomBloc, MessageRoomState>(
                listener: (context, state) {
                  if (state is MessageRoomSuccess) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (_scrollController.hasClients) {
                        _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent,
                        );
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is MessageRoomFailure) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppPallete.error),
                      ),
                    );
                  } else if (state is MessageRoomSuccess) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == currentUser.id;

                        final time =
                            '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

                        if (message.isSystemMessage) {
                          String systemMessageText = message.content;
                          if (message.senderId == currentUser.id) {
                            systemMessageText = "Anda $systemMessageText";
                          } else {
                            final senderName = message.senderName?.split(' ').first ?? 'Seseorang';
                            systemMessageText = "$senderName $systemMessageText";
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppPallete.surfaceContainerHighest.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  systemMessageText,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppPallete.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe)
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(
                                    right: 8,
                                    bottom: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppPallete.surfaceContainer,
                                    image:
                                        message.senderAvatarUrl != null &&
                                            message.senderAvatarUrl!.trim().startsWith(
                                              'http',
                                            )
                                        ? DecorationImage(
                                            image: NetworkImage(
                                              message.senderAvatarUrl!.trim(),
                                            ),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) {},
                                          )
                                        : null,
                                  ),
                                  child:
                                      message.senderAvatarUrl == null ||
                                          !message.senderAvatarUrl!.trim().startsWith(
                                            'http',
                                          )
                                      ? Center(
                                          child: Text(
                                            (message.senderName?.isNotEmpty ?? false)
                                                ? message.senderName![0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppPallete.onSurface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),

                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? AppPallete.primary
                                        : AppPallete.surface,
                                    border: isMe
                                        ? null
                                        : Border.all(color: AppPallete.stroke),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(
                                        isMe ? 16 : 2,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMe ? 2 : 16,
                                      ),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x05000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isMe
                                              ? AppPallete.onPrimary
                                              : AppPallete.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            time,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isMe
                                                  ? AppPallete.onPrimary
                                                        .withValues(alpha: 0.7)
                                                  : AppPallete.outline,
                                            ),
                                          ),
                                          if (isMe) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.done_all,
                                              size: 14,
                                              color: AppPallete.onPrimary
                                                  .withValues(alpha: 0.7),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom + 8
                  : 16,
            ),
            decoration: BoxDecoration(
              color: AppPallete.surface,
              boxShadow: [
                BoxShadow(
                  color: AppPallete.onSurface.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPallete.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppPallete.stroke.withValues(alpha: 0.5),
                      ),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: TextStyle(
                          color: AppPallete.onSurfaceVariant,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppPallete.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  margin: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                    color: AppPallete.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.send_rounded),
                    ),
                    color: AppPallete.onPrimary,
                    iconSize: 22,
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
