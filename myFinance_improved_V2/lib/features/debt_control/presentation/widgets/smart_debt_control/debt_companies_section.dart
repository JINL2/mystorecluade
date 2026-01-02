// lib/features/debt_control/presentation/widgets/smart_debt_control/debt_companies_section.dart

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/states/debt_control_state.dart';
import 'debt_company_card.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Debt Companies Section Widget
///
/// Displays the companies section with filter tabs and debt list.
class DebtCompaniesSection extends StatelessWidget {
  final DebtControlState state;
  final String currency;
  final String selectedCompaniesTab;
  final ValueChanged<String> onFilterChanged;

  const DebtCompaniesSection({
    super.key,
    required this.state,
    required this.currency,
    required this.selectedCompaniesTab,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        // Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space4,
              TossSpacing.space4,
              TossSpacing.space4,
              TossSpacing.space2,
            ),
            child: Text(
              'Companies',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Filter Tabs
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
            ),
            child: TossChipGroup(
              items: const [
                TossChipItem(value: 'all', label: 'All'),
                TossChipItem(
                    value: 'my_group', label: 'My Group', icon: Icons.people_outline),
                TossChipItem(
                    value: 'external', label: 'External', icon: Icons.public),
              ],
              selectedValue: selectedCompaniesTab,
              onChanged: (value) {
                if (value != null) {
                  onFilterChanged(value);
                }
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: TossSpacing.space3),
        ),

        // Debt List Content
        _buildDebtListContent(),
      ],
    );
  }

  Widget _buildDebtListContent() {
    // Show loading indicator while data is being fetched
    if (state.isLoadingDebts) {
      return const SliverFillRemaining(
        child: TossLoadingView(
          message: 'Loading debt records...',
        ),
      );
    }

    // Show data if available
    if (state.hasDebts) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final debt = state.debts[index];
            return DebtCompanyCard(
              key: ValueKey(debt.id),
              debt: debt,
              currency: currency,
            );
          },
          childCount: state.debts.length,
        ),
      );
    }

    // Show empty state only when loading is complete and no data
    return const SliverFillRemaining(
      child: TossEmptyView(
        title: 'No companies found',
        description: 'There are no debt records matching your criteria',
        icon: Icon(
          Icons.business_outlined,
          size: 64,
          color: TossColors.gray400,
        ),
      ),
    );
  }
}

/// Debt List Loading State Widget
class DebtListLoadingState extends StatelessWidget {
  const DebtListLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      child: TossLoadingView(
        message: 'Loading debt records...',
      ),
    );
  }
}

/// Debt List Error State Widget
class DebtListErrorState extends StatelessWidget {
  final Object error;

  const DebtListErrorState({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: TossEmptyView(
        title: 'Error loading data',
        description: error.toString(),
        icon: const Icon(
          Icons.error_outline,
          size: 64,
          color: TossColors.error,
        ),
      ),
    );
  }
}
