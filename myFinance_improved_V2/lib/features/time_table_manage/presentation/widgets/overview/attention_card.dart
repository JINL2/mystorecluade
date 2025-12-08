import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_badge.dart';

/// Attention Type
enum AttentionType {
  late,
  understaffed,
  overtime,
  problem,
  reported,
}

/// Attention Item Data
class AttentionItemData {
  final AttentionType type;
  final String title;
  final String date;
  final String time;
  final String subtext;

  // Staff-specific fields for navigation to detail page
  final String? staffId;
  final String? shiftRequestId;
  final String? clockIn;
  final String? clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool isConfirmed;
  final String? actualStart;
  final String? actualEnd;
  final String? confirmStartTime;
  final String? confirmEndTime;
  final bool isReported;
  final String? reportReason;
  final bool isProblemSolved;
  final double bonusAmount;
  final String? salaryType;
  final String? salaryAmount;
  final String? basePay;
  final String? totalPayWithBonus;
  final double paidHour;
  final int lateMinute;
  final int overtimeMinute;
  final String? avatarUrl;
  final DateTime? shiftDate;
  final String? shiftName;
  final String? shiftTimeRange;
  final bool isShiftProblem; // True if understaffed, false if staff problem
  final DateTime? shiftEndTime;

  AttentionItemData({
    required this.type,
    required this.title,
    required this.date,
    required this.time,
    required this.subtext,
    this.staffId,
    this.shiftRequestId,
    this.clockIn,
    this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.isConfirmed = false,
    this.actualStart,
    this.actualEnd,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isReported = false,
    this.reportReason,
    this.isProblemSolved = false,
    this.bonusAmount = 0.0,
    this.salaryType,
    this.salaryAmount,
    this.basePay,
    this.totalPayWithBonus,
    this.paidHour = 0.0,
    this.lateMinute = 0,
    this.overtimeMinute = 0,
    this.avatarUrl,
    this.shiftDate,
    this.shiftName,
    this.shiftTimeRange,
    this.isShiftProblem = false,
    this.shiftEndTime,
  });
}

/// Attention Card
///
/// Card displaying items that need attention (late, understaffed, overtime).
class AttentionCard extends StatelessWidget {
  final AttentionItemData item;
  final VoidCallback? onTap;

  const AttentionCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(TossSpacing.space4),
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
            // Badge
            _buildBadge(),
            const SizedBox(height: TossSpacing.space3),

            // Title
            Text(
              item.title,
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),

            // Date
            Text(
              item.date,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),

            // Time
            Text(
              item.time,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),

            const Spacer(),

            // Subtext
            Text(
              item.subtext,
              style: TossTextStyles.labelSmall.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build badge based on attention type
  Widget _buildBadge() {
    BadgeStatus status;
    String label;

    switch (item.type) {
      case AttentionType.late:
        status = BadgeStatus.error;
        label = 'Late';
      case AttentionType.understaffed:
        status = BadgeStatus.info;
        label = 'Understaffed';
      case AttentionType.overtime:
        status = BadgeStatus.error;
        label = 'Overtime';
      case AttentionType.problem:
        status = BadgeStatus.warning;
        label = 'Problem';
      case AttentionType.reported:
        status = BadgeStatus.warning;
        label = 'Reported';
    }

    return TossStatusBadge(
      label: label,
      status: status,
    );
  }
}
