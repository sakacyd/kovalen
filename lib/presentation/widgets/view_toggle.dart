import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';

class ViewToggle extends StatelessWidget {
  final bool isCardView;
  final VoidCallback onToggle;

  const ViewToggle({
    super.key,
    required this.isCardView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppPallete.surfaceLightPurple, // wait, let's use a subtle surface color
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppPallete.stroke.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: !isCardView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isCardView ? AppPallete.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isCardView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.view_carousel_outlined,
                      size: 18,
                      color: isCardView ? AppPallete.primary : AppPallete.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Card View',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isCardView ? AppPallete.primary : AppPallete.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isCardView ? onToggle : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !isCardView ? AppPallete.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: !isCardView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 18,
                      color: !isCardView ? AppPallete.primary : AppPallete.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Map View',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: !isCardView ? AppPallete.primary : AppPallete.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
