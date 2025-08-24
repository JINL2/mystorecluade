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

/// Enhanced Smart Debt Control Page with Counterparty Focus
/// Shows debt amounts with each counterparty as the primary information
class SmartDebtControlPageV3 extends ConsumerStatefulWidget {
  static const String routeName = 'smart-debt-control';
  static const String routePath = '/debt-control';

  const SmartDebtControlPageV3({super.key});

  @override
  ConsumerState<SmartDebtControlPageV3> createState() => _SmartDebtControlPageV3State();
}

class _SmartDebtControlPageV3State extends ConsumerState<SmartDebtControlPageV3> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  String _selectedViewpoint = 'company';
  String _selectedFilter = 'all'; // all, internal, external
  String? _expandedCounterpartyId;

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
              // Header with Title and Location
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Title Bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Debt Control',
                              style: TossTextStyles.h2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {},
                                  color: TossColors.textSecondary,
                                ),
                                Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications_outlined),
                                      onPressed: () {},
                                      color: TossColors.textSecondary,
                                    ),
                                    if (smartOverview.hasValue && 
                                        smartOverview.value!.kpiMetrics.criticalCount > 0)
                                      Positioned(
                                        right: 8,
                                        top: 8,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: TossColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Location Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: const Color(0xFFEFF6FF),
                        child: Text(
                          '${selectedCompany?['company_name'] ?? 'Company'} ${selectedStore != null ? '> ${selectedStore['store_name']}' : ''}',
                          style: TossTextStyles.caption.copyWith(
                            color: const Color(0xFF1E40AF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Viewpoint Selector
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildViewTab('company', 'Company Total', Icons.business),
                        _buildViewTab('headquarters', 'Headquarters', Icons.account_balance),
                        _buildViewTab('store', selectedStore?['store_name'] ?? 'Store', Icons.store),
                      ],
                    ),
                  ),
                ),
              ),

              // Summary Card with Gradient
              if (smartOverview.hasValue)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
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
                          // Viewpoint Label
                          Row(
                            children: [
                              Icon(
                                _selectedViewpoint == 'company' 
                                  ? Icons.business 
                                  : _selectedViewpoint == 'headquarters' 
                                    ? Icons.account_balance 
                                    : Icons.store,
                                color: Colors.white.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_getViewpointName()}\'s viewpoint',
                                style: TossTextStyles.body.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Net Balance
                          Text(
                            NumberFormatter.formatCurrency(
                              smartOverview.value!.kpiMetrics.netPosition,
                              '₫',
                            ),
                            style: TossTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          Text(
                            '${smartOverview.value!.kpiMetrics.transactionCount} transactions',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Receivable and Payable Grid
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Receivables',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        NumberFormatter.formatCurrency(
                                          smartOverview.value!.kpiMetrics.totalReceivable,
                                          '₫',
                                        ),
                                        style: TossTextStyles.body.copyWith(
                                          color: Colors.white,
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
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payables',
                                        style: TossTextStyles.caption.copyWith(
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        NumberFormatter.formatCurrency(
                                          smartOverview.value!.kpiMetrics.totalPayable,
                                          '₫',
                                        ),
                                        style: TossTextStyles.body.copyWith(
                                          color: Colors.white,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Counterparties',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Show detailed filters
                            },
                            child: Text(
                              'Detailed Filter',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildFilterChip('All', 'all'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Group', 'internal'),
                          const SizedBox(width: 8),
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
                      return _buildCounterpartyCard(debt);
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
                            Icons.account_balance_wallet_outlined,
                            size: 48,
                            color: TossColors.gray300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No counterparty debts',
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
      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => context.push('/journal-input?type=debt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add New Transaction'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/transaction-history'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
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
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ] : null,
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
              Flexible(
                child: Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected ? TossColors.primary : TossColors.textTertiary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary.withOpacity(0.1) : TossColors.gray100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
          ),
        ),
        child: Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: isSelected ? TossColors.primary : TossColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCounterpartyCard(PrioritizedDebt debt) {
    final isExpanded = _expandedCounterpartyId == debt.id;
    final isInternal = debt.counterpartyType == 'internal';
    final netBalance = debt.amount;
    final isPositive = netBalance >= 0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: isInternal ? () {
          setState(() {
            _expandedCounterpartyId = isExpanded ? null : debt.id;
          });
        } : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Main Row
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isInternal 
                        ? TossColors.primary.withOpacity(0.1)
                        : TossColors.gray100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getCounterpartyInitials(debt.counterpartyName),
                        style: TossTextStyles.body.copyWith(
                          color: isInternal ? TossColors.primary : TossColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                debt.counterpartyName,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isInternal)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBE9FE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Group',
                                  style: TossTextStyles.caption.copyWith(
                                    color: const Color(0xFF325BD8),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          debt.lastContactDate != null
                            ? 'Last: ${_formatDate(debt.lastContactDate!)}'
                            : 'No recent transactions',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        if (isInternal && debt.metadata != null)
                          Text(
                            'Trading with ${_getTradingCount(debt.metadata)} departments',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  // Net Balance
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberFormatter.formatCurrency(netBalance.abs(), '₫'),
                        style: TossTextStyles.body.copyWith(
                          color: isPositive ? TossColors.success : TossColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isPositive ? 'Receivable' : 'Payable',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  
                  if (isInternal)
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: TossColors.textTertiary,
                    ),
                ],
              ),
              
              // Expanded Department Details (for internal counterparties)
              if (isExpanded && isInternal && debt.metadata != null)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: _buildDepartmentBreakdown(debt.metadata),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDepartmentBreakdown(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata['departments'] == null) {
      return [
        Text(
          'No department breakdown available',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ];
    }
    
    final departments = metadata['departments'] as List<dynamic>? ?? [];
    return departments.map((dept) {
      final name = dept['name'] ?? 'Unknown';
      final balance = dept['balance'] ?? 0.0;
      final isPositive = balance >= 0;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
            Text(
              NumberFormatter.formatCurrency(balance.abs(), '₫'),
              style: TossTextStyles.caption.copyWith(
                color: isPositive ? TossColors.success : TossColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  String _getCounterpartyInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _getViewpointName() {
    final selectedCompany = ref.read(selectedCompanyProvider);
    final selectedStore = ref.read(selectedStoreProvider);
    
    if (_selectedViewpoint == 'company') {
      return selectedCompany?['company_name'] ?? 'Company';
    } else if (_selectedViewpoint == 'store') {
      return selectedStore?['store_name'] ?? 'Store';
    } else {
      return 'Headquarters';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }

  int _getTradingCount(Map<String, dynamic>? metadata) {
    if (metadata == null || metadata['departments'] == null) {
      return 0;
    }
    final departments = metadata['departments'] as List<dynamic>? ?? [];
    return departments.length;
  }
}