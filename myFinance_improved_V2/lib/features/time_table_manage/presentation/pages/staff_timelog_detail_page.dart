import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_button_1.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_expandable_card.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/usecases/input_card_v4.dart';
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
  late String? _initialIssueReportStatus;

  // Issue report from RPC
  String? get employeeIssueReport => widget.staffRecord.isReported ? widget.staffRecord.reportReason : null;

  // Bonus amount initialized from RPC
  late int bonusAmount;

  // Issue report approval state
  String? issueReportStatus;
  bool _showBothIssueButtons = false;

  // Controllers
  final TextEditingController _bonusController = TextEditingController();

  // ============================================================================
  // Computed Properties
  // ============================================================================

  bool get _areConfirmTimesValid {
    final checkInValid = confirmedCheckIn != '--:--:--' && confirmedCheckIn.isNotEmpty;
    final checkOutValid = confirmedCheckOut != '--:--:--' && confirmedCheckOut.isNotEmpty;
    return checkInValid && checkOutValid;
  }

  bool get hasChanges {
    final checkInChanged = confirmedCheckIn != _initialConfirmedCheckIn;
    final checkOutChanged = confirmedCheckOut != _initialConfirmedCheckOut;
    final bonusChanged = bonusAmount != _initialBonusAmount;
    final hasIssueReport = widget.staffRecord.isReported;
    final issueStatusChanged = hasIssueReport &&
        issueReportStatus != null &&
        issueReportStatus != _initialIssueReportStatus;

    final hasAnyChange = checkInChanged || checkOutChanged || bonusChanged || issueStatusChanged;
    final timesChanged = checkInChanged || checkOutChanged;

    if (timesChanged) {
      return hasAnyChange && _areConfirmTimesValid;
    }
    return hasAnyChange;
  }

  bool get _isFullyConfirmed {
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
      final amount = double.tryParse(basePayStr);
      if (amount != null) return amount.toInt();
    }
    final salaryAmountStr = widget.staffRecord.salaryAmount;
    if (salaryAmountStr != null && salaryAmountStr.isNotEmpty) {
      final salaryAmount = double.tryParse(salaryAmountStr);
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

    // Bonus
    bonusAmount = widget.staffRecord.bonusAmount.toInt();
    if (bonusAmount > 0) {
      _bonusController.text = NumberFormat('#,###').format(bonusAmount);
    }

    // Issue report status
    if (widget.staffRecord.isReported) {
      _initialIssueReportStatus = widget.staffRecord.isProblemSolved ? 'approved' : 'rejected';
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
      final inputCardV4UseCase = ref.read(inputCardV4UseCaseProvider);
      final timezone = DateTimeUtils.getLocalTimezone();

      bool? isProblemSolved;
      if (widget.staffRecord.isReported && issueReportStatus != null) {
        isProblemSolved = issueReportStatus == 'approved';
      }

      final params = InputCardV4Params(
        managerId: managerId,
        shiftRequestId: shiftRequestId,
        confirmStartTime: confirmedCheckIn != '--:--:--' ? confirmedCheckIn : null,
        confirmEndTime: confirmedCheckOut != '--:--:--' ? confirmedCheckOut : null,
        isProblemSolved: isProblemSolved,
        bonusAmount: bonusAmount.toDouble(),
        timezone: timezone,
      );

      await inputCardV4UseCase.call(params);

      if (mounted) {
        setState(() {
          _initialConfirmedCheckIn = confirmedCheckIn;
          _initialConfirmedCheckOut = confirmedCheckOut;
          _initialBonusAmount = bonusAmount;
          if (issueReportStatus != null) {
            _initialIssueReportStatus = issueReportStatus;
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
                  const SizedBox(height: 16),
                  _buildRecordedAttendanceCard(),
                  const SizedBox(height: 16),
                  ConfirmedAttendanceCard(
                    isExpanded: _confirmedAttendanceExpanded,
                    onToggle: () => setState(() => _confirmedAttendanceExpanded = !_confirmedAttendanceExpanded),
                    isFullyConfirmed: _isFullyConfirmed,
                    confirmedCheckIn: confirmedCheckIn,
                    confirmedCheckOut: confirmedCheckOut,
                    checkInNeedsConfirm: widget.staffRecord.isLate && !isCheckInManuallyConfirmed,
                    checkOutNeedsConfirm: widget.staffRecord.isOvertime && !isCheckOutManuallyConfirmed,
                    isCheckInConfirmed: isCheckInManuallyConfirmed,
                    isCheckOutConfirmed: isCheckOutManuallyConfirmed,
                    onEditCheckIn: _showTimePickerForCheckIn,
                    onEditCheckOut: _showTimePickerForCheckOut,
                  ),
                  const SizedBox(height: 16),
                  if (employeeIssueReport != null) ...[
                    IssueReportCard(
                      issueReport: employeeIssueReport!,
                      isProblemSolved: widget.staffRecord.isProblemSolved,
                      showBothButtons: _showBothIssueButtons,
                      issueReportStatus: issueReportStatus,
                      onExpandButtons: () => setState(() => _showBothIssueButtons = true),
                      onApprove: () => setState(() => issueReportStatus = 'approved'),
                      onReject: () => setState(() => issueReportStatus = 'rejected'),
                      onResetSelection: () => setState(() {
                        issueReportStatus = null;
                        _showBothIssueButtons = true;
                      }),
                    ),
                    const SizedBox(height: 16),
                  ],
                  BonusSection(
                    controller: _bonusController,
                    onBonusChanged: (amount) => setState(() => bonusAmount = amount),
                  ),
                  const SizedBox(height: 16),
                  SalaryBreakdownCard(
                    asOfDate: asOfDate,
                    totalConfirmedTime: totalConfirmedTime,
                    hourlySalary: hourlySalary,
                    basePay: basePay,
                    bonusPay: bonusPay,
                    totalPayment: totalPayment,
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

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(top: BorderSide(color: TossColors.gray100, width: 1)),
      ),
      child: TossButton1.primary(
        text: 'Save & confirm shift',
        fullWidth: true,
        isLoading: _isSaving,
        isEnabled: hasChanges && !_isSaving,
        onPressed: _saveAndConfirmShift,
      ),
    );
  }
}
