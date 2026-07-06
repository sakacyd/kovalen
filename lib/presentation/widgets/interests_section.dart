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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.stroke),
        boxShadow: [
          BoxShadow(
            color: AppPallete.onSurface.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minat Saya',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppPallete.surfaceContainerHighest, 
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppPallete.stroke),
                ),
                child: Text(
                  interest,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}