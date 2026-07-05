import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/bloc/message_room/message_room_bloc.dart';
import 'package:kovalen/core/common/cubits/app_user_cubit.dart';

class MessageRoomPage extends StatefulWidget {
  final String roomId;
  final String name;
  final String? avatarUrl;

  const MessageRoomPage({
    super.key,
    required this.roomId,
    required this.name,
    this.avatarUrl,
  });

  static route({
    required String roomId,
    required String name,
    String? avatarUrl,
  }) =>
      MaterialPageRoute(
        builder: (context) => MessageRoomPage(
          roomId: roomId,
          name: name,
          avatarUrl: avatarUrl,
        ),
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
      context.read<MessageRoomBloc>().add(SendMessageRoomMessageEvent(widget.roomId, content));
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

  @override
  Widget build(BuildContext context) {
    final currentUser = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    
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
          child: Container(
            color: AppPallete.stroke,
            height: 1.0,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppPallete.surfaceContainer,
                border: Border.all(color: AppPallete.stroke),
                image: widget.avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: widget.avatarUrl == null
                  ? Center(
                      child: Text(
                        widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
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
                    widget.name,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
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
                        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    });
                  }
                },
                builder: (context, state) {
                  if (state is MessageRoomLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessageRoomFailure) {
                    return Center(child: Text(state.message, style: const TextStyle(color: AppPallete.error)));
                  } else if (state is MessageRoomSuccess) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == currentUser.id;
                        
                        final time = '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe)
                                Container(
                                  width: 24,
                                  height: 24,
                                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppPallete.surfaceContainer,
                                    image: widget.avatarUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(widget.avatarUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: widget.avatarUrl == null
                                      ? Center(
                                          child: Text(
                                            widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isMe ? AppPallete.primary : AppPallete.surface,
                                    border: isMe ? null : Border.all(color: AppPallete.stroke),
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(isMe ? 16 : 2),
                                      bottomRight: Radius.circular(isMe ? 2 : 16),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x05000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isMe ? AppPallete.onPrimary : AppPallete.textPrimary,
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
                                              color: isMe ? AppPallete.onPrimary.withValues(alpha: 0.7) : AppPallete.outline,
                                            ),
                                          ),
                                          if (isMe) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.done_all,
                                              size: 14,
                                              color: AppPallete.onPrimary.withValues(alpha: 0.7),
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
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom > 0 
                  ? MediaQuery.of(context).padding.bottom 
                  : 12,
            ),
            decoration: const BoxDecoration(
              color: AppPallete.surface,
              border: Border(
                top: BorderSide(color: AppPallete.stroke),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                )
              ],
            ),
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppPallete.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppPallete.stroke),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      color: AppPallete.onSurfaceVariant,
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: TextField(
                          controller: _messageController,
                          maxLines: 5,
                          minLines: 1,
                          decoration: const InputDecoration(
                            hintText: 'Tulis pesan...',
                            hintStyle: TextStyle(
                              color: AppPallete.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppPallete.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 2, right: 2),
                      decoration: BoxDecoration(
                        color: AppPallete.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        color: AppPallete.onPrimary,
                        iconSize: 20,
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
