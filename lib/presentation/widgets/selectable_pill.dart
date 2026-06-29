import 'package:flutter/material.dart';
import '../../core/theme/app_pallete.dart';

class SelectablePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectablePill({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppPallete.primary 
              : AppPallete.secondaryContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? AppPallete.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: isSelected ? AppPallete.surface : AppPallete.textSecondary,
          ),
        ),
      ),
    );
  }
}
