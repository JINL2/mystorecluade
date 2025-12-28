import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Displays the account mapping verification status
///
/// Shows a success indicator when account mapping is verified,
/// or an error message when mapping fails.
class AccountMappingStatus extends StatelessWidget {
  final bool isInternal;
  final Map<String, dynamic>? accountMapping;
  final String? mappingError;

  const AccountMappingStatus({
    super.key,
    required this.isInternal,
    this.accountMapping,
    this.mappingError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Success status
        if (isInternal && accountMapping != null) ...[
          const SizedBox(height: TossSpacing.space4),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.success.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: TossColors.success, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Account mapping verified',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Error status
        if (mappingError != null) ...[
          const SizedBox(height: TossSpacing.space4),
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(
                color: TossColors.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: TossColors.error, size: 20),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    mappingError!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
