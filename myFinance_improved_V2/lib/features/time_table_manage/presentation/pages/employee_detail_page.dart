import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';

import '../../domain/entities/employee_monthly_detail.dart';
import '../providers/state/employee_monthly_detail_provider.dart';
import '../widgets/stats/stats_leaderboard.dart';

/// Employee Detail Page
///
/// Shows comprehensive employee information including:
/// - Profile header with avatar, name, role
/// - Performance metrics (On-time Rate, Completed Shifts, Reliability Score)
/// - Attendance history with filterable tabs (real data from RPC)
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
    // Load data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyData();
    });
  }

  String get _yearMonth {
    return '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';
  }

  void _loadMonthlyData() {
    final userId = widget.employee.visitorId;
    if (userId == null) return;
    ref.read(employeeMonthlyDetailProvider.notifier).loadData(
          userId: userId,
          yearMonth: _yearMonth,
        );
  }

  void _changeMonth(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
    _loadMonthlyData();
  }

  String get _monthLabel {
    return DateFormat('MMM').format(_selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeMonthlyDetailProvider);
    final userId = widget.employee.visitorId;
    final monthlyData = userId != null ? state.getData(userId, _yearMonth) : null;

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: state.isLoading && monthlyData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Section
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: _buildProfileHeader(monthlyData),
                  ),

                  // Gray divider (full width)
                  const GrayDividerSpace(),

                  // Attendance History Section
                  _buildAttendanceHistorySection(monthlyData),

                  // Gray divider (full width)
                  const GrayDividerSpace(),

                  // Recent Activity Section (Audit Logs)
                  _buildRecentActivitySection(monthlyData),

                  // Gray divider (full width)
                  const GrayDividerSpace(),

                  // Salary Breakdown Section
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: _buildSalaryBreakdownSection(monthlyData),
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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Previous month button
          IconButton(
            icon: const Icon(Icons.chevron_left, color: TossColors.gray600),
            onPressed: () => _changeMonth(-1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          // Month label (tappable for picker)
          GestureDetector(
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
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: TossColors.primary,
                ),
              ],
            ),
          ),
          // Next month button
          IconButton(
            icon: const Icon(Icons.chevron_right, color: TossColors.gray600),
            onPressed: () => _changeMonth(1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  void _showMonthPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _MonthPickerSheet(
        selectedMonth: _selectedMonth,
        onMonthSelected: (month) {
          Navigator.pop(context);
          setState(() {
            _selectedMonth = month;
          });
          _loadMonthlyData();
        },
      ),
    );
  }

  Widget _buildProfileHeader(EmployeeMonthlyDetail? monthlyData) {
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
        _buildMetricsRow(monthlyData),
      ],
    );
  }

  Widget _buildMetricsRow(EmployeeMonthlyDetail? monthlyData) {
    final summary = monthlyData?.summary;

    // Calculate on-time rate from monthly data
    // On-time = shifts with actual_start that are not late
    final totalWorkedShifts = summary?.approvedCount ?? 0;
    final lateCount = summary?.lateCount ?? 0;
    final onTimeCount = totalWorkedShifts - lateCount;
    final onTimeRate = totalWorkedShifts > 0
        ? (onTimeCount / totalWorkedShifts * 100).round()
        : 0;

    // Completed shifts = shifts with both check-in and check-out
    // For now, use approvedCount as proxy (TODO: add completed_count to RPC)
    final completedShifts = summary?.approvedCount ?? 0;

    // Total shifts this month
    final totalShifts = summary?.totalShifts ?? 0;

    return Row(
      children: [
        // On-time Rate
        Expanded(
          child: _MetricCard(
            label: 'On-time Rate',
            value: '$onTimeRate%',
            footnote: '$onTimeCount / $totalWorkedShifts shifts',
          ),
        ),
        const _MetricDivider(),
        // Completed Shifts
        Expanded(
          child: _MetricCard(
            label: 'Completed Shifts',
            value: completedShifts.toString(),
            footnote: 'of $totalShifts total',
          ),
        ),
        const _MetricDivider(),
        // Total Hours
        Expanded(
          child: _MetricCard(
            label: 'Total Hours',
            value: summary?.formattedWorkedHours ?? '0h',
            footnote: 'this month',
            showInfoIcon: true,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceHistorySection(EmployeeMonthlyDetail? monthlyData) {
    // Get shifts based on selected tab
    final shifts = monthlyData != null
        ? _getFilteredShifts(monthlyData)
        : <EmployeeShiftRecord>[];

    final summary = monthlyData?.summary;
    final unresolvedCount = summary?.unresolvedCount ?? 0;
    final resolvedCount = summary?.resolvedCount ?? 0;
    // All shifts tab shows only approved shifts
    final approvedCount = summary?.approvedCount ?? 0;

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
        _buildAttendanceTabs(unresolvedCount, resolvedCount, approvedCount),

        const SizedBox(height: TossSpacing.space3),

        // Tab Content (no fixed height, renders inline)
        _buildAttendanceContent(shifts),
      ],
    );
  }

  List<EmployeeShiftRecord> _getFilteredShifts(EmployeeMonthlyDetail data) {
    switch (_selectedAttendanceTab) {
      case 0: // Unresolved
        return data.getShiftsByFilter(ShiftFilterType.unresolved);
      case 1: // Resolved
        return data.getShiftsByFilter(ShiftFilterType.resolved);
      case 2: // All
      default:
        return data.getShiftsByFilter(ShiftFilterType.all);
    }
  }

  Widget _buildAttendanceTabs(
    int unresolvedCount,
    int resolvedCount,
    int totalCount,
  ) {
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
              title: 'All shifts ($totalCount)',
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

  Widget _buildAttendanceContent(List<EmployeeShiftRecord> shifts) {
    if (shifts.isEmpty) {
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
        children: shifts
            .map((shift) => _AttendanceCard(shift: shift))
            .toList(),
      ),
    );
  }

  Widget _buildRecentActivitySection(EmployeeMonthlyDetail? monthlyData) {
    final auditLogs = monthlyData?.auditLogs ?? [];

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TossTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (auditLogs.isNotEmpty)
                Text(
                  '${auditLogs.length} events',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Activity List
        if (auditLogs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space6),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.history,
                    size: 48,
                    color: TossColors.gray300,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'No activity this month',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Column(
              children: auditLogs
                  .take(10) // Limit to 10 most recent
                  .map((log) => _ActivityLogItem(log: log))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildSalaryBreakdownSection(EmployeeMonthlyDetail? monthlyData) {
    final employee = widget.employee;
    final summary = monthlyData?.summary;
    final salaryInfo = monthlyData?.salary;

    // Use real data if available
    final totalWorkedHours = summary?.totalWorkedHours ?? (employee.completedShifts * 8.0);
    final salaryAmount = salaryInfo?.salaryAmount ?? employee.salaryAmount;
    final totalBonus = summary?.totalBonus ?? 0;
    final totalLateMinutes = summary?.totalLateDeduction ?? 0; // This is minutes, not currency
    final unresolvedCount = summary?.unresolvedCount ?? 0;

    // Format values
    final formatter = NumberFormat('#,###');
    final currencySymbol = salaryInfo?.currencySymbol ?? '₫';

    final basePay = totalWorkedHours * salaryAmount;
    // Note: totalLateMinutes is in minutes, not deducted from payment directly
    // The actual deduction calculation would need a per-minute rate
    final totalPayment = basePay + totalBonus;

    final monthRange = monthlyData?.period.displayRange ?? _getMonthRange();

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
        _SalaryRow(
          label: 'Total confirmed time',
          value: summary?.formattedWorkedHours ?? '${totalWorkedHours.toStringAsFixed(0)}h 0m',
        ),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Hourly salary',
          value: '${formatter.format(salaryAmount.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: TossColors.gray100),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Base pay',
          value: '${formatter.format(basePay.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Bonus pay',
          value: '${formatter.format(totalBonus.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Penalty deduction',
          value: '-${totalLateMinutes.toInt()}m',
          valueColor: TossColors.error,
        ),
        const SizedBox(height: 12),
        _SalaryRow(
          label: 'Total payment',
          value: '${formatter.format(totalPayment.toInt())}$currencySymbol',
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
        if (unresolvedCount > 0)
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
                    'Warning: $unresolvedCount unresolved problems may affect final payment',
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
  final String? footnote;
  final bool showInfoIcon;

  const _MetricCard({
    required this.label,
    required this.value,
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

        // Value
        Text(
          value,
          style: TossTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
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

/// Attendance card widget - uses real EmployeeShiftRecord
class _AttendanceCard extends StatelessWidget {
  final EmployeeShiftRecord shift;

  const _AttendanceCard({
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = shift.isProblemSolved;
    final clockIn = shift.displayClockIn;
    final clockOut = shift.displayClockOut;
    final workedHoursText = shift.workedHours != null
        ? '${shift.workedHours!.toStringAsFixed(1)}h'
        : '-';

    return Padding(
        padding: const EdgeInsets.only(bottom: TossSpacing.space4),
        child: Row(
          children: [
            // Day of month circle
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TossColors.gray100,
              ),
              child: Center(
                child: Text(
                  '${shift.dayOfMonth ?? '-'}',
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
                    shift.shiftName ?? 'Shift',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        // Worked hours
                        TextSpan(
                          text: '$workedHoursText · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: clockIn,
                          style: TossTextStyles.caption.copyWith(
                            color: clockIn == '--:--'
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
                          text: clockOut,
                          style: TossTextStyles.caption.copyWith(
                            color: clockOut == '--:--'
                                ? (isResolved ? TossColors.gray500 : TossColors.error)
                                : TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                        TextSpan(
                          text: shift.isApproved ? 'Confirmed' : 'Need Confirm',
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

            // Issue badge
            if (shift.issueType != null) ...[
              const SizedBox(width: TossSpacing.space2),
              _IssueBadge(
                issueType: shift.issueType!,
                isResolved: isResolved,
              ),
            ],
          ],
        ),
      );
  }
}

/// Issue badge for attendance cards
class _IssueBadge extends StatelessWidget {
  final ShiftIssueType issueType;
  final bool isResolved;

  const _IssueBadge({
    required this.issueType,
    this.isResolved = false,
  });

  @override
  Widget build(BuildContext context) {
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
        issueType.label,
        style: TossTextStyles.small.copyWith(
          color: TossColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
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

/// Activity log item widget for Recent Activity section
class _ActivityLogItem extends StatelessWidget {
  final EmployeeAuditLog log;

  const _ActivityLogItem({required this.log});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon based on action type
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getActionColor().withValues(alpha: 0.1),
            ),
            child: Icon(
              _getActionIcon(),
              size: 16,
              color: _getActionColor(),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Log details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action label
                Text(
                  log.actionType.label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                // Details row: store, date, changed by
                Text.rich(
                  TextSpan(
                    children: [
                      if (log.storeName != null) ...[
                        TextSpan(
                          text: log.storeName,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                      if (log.workDate != null) ...[
                        TextSpan(
                          text: _formatWorkDate(log.workDate!),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        TextSpan(
                          text: ' · ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray400,
                          ),
                        ),
                      ],
                      TextSpan(
                        text: log.changedByName ?? 'System',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Relative time
          Text(
            log.relativeTime,
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray400,
            ),
          ),
        ],
      ),
    );
  }

  String _formatWorkDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  IconData _getActionIcon() {
    switch (log.actionType) {
      case AuditActionType.scheduleCreated:
        return Icons.add_circle_outline;
      case AuditActionType.scheduleDeleted:
        return Icons.remove_circle_outline;
      case AuditActionType.approvalChanged:
        return Icons.check_circle_outline;
      case AuditActionType.checkIn:
        return Icons.login;
      case AuditActionType.checkOut:
        return Icons.logout;
      case AuditActionType.timeConfirmed:
        return Icons.schedule;
      case AuditActionType.problemResolved:
        return Icons.build_circle_outlined;
      case AuditActionType.reportResolved:
        return Icons.report_off_outlined;
      case AuditActionType.bonusUpdated:
        return Icons.attach_money;
      case AuditActionType.memoAdded:
        return Icons.note_add_outlined;
      case AuditActionType.updated:
        return Icons.edit_outlined;
    }
  }

  Color _getActionColor() {
    switch (log.actionType) {
      case AuditActionType.scheduleCreated:
        return TossColors.primary;
      case AuditActionType.scheduleDeleted:
        return TossColors.error;
      case AuditActionType.approvalChanged:
        return TossColors.success;
      case AuditActionType.checkIn:
        return TossColors.success;
      case AuditActionType.checkOut:
        return TossColors.primary;
      case AuditActionType.timeConfirmed:
        return TossColors.success;
      case AuditActionType.problemResolved:
        return TossColors.warning;
      case AuditActionType.reportResolved:
        return TossColors.warning;
      case AuditActionType.bonusUpdated:
        return TossColors.success;
      case AuditActionType.memoAdded:
        return TossColors.gray600;
      case AuditActionType.updated:
        return TossColors.gray600;
    }
  }
}

/// Month picker bottom sheet widget
class _MonthPickerSheet extends StatefulWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthSelected;

  const _MonthPickerSheet({
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.selectedMonth.year;
  }

  void _changeYear(int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedYear += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Year selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  color: TossColors.gray600,
                  onPressed: () => _changeYear(-1),
                ),
                Text(
                  '$_selectedYear',
                  style: TossTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  color: TossColors.gray600,
                  onPressed: _selectedYear < now.year ? () => _changeYear(1) : null,
                ),
              ],
            ),

            const SizedBox(height: TossSpacing.space4),

            // Month grid (3x4)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthName = _getMonthName(index + 1);
                final isSelected = _selectedYear == widget.selectedMonth.year &&
                    index == widget.selectedMonth.month - 1;
                final isFuture = _selectedYear > now.year ||
                    (_selectedYear == now.year && index > now.month - 1);

                return GestureDetector(
                  onTap: isFuture
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          widget.onMonthSelected(
                            DateTime(_selectedYear, index + 1),
                          );
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? TossColors.primary
                          : isFuture
                              ? TossColors.gray100
                              : TossColors.gray50,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? null
                          : Border.all(color: TossColors.gray200),
                    ),
                    child: Center(
                      child: Text(
                        monthName,
                        style: TossTextStyles.body.copyWith(
                          color: isSelected
                              ? TossColors.white
                              : isFuture
                                  ? TossColors.gray400
                                  : TossColors.gray900,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
