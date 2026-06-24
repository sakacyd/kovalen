import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  
  const StatsCard({
    super.key, 
    required this.title, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surfaceLightPurple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppPallete.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}