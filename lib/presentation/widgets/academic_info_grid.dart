import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class AcademicInfoGrid extends StatelessWidget {
  final String programStudi;
  final int semester;
  final int ipk;

  const AcademicInfoGrid({
    super.key,
    required this.programStudi,
    required this.semester,
    required this.ipk,
  });

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPallete.surface,
        borderRadius: BorderRadius.circular(24), // Sesuai tema Clean Minimalism
        border: Border.all(color: AppPallete.stroke.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppPallete.primary),
              const SizedBox(width: 6),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppPallete.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppPallete.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Program Studi',
          value: programStudi,
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                title: 'Semester',
                value: semester.toString(),
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoCard(
                title: 'IPK',
                value: ipk.toString(),
                icon: Icons.star_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
