import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';

import '../../domain/entities/employee_monthly_detail.dart';
import '../providers/state/employee_monthly_detail_provider.dart';
import '../widgets/employee_detail/activity_log_item.dart';
import '../widgets/employee_detail/attendance_card.dart';
import '../widgets/employee_detail/attendance_tab.dart';
import '../widgets/employee_detail/metric_card.dart';
import '../widgets/employee_detail/month_picker_sheet.dart';
import '../widgets/employee_detail/salary_row.dart';
import '../widgets/stats/stats_leaderboard.dart';

/// Employee Detail Page
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
  int _selectedAttendanceTab = 0;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
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
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: _buildProfileHeader(monthlyData),
                  ),
                  const GrayDividerSpace(),
                  _buildAttendanceHistorySection(monthlyData),
                  const GrayDividerSpace(),
                  _buildRecentActivitySection(monthlyData),
                  const GrayDividerSpace(),
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
          IconButton(
            icon: const Icon(Icons.chevron_left, color: TossColors.gray600),
            onPressed: () => _changeMonth(-1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
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
      builder: (context) => MonthPickerSheet(
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
                  Text(
                    employee.name,
                    style: TossTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
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
        _buildMetricsRow(monthlyData),
      ],
    );
  }

  Widget _buildMetricsRow(EmployeeMonthlyDetail? monthlyData) {
    final summary = monthlyData?.summary;
    final totalWorkedShifts = summary?.approvedCount ?? 0;
    final lateCount = summary?.lateCount ?? 0;
    final onTimeCount = totalWorkedShifts - lateCount;
    final onTimeRate = totalWorkedShifts > 0
        ? (onTimeCount / totalWorkedShifts * 100).round()
        : 0;
    final completedShifts = summary?.approvedCount ?? 0;
    final totalShifts = summary?.totalShifts ?? 0;

    return Row(
      children: [
        Expanded(
          child: MetricCard(
            label: 'On-time Rate',
            value: '$onTimeRate%',
            footnote: '$onTimeCount / $totalWorkedShifts shifts',
          ),
        ),
        const MetricDivider(),
        Expanded(
          child: MetricCard(
            label: 'Completed Shifts',
            value: completedShifts.toString(),
            footnote: 'of $totalShifts total',
          ),
        ),
        const MetricDivider(),
        Expanded(
          child: MetricCard(
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
    final shifts = monthlyData != null
        ? _getFilteredShifts(monthlyData)
        : <EmployeeShiftRecord>[];

    final summary = monthlyData?.summary;
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildAttendanceTabs(unresolvedCount, resolvedCount, approvedCount),
        const SizedBox(height: TossSpacing.space3),
        _buildAttendanceContent(shifts),
      ],
    );
  }

  List<EmployeeShiftRecord> _getFilteredShifts(EmployeeMonthlyDetail data) {
    switch (_selectedAttendanceTab) {
      case 0:
        return data.getShiftsByFilter(ShiftFilterType.unresolved);
      case 1:
        return data.getShiftsByFilter(ShiftFilterType.resolved);
      case 2:
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
            child: AttendanceTab(
              title: 'Unresolved ($unresolvedCount)',
              isActive: _selectedAttendanceTab == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedAttendanceTab = 0);
              },
            ),
          ),
          Expanded(
            child: AttendanceTab(
              title: 'Resolved ($resolvedCount)',
              isActive: _selectedAttendanceTab == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedAttendanceTab = 1);
              },
            ),
          ),
          Expanded(
            child: AttendanceTab(
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
            .map((shift) => AttendanceCard(shift: shift))
            .toList(),
      ),
    );
  }

  Widget _buildRecentActivitySection(EmployeeMonthlyDetail? monthlyData) {
    final auditLogs = monthlyData?.auditLogs ?? [];

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
                  .take(10)
                  .map((log) => ActivityLogItem(log: log))
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

    final salaryAmount = salaryInfo?.salaryAmount ?? employee.salaryAmount;
    final totalBonus = summary?.totalBonus ?? 0;
    final unresolvedCount = summary?.unresolvedCount ?? 0;

    final formatter = NumberFormat('#,###');
    final currencySymbol = salaryInfo?.currencySymbol ?? '₫';

    // Use RPC calculated values (from v_shift_request view)
    final basePay = summary?.totalBasePay ?? 0;
    final totalPayment = summary?.totalPayment ?? 0;

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
        SalaryRow(
          label: 'Total confirmed time',
          value: summary?.formattedWorkedHours ?? '0h 0m',
        ),
        const SizedBox(height: 12),
        SalaryRow(
          label: 'Hourly salary',
          value: '${formatter.format(salaryAmount.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        Container(height: 1, color: TossColors.gray100),
        const SizedBox(height: 12),
        SalaryRow(
          label: 'Base pay',
          value: '${formatter.format(basePay.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        SalaryRow(
          label: 'Bonus pay',
          value: '${formatter.format(totalBonus.toInt())}$currencySymbol',
        ),
        const SizedBox(height: 12),
        SalaryRow(
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
        if (unresolvedCount > 0)
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
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
