/// Input Section Header - "Just enter these:" header
///
/// Purpose: Displays the header for the input section with guidance
/// Shows edit icon and instruction text when guidance is needed
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Header widget for the input section
class InputSectionHeader extends StatelessWidget {
  final bool showGuidance;

  const InputSectionHeader({
    super.key,
    required this.showGuidance,
  });

  @override
  Widget build(BuildContext context) {
    if (!showGuidance) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.edit,
              color: TossColors.primary,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Just enter these:',
              style: TossTextStyles.body.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
      ],
    );
  }
}
