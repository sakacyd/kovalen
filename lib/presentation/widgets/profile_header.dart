import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;
  final String avatarUrl;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.university,
    required this.avatarUrl,
  }) : super(key: key);

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
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(avatarUrl),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppPallete.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppPallete.surface, width: 3),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.edit,
                color: AppPallete.surface,
                size: 16,
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
