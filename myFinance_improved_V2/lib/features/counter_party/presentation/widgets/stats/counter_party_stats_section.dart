import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';

import '../../../domain/entities/counter_party_stats.dart';
import 'toss_stats_card.dart';

/// Stats section widget for counter party page
class CounterPartyStatsSection extends StatelessWidget {
  final AsyncValue<CounterPartyStats> statsAsync;
  final VoidCallback onRetry;

  const CounterPartyStatsSection({
    super.key,
    required this.statsAsync,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: statsAsync.when(
          data: (stats) => TossStatsCard(
            title: 'Total Counterparties',
            totalCount: stats.total,
            items: [
              TossStatItem(
                label: 'My Company',
                count: stats.myCompanies,
                icon: Icons.business,
                color: TossColors.primary,
              ),
              TossStatItem(
                label: 'Team Member',
                count: stats.teamMembers,
                icon: Icons.group,
                color: TossColors.success,
              ),
              TossStatItem(
                label: 'Suppliers',
                count: stats.suppliers,
                icon: Icons.local_shipping,
                color: TossColors.info,
              ),
              TossStatItem(
                label: 'Employees',
                count: stats.employees,
                icon: Icons.badge,
                color: TossColors.warning,
              ),
              TossStatItem(
                label: 'Customers',
                count: stats.customers,
                icon: Icons.people,
                color: TossColors.error,
              ),
              TossStatItem(
                label: 'Others',
                count: stats.others,
                icon: Icons.category,
                color: TossColors.gray500,
              ),
            ],
            onRetry: onRetry,
          ),
          loading: () => const TossStatsCard(
            title: 'Total Counterparties',
            totalCount: 0,
            items: [],
            isLoading: true,
          ),
          error: (error, _) => TossStatsCard(
            title: 'Total Counterparties',
            totalCount: 0,
            items: const [],
            errorMessage: 'Failed to load statistics',
            onRetry: onRetry,
          ),
        ),
      ),
    );
  }
}
