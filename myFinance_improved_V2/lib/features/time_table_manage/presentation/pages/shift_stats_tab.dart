import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/gray_divider_space.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_dropdown.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../domain/entities/reliability_score.dart';
import '../providers/state/reliability_score_provider.dart';
import '../providers/state/store_employees_provider.dart';
import '../widgets/stats/stats_gauge_card.dart';
import '../widgets/stats/stats_leaderboard.dart';
import '../widgets/stats/stats_metric_row.dart';

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

  const ShiftStatsTab({
    super.key,
    this.selectedStoreId,
    this.onStoreChanged,
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

    // Watch store employee user IDs for filtering leaderboard
    final storeEmployeeIdsAsync = storeId.isNotEmpty
        ? ref.watch(storeEmployeeUserIdsProvider(storeId))
        : const AsyncValue<Set<String>>.data({});

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

          const SizedBox(height: 32),

          // Store Health Section - Connected to real data
          reliabilityAsync.when(
            data: (score) => _buildStoreHealthSection(score),
            loading: () => _buildLoadingSection(),
            error: (error, stack) => _buildErrorSection(error.toString()),
          ),

          const SizedBox(height: 24),

          // Section Divider (full width)
          const GrayDividerSpace(),

          const SizedBox(height: 24),

          // Reliability Leaderboard - Connected to real data
          // Leaderboard shows only Store employees, See All shows Company employees
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: reliabilityAsync.when(
              data: (score) {
                // Get store employee IDs for filtering
                final storeEmployeeIds = storeEmployeeIdsAsync.valueOrNull ?? {};

                // Filter employees by store (for leaderboard display)
                final storeEmployees = storeEmployeeIds.isEmpty
                    ? score.employees // If no store filter, show all
                    : score.employees
                        .where((e) => storeEmployeeIds.contains(e.userId))
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

                return StatsLeaderboard(
                  // Leaderboard shows Store employees only
                  topReliabilityList: _mapToLeaderboardEmployees(
                    filteredTopReliability,
                    isNeedsAttention: false,
                  ),
                  needsAttentionList: _mapToLeaderboardEmployees(
                    filteredNeedsAttention,
                    isNeedsAttention: true,
                  ),
                  // See All bottom sheet shows ALL Company employees (unfiltered)
                  allEmployeesList: _mapToLeaderboardEmployees(
                    score.employees,
                    isNeedsAttention: false,
                  ),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(TossSpacing.space4),
                  child: CircularProgressIndicator(),
                ),
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

    // Problem solved count and total
    final problemSolved = currentPeriod.problemSolvedCount;
    final totalProblems = currentPeriod.problemCount;

    // Calculate changes (current period vs previous period)
    final lateChange = currentPeriod.lateCount - previousPeriod.lateCount;
    final understaffedChange = currentUnderstaffed - previousUnderstaffed;
    final otChange = currentPeriod.overtimeAmountSum - previousPeriod.overtimeAmountSum;

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
          ),
          const SizedBox(height: 16),

          // Hero Stats with real data
          StatsMetricRow(
            lateShifts: currentPeriod.lateCount.toString(),
            lateShiftsChange: _formatChange(lateChange),
            lateShiftsIsNegative: lateChange > 0, // Increase in late is negative
            understaffedShifts: currentUnderstaffed.toString(),
            understaffedShiftsChange: _formatChange(understaffedChange),
            understaffedIsNegative: understaffedChange > 0, // Increase is negative
            otHours: _formatOvertimeHours(currentPeriod.overtimeAmountSum),
            otHoursChange: _formatOvertimeChange(otChange),
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
      builder: (context) => _PeriodSelectorBottomSheet(
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

  /// Format change value with + or - prefix
  String _formatChange(int change) {
    if (change == 0) return '0';
    return change > 0 ? '+$change' : '$change';
  }

  /// Format overtime hours
  String _formatOvertimeHours(double hours) {
    if (hours == 0) return '0h';
    return '${hours.toStringAsFixed(1)}h';
  }

  /// Format overtime change
  String _formatOvertimeChange(double change) {
    if (change == 0) return '0h';
    final prefix = change > 0 ? '+' : '';
    return '$prefix${change.toStringAsFixed(1)}h';
  }

  /// Build loading section
  Widget _buildLoadingSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space6,
      ),
      child: Center(child: CircularProgressIndicator()),
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

  /// Map EmployeeReliability to LeaderboardEmployee
  List<LeaderboardEmployee> _mapToLeaderboardEmployees(
    List<EmployeeReliability> employees, {
    required bool isNeedsAttention,
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
      );
    }).toList();
  }

  /// Build store selector dropdown
  Widget _buildStoreSelector() {
    final appState = ref.watch(appStateProvider);
    final userData = appState.user;
    final companies = (userData['companies'] as List<dynamic>?) ?? [];

    // Get stores from selected company
    List<dynamic> stores = [];
    if (companies.isNotEmpty) {
      try {
        final selectedCompany = companies.firstWhere(
          (c) =>
              (c as Map<String, dynamic>)['company_id'] ==
              appState.companyChoosen,
        ) as Map<String, dynamic>;
        stores = (selectedCompany['stores'] as List<dynamic>?) ?? [];
      } catch (e) {
        if (companies.isNotEmpty) {
          final firstCompany = companies.first as Map<String, dynamic>;
          stores = (firstCompany['stores'] as List<dynamic>?) ?? [];
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

/// Period selector bottom sheet widget
class _PeriodSelectorBottomSheet extends StatelessWidget {
  final StatsPeriod selectedPeriod;
  final void Function(StatsPeriod) onPeriodSelected;

  const _PeriodSelectorBottomSheet({
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            child: Text(
              'Select Period',
              style: TossTextStyles.titleMedium,
            ),
          ),
          // Period options
          ...StatsPeriod.values.map((period) => _buildPeriodOption(period)),
          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }

  Widget _buildPeriodOption(StatsPeriod period) {
    final isSelected = period == selectedPeriod;

    return InkWell(
      onTap: () => onPeriodSelected(period),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? TossColors.primary.withValues(alpha: 0.12)
                    : TossColors.gray100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 20,
                color: isSelected ? TossColors.primary : TossColors.gray500,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                period.label,
                style: TossTextStyles.body.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? TossColors.gray900 : TossColors.gray700,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                size: 20,
                color: TossColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
