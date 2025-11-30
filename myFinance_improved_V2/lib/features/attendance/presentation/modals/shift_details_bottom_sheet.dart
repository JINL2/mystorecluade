import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../widgets/check_in_out/dialogs/report_issue_dialog.dart';
import '../widgets/check_in_out/helpers/format_helpers.dart';

/// Shows the shift details bottom sheet
void showShiftDetailsBottomSheet({
  required BuildContext context,
  required WidgetRef ref,
  required Map<String, dynamic> cardData,
  required String currencySymbol,
  required VoidCallback onReportSuccess,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: TossColors.transparent,
    isScrollControlled: true,
    builder: (context) => ShiftDetailsBottomSheet(
      cardData: cardData,
      currencySymbol: currencySymbol,
      ref: ref,
      onReportSuccess: onReportSuccess,
    ),
  );
}

/// Bottom sheet widget displaying shift details
class ShiftDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> cardData;
  final String currencySymbol;
  final WidgetRef ref;
  final VoidCallback onReportSuccess;

  const ShiftDetailsBottomSheet({
    super.key,
    required this.cardData,
    required this.currencySymbol,
    required this.ref,
    required this.onReportSuccess,
  });

  @override
  State<ShiftDetailsBottomSheet> createState() => _ShiftDetailsBottomSheetState();
}

class _ShiftDetailsBottomSheetState extends State<ShiftDetailsBottomSheet> {
  bool isInfoExpanded = false;
  bool isActualAttendanceExpanded = false;

  @override
  Widget build(BuildContext context) {
    final cardData = widget.cardData;
    final currencySymbol = widget.currencySymbol;

    // Parse date
    final dateStr = (cardData['request_date'] ?? '').toString();
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          )
        : DateTime.now();

