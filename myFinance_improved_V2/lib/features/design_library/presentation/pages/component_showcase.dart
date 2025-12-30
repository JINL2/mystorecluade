import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

/// Component showcase wrapper for design library
class ComponentShowcase extends StatelessWidget {
  final String name;
  final String filename;
  final Widget child;

  const ComponentShowcase({
    super.key,
    required this.name,
    required this.filename,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            filename,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          child,
        ],
      ),
    );
  }
}
