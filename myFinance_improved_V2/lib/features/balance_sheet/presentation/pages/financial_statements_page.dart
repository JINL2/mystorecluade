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
          .read(financialStatementsPageNotifierProvider.notifier)
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
    final pageState = ref.watch(financialStatementsPageNotifierProvider);
    final companyId = appState.companyChoosen;

    // storeId는 DataLevel에 따라 결정
    final storeId = pageState.dataLevel == DataLevel.store
        ? (appState.storeChoosen.isEmpty ? null : appState.storeChoosen)
        : null;

    // Sync tab controller with state (defer to avoid modifying provider during build)
    if (_tabController.index != pageState.selectedTabIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _tabController.index != pageState.selectedTabIndex) {
          _tabController.animateTo(pageState.selectedTabIndex);
        }
      });
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
            // Data Level Toggle + Tab Bar
            _buildHeader(pageState, appState.storeName),

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

  Widget _buildHeader(FinancialStatementsPageState pageState, String storeName) {
    return Container(
      color: TossColors.white,
      child: Column(
        children: [
          // Data Level Toggle
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space2,
            ),
            child: Row(
              children: [
                _buildLevelChip(
                  label: 'Company',
                  isSelected: pageState.dataLevel == DataLevel.company,
                  onTap: () => ref
                      .read(financialStatementsPageNotifierProvider.notifier)
                      .setDataLevel(DataLevel.company),
                ),
                const SizedBox(width: TossSpacing.space2),
                _buildLevelChip(
                  label: storeName.isEmpty ? 'Store' : storeName,
                  isSelected: pageState.dataLevel == DataLevel.store,
                  onTap: () => ref
                      .read(financialStatementsPageNotifierProvider.notifier)
                      .setDataLevel(DataLevel.store),
                ),
              ],
            ),
          ),

          // Tab Bar
          _buildTabBar(),
        ],
      ),
    );
  }

  Widget _buildLevelChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.gray900 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.white : TossColors.gray600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
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
    );
  }
}
