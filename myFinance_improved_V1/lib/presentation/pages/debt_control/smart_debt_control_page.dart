import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/utils/number_formatter.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_empty_view.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_refresh_indicator.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../providers/app_state_provider.dart';
import 'providers/debt_control_providers.dart';
import 'providers/perspective_providers.dart';
import 'providers/currency_provider.dart';
import 'widgets/simple_company_card.dart';
import 'widgets/perspective_summary_card.dart';

class SmartDebtControlPage extends ConsumerStatefulWidget {
  static const String routeName = 'smart-debt-control';
  static const String routePath = '/debt-control';

  const SmartDebtControlPage({super.key});

  @override
  ConsumerState<SmartDebtControlPage> createState() => _SmartDebtControlPageState();
}

class _SmartDebtControlPageState extends ConsumerState<SmartDebtControlPage> 
    with TickerProviderStateMixin {
  
  late AnimationController _animationController;
  late TabController _tabController;
  String _selectedViewpoint = 'company';
  String _selectedFilter = 'all'; // all, internal, external

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    _tabController = TabController(
      length: 2, // Company and Store only
      vsync: this,
      initialIndex: 0,
    );
    
    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedViewpoint = _tabController.index == 0 ? 'company' : 'store';
        });
        _loadData();
        _loadPerspectiveSummary(); // This was missing!
      }
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _loadPerspectiveSummary();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool forceRefresh = false}) async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    // Clear cache if force refresh
    if (forceRefresh) {
      final repository = ref.read(debtRepositoryProvider);
      await repository.refreshData();
    }

    await ref.read(smartDebtOverviewProvider.notifier).loadSmartOverview(
      companyId: appState.companyChoosen,
      storeId: _selectedViewpoint == 'store' && appState.storeChoosen.isNotEmpty 
        ? appState.storeChoosen 
        : null,
      viewpoint: _selectedViewpoint,
    );

    await ref.read(prioritizedDebtsProvider.notifier).loadPrioritizedDebts(
      companyId: appState.companyChoosen,
      storeId: _selectedViewpoint == 'store' && appState.storeChoosen.isNotEmpty 
        ? appState.storeChoosen 
        : null,
      viewpoint: _selectedViewpoint,
      filter: _selectedFilter,
    );
  }
  
  Future<void> _loadPerspectiveSummary() async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;
    
    final selectedCompany = ref.read(selectedCompanyProvider);
    final selectedStore = ref.read(selectedStoreProvider);
    
    await ref.read(perspectiveDebtSummaryProvider.notifier).loadPerspectiveSummary(
      perspectiveType: _selectedViewpoint,
      entityId: _selectedViewpoint == 'store' && appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : appState.companyChoosen,
      entityName: _selectedViewpoint == 'store' 
        ? (selectedStore?['store_name'] ?? 'Store')
        : (selectedCompany?['company_name'] ?? 'Company'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final smartOverview = ref.watch(smartDebtOverviewProvider);
    final prioritizedDebts = ref.watch(prioritizedDebtsProvider);
    final perspectiveSummary = ref.watch(perspectiveDebtSummaryProvider);
    final currency = ref.watch(debtCurrencyProvider);

    return TossScaffold(
      appBar: TossAppBar(
        title: 'Debt Control',
        backgroundColor: TossColors.background,
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: TossRefreshIndicator(
                onRefresh: () => _loadData(forceRefresh: true),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [

              // Enhanced Summary Card using PerspectiveSummaryCard
              if (perspectiveSummary.hasValue && perspectiveSummary.value != null)
                SliverToBoxAdapter(
                  child: PerspectiveSummaryCard(
                    summary: perspectiveSummary.value!,
                    onTap: () {
                      _loadPerspectiveSummary();
                    },
                  ),
                )
              else if (smartOverview.hasValue && smartOverview.value != null)
                // Fallback to basic summary if perspective summary not loaded
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [TossColors.primary, TossColors.primary.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(TossBorderRadius.cardLarge),
                      boxShadow: [
                        BoxShadow(
                          color: TossColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedViewpoint == 'company' 
                                  ? Icons.business 
                                  : Icons.store,
                                color: TossColors.textInverse.withValues(alpha: 0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_getViewpointName()}\'s viewpoint',
                                style: TossTextStyles.body.copyWith(
                                  color: TossColors.textInverse.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            NumberFormatter.formatCurrency(
                              smartOverview.value?.kpiMetrics.netPosition ?? 0.0,
                              currency,
                            ),
                            style: TossTextStyles.display.copyWith(
                              color: TossColors.textInverse,
                            ),
                          ),
                          Text(
                            '${smartOverview.value?.kpiMetrics.transactionCount ?? 0} transactions',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.textInverse.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: TossColors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receivables',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.textInverse.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        NumberFormatter.formatCurrency(
                                          smartOverview.value?.kpiMetrics.totalReceivable ?? 0.0,
                                          currency,
                                        ),
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.textInverse,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: TossColors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payables',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.textInverse.withValues(alpha: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        NumberFormatter.formatCurrency(
                                          smartOverview.value?.kpiMetrics.totalPayable ?? 0.0,
                                          currency,
                                        ),
                                        style: TossTextStyles.body.copyWith(
                                          color: TossColors.textInverse,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Filter Section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Companies',
                        style: TossTextStyles.h4.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildFilterChip('All', 'all'),
                          const SizedBox(width: 12),
                          _buildFilterChip('My Group', 'internal'),
                          const SizedBox(width: 12),
                          _buildFilterChip('External', 'external'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Counterparty List - The Main Content
              if (prioritizedDebts.hasValue && prioritizedDebts.value!.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final debt = prioritizedDebts.value![index];
                      final appState = ref.read(appStateProvider);
                      
                      // Use SimpleCompanyCard for all counterparties
                      return SimpleCompanyCard(
                        counterpartyId: debt.counterpartyId,
                        counterpartyName: debt.counterpartyName,
                        netBalance: debt.amount,
                        counterpartyType: debt.counterpartyType,
                        lastTransactionDate: debt.lastContactDate,
                        isCurrentCompany: debt.counterpartyId == appState.companyChoosen,
                      );
                    },
                    childCount: prioritizedDebts.value!.length,
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 40, 16, 40),
                    child: TossEmptyView(
                      icon: Icon(
                        Icons.handshake_outlined,
                        size: 56,
                        color: TossColors.gray300,
                      ),
                      title: 'No outstanding balances',
                      description: 'All accounts are settled up',
                    ),
                  ),
                ),

                    // Bottom padding
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  // Tab Bar (matches cash location page)
  Widget _buildTabBar() {
    return TossTabBar(
      tabs: [
        'Company',
        'Store',
      ],
      controller: _tabController,
      indicatorHeight: 2.5,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        _loadData();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.background : TossColors.gray100,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: isSelected ? TossColors.gray900 : TossColors.gray500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  String _getViewpointName() {
    final selectedCompany = ref.read(selectedCompanyProvider);
    final selectedStore = ref.read(selectedStoreProvider);
    
    if (_selectedViewpoint == 'company') {
      return selectedCompany?['company_name'] ?? 'Company';
    } else {
      return selectedStore?['store_name'] ?? 'Store';
    }
  }


}