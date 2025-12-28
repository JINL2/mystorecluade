import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// A reusable section title widget for form sections
///
/// Used in AddTransactionDialog to display section headers
/// with consistent styling.
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TossTextStyles.body.copyWith(
        color: TossColors.gray700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
