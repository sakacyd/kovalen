import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class StatsCard extends StatelessWidget {
  final IconData logo;
  final String title;
  final String value;
  final String secondValue;

  const StatsCard({
    super.key,
    required this.logo,
    required this.title,
    required this.value,
    required this.secondValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppPallete.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(logo, size: 20, color: AppPallete.textSecondary),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.displayLarge?.copyWith(color: AppPallete.primary),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppPallete.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  secondValue,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppPallete.success),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
