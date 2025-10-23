import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_loading_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../providers/balance_sheet_providers.dart';
import '../widgets/balance_sheet_display.dart';
import '../widgets/balance_sheet_input.dart';
import '../widgets/income_statement_display.dart';

class BalanceSheetPage extends ConsumerStatefulWidget {
  const BalanceSheetPage({super.key});

  @override
  ConsumerState<BalanceSheetPage> createState() => _BalanceSheetPageState();
}

class _BalanceSheetPageState extends ConsumerState<BalanceSheetPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
        // Update state when tab changes
        ref.read(balanceSheetPageProvider.notifier).changeTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final pageState = ref.watch(balanceSheetPageProvider);
    final companyId = appState.companyChoosen;

    // Sync tab controller with state
    if (_tabController.index != pageState.selectedTabIndex) {
      _tabController.animateTo(pageState.selectedTabIndex);
    }

    // Get currency
    final currencyAsync = ref.watch(currencyProvider(companyId));
    final currency = currencyAsync.value;

    // 🔍 DEBUG: Currency info
    debugPrint('🔍 [BalanceSheet] Company ID: $companyId');
    debugPrint('🔍 [BalanceSheet] Currency async state: ${currencyAsync.isLoading ? "Loading" : currencyAsync.hasValue ? "Has Value" : "Error"}');
    if (currency != null) {
      debugPrint('🔍 [BalanceSheet] Currency symbol: ${currency.symbol}, code: ${currency.code}');
    } else {
      debugPrint('🔍 [BalanceSheet] Currency is null, using default: ₩');
    }

    return TossScaffold(
      backgroundColor: TossColors.background,
      appBar: const TossAppBar1(
        title: 'Financial Statements',
        backgroundColor: TossColors.background,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar Container
            Container(
              color: TossColors.background,
              child: Column(
                children: [
                  // Tab Bar - Toss Style
                  Container(
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          decoration: BoxDecoration(
                            color: TossColors.gray100,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxxl),
                          ),
                        ),
                        // Tab Bar
                        TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: TossColors.background,
                            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
                            boxShadow: [
                              BoxShadow(
                                color: TossColors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(TossSpacing.space1 / 2),
                          dividerColor: TossColors.transparent,
                          labelColor: TossColors.gray900,
                          unselectedLabelColor: TossColors.gray500,
                          labelStyle: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: TossTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: const [
                            Tab(text: 'Balance Sheet'),
                            Tab(text: 'Income Statement'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space3),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Balance Sheet Tab
                  _buildBalanceSheetTab(companyId, currency?.symbol ?? '₩'),

                  // Income Statement Tab
                  _buildIncomeStatementTab(companyId, currency?.symbol ?? '₩'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSheetTab(String companyId, String currencySymbol) {
    final pageState = ref.watch(balanceSheetPageProvider);
    final appState = ref.watch(appStateProvider);

    // Show input UI if no data has been generated yet
    if (!pageState.hasBalanceSheetData) {
      return BalanceSheetInput(
        companyId: companyId,
        onGenerate: () {
          // Mark that we want to generate Balance Sheet
          ref.read(balanceSheetPageProvider.notifier).generateBalanceSheet();
        },
      );
    }


    // Create params for provider
    // Note: storeId comes from App State (storeChoosen), not Page State
    final params = BalanceSheetParams(
      companyId: companyId,
      startDate: pageState.dateRange.startDateFormatted,
      endDate: pageState.dateRange.endDateFormatted,
      storeId: appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
    );

    final balanceSheetAsync = ref.watch(balanceSheetProvider(params));

    return balanceSheetAsync.when(
      data: (balanceSheet) {
        // Convert entity back to Map for display widget
        // TODO: Refactor BalanceSheetDisplay to use entity directly
        final balanceSheetData = {
          'data': {
            'current_assets': balanceSheet.currentAssets
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'non_current_assets': balanceSheet.nonCurrentAssets
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'current_liabilities': balanceSheet.currentLiabilities
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'non_current_liabilities': balanceSheet.nonCurrentLiabilities
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'equity': balanceSheet.equity
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'comprehensive_income': balanceSheet.comprehensiveIncome
                .map((a) => {
                      'account_id': a.accountId,
                      'account_name': a.accountName,
                      'account_type': a.accountType,
                      'balance': a.balance,
                      'has_transactions': a.hasTransactions,
                    })
                .toList(),
            'totals': {
              'total_assets': balanceSheet.totals.totalAssets,
              'total_current_assets': balanceSheet.totals.totalCurrentAssets,
              'total_non_current_assets': balanceSheet.totals.totalNonCurrentAssets,
              'total_liabilities': balanceSheet.totals.totalLiabilities,
              'total_current_liabilities': balanceSheet.totals.totalCurrentLiabilities,
              'total_non_current_liabilities': balanceSheet.totals.totalNonCurrentLiabilities,
              'total_equity': balanceSheet.totals.totalEquity,
              'total_comprehensive_income': balanceSheet.totals.totalComprehensiveIncome,
            },
          },
          'company_info': {
            'company_id': balanceSheet.companyInfo.companyId,
            'company_name': balanceSheet.companyInfo.companyName,
            'store_id': balanceSheet.companyInfo.storeId,
            'store_name': balanceSheet.companyInfo.storeName,
          },
          'ui_data': {
            'balance_verification': {
              'is_balanced': balanceSheet.verification.isBalanced,
              'total_assets': balanceSheet.verification.totalAssets,
              'total_liabilities_and_equity': balanceSheet.verification.totalLiabilitiesAndEquity,
              'total_assets_formatted': balanceSheet.verification.totalAssetsFormatted,
              'total_liabilities_and_equity_formatted':
                  balanceSheet.verification.totalLiabilitiesAndEquityFormatted,
            },
          },
          'parameters': {
            'start_date': balanceSheet.dateRange.startDateFormatted,
            'end_date': balanceSheet.dateRange.endDateFormatted,
          },
        };

        return BalanceSheetDisplay(
          balanceSheetData: balanceSheetData,
          currencySymbol: currencySymbol,
          onEdit: () {
            // Go back to input screen
            ref.read(balanceSheetPageProvider.notifier).state = 
              ref.read(balanceSheetPageProvider).copyWith(hasBalanceSheetData: false);
          },
        );
      },
      loading: () => const TossLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load balance sheet',
              style: TossTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeStatementTab(String companyId, String currencySymbol) {
    final pageState = ref.watch(balanceSheetPageProvider);
    final appState = ref.watch(appStateProvider);

    // Show input UI if no data has been generated yet
    if (!pageState.hasIncomeStatementData) {
      return BalanceSheetInput(
        companyId: companyId,
        onGenerate: () {
          // Mark that we want to generate Income Statement
          ref.read(balanceSheetPageProvider.notifier).generateIncomeStatement();
        },
      );
    }


    // Create params for provider
    // Note: storeId comes from App State (storeChoosen), not Page State
    final params = BalanceSheetParams(
      companyId: companyId,
      startDate: pageState.dateRange.startDateFormatted,
      endDate: pageState.dateRange.endDateFormatted,
      storeId: appState.storeChoosen.isEmpty ? null : appState.storeChoosen,
    );

    final incomeStatementAsync = ref.watch(incomeStatementProvider(params));

    return incomeStatementAsync.when(
      data: (incomeStatement) {
        // Convert entity back to Map for display widget
        // TODO: Refactor IncomeStatementDisplay to use entity directly
        final incomeStatementData = {
          'data': incomeStatement.sections
              .map((section) => {
                    'section': section.sectionName,
                    'section_total': section.sectionTotal,
                    'subcategories': section.subcategories
                        .map((sub) => {
                              'subcategory': sub.subcategoryName,
                              'subcategory_total': sub.subcategoryTotal,
                              'accounts': sub.accounts
                                  .map((acc) => {
                                        'account_id': acc.accountId,
                                        'account_name': acc.accountName,
                                        'account_type': acc.accountType,
                                        'net_amount': acc.netAmount,
                                      })
                                  .toList(),
                            })
                        .toList(),
                  })
              .toList(),
          'parameters': {
            'start_date': incomeStatement.dateRange.startDateFormatted,
            'end_date': incomeStatement.dateRange.endDateFormatted,
            'company_id': incomeStatement.companyId,
            'store_id': incomeStatement.storeId,
          },
        };

        return IncomeStatementDisplay(
          incomeStatementData: incomeStatementData,
          currencySymbol: currencySymbol,
          onEdit: () {
            // Go back to input screen
            ref.read(balanceSheetPageProvider.notifier).state = 
              ref.read(balanceSheetPageProvider).copyWith(hasIncomeStatementData: false);
          },
        );
      },
      loading: () => const TossLoadingView(),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: TossColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load income statement',
              style: TossTextStyles.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
