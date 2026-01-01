import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:myfinance_improved/features/attendance/domain/entities/shift_card.dart';
import 'package:myfinance_improved/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../widgets/shift_detail/shift_info_card.dart';
import '../widgets/shift_detail/payment_summary_card.dart';
import '../widgets/shift_detail/activity_log_section.dart';
import '../widgets/shift_detail/report_response_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shift Detail Page - Shows detailed information about a specific shift
class ShiftDetailPage extends ConsumerStatefulWidget {
  final ShiftCard shift;

  const ShiftDetailPage({
    super.key,
    required this.shift,
  });

  @override
  ConsumerState<ShiftDetailPage> createState() => _ShiftDetailPageState();
}

class _ShiftDetailPageState extends ConsumerState<ShiftDetailPage> {
  bool _recordedAttendanceExpanded = false;
  bool _confirmedAttendanceExpanded = false;
  bool _reportAndResponseExpanded = true;
  bool _isSubmittingReport = false;

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

  String? _getConfirmedStartTime() {
    // RPC에서 이미 로컬 타임존으로 변환된 "HH:MM" 형식으로 반환
    return widget.shift.confirmStartTime;
  }

  String? _getConfirmedEndTime() {
    // RPC에서 이미 로컬 타임존으로 변환된 "HH:MM" 형식으로 반환
    return widget.shift.confirmEndTime;
  }

  TextStyle? _getCheckInTimeColor() {
    final isConfirmedByManager = widget.shift.confirmStartTime != null;
    if (widget.shift.isLate && !isConfirmedByManager) {
      return TossTextStyles.bodyLarge.copyWith(
        color: TossColors.error,
        fontWeight: FontWeight.w600,
      );
    } else if (isConfirmedByManager) {
      return TossTextStyles.bodyLarge.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    }
    return null;
  }

  TextStyle? _getCheckOutTimeColor() {
    final isConfirmedByManager = widget.shift.confirmEndTime != null;
    if (widget.shift.isExtratime && !isConfirmedByManager) {
      return TossTextStyles.bodyLarge.copyWith(
        color: TossColors.error,
        fontWeight: FontWeight.w600,
      );
    } else if (isConfirmedByManager) {
      return TossTextStyles.bodyLarge.copyWith(
        color: TossColors.primary,
        fontWeight: FontWeight.w600,
      );
    }
    return null;
  }

