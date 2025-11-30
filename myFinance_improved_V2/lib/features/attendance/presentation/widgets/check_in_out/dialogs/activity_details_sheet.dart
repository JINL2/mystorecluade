import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../domain/entities/shift_card.dart';
import '../../../../domain/entities/user_shift_stats.dart';
import '../helpers/format_helpers.dart';
import '../widgets/attendance_row_widgets.dart';
import 'report_issue_dialog.dart';

/// Bottom sheet showing detailed shift activity
///
/// ✅ Clean Architecture: Uses ShiftCard Entity instead of Map<String, dynamic>
class ActivityDetailsSheet extends ConsumerWidget {
  /// ✅ Clean Architecture: Use ShiftCard Entity directly
  final ShiftCard shiftCard;
  final SalaryInfo? salaryInfo;
  final VoidCallback onReportSubmitted;

  const ActivityDetailsSheet({
    super.key,
    required this.shiftCard,
    this.salaryInfo,
    required this.onReportSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Clean Architecture: Parse date from Entity
    final dateStr = shiftCard.requestDate;
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0]),
            int.parse(dateParts[1]),
            int.parse(dateParts[2]),
          )
        : DateTime.now();

    final currencySymbol = salaryInfo?.currencySymbol ?? 'VND';
    final rawShiftTime = shiftCard.shiftTime;
    final requestDate = shiftCard.requestDate;
    String shiftTime = FormatHelpers.formatShiftTime(rawShiftTime, requestDate: requestDate);

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
                        child: _buildInfoSection(date, shiftTime),
                      ),

                      const SizedBox(height: TossSpacing.space6),

                      // Actual Attendance Section
                      _buildExpandableSection(
                        title: 'Actual Attendance',
                        isExpanded: isActualAttendanceExpanded,
                        onTap: () => setState(() => isActualAttendanceExpanded = !isActualAttendanceExpanded),
                        child: _buildActualAttendanceSection(currencySymbol),
                      ),

                      const SizedBox(height: TossSpacing.space6),

                      // Confirmed Attendance
                      _buildConfirmedAttendance(),

                      const SizedBox(height: TossSpacing.space4),

                      // Base Pay and Bonus
                      _buildPaySection(currencySymbol),

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
                            '$currencySymbol${FormatHelpers.formatNumber(shiftCard.totalPayAmount)}',
                            style: TossTextStyles.h2.copyWith(
                              color: TossColors.info,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: TossSpacing.space5),

                      // Reported status
                      if (shiftCard.isReported)
                        _buildReportedStatus(),

                      // Report Issue Button
                      _buildReportButton(context, ref),

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

  Widget _buildInfoSection(DateTime date, String shiftTime) {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    final workStatus = _getWorkStatus();
    final statusColor = _getWorkStatusColor();

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
              workStatus,
              style: TossTextStyles.body.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (shiftCard.lateMinutes > 0) ...[
          const SizedBox(height: TossSpacing.space4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Late', style: TossTextStyles.body.copyWith(color: TossColors.error)),
              Text(
                '${shiftCard.lateMinutes.toInt()} minutes',
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

  Widget _buildActualAttendanceSection(String currencySymbol) {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    final requestDateStr = shiftCard.requestDate;
    return Column(
      children: [
        AttendanceRowWidgets.buildInfoRow(
          'Actual Check-in',
          FormatHelpers.formatTime(
            shiftCard.actualStartTime,
            requestDate: requestDateStr,
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Actual Check-out',
          FormatHelpers.formatTime(
            shiftCard.actualEndTime,
            requestDate: requestDateStr,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),
        AttendanceRowWidgets.buildInfoRow(
          'Scheduled Hours',
          '${shiftCard.scheduledHours} hours',
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Paid Hours',
          '${shiftCard.paidHours} hours',
        ),
        const SizedBox(height: TossSpacing.space4),
        AttendanceRowWidgets.buildInfoRow(
          'Salary Type',
          shiftCard.salaryType,
        ),
        const SizedBox(height: TossSpacing.space3),
        AttendanceRowWidgets.buildInfoRow(
          'Salary per Hour',
          '$currencySymbol${FormatHelpers.formatNumber(shiftCard.salaryAmount)}',
        ),
      ],
    );
  }

  Widget _buildConfirmedAttendance() {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    final requestDateStr = shiftCard.requestDate;
    return Container(
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
              Text('Check-in', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                FormatHelpers.formatTime(
                  shiftCard.confirmStartTime,
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
                FormatHelpers.formatTime(
                  shiftCard.confirmEndTime,
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

  Widget _buildPaySection(String currencySymbol) {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    return Container(
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
              Text('Base Pay', style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500)),
              Text(
                '$currencySymbol${FormatHelpers.formatNumber(shiftCard.basePay)}',
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
                '$currencySymbol${FormatHelpers.formatNumber(shiftCard.bonusAmount)}',
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

  Widget _buildReportedStatus() {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space5),
      child: Container(
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
                    shiftCard.isProblemSolved
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

  Widget _buildReportButton(BuildContext context, WidgetRef ref) {
    // ✅ Clean Architecture: Use ShiftCard Entity properties
    final isDisabled = shiftCard.isReported || !shiftCard.isApproved;

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
                  final shiftRequestId = shiftCard.shiftRequestId;
                  if (shiftRequestId.isEmpty) {
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

                  // Convert ShiftCard to Map for backward compatibility with ReportIssueDialog
                  final cardData = _shiftCardToMap();

                  await ReportIssueDialog.show(
                    context: context,
                    ref: ref,
                    shiftRequestId: shiftRequestId,
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

  /// Helper method to get work status from ShiftCard
  String _getWorkStatus() {
    if (shiftCard.confirmEndTime != null && shiftCard.confirmEndTime!.isNotEmpty) {
      return 'Completed';
    } else if (shiftCard.confirmStartTime != null && shiftCard.confirmStartTime!.isNotEmpty) {
      return 'Working';
    } else if (shiftCard.isApproved) {
      return 'Approved';
    }
    return 'Pending';
  }

  /// Helper method to get work status color
  Color _getWorkStatusColor() {
    if (shiftCard.confirmEndTime != null && shiftCard.confirmEndTime!.isNotEmpty) {
      return TossColors.success;
    } else if (shiftCard.confirmStartTime != null && shiftCard.confirmStartTime!.isNotEmpty) {
      return TossColors.info;
    } else if (shiftCard.isApproved) {
      return TossColors.success;
    }
    return TossColors.warning;
  }

  /// Convert ShiftCard Entity to Map for backward compatibility
  Map<String, dynamic> _shiftCardToMap() {
    return {
      'shift_request_id': shiftCard.shiftRequestId,
      'request_date': shiftCard.requestDate,
      'shift_name': shiftCard.shiftName,
      'shift_time': shiftCard.shiftTime,
      'is_approved': shiftCard.isApproved,
      'is_reported': shiftCard.isReported,
      'is_problem_solved': shiftCard.isProblemSolved,
      'confirm_start_time': shiftCard.confirmStartTime,
      'confirm_end_time': shiftCard.confirmEndTime,
      'actual_start_time': shiftCard.actualStartTime,
      'actual_end_time': shiftCard.actualEndTime,
      'scheduled_hours': shiftCard.scheduledHours,
      'paid_hours': shiftCard.paidHours,
      'late_minutes': shiftCard.lateMinutes,
      'overtime_minutes': shiftCard.overtimeMinutes,
      'base_pay': shiftCard.basePay,
      'bonus_amount': shiftCard.bonusAmount,
      'total_pay_with_bonus': shiftCard.totalPayAmount,
      'salary_amount': shiftCard.salaryAmount,
      'salary_type': shiftCard.salaryType,
    };
  }
}
