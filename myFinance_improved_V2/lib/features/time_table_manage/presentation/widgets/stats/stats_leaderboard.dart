import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../../../domain/entities/leaderboard_employee.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/sheets/toss_bottom_sheet.dart';

export '../../../domain/entities/leaderboard_employee.dart';

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
  final void Function(LeaderboardEmployee employee)? onEmployeeTap; // Callback when employee is tapped

  const StatsLeaderboard({
    super.key,
    required this.topReliabilityList,
    required this.needsAttentionList,
    required this.allEmployeesList,
    this.onSeeAllTap,
    this.onSeeAllTapWithTab,
    this.onEmployeeTap,
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
            onTap: widget.onEmployeeTap != null
                ? () => widget.onEmployeeTap!(employee)
                : null,
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
                fontWeight: TossFontWeight.medium,
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
    TossBottomSheet.showWithBuilder<void>(
      context: context,
      isScrollControlled: true,
      heightFactor: 0.9,
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
              color: isActive ? TossColors.primary : TossColors.transparent,
              width: TossSpacing.space0_5 + 1, // 3px tab indicator
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TossTextStyles.body.copyWith(
            fontWeight: TossFontWeight.semibold,
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
  final VoidCallback? onTap;

  const _LeaderboardRow({
    required this.employee,
    required this.isNeedsAttention,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Padding(
          padding: const EdgeInsets.only(bottom: TossSpacing.space6),
          child: Row(
            children: [
              // Rank number
              SizedBox(
                width: TossDimensions.rankBadgeSize,
                child: Text(
                  employee.rank.toString(),
                  textAlign: TextAlign.center,
                  style: TossTextStyles.body.copyWith(
                    color: isNeedsAttention ? TossColors.error : TossColors.primary,
                    fontWeight: TossFontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Avatar
              EmployeeProfileAvatar(
                imageUrl: employee.avatarUrl,
                name: employee.name,
                size: TossDimensions.avatarLG + 4, // 44px
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
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      employee.subtitle,
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: TossFontWeight.regular,
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
                      fontWeight: TossFontWeight.semibold,
                    ),
                  ),
                  // Only show change if RPC provides historical data
                  if (employee.change != null) ...[
                    const SizedBox(height: TossSpacing.space0_5),
                    Text(
                      '${employee.isPositive ? '+' : ''}${employee.change}',
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: TossFontWeight.medium,
                        color: employee.isPositive ? TossColors.primary : TossColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
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
              margin: EdgeInsets.only(
                top: TossSpacing.space3,
                bottom: TossSpacing.space2,
              ),
              width: TossDimensions.dragHandleWidth,
              height: TossDimensions.dragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
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
