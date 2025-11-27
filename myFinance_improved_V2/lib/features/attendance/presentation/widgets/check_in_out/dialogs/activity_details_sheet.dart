import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../utils/attendance_formatters.dart';
import '../utils/attendance_status_helper.dart';
import '../widgets/attendance_row_widgets.dart';
import 'report_issue_dialog.dart';

/// Bottom sheet showing detailed shift activity
class ActivityDetailsSheet extends ConsumerWidget {
  final Map<String, dynamic> activity;
  final Map<String, dynamic>? shiftOverviewData;
  final VoidCallback onReportSubmitted;

  const ActivityDetailsSheet({
    super.key,
    required this.activity,
    this.shiftOverviewData,
    required this.onReportSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardData = activity['rawCard'] as Map<String, dynamic>?;
    if (cardData == null) {
      return const SizedBox.shrink();
    }

    final dateStr = (cardData['request_date'] ?? '').toString();
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0].toString()),
            int.parse(dateParts[1].toString()),
            int.parse(dateParts[2].toString()),
          )
        : DateTime.now();

    final currencySymbol = (shiftOverviewData?['currency_symbol'] as String?) ?? 'VND';
    final rawShiftTime = (cardData['shift_time'] ?? '09:00 ~ 17:00').toString();
    final requestDate = cardData['request_date']?.toString();
    String shiftTime = AttendanceFormatters.formatShiftTime(rawShiftTime, requestDate: requestDate);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool isInfoExpanded = false;
        bool isActualAttendanceExpanded = false;

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
                  margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.space4),
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

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info Section
                      _buildExpandableSection(
                        title: 'Info',
                        isExpanded: isInfoExpanded,
                        onTap: () => setState(() => isInfoExpanded = !isInfoExpanded),
                        child: _buildInfoSection(date, shiftTime, cardData),
                      ),

                      const SizedBox(height: TossSpacing.space6),

                      // Actual Attendance Section
                      _buildExpandableSection(
                        title: 'Actual Attendance',
                        isExpanded: isActualAttendanceExpanded,
                        onTap: () => setState(() => isActualAttendanceExpanded = !isActualAttendanceExpanded),
                        child: _buildActualAttendanceSection(cardData, currencySymbol),
                      ),

                      const SizedBox(height: TossSpacing.space6),

                      // Confirmed Attendance
                      _buildConfirmedAttendance(cardData),

                      const SizedBox(height: TossSpacing.space4),

                      // Base Pay and Bonus
                      _buildPaySection(cardData, currencySymbol),

                      const SizedBox(height: TossSpacing.space6),

                      // Divider
                      Container(height: 1, color: TossColors.gray100),

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
                            '$currencySymbol${AttendanceFormatters.formatNumber(cardData['total_pay_with_bonus'] ?? '0')}',
                            style: TossTextStyles.h2.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: TossSpacing.space5),

                      // Reported status
                      if (cardData['is_reported'] == true)
                        _buildReportedStatus(cardData),

                      // Report Issue Button
                      _buildReportButton(context, ref, cardData),

                      SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space5),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
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
        ),
        if (isExpanded) ...[
          const SizedBox(height: TossSpacing.space3),
          child,
        ],
      ],
    );
  }

  Widget _buildInfoSection(DateTime date, String shiftTime, Map<String, dynamic> cardData) {
    return Column(
      children: [
        AttendanceRowWidgets.buildInfoRow(
          'Date',
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        ),
        const SizedBox(height: TossSpacing.space4),
        AttendanceRowWidgets.buildInfoRow('Shift Time', shiftTime),
        const SizedBox(height: TossSpacing.space4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status',
              style: TossTextStyles.body.copyWith(color: TossColors.gray500),
            ),
            Text(
              AttendanceFormatters.getWorkStatusFromCard(cardData),
              style: TossTextStyles.body.copyWith(
                color: AttendanceStatusHelper.getWorkStatusColorFromCard(cardData),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if ((cardData['is_late'] == true) || ((cardData['late_minutes'] as num?) ?? 0) > 0) ...[
          const SizedBox(height: TossSpacing.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Late', style: TossTextStyles.body.copyWith(color: TossColors.error)),
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
    );
  }

  Widget _buildActualAttendanceSection(Map<String, dynamic> cardData, String currencySymbol) {
    final requestDateStr = cardData['request_date'] as String?;
    return Column(
      children: [
        AttendanceRowWidgets.buildInfoRow(
          'Actual Check-in',
          AttendanceFormatters.formatTime(
            cardData['actual_start_time'],
            requestDate: requestDateStr,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Actual Check-out',
          AttendanceFormatters.formatTime(
            cardData['actual_end_time'],
            requestDate: requestDateStr,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        AttendanceRowWidgets.buildInfoRow(
          'Scheduled Hours',
          '${cardData['scheduled_hours'] ?? 0.0} hours',
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Paid Hours',
          '${cardData['paid_hours'] ?? 0} hours',
        ),
        const SizedBox(height: TossSpacing.space4),
        AttendanceRowWidgets.buildInfoRow(
          'Salary Type',
          (cardData['salary_type'] ?? 'hourly').toString(),
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Salary per Hour',
          '$currencySymbol${AttendanceFormatters.formatNumber(cardData['salary_amount'] ?? 0)}',
        ),
      ],
    );
  }

  Widget _buildConfirmedAttendance(Map<String, dynamic> cardData) {
    final requestDateStr = cardData['request_date'] as String?;
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.info.withOpacity(0.05),
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
              Text('Check-in', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                AttendanceFormatters.formatTime(
                  cardData['confirm_start_time'],
                  requestDate: requestDateStr,
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
              Text('Check-out', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                AttendanceFormatters.formatTime(
                  cardData['confirm_end_time'],
                  requestDate: requestDateStr,
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
    );
  }

  Widget _buildPaySection(Map<String, dynamic> cardData, String currencySymbol) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Base Pay', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                '$currencySymbol${AttendanceFormatters.formatNumber(cardData['base_pay'] ?? 0)}',
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
              Text('Bonus Amount', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                '$currencySymbol${AttendanceFormatters.formatNumber(cardData['bonus_amount'] ?? 0)}',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportedStatus(Map<String, dynamic> cardData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space5),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.warning.withOpacity(0.06),
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.warning.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline_rounded, color: TossColors.warning, size: 20),
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
                    (cardData['is_problem_solved'] == true)
                        ? 'Your report has been resolved'
                        : 'Your report is being reviewed',
                    style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, WidgetRef ref, Map<String, dynamic> cardData) {
    final isDisabled = (cardData['is_reported'] == true) || (cardData['is_approved'] != true);

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
                    await showDialog<bool>(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) => TossDialog.error(
                        title: 'Unable to Report Issue',
                        message: 'Missing shift ID',
                        primaryButtonText: 'OK',
                      ),
                    );
                    return;
                  }

                  HapticFeedback.selectionClick();

                  await ReportIssueDialog.show(
                    context: context,
                    ref: ref,
                    shiftRequestId: shiftRequestId as String,
                    cardData: cardData,
                    onSuccess: () {
                      context.pop(); // Close details sheet
                      onReportSubmitted();
                    },
                  );
                },
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
