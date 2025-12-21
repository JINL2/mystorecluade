import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
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
  final int problemCount;
  final List<StaffTimeRecord> staffRecords;
  final DateTime date;

  const ShiftTimelog({
    required this.shiftId,
    required this.shiftName,
    required this.timeRange,
    required this.assignedCount,
    required this.totalCount,
    required this.problemCount,
    required this.staffRecords,
    required this.date,
  });
}

/// Expandable shift section with staff timelogs
class ShiftSection extends StatefulWidget {
  final ShiftTimelog shift;
  final bool initiallyExpanded;
  final VoidCallback? onDataChanged;

  const ShiftSection({
    super.key,
    required this.shift,
    this.initiallyExpanded = true,
    this.onDataChanged,
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
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (widget.shift.problemCount > 0) ...[
                              const SizedBox(width: TossSpacing.space2),
                              Text(
                                '${widget.shift.problemCount} problems',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: TossColors.gray600,
                            ),
                            const SizedBox(width: 4),
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
                            fontWeight: FontWeight.w600,
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
                    size: 20,
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
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (context) => StaffTimelogDetailPage(
                          staffRecord: record,
                          shiftName: widget.shift.shiftName,
                          shiftDate: DateFormat('EEE, d MMM yyyy').format(widget.shift.date),
                          shiftTimeRange: widget.shift.timeRange,
                        ),
                      ),
                    );
                    // Notify parent to refresh data if save was successful
                    if (result == true) {
                      widget.onDataChanged?.call();
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
