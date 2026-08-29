import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showDivider;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Icon(icon, color: AppPallete.primary),
          title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
          trailing: const Icon(Icons.chevron_right, color: AppPallete.outline),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(
            height: 1,
            thickness: 1,
            color: AppPallete.stroke,
            indent: 56, // Align with text
          ),
      ],
    );
  }
}
