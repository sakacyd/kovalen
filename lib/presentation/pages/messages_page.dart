import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_pallete.dart';
import '../bloc/messages_bloc.dart';
import '../widgets/chat_list_item.dart';

class MessagesPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => MessagesBloc()..add(LoadMessagesData()),
          child: const MessagesPage(),
        ),
      );
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPallete.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppPallete.surface,
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
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA6_8ztsLxf2Z3wE8lVk4oCeZJu4O9ZeXP0EBNHkP9DnjR48r0uVG-u8yPqdrYi96rRBL8N7u1BtvOroR7SQ1FzUuqpSDEqBovbs-N6w9Ib28x9rOzNw0kYvG8lwJkAFqHSx5WO5whMY8uUD2l8iLtyNB2DKhrakSshngwdeHQWYqY8kvdiirwgD5HttE3zJZrodA600Jotxqrkf5D9ec5Bn4gH11I3hSVICNxbtVrIfiLXiILYnx_YYasnpPHzjPTJE-4nQ2kLAatv',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Kovalen',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppPallete.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppPallete.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                      color: AppPallete.onSurface.withOpacity(0.04),
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
                    prefixIcon: const Icon(Icons.search, color: AppPallete.textOutline),
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
            
            // Messages List Container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPallete.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppPallete.stroke),
                    boxShadow: [
                      BoxShadow(
                        color: AppPallete.onSurface.withOpacity(0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: BlocBuilder<MessagesBloc, MessagesState>(
                    builder: (context, state) {
                      if (state is MessagesLoading) {
                        return const Center(child: CircularProgressIndicator(color: AppPallete.primary));
                      } else if (state is MessagesFailure) {
                        return Center(child: Text(state.message));
                      } else if (state is MessagesSuccess) {
                        if (state.messages.isEmpty) {
                          return const Center(child: Text('No messages'));
                        }
                        return ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
                            return ChatListItem(
                              name: msg.name,
                              time: msg.time,
                              messagePreview: msg.preview,
                              imageUrl: msg.imageUrl,
                              initials: msg.initials,
                              unreadCount: msg.unreadCount,
                              isOnline: msg.isOnline,
                              isRead: msg.isRead,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
