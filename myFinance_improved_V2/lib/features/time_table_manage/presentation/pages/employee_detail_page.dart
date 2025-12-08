import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';

import '../widgets/stats/stats_leaderboard.dart';

/// Employee Detail Page
///
/// Shows comprehensive employee information including:
/// - Profile header with avatar, name, role
/// - Performance metrics (On-time Rate, Completed Shifts, Reliability Score)
/// - Attendance history with filterable tabs
/// - Salary breakdown for the selected month
class EmployeeDetailPage extends ConsumerStatefulWidget {
  final LeaderboardEmployee employee;
  final String? storeId;

  const EmployeeDetailPage({
    super.key,
    required this.employee,
    this.storeId,
  });

  @override
  ConsumerState<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends ConsumerState<EmployeeDetailPage> {
  int _selectedAttendanceTab = 0; // 0 = Unresolved, 1 = Resolved, 2 = All
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  void _changeMonth(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
  }

  String get _monthLabel {
    return DateFormat('MMM').format(_selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: _buildProfileHeader(),
            ),

            // Gray divider (full width)
            const GrayDividerSpace(),

            // Attendance History Section
            _buildAttendanceHistorySection(),

            // Gray divider (full width)
            const GrayDividerSpace(),

            // Salary Breakdown Section
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: _buildSalaryBreakdownSection(),
            ),

            const SizedBox(height: TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: TossColors.gray900),
        onPressed: () => Navigator.pop(context),
      ),
      title: GestureDetector(
        onTap: _showMonthPicker,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _monthLabel,
              style: TossTextStyles.titleMedium.copyWith(
                color: TossColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: TossColors.primary,
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  void _showMonthPicker() {
    HapticFeedback.selectionClick();
    // TODO: Implement month picker bottom sheet
  }

  Widget _buildProfileHeader() {
    final employee = widget.employee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar and Name Row
        Row(
          children: [
            EmployeeProfileAvatar(
              imageUrl: employee.avatarUrl,
              name: employee.name,
              size: 56,
              showBorder: true,
              borderColor: TossColors.gray200,
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    employee.name,
                    style: TossTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Role and store
                  Text(
                    '${employee.role ?? 'Staff'} · ${employee.storeName ?? 'Store'}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: TossSpacing.space5),

        // Performance Metrics Row
        _buildMetricsRow(),
      ],
    );
  }

  void _showEmployeeSelector() {
    HapticFeedback.selectionClick();
    // TODO: Implement employee selector bottom sheet
  }

  Widget _buildMetricsRow() {
    final employee = widget.employee;

    // Calculate on-time rate from late rate
    final onTimeRate = 100 - employee.lateRate;
    final onTimeRateStr = '${onTimeRate.toStringAsFixed(0)}%';

    return Row(
      children: [
        // On-time Rate
        Expanded(
          child: _MetricCard(
            label: 'On-time Rate',
            value: onTimeRateStr,
            change: '+1.5%', // TODO: Calculate from historical data
            changeIsPositive: true,
            footnote: '#1 in company',
          ),
        ),
        const _MetricDivider(),
        // Completed Shifts
        Expanded(
          child: _MetricCard(
            label: 'Completed Shifts',
            value: employee.completedShifts.toString(),
            change: '+0.8%',
            changeIsPositive: true,
            footnote: 'Above store average',
          ),
        ),
        const _MetricDivider(),
        // Reliability Score
        Expanded(
          child: _MetricCard(
            label: 'Reliability Score',
            value: employee.finalScore.round().toString(),
            change: '-0.2%',
            changeIsPositive: false,
            footnote: '#2 of 23 staff',
            showInfoIcon: true,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceHistorySection() {
    // Get attendance items based on selected tab
    final filter = _selectedAttendanceTab == 0
        ? 'unresolved'
        : _selectedAttendanceTab == 1
            ? 'resolved'
            : 'all';
    final attendanceItems = _getMockAttendanceItems(filter);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Tab Bar
        _buildAttendanceTabs(),

        const SizedBox(height: TossSpacing.space3),

        // Tab Content (no fixed height, renders inline)
        _buildAttendanceContent(attendanceItems),
      ],
    );
  }

  Widget _buildAttendanceTabs() {
    // TODO: Get actual counts from data
    const unresolvedCount = 4;
    const resolvedCount = 10;
    const allCount = 16;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _AttendanceTab(
              title: 'Unresolved ($unresolvedCount)',
              isActive: _selectedAttendanceTab == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedAttendanceTab = 0);
              },
            ),
          ),
          Expanded(
            child: _AttendanceTab(
              title: 'Resolved ($resolvedCount)',
              isActive: _selectedAttendanceTab == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedAttendanceTab = 1);
              },
            ),
          ),
          Expanded(
            child: _AttendanceTab(
              title: 'All shifts ($allCount)',
              isActive: _selectedAttendanceTab == 2,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedAttendanceTab = 2);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceContent(List<_AttendanceItem> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 48,
                color: TossColors.gray300,
              ),
              const SizedBox(height: TossSpacing.space3),
              Text(
                _selectedAttendanceTab == 0
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
        children: items
            .map((item) => _AttendanceCard(
                  item: item,
                  onTap: () => _navigateToShiftDetail(item),
                ))
            .toList(),
      ),
    );
  }

  List<_AttendanceItem> _getMockAttendanceItems(String filter) {
    // Mock data for demonstration - unresolved items
    final unresolvedItems = [
      const _AttendanceItem(
        paidHours: 13.8,
        shiftName: 'Morning shift',
        dayNumber: 15,
        clockIn: '08:12',
        clockOut: '--:--',
        needsConfirm: true,
        issueType: AttendanceIssueType.noCheckOut,
      ),
      const _AttendanceItem(
        paidHours: 11.8,
        shiftName: 'Opening shift',
        dayNumber: 14,
        clockIn: '--:--',
        clockOut: '16:02',
        needsConfirm: true,
        issueType: AttendanceIssueType.noCheckIn,
      ),
      const _AttendanceItem(
        paidHours: 9.8,
        shiftName: 'Afternoon shift',
        dayNumber: 12,
        clockIn: '14:00',
        clockOut: '23:18',
        needsConfirm: true,
        issueType: AttendanceIssueType.overtime,
      ),
      const _AttendanceItem(
        paidHours: 7.8,
        shiftName: 'Closing shift',
        dayNumber: 10,
        clockIn: '17:58',
        clockOut: '21:15',
        needsConfirm: true,
        issueType: AttendanceIssueType.earlyCheckOut,
      ),
    ];

    // Mock data for demonstration - resolved items (same issues but confirmed)
    final resolvedItems = [
      const _AttendanceItem(
        paidHours: 13.8,
        shiftName: 'Morning shift',
        dayNumber: 8,
        clockIn: '08:05',
        clockOut: '--:--',
        needsConfirm: false,
        issueType: AttendanceIssueType.noCheckOut,
      ),
      const _AttendanceItem(
        paidHours: 11.8,
        shiftName: 'Opening shift',
        dayNumber: 7,
        clockIn: '--:--',
        clockOut: '15:45',
        needsConfirm: false,
        issueType: AttendanceIssueType.noCheckIn,
      ),
      const _AttendanceItem(
        paidHours: 10.2,
        shiftName: 'Afternoon shift',
        dayNumber: 6,
        clockIn: '13:55',
        clockOut: '22:30',
        needsConfirm: false,
        issueType: AttendanceIssueType.overtime,
      ),
      const _AttendanceItem(
        paidHours: 7.5,
        shiftName: 'Closing shift',
        dayNumber: 5,
        clockIn: '18:02',
        clockOut: '21:00',
        needsConfirm: false,
        issueType: AttendanceIssueType.earlyCheckOut,
      ),
      const _AttendanceItem(
        paidHours: 8.0,
        shiftName: 'Morning shift',
        dayNumber: 4,
        clockIn: '08:15',
        clockOut: '16:00',
        needsConfirm: false,
        issueType: AttendanceIssueType.late,
      ),
      const _AttendanceItem(
        paidHours: 8.0,
        shiftName: 'Opening shift',
        dayNumber: 3,
        clockIn: '07:58',
        clockOut: '16:05',
        needsConfirm: false,
        issueType: AttendanceIssueType.noCheckIn,
      ),
      const _AttendanceItem(
        paidHours: 9.5,
        shiftName: 'Afternoon shift',
        dayNumber: 2,
        clockIn: '14:00',
        clockOut: '23:00',
        needsConfirm: false,
        issueType: AttendanceIssueType.overtime,
      ),
      const _AttendanceItem(
        paidHours: 7.2,
        shiftName: 'Closing shift',
        dayNumber: 1,
        clockIn: '17:50',
        clockOut: '20:45',
        needsConfirm: false,
        issueType: AttendanceIssueType.earlyCheckOut,
      ),
      const _AttendanceItem(
        paidHours: 8.0,
        shiftName: 'Morning shift',
        dayNumber: 28,
        clockIn: '08:20',
        clockOut: '16:10',
        needsConfirm: false,
        issueType: AttendanceIssueType.late,
      ),
      const _AttendanceItem(
        paidHours: 12.0,
        shiftName: 'Opening shift',
        dayNumber: 25,
        clockIn: '--:--',
        clockOut: '18:00',
        needsConfirm: false,
        issueType: AttendanceIssueType.noCheckIn,
      ),
    ];

    switch (filter) {
      case 'unresolved':
        return unresolvedItems;
      case 'resolved':
        return resolvedItems;
      case 'all':
      default:
        return [...unresolvedItems, ...resolvedItems];
    }
  }

  void _navigateToShiftDetail(_AttendanceItem item) {
    HapticFeedback.selectionClick();
    // TODO: Navigate to shift detail page
  }

  Widget _buildSalaryBreakdownSection() {
    final employee = widget.employee;

    // Calculate salary values
    final salaryAmount = employee.salaryAmount;
    final completedShifts = employee.completedShifts;
    final paidHours = completedShifts * 8.0; // Approximate

    // Format values
    final formatter = NumberFormat('#,###');
    final totalConfirmedTime = '${paidHours.toStringAsFixed(0)}h 30m';
    final hourlySalary = '${formatter.format(salaryAmount.toInt())}₫';
    final basePay = formatter.format((paidHours * salaryAmount).toInt());
    final bonusPay = '1,450,000';
    final penaltyDeduction = '-300,000';
    final totalPayment = formatter.format(
      (paidHours * salaryAmount + 1450000 - 300000).toInt(),
    );

    final monthRange = _getMonthRange();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Breakdown This Month',
          style: TossTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'From $monthRange',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: TossSpacing.space4),

        // Salary rows
        _SalaryRow(label: 'Total confirmed time', value: totalConfirmedTime),
        const SizedBox(height: 12),
        _SalaryRow(label: 'Hourly salary', value: hourlySalary),
        const SizedBox(height: 12),
        Container(height: 1, color: TossColors.gray100),
        const SizedBox(height: 12),
        _SalaryRow(label: 'Base pay', value: '${basePay}₫'),
        const SizedBox(height: 12),
        _SalaryRow(label: 'Bonus pay', value: '${bonusPay}₫'),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Penalty deduction',
          value: '${penaltyDeduction}₫',
          valueColor: TossColors.error,
        ),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Total payment',
          value: '${totalPayment}₫',
          labelStyle: TossTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          valueStyle: TossTextStyles.titleMedium.copyWith(
            color: TossColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Warning message if unresolved issues exist
        Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: TossColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: TossColors.warning,
              ),
              const SizedBox(width: TossSpacing.space2),
              Expanded(
                child: Text(
                  'Warning: 4 unresolved problems may affect final payment',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthRange() {
    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final monthName = DateFormat('MMM').format(_selectedMonth);
    return '$monthName/${firstDay.day} to $monthName/${lastDay.day}';
  }
}

// ============================================================================
// Supporting Widgets
// ============================================================================

/// Metric card for profile header
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? change;
  final bool changeIsPositive;
  final String? footnote;
  final bool showInfoIcon;

  const _MetricCard({
    required this.label,
    required this.value,
    this.change,
    this.changeIsPositive = true,
    this.footnote,
    this.showInfoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with optional info icon
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showInfoIcon) ...[
              const SizedBox(width: 2),
              const Icon(
                Icons.info_outline,
                size: 14,
                color: TossColors.gray400,
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),

        // Value and change
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TossTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (change != null) ...[
              const SizedBox(width: 4),
              Text(
                change!,
                style: TossTextStyles.caption.copyWith(
                  color: changeIsPositive ? TossColors.primary : TossColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),

        // Footnote
        if (footnote != null) ...[
          const SizedBox(height: 2),
          Text(
            footnote!,
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Vertical divider between metrics
class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
      color: TossColors.gray200,
    );
  }
}

/// Attendance tab widget
class _AttendanceTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _AttendanceTab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.only(bottom: TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? TossColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? TossColors.gray900 : TossColors.gray500,
          ),
        ),
      ),
    );
  }
}

/// Attendance item data model
class _AttendanceItem {
  final double paidHours;
  final String shiftName;
  final int dayNumber; // Day of month (1-31)
  final String clockIn;
  final String clockOut;
  final bool needsConfirm;
  final AttendanceIssueType? issueType;

