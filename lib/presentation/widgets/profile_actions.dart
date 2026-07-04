import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';
import 'package:kovalen/presentation/pages/settings_page.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, SettingsPage.route());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.surface,
            foregroundColor: AppPallete.textPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppPallete.stroke.withValues(alpha: 0.3)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            minimumSize: const Size(double.infinity, 56),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.settings_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                'Pengaturan Akun',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
