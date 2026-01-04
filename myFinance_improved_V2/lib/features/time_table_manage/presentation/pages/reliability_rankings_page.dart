import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/shared/themes/index.dart';

import '../widgets/stats/stats_leaderboard.dart';
import 'employee_detail_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Ranking criteria enum for filtering employees
enum RankingCriteria {
  reliability('Reliability', 'final_score'),
  needsAttention('Needs Attention', 'final_score'),
  lateFrequency('Late Frequency', 'late_rate'),
  noCheckInOut('No Check-In/Out', 'no_checkin_rate'),
  overtime('Overtime', 'overtime_minutes'),
  attendance('Attendance', 'total_applications');

  final String label;
  final String scoreKey;

  const RankingCriteria(this.label, this.scoreKey);
}

/// Reliability Rankings Page
///
/// Full page view showing employee reliability rankings with:
/// - This Store / Company level tabs
/// - Scrollable employee list with rankings
class ReliabilityRankingsPage extends ConsumerStatefulWidget {
  final String storeId;
  final List<LeaderboardEmployee> storeEmployees;
  final List<LeaderboardEmployee> companyEmployees;
  final int initialTab; // 0 = This Store, 1 = Company level
  final bool isNeedsAttention; // true = Needs attention (ascending), false = Top reliability (descending)

  const ReliabilityRankingsPage({
    super.key,
    required this.storeId,
    required this.storeEmployees,
    required this.companyEmployees,
    this.initialTab = 0,
    this.isNeedsAttention = false,
  });

  @override
  ConsumerState<ReliabilityRankingsPage> createState() =>
      _ReliabilityRankingsPageState();
}

class _ReliabilityRankingsPageState
    extends ConsumerState<ReliabilityRankingsPage> {
  late int selectedTab; // 0 = This Store, 1 = Company level
  late List<LeaderboardEmployee> displayedEmployees;
  late DateTime lastUpdated;
  late RankingCriteria selectedCriteria;

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    lastUpdated = DateTime.now();
    // Set initial criteria based on isNeedsAttention
    selectedCriteria = widget.isNeedsAttention
        ? RankingCriteria.needsAttention
        : RankingCriteria.reliability;
    _updateDisplayedEmployees();
  }

  void _updateDisplayedEmployees() {
    final sourceList =
        selectedTab == 0 ? widget.storeEmployees : widget.companyEmployees;

    // Sort by score based on selected criteria
    final sorted = List<LeaderboardEmployee>.from(sourceList);

    // Get sort value based on criteria
    double getSortValue(LeaderboardEmployee e) {
      switch (selectedCriteria) {
        case RankingCriteria.reliability:
          return e.finalScore;
        case RankingCriteria.needsAttention:
          return e.finalScore;
        case RankingCriteria.lateFrequency:
          return e.lateRateScore; // Higher score = better (less late)
        case RankingCriteria.noCheckInOut:
          return e.finalScore; // TODO: Add no check-in/out field when RPC provides it
        case RankingCriteria.overtime:
          return e.finalScore; // TODO: Add overtime field when RPC provides it
        case RankingCriteria.attendance:
          return e.applicationsScore; // Higher score = more applications
      }
    }

    // Get display score based on criteria
    int getDisplayScore(LeaderboardEmployee e) {
      switch (selectedCriteria) {
        case RankingCriteria.reliability:
        case RankingCriteria.needsAttention:
          return e.finalScore.round();
        case RankingCriteria.lateFrequency:
          return e.lateRateScore.round();
        case RankingCriteria.noCheckInOut:
          return e.finalScore.round();
        case RankingCriteria.overtime:
          return e.finalScore.round();
        case RankingCriteria.attendance:
          return e.applicationsScore.round();
      }
    }

    // Determine sort direction based on criteria
    // needsAttention: ascending (lowest first)
    // Others: descending (highest first)
    final isAscending = selectedCriteria == RankingCriteria.needsAttention;

    if (isAscending) {
      sorted.sort((a, b) => getSortValue(a).compareTo(getSortValue(b)));
    } else {
      sorted.sort((a, b) => getSortValue(b).compareTo(getSortValue(a)));
    }

    displayedEmployees = sorted.asMap().entries.map((entry) {
      final employee = entry.value;
      return employee.copyWith(
        rank: entry.key + 1,
        score: getDisplayScore(employee),
        isPositive: !isAscending,
      );
    }).toList();
  }

  bool get _isNeedsAttentionMode =>
      selectedCriteria == RankingCriteria.needsAttention;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Title header (below app bar)
          _buildTitleHeader(),

          // Level tabs (This Store / Company level)
          _buildLevelTabs(),

          const SizedBox(height: TossSpacing.space3),

          // Employee list
          Expanded(
            child: _buildEmployeeList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return const TossAppBar(
      title: '',
      backgroundColor: TossColors.white,
    );
  }

  Widget _buildTitleHeader() {
    final timeStr = DateFormat('HH:mm').format(lastUpdated);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _showCriteriaBottomSheet,
            child: Row(
              children: [
                Text(
                  selectedCriteria.label,
                  style: TossTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: TossColors.gray600,
                  size: 20,
                ),
              ],
            ),
          ),
          Text(
            'Updated $timeStr',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCriteriaBottomSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _RankingCriteriaBottomSheet(
        selectedCriteria: selectedCriteria,
        onCriteriaSelected: (criteria) {
          Navigator.pop(context);
          setState(() {
            selectedCriteria = criteria;
            _updateDisplayedEmployees();
          });
        },
      ),
    );
  }

  Widget _buildLevelTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: TossColors.gray200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _LevelTab(
              title: 'This store',
              isActive: selectedTab == 0,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedTab = 0;
                  _updateDisplayedEmployees();
                });
              },
            ),
          ),
          Expanded(
            child: _LevelTab(
              title: 'Company level',
              isActive: selectedTab == 1,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedTab = 1;
                  _updateDisplayedEmployees();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    if (displayedEmployees.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'No employees found',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      itemCount: displayedEmployees.length,
      itemBuilder: (context, index) {
        final employee = displayedEmployees[index];
        return _RankingRow(
          employee: employee,
          isNeedsAttention: _isNeedsAttentionMode,
          onTap: () => _navigateToEmployeeDetail(employee),
        );
      },
    );
  }

  void _navigateToEmployeeDetail(LeaderboardEmployee employee) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => EmployeeDetailPage(
          employee: employee,
          storeId: widget.storeId,
        ),
      ),
    );
  }
}

