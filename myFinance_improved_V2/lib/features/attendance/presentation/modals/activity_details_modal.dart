import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../domain/entities/shift_card_data.dart';
import '../utils/attendance_formatters.dart';
import '../utils/date_format_utils.dart';

/// Modal bottom sheet that displays detailed shift activity information
///
/// Shows comprehensive shift details including:
/// - Basic info (date, shift time, status)
/// - Actual attendance (check-in/out times, hours)
/// - Confirmed attendance times
/// - Payment breakdown (base pay, bonus, total)
/// - Report issue functionality
class ActivityDetailsModal extends StatelessWidget {
  final ShiftCardData cardData;
  final String currencySymbol;
  final Future<void> Function(String shiftRequestId, ShiftCardData cardData) onReportIssue;

  const ActivityDetailsModal({
    super.key,
    required this.cardData,
    required this.currencySymbol,
    required this.onReportIssue,
  });

  /// Shows the modal bottom sheet
  static void show({
    required BuildContext context,
    required Map<String, dynamic> activity,
    required String currencySymbol,
    required Future<void> Function(String, ShiftCardData) onReportIssue,
  }) {
    final cardData = activity['rawCard'] as ShiftCardData?;
    if (cardData == null) {
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => ActivityDetailsModal(
        cardData: cardData,
        currencySymbol: currencySymbol,
        onReportIssue: onReportIssue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Parse date
    final dateStr = cardData.requestDate;
    final dateParts = dateStr.split('-');
    final date = dateParts.length == 3
        ? DateTime(
            int.parse(dateParts[0].toString()),
            int.parse(dateParts[1].toString()),
            int.parse(dateParts[2].toString())
          )
        : DateTime.now();

    // Format shift time
    final shiftTime = AttendanceFormatters.formatShiftTime(cardData.shiftTime, requestDate: cardData.requestDate);

    return _ActivityDetailsContent(
      cardData: cardData,
      date: date,
      shiftTime: shiftTime,
      currencySymbol: currencySymbol,
      onReportIssue: onReportIssue,
    );
  }
}

/// Stateful content widget for expandable sections
class _ActivityDetailsContent extends StatefulWidget {
  final ShiftCardData cardData;
  final DateTime date;
  final String shiftTime;
  final String currencySymbol;
  final Future<void> Function(String, ShiftCardData) onReportIssue;

  const _ActivityDetailsContent({
    required this.cardData,
    required this.date,
    required this.shiftTime,
    required this.currencySymbol,
    required this.onReportIssue,
  });

  @override
  State<_ActivityDetailsContent> createState() => _ActivityDetailsContentState();
}

class _ActivityDetailsContentState extends State<_ActivityDetailsContent> {
  bool isInfoExpanded = false;
  bool isActualAttendanceExpanded = false;

  @override
  Widget build(BuildContext context) {
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

          // Content with scroll
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
                    children: [
                      _buildInfoRow('Date', widget.date.toDateKey()),
                      const SizedBox(height: TossSpacing.space4),
                      _buildInfoRow('Shift Time', widget.shiftTime),
                      const SizedBox(height: TossSpacing.space4),
                      _buildStatusRow(),
                      if (widget.cardData.lateMinutes > 0) ...[
                        const SizedBox(height: TossSpacing.space4),
                        _buildLateRow(),
                      ],
                    ],
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Actual Attendance Section
                  _buildExpandableSection(
                    title: 'Actual Attendance',
                    isExpanded: isActualAttendanceExpanded,
                    onTap: () => setState(() => isActualAttendanceExpanded = !isActualAttendanceExpanded),
                    children: [
                      _buildInfoRow('Actual Check-in', AttendanceFormatters.formatTime(widget.cardData.actualStartTime, requestDate: widget.cardData.requestDate)),
                      const SizedBox(height: TossSpacing.space3),
                      _buildInfoRow('Actual Check-out', AttendanceFormatters.formatTime(widget.cardData.actualEndTime, requestDate: widget.cardData.requestDate)),
                      const SizedBox(height: TossSpacing.space4),
                      _buildInfoRow('Scheduled Hours', '${widget.cardData.scheduledHours ?? 0.0} hours'),
                      const SizedBox(height: TossSpacing.space3),
                      _buildInfoRow('Paid Hours', '${widget.cardData.paidHours ?? 0} hours'),
                      const SizedBox(height: TossSpacing.space4),
                      _buildInfoRow('Salary Type', widget.cardData.salaryType ?? 'hourly'),
                      const SizedBox(height: TossSpacing.space3),
                      _buildInfoRow('Salary per Hour', '${widget.currencySymbol}${AttendanceFormatters.formatNumber(widget.cardData.salaryAmount ?? 0)}'),
                    ],
                  ),

                  const SizedBox(height: TossSpacing.space6),

                  // Confirmed Attendance
                  _buildConfirmedAttendance(),

                  const SizedBox(height: TossSpacing.space4),

                  // Payment Info
                  _buildPaymentInfo(),

                  const SizedBox(height: TossSpacing.space6),

                  // Divider
                  Container(height: 1, color: TossColors.gray100),

                  const SizedBox(height: TossSpacing.space4),

                  // Total Pay
                  _buildTotalPay(),

                  const SizedBox(height: TossSpacing.space5),

                  // Reported Status
                  if (widget.cardData.isReported) ...[
                    _buildReportedStatus(),
                    const SizedBox(height: TossSpacing.space5),
                  ],

                  // Report Issue Button
                  _buildReportButton(),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
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
          ...children,
        ],
      ],
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

  Widget _buildStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          AttendanceFormatters.getWorkStatusFromCard(widget.cardData),
          style: TossTextStyles.body.copyWith(
            color: AttendanceFormatters.getWorkStatusColorFromCard(widget.cardData),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Late',
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
          ),
        ),
        Text(
          '${widget.cardData.lateMinutes} minutes',
          style: TossTextStyles.body.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmedAttendance() {
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
          _buildConfirmedRow('Check-in', widget.cardData.actualStartTime),
          const SizedBox(height: TossSpacing.space2),
          _buildConfirmedRow('Check-out', widget.cardData.actualEndTime),
        ],
      ),
    );
  }

  Widget _buildConfirmedRow(String label, dynamic time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          AttendanceFormatters.formatTime(time, requestDate: widget.cardData.requestDate),
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentRow('Base Pay', widget.cardData.basePay ?? 0),
          const SizedBox(height: TossSpacing.space2),
          _buildPaymentRow('Bonus Amount', widget.cardData.bonusAmount ?? 0),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, dynamic amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray500,
          ),
        ),
        Text(
          '${widget.currencySymbol}${AttendanceFormatters.formatNumber(amount)}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPay() {
    return Row(
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
          '${widget.currencySymbol}${AttendanceFormatters.formatNumber(widget.cardData.totalPayWithBonus ?? 0)}',
          style: TossTextStyles.h2.copyWith(
            color: TossColors.info,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildReportedStatus() {
    return Container(
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
                  'Your report is being reviewed',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton() {
    final isDisabled = widget.cardData.isReported || !widget.cardData.isApproved;

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
          onTap: isDisabled ? null : () => _handleReportIssue(),
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

  Future<void> _handleReportIssue() async {
    final shiftRequestId = widget.cardData.shiftRequestId;
    if (shiftRequestId.isEmpty) {
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Unable to Report Issue',
            message: 'Missing shift ID',
            primaryButtonText: 'OK',
          ),
        );
      }
      return;
    }

    HapticFeedback.selectionClick();
    await widget.onReportIssue(shiftRequestId, widget.cardData);
  }

  // Helper methods
}
