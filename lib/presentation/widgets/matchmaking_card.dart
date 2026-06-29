import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';

class MatchmakingCard extends StatelessWidget {
  final String name;
  final String semester;
  final String major;
  final String distance;
  final int matchPercentage;
  final String imageUrl;
  final List<String> interests;

  const MatchmakingCard({
    super.key,
    required this.name,
    required this.semester,
    required this.major,
    required this.distance,
    required this.matchPercentage,
    required this.imageUrl,
    required this.interests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPallete.stroke),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image Section
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppPallete.surfaceVariant);
                  },
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.2),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                // Compatibility Badge
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppPallete.primary,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppPallete.primaryLight.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.psychology, size: 14, color: AppPallete.surface),
                        const SizedBox(width: 4),
                        Text(
                          '$matchPercentage% Cocok',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppPallete.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Basic Info
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 24, // Adjusted for card size
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Semester $semester',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Details Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_outlined, size: 20, color: AppPallete.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        major,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 20, color: AppPallete.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        distance,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppPallete.stroke),
                  const SizedBox(height: 16),
                  Text(
                    'MINAT AKADEMIK',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppPallete.secondaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: AppPallete.secondaryContainer.withOpacity(0.3),
                          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
