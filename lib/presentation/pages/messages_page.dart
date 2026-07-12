import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kovalen/presentation/bloc/message_room/message_room_bloc.dart';
import '../../core/theme/app_pallete.dart';
import '../bloc/messages_bloc.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/custom_app_bar.dart';
import 'message_room_page.dart';
import 'package:kovalen/core/common/entities/chat_room.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessagesBloc>().add(LoadMessagesData());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildChatList(List<ChatRoom> rooms, String emptyMessage) {
    if (rooms.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppPallete.textOutline,
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        final name = room.name ?? room.otherUser?.fullName ?? 'Unknown User';
        final time = room.lastMessageTime != null
            ? '${room.lastMessageTime!.hour.toString().padLeft(2, '0')}:${room.lastMessageTime!.minute.toString().padLeft(2, '0')}'
            : '';
        final preview = room.lastMessage ?? 'Belum ada pesan';
        final imageUrl = room.otherUser?.avatarUrl;
        final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

        return ChatListItem(
          name: name,
          time: time,
          messagePreview: preview,
          imageUrl: imageUrl,
          initials: initials,
          unreadCount: 0,
          isOnline: false,
          isRead: true,
          onTap: () {
            Navigator.push(
              context,
              MessageRoomPage.route(
                roomId: room.id,
                name: name,
                avatarUrl: imageUrl,
                isGroup: room.type == 'group',
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppPallete.background,
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              // Search Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppPallete.onSurface.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Cari kontak atau pesan...',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPallete.textOutline,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppPallete.textOutline,
                      ),
                      filled: true,
                      fillColor: AppPallete.surface,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppPallete.stroke),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppPallete.stroke),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppPallete.primary),
                      ),
                    ),
                  ),
                ),
              ),

              // TabBar Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TabBar(
                  labelColor: AppPallete.primary,
                  unselectedLabelColor: AppPallete.textOutline,
                  indicatorColor: AppPallete.primary,
                  indicatorWeight: 3,
                  labelStyle: Theme.of(context).textTheme.labelLarge,
                  unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
                  tabs: const [
                    Tab(text: 'Personal'),
                    Tab(text: 'Grup'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Messages List Container
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BlocListener<MessageRoomBloc, MessageRoomState>(
                    listener: (context, state) {
                      if (state is MessageRoomSuccess) {
                        context.read<MessagesBloc>().add(LoadMessagesData());
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppPallete.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppPallete.stroke),
                        boxShadow: [
                          BoxShadow(
                            color: AppPallete.onSurface.withValues(alpha: 0.04),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: BlocBuilder<MessagesBloc, MessagesState>(
                        builder: (context, state) {
                          if (state is MessagesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: AppPallete.primary,
                              ),
                            );
                          } else if (state is MessagesFailure) {
                            return Center(child: Text(state.message));
                          } else if (state is MessagesSuccess) {
                            // Filter chats based on type
                            final personalRooms = state.rooms.where((r) => r.type == 'personal').toList();
                            final groupRooms = state.rooms.where((r) => r.type == 'group').toList();
                            
                            return TabBarView(
                              children: [
                                _buildChatList(personalRooms, 'Belum ada pesan personal'),
                                _buildChatList(groupRooms, 'Belum ada pesan grup'),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
