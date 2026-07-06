import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;
  final String avatarUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
    required this.avatarUrl,
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
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundColor: AppPallete.surfaceContainerHighest,
                backgroundImage: avatarUrl.trim().startsWith('http') ? NetworkImage(avatarUrl.trim()) : null,
                child: !avatarUrl.trim().startsWith('http') 
                  ? const Icon(Icons.person, size: 48, color: AppPallete.onSurfaceVariant)
                  : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppPallete.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          university,
          style: const TextStyle(fontSize: 16, color: AppPallete.textSecondary),
        ),
      ],
    );
  }
}
