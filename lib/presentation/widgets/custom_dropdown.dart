import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          onChanged: onChanged,
          items: items,
          icon: Icon(Icons.expand_more, color: Theme.of(context).colorScheme.outline),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
