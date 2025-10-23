import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../shared/themes/toss_animations.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_empty_view.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/toss_refresh_indicator.dart';
import '../../../../shared/widgets/toss/toss_tab_bar_1.dart';
import '../../domain/entities/critical_alert.dart';
import '../../domain/entities/debt_overview.dart';
import '../../domain/entities/prioritized_debt.dart';
import '../providers/debt_control_providers.dart';

/// Smart Debt Control Page
///
/// Main debt control dashboard with Clean Architecture implementation.
class SmartDebtControlPage extends ConsumerStatefulWidget {
  const SmartDebtControlPage({super.key});

  @override
  ConsumerState<SmartDebtControlPage> createState() =>
      _SmartDebtControlPageState();
}

class _SmartDebtControlPageState extends ConsumerState<SmartDebtControlPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _selectedTabIndex = 0;
  String _selectedFilter = 'all'; // all, internal, external

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get _selectedViewpoint => _selectedTabIndex == 0 ? 'company' : 'store';

  Future<void> _loadData({bool forceRefresh = false}) async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    final storeId = _selectedViewpoint == 'store' &&
            appState.storeChoosen.isNotEmpty
        ? appState.storeChoosen
        : null;

    if (forceRefresh) {
      await ref.read(debtControlProvider.notifier).refresh(
            companyId: appState.companyChoosen,
            storeId: storeId,
            viewpoint: _selectedViewpoint,
            filter: _selectedFilter,
          );
    } else {
      await Future.wait([
        ref.read(debtControlProvider.notifier).loadSmartOverview(
              companyId: appState.companyChoosen,
              storeId: storeId,
              viewpoint: _selectedViewpoint,
            ),
        ref.read(debtControlProvider.notifier).loadPrioritizedDebts(
              companyId: appState.companyChoosen,
              storeId: storeId,
              viewpoint: _selectedViewpoint,
              filter: _selectedFilter,
            ),
      ]);
    }
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _loadData();
  }

  String _getViewpointName() {
    return _selectedTabIndex == 0 ? 'Company' : 'Store';
  }

  @override
  Widget build(BuildContext context) {
    final debtControlState = ref.watch(debtControlProvider);

    return TossScaffold(
      appBar: const TossAppBar1(
        title: 'Debt Control',
      ),
      backgroundColor: TossColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            TossTabBar1(
              tabs: const ['Company', 'Store'],
              onTabChanged: _onTabChanged,
            ),

            // Content
            Expanded(
              child: debtControlState.when(
                data: (state) => TossRefreshIndicator(
                  onRefresh: () => _loadData(forceRefresh: true),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Overview Summary
                      if (state.hasOverview) ...[
                        SliverToBoxAdapter(
                          child: _buildOverviewCard(state.overview!),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: TossSpacing.space4),
                        ),
                      ],

                      // Critical Alerts
                      if (state.overview != null &&
                          state.overview!.criticalAlerts.isNotEmpty) ...[
                        SliverToBoxAdapter(
                          child: _buildAlertsSection(state.overview!),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: TossSpacing.space4),
                        ),
                      ],

                      // Filter Tabs
                      SliverToBoxAdapter(
                        child: _buildFilterTabs(),
                      ),

                      // Debts List
                      if (state.isLoadingDebts)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (state.hasDebts)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final debt = state.debts[index];
                              return _buildDebtCard(debt);
                            },
                            childCount: state.debts.length,
                          ),
                        )
                      else
                        SliverFillRemaining(
                          child: TossEmptyView(
                            title: 'No debts found',
                            description:
                                'There are no debts matching your criteria',
                            icon: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 64,
                              color: TossColors.gray400,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: TossEmptyView(
                    title: 'Error loading data',
                    description: error.toString(),
                    icon: Icon(
                      Icons.error_outline,
                      size: 64,
                      color: TossColors.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(DebtOverview overview) {
    final kpiMetrics = overview.kpiMetrics;

    return Container(
      margin: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary,
            TossColors.primary.withValues(alpha: 0.8),
          ],
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
        padding: const EdgeInsets.all(TossSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _selectedTabIndex == 0 ? Icons.business : Icons.store,
                  color: TossColors.textInverse.withValues(alpha: 0.9),
                  size: 16,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  '${_getViewpointName()}\'s viewpoint',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textInverse.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              NumberFormatter.formatCurrency(
                kpiMetrics.netPosition,
                'KRW',
              ),
              style: TossTextStyles.display.copyWith(
                color: TossColors.textInverse,
              ),
            ),
            Text(
              '${kpiMetrics.transactionCount} transactions',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textInverse.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Row(
              children: [
                Expanded(
                  child: _buildMetricBox(
                    'Receivables',
                    NumberFormatter.formatCurrency(
                      kpiMetrics.totalReceivable,
                      'KRW',
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: _buildMetricBox(
                    'Payables',
                    NumberFormatter.formatCurrency(
                      kpiMetrics.totalPayable,
                      'KRW',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textInverse.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textInverse,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(DebtOverview overview) {
    final unreadAlerts =
        overview.criticalAlerts.where((a) => !a.isRead).toList();

    if (unreadAlerts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Critical Alerts (${unreadAlerts.length})',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          ...unreadAlerts.take(3).map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildAlertCard(CriticalAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: TossSpacing.space2),
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: TossColors.error,
            size: 20,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Text(
              alert.message,
              style: TossTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: TossSpacing.space2),
          _buildFilterChip('Internal', 'internal'),
          const SizedBox(width: TossSpacing.space2),
          _buildFilterChip('External', 'external'),
        ],
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.full),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.border,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: isSelected ? TossColors.textInverse : TossColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDebtCard(PrioritizedDebt debt) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  debt.counterpartyName,
                  style: TossTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (debt.isCritical)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    'Critical',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            NumberFormatter.formatCurrency(debt.amount, 'KRW'),
            style: TossTextStyles.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: debt.amount > 0 ? TossColors.success : TossColors.error,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: TossColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Due: ${debt.daysOverdue > 0 ? "${debt.daysOverdue} days overdue" : "Not overdue"}',
                style: TossTextStyles.caption.copyWith(
                  color: debt.daysOverdue > 0
                      ? TossColors.error
                      : TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
