import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../providers/state/employee_monthly_detail_provider.dart';
import '../widgets/employee_detail/attendance_history_section.dart';
import '../widgets/employee_detail/employee_profile_header.dart';
import '../widgets/employee_detail/month_picker_sheet.dart';
import '../widgets/employee_detail/recent_activity_section.dart';
import '../widgets/employee_detail/salary_breakdown_section.dart';
import '../widgets/stats/stats_leaderboard.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/skeleton/toss_detail_skeleton.dart';

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
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    debugPrint('🟢 [EmployeeDetailPage] initState - employee: ${widget.employee.name}');
    _selectedMonth = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMonthlyData();
    });
  }

  @override
  void dispose() {
    debugPrint('🔴 [EmployeeDetailPage] dispose - employee: ${widget.employee.name}');
    super.dispose();
  }

  String get _yearMonth {
    return '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';
  }

  void _loadMonthlyData() {
    final userId = widget.employee.visitorId;
    debugPrint('📤 [EmployeeDetailPage] _loadMonthlyData called - userId: $userId, yearMonth: $_yearMonth');
    if (userId == null) {
      debugPrint('   ⚠️ userId is null, skipping load');
      return;
    }
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

    // 🔍 DEBUG: Log build state
    debugPrint('🔨 [EmployeeDetailPage] build - isLoading: ${state.isLoading}, hasData: ${monthlyData != null}, cacheKeys: ${state.dataByMonth.keys.toList()}');

    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: state.isLoading && monthlyData == null
          ? const TossDetailSkeleton(
              showHeader: true,
              showChart: false,
              sectionCount: 3,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: EmployeeProfileHeader(
                      employee: widget.employee,
                      monthlyData: monthlyData,
                    ),
                  ),
                  const GrayDividerSpace(),
                  AttendanceHistorySection(monthlyData: monthlyData),
                  const GrayDividerSpace(),
                  RecentActivitySection(monthlyData: monthlyData),
                  const GrayDividerSpace(),
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: SalaryBreakdownSection(
                      employee: widget.employee,
                      monthlyData: monthlyData,
                      selectedMonth: _selectedMonth,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space6),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return TossAppBar(
      title: '',
      backgroundColor: TossColors.white,
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: TossColors.gray600),
            onPressed: () => _changeMonth(-1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: TossDimensions.avatarMD, minHeight: TossDimensions.avatarMD),
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
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: TossSpacing.iconMD,
                  color: TossColors.primary,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: TossColors.gray600),
            onPressed: () => _changeMonth(1),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: TossDimensions.avatarMD, minHeight: TossDimensions.avatarMD),
          ),
        ],
      ),
    );
  }

  void _showMonthPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
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
}
