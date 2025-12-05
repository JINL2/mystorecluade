import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';

/// Data model for leaderboard employee
class LeaderboardEmployee {
  final int rank;
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final int score; // Main display score (changes based on selected criteria)
  final double? change; // Optional - only shown if RPC provides historical data
  final bool isPositive;

  // Individual scores for different ranking criteria
  final double finalScore; // Overall reliability score
  final double lateRate; // Late rate percentage
  final double lateRateScore; // Late rate score (0-100)
  final int totalApplications; // Total shift applications
  final double applicationsScore; // Applications score (0-100)
  final double avgLateMinutes; // Average late minutes
  final double lateMinutesScore; // Late minutes score (0-100)
  final double fillRate; // Fill rate percentage
  final double fillRateScore; // Fill rate score (0-100)
  final int lateCount; // Number of late shifts
  // Salary fields for payroll calculation
  final double salaryAmount; // Salary amount from user_salaries
  final String? salaryType; // 'hourly' or 'monthly'
  final int completedShifts; // Number of completed shifts for payroll calc

  const LeaderboardEmployee({
    required this.rank,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    required this.score,
    this.change, // Optional
    required this.isPositive,
    this.finalScore = 0,
    this.lateRate = 0,
    this.lateRateScore = 0,
    this.totalApplications = 0,
    this.applicationsScore = 0,
    this.avgLateMinutes = 0,
    this.lateMinutesScore = 0,
    this.fillRate = 0,
    this.fillRateScore = 0,
    this.lateCount = 0,
    this.salaryAmount = 0,
    this.salaryType,
    this.completedShifts = 0,
  });

  /// Create a copy with updated rank and score for different criteria
  LeaderboardEmployee copyWith({
    int? rank,
    String? name,
    String? subtitle,
    String? avatarUrl,
    int? score,
    double? change,
    bool? isPositive,
    double? finalScore,
    double? lateRate,
    double? lateRateScore,
    int? totalApplications,
    double? applicationsScore,
    double? avgLateMinutes,
    double? lateMinutesScore,
    double? fillRate,
    double? fillRateScore,
    int? lateCount,
    double? salaryAmount,
    String? salaryType,
    int? completedShifts,
  }) {
    return LeaderboardEmployee(
      rank: rank ?? this.rank,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      score: score ?? this.score,
      change: change ?? this.change,
      isPositive: isPositive ?? this.isPositive,
      finalScore: finalScore ?? this.finalScore,
      lateRate: lateRate ?? this.lateRate,
      lateRateScore: lateRateScore ?? this.lateRateScore,
      totalApplications: totalApplications ?? this.totalApplications,
      applicationsScore: applicationsScore ?? this.applicationsScore,
      avgLateMinutes: avgLateMinutes ?? this.avgLateMinutes,
      lateMinutesScore: lateMinutesScore ?? this.lateMinutesScore,
      fillRate: fillRate ?? this.fillRate,
      fillRateScore: fillRateScore ?? this.fillRateScore,
      lateCount: lateCount ?? this.lateCount,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      salaryType: salaryType ?? this.salaryType,
      completedShifts: completedShifts ?? this.completedShifts,
    );
  }
}

/// Reliability leaderboard section
///
/// Shows two tabs:
/// - Top reliability
/// - Needs attention
class StatsLeaderboard extends StatefulWidget {
  final List<LeaderboardEmployee> topReliabilityList;
  final List<LeaderboardEmployee> needsAttentionList;
  final List<LeaderboardEmployee> allEmployeesList; // Full list for "See all"
  final VoidCallback? onSeeAllTap; // Optional callback for custom handling (deprecated)
  final void Function(int selectedTab)? onSeeAllTapWithTab; // Callback with current tab index

  const StatsLeaderboard({
    super.key,
    required this.topReliabilityList,
    required this.needsAttentionList,
    required this.allEmployeesList,
    this.onSeeAllTap,
    this.onSeeAllTapWithTab,
  });

  @override
  State<StatsLeaderboard> createState() => _StatsLeaderboardState();
}

class _StatsLeaderboardState extends State<StatsLeaderboard> {
  int selectedTab = 0; // 0 = Top reliability, 1 = Needs attention

  @override
  Widget build(BuildContext context) {
    final currentList =
        selectedTab == 0 ? widget.topReliabilityList : widget.needsAttentionList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Reliability leaderboard',
          style: TossTextStyles.titleMedium,
        ),
        const SizedBox(height: TossSpacing.space4),

        // Tabs
        _buildTabs(),
        const SizedBox(height: TossSpacing.space5),

