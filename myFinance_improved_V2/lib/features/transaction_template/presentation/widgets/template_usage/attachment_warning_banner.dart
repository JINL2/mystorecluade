/// Attachment Warning Banner - Required attachment warning
///
/// Purpose: Displays warning when attachment is required but not provided
/// Shows amber/warning colored banner with icon and message
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

/// Warning banner for required attachments
class AttachmentWarningBanner extends StatelessWidget {
  const AttachmentWarningBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.warning.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: TossColors.warning,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'This template requires an attachment (receipt, invoice, etc.)',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
