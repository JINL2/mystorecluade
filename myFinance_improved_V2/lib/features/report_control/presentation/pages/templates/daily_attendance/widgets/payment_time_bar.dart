// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/payment_time_bar.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';

/// Payment Time Bar - Salary payment time timeline
class PaymentTimeBar extends StatelessWidget {
  final String scheduledStart;
  final String scheduledEnd;
  final String? actualStart;
  final String? actualEnd;
  final String? paymentStart;
  final String? paymentEnd;
  final bool isManagerAdjusted;
  final String? managerName;
  final int penalty;
  final int overtime;
  final String? managerReason;

  const PaymentTimeBar({
    super.key,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    this.paymentStart,
    this.paymentEnd,
    this.isManagerAdjusted = false,
    this.managerName,
    required this.penalty,
    required this.overtime,
    this.managerReason,
  });

  @override
  Widget build(BuildContext context) {
    final netPayment = overtime - penalty;

    // Calculate scheduled hours (handle overnight shifts)
    final schedStart = _parseTime(scheduledStart);
    var schedEnd = _parseTime(scheduledEnd);

    // If end time is less than start time, it's an overnight shift
    if (schedEnd < schedStart) {
      schedEnd += 1440; // Add 24 hours (1440 minutes)
    }

    final scheduledMinutes = schedEnd - schedStart;
    final scheduledHours = scheduledMinutes ~/ 60;
    final scheduledMins = scheduledMinutes % 60;

    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingSM),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                LucideIcons.dollarSign,
                size: TossSpacing.iconXS,
                color: TossColors.gray700,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Payment',
                style: TossTextStyles.labelMedium.copyWith(
                  color: TossColors.gray700,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: isManagerAdjusted
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isManagerAdjusted
                          ? LucideIcons.userCheck
                          : LucideIcons.calculator,
                      size: 10,
                      color: isManagerAdjusted
                          ? TossColors.primary
                          : TossColors.gray600,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      isManagerAdjusted ? 'Manual' : 'Auto',
                      style: TossTextStyles.labelSmall.copyWith(
                        color: isManagerAdjusted
                            ? TossColors.primary
                            : TossColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: TossSpacing.space3),

          // Time comparison bars (vs Scheduled baseline)
          ComparisonTimeBar(
            label: 'Actual',
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            actualStart: actualStart ?? '?',
            actualEnd: actualEnd ?? '?',
          ),
          SizedBox(height: TossSpacing.space2),
          ComparisonTimeBar(
            label: isManagerAdjusted
                ? 'Payment (by ${managerName ?? "Manager"})'
                : 'Payment',
            scheduledStart: scheduledStart,
            scheduledEnd: scheduledEnd,
            actualStart: paymentStart ?? actualStart ?? '?',
            actualEnd: paymentEnd ?? actualEnd ?? scheduledEnd,
            isPayment: true,
            isManagerAdjusted: isManagerAdjusted,
          ),

          SizedBox(height: TossSpacing.space3),

          // Final Payment Calculation
          Container(
            padding: EdgeInsets.all(TossSpacing.paddingSM),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Formula
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        scheduledMins > 0
                            ? '${scheduledHours}h ${scheduledMins}min'
                            : '${scheduledHours}h',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '${netPayment >= 0 ? "+" : ""}$netPayment min',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color:
                              netPayment >= 0 ? TossColors.success : TossColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space1),
                      Text(
                        '=',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: TossColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Result
                Text(
                  '${(scheduledMinutes + netPayment) ~/ 60}h ${(scheduledMinutes + netPayment) % 60}min',
                  style: TossTextStyles.h3.copyWith(
                    color: isManagerAdjusted ? TossColors.primary : TossColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          // Manager reason
          if (isManagerAdjusted &&
              managerReason != null &&
              managerReason!.isNotEmpty) ...[
            SizedBox(height: TossSpacing.space2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.messageSquare,
                  size: 12,
                  color: TossColors.gray500,
                ),
                SizedBox(width: TossSpacing.space1),
                Expanded(
                  child: Text(
                    managerReason!,
                    style: TossTextStyles.small.copyWith(
                      color: TossColors.gray600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}

/// Comparison Time Bar - Scheduled baseline comparison
class ComparisonTimeBar extends StatelessWidget {
  final String label;
  final String scheduledStart;
  final String scheduledEnd;
  final String actualStart;
  final String actualEnd;
  final bool isPayment;
  final bool isManagerAdjusted;

  const ComparisonTimeBar({
    super.key,
    required this.label,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.actualStart,
    required this.actualEnd,
    this.isPayment = false,
    this.isManagerAdjusted = false,
  });

  @override
  Widget build(BuildContext context) {
    // Parse times (null-safe)
    final schedStart = _parseTime(scheduledStart);
    final schedEnd = _parseTime(scheduledEnd);
    final actStart = actualStart == '?' ? null : _parseTime(actualStart);
    final actEnd = actualEnd == '?' ? null : _parseTime(actualEnd);

    final startDiff = actStart != null ? (actStart - schedStart) : 0;
    final endDiff = actEnd != null ? (actEnd - schedEnd) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label + Time info
        Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                label,
                style: TossTextStyles.small.copyWith(
                  color: TossColors.gray600,
                  fontWeight: isPayment ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (startDiff != 0)
              Row(
                children: [
                  Icon(
                    LucideIcons.clock,
                    size: 12,
                    color: startDiff > 0 ? TossColors.error : TossColors.success,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '${startDiff > 0 ? "+" : ""}$startDiff min',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: startDiff > 0 ? TossColors.error : TossColors.success,
                    ),
                  ),
                ],
              ),
            Spacer(),
            if (endDiff != 0)
              Row(
                children: [
                  Text(
                    '${endDiff > 0 ? "+" : ""}$endDiff min',
                    style: TossTextStyles.labelSmall.copyWith(
                      color: endDiff > 0 ? TossColors.success : TossColors.error,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    LucideIcons.clock,
                    size: 12,
                    color: endDiff > 0 ? TossColors.success : TossColors.error,
                  ),
                ],
              ),
          ],
        ),
        SizedBox(height: TossSpacing.space1),

        // Time bar with colors
        Row(
          children: [
            SizedBox(width: 70),
            Expanded(
              child: Column(
                children: [
                  // Bar
                  Container(
                    height: isPayment ? 24 : 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      border: Border.all(
                        color: isManagerAdjusted
                            ? TossColors.primary
                            : TossColors.gray200,
                        width: isManagerAdjusted ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Base
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius:
                                BorderRadius.circular(TossBorderRadius.sm),
                          ),
                        ),
                        // Colored bar with time inside
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.sm),
                          child: Row(
                            children: [
                              // Left - Late (red)
                              if (startDiff > 0)
                                Container(
                                  width: 40,
                                  color: TossColors.error.withValues(alpha: 0.6),
                                )
                              else if (startDiff < 0)
                                Container(
                                  width: 30,
                                  color: TossColors.success.withValues(alpha: 0.6),
                                ),
                              // Middle - Normal
                              Expanded(child: SizedBox()),
                              // Right - Overtime (green)
                              if (endDiff > 0)
                                Container(
                                  width: 25,
                                  color: TossColors.success.withValues(alpha: 0.6),
                                )
                              else if (endDiff < 0)
                                Container(
                                  width: 20,
                                  color: TossColors.error.withValues(alpha: 0.6),
                                ),
                            ],
                          ),
                        ),
                        // Time labels on top of bar
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  actualStart,
                                  style: TossTextStyles.small.copyWith(
                                    color: isManagerAdjusted
                                        ? TossColors.primary
                                        : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  actualEnd,
                                  style: TossTextStyles.small.copyWith(
                                    color: isManagerAdjusted
                                        ? TossColors.primary
                                        : TossColors.gray900,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scheduled markers
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u25B3$scheduledStart',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '\u25B3$scheduledEnd',
                        style: TossTextStyles.small.copyWith(
                          color: TossColors.gray400,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
