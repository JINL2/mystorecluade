import 'package:flutter/material.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/shift_card.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';
import 'shift_detail_row.dart';
import 'shift_status_pill.dart';

/// Shift Info Tab
///
/// A widget displaying comprehensive shift information including times, status, and details.
class ShiftInfoTab extends StatelessWidget {
  final ShiftCard card;
  final bool hasUnsolvedProblem;

  const ShiftInfoTab({
    super.key,
    required this.card,
    required this.hasUnsolvedProblem,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Problem Alert - Show if problem exists (solved or unsolved)
          // Keep showing report reason even after problem is solved
          if (card.hasProblem) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space2,
                TossSpacing.space5,
                TossSpacing.space3,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                // Use different color based on solved status
                color: card.isProblemSolved
                    ? TossColors.success.withValues(alpha: 0.05)
                    : TossColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: card.isProblemSolved
                      ? TossColors.success.withValues(alpha: 0.2)
                      : TossColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        card.isProblemSolved
                            ? Icons.check_circle_outline
                            : Icons.warning_amber_rounded,
                        color: card.isProblemSolved
                            ? TossColors.success
                            : TossColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        card.isProblemSolved ? 'Problem Resolved' : 'Problem Detected',
                        style: TossTextStyles.body.copyWith(
                          color: card.isProblemSolved
                              ? TossColors.success
                              : TossColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (card.problemDetails != null && card.problemDetails!.problems.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Type: ${card.problemDetails!.problems.map((p) => p.displayName).join(', ')}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: card.isProblemSolved
                            ? TossColors.success.withValues(alpha: 0.8)
                            : TossColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  // Display report reason if the problem has been reported
                  if (card.isReported && card.reportReason != null && card.reportReason!.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card.reportReason!,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Primary Time Info - Most Important (Confirmed Times)
          Container(
                      margin: const EdgeInsets.fromLTRB(
                        TossSpacing.space5,
                        TossSpacing.space2,
                        TossSpacing.space5,
                        TossSpacing.space3,
                      ),
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            TossColors.primary.withValues(alpha: 0.05),
                            TossColors.primary.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                        border: Border.all(
                          color: TossColors.primary.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with icon
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: TossColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                                ),
                                child: const Icon(
                                  Icons.access_time_filled,
                                  size: 18,
                                  color: TossColors.primary,
                                ),
                              ),
                              const SizedBox(width: TossSpacing.space3),
                              Text(
                                'Confirmed Working Hours',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.gray700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: TossSpacing.space5),
                          // Time display in big format
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'START',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      ShiftTimeFormatter.formatTime(card.confirmedStartTime?.toIso8601String(), card.shiftDate),
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card.confirmedStartTime != null
                                          ? TossColors.gray900
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 50,
                                color: TossColors.gray200,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'END',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray500,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: TossSpacing.space2),
                                    Text(
                                      ShiftTimeFormatter.formatTime(card.confirmedEndTime?.toIso8601String(), card.shiftDate),
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card.confirmedEndTime != null
                                          ? TossColors.gray900
                                          : TossColors.gray400,
                                        fontFamily: 'JetBrains Mono',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Total hours if available
                          if (card.paidHour > 0) ...[
                            const SizedBox(height: TossSpacing.space4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space3,
                                vertical: TossSpacing.space2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.background,
                                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: TossColors.gray600,
                                  ),
                                  const SizedBox(width: TossSpacing.space2),
                                  Text(
                                    'Total: ${card.paidHour} hours',
                                    style: TossTextStyles.body.copyWith(
                                      color: TossColors.gray700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Quick Status Pills
                    Container(
                      height: 36,
                      margin: const EdgeInsets.only(bottom: TossSpacing.space4),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        children: [
                          // Approval status
                          ShiftStatusPill(
                            icon: card.isApproved
                              ? Icons.check_circle
                              : Icons.pending,
                            label: card.isApproved ? 'Approved' : 'Pending',
                            color: card.isApproved
                              ? TossColors.success
                              : TossColors.warning,
                          ),
                          // Problem status
                          if (card.hasProblem)
                            ShiftStatusPill(
                              icon: card.isProblemSolved
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_rounded,
                              label: card.isProblemSolved
                                ? 'Problem Solved'
                                : 'Has Problem',
                              color: card.isProblemSolved
                                ? TossColors.success
                                : TossColors.error,
                            ),
                          // Late status
                          if (card.isLate)
                            ShiftStatusPill(
                              icon: Icons.schedule,
                              label: 'Late ${card.lateMinute}min',
                              color: TossColors.error,
                            ),
                          // Overtime
                          if (card.isOverTime)
                            ShiftStatusPill(
                              icon: Icons.trending_up,
                              label: 'OT ${card.overTimeMinute}min',
                              color: TossColors.info,
                            ),
                        ],
                      ),
                    ),

                    // Shift Information Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shift Details',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          ShiftDetailRow(
                            label: 'Store',
                            value: card.shift.storeName ?? 'N/A',
                          ),
                          ShiftDetailRow(
                            label: 'Shift Type',
                            value: card.shift.shiftName ?? 'N/A',
                          ),
                          ShiftDetailRow(
                            label: 'Scheduled Time',
                            value: '${DateTimeUtils.formatTimeOnly(card.shift.planStartTime)}-${DateTimeUtils.formatTimeOnly(card.shift.planEndTime)}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),

                    // Actual Check-in/out Times
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.gray50,
                        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Check-in/out Records',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          ShiftDetailRow(
                            label: 'Actual Check-in',
                            value: card.actualStartTime != null
                              ? ShiftTimeFormatter.formatTimeWithSeconds(card.actualStartTime?.toIso8601String(), card.shiftDate)
                              : 'Not checked in',
                          ),
                          ShiftDetailRow(
                            label: 'Actual Check-out',
                            value: card.actualEndTime != null
                              ? ShiftTimeFormatter.formatTimeWithSeconds(card.actualEndTime?.toIso8601String(), card.shiftDate)
                              : 'Not checked out',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),

                    // Additional info
                    if (card.tags.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notice Tags',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            Wrap(
                              spacing: TossSpacing.space2,
                              runSpacing: TossSpacing.space2,
                              children: card.tags.map((tag) {
                                // Extract content from Tag entity
                                final content = tag.tagContent;

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space3,
                                    vertical: TossSpacing.space1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  ),
                                  child: Text(
                                    content,
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Location section (if available)
                    if (card.isValidCheckinLocation != null || card.isValidCheckoutLocation != null) ...[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space3),
                            if (card.isValidCheckinLocation != null)
                              ShiftDetailRow(
                                label: 'Check-in Location',
                                value: card.isValidCheckinLocation == true ? 'Valid' : 'Invalid',
                                valueColor: card.isValidCheckinLocation == true ? TossColors.success : TossColors.error,
                              ),
                            if (card.checkinDistanceFromStore != null && card.checkinDistanceFromStore! > 0)
                              ShiftDetailRow(
                                label: 'Check-in Distance',
                                value: '${card.checkinDistanceFromStore}m from store',
                              ),
                            if (card.isValidCheckoutLocation != null)
                              ShiftDetailRow(
                                label: 'Check-out Location',
                                value: card.isValidCheckoutLocation == true ? 'Valid' : 'Invalid',
                                valueColor: card.isValidCheckoutLocation == true ? TossColors.success : TossColors.error,
                              ),
                            if (card.checkoutDistanceFromStore != null && card.checkoutDistanceFromStore! > 0)
                              ShiftDetailRow(
                                label: 'Check-out Distance',
                                value: '${card.checkoutDistanceFromStore}m from store',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              );
  }
}
