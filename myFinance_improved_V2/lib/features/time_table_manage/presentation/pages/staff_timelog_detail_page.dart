import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_expandable_card.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../providers/usecase/time_table_usecase_providers.dart';
import '../../domain/usecases/input_card_v4.dart';
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
class StaffTimelogDetailPage extends ConsumerStatefulWidget {
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
  ConsumerState<StaffTimelogDetailPage> createState() => _StaffTimelogDetailPageState();
}

class _StaffTimelogDetailPageState extends ConsumerState<StaffTimelogDetailPage> {
  bool _recordedAttendanceExpanded = false;
  bool _confirmedAttendanceExpanded = true; // Open by default for manager action
  bool _isSaving = false; // Loading state for save button

  // State variables initialized from StaffTimeRecord
  late String recordedCheckIn;
  late String recordedCheckOut;
  late String confirmedCheckIn;
  late String confirmedCheckOut;
  bool isCheckInManuallyConfirmed = false;
  bool isCheckOutManuallyConfirmed = false;

  // Initial values for change detection
  late String _initialConfirmedCheckIn;
  late String _initialConfirmedCheckOut;
  late int _initialBonusAmount;
  late String? _initialIssueReportStatus;

  // Issue report from RPC (is_reported, report_reason)
  String? get employeeIssueReport => widget.staffRecord.isReported ? widget.staffRecord.reportReason : null;

  // Bonus amount initialized from RPC
  late int bonusAmount;

  // Issue report approval state (based on is_problem_solved from RPC)
  String? issueReportStatus; // null, 'approved', 'rejected'

  // Track if user has clicked to expand issue report buttons
  // When false: show single button based on is_problem_solved
  // When true: show both buttons for user to select
  bool _showBothIssueButtons = false;

  /// Check if confirm times are valid (not default placeholder values)
  bool get _areConfirmTimesValid {
    // Both confirm times must be set (not placeholder values)
    final checkInValid = confirmedCheckIn != '--:--:--' && confirmedCheckIn.isNotEmpty;
    final checkOutValid = confirmedCheckOut != '--:--:--' && confirmedCheckOut.isNotEmpty;
    return checkInValid && checkOutValid;
  }

  /// Check if there are any changes from the initial values
  bool get hasChanges {
    // Check confirmed times changed
    final checkInChanged = confirmedCheckIn != _initialConfirmedCheckIn;
    final checkOutChanged = confirmedCheckOut != _initialConfirmedCheckOut;

    // Check bonus amount changed
    final bonusChanged = bonusAmount != _initialBonusAmount;

    // Check issue report status changed (only if issue report exists AND user made a selection)
    // - issueReportStatus == null means user hasn't made a selection yet → no change
    // - issueReportStatus != null AND different from initial → change detected
    final hasIssueReport = widget.staffRecord.isReported;
    final issueStatusChanged = hasIssueReport &&
        issueReportStatus != null &&
        issueReportStatus != _initialIssueReportStatus;

    debugPrint('[hasChanges] checkIn: $confirmedCheckIn vs $_initialConfirmedCheckIn = $checkInChanged');
    debugPrint('[hasChanges] checkOut: $confirmedCheckOut vs $_initialConfirmedCheckOut = $checkOutChanged');
    debugPrint('[hasChanges] bonus: $bonusAmount vs $_initialBonusAmount = $bonusChanged');
    debugPrint('[hasChanges] issueStatus: $issueReportStatus vs $_initialIssueReportStatus (hasReport: $hasIssueReport) = $issueStatusChanged');
    debugPrint('[hasChanges] confirmTimesValid: $_areConfirmTimesValid');

    final hasAnyChange = checkInChanged || checkOutChanged || bonusChanged || issueStatusChanged;

    // If confirm times were changed, they must be valid
    // If only bonus or issue status changed, confirm times validation is not required
    final timesChanged = checkInChanged || checkOutChanged;
    if (timesChanged) {
      // Times changed - must be valid
      return hasAnyChange && _areConfirmTimesValid;
    } else {
      // Only bonus or issue status changed - allow save without time validation
      return hasAnyChange;
    }
  }

