import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class AcademicInfoGrid extends StatelessWidget {
  final String programStudi;
  final int semester;
  final double ipk;

  const AcademicInfoGrid({
    super.key,
    required this.programStudi,
    required this.semester,
    required this.ipk,
  });

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
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
          Row(
            children: [
              Icon(icon, size: 18, color: AppPallete.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppPallete.primary,
                        letterSpacing: 0.5,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium,
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
          context,
          title: 'Program Studi',
          value: programStudi,
          icon: Icons.school_outlined,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                context,
                title: 'Semester',
                value: semester.toString(),
                icon: Icons.calendar_today_outlined,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                context,
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