    // Parse shift time
    String shiftTime = (cardData['shift_time'] ?? '09:00 ~ 17:00').toString();
    shiftTime = shiftTime.replaceAll('~', ' ~ ');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.space4,
              ),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray200,
                borderRadius: BorderRadius.circular(TossBorderRadius.full),
              ),
            ),
          ),

          // Title
          Text(
            'Shift Details',
            style: TossTextStyles.h3.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: TossSpacing.space5),

          // Content with scroll
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Section Heading with expandable arrow
                  _buildExpandableHeader(
                    'Info',
                    isInfoExpanded,
                    () => setState(() => isInfoExpanded = !isInfoExpanded),
                  ),

                  // Info section content (collapsible)
                  if (isInfoExpanded) ...[
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow(
                      'Date',
                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                    ),
                    const SizedBox(height: TossSpacing.space4),
                    _buildInfoRow('Shift Time', shiftTime),
                    const SizedBox(height: TossSpacing.space4),

                    // Work Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                        Text(
                          FormatHelpers.getWorkStatusFromCard(cardData),
                          style: TossTextStyles.body.copyWith(
                            color: FormatHelpers.getWorkStatusColorFromCard(cardData),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Late info if exists
                    if ((cardData['is_late'] as bool? ?? false) ||
                        ((cardData['late_minutes'] as num?) ?? 0) > 0) ...[
                      const SizedBox(height: TossSpacing.space4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Late',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                            ),
                          ),
                          Text(
                            '${cardData['late_minutes'] ?? 0} minutes',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],

                  const SizedBox(height: TossSpacing.space6),

                  // Actual Attendance Section Heading
                  _buildExpandableHeader(
                    'Actual Attendance',
                    isActualAttendanceExpanded,
                    () => setState(() =>
                        isActualAttendanceExpanded = !isActualAttendanceExpanded),
                  ),

                  // Actual Attendance section content (collapsible)
                  if (isActualAttendanceExpanded) ...[
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow(
                      'Actual Check-in',
                      FormatHelpers.formatTime(cardData['actual_start_time']?.toString()),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow(
                      'Actual Check-out',
                      FormatHelpers.formatTime(cardData['actual_end_time']?.toString()),
                    ),
                    const SizedBox(height: TossSpacing.space4),

                    // Hours Section
                    _buildInfoRow(
                      'Scheduled Hours',
                      '${cardData['scheduled_hours'] ?? 0.0} hours',
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow(
                      'Paid Hours',
                      '${cardData['paid_hours'] ?? 0} hours',
                    ),
                    const SizedBox(height: TossSpacing.space4),

                    // Salary information
                    _buildInfoRow(
                      'Salary Type',
                      (cardData['salary_type'] ?? 'hourly').toString(),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    _buildInfoRow(
                      'Salary per Hour',
                      '$currencySymbol${FormatHelpers.formatNumber(cardData['salary_amount'] ?? 0)}',
                    ),
                  ],

                  const SizedBox(height: TossSpacing.space6),

                  // Confirmed Attendance Section (Always visible)
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.info.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirmed Attendance',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.info,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Check-in',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                            Text(
                              FormatHelpers.formatTime(
                                cardData['confirm_start_time']?.toString(),
                              ),
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Check-out',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                            Text(
                              FormatHelpers.formatTime(
                                cardData['confirm_end_time']?.toString(),
                              ),
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Base Pay and Bonus Amount
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: TossColors.info.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Base Pay',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                            Text(
                              '$currencySymbol${FormatHelpers.formatNumber(cardData['base_pay'] ?? 0)}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bonus Amount',
                              style: TossTextStyles.bodySmall.copyWith(
                                color: TossColors.gray500,
                              ),
                            ),
                            Text(
                              '$currencySymbol${FormatHelpers.formatNumber(cardData['bonus_amount'] ?? 0)}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Divider
                  Container(
                    height: 1,
                    color: TossColors.gray100,
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Total Pay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pay',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$currencySymbol${FormatHelpers.formatNumber(cardData['total_pay_with_bonus'] ?? '0')}',
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.info,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: TossSpacing.space5),

                  // Show reported status if already reported
                  if (cardData['is_reported'] as bool? ?? false) ...[
                    Container(
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        border: Border.all(
                          color: TossColors.warning.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: TossColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: TossSpacing.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Issue Reported',
                                  style: TossTextStyles.body.copyWith(
                                    color: TossColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (cardData['is_problem_solved'] as bool? ?? false)
                                      ? 'Your report has been resolved'
                                      : 'Your report is being reviewed',
                                  style: TossTextStyles.bodySmall.copyWith(
                                    color: TossColors.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space5),
                  ],

                  // Report Issue Button
                  _buildReportIssueButton(cardData),

                  // Safe area padding
                  SizedBox(
                    height:
                        MediaQuery.of(context).padding.bottom + TossSpacing.space5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableHeader(
    String title,
    bool isExpanded,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
        child: Row(
          children: [
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
              color: TossColors.gray600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildReportIssueButton(Map<String, dynamic> cardData) {
    final isReported = cardData['is_reported'] as bool? ?? false;
    final isApproved = cardData['is_approved'] as bool? ?? false;
    final isDisabled = isReported || !isApproved;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        color: isDisabled ? TossColors.gray50 : TossColors.background,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: isDisabled ? TossColors.gray100 : TossColors.gray200,
          width: 1,
        ),
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () async {
                  final shiftRequestId = cardData['shift_request_id'];
                  if (shiftRequestId == null) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unable to report issue: Missing shift ID'),
                          backgroundColor: TossColors.error,
                        ),
                      );
                    }
                    return;
                  }

                  HapticFeedback.selectionClick();

                  // Close bottom sheet first
                  Navigator.pop(context);

                  // Show report issue dialog
                  if (mounted) {
                    ReportIssueDialog.show(
                      context: context,
                      ref: widget.ref,
                      shiftRequestId: shiftRequestId.toString(),
                      cardData: cardData,
                      onSuccess: widget.onReportSuccess,
                    );
                  }
                },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: TossSpacing.space3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 20,
                  color: isDisabled ? TossColors.gray300 : TossColors.gray600,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Report Issue',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDisabled ? TossColors.gray300 : TossColors.gray700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
