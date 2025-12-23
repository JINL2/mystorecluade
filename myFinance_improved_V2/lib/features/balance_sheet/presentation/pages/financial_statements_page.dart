import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../providers/financial_statements_provider.dart';
import '../widgets/pnl_tab_content.dart';
import '../widgets/bs_tab_content.dart';
import '../widgets/trend_tab_content.dart';

/// Financial Statements Page with 3 tabs: P&L, B/S, Trend
class FinancialStatementsPage extends ConsumerStatefulWidget {
  const FinancialStatementsPage({super.key});

  @override
  ConsumerState<FinancialStatementsPage> createState() =>
      _FinancialStatementsPageState();
}

class _FinancialStatementsPageState
    extends ConsumerState<FinancialStatementsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!mounted) return;
    if (_tabController.indexIsChanging) {
      HapticFeedback.selectionClick();
      ref
          .read(financialStatementsPageProvider.notifier)
          .changeTab(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final pageState = ref.watch(financialStatementsPageProvider);
    final companyId = appState.companyChoosen;
    final storeId =
        appState.storeChoosen.isEmpty ? null : appState.storeChoosen;

    // Sync tab controller with state
    if (_tabController.index != pageState.selectedTabIndex) {
      _tabController.animateTo(pageState.selectedTabIndex);
    }

    // Get currency
    final currencyAsync = ref.watch(companyCurrencyProvider(companyId));
    final currencySymbol = currencyAsync.value ?? '₫';

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: const TossAppBar1(
        title: 'Financial Statements',
        backgroundColor: TossColors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            _buildTabBar(),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // P&L Tab
                  PnlTabContent(
                    companyId: companyId,
                    storeId: storeId,
                    currencySymbol: currencySymbol,
                  ),

                  // B/S Tab
                  BsTabContent(
                    companyId: companyId,
                    storeId: storeId,
                    currencySymbol: currencySymbol,
                  ),

                  // Trend Tab
                  TrendTabContent(
                    companyId: companyId,
                    storeId: storeId,
                    currencySymbol: currencySymbol,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: TossColors.white,
      child: Column(
        children: [
          Container(
            height: 44,
            margin: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Stack(
              children: [
                // Background
                Container(
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                ),
                // Tab Bar
                TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: TossColors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.all(3),
                  dividerColor: TossColors.transparent,
                  labelColor: TossColors.gray900,
                  unselectedLabelColor: TossColors.gray500,
                  labelStyle: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'P&L'),
                    Tab(text: 'B/S'),
                    Tab(text: 'Trend'),
                  ],
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }
}
