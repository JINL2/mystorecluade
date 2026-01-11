// lib/features/cash_ending/presentation/widgets/section_label.dart

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Section label widget - small muted text above sections
///
/// Matches the HTML design pattern for section headers
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: TossSpacing.space1,
        bottom: TossSpacing.space2,
      ),
      child: Text(
        text,
        style: TossTextStyles.smallSectionTitle,
      ),
    );
  }
}