        // Employee list
        ...currentList.map(
          (employee) => _LeaderboardRow(
            employee: employee,
            isNeedsAttention: selectedTab == 1,
          ),
        ),

        // See all button
        _buildSeeAllButton(),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _LeaderboardTab(
              title: 'Top reliability',
              isActive: selectedTab == 0,
              onTap: () => setState(() => selectedTab = 0),
            ),
          ),
          Expanded(
            child: _LeaderboardTab(
              title: 'Needs attention',
              isActive: selectedTab == 1,
              onTap: () => setState(() => selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeeAllButton() {
    return Column(
      children: [
        const Divider(height: 1, color: TossColors.gray200),
        GestureDetector(
          onTap: () {
            // Use callback with tab info if provided
            if (widget.onSeeAllTapWithTab != null) {
              widget.onSeeAllTapWithTab!(selectedTab);
            } else if (widget.onSeeAllTap != null) {
              widget.onSeeAllTap!();
            } else {
              _showAllEmployeesBottomSheet();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
            child: Text(
              'See all',
              textAlign: TextAlign.center,
              style: TossTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAllEmployeesBottomSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AllEmployeesBottomSheet(
        employees: widget.allEmployeesList,
        initialTab: selectedTab,
      ),
    );
  }
}

/// Individual tab for leaderboard
class _LeaderboardTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _LeaderboardTab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            color: isActive ? TossColors.gray900 : TossColors.gray600,
          ),
        ),
      ),
    );
  }
}

/// Individual leaderboard row showing employee info
class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEmployee employee;
  final bool isNeedsAttention;

  const _LeaderboardRow({
    required this.employee,
    required this.isNeedsAttention,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space6),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 24,
            child: Text(
              employee.rank.toString(),
              textAlign: TextAlign.center,
              style: TossTextStyles.body.copyWith(
                color: isNeedsAttention ? TossColors.error : TossColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Avatar
          EmployeeProfileAvatar(
            imageUrl: employee.avatarUrl,
            name: employee.name,
            size: 44,
            showBorder: true,
            borderColor: TossColors.gray200,
          ),
          const SizedBox(width: TossSpacing.space3),

          // Name and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: TossTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  employee.subtitle,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ),

          // Score and change (if available)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                employee.score.toString(),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Only show change if RPC provides historical data
              if (employee.change != null) ...[
                const SizedBox(height: 2),
                Text(
                  '${employee.isPositive ? '+' : ''}${employee.change}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w500,
                    color: employee.isPositive ? TossColors.primary : TossColors.error,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet showing all employees sorted by reliability
class _AllEmployeesBottomSheet extends StatefulWidget {
  final List<LeaderboardEmployee> employees;
  final int initialTab; // 0 = Top reliability (descending), 1 = Needs attention (ascending)

  const _AllEmployeesBottomSheet({
    required this.employees,
    required this.initialTab,
  });

  @override
  State<_AllEmployeesBottomSheet> createState() => _AllEmployeesBottomSheetState();
}

class _AllEmployeesBottomSheetState extends State<_AllEmployeesBottomSheet> {
  late int selectedTab;
  late List<LeaderboardEmployee> sortedEmployees;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    _sortEmployees();
  }

  void _sortEmployees() {
    sortedEmployees = List.from(widget.employees);
    if (selectedTab == 0) {
      // Top reliability: highest score first (descending)
      sortedEmployees.sort((a, b) => b.score.compareTo(a.score));
    } else {
      // Needs attention: lowest score first (ascending)
      sortedEmployees.sort((a, b) => a.score.compareTo(b.score));
    }
    // Update rank based on sorted position
    sortedEmployees = sortedEmployees.asMap().entries.map((entry) {
      return LeaderboardEmployee(
        rank: entry.key + 1,
        name: entry.value.name,
        subtitle: entry.value.subtitle,
        avatarUrl: entry.value.avatarUrl,
        score: entry.value.score,
        change: entry.value.change,
        isPositive: selectedTab == 0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
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
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Employees',
                    style: TossTextStyles.titleMedium,
                  ),
                  Text(
                    '${sortedEmployees.length} employees',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: TossColors.gray200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _LeaderboardTab(
                        title: 'Top reliability',
                        isActive: selectedTab == 0,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            selectedTab = 0;
                            _sortEmployees();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _LeaderboardTab(
                        title: 'Needs attention',
                        isActive: selectedTab == 1,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            selectedTab = 1;
                            _sortEmployees();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            // Employee list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                itemCount: sortedEmployees.length,
                itemBuilder: (context, index) {
                  return _LeaderboardRow(
                    employee: sortedEmployees[index],
                    isNeedsAttention: selectedTab == 1,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
