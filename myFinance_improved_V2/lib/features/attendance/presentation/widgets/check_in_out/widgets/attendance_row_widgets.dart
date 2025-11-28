import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';

/// Reusable row widgets for displaying label-value pairs in attendance UI
class AttendanceRowWidgets {
  /// Minimal row with standard gray label and bold value
  static Widget buildMinimalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Clean row with slightly bolder value
  static Widget buildCleanRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Info row with lighter label color
  static Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Detail row with customizable highlight, color, and subtle mode
  static Widget buildDetailRow(
    String label,
    String value, {
    bool isHighlighted = false,
    Color? highlightColor,
    bool isSubtle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted
                  ? highlightColor
                  : isSubtle
                      ? TossColors.gray600
                      : TossColors.gray700,
              fontSize: isSubtle ? 14 : null,
              fontWeight: isSubtle ? FontWeight.w500 : FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: isHighlighted
                  ? highlightColor
                  : isSubtle
                      ? TossColors.gray600
                      : TossColors.gray900,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              fontSize: isSubtle ? 14 : null,
            ),
          ),
        ],
      ),
    );
  }
}
