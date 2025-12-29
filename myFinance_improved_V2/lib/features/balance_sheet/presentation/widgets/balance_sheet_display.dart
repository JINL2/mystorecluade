import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import 'balance_sheet_display/balance_sheet_display_widgets.dart';

/// Balance Sheet Display Widget
/// Refactored: 631 lines → ~130 lines
class BalanceSheetDisplay extends StatelessWidget {
  final Map<String, dynamic> balanceSheetData;
  final String currencySymbol;
  final VoidCallback onEdit;

  const BalanceSheetDisplay({
    super.key,
    required this.balanceSheetData,
    required this.currencySymbol,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final data = balanceSheetData['data'] as Map<String, dynamic>;
    final companyInfo = balanceSheetData['company_info'] as Map<String, dynamic>;
    final uiData = balanceSheetData['ui_data'] as Map<String, dynamic>;
    final totals = data['totals'] as Map<String, dynamic>;
    final parameters = balanceSheetData['parameters'] as Map<String, dynamic>;

    final currentAssets = data['current_assets'] as List;
    final nonCurrentAssets = data['non_current_assets'] as List;
    final currentLiabilities = data['current_liabilities'] as List;
    final nonCurrentLiabilities = data['non_current_liabilities'] as List;
    final equity = data['equity'] as List;
    final comprehensiveIncome = data['comprehensive_income'] as List;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Header with Store info
              BalanceSheetHeaderCard(
                companyInfo: companyInfo,
                parameters: parameters,
                onEdit: onEdit,
              ),

              // Balance Sheet Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                child: Column(
                  children: [
                    // Balance Verification Card
                    BalanceVerificationCard(
                      verification:
                          uiData['balance_verification'] as Map<String, dynamic>,
                      currencySymbol: currencySymbol,
                    ),
                    const SizedBox(height: TossSpacing.space4),

                    // Summary Cards
                    BalanceSheetSummaryCards(
                      totals: totals,
                      currencySymbol: currencySymbol,
                    ),
                    const SizedBox(height: TossSpacing.space6),

                    // Assets Section
                    if (currentAssets.isNotEmpty ||
                        nonCurrentAssets.isNotEmpty) ...[
                      _buildAssetsSection(
                          data, totals, currentAssets, nonCurrentAssets),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Liabilities Section
                    if (currentLiabilities.isNotEmpty ||
                        nonCurrentLiabilities.isNotEmpty) ...[
                      _buildLiabilitiesSection(data, totals, currentLiabilities,
                          nonCurrentLiabilities),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Equity Section
                    if (equity.isNotEmpty) ...[
                      _buildEquitySection(totals, equity),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Comprehensive Income (if any)
                    if (comprehensiveIncome.isNotEmpty) ...[
                      _buildComprehensiveIncomeSection(
                          totals, comprehensiveIncome),
                      const SizedBox(height: TossSpacing.space4),
                    ],

                    // Bottom padding
                    const SizedBox(height: TossSpacing.space8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetsSection(
    Map<String, dynamic> data,
    Map<String, dynamic> totals,
    List currentAssets,
    List nonCurrentAssets,
  ) {
    return BalanceSection(
      title: 'Assets',
      total: totals['total_assets'],
      currencySymbol: currencySymbol,
      icon: Icons.account_balance_wallet_outlined,
      color: TossColors.success,
      children: [
        if (currentAssets.isNotEmpty)
          BalanceSubSection(
            title: 'Current Assets',
            total: totals['total_current_assets'],
            currencySymbol: currencySymbol,
            accounts: currentAssets,
          ),
        if (nonCurrentAssets.isNotEmpty) ...[
          if (currentAssets.isNotEmpty)
            const SizedBox(height: TossSpacing.space3),
          BalanceSubSection(
            title: 'Non-Current Assets',
            total: totals['total_non_current_assets'],
            currencySymbol: currencySymbol,
            accounts: nonCurrentAssets,
          ),
        ],
      ],
    );
  }

  Widget _buildLiabilitiesSection(
    Map<String, dynamic> data,
    Map<String, dynamic> totals,
    List currentLiabilities,
    List nonCurrentLiabilities,
  ) {
    return BalanceSection(
      title: 'Liabilities',
      total: totals['total_liabilities'],
      currencySymbol: currencySymbol,
      icon: Icons.receipt_long_outlined,
      color: TossColors.warning,
      children: [
        if (currentLiabilities.isNotEmpty)
          BalanceSubSection(
            title: 'Current Liabilities',
            total: totals['total_current_liabilities'],
            currencySymbol: currencySymbol,
            accounts: currentLiabilities,
          ),
        if (nonCurrentLiabilities.isNotEmpty) ...[
          if (currentLiabilities.isNotEmpty)
            const SizedBox(height: TossSpacing.space3),
          BalanceSubSection(
            title: 'Non-Current Liabilities',
            total: totals['total_non_current_liabilities'],
            currencySymbol: currencySymbol,
            accounts: nonCurrentLiabilities,
          ),
        ],
      ],
    );
  }

  Widget _buildEquitySection(Map<String, dynamic> totals, List equity) {
    return BalanceSection(
      title: "Shareholder's Equity",
      total: totals['total_equity'],
      currencySymbol: currencySymbol,
      icon: Icons.pie_chart_outline,
      color: TossColors.primary,
      children: [
        ...equity.map<Widget>(
          (account) => AccountItem(
            account: account as Map<String, dynamic>,
            currencySymbol: currencySymbol,
          ),
        ),
      ],
    );
  }

  Widget _buildComprehensiveIncomeSection(
      Map<String, dynamic> totals, List comprehensiveIncome) {
    return BalanceSection(
      title: 'Other Comprehensive Income',
      total: totals['total_comprehensive_income'],
      currencySymbol: currencySymbol,
      icon: Icons.trending_up_outlined,
      color: TossColors.info,
      children: [
        ...comprehensiveIncome.map<Widget>(
          (account) => AccountItem(
            account: account as Map<String, dynamic>,
            currencySymbol: currencySymbol,
          ),
        ),
      ],
    );
  }
}
