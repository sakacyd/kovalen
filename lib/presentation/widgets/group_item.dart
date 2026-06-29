import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class GroupItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isAccentColors;

  const GroupItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isAccentColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPallete.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAccentColors
                  ? AppPallete.secondaryContainer
                  : AppPallete.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.group_outlined,
              color: isAccentColors
                  ? AppPallete.onSecondaryContainer
                  : AppPallete.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppPallete.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppPallete.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: AppPallete.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
