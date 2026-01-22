import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/core/monitoring/sentry_config.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import 'package:myfinance_improved/features/attendance/domain/entities/shift_card.dart';
import 'package:myfinance_improved/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

import '../widgets/shift_detail/shift_info_card.dart';
import '../widgets/shift_detail/payment_summary_card.dart';
import '../widgets/shift_detail/report_response_card.dart';
import '../../../time_table_manage/presentation/pages/staff_timelog_detail/widgets/shift_logs_section.dart';
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
      return TossTextStyles.bodyError;
    } else if (isConfirmedByManager) {
      return TossTextStyles.bodyPrimaryBold;
    }
    return null;
  }

  TextStyle? _getCheckOutTimeColor() {
    final isConfirmedByManager = widget.shift.confirmEndTime != null;
    if (widget.shift.isExtratime && !isConfirmedByManager) {
      return TossTextStyles.bodyError;
    } else if (isConfirmedByManager) {
      return TossTextStyles.bodyPrimaryBold;
    }
    return null;
  }

  Future<void> _submitReport(String reason) async {
    if (_isSubmittingReport) return;

    setState(() {
      _isSubmittingReport = true;
    });

    // Log breadcrumb for tracking
    SentryConfig.addBreadcrumb(
      message: 'Submitting shift report',
      category: 'attendance',
      data: {
        'shiftRequestId': widget.shift.shiftRequestId,
        'reason': reason,
      },
    );

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
      // Log result type for debugging
      SentryConfig.addBreadcrumb(
        message: 'reportShiftIssue result received',
        category: 'attendance',
        data: {
          'resultType': result.runtimeType.toString(),
          'isRight': result.isRight(),
        },
      );

      final success = result.fold(
        (failure) {
          SentryConfig.captureMessage(
            'ShiftDetailPage: Report submission failed',
            extra: {
              'shiftRequestId': widget.shift.shiftRequestId,
              'failure': failure.toString(),
            },
          );
          return false;
        },
        (data) {
          // Ensure data is bool type
          if (data is! bool) {
            SentryConfig.captureMessage(
              'ShiftDetailPage: Unexpected data type in fold',
              extra: {
                'shiftRequestId': widget.shift.shiftRequestId,
                'dataType': data.runtimeType.toString(),
                'data': data.toString(),
              },
            );
            return false;
          }
          return data;
        },
      );

      if (success) {
        final requestDate = DateTime.parse(widget.shift.requestDate);
        final yearMonth =
            '${requestDate.year}-${requestDate.month.toString().padLeft(2, '0')}';
        ref.invalidate(monthlyShiftCardsProvider(yearMonth));

        TossToast.success(context, 'Report submitted successfully');
        Navigator.pop(context);
      } else {
        TossToast.error(context, 'Failed to submit report. Please try again.');
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'ShiftDetailPage._submitReport failed',
        extra: {
          'shiftRequestId': widget.shift.shiftRequestId,
          'reason': reason,
        },
      );
      if (mounted) {
        TossToast.error(context, 'Error: ${e.toString()}');
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

    TossBottomSheet.show<void>(
      context: context,
      title: 'Report Issue',
      content: StatefulBuilder(
        builder: (context, setBottomSheetState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please describe the problem with this shift',
                style: TossTextStyles.bodyGray600,
              ),
              SizedBox(height: TossSpacing.space4),
              TossTextField(
                controller: reasonController,
                hintText: 'Enter the reason for reporting this issue...',
                maxLines: 4,
                enabled: !isSubmitting,
              ),
              SizedBox(height: TossSpacing.paddingXL),
              Row(
                children: [
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Cancel',
                      fullWidth: true,
                      isEnabled: !isSubmitting,
                      onPressed: isSubmitting
                          ? null
                          : () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(width: TossSpacing.space3),
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
                                TossToast.error(this.context, 'Please enter a reason');
                                return;
                              }
                              setBottomSheetState(() {
                                isSubmitting = true;
                              });
                              Navigator.pop(context);
                              await _submitReport(reason);
                            },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
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
      appBar: TossAppBar(
        title: 'Shift details',
        backgroundColor: TossColors.white,
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
                        SizedBox(height: TossSpacing.space4),
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
                              SizedBox(height: TossSpacing.space3),
                              _buildInfoRow(
                                label: 'Recorded check-out',
                                value: _formatTime(widget.shift.actualEndTime,
                                    includeSeconds: true),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: TossSpacing.space4),
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
                              SizedBox(height: TossSpacing.space3),
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
                          SizedBox(height: TossSpacing.space4),
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
                        SizedBox(height: TossSpacing.space4),
                        ShiftLogsSection(shiftRequestId: widget.shift.shiftRequestId),
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
                        SizedBox(height: TossSpacing.space5),
                        Text(
                          'Recorded attendance is based on your check-in/out records.\nConfirmed attendance is the manager-approved time used for salary.',
                          style: TossTextStyles.captionGray600,
                        ),
                        SizedBox(height: TossSpacing.space4),
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
                    leadingIcon: Icon(Icons.error_outline, size: TossSpacing.iconSM),
                    fullWidth: true,
                    textColor: TossColors.gray600,
                    isEnabled: false,
                    onPressed: null,
                  )
                : TossButton.primary(
                    text: 'Report an issue with this shift',
                    leadingIcon: Icon(Icons.error_outline, size: TossSpacing.iconSM),
                    fullWidth: true,
                    onPressed: () => _showReportBottomSheet(context),
                  ),
          ),
        ],
      ),
    );
  }
}
