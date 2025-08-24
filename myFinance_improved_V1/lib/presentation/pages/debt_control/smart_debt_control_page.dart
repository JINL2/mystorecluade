import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_animations.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../providers/app_state_provider.dart';
import 'providers/debt_control_providers.dart';
import 'models/debt_control_models.dart';
import 'widgets/critical_alerts_banner.dart';
import 'widgets/smart_kpi_dashboard.dart';
import 'widgets/quick_actions_hub.dart';
import 'widgets/smart_debt_list.dart';
import 'widgets/analytics_preview.dart';
import 'widgets/debt_control_header.dart';

/// Smart Debt Control Page - Enhanced debt management with AI-driven insights
/// 
/// Key Features:
/// - Risk-prioritized debt queue with intelligent scoring
/// - Critical alerts system for proactive management
/// - Smart KPI dashboard with trend analysis
/// - Contextual action suggestions based on debt status
/// - Advanced filtering and search capabilities
/// - Mobile-optimized gesture interactions
class SmartDebtControlPage extends ConsumerStatefulWidget {
  static const String routeName = 'smart-debt-control';
  static const String routePath = '/debt-control';

  const SmartDebtControlPage({super.key});

  @override
  ConsumerState<SmartDebtControlPage> createState() => _SmartDebtControlPageState();
}

class _SmartDebtControlPageState extends ConsumerState<SmartDebtControlPage> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String _selectedViewpoint = 'company';
  String _selectedFilter = 'all';
  String? _expandedDebtId;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _animationController = AnimationController(
      duration: TossAnimations.medium,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Load initial data
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadDebtData();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadDebtData() async {
    final appState = ref.read(appStateProvider);
    if (appState.companyChoosen.isEmpty) return;

    // Load smart debt overview with intelligence features
    await ref.read(smartDebtOverviewProvider.notifier).loadSmartOverview(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      viewpoint: _selectedViewpoint,
    );

    // Load prioritized debts
    await ref.read(prioritizedDebtsProvider.notifier).loadPrioritizedDebts(
      companyId: appState.companyChoosen,
      storeId: appState.storeChoosen.isNotEmpty ? appState.storeChoosen : null,
      viewpoint: _selectedViewpoint,
      filter: _selectedFilter,
    );
  }

  void _handleViewpointChange(String viewpoint) {
    setState(() {
      _selectedViewpoint = viewpoint;
    });
    _loadDebtData();
  }

  void _handleFilterChange(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadDebtData();
  }

  void _handleDebtTap(String debtId) {
    setState(() {
      _expandedDebtId = _expandedDebtId == debtId ? null : debtId;
    });
  }

  void _handleQuickAction(String actionType) {
    switch (actionType) {
      case 'create_invoice':
        context.push('/journal-input?type=invoice');
        break;
      case 'record_payment':
        context.push('/journal-input?type=payment');
        break;
      case 'bulk_reminder':
        _showBulkReminderDialog();
        break;
      case 'analytics':
        _navigateToAnalytics();
        break;
    }
  }

  void _handleDebtAction(String debtId, String action) {
    // Handle debt-specific actions
    switch (action) {
      case 'call':
        _recordCommunication(debtId, 'call');
        break;
      case 'email':
        _sendEmail(debtId);
        break;
      case 'payment_plan':
        _createPaymentPlan(debtId);
        break;
      case 'dispute':
        _markDispute(debtId);
        break;
      case 'legal':
        _initiateLegalAction(debtId);
        break;
    }
  }

  void _handleCriticalAlert(CriticalAlert alert) {
    switch (alert.type) {
      case 'overdue_critical':
        _showCriticalOverdueList();
        break;
      case 'payment_received':
        _showRecentPayments();
        break;
      case 'dispute_pending':
        _showPendingDisputes();
        break;
    }
  }

  // Action handlers
  void _recordCommunication(String debtId, String type) {
    // TODO: Implement communication recording
  }

  void _sendEmail(String debtId) {
    // TODO: Implement email sending
  }

  void _createPaymentPlan(String debtId) {
    // TODO: Implement payment plan creation
  }

  void _markDispute(String debtId) {
    // TODO: Implement dispute marking
  }

  void _initiateLegalAction(String debtId) {
    // TODO: Implement legal action workflow
  }

  void _showBulkReminderDialog() {
    // TODO: Implement bulk reminder dialog
  }

  void _navigateToAnalytics() {
    context.push('/debt-analytics');
  }

  void _showCriticalOverdueList() {
    // TODO: Show filtered list of critical overdue items
  }

  void _showRecentPayments() {
    // TODO: Show recent payments
  }

  void _showPendingDisputes() {
    // TODO: Show pending disputes
  }

  @override
  Widget build(BuildContext context) {
    final smartOverview = ref.watch(smartDebtOverviewProvider);
    final prioritizedDebts = ref.watch(prioritizedDebtsProvider);

    return TossScaffold(
      backgroundColor: TossColors.gray100,
      body: RefreshIndicator(
        onRefresh: _loadDebtData,
        color: TossColors.primary,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              // Smart Header with company/store context
              SliverToBoxAdapter(
                child: DebtControlHeader(
                  companyName: ref.read(selectedCompanyProvider)?['company_name'] ?? '',
                  storeName: ref.read(selectedStoreProvider)?['store_name'] ?? '',
                  selectedViewpoint: _selectedViewpoint,
                  onViewpointChange: _handleViewpointChange,
                ),
              ),

              // Critical Alerts Banner
              if (smartOverview.hasValue && smartOverview.value!.criticalAlerts.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CriticalAlertsBanner(
                      alerts: smartOverview.value!.criticalAlerts,
                      onAlertTap: _handleCriticalAlert,
                    ),
                  ),
                ),

              // Smart KPI Dashboard
              if (smartOverview.hasValue)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SmartKPIDashboard(
                      metrics: smartOverview.value!.kpiMetrics,
                    ),
                  ),
                ),

              // Quick Actions Hub
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: QuickActionsHub(
                    onActionSelected: _handleQuickAction,
                  ),
                ),
              ),

              // Filter Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Debt Management',
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE5E5EA)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFilterChip('all', 'All', _selectedFilter == 'all'),
                            const SizedBox(width: 8),
                            _buildFilterChip('group', 'Group', _selectedFilter == 'group'),
                            const SizedBox(width: 8),
                            _buildFilterChip('external', 'External', _selectedFilter == 'external'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Smart Debt List
              if (prioritizedDebts.hasValue)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SmartDebtList(
                    debts: prioritizedDebts.value!,
                    expandedDebtId: _expandedDebtId,
                    onDebtTap: _handleDebtTap,
                    onActionTap: _handleDebtAction,
                  ),
                ),

              // Analytics Preview
              if (smartOverview.hasValue)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AnalyticsPreview(
                      agingData: smartOverview.value!.agingAnalysis,
                      onViewFullAnalytics: _navigateToAnalytics,
                    ),
                  ),
                ),

              // Bottom spacing for floating action button
              SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
      
      // Floating Action Button for new transactions
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal-input?type=debt'),
        backgroundColor: TossColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        label: Text(
          'New Transaction',
          style: TossTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _handleFilterChange(value),
      child: AnimatedContainer(
        duration: TossAnimations.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : TossColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}