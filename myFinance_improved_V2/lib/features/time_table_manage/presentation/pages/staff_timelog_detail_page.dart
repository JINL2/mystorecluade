import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/usecases/input_card_v5.dart';
import '../providers/usecase/time_table_usecase_providers.dart';
import '../widgets/timesheets/staff_timelog_card.dart';
import '../widgets/timesheets/time_picker_bottom_sheet.dart';
import 'staff_timelog_detail/utils/timelog_helpers.dart';
import 'staff_timelog_detail/widgets/widgets.dart';

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
  bool _confirmedAttendanceExpanded = true;
  bool _isSaving = false;

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
  bool? _initialIsReportedSolved; // v4: Track initial RPC value for report status

  // Issue report from RPC
  String? get employeeIssueReport => widget.staffRecord.isReported ? widget.staffRecord.reportReason : null;

  // Bonus amount
  late int bonusAmount;
  int penaltyAmount = 0;
  late int _initialPenaltyAmount;

  // Controllers for bonus, deduct and memo text fields
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _deductController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();

  // Memo state
  late String _initialMemo;

  // Issue report approval state
  String? issueReportStatus;

  // ============================================================================
  // Computed Properties
  // ============================================================================

  // ============================================================================
  // Section-level Change Detection
  // ============================================================================

  /// Check if confirmed check-in time has changed
  bool get isCheckInChanged => confirmedCheckIn != _initialConfirmedCheckIn;

  /// Check if confirmed check-out time has changed
  bool get isCheckOutChanged => confirmedCheckOut != _initialConfirmedCheckOut;

  /// Check if confirmed attendance section has any changes
  /// Includes time changes OR manual confirmation (even if same time value)
  bool get isConfirmedTimeChanged =>
      isCheckInChanged || isCheckOutChanged ||
      isCheckInManuallyConfirmed || isCheckOutManuallyConfirmed;

  /// Check if bonus amount has changed
  bool get isBonusChanged => bonusAmount != _initialBonusAmount;

  /// Check if memo has changed
  bool get isMemoChanged => _memoController.text != _initialMemo;

  /// Check if issue report status has changed from initial RPC value
  /// - If user selected a status (issueReportStatus != null), compare with initial
  /// - initial null + user approved → changed to true
  /// - initial null + user rejected → changed to false
  /// - initial true + user rejected → changed to false
  /// - initial false + user approved → changed to true
  bool get isReportStatusChanged {
    if (!widget.staffRecord.isReported) return false;
    if (issueReportStatus == null) return false;

    // Convert user selection to bool for comparison
    final userSelectedValue = issueReportStatus == 'approved';

    // If initial was null, any selection is a change
    if (_initialIsReportedSolved == null) return true;

    // Otherwise compare with initial value
    return userSelectedValue != _initialIsReportedSolved;
  }

  /// Overall change detection - true if any section has changes
  bool get hasChanges {
    return isConfirmedTimeChanged || isBonusChanged || isMemoChanged || isReportStatusChanged;
  }

  /// Check if the shift is still in progress (not yet ended)
  /// If shiftEndTime exists and current time is before it, shift hasn't ended yet
  bool get _isShiftStillInProgress {
    final shiftEndTime = widget.staffRecord.shiftEndTime;
    if (shiftEndTime == null) return false;
    return DateTime.now().isBefore(shiftEndTime);
  }

  bool get _isFullyConfirmed {
    // IMPORTANT: Check shift progress FIRST
    // If shift is still in progress (hasn't ended yet), don't require confirmation yet
    if (_isShiftStillInProgress) {
      return true;
    }

    // Use problemDetails for comprehensive problem checking
    final pd = widget.staffRecord.problemDetails;

    // If no problemDetails or no problems, check basic attendance
    if (pd == null || pd.problemCount == 0) {
      // No problems = fully confirmed
      return true;
    }

    // Check if ALL problems are solved using problemDetails.isFullySolved
    // This covers: late, overtime, early_leave, no_checkout, reported, etc.
    if (pd.isFullySolved) {
      return true;
    }

    // Has unsolved problems = needs confirmation
    return false;
  }

  // ============================================================================
  // Check-in/Check-out Specific Problem Helpers (for ConfirmedAttendanceCard)
  // ============================================================================

  /// Problem types related to check-in
  static const _checkInTypes = {'late', 'invalid_checkin'};

  /// Problem types related to check-out
  static const _checkOutTypes = {'overtime', 'early_leave', 'no_checkout', 'absence', 'location_issue'};

  /// Check-in related problems: late, invalid_checkin
  bool get _hasCheckInProblem {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) return widget.staffRecord.isLate;
    return pd.hasLate || pd.problems.any((p) => p.type == 'invalid_checkin');
  }

  /// Check-out related problems: overtime, early_leave, no_checkout, absence, location_issue
  bool get _hasCheckOutProblem {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) return widget.staffRecord.isOvertime;
    return pd.hasOvertime || pd.hasEarlyLeave || pd.hasNoCheckout || pd.hasAbsence || pd.hasLocationIssue;
  }

  /// Check if check-in problem is unsolved (for "Need confirm" red status)
  bool get _hasUnsolvedCheckInProblem {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) {
      return widget.staffRecord.isLate && !widget.staffRecord.isProblemSolved;
    }
    return pd.problems.any((p) => _checkInTypes.contains(p.type) && !p.isSolved);
  }

  /// Check if check-out problem is unsolved (for "Need confirm" red status)
  bool get _hasUnsolvedCheckOutProblem {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) {
      return widget.staffRecord.isOvertime && !widget.staffRecord.isProblemSolved;
    }
    return pd.problems.any((p) => _checkOutTypes.contains(p.type) && !p.isSolved);
  }

  /// Check if ALL check-in problems were solved by DB (for blue "Confirmed" status)
  bool get _isCheckInProblemSolved {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) return widget.staffRecord.isProblemSolved;
    final checkInProblems = pd.problems.where((p) => _checkInTypes.contains(p.type));
    if (checkInProblems.isEmpty) return false;
    return checkInProblems.every((p) => p.isSolved);
  }

  /// Check if ALL check-out problems were solved by DB (for blue "Confirmed" status)
  bool get _isCheckOutProblemSolved {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) return widget.staffRecord.isProblemSolved;
    final checkOutProblems = pd.problems.where((p) => _checkOutTypes.contains(p.type));
    if (checkOutProblems.isEmpty) return false;
    return checkOutProblems.every((p) => p.isSolved);
  }

  /// Check if there's an unsolved report (for "Report pending" status)
  /// Used when time problems are solved but report is still pending approval
  bool get _hasUnsolvedReport {
    final pd = widget.staffRecord.problemDetails;
    if (pd == null) {
      final isReportedSolved = widget.staffRecord.isReportedSolved;
      return widget.staffRecord.isReported && (isReportedSolved == null || !isReportedSolved);
    }
    return pd.problems.any((p) => p.type == 'reported' && !p.isSolved);
  }

  // ============================================================================
  // Salary Computed Properties
  // ============================================================================

  /// Get hourly rate as number for calculations
  double get _hourlyRate {
    final salaryAmountStr = widget.staffRecord.salaryAmount;
    if (salaryAmountStr == null || salaryAmountStr.isEmpty) return 0;
    final cleaned = salaryAmountStr.replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0;
  }

  /// Calculate paid hours from current confirmed times (for preview)
  /// Returns null if times are invalid, uses RPC paidHour as fallback
  double get _calculatedPaidHour {
    final calculated = TimelogHelpers.calculateHoursFromTimes(confirmedCheckIn, confirmedCheckOut);
    return calculated ?? widget.staffRecord.paidHour;
  }

  /// Check if confirmed time has changed from initial (for showing before/after)
  bool get _isTimeChangeForPreview => isCheckInChanged || isCheckOutChanged;

  /// Display total confirmed time - shows calculated if time changed, else original
  String get totalConfirmedTime {
    if (_isTimeChangeForPreview) {
      return TimelogHelpers.formatHoursMinutes(_calculatedPaidHour);
    }
    return TimelogHelpers.formatHoursMinutes(widget.staffRecord.paidHour);
  }

  /// Original total confirmed time (from RPC paidHour, for comparison)
  String get originalConfirmedTime => TimelogHelpers.formatHoursMinutes(widget.staffRecord.paidHour);

  String get hourlySalary {
    final salaryAmount = widget.staffRecord.salaryAmount;
    if (salaryAmount == null || salaryAmount.isEmpty) return '--';
    final amount = double.tryParse(salaryAmount);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$salaryAmount₫';
  }

  /// Display base pay - uses calculated hours if time changed
  String get basePay {
    if (_isTimeChangeForPreview) {
      final calc = (_calculatedPaidHour * _hourlyRate).toInt();
      return '${NumberFormat('#,###').format(calc)}₫';
    }
    // Original logic for unchanged times
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr == null || basePayStr.isEmpty) {
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

  /// Base pay amount for calculations - uses calculated hours if time changed
  int get basePayAmount {
    if (_isTimeChangeForPreview) {
      return (_calculatedPaidHour * _hourlyRate).toInt();
    }
    // Original logic
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      final cleanedStr = basePayStr.replaceAll(',', '');
      final amount = double.tryParse(cleanedStr);
      if (amount != null) return amount.toInt();
    }
    final salaryAmountStr = widget.staffRecord.salaryAmount;
    if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
      final cleanedSalary = salaryAmountStr.replaceAll(',', '');
      final salaryAmount = double.tryParse(cleanedSalary);
      if (salaryAmount != null) {
        return (widget.staffRecord.paidHour * salaryAmount).toInt();
      }
    }
    return 0;
  }

  /// Original base pay amount (from RPC, for comparison)
  int get _originalBasePayAmount {
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      final cleanedStr = basePayStr.replaceAll(',', '');
      final amount = double.tryParse(cleanedStr);
      if (amount != null) return amount.toInt();
    }
    return (widget.staffRecord.paidHour * _hourlyRate).toInt();
  }

  String get asOfDate => TimelogHelpers.formatAsOfDate(widget.shiftDate);
  String get bonusPay => '${NumberFormat('#,###').format(bonusAmount - penaltyAmount)}₫';
  String get penaltyDeduction => '${NumberFormat('#,###').format(penaltyAmount)}₫';
  String get totalPayment => '${NumberFormat('#,###').format(basePayAmount + bonusAmount - penaltyAmount)}₫';

  // ============================================================================
  // Original Values for Salary Breakdown Comparison
  // ============================================================================

  /// Original base pay (from RPC, for comparison)
  String get originalBasePay => '${NumberFormat('#,###').format(_originalBasePayAmount)}₫';

  /// Original bonus pay (from RPC, for comparison)
  String get originalBonusPay => '${NumberFormat('#,###').format(_initialBonusAmount - _initialPenaltyAmount)}₫';

  /// Original total payment (from RPC, for comparison)
  String get originalTotalPayment => '${NumberFormat('#,###').format(_originalBasePayAmount + _initialBonusAmount - _initialPenaltyAmount)}₫';

  /// Check if any salary-affecting value has changed
  bool get _hasSalaryChanges => _isTimeChangeForPreview || isBonusOrDeductChanged;

  /// Check if bonus/deduct has changed (for salary breakdown display)
  bool get isBonusOrDeductChanged => bonusAmount != _initialBonusAmount || penaltyAmount != _initialPenaltyAmount;

  // ============================================================================
  // Lifecycle
  // ============================================================================

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    // Recorded times
    recordedCheckIn = TimelogHelpers.extractTimeFromString(widget.staffRecord.actualStart) ?? '--:--:--';
    recordedCheckOut = TimelogHelpers.extractTimeFromString(widget.staffRecord.actualEnd) ?? '--:--:--';

    // Confirmed times
    confirmedCheckIn = TimelogHelpers.extractTimeFromString(widget.staffRecord.confirmStartTime) ?? recordedCheckIn;
    confirmedCheckOut = TimelogHelpers.extractTimeFromString(widget.staffRecord.confirmEndTime) ?? recordedCheckOut;

    // Bonus - 항상 RPC에서 받아온 값으로 초기화 (0 포함)
    bonusAmount = widget.staffRecord.bonusAmount.toInt();

    // Initialize controllers with formatted values (0이어도 표시)
    _bonusController.text = NumberFormat('#,###').format(bonusAmount);

    // Issue report status - v4: Use isReportedSolved from RPC
    if (widget.staffRecord.isReported) {
      _initialIsReportedSolved = widget.staffRecord.isReportedSolved;
      issueReportStatus = null;
    }

    // Memo - TODO: Initialize from staffRecord when memo field is added to RPC
    _initialMemo = '';
    _memoController.text = _initialMemo;

    // Store initial values for change detection
    _initialConfirmedCheckIn = confirmedCheckIn;
    _initialConfirmedCheckOut = confirmedCheckOut;
    _initialBonusAmount = bonusAmount;
    _initialPenaltyAmount = penaltyAmount;
  }

  @override
  void dispose() {
    _bonusController.dispose();
    _deductController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Time Picker Methods
  // ============================================================================

  Future<void> _showTimePickerForCheckIn() async {
    // Use recorded time as default (not confirmed time)
    final parsedRecordedTime = TimelogHelpers.parseTime(recordedCheckIn);
    final result = await TimePickerBottomSheet.show(
      context: context,
      title: 'Confirmed Check In',
      recordedTimeLabel: 'Recorded check in',
      recordedTime: recordedCheckIn,
      initialTime: parsedRecordedTime['time'] as TimeOfDay,
      initialSeconds: parsedRecordedTime['seconds'] as int,
    );

    if (result != null) {
      setState(() {
        final time = result['time'] as TimeOfDay;
        final seconds = result['seconds'] as int;
        confirmedCheckIn = time.toFormattedString(seconds: seconds);
        isCheckInManuallyConfirmed = true;
      });
    }
  }

  Future<void> _showTimePickerForCheckOut() async {
    // Use recorded time as default (not confirmed time)
    final parsedRecordedTime = TimelogHelpers.parseTime(recordedCheckOut);
    final result = await TimePickerBottomSheet.show(
      context: context,
      title: 'Confirmed Check Out',
      recordedTimeLabel: 'Recorded check out',
      recordedTime: recordedCheckOut,
      initialTime: parsedRecordedTime['time'] as TimeOfDay,
      initialSeconds: parsedRecordedTime['seconds'] as int,
    );

    if (result != null) {
      setState(() {
        final time = result['time'] as TimeOfDay;
        final seconds = result['seconds'] as int;
        confirmedCheckOut = time.toFormattedString(seconds: seconds);
        isCheckOutManuallyConfirmed = true;
      });
    }
  }

  // ============================================================================
  // Bonus/Penalty Callbacks
  // ============================================================================

  void _onBonusChanged(int amount) {
    setState(() => bonusAmount = amount);
  }

  void _onDeductChanged(int amount) {
    setState(() => penaltyAmount = amount);
  }

  // ============================================================================
  // Save Action
  // ============================================================================

  Future<void> _saveAndConfirmShift() async {
    final shiftRequestId = widget.staffRecord.shiftRequestId;
    if (shiftRequestId == null || shiftRequestId.isEmpty) {
      _showError('Error: Missing shift request ID');
      return;
    }

    final appState = ref.read(appStateProvider);
    final managerId = appState.user['user_id'] as String?;
    if (managerId == null || managerId.isEmpty) {
      _showError('Error: Manager ID not found');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final inputCardV5UseCase = ref.read(inputCardV5UseCaseProvider);
      final timezone = DateTimeUtils.getLocalTimezone();

      // v5: isProblemSolved (for Late/Overtime/EarlyLeave time confirmation)
      // When manager clicks "Save & confirm shift", mark problem as solved if:
      // 1. Confirm time has been changed (manual edit)
      // 2. OR there's an existing problem that hasn't been solved yet
      //    (Late, Overtime, EarlyLeave, NoCheckout, etc.)
      // This allows manager to "confirm" auto-calculated times without editing them
      // isProblemSolved: ONLY set when manager explicitly confirms time
      // - Time change (edit check-in/check-out time)
      // - Manual confirmation (click edit button even without changing value)
      // DO NOT auto-solve problems just because manager clicked save with memo only!
      bool? isProblemSolved;

      if (isConfirmedTimeChanged) {
        // Confirm time이 변경되거나 매니저가 수동으로 확인한 경우에만 문제 해결
        isProblemSolved = true;
      }
      // REMOVED: Auto-solving problems when saving without time confirmation
      // This was causing problems to be marked as solved when only adding memo

      // v6: ONLY send values that have ACTUALLY CHANGED
      // null = don't update this field in DB

      // managerMemo: only send if user typed something new
      final String? managerMemo =
          _memoController.text.isNotEmpty ? _memoController.text : null;

      // confirmStartTime: only send if CHANGED from initial value
      String? confirmStartTime;
      if (isCheckInChanged && confirmedCheckIn != '--:--:--') {
        confirmStartTime = confirmedCheckIn;
      }

      // confirmEndTime: only send if CHANGED from initial value
      String? confirmEndTime;
      if (isCheckOutChanged && confirmedCheckOut != '--:--:--') {
        confirmEndTime = confirmedCheckOut;
      }

      // bonusAmount: only send if CHANGED from initial value
      // Net bonus amount = Add bonus - Deduct (can be negative)
      final netBonusAmount = bonusAmount - penaltyAmount;
      final double? bonusToSend = isBonusOrDeductChanged ? netBonusAmount.toDouble() : null;

      // isReportedSolved: only send if user made a selection AND it differs from initial
      bool? isReportedSolvedToSend;
      if (isReportStatusChanged) {
        isReportedSolvedToSend = issueReportStatus == 'approved';
      }

      final params = InputCardV5Params(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        isProblemSolved: isProblemSolved,
        isReportedSolved: isReportedSolvedToSend,
        bonusAmount: bonusToSend,
        managerMemo: managerMemo,
        timezone: timezone,
      );

      await inputCardV5UseCase.call(params);

      if (mounted) {
        // v7: Capture calculated values BEFORE updating initial values
        // Otherwise _isTimeChangeForPreview will be false after setState
        final paidHourForCache = _isTimeChangeForPreview ? _calculatedPaidHour : null;

        setState(() {
          // Update initial values after successful save
          _initialConfirmedCheckIn = confirmedCheckIn;
          _initialConfirmedCheckOut = confirmedCheckOut;
          _initialBonusAmount = bonusAmount;
          _initialPenaltyAmount = penaltyAmount;
          _initialMemo = _memoController.text;
          if (issueReportStatus != null) {
            // Convert user selection to bool for storage
            _initialIsReportedSolved = issueReportStatus == 'approved';
          }
        });
        // Return save result for Partial Update
        // This allows the caller to update cached data without full refresh
        Navigator.pop(context, {
          'success': true,
          'shiftRequestId': shiftRequestId,
          'shiftDate': widget.shiftDate,
          'isProblemSolved': isProblemSolved,
          'isReportedSolved': isReportedSolvedToSend,
          'confirmedStartTime': confirmStartTime,
          'confirmedEndTime': confirmEndTime,
          'bonusAmount': bonusToSend,
          'managerMemo': managerMemo,
          // v7: Use pre-captured value for cache update
          'calculatedPaidHour': paidHourForCache,
        });
      }
    } on ArgumentError catch (e) {
      if (mounted) _showError('Error: ${e.message}');
    } catch (e) {
      if (mounted) _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: TossColors.error),
    );
  }

  // ============================================================================
  // Build
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Shift info, issue report, recorded/confirmed attendance
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShiftInfoCard(
                          shiftDate: widget.shiftDate,
                          shiftName: widget.shiftName,
                          shiftTimeRange: widget.shiftTimeRange,
                          isLate: widget.staffRecord.isLate,
                          isOvertime: widget.staffRecord.isOvertime,
                          // v5: Pass problemDetails for displaying badges with minutes
                          problemDetails: widget.staffRecord.problemDetails,
                        ),
                        // Issue report card with integrated memo (if employee reported an issue)
                        if (employeeIssueReport != null && employeeIssueReport!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          IssueReportCard(
                            employeeName: widget.staffRecord.staffName,
                            employeeAvatarUrl: widget.staffRecord.avatarUrl,
                            issueReport: employeeIssueReport!,
                            isReportedSolved: widget.staffRecord.isReportedSolved,
                            issueReportStatus: issueReportStatus,
                            onApprove: () => setState(() => issueReportStatus = 'approved'),
                            onReject: () => setState(() => issueReportStatus = 'rejected'),
                            // v6: Integrated memo fields
                            memoController: _memoController,
                            onMemoChanged: (_) => setState(() {}),
                            existingMemos: widget.staffRecord.managerMemos,
                          ),
                        ],
                        // Standalone memo card (only if NO report exists)
                        if (employeeIssueReport == null || employeeIssueReport!.isEmpty) ...[
                          const SizedBox(height: 16),
                          ManageMemoCard(
                            memoController: _memoController,
                            onChanged: (_) => setState(() {}),
                            existingMemos: widget.staffRecord.managerMemos,
                          ),
                        ],
                        const SizedBox(height: 16),
                        RecordedAttendanceCard(
                          isExpanded: _recordedAttendanceExpanded,
                          onToggle: () => setState(() => _recordedAttendanceExpanded = !_recordedAttendanceExpanded),
                          recordedCheckIn: recordedCheckIn,
                          recordedCheckOut: recordedCheckOut,
                        ),
                        const SizedBox(height: 16),
                        ConfirmedAttendanceCard(
                          isExpanded: _confirmedAttendanceExpanded,
                          onToggle: () => setState(() => _confirmedAttendanceExpanded = !_confirmedAttendanceExpanded),
                          isFullyConfirmed: _isFullyConfirmed,
                          confirmedCheckIn: confirmedCheckIn,
                          confirmedCheckOut: confirmedCheckOut,
                          // Use problemDetails for comprehensive problem checking
                          // checkInNeedsConfirm: late problem unsolved
                          checkInNeedsConfirm: !_isShiftStillInProgress &&
                              _hasUnsolvedCheckInProblem &&
                              !isCheckInManuallyConfirmed,
                          // checkOutNeedsConfirm: overtime/early_leave/no_checkout problem unsolved
                          checkOutNeedsConfirm: !_isShiftStillInProgress &&
                              _hasUnsolvedCheckOutProblem &&
                              !isCheckOutManuallyConfirmed,
                          // Blue text: problem exists AND confirmed (solved OR manually confirmed)
                          isCheckInConfirmed: _hasCheckInProblem &&
                              (_isCheckInProblemSolved || isCheckInManuallyConfirmed),
                          isCheckOutConfirmed: _hasCheckOutProblem &&
                              (_isCheckOutProblemSolved || isCheckOutManuallyConfirmed),
                          onEditCheckIn: _showTimePickerForCheckIn,
                          onEditCheckOut: _showTimePickerForCheckOut,
                          // Hide status badge when shift is still in progress
                          isShiftInProgress: _isShiftStillInProgress,
                          // Show "Report pending" when time confirmed but report unsolved
                          hasUnsolvedReport: _hasUnsolvedReport,
                        ),
                      ],
                    ),
                  ),

                  // Full-width gray divider before Adjustment section
                  const GrayDividerSpace(),

                  // Section 2: Adjustment section (bonus and deduct)
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: AdjustmentSection(
                      bonusController: _bonusController,
                      deductController: _deductController,
                      onBonusChanged: _onBonusChanged,
                      onDeductChanged: _onDeductChanged,
                    ),
                  ),

                  // Full-width gray divider before Salary breakdown
                  const GrayDividerSpace(),

                  // Section 2: Salary breakdown with before/after comparison
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: SalaryBreakdownCard(
                      asOfDate: asOfDate,
                      totalConfirmedTime: totalConfirmedTime,
                      hourlySalary: hourlySalary,
                      basePay: basePay,
                      bonusPay: bonusPay,
                      totalPayment: totalPayment,
                      // Pass original values when time or bonus changed (null = no change shown)
                      originalConfirmedTime: _isTimeChangeForPreview ? originalConfirmedTime : null,
                      originalBasePay: _isTimeChangeForPreview ? originalBasePay : null,
                      originalBonusPay: isBonusOrDeductChanged ? originalBonusPay : null,
                      originalTotalPayment: _hasSalaryChanges ? originalTotalPayment : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      surfaceTintColor: TossColors.white,
      title: Text(
        'Shift Details Management',
        style: TossTextStyles.titleMedium.copyWith(color: TossColors.gray900),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: TossColors.gray900),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  /// 리포트 확인이 필요한지 체크
  /// is_reported = true AND is_reported_solved = null 일 때
  bool get _needsReportCheck {
    return widget.staffRecord.isReported &&
           widget.staffRecord.isReportedSolved == null;
  }

  /// 시간 확인이 필요한지 체크 (Need confirm 상태)
  /// _isFullyConfirmed가 false일 때
  bool get _needsTimeConfirm => !_isFullyConfirmed;

  /// 버튼 문구 결정
  /// 1. 리포트 확인 필요 + 시간 확인 필요 → "Check Two Problems"
  /// 2. 리포트 확인 필요만 → "Check Report"
  /// 3. 시간 확인 필요만 → "Check Confirm Time"
  /// 4. 둘 다 아님 → "Save & confirm shift"
  String get _buttonText {
    final needsReport = _needsReportCheck;
    final needsTime = _needsTimeConfirm;

    if (needsReport && needsTime) {
      return 'Check Two Problems';
    } else if (needsReport) {
      return 'Check Report';
    } else if (needsTime) {
      return 'Check Confirm Time';
    } else {
      return 'Save & confirm shift';
    }
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space4, TossSpacing.space4, 48),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(top: BorderSide(color: TossColors.gray100, width: 1)),
      ),
      child: TossButton.primary(
        text: _buttonText,
        fullWidth: true,
        isLoading: _isSaving,
        isEnabled: hasChanges && !_isSaving,
        onPressed: _saveAndConfirmShift,
      ),
    );
  }
}
