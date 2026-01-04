import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/usecases/input_card_v5.dart';
import '../providers/usecase/time_table_usecase_providers.dart';
import '../widgets/timesheets/staff_timelog_card.dart';
import '../widgets/timesheets/time_picker_bottom_sheet.dart';
import 'staff_timelog_detail/utils/problem_helpers.dart';
import 'staff_timelog_detail/utils/salary_calculator.dart';
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
  // Computed Properties (using extracted helpers)
  // ============================================================================

  /// Salary calculator instance - created lazily
  SalaryCalculator get _salary => SalaryCalculator(
        staffRecord: widget.staffRecord,
        confirmedCheckIn: confirmedCheckIn,
        confirmedCheckOut: confirmedCheckOut,
        bonusAmount: bonusAmount,
        penaltyAmount: penaltyAmount,
        initialConfirmedCheckIn: _initialConfirmedCheckIn,
        initialConfirmedCheckOut: _initialConfirmedCheckOut,
        initialBonusAmount: _initialBonusAmount,
        initialPenaltyAmount: _initialPenaltyAmount,
      );

  // ============================================================================
  // Change Detection
  // ============================================================================

  bool get isCheckInChanged => confirmedCheckIn != _initialConfirmedCheckIn;
  bool get isCheckOutChanged => confirmedCheckOut != _initialConfirmedCheckOut;

  bool get isConfirmedTimeChanged =>
      isCheckInChanged ||
      isCheckOutChanged ||
      isCheckInManuallyConfirmed ||
      isCheckOutManuallyConfirmed;

  bool get isBonusChanged => bonusAmount != _initialBonusAmount;
  bool get isMemoChanged => _memoController.text != _initialMemo;

  bool get isReportStatusChanged {
    if (!widget.staffRecord.isReported) return false;
    if (issueReportStatus == null) return false;
    final userSelectedValue = issueReportStatus == 'approved';
    if (_initialIsReportedSolved == null) return true;
    return userSelectedValue != _initialIsReportedSolved;
  }

  bool get hasChanges =>
      isConfirmedTimeChanged || isBonusChanged || isMemoChanged || isReportStatusChanged;

  // ============================================================================
  // Salary Computed Properties (delegated to SalaryCalculator)
  // ============================================================================

  String get totalConfirmedTime => _salary.totalConfirmedTime;
  String get originalConfirmedTime => _salary.originalConfirmedTime;
  String get hourlySalary => _salary.hourlySalary;
  String get basePay => _salary.basePay;
  int get basePayAmount => _salary.basePayAmount;
  String get asOfDate => _salary.asOfDate(widget.shiftDate);
  String get bonusPay => _salary.bonusPay;
  String get totalPayment => _salary.totalPayment;
  String get originalBasePay => _salary.originalBasePay;
  String get originalBonusPay => _salary.originalBonusPay;
  String get originalTotalPayment => _salary.originalTotalPayment;
  bool get isBonusOrDeductChanged => _salary.isBonusOrDeductChanged;

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
        // Otherwise isTimeChanged will be false after setState
        final paidHourForCache = _salary.isTimeChanged ? _salary.calculatedPaidHour : null;

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
    TossToast.error(context, message);
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
                          isFullyConfirmed: widget.staffRecord.isFullyConfirmed,
                          confirmedCheckIn: confirmedCheckIn,
                          confirmedCheckOut: confirmedCheckOut,
                          // checkInNeedsConfirm: late problem unsolved
                          checkInNeedsConfirm: !widget.staffRecord.isShiftStillInProgress &&
                              widget.staffRecord.hasUnsolvedCheckInProblem &&
                              !isCheckInManuallyConfirmed,
                          // checkOutNeedsConfirm: overtime/early_leave/no_checkout problem unsolved
                          checkOutNeedsConfirm: !widget.staffRecord.isShiftStillInProgress &&
                              widget.staffRecord.hasUnsolvedCheckOutProblem &&
                              !isCheckOutManuallyConfirmed,
                          // Blue text: problem exists AND confirmed (solved OR manually confirmed)
                          isCheckInConfirmed: widget.staffRecord.hasCheckInProblem &&
                              (widget.staffRecord.isCheckInProblemSolved || isCheckInManuallyConfirmed),
                          isCheckOutConfirmed: widget.staffRecord.hasCheckOutProblem &&
                              (widget.staffRecord.isCheckOutProblemSolved || isCheckOutManuallyConfirmed),
                          onEditCheckIn: _showTimePickerForCheckIn,
                          onEditCheckOut: _showTimePickerForCheckOut,
                          // Hide status badge when shift is still in progress
                          isShiftInProgress: widget.staffRecord.isShiftStillInProgress,
                          // Show "Report pending" when time confirmed but report unsolved
                          hasUnsolvedReport: widget.staffRecord.hasUnsolvedReport,
                        ),
                        // Shift Logs Section - shows audit history
                        const SizedBox(height: 16),
                        ShiftLogsSection(
                          shiftRequestId: widget.staffRecord.shiftRequestId,
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
                      originalConfirmedTime: _salary.isTimeChanged ? originalConfirmedTime : null,
                      originalBasePay: _salary.isTimeChanged ? originalBasePay : null,
                      originalBonusPay: isBonusOrDeductChanged ? originalBonusPay : null,
                      originalTotalPayment: _salary.hasSalaryChanges ? originalTotalPayment : null,
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
    return TossAppBar(
      title: 'Shift Details Management',
      backgroundColor: TossColors.white,
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
  bool get _needsTimeConfirm => !widget.staffRecord.isFullyConfirmed;

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
