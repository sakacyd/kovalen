import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final String? infoText;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: Theme.of(context).textTheme.bodyMedium,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Kolom ini wajib diisi';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.outline),
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.outline, size: 20),
            suffixIcon: isPassword
                ? Icon(
                    Icons.visibility_off,
                    color: Theme.of(context).colorScheme.outline,
                    size: 20,
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
        if (infoText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(infoText!, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ],
    );
  }
}