  // Salary breakdown from RPC
  String get totalConfirmedTime {
    final paidHour = widget.staffRecord.paidHour;
    final hours = paidHour.floor();
    final minutes = ((paidHour - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  String get hourlySalary {
    final salaryAmount = widget.staffRecord.salaryAmount;
    if (salaryAmount == null || salaryAmount.isEmpty) return '--';
    // Try to format as number with comma
    final amount = double.tryParse(salaryAmount);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$salaryAmount₫';
  }

  String get basePay {
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr == null || basePayStr.isEmpty) {
      // Calculate from paidHour * salaryAmount if not provided
      final salaryAmountStr = widget.staffRecord.salaryAmount;
      if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
        final salaryAmount = double.tryParse(salaryAmountStr);
        if (salaryAmount != null) {
          final basePayCalc = (widget.staffRecord.paidHour * salaryAmount).toInt();
          return '${NumberFormat('#,###').format(basePayCalc)}₫';
        }
      }
      return '--';
    }
    final amount = double.tryParse(basePayStr);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$basePayStr₫';
  }

  int get basePayAmount {
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      final amount = double.tryParse(basePayStr);
      if (amount != null) return amount.toInt();
    }
    // Calculate from paidHour * salaryAmount if not provided
    final salaryAmountStr = widget.staffRecord.salaryAmount;
    if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
      final salaryAmount = double.tryParse(salaryAmountStr);
      if (salaryAmount != null) {
        return (widget.staffRecord.paidHour * salaryAmount).toInt();
      }
    }
    return 0;
  }

  String get asOfDate {
    // Parse shiftDate from widget and format as "Mon/DD"
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    try {
      final date = DateTime.parse(widget.shiftDate);
      return '${months[date.month - 1]}/${date.day}';
    } catch (e) {
      return widget.shiftDate;
    }
  }

  // Controllers
  final TextEditingController _bonusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize from StaffTimeRecord real data
    // Recorded: use actual_start, actual_end (extract time only)
    recordedCheckIn = _extractTimeFromString(widget.staffRecord.actualStart) ?? '--:--:--';
    recordedCheckOut = _extractTimeFromString(widget.staffRecord.actualEnd) ?? '--:--:--';

    // Confirmed: use confirm_start_time, confirm_end_time
    // If not available, fallback to recorded times
    confirmedCheckIn = _extractTimeFromString(widget.staffRecord.confirmStartTime) ?? recordedCheckIn;
    confirmedCheckOut = _extractTimeFromString(widget.staffRecord.confirmEndTime) ?? recordedCheckOut;

    // Initialize bonus from RPC bonus_amount
    bonusAmount = widget.staffRecord.bonusAmount.toInt();
    if (bonusAmount > 0) {
      _bonusController.text = NumberFormat('#,###').format(bonusAmount);
    }

    // Initialize issue report status:
    // - issueReportStatus starts as null (user hasn't made a selection yet)
    // - _initialIssueReportStatus stores the RPC value for change detection
    // - When user selects approve/reject, issueReportStatus gets set
    // - Change is detected by comparing issueReportStatus with _initialIssueReportStatus
    if (widget.staffRecord.isReported) {
      // Store initial value from RPC for change detection
      _initialIssueReportStatus = widget.staffRecord.isProblemSolved ? 'approved' : 'rejected';
      // issueReportStatus stays null until user makes a selection
      issueReportStatus = null;
    }

    // Store initial values for change detection
    _initialConfirmedCheckIn = confirmedCheckIn;
    _initialConfirmedCheckOut = confirmedCheckOut;
    _initialBonusAmount = bonusAmount;
  }

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

  /// Extract time (HH:mm:ss) from various string formats
  /// Handles:
  /// - ISO 8601: "2025-12-07T14:00:00.000" → "14:00:00"
  /// - Time only: "14:00:00" → "14:00:00"
  /// - Returns null if input is null or invalid
  String? _extractTimeFromString(String? input) {
    if (input == null || input.isEmpty) return null;

    // Check if it's ISO 8601 format (contains 'T')
    if (input.contains('T')) {
      try {
        final dateTime = DateTime.parse(input);
        final hour = dateTime.hour.toString().padLeft(2, '0');
        final minute = dateTime.minute.toString().padLeft(2, '0');
        final second = dateTime.second.toString().padLeft(2, '0');
        return '$hour:$minute:$second';
      } catch (e) {
        debugPrint('[_extractTimeFromString] Error parsing ISO: $e');
        return null;
      }
    }

    // Already in time format (HH:mm:ss or HH:mm)
    if (input.contains(':')) {
      return input;
    }

    return null;
  }

  /// Parse time string "HH:MM:SS" to TimeOfDay and seconds
  /// Returns default time (00:00:00) if parsing fails (e.g., for placeholder "--:--:--")
  Map<String, dynamic> _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) {
        return {'time': const TimeOfDay(hour: 0, minute: 0), 'seconds': 0};
      }
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final seconds = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
      return {
        'time': TimeOfDay(hour: hour, minute: minute),
        'seconds': seconds,
      };
    } catch (e) {
      debugPrint('[_parseTime] Error parsing "$timeString": $e');
      return {'time': const TimeOfDay(hour: 0, minute: 0), 'seconds': 0};
    }
  }

  /// Show time picker for check-in
  Future<void> _showTimePickerForCheckIn() async {
    final parsedTime = _parseTime(confirmedCheckIn);
    final result = await TimePickerBottomSheet.show(
      context: context,
      title: 'Confirmed Check In',
      recordedTimeLabel: 'Recorded check in',
      recordedTime: recordedCheckIn,
      initialTime: parsedTime['time'] as TimeOfDay,
      initialSeconds: parsedTime['seconds'] as int,
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
      title: 'Confirmed Check Out',
      recordedTimeLabel: 'Recorded check out',
      recordedTime: recordedCheckOut,
      initialTime: parsedTime['time'] as TimeOfDay,
      initialSeconds: parsedTime['seconds'] as int,
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

  /// Save and confirm shift using manager_shift_input_card_v4 RPC
  ///
  /// Sends local device time without conversion (as per RPC requirement)
  Future<void> _saveAndConfirmShift() async {
    // Validate shiftRequestId exists
    final shiftRequestId = widget.staffRecord.shiftRequestId;
    if (shiftRequestId == null || shiftRequestId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Missing shift request ID'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    // Get manager ID from app state (key is 'user_id', not 'id')
    final appState = ref.read(appStateProvider);
    final managerId = appState.user['user_id'] as String?;
    if (managerId == null || managerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Manager ID not found'),
          backgroundColor: TossColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get usecase from provider
      final inputCardV4UseCase = ref.read(inputCardV4UseCaseProvider);

      // Get device timezone in IANA format (e.g., "Asia/Ho_Chi_Minh", "Asia/Seoul")
      // RPC requires IANA timezone name, not abbreviation like "KST"
      final timezone = DateTimeUtils.getLocalTimezone();

      // Determine is_problem_solved value from issueReportStatus
      // Only send if issue report exists and user made a selection
      bool? isProblemSolved;
      if (widget.staffRecord.isReported && issueReportStatus != null) {
        isProblemSolved = issueReportStatus == 'approved';
      }

      // Create params - time values are already in local format (HH:mm:ss)
      final params = InputCardV4Params(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmedCheckIn != '--:--:--' ? confirmedCheckIn : null,
        confirmEndTime: confirmedCheckOut != '--:--:--' ? confirmedCheckOut : null,
        isProblemSolved: isProblemSolved,
        bonusAmount: bonusAmount.toDouble(),
        timezone: timezone,
      );

      debugPrint('[SaveShift] Calling inputCardV4 with params:');
      debugPrint('  shiftRequestId: $shiftRequestId');
      debugPrint('  managerId: $managerId');
      debugPrint('  confirmStartTime: ${params.confirmStartTime}');
      debugPrint('  confirmEndTime: ${params.confirmEndTime}');
      debugPrint('  isProblemSolved: $isProblemSolved');
      debugPrint('  bonusAmount: $bonusAmount');
      debugPrint('  timezone: $timezone');

      // Execute RPC call
      final result = await inputCardV4UseCase.call(params);

      debugPrint('[SaveShift] Success: $result');
      if (mounted) {
        // Update local state to reflect saved values (no need for RPC refresh)
        setState(() {
          _initialConfirmedCheckIn = confirmedCheckIn;
          _initialConfirmedCheckOut = confirmedCheckOut;
          _initialBonusAmount = bonusAmount;
          if (issueReportStatus != null) {
            _initialIssueReportStatus = issueReportStatus;
          }
        });
        // Close page and return success (no SnackBar)
        Navigator.pop(context, true);
      }
    } on ArgumentError catch (e) {
      debugPrint('[SaveShift] ArgumentError: ${e.message}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } catch (e) {
      debugPrint('[SaveShift] Exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
                  const SizedBox(height: 16),

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
              isLoading: _isSaving,
              // Disable button when no changes from default values
              isEnabled: hasChanges && !_isSaving,
              onPressed: _saveAndConfirmShift,
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
  ///
  /// Button logic:
  /// - Initial state based on is_problem_solved from RPC:
  ///   - is_problem_solved = true → Show "Approved" button only
  ///   - is_problem_solved = false → Show "Reject explanation" button only
  /// - When button is clicked → Show both buttons for user to select
  /// - User's selection is stored in issueReportStatus for parameter submission
  Widget _buildIssueReportCard() {
    // Determine initial button to show based on is_problem_solved
    final isProblemSolved = widget.staffRecord.isProblemSolved;

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

          // Case 1: User hasn't clicked yet, show single button based on is_problem_solved
          if (!_showBothIssueButtons && issueReportStatus == null) ...[
            if (isProblemSolved)
              // is_problem_solved = true → Show "Approved" button
              TossButton1.outlined(
                text: 'Approved',
                fullWidth: true,
                onPressed: () {
                  setState(() {
                    _showBothIssueButtons = true;
                  });
                },
              )
            else
              // is_problem_solved = false → Show "Reject explanation" button
              TossButton1.secondary(
                text: 'Reject explanation',
                fullWidth: true,
                onPressed: () {
                  setState(() {
                    _showBothIssueButtons = true;
                  });
                },
              ),
          ],

          // Case 2: User clicked to expand, show both buttons for selection
          if (_showBothIssueButtons && issueReportStatus == null)
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

          // Case 3: User has made a selection, show selected button
          // Clicking the selected button allows changing selection (shows both buttons again)
          if (issueReportStatus == 'rejected')
            TossButton1.secondary(
              text: 'Rejected',
              fullWidth: true,
              onPressed: () {
                setState(() {
                  // Reset to show both buttons for re-selection
                  issueReportStatus = null;
                  _showBothIssueButtons = true;
                });
              },
            ),
          if (issueReportStatus == 'approved')
            TossButton1.outlined(
              text: 'Approved',
              fullWidth: true,
              onPressed: () {
                setState(() {
                  // Reset to show both buttons for re-selection
                  issueReportStatus = null;
                  _showBothIssueButtons = true;
                });
              },
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray100, width: 1),
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
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