  Future<void> _submitReport(String reason) async {
    if (_isSubmittingReport) return;

    setState(() {
      _isSubmittingReport = true;
    });

    try {
      final now = DateTime.now();
      final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      final timezone = DateTimeUtils.getLocalTimezone();

      final reportShiftIssue = ref.read(reportShiftIssueProvider);
      final result = await reportShiftIssue(
        shiftRequestId: widget.shift.shiftRequestId,
        reportReason: reason,
        time: time,
        timezone: timezone,
      );

      if (!mounted) return;

      // Either pattern: fold to get success value
      final success = result.fold(
        (failure) => false,
        (data) => data,
      );

      if (success) {
        final requestDate = DateTime.parse(widget.shift.requestDate);
        final yearMonth =
            '${requestDate.year}-${requestDate.month.toString().padLeft(2, '0')}';
        ref.invalidate(monthlyShiftCardsProvider(yearMonth));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
            backgroundColor: TossColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit report. Please try again.'),
            backgroundColor: TossColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingReport = false;
        });
      }
    }
  }

  void _showReportBottomSheet(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: TossSpacing.space4,
                right: TossSpacing.space4,
                top: TossSpacing.space6,
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 48,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Issue',
                    style: TossTextStyles.titleMedium.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please describe the problem with this shift',
                    style: TossTextStyles.bodyLarge.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      border: Border.all(color: TossColors.gray200, width: 1),
                    ),
                    child: TextField(
                      controller: reasonController,
                      maxLines: 4,
                      maxLength: 500,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(
                        hintText: 'Enter the reason for reporting this issue...',
                        hintStyle: TossTextStyles.bodyLarge.copyWith(
                          color: TossColors.gray400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(TossSpacing.space4),
                        counterStyle: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      style: TossTextStyles.bodyLarge.copyWith(
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TossButton.secondary(
                          text: 'Cancel',
                          fullWidth: true,
                          isEnabled: !isSubmitting,
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.pop(bottomSheetContext),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TossButton.primary(
                          text: isSubmitting ? 'Submitting...' : 'OK',
                          fullWidth: true,
                          isEnabled: !isSubmitting,
                          onPressed: isSubmitting
                              ? null
                              : () async {
                                  final reason = reasonController.text.trim();
                                  if (reason.isEmpty) {
                                    ScaffoldMessenger.of(this.context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please enter a reason'),
                                        backgroundColor: TossColors.error,
                                      ),
                                    );
                                    return;
                                  }
                                  setBottomSheetState(() {
                                    isSubmitting = true;
                                  });
                                  Navigator.pop(bottomSheetContext);
                                  await _submitReport(reason);
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return InfoRow.between(
      label: label,
      value: value,
      valueStyle: valueStyle,
    );
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShiftInfoCard(shift: widget.shift),
                        const SizedBox(height: 16),
                        TossExpandableCard(
                          title: 'Recorded attendance',
                          isExpanded: _recordedAttendanceExpanded,
                          onToggle: () {
                            setState(() {
                              _recordedAttendanceExpanded =
                                  !_recordedAttendanceExpanded;
                            });
                          },
                          content: Column(
                            children: [
                              _buildInfoRow(
                                label: 'Recorded check-in',
                                value: _formatTime(widget.shift.actualStartTime,
                                    includeSeconds: true),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                label: 'Recorded check-out',
                                value: _formatTime(widget.shift.actualEndTime,
                                    includeSeconds: true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TossExpandableCard(
                          title: 'Confirmed attendance',
                          isExpanded: _confirmedAttendanceExpanded,
                          onToggle: () {
                            setState(() {
                              _confirmedAttendanceExpanded =
                                  !_confirmedAttendanceExpanded;
                            });
                          },
                          content: Column(
                            children: [
                              _buildInfoRow(
                                label: 'Confirmed check-in',
                                value: _formatTime(_getConfirmedStartTime()),
                                valueStyle: _getCheckInTimeColor(),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                label: 'Confirmed check-out',
                                value: _formatTime(_getConfirmedEndTime()),
                                valueStyle: _getCheckOutTimeColor(),
                              ),
                            ],
                          ),
                        ),
                        if (widget.shift.isReported ||
                            widget.shift.managerMemos.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ReportResponseCard(
                            shift: widget.shift,
                            isExpanded: _reportAndResponseExpanded,
                            onToggle: () {
                              setState(() {
                                _reportAndResponseExpanded =
                                    !_reportAndResponseExpanded;
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const GrayDividerSpace(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentSummaryCard(shift: widget.shift),
                        const SizedBox(height: 20),
                        ActivityLogSection(shift: widget.shift),
                        const SizedBox(height: 20),
                        Text(
                          'Recorded attendance is based on your check-in/out records.\nConfirmed attendance is the manager-approved time used for salary.',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            height: 1.6,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(TossSpacing.space4, TossSpacing.space4, TossSpacing.space4, 48),
            decoration: BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(
                  color: TossColors.gray100,
                  width: 1,
                ),
              ),
            ),
            child: widget.shift.isReported
                ? TossButton.secondary(
                    text: 'Report an issue with this shift',
                    leadingIcon: const Icon(Icons.error_outline, size: 18),
                    fullWidth: true,
                    textColor: TossColors.gray600,
                    isEnabled: false,
                    onPressed: null,
                  )
                : TossButton.primary(
                    text: 'Report an issue with this shift',
                    leadingIcon: const Icon(Icons.error_outline, size: 18),
                    fullWidth: true,
                    onPressed: () => _showReportBottomSheet(context),
                  ),
          ),
        ],
      ),
    );
  }
}
