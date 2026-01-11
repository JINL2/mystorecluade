import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Search input field for filtering lists in bottom sheets
class SheetSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextEditingController? controller;

  const SheetSearchField({
    super.key,
    this.onChanged,
    this.hintText = 'Search...',
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space2,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: TossColors.gray400),
          prefixIcon: const Icon(
            LucideIcons.search,
            size: 18,
            color: TossColors.gray500,
          ),
          filled: true,
          fillColor: TossColors.gray50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide:
                const BorderSide(color: TossColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
