import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../../core/utils/number_formatter.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../providers/app_state_provider.dart';
import 'providers/debt_control_providers.dart';
import 'models/debt_control_models.dart';

/// Redesigned Smart Debt Control Page with better UI/UX
class SmartDebtControlPageV2 extends ConsumerStatefulWidget {
  static const String routeName = 'smart-debt-control';
  static const String routePath = '/debt-control';

  const SmartDebtControlPageV2({super.key});

  @override
  ConsumerState<SmartDebtControlPageV2> createState() => _SmartDebtControlPageV2State();
}

class _SmartDebtControlPageV2State extends ConsumerState<SmartDebtControlPageV2> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  String _selectedViewpoint = 'company';
  String _selectedFilter = 'all';

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

  Future<void> _loadData() async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    await ref.read(smartDebtOverviewProvider.notifier).loadSmartOverview(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      viewpoint: _selectedViewpoint,
    );

    await ref.read(prioritizedDebtsProvider.notifier).loadPrioritizedDebts(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      viewpoint: _selectedViewpoint,
      filter: _selectedFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final smartOverview = ref.watch(smartDebtOverviewProvider);
    final prioritizedDebts = ref.watch(prioritizedDebtsProvider);
    final selectedCompany = ref.watch(selectedCompanyProvider);
    final selectedStore = ref.watch(selectedStoreProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: TossColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Simplified Header
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Company Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Debt Control',
                                  style: TossTextStyles.h2.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${selectedCompany?['company_name'] ?? 'Company'} ${selectedStore != null ? '• ${selectedStore['store_name']}' : ''}',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Notification Icon
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {},
                            color: TossColors.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Viewpoint Selector - Improved Design
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            _buildViewTab('company', 'Company', Icons.business),
                            _buildViewTab('headquarters', 'HQ', Icons.account_balance),
                            _buildViewTab('store', 'Store', Icons.store),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Primary Metrics Section - Redesigned
              if (smartOverview.hasValue)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Net Position Card - Most Important
                        _buildPrimaryMetricCard(
                          title: 'Net Position',
                          value: NumberFormatter.formatCurrency(
                            smartOverview.value!.kpiMetrics.netPosition, 
                            '₫'
                          ),
                          subtitle: 'Receivables - Payables',
                          color: smartOverview.value!.kpiMetrics.netPosition >= 0 
                            ? TossColors.success 
                            : TossColors.error,
                          icon: Icons.account_balance_wallet,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Secondary Metrics Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactMetricCard(
                                title: 'Overdue',
                                value: '${smartOverview.value!.kpiMetrics.avgDaysOutstanding}d',
                                icon: Icons.schedule,
                                color: TossColors.warning,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactMetricCard(
                                title: 'Collection',
                                value: '${smartOverview.value!.kpiMetrics.collectionRate.toStringAsFixed(0)}%',
                                icon: Icons.trending_up,
                                color: TossColors.success,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactMetricCard(
                                title: 'Critical',
                                value: '${smartOverview.value!.kpiMetrics.criticalCount}',
                                icon: Icons.warning_amber,
                                color: TossColors.error,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCompactMetricCard(
                                title: 'Total Items',
                                value: '${smartOverview.value!.kpiMetrics.transactionCount}',
                                icon: Icons.receipt_long,
                                color: TossColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Aging Analysis - Visual Chart
              if (smartOverview.hasValue)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aging Distribution',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildAgingChart(smartOverview.value!.agingAnalysis),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),

              // Quick Actions Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              'Create Invoice',
                              Icons.receipt,
                              () => context.push('/journal-input?type=invoice'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              'Record Payment',
                              Icons.payment,
                              () => context.push('/journal-input?type=payment'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),

              // Debt List Header with Filter
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outstanding Items',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: TossColors.gray200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFilterChip('All', 'all'),
                            const SizedBox(width: 8),
                            _buildFilterChip('Critical', 'critical'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 12),
              ),

              // Debt List
              if (prioritizedDebts.hasValue && prioritizedDebts.value!.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final debt = prioritizedDebts.value![index];
                      return _buildDebtItem(debt);
                    },
                    childCount: prioritizedDebts.value!.length,
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: TossColors.gray300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No outstanding debts',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal-input?type=debt'),
        backgroundColor: TossColors.primary,
        label: const Text('New Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildViewTab(String value, String label, IconData icon) {
    final isSelected = _selectedViewpoint == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedViewpoint = value;
          });
          _loadData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? TossColors.primary : TossColors.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: isSelected ? TossColors.primary : TossColors.textTertiary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TossTextStyles.h3.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgingChart(AgingAnalysis aging) {
    final total = aging.current + aging.overdue30 + aging.overdue60 + aging.overdue90;
    if (total == 0) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'No data available',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Bar Chart
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 40,
            child: Row(
            children: [
              if (aging.current > 0)
                Expanded(
                  flex: (aging.current * 100 / total).round(),
                  child: Container(color: TossColors.success),
                ),
              if (aging.overdue30 > 0)
                Expanded(
                  flex: (aging.overdue30 * 100 / total).round(),
                  child: Container(color: TossColors.warning),
                ),
              if (aging.overdue60 > 0)
                Expanded(
                  flex: (aging.overdue60 * 100 / total).round(),
                  child: Container(color: Colors.orange),
                ),
              if (aging.overdue90 > 0)
                Expanded(
                  flex: (aging.overdue90 * 100 / total).round(),
                  child: Container(color: TossColors.error),
                ),
            ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildAgingLegend('Current', aging.current, TossColors.success),
            _buildAgingLegend('30 days', aging.overdue30, TossColors.warning),
            _buildAgingLegend('60 days', aging.overdue60, Colors.orange),
            _buildAgingLegend('90+ days', aging.overdue90, TossColors.error),
          ],
        ),
      ],
    );
  }

  Widget _buildAgingLegend(String label, double amount, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: TossColors.gray200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: TossColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? TossColors.primary : TossColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDebtItem(PrioritizedDebt debt) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: _getRiskColor(debt.riskCategory).withOpacity(0.1),
          child: Text(
            debt.counterpartyName.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: _getRiskColor(debt.riskCategory),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          debt.counterpartyName,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${debt.daysOverdue} days overdue',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              NumberFormatter.formatCurrency(debt.amount, '₫'),
              style: TossTextStyles.body.copyWith(
                color: _getRiskColor(debt.riskCategory),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              debt.riskCategory,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String riskCategory) {
    switch (riskCategory) {
      case 'critical':
        return TossColors.error;
      case 'attention':
        return Colors.orange;
      case 'watch':
        return TossColors.warning;
      default:
        return TossColors.success;
    }
  }
}