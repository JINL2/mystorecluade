import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/employee_monthly_detail.dart';
import 'attendance_card.dart';
import 'attendance_tab.dart';

/// Attendance history section with tabs and shift cards
class AttendanceHistorySection extends StatefulWidget {
  final EmployeeMonthlyDetail? monthlyData;

  const AttendanceHistorySection({
    super.key,
    this.monthlyData,
  });

  @override
  State<AttendanceHistorySection> createState() => _AttendanceHistorySectionState();
}

class _AttendanceHistorySectionState extends State<AttendanceHistorySection> {
  int _selectedTab = 0;

  List<EmployeeShiftRecord> _getFilteredShifts() {
    if (widget.monthlyData == null) return [];

    switch (_selectedTab) {
      case 0:
        return widget.monthlyData!.getShiftsByFilter(ShiftFilterType.unresolved);
      case 1:
        return widget.monthlyData!.getShiftsByFilter(ShiftFilterType.resolved);
      case 2:
      default:
        return widget.monthlyData!.getShiftsByFilter(ShiftFilterType.all);
    }
  }

  @override
  Widget build(BuildContext context) {
    final shifts = _getFilteredShifts();
    final summary = widget.monthlyData?.summary;
    final unresolvedCount = summary?.unresolvedCount ?? 0;
    final resolvedCount = summary?.resolvedCount ?? 0;
    final approvedCount = summary?.approvedCount ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            TossSpacing.space4,
            TossSpacing.space4,
            TossSpacing.space4,
            0,
          ),
          child: Text(
            'Attendance History',
            style: TossTextStyles.titleMedium.copyWith(
              fontWeight: TossFontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildTabs(unresolvedCount, resolvedCount, approvedCount),
        const SizedBox(height: TossSpacing.space3),
        _buildContent(shifts),
      ],
    );
  }

  Widget _buildTabs(int unresolvedCount, int resolvedCount, int totalCount) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AttendanceTab(
              title: 'Unresolved ($unresolvedCount)',
              isActive: _selectedTab == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTab = 0);
              },
            ),
          ),
          Expanded(
            child: AttendanceTab(
              title: 'Resolved ($resolvedCount)',
              isActive: _selectedTab == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTab = 1);
              },
            ),
          ),
          Expanded(
            child: AttendanceTab(
              title: 'All shifts ($totalCount)',
              isActive: _selectedTab == 2,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTab = 2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<EmployeeShiftRecord> shifts) {
    if (shifts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: TossSpacing.icon3XL,
                color: TossColors.gray300,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                _selectedTab == 0
                    ? 'No unresolved issues'
                    : 'No records found',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: shifts
            .map((shift) => AttendanceCard(shift: shift))
            .toList(),
      ),
    );
  }
}