  const _AttendanceItem({
    required this.paidHours,
    required this.shiftName,
    required this.dayNumber,
    required this.clockIn,
    required this.clockOut,
    this.needsConfirm = false,
    this.issueType,
  });
}

enum AttendanceIssueType {
  late,
  overtime,
  noCheckIn,
  noCheckOut,
  earlyCheckOut,
}

/// Attendance card widget
class _AttendanceCard extends StatelessWidget {
  final _AttendanceItem item;
  final VoidCallback? onTap;

  const _AttendanceCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = !item.needsConfirm;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: TossSpacing.space4),
        child: Row(
          children: [
            // Paid hours circle (smaller)
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TossColors.gray100,
              ),
              child: Center(
                child: Text(
                  item.paidHours.toStringAsFixed(1),
                  style: TossTextStyles.small.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Shift info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.shiftName,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${item.dayNumber} · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: item.clockIn,
                          style: TossTextStyles.caption.copyWith(
                            // Gray for resolved, red for unresolved missing time
                            color: item.clockIn == '--:--'
                                ? (isResolved ? TossColors.gray500 : TossColors.error)
                                : TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' – ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: item.clockOut,
                          style: TossTextStyles.caption.copyWith(
                            // Gray for resolved, red for unresolved missing time
                            color: item.clockOut == '--:--'
                                ? (isResolved ? TossColors.gray500 : TossColors.error)
                                : TossColors.gray600,
                          ),
                        ),
                        // Show "Confirmed" for resolved, "Need Confirm" for unresolved
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                        TextSpan(
                          text: isResolved ? 'Confirmed' : 'Need Confirm',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // Issue badge (gray for resolved, red for unresolved)
            if (item.issueType != null) ...[
              const SizedBox(width: TossSpacing.space2),
              _IssueBadge(
                issueType: item.issueType!,
                isResolved: isResolved,
              ),
            ],

            // Arrow
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: TossColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}

/// Issue badge for attendance cards
class _IssueBadge extends StatelessWidget {
  final AttendanceIssueType issueType;
  final bool isResolved;

  const _IssueBadge({
    required this.issueType,
    this.isResolved = false,
  });

  @override
  Widget build(BuildContext context) {
    final label = _getIssueLabel();
    // Use gray for resolved issues, red for unresolved
    final color = isResolved ? TossColors.gray400 : TossColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TossTextStyles.small.copyWith(
          color: TossColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getIssueLabel() {
    switch (issueType) {
      case AttendanceIssueType.late:
        return 'Late';
      case AttendanceIssueType.overtime:
        return 'OT';
      case AttendanceIssueType.noCheckIn:
        return 'No check-in';
      case AttendanceIssueType.noCheckOut:
        return 'No check-out';
      case AttendanceIssueType.earlyCheckOut:
        return 'Early check-out';
    }
  }
}

/// Salary row widget
class _SalaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const _SalaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
        ),
        Text(
          value,
          style: valueStyle ??
              TossTextStyles.body.copyWith(
                color: valueColor ?? TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
