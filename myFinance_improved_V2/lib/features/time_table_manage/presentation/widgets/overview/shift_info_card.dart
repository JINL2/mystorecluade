import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/entities/shift_info_types.dart';
import '../../../domain/entities/snapshot_data.dart';
import 'snapshot_metrics_section.dart';
import 'staff_grid_section.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../../domain/entities/shift_info_types.dart';
export '../../../domain/entities/snapshot_data.dart';

/// Shift Info Card
///
/// Reusable card for displaying shift information.
/// Can show either snapshot metrics (active) or staff grid (upcoming).
class ShiftInfoCard extends StatelessWidget {
  final String date;
  final String shiftName;
  final String timeRange;
  final ShiftCardType type;
  final String? statusLabel;
  final ShiftStatusType? statusType;
  final SnapshotData? snapshotData;
  final List<StaffMember>? staffList;
  /// Callback when an employee is tapped in the snapshot metrics bottom sheet
  final void Function(ShiftCard card)? onEmployeeTap;

  const ShiftInfoCard({
    super.key,
    required this.date,
    required this.shiftName,
    required this.timeRange,
    required this.type,
    this.statusLabel,
    this.statusType,
    this.snapshotData,
    this.staffList,
    this.onEmployeeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift Header
          _buildShiftHeader(),

          // Divider line under header
          if (snapshotData != null || (staffList != null && staffList!.isNotEmpty)) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
          ],

          // Snapshot or Staff Grid
          if (snapshotData != null) ...[
            const SizedBox(height: TossSpacing.space3),
            SnapshotMetricsSection(
              data: snapshotData!,
              onEmployeeTap: onEmployeeTap,
            ),
          ],
          if (staffList != null && staffList!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space3),
            StaffGridSection(staffList: staffList!),
          ],
        ],
      ),
    );
  }

  /// Build shift header with date, name, time, and status badge
  Widget _buildShiftHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Date, Name, Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TossTextStyles.labelMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                shiftName,
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeRange,
                style: TossTextStyles.bodyMedium.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ],
          ),
        ),

        // Right: Status Badge
        if (statusLabel != null && statusType != null) _buildStatusBadge(),
      ],
    );
  }

  /// Build status badge based on type
  Widget _buildStatusBadge() {
    if (statusType == ShiftStatusType.neutral) {
      // Neutral badge for "assigned"
      return TossBadge(
        label: statusLabel!,
        backgroundColor: TossColors.gray100,
        textColor: TossColors.gray600,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
      );
    }

    // Status badge for success/error/warning/info
    BadgeStatus badgeStatus;
    switch (statusType!) {
      case ShiftStatusType.success:
        badgeStatus = BadgeStatus.success;
      case ShiftStatusType.error:
        badgeStatus = BadgeStatus.error;
      case ShiftStatusType.warning:
        badgeStatus = BadgeStatus.warning;
      case ShiftStatusType.info:
        badgeStatus = BadgeStatus.info;
      case ShiftStatusType.neutral:
        badgeStatus = BadgeStatus.neutral;
    }

    return TossStatusBadge(
      label: statusLabel!,
      status: badgeStatus,
    );
  }
}
