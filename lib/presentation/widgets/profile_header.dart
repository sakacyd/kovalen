import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;
  final String avatarUrl;
  final double ratingScore;
  final int ratingCount;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
    required this.avatarUrl,
    this.ratingScore = 0.0,
    this.ratingCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppPallete.surface, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppPallete.onSurface.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundColor: AppPallete.surfaceContainerHighest,
                backgroundImage: avatarUrl.trim().startsWith('http') ? NetworkImage(avatarUrl.trim()) : null,
                onBackgroundImageError: avatarUrl.trim().startsWith('http') ? (exception, stackTrace) {} : null,
                child: !avatarUrl.trim().startsWith('http') 
                  ? const Icon(Icons.person, size: 48, color: AppPallete.onSurfaceVariant)
                  : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          university,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppPallete.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        if (ratingCount > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${ratingScore.toStringAsFixed(1)} ($ratingCount ulasan)',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppPallete.textOutline),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
