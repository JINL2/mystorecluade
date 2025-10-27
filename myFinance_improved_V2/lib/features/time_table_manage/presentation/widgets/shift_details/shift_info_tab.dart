import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/value_objects/shift_time_formatter.dart';
import 'shift_detail_row.dart';
import 'shift_section_title.dart';
import 'shift_status_pill.dart';

/// Shift Info Tab
///
/// A widget displaying comprehensive shift information including times, status, and details.
class ShiftInfoTab extends StatelessWidget {
  final Map<String, dynamic> card;
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
          // Problem Alert if there's an unsolved problem
          if (hasUnsolvedProblem) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(
                TossSpacing.space5,
                TossSpacing.space2,
                TossSpacing.space5,
                TossSpacing.space3,
              ),
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                border: Border.all(
                  color: TossColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: TossColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Text(
                        'Problem Detected',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (card['problem_type'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      'Type: ${card['problem_type']}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.error.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                  if (card['problem_description'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['problem_description'].toString(),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                  // Display report reason if the problem has been reported
                  if (card['is_reported'] == true && card['report_reason'] != null) ...[
                    const SizedBox(height: TossSpacing.space2),
                    Text(
                      card['report_reason'].toString(),
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
                                      ShiftTimeFormatter.formatTime(card['confirm_start_time']?.toString(), card['request_date']?.toString()),
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_start_time'] != null
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
                                      ShiftTimeFormatter.formatTime(card['confirm_end_time']?.toString(), card['request_date']?.toString()),
                                      style: TossTextStyles.display.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: card['confirm_end_time'] != null
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
                          if (card['paid_hour'] != null && (card['paid_hour'] as num) > 0) ...[
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
                                    'Total: ${card['paid_hour']} hours',
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
                            icon: card['is_approved'] == true
                              ? Icons.check_circle
                              : Icons.pending,
                            label: card['is_approved'] == true ? 'Approved' : 'Pending',
                            color: card['is_approved'] == true
                              ? TossColors.success
                              : TossColors.warning,
                          ),
                          // Problem status
                          if (card['is_problem'] == true)
                            ShiftStatusPill(
                              icon: card['is_problem_solved'] == true
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_rounded,
                              label: card['is_problem_solved'] == true
                                ? 'Problem Solved'
                                : 'Has Problem',
                              color: card['is_problem_solved'] == true
                                ? TossColors.success
                                : TossColors.error,
                            ),
                          // Late status
                          if (card['is_late'] == true)
                            ShiftStatusPill(
                              icon: Icons.schedule,
                              label: 'Late ${card['late_minute']}min',
                              color: TossColors.error,
                            ),
                          // Overtime
                          if (card['is_over_time'] == true)
                            ShiftStatusPill(
                              icon: Icons.trending_up,
                              label: 'OT ${card['over_time_minute']}min',
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
                            value: card['store_name']?.toString() ?? 'N/A',
                          ),
                          ShiftDetailRow(
                            label: 'Shift Type',
                            value: card['shift_name']?.toString() ?? 'N/A',
                          ),
                          ShiftDetailRow(
                            label: 'Scheduled Time',
                            value: ShiftTimeFormatter.formatShiftTime(card['shift_time']?.toString(), card['request_date']?.toString()),
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
                            value: ShiftTimeFormatter.formatTime(card['actual_start']?.toString(), card['request_date']?.toString()) != '--:--' ? ShiftTimeFormatter.formatTime(card['actual_start']?.toString(), card['request_date']?.toString()) : 'Not checked in',
                          ),
                          ShiftDetailRow(
                            label: 'Actual Check-out',
                            value: ShiftTimeFormatter.formatTime(card['actual_end']?.toString(), card['request_date']?.toString()) != '--:--' ? ShiftTimeFormatter.formatTime(card['actual_end']?.toString(), card['request_date']?.toString()) : 'Not checked out',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),

                    // Location section (if available)
                    if (card['is_valid_checkin_location'] != null || card['is_valid_checkout_location'] != null) ...[
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
                            if (card['is_valid_checkin_location'] != null)
                              ShiftDetailRow(
                                label: 'Check-in Location',
                                value: card['is_valid_checkin_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkin_location'] == true ? TossColors.success : TossColors.error,
                              ),
                            if (card['checkin_distance_from_store'] != null && (card['checkin_distance_from_store'] as num) > 0)
                              ShiftDetailRow(
                                label: 'Check-in Distance',
                                value: '${card['checkin_distance_from_store']}m from store',
                              ),
                            if (card['is_valid_checkout_location'] != null)
                              ShiftDetailRow(
                                label: 'Check-out Location',
                                value: card['is_valid_checkout_location'] == true ? 'Valid' : 'Invalid',
                                valueColor: card['is_valid_checkout_location'] == true ? TossColors.success : TossColors.error,
                              ),
                            if (card['checkout_distance_from_store'] != null && (card['checkout_distance_from_store'] as num) > 0)
                              ShiftDetailRow(
                                label: 'Check-out Distance',
                                value: '${card['checkout_distance_from_store']}m from store',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Additional info
                    if (card['notice_tag'] != null && (card['notice_tag'] as List).isNotEmpty) ...[
                      const ShiftSectionTitle(title: 'Notice Tags'),
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                        ),
                        child: Wrap(
                          spacing: TossSpacing.space2,
                          runSpacing: TossSpacing.space2,
                          children: (card['notice_tag'] as List).map((tag) {
                            // Parse tag as a Map and extract only content
                            final tagData = tag is Map ? tag : <String, dynamic>{};
                            final content = tagData['content']?.toString() ?? 'No content';

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
                      ),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    const SizedBox(height: TossSpacing.space5),
                  ],
                ),
              );
  }
}
