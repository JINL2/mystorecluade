import 'package:flutter/material.dart';

import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/employee_profile_avatar.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_badge.dart';

/// Data model for leaderboard employee
class LeaderboardEmployee {
  final int rank;
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final int score;
  final double change;
  final bool isPositive;

  const LeaderboardEmployee({
    required this.rank,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    required this.score,
    required this.change,
    required this.isPositive,
  });
}

/// Reliability leaderboard section
///
/// Shows two tabs:
/// - Top reliability
/// - Needs attention
class StatsLeaderboard extends StatefulWidget {
  final List<LeaderboardEmployee> topReliabilityList;
  final List<LeaderboardEmployee> needsAttentionList;
  final VoidCallback onSeeAllTap;

  const StatsLeaderboard({
    super.key,
    required this.topReliabilityList,
    required this.needsAttentionList,
    required this.onSeeAllTap,
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
        ...currentList.map((employee) => _LeaderboardRow(
              employee: employee,
              isNeedsAttention: selectedTab == 1,
            )),

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
          onTap: widget.onSeeAllTap,
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

          // Score and change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                employee.score.toString(),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${employee.isPositive ? '+' : ''}${employee.change}',
                style: TossTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: employee.isPositive ? TossColors.primary : TossColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
