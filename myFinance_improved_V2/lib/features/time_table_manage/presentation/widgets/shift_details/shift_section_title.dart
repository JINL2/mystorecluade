import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Shift Section Title
///
/// A reusable widget for displaying section titles in shift details.
class ShiftSectionTitle extends StatelessWidget {
  final String title;

  const ShiftSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: TossSpacing.space2,
        bottom: TossSpacing.space3,
      ),
      child: Text(
        title,
        style: TossTextStyles.body.copyWith(
          color: TossColors.gray900,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
