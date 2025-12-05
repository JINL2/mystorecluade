import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_expandable_card.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import '../widgets/timesheets/staff_timelog_card.dart';
import '../widgets/timesheets/time_picker_bottom_sheet.dart';

/// Staff Timelog Detail Page - Manager view to confirm/edit staff attendance
///
/// Shows:
/// - Shift info (date, name, time range, status)
/// - Recorded attendance (actual clock in/out)
/// - Confirmed attendance (manager-approved times with edit capability)
/// - Issue report from employee (if exists)
/// - Bonus section (optional one-time bonus)
/// - Salary breakdown
class StaffTimelogDetailPage extends StatefulWidget {
  final StaffTimeRecord staffRecord;
  final String shiftName;
  final String shiftDate;
  final String shiftTimeRange;

  const StaffTimelogDetailPage({
    super.key,
    required this.staffRecord,
    required this.shiftName,
    required this.shiftDate,
    required this.shiftTimeRange,
  });

  @override
  State<StaffTimelogDetailPage> createState() => _StaffTimelogDetailPageState();
}

class _StaffTimelogDetailPageState extends State<StaffTimelogDetailPage> {
  bool _recordedAttendanceExpanded = false;
  bool _confirmedAttendanceExpanded = true; // Open by default for manager action

  // Mock data - replace with actual data later
  final String recordedCheckIn = '09:03:00';
  final String recordedCheckOut = '17:05:00';
  String confirmedCheckIn = '09:03:00';
  String confirmedCheckOut = '17:00:00';
  bool isCheckInManuallyConfirmed = false;
  bool isCheckOutManuallyConfirmed = false;
  final String? employeeIssueReport =
      '"I arrived on time but had to wait outside because the store was still closed. Please adjust the check-in time for this shift."';
  int bonusAmount = 0;

  // Issue report approval state
  String? issueReportStatus; // null, 'approved', 'rejected'

  // Salary breakdown mock data
  final String totalConfirmedTime = '120h 30m';
  final String hourlySalary = '85,000₫';
  final String basePay = '10,200,000₫';
  final int basePayAmount = 10200000;
  final String asOfDate = 'Aug/13';

  // Controllers
  final TextEditingController _bonusController = TextEditingController();

  @override
  void dispose() {
    _bonusController.dispose();
    super.dispose();
  }

  /// Calculate bonus pay from bonus amount
  String get bonusPay {
    return '${NumberFormat('#,###').format(bonusAmount)}₫';
  }

  /// Calculate total payment
  String get totalPayment {
    final total = basePayAmount + bonusAmount;
    return '${NumberFormat('#,###').format(total)}₫';
  }

  /// Parse time string "HH:MM:SS" to TimeOfDay and seconds
  Map<String, dynamic> _parseTime(String timeString) {
    final parts = timeString.split(':');
    return {
      'time': TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
      'seconds': parts.length > 2 ? int.parse(parts[2]) : 0,
    };
  }

  /// Show time picker for check-in
  Future<void> _showTimePickerForCheckIn() async {
    final parsedTime = _parseTime(confirmedCheckIn);
    final result = await TimePickerBottomSheet.show(
      context: context,
      title: 'Confirmed check-in',
      recordedTimeLabel: 'Recorded check-in',
      recordedTime: recordedCheckIn,
      initialTime: parsedTime['time'],
      initialSeconds: parsedTime['seconds'],
    );

    if (result != null) {
      setState(() {
        final time = result['time'] as TimeOfDay;
        final seconds = result['seconds'] as int;
        confirmedCheckIn = time.toFormattedString(seconds: seconds);
        isCheckInManuallyConfirmed = true; // Mark as confirmed
      });
    }
  }

  /// Show time picker for check-out
  Future<void> _showTimePickerForCheckOut() async {
    final parsedTime = _parseTime(confirmedCheckOut);
    final result = await TimePickerBottomSheet.show(
      context: context,
      title: 'Confirmed check-out',
      recordedTimeLabel: 'Recorded check-out',
      recordedTime: recordedCheckOut,
      initialTime: parsedTime['time'],
      initialSeconds: parsedTime['seconds'],
    );

    if (result != null) {
      setState(() {
        final time = result['time'] as TimeOfDay;
        final seconds = result['seconds'] as int;
        confirmedCheckOut = time.toFormattedString(seconds: seconds);
        isCheckOutManuallyConfirmed = true; // Mark as confirmed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: AppBar(
        backgroundColor: TossColors.white,
        elevation: 0,
        surfaceTintColor: TossColors.white,
        title: Text(
          'Shift Details Management',
          style: TossTextStyles.titleMedium.copyWith(
            color: TossColors.gray900,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: TossColors.gray900),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift Info Card
                  _buildShiftInfoCard(),
                  const SizedBox(height: 16),

                  // Recorded Attendance Card
                  TossExpandableCard(
                    title: 'Recorded attendance',
                    isExpanded: _recordedAttendanceExpanded,
                    onToggle: () {
                      setState(() {
                        _recordedAttendanceExpanded = !_recordedAttendanceExpanded;
                      });
                    },
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          label: 'Recorded check-in',
                          value: recordedCheckIn,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          label: 'Recorded check-out',
                          value: recordedCheckOut,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Based on check-in/out device logs.',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirmed Attendance Card (with edit capability)
                  _buildConfirmedAttendanceCard(),

                  // Gray Divider after Confirmed Attendance
                  const GrayDividerSpace(),

                  // Issue Report Section (if exists)
                  if (employeeIssueReport != null) ...[
                    _buildIssueReportCard(),
                    const SizedBox(height: 16),
                  ],

                  // Bonus Section
                  _buildBonusSection(),
                  const SizedBox(height: 16),

                  // Salary Breakdown Card
                  _buildSalaryBreakdownCard(),
                ],
              ),
            ),
          ),

          // Fixed Bottom Button
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
            decoration: BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: TossButton1.primary(
              text: 'Save & confirm shift',
              fullWidth: true,
              onPressed: () {
                // TODO: Implement save and confirm
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds shift info card - reused structure from shift_detail_page
  Widget _buildShiftInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shiftDate,
                      style: TossTextStyles.label.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.shiftName,
                      style: TossTextStyles.titleMedium.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.shiftTimeRange,
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              if (widget.staffRecord.isLate || widget.staffRecord.isOvertime)
                TossBadge(
                  label: widget.staffRecord.isLate ? 'Late' : 'OT',
                  backgroundColor: TossColors.error,
                  textColor: TossColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  borderRadius: 12,
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Check if both check-in and check-out are confirmed
  bool get _isFullyConfirmed {
    bool checkInConfirmed = !widget.staffRecord.isLate || isCheckInManuallyConfirmed;
    bool checkOutConfirmed = !widget.staffRecord.isOvertime || isCheckOutManuallyConfirmed;
    return checkInConfirmed && checkOutConfirmed;
  }

  /// Builds confirmed attendance card with edit capability
  Widget _buildConfirmedAttendanceCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Header with Badge
          InkWell(
            onTap: () {
              setState(() {
                _confirmedAttendanceExpanded = !_confirmedAttendanceExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.lg),
              bottom: _confirmedAttendanceExpanded ? Radius.zero : Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                children: [
                  Text(
                    'Confirmed attendance',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isFullyConfirmed ? '• Confirmed' : '• Need confirm',
                    style: TossTextStyles.caption.copyWith(
                      color: _isFullyConfirmed ? TossColors.gray500 : TossColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _confirmedAttendanceExpanded ? Icons.expand_less : Icons.expand_more,
                    color: TossColors.gray600,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Content
          if (_confirmedAttendanceExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditableTimeRow(
                    label: 'Confirmed check-in',
                    value: confirmedCheckIn,
                    needsConfirm: widget.staffRecord.isLate && !isCheckInManuallyConfirmed,
                    isConfirmed: isCheckInManuallyConfirmed,
                    onEdit: () => _showTimePickerForCheckIn(),
                  ),
                  const SizedBox(height: 12),
                  _buildEditableTimeRow(
                    label: 'Confirmed check-out',
                    value: confirmedCheckOut,
                    needsConfirm: widget.staffRecord.isOvertime && !isCheckOutManuallyConfirmed,
                    isConfirmed: isCheckOutManuallyConfirmed,
                    onEdit: () => _showTimePickerForCheckOut(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'These times are used for salary calculations.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds issue report card (if employee reported an issue)
  Widget _buildIssueReportCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue report from employee',
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            employeeIssueReport!,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Show buttons based on status
          if (issueReportStatus == null)
            Row(
              children: [
                Expanded(
                  child: TossButton1.secondary(
                    text: 'Reject explanation',
                    onPressed: () {
                      setState(() {
                        issueReportStatus = 'rejected';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TossButton1.outlined(
                    text: 'Approve explanation',
                    onPressed: () {
                      setState(() {
                        issueReportStatus = 'approved';
                      });
                    },
                  ),
                ),
              ],
            ),
          // Show rejected button (full width, disabled)
          if (issueReportStatus == 'rejected')
            TossButton1.secondary(
              text: 'Rejected',
              fullWidth: true,
              onPressed: null,
            ),
          // Show approved button (full width, disabled)
          if (issueReportStatus == 'approved')
            TossButton1.outlined(
              text: 'Approved',
              fullWidth: true,
              onPressed: null,
            ),
        ],
      ),
    );
  }

  /// Builds bonus section
  Widget _buildBonusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonus for this shift (₫)',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            // Show "0" when field is empty
            if (_bonusController.text.isEmpty)
              Positioned.fill(
                child: Center(
                  child: IgnorePointer(
                    child: Text(
                      '0',
                      style: TossTextStyles.h2.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            TextField(
              controller: _bonusController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TossTextStyles.h2.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w700,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Auto-format with commas
                  if (newValue.text.isEmpty) return newValue;
                  final number = int.tryParse(newValue.text.replaceAll(',', ''));
                  if (number == null) return oldValue;
                  final formatted = NumberFormat('#,###').format(number);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray100, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray100, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: BorderSide(color: TossColors.gray100, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  bonusAmount = int.tryParse(value.replaceAll(',', '')) ?? 0;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Optional one-time bonus approved by manager.',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  /// Builds salary breakdown card - reused structure from shift_detail_page
  Widget _buildSalaryBreakdownCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary breakdown this shift',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'As of $asOfDate',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            _buildInfoRow(
              label: 'Total confirmed time',
              value: totalConfirmedTime,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Hourly salary',
              value: hourlySalary,
            ),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: TossColors.gray100,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Base pay',
              value: basePay,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Bonus pay',
              value: bonusPay,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Total payment',
              value: totalPayment,
              labelStyle: TossTextStyles.titleMedium.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              valueStyle: TossTextStyles.titleMedium.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds info row with label and value - reused from shift_detail_page
  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  /// Builds editable time row with colored text and edit button
  Widget _buildEditableTimeRow({
    required String label,
    required String value,
    required bool needsConfirm,
    required VoidCallback onEdit,
    bool isConfirmed = false,
  }) {
    // Determine color: red if needs confirm, blue if confirmed, black otherwise
    Color timeColor;
    if (needsConfirm) {
      timeColor = TossColors.error; // Red
    } else if (isConfirmed) {
      timeColor = TossColors.primary; // Blue
    } else {
      timeColor = TossColors.gray900; // Black
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: timeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isConfirmed) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Confirmed',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: TossColors.gray600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
