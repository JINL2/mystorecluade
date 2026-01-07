import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:intl/intl.dart';
import 'staff_timelog_card.dart';
import '../../pages/staff_timelog_detail_page.dart';

/// Model for shift timelog
class ShiftTimelog {
  final String shiftId;
  final String shiftName;
  final String timeRange;
  final int assignedCount;
  final int totalCount;
  final int problemCount; // Unsolved problems count
  final int solvedCount; // Solved problems count
  final List<StaffTimeRecord> staffRecords;
  final DateTime date;

  const ShiftTimelog({
    required this.shiftId,
    required this.shiftName,
    required this.timeRange,
    required this.assignedCount,
    required this.totalCount,
    required this.problemCount,
    this.solvedCount = 0,
    required this.staffRecords,
    required this.date,
  });
}

/// Expandable shift section with staff timelogs
class ShiftSection extends StatefulWidget {
  final ShiftTimelog shift;
  final bool initiallyExpanded;
  /// Legacy callback (deprecated, use onSaveResult instead)
  final VoidCallback? onDataChanged;
  /// Callback with save result for Partial Update
  /// Parameters: shiftRequestId, shiftDate, isProblemSolved, isReportedSolved,
  ///             confirmedStartTime, confirmedEndTime, bonusAmount
  final void Function(Map<String, dynamic> result)? onSaveResult;

  const ShiftSection({
    super.key,
    required this.shift,
    this.initiallyExpanded = true,
    this.onDataChanged,
    this.onSaveResult,
  });

  @override
  State<ShiftSection> createState() => _ShiftSectionState();
}

class _ShiftSectionState extends State<ShiftSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  /// Build problem and solved indicators for shift header
  /// Shows: "2 problems" (red) + "solved 1" (gray) or just "solved 1" (gray)
  List<Widget> _buildProblemSolvedIndicators() {
    final List<Widget> indicators = [];
    final problemCount = widget.shift.problemCount;
    final solvedCount = widget.shift.solvedCount;

    // Unsolved problems: red text
    if (problemCount > 0) {
      indicators.add(const SizedBox(width: TossSpacing.space2));
      indicators.add(
        Text(
          '$problemCount problems',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.error,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      );
    }

    // Solved problems: green text
    if (solvedCount > 0) {
      indicators.add(const SizedBox(width: TossSpacing.space2));
      indicators.add(
        Text(
          'solved $solvedCount',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.success,
            fontWeight: TossFontWeight.medium,
          ),
        ),
      );
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  // Shift info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.shift.shiftName,
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                                fontWeight: TossFontWeight.bold,
                              ),
                            ),
                            // Problem & Solved indicators
                            ..._buildProblemSolvedIndicators(),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space0_5),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: TossSpacing.iconXS,
                              color: TossColors.gray600,
                            ),
                            const SizedBox(width: TossSpacing.space1),
                            Text(
                              widget.shift.timeRange,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TossSpacing.space2),
                        Text(
                          '${widget.shift.assignedCount}/${widget.shift.totalCount} assigned',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: TossSpacing.space2),

                  // Expand/Collapse Icon
                  Icon(
                    _isExpanded ? Icons.expand_more : Icons.chevron_right,
                    color: TossColors.gray600,
                    size: TossSpacing.iconMD,
                  ),
                ],
              ),
            ),
          ),

          // Staff list (expanded)
          if (_isExpanded && widget.shift.staffRecords.isNotEmpty) ...[
            const Divider(height: 1, thickness: 1, color: TossColors.gray100),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.shift.staffRecords.length,
              itemBuilder: (context, index) {
                final record = widget.shift.staffRecords[index];
                return StaffTimelogCard(
                  record: record,
                  onTap: () async {
                    debugPrint('👆 [ShiftSection] Staff tapped - navigating to detail: ${record.staffName}');
                    final result = await Navigator.of(context).push<Map<String, dynamic>>(
                      MaterialPageRoute<Map<String, dynamic>>(
                        builder: (context) => StaffTimelogDetailPage(
                          staffRecord: record,
                          shiftName: widget.shift.shiftName,
                          shiftDate: DateFormat('EEE, d MMM yyyy').format(widget.shift.date),
                          shiftTimeRange: widget.shift.timeRange,
                        ),
                      ),
                    );
                    debugPrint('⬅️ [ShiftSection] Returned from StaffTimelogDetailPage - result: $result');
                    // Use Partial Update callback if available
                    if (result != null && result['success'] == true) {
                      if (widget.onSaveResult != null) {
                        // Add shiftDate for Partial Update
                        result['shiftDate'] = DateFormat('yyyy-MM-dd').format(widget.shift.date);
                        widget.onSaveResult!(result);
                      } else {
                        // Fallback to legacy callback
                        widget.onDataChanged?.call();
                      }
                    }
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
