import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/features/attendance/domain/entities/shift_card.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_expandable_card.dart';

/// Shift Detail Page - Shows detailed information about a specific shift
///
/// Displays:
/// - Shift info (date, time, type, status)
/// - Recorded attendance (check-in/out from actual records)
/// - Confirmed attendance (manager-approved times)
/// - Payment breakdown (base pay, bonus, total)
/// - Report issue action
class ShiftDetailPage extends StatefulWidget {
  final ShiftCard shift;

  const ShiftDetailPage({
    super.key,
    required this.shift,
  });

  @override
  State<ShiftDetailPage> createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends State<ShiftDetailPage> {
  bool _recordedAttendanceExpanded = false;
  bool _confirmedAttendanceExpanded = false;

  /// Format date from "2025-11-24" to "Mon, 24 Nov 2025"
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEE, d MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Format time from "14:30:00" to "14:30:00" (with seconds)
  String _formatTime(String? timeStr, {bool includeSeconds = false}) {
    if (timeStr == null || timeStr.isEmpty) return '--:--';
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 3 && includeSeconds) {
        return '${parts[0]}:${parts[1]}:${parts[2]}';
      } else if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return timeStr;
    } catch (e) {
      return timeStr;
    }
  }

  /// Format hours to "8h 2m"
  String _formatHours(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  /// Format money with currency
  String _formatMoney(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Get status text from shift
  String _getStatusText() {
    if (widget.shift.isLate) return 'Late';
    if (!widget.shift.isApproved) return 'Pending';
    return 'On-time';
  }

  /// Get confirmed start time (use scheduled time from shift, not actual check-in)
  /// Confirmed times should always be whole hours from shift settings
  String? _getConfirmedStartTime() {
    // Priority 1: Parse from shift_time field (format: "09:00-18:00" or "Morning Shift")
    final shiftTime = widget.shift.shiftTime;
    if (shiftTime.contains('-')) {
      final parts = shiftTime.split('-');
      if (parts.isNotEmpty) {
        return parts[0].trim(); // Return start time (e.g., "09:00")
      }
    }

    // Priority 2: Fall back to confirm_start_time from database
    return widget.shift.confirmStartTime;
  }

  /// Get confirmed end time (use scheduled time from shift, not actual check-out)
  /// Confirmed times should always be whole hours from shift settings
  String? _getConfirmedEndTime() {
    // Priority 1: Parse from shift_time field (format: "09:00-18:00" or "Morning Shift")
    final shiftTime = widget.shift.shiftTime;
    if (shiftTime.contains('-')) {
      final parts = shiftTime.split('-');
      if (parts.length > 1) {
        return parts[1].trim(); // Return end time (e.g., "18:00")
      }
    }

    // Priority 2: Fall back to confirm_end_time from database
    return widget.shift.confirmEndTime;
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
          'Shift details',
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
                      children: [
                        _buildInfoRow(
                          label: 'Recorded check-in',
                          value: _formatTime(widget.shift.actualStartTime, includeSeconds: true),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          label: 'Recorded check-out',
                          value: _formatTime(widget.shift.actualEndTime, includeSeconds: true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirmed Attendance Card
                  TossExpandableCard(
                    title: 'Confirmed attendance',
                    isExpanded: _confirmedAttendanceExpanded,
                    onToggle: () {
                      setState(() {
                        _confirmedAttendanceExpanded = !_confirmedAttendanceExpanded;
                      });
                    },
                    content: Column(
                      children: [
                        _buildInfoRow(
                          label: 'Confirmed check-in',
                          value: _formatTime(_getConfirmedStartTime()),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          label: 'Confirmed check-out',
                          value: _formatTime(_getConfirmedEndTime()),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Summary Card
                  _buildPaymentSummaryCard(),
                  const SizedBox(height: 20),

                  // Helper Text
                  Text(
                    'Recorded attendance is based on your check-in/out records.\nConfirmed attendance is the manager-approved time used for salary.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      height: 1.6,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer Action
          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              48, // 48px bottom padding for safe area
            ),
            decoration: BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: TossButton1.secondary(
              text: 'Report an issue with this shift',
              leadingIcon: const Icon(Icons.error_outline, size: 18),
              fullWidth: true,
              textColor: TossColors.gray600,
              onPressed: () {
                // TODO: Implement report issue
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds shift info card with date, type, time, and status badge
  Widget _buildShiftInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(widget.shift.requestDate),
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.shift.shiftTime,
                  style: TossTextStyles.titleMedium.copyWith(
                    color: TossColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_formatHours(widget.shift.scheduledHours)} scheduled',
                  style: TossTextStyles.bodyLarge.copyWith(
                    color: TossColors.gray600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(_getStatusText()),
        ],
      ),
    );
  }

  /// Builds status badge based on shift status
  Widget _buildStatusBadge(String status) {
    // Map status string to badge colors
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'on-time':
        backgroundColor = TossColors.success;
        textColor = TossColors.white;
        break;
      case 'late':
        backgroundColor = TossColors.warning;
        textColor = TossColors.white;
        break;
      case 'absent':
        backgroundColor = TossColors.error;
        textColor = TossColors.white;
        break;
      default:
        backgroundColor = TossColors.gray100;
        textColor = TossColors.gray700;
    }

    return TossBadge(
      label: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      borderRadius: 12,
    );
  }

  /// Builds payment summary card with all payment details
  Widget _buildPaymentSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: TossColors.gray100, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            label: 'Total confirmed time',
            value: _formatHours(widget.shift.paidHours),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'Hourly salary',
            value: _formatMoney(widget.shift.salaryAmountValue),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'Base pay',
            value: _formatMoney(widget.shift.basePayAmount),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'Bonus pay',
            value: _formatMoney(widget.shift.bonusAmount),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'Total payment',
            value: _formatMoney(widget.shift.totalPayAmount),
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
    );
  }

  /// Builds info row with label and value
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
}
