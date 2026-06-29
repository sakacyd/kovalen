import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class InterestsSection extends StatelessWidget {
  final List<String> interests;

  const InterestsSection({
    super.key,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPallete.stroke.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minat Saya',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPallete.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppPallete.surfaceVariant, // Warna aksen pudar
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.primary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}