/// Level tab widget (This Store / Company level)
class _LevelTab extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _LevelTab({
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
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? TossColors.primary : TossColors.transparent,
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

/// Ranking row widget showing employee info with score and change
class _RankingRow extends StatelessWidget {
  final LeaderboardEmployee employee;
  final bool isNeedsAttention;
  final VoidCallback? onTap;

  const _RankingRow({
    required this.employee,
    this.isNeedsAttention = false,
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
          padding: const EdgeInsets.only(bottom: TossSpacing.space5),
          child: Row(
            children: [
              // Rank number (red for needs attention, blue for top reliability)
              SizedBox(
                width: 28,
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
                size: 48,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Score and change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    employee.score.toString(),
                    style: TossTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (employee.change != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${employee.change! >= 0 ? '+' : ''}${employee.change}',
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w500,
                        color: employee.change! >= 0
                            ? TossColors.primary
                            : TossColors.error,
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

/// Bottom sheet for selecting ranking criteria
class _RankingCriteriaBottomSheet extends StatelessWidget {
  final RankingCriteria selectedCriteria;
  final void Function(RankingCriteria) onCriteriaSelected;

  const _RankingCriteriaBottomSheet({
    required this.selectedCriteria,
    required this.onCriteriaSelected,
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

          // Title with close button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40), // Spacer for centering
                Text(
                  'Reliability Rankings',
                  style: TossTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.close,
                    color: TossColors.gray600,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: TossColors.gray200),

          // Criteria list
          ...RankingCriteria.values.map((criteria) {
            final isSelected = criteria == selectedCriteria;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onCriteriaSelected(criteria);
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      criteria.label,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? TossColors.primary : TossColors.gray900,
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        color: TossColors.primary,
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: TossSpacing.space4),
        ],
      ),
    );
  }
}
