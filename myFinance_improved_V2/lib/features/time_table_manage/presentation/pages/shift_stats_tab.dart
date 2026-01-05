import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/reliability_score.dart';
import '../providers/state/manager_shift_cards_provider.dart';
import '../providers/state/reliability_score_provider.dart';
import '../providers/states/time_table_state.dart';
import '../widgets/stats/helpers/stats_format_helpers.dart';
import '../widgets/stats/helpers/stats_problem_calculator.dart';
import '../widgets/stats/period_selector_bottom_sheet.dart';
import '../widgets/stats/stats_gauge_card.dart';
import '../widgets/stats/stats_leaderboard.dart';
import '../widgets/stats/stats_metric_row.dart';
import 'employee_detail_page.dart';
import 'reliability_rankings_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Period options for Store Health section
enum StatsPeriod {
  today('Today'),
  thisMonth('This Month'),
  lastMonth('Last Month');

  final String label;
  const StatsPeriod(this.label);
}

/// Stats Tab for Shift Management
///
/// This is the 4th tab in the Shift Management screen.
/// Shows store health metrics, gauges, and reliability leaderboard.
class ShiftStatsTab extends ConsumerStatefulWidget {
  final String? selectedStoreId;
  final void Function(String storeId)? onStoreChanged;
  /// Callback to navigate to Timesheets tab with a specific filter
  final void Function(String filter)? onNavigateToTimesheets;

  const ShiftStatsTab({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
    this.onNavigateToTimesheets,
  });

  @override
  ConsumerState<ShiftStatsTab> createState() => _ShiftStatsTabState();
}

class _ShiftStatsTabState extends ConsumerState<ShiftStatsTab> {
  StatsPeriod selectedPeriod = StatsPeriod.thisMonth;

