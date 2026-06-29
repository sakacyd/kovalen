import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';

class ChatListItem extends StatelessWidget {
  final String name;
  final String time;
  final String messagePreview;
  final String? imageUrl;
  final String? initials;
  final int unreadCount;
  final bool isOnline;
  final bool isRead;

  const ChatListItem({
    super.key,
    required this.name,
    required this.time,
    required this.messagePreview,
    this.imageUrl,
    this.initials,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppPallete.stroke),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppPallete.secondaryContainer,
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null && initials != null
                      ? Text(
                          initials!,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppPallete.textSecondary,
                          ),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppPallete.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppPallete.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: unreadCount > 0 ? AppPallete.primary : AppPallete.textOutline,
                          fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (unreadCount == 0 && isRead) ...[
                        const Icon(
                          Icons.done_all,
                          size: 16,
                          color: AppPallete.textOutline,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          messagePreview,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: unreadCount > 0 ? AppPallete.textPrimary : AppPallete.textSecondary,
                            fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: AppPallete.primary,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppPallete.surface,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
