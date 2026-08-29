import 'package:flutter/material.dart';
import 'package:kovalen/core/theme/app_pallete.dart';

class ConfirmationModal extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationModal({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Ya',
    this.cancelText = 'Batal',
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationModal(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppPallete.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20),
      ),
      content: Text(
        content,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppPallete.onSurfaceVariant),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            cancelText,
            style: const TextStyle(
              color: AppPallete.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.primary,
            foregroundColor: AppPallete.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            confirmText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