  @override
  Widget build(BuildContext context) {
    final storeId = widget.selectedStoreId ?? '';

    // Watch reliability score data
    final reliabilityAsync = storeId.isNotEmpty
        ? ref.watch(reliabilityScoreProvider(storeId))
        : const AsyncValue<ReliabilityScore>.loading();

    // Watch manager shift cards to get employees with actual work history
    final managerCardsState = storeId.isNotEmpty
        ? ref.watch(managerCardsProvider(storeId))
        : const ManagerShiftCardsState();

    // Extract employee UUIDs from shift cards (employees with actual work history this month)
    final currentMonthKey = StatsFormatHelpers.getCurrentMonthKey();

    // Ensure current month data is loaded
    if (storeId.isNotEmpty) {
      final notifier = ref.read(managerCardsProvider(storeId).notifier);
      if (!managerCardsState.dataByMonth.containsKey(currentMonthKey)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.loadMonth(month: DateTime.now());
        });
      }
    }

    final employeesWithWorkHistory = StatsProblemCalculator.extractEmployeeIdsFromCards(
      managerCardsState,
      currentMonthKey,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector (same as Timesheets tab)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space3,
              TossSpacing.space2,
              TossSpacing.space3,
              TossSpacing.space4,
            ),
            child: _buildStoreSelector(),
          ),

          // Section Divider (full width)
          const GrayDividerSpace(),

          // Store Health Section - Connected to real data
          reliabilityAsync.when(
            data: (score) => _buildStoreHealthSection(score),
            loading: () => _buildLoadingSection(),
            error: (error, stack) => _buildErrorSection(error.toString()),
          ),

          const SizedBox(height: 16),

          // Section Divider (full width)
          const GrayDividerSpace(),

          const SizedBox(height: 16),

          // Reliability Leaderboard - Connected to real data
          // Leaderboard shows only Store employees, See All shows Company employees
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: reliabilityAsync.when(
              data: (score) {
                // Get current store name for employee detail display
                final currentStoreName = _getStoreName(storeId);

                // Filter employees by work history (employees with actual shifts this month)
                final storeEmployees = employeesWithWorkHistory.isEmpty
                    ? score.employees // If no work history filter, show all
                    : score.employees
                        .where((e) => employeesWithWorkHistory.contains(e.userId))
                        .toList();

                // Get filtered top reliability (store employees only)
                final filteredTopReliability = storeEmployees.isEmpty
                    ? <EmployeeReliability>[]
                    : () {
                        final sorted = List<EmployeeReliability>.from(storeEmployees);
                        sorted.sort((a, b) => b.finalScore.compareTo(a.finalScore));
                        return sorted.take(3).toList();
                      }();

                // Get filtered needs attention (store employees only)
                final filteredNeedsAttention = storeEmployees.isEmpty
                    ? <EmployeeReliability>[]
                    : () {
                        final sorted = List<EmployeeReliability>.from(storeEmployees);
                        sorted.sort((a, b) => a.finalScore.compareTo(b.finalScore));
                        return sorted.where((e) => e.finalScore < 80).take(3).toList();
                      }();

                // Prepare employee lists for the rankings page
                final storeEmployeesList = _mapToLeaderboardEmployees(
                  storeEmployees,
                  isNeedsAttention: false,
                  storeName: currentStoreName,
                );
                final companyEmployeesList = _mapToLeaderboardEmployees(
                  score.employees,
                  isNeedsAttention: false,
                );

                return StatsLeaderboard(
                  // Leaderboard shows Store employees only
                  topReliabilityList: _mapToLeaderboardEmployees(
                    filteredTopReliability,
                    isNeedsAttention: false,
                    storeName: currentStoreName,
                  ),
                  needsAttentionList: _mapToLeaderboardEmployees(
                    filteredNeedsAttention,
                    isNeedsAttention: true,
                    storeName: currentStoreName,
                  ),
                  // This list is used for "See All" - pass company employees
                  allEmployeesList: companyEmployeesList,
                  // Navigate to employee detail page when tapped
                  onEmployeeTap: (employee) {
                    debugPrint('👆 [ShiftStatsTab] Employee tapped - navigating to detail: ${employee.name}');
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => EmployeeDetailPage(
                          employee: employee,
                          storeId: storeId,
                        ),
                      ),
                    ).then((_) {
                      debugPrint('⬅️ [ShiftStatsTab] Returned from EmployeeDetailPage');
                    });
                  },
                  // Navigate to new page with current tab info
                  onSeeAllTapWithTab: (selectedTab) {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ReliabilityRankingsPage(
                          storeId: storeId,
                          storeEmployees: storeEmployeesList,
                          companyEmployees: companyEmployeesList,
                          initialTab: 0, // Start with "This Store" tab
                          isNeedsAttention: selectedTab == 1, // 1 = Needs attention
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: TossLoadingView(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Failed to load leaderboard',
                  style: TossTextStyles.body.copyWith(color: TossColors.error),
                ),
              ),
            ),
          ),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  /// Build store health section with real data
  Widget _buildStoreHealthSection(ReliabilityScore score) {
    final summary = score.shiftSummary;
    final understaffed = score.understaffedShifts;

    // Get period-specific data based on selected period
    final (currentPeriod, previousPeriod, currentUnderstaffed, previousUnderstaffed) =
        _getPeriodData(summary, understaffed);

    // Calculate on-time rate using totalShifts from RPC
    // On-time rate = (total shifts - late shifts) / total shifts
    final totalShifts = currentPeriod.totalShifts;
    final onTimeRate = totalShifts > 0
        ? (totalShifts - currentPeriod.lateCount) / totalShifts
        : 1.0;
    final onTimeDisplay = '${(onTimeRate * 100).toStringAsFixed(0)}%';

    // Problem counts from problem_details_v2 (not from RPC)
    // This ensures consistency with Problems tab
    final storeId = widget.selectedStoreId ?? '';
    final managerCardsState = storeId.isNotEmpty
        ? ref.watch(managerCardsProvider(storeId))
        : const ManagerShiftCardsState();
    final (problemUnsolved, problemSolved) =
        StatsProblemCalculator.getProblemCountsFromCards(
      managerCardsState,
      selectedPeriod,
    );

    // Calculate changes (current period vs previous period)
    final lateChange = currentPeriod.lateCount - previousPeriod.lateCount;
    final understaffedChange = currentUnderstaffed - previousUnderstaffed;
    final otChange = currentPeriod.overtimeAmountSum - previousPeriod.overtimeAmountSum;

    // Total problems = unsolved + solved
    final totalProblems = problemUnsolved + problemSolved;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space3,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gauges
          StatsGaugeCard(
            selectedPeriod: selectedPeriod.label,
            onPeriodTap: () => _showPeriodSelector(context),
            onTimeRate: onTimeRate,
            onTimeDisplay: onTimeDisplay,
            problemSolved: problemSolved,
            totalProblems: totalProblems > 0 ? totalProblems : 1, // Avoid division by zero
            onProblemSolvesTap: () {
              // Navigate to Timesheets tab with "This month" filter
              widget.onNavigateToTimesheets?.call('this_month');
            },
          ),
          const SizedBox(height: 16),

          // Hero Stats with real data
          StatsMetricRow(
            lateShifts: currentPeriod.lateCount.toString(),
            lateShiftsChange: StatsFormatHelpers.formatChange(lateChange),
            lateShiftsIsNegative: lateChange > 0, // Increase in late is negative
            understaffedShifts: currentUnderstaffed.toString(),
            understaffedShiftsChange: StatsFormatHelpers.formatChange(understaffedChange),
            understaffedIsNegative: understaffedChange > 0, // Increase is negative
            otHours: StatsFormatHelpers.formatOvertimeHours(currentPeriod.overtimeAmountSum),
            otHoursChange: StatsFormatHelpers.formatOvertimeChange(otChange),
            otHoursIsNegative: otChange > 0, // Increase in OT is negative
          ),
        ],
      ),
    );
  }

  /// Get period-specific data based on selected period
  /// Returns (currentPeriod, previousPeriod, currentUnderstaffed, previousUnderstaffed)
  (PeriodStats, PeriodStats, int, int) _getPeriodData(
    ShiftSummary summary,
    UnderstaffedShifts understaffed,
  ) {
    switch (selectedPeriod) {
      case StatsPeriod.today:
        return (
          summary.today,
          summary.yesterday,
          understaffed.today,
          understaffed.yesterday,
        );
      case StatsPeriod.thisMonth:
        return (
          summary.thisMonth,
          summary.lastMonth,
          understaffed.thisMonth,
          understaffed.lastMonth,
        );
      case StatsPeriod.lastMonth:
        return (
          summary.lastMonth,
          summary.twoMonthsAgo,
          understaffed.lastMonth,
          understaffed.twoMonthsAgo,
        );
    }
  }

  /// Show period selector bottom sheet
  void _showPeriodSelector(BuildContext context) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<StatsPeriod>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PeriodSelectorBottomSheet(
        selectedPeriod: selectedPeriod,
        onPeriodSelected: (period) {
          Navigator.pop(context);
          if (period != selectedPeriod) {
            HapticFeedback.selectionClick();
            setState(() {
              selectedPeriod = period;
            });
          }
        },
      ),
    );
  }

  /// Build loading section
  Widget _buildLoadingSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space6,
      ),
      child: TossLoadingView(),
    );
  }

  /// Build error section
  Widget _buildErrorSection(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space4,
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: TossColors.error, size: 48),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Failed to load store health data',
              style: TossTextStyles.body.copyWith(color: TossColors.error),
            ),
          ],
        ),
      ),
    );
  }

  /// Get store name from store ID
  String _getStoreName(String storeId) {
    final appState = ref.read(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    for (final company in companies) {
      final companyMap = company as Map<String, dynamic>;
      final stores = (companyMap['stores'] as List<dynamic>?) ?? [];
      for (final store in stores) {
        final storeMap = store as Map<String, dynamic>;
        if (storeMap['store_id']?.toString() == storeId) {
          return storeMap['store_name']?.toString() ?? '';
        }
      }
    }
    return '';
  }

  /// Map EmployeeReliability to LeaderboardEmployee
  List<LeaderboardEmployee> _mapToLeaderboardEmployees(
    List<EmployeeReliability> employees, {
    required bool isNeedsAttention,
    String? storeName,
  }) {
    return employees.asMap().entries.map((entry) {
      final index = entry.key;
      final employee = entry.value;

      return LeaderboardEmployee(
        rank: index + 1,
        name: employee.employeeName,
        subtitle: employee.subtitle,
        avatarUrl: employee.avatarUrl,
        score: employee.reliabilityScore,
        // change is not provided by RPC - only show if historical data becomes available
        change: null,
        isPositive: !isNeedsAttention,
        // Employee info for detail page
        visitorId: employee.userId,
        role: employee.role,
        storeName: employee.storeName ?? storeName,
        // Score breakdown fields for criteria-based filtering
        finalScore: employee.finalScore,
        lateRate: employee.lateRate,
        lateRateScore: employee.lateRateScore,
        totalApplications: employee.totalApplications,
        applicationsScore: employee.applicationsScore,
        avgLateMinutes: employee.avgLateMinutes,
        lateMinutesScore: employee.lateMinutesScore,
        fillRate: employee.avgFillRateApplied,
        fillRateScore: employee.fillRateScore,
        lateCount: employee.lateCount,
        salaryAmount: employee.salaryAmount,
        salaryType: employee.salaryType,
        completedShifts: employee.completedShifts,
      );
    }).toList();
  }

  /// Build store selector dropdown
  Widget _buildStoreSelector() {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    // Get stores from selected company only (no fallback to prevent showing wrong company's stores)
    List<dynamic> stores = [];
    if (companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
      for (final company in companies) {
        final companyMap = company as Map<String, dynamic>;
        if (companyMap['company_id']?.toString() == appState.companyChoosen) {
          stores = (companyMap['stores'] as List<dynamic>?) ?? [];
          break;
        }
      }
    }

    final storeItems = stores.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return TossDropdownItem<String>(
        value: storeMap['store_id']?.toString() ?? '',
        label: storeMap['store_name']?.toString() ?? 'Unknown',
      );
    }).toList();

    return TossDropdown<String>(
      label: 'Store',
      value: widget.selectedStoreId,
      items: storeItems,
      onChanged: (newValue) {
        if (newValue != null && newValue != widget.selectedStoreId) {
          widget.onStoreChanged?.call(newValue);
        }
      },
    );
  }
}
