import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../domain/entities/problem_details.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../dialogs/shift_detail_dialog.dart';
import '../../utils/schedule_date_utils.dart';
import '../../utils/schedule_shift_finder.dart';
import 'schedule_status_badge.dart';
import 'schedule_problem_badges.dart';

/// Individual shift card for selected date display
/// Extracted from MyScheduleTab._buildShiftCard
class ScheduleShiftCard extends StatelessWidget {
  final ShiftCard card;

  const ScheduleShiftCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
    final endDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime);

    final timeRange = startDateTime != null && endDateTime != null
        ? '${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}'
        : '--:-- - --:--';

    final status = ScheduleShiftFinder.determineStatus(
      card,
      startDateTime != null
          ? DateTime(startDateTime.year, startDateTime.month, startDateTime.day)
          : DateTime.now(),
      hasManagerMemo: card.managerMemos.isNotEmpty,
    );

    // Problem badges
    final pd = card.problemDetails;

    return GestureDetector(
      onTap: () => ShiftDetailDialog.show(context, shiftCard: card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space3,
          horizontal: TossSpacing.space4,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(color: TossColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First row: Shift name, time, and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.shiftName ?? 'Unknown Shift',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeRange,
                        style: TossTextStyles.labelSmall.copyWith(
                          color: TossColors.gray500,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badge
                ScheduleStatusBadge(status: status),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: TossColors.gray400, size: 20),
              ],
            ),

            // Problem badges row (if any)
            if (pd != null && pd.problemCount > 0) ...[
              const SizedBox(height: 8),
              ScheduleProblemBadges(
                problemDetails: pd,
                hasManagerMemo: card.managerMemos.isNotEmpty,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
