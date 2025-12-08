import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_expandable_card.dart';

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

  // Controllers for bonus and memo text fields
  final TextEditingController _bonusController = TextEditingController();
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
  bool get isConfirmedTimeChanged => isCheckInChanged || isCheckOutChanged;

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
    final hasCheckIn = confirmedCheckIn != '--:--:--';
    final hasCheckOut = confirmedCheckOut != '--:--:--';

    debugPrint('[DEBUG] _isFullyConfirmed: hasCheckIn=$hasCheckIn, hasCheckOut=$hasCheckOut');
    debugPrint('[DEBUG] confirmedCheckIn=$confirmedCheckIn, confirmedCheckOut=$confirmedCheckOut');
    debugPrint('[DEBUG] shiftEndTime=${widget.staffRecord.shiftEndTime}');
    debugPrint('[DEBUG] _isShiftStillInProgress=$_isShiftStillInProgress');

    // IMPORTANT: Check shift progress FIRST, before checking hasCheckIn/hasCheckOut
    // If shift is still in progress (hasn't ended yet), don't require confirmation yet
    // Treat as "confirmed" for now (no need to show "Need confirm")
    if (_isShiftStillInProgress) {
      debugPrint('[DEBUG] Shift still in progress - returning true (no need confirm)');
      return true;
    }

    // Shift has ended - now check if we have both check-in and check-out
    if (!hasCheckIn || !hasCheckOut) return false;

    // Shift has ended - now check late/overtime status for confirmation requirements
    bool checkInConfirmed = !widget.staffRecord.isLate || isCheckInManuallyConfirmed;
    bool checkOutConfirmed = !widget.staffRecord.isOvertime || isCheckOutManuallyConfirmed;
    return checkInConfirmed && checkOutConfirmed;
  }

  // Salary computed properties
  String get totalConfirmedTime => TimelogHelpers.formatHoursMinutes(widget.staffRecord.paidHour);

  String get hourlySalary {
    final salaryAmount = widget.staffRecord.salaryAmount;
    if (salaryAmount == null || salaryAmount.isEmpty) return '--';
    final amount = double.tryParse(salaryAmount);
    if (amount != null) {
      return '${NumberFormat('#,###').format(amount.toInt())}₫';
    }
    return '$salaryAmount₫';
  }

  String get basePay {
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

  int get basePayAmount {
    final basePayStr = widget.staffRecord.basePay;
    if (basePayStr != null && basePayStr.isNotEmpty) {
      // Remove commas before parsing (RPC returns formatted string like "150,000")
      final cleanedStr = basePayStr.replaceAll(',', '');
      final amount = double.tryParse(cleanedStr);
      if (amount != null) return amount.toInt();
    }
    final salaryAmountStr = widget.staffRecord.salaryAmount;
    if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
      // Remove commas before parsing
      final cleanedSalary = salaryAmountStr.replaceAll(',', '');
      final salaryAmount = double.tryParse(cleanedSalary);
      if (salaryAmount != null) {
        return (widget.staffRecord.paidHour * salaryAmount).toInt();
      }
    }
    return 0;
  }

  String get asOfDate => TimelogHelpers.formatAsOfDate(widget.shiftDate);
  String get bonusPay => '${NumberFormat('#,###').format(bonusAmount)}₫';
  String get totalPayment => '${NumberFormat('#,###').format(basePayAmount + bonusAmount)}₫';

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
  }

  @override
  void dispose() {
    _bonusController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Time Picker Methods
  // ============================================================================

  Future<void> _showTimePickerForCheckIn() async {
    final parsedTime = TimelogHelpers.parseTime(confirmedCheckIn);
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
        isCheckInManuallyConfirmed = true;
      });
    }
  }

  Future<void> _showTimePickerForCheckOut() async {
    final parsedTime = TimelogHelpers.parseTime(confirmedCheckOut);
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

      // v5: isReportedSolved
      // - confirm time이 변경되면 → true (문제 해결됨으로 처리)
      // - Approve 클릭 → true
      // - Reject 클릭 → false
      // - 아무것도 안 바꿨으면 → 기존 값 전송
      bool? isReportedSolved;
      if (isConfirmedTimeChanged) {
        // Confirm time이 변경되면 문제 해결됨으로 처리
        isReportedSolved = true;
      } else if (widget.staffRecord.isReported) {
        if (issueReportStatus == 'approved') {
          isReportedSolved = true;
        } else if (issueReportStatus == 'rejected') {
          isReportedSolved = false;
        } else {
          // 유저가 아무 버튼도 안 눌렀으면 기존 값 전송
          isReportedSolved = _initialIsReportedSolved;
        }
      }

      // v5: managerMemo
      // - 텍스트박스는 항상 빈 상태로 시작 (_initialMemo = '')
      // - 기존 메모는 별도 UI에 표시 (ManageMemoCard에서 읽기 전용)
      // - 텍스트박스에 값이 있으면 → 새 메모 전송
      // - 텍스트박스가 비어있으면 → null 전송 (새 메모 없음)
      final String? managerMemo =
          _memoController.text.isNotEmpty ? _memoController.text : null;

      // v5: confirmStartTime / confirmEndTime
      // - 변경됐으면 → 변경된 값 전송
      // - 변경 안 됐으면 → 기존 default 값 전송
      // - '--:--:--'이면 → null 전송 (아직 설정 안 됨)
      String? confirmStartTime;
      if (confirmedCheckIn != '--:--:--') {
        confirmStartTime = confirmedCheckIn;
      } else {
        confirmStartTime = null;
      }

      String? confirmEndTime;
      if (confirmedCheckOut != '--:--:--') {
        confirmEndTime = confirmedCheckOut;
      } else {
        confirmEndTime = null;
      }

      final params = InputCardV5Params(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmStartTime,
        confirmEndTime: confirmEndTime,
        isReportedSolved: isReportedSolved,
        bonusAmount: bonusAmount.toDouble(),
        managerMemo: managerMemo,
        timezone: timezone,
      );

      await inputCardV5UseCase.call(params);

      if (mounted) {
        setState(() {
          // Update initial values after successful save
          _initialConfirmedCheckIn = confirmedCheckIn;
          _initialConfirmedCheckOut = confirmedCheckOut;
          _initialBonusAmount = bonusAmount;
          _initialMemo = _memoController.text;
          if (issueReportStatus != null) {
            // Convert user selection to bool for storage
            _initialIsReportedSolved = issueReportStatus == 'approved';
          }
        });
        Navigator.pop(context, true);
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShiftInfoCard(
                          shiftDate: widget.shiftDate,
                          shiftName: widget.shiftName,
                          shiftTimeRange: widget.shiftTimeRange,
                          isLate: widget.staffRecord.isLate,
                          isOvertime: widget.staffRecord.isOvertime,
                        ),
                        // Issue report card (if employee reported an issue) - positioned after shift info
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
                            onResetSelection: () => setState(() => issueReportStatus = null),
                          ),
                        ],
                        // Manage memo card - positioned between report and recorded attendance
                        const SizedBox(height: 16),
                        ManageMemoCard(
                          memoController: _memoController,
                          onChanged: (_) => setState(() {}),
                          // v4: Pass existing memos from RPC (read-only display)
                          existingMemos: widget.staffRecord.managerMemos,
                        ),
                        const SizedBox(height: 16),
                        _buildRecordedAttendanceCard(),
                        const SizedBox(height: 16),
                        ConfirmedAttendanceCard(
                          isExpanded: _confirmedAttendanceExpanded,
                          onToggle: () => setState(() => _confirmedAttendanceExpanded = !_confirmedAttendanceExpanded),
                          isFullyConfirmed: _isFullyConfirmed,
                          confirmedCheckIn: confirmedCheckIn,
                          confirmedCheckOut: confirmedCheckOut,
                          // Don't show "needs confirm" if shift is still in progress
                          checkInNeedsConfirm: !_isShiftStillInProgress && widget.staffRecord.isLate && !isCheckInManuallyConfirmed,
                          checkOutNeedsConfirm: !_isShiftStillInProgress && widget.staffRecord.isOvertime && !isCheckOutManuallyConfirmed,
                          isCheckInConfirmed: isCheckInManuallyConfirmed,
                          isCheckOutConfirmed: isCheckOutManuallyConfirmed,
                          onEditCheckIn: _showTimePickerForCheckIn,
                          onEditCheckOut: _showTimePickerForCheckOut,
                          // Hide status badge when shift is still in progress
                          isShiftInProgress: _isShiftStillInProgress,
                        ),
                      ],
                    ),
                  ),

                  // Full-width gray divider before Adjustment section
                  const GrayDividerSpace(),

                  // Section 2: Adjustment section (bonus only)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: AdjustmentSection(
                      bonusController: _bonusController,
                      onBonusChanged: _onBonusChanged,
                    ),
                  ),

                  // Full-width gray divider before Salary breakdown
                  const GrayDividerSpace(),

                  // Section 2: Salary breakdown
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SalaryBreakdownCard(
                      asOfDate: asOfDate,
                      totalConfirmedTime: totalConfirmedTime,
                      hourlySalary: hourlySalary,
                      basePay: basePay,
                      bonusPay: bonusPay,
                      totalPayment: totalPayment,
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

  Widget _buildRecordedAttendanceCard() {
    return TossExpandableCard(
      title: 'Recorded attendance',
      isExpanded: _recordedAttendanceExpanded,
      onToggle: () => setState(() => _recordedAttendanceExpanded = !_recordedAttendanceExpanded),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(label: 'Recorded check-in', value: recordedCheckIn),
          const SizedBox(height: 12),
          _buildInfoRow(label: 'Recorded check-out', value: recordedCheckOut),
          const SizedBox(height: 12),
          Text(
            'Based on check-in/out device logs.',
            style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray600)),
        Text(value, style: TossTextStyles.bodyLarge.copyWith(color: TossColors.gray900, fontWeight: FontWeight.w600)),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(top: BorderSide(color: TossColors.gray100, width: 1)),
      ),
      child: TossButton1.primary(
        text: _buttonText,
        fullWidth: true,
        isLoading: _isSaving,
        isEnabled: hasChanges && !_isSaving,
        onPressed: _saveAndConfirmShift,
      ),
    );
  }
}
