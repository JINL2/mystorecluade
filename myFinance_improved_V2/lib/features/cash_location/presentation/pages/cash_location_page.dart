import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/domain/entities/feature.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/top_feature.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/ai_chat/ai_chat.dart';
import '../providers/cash_location_providers.dart';
import '../widgets/cash_account_card.dart';
import 'add_account_page.dart';
import 'bank_real_page.dart';
import 'total_journal_page.dart';
import 'total_real_page.dart';
import 'vault_real_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  /// Feature data - can be TopFeature, Feature, or Map<String, dynamic>
  /// Type safety: Using Object? instead of dynamic for better type checking
  final Object? feature;

  const CashLocationPage({super.key, this.feature});

  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _selectedTab = 0;

  // Feature info extracted once
  String? _featureName;
  String? _featureId;
  bool _featureInfoExtracted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_selectedTab != _tabController.index) {
        setState(() {
          _selectedTab = _tabController.index;
        });
        // Data will be filtered client-side, no need to refresh
      }
    });

    // Schedule data refresh after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
      // Extract feature info for AI Chat
      _extractFeatureInfo();
    });
  }

  /// Extract feature name and ID from widget.feature (once)
  void _extractFeatureInfo() {
    if (_featureInfoExtracted) return;
    _featureInfoExtracted = true;

    if (widget.feature == null) {
      _featureName = 'Cash Control';
      return;
    }

    try {
      if (widget.feature is TopFeature) {
        final topFeature = widget.feature as TopFeature;
        _featureName = topFeature.featureName;
        _featureId = topFeature.featureId;
      } else if (widget.feature is Feature) {
        final feature = widget.feature as Feature;
        _featureName = feature.featureName;
        _featureId = feature.featureId;
      } else if (widget.feature is Map<String, dynamic>) {
        final featureMap = widget.feature as Map<String, dynamic>;
        _featureName = featureMap['feature_name'] as String? ?? featureMap['featureName'] as String?;
        _featureId = featureMap['feature_id'] as String? ?? featureMap['featureId'] as String?;
      }
    } catch (_) {
      _featureName = 'Cash Control';
    }

    _featureName ??= 'Cash Control';
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }
  
  // Note: Removed didChangeDependencies override that was causing excessive rebuilds.
  // The method was calling _refreshData() on every dependency change,
  // which could cause UI flickering and AppBar disappearing issues.
  // Data refresh is already handled by:
  // - initState (initial load)
  // - didChangeAppLifecycleState (app resume)
  // - RefreshIndicator (pull-to-refresh)
  // - Navigation callbacks (returning from detail/add pages)
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _refreshData({bool showFeedback = false}) async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      if (companyId.isNotEmpty && storeId.isNotEmpty) {
        // Invalidate the provider to force a refresh
        ref.invalidate(allCashLocationsProvider);
        
        // Force rebuild to show loading state
        if (mounted) {
          setState(() {});
        }
        
        // Only show success feedback if explicitly requested (manual refresh)
        if (showFeedback && mounted) {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Data Refreshed',
              message: 'Data refreshed successfully',
              primaryButtonText: 'OK',
            ),
          );
        }
      }
    } catch (e) {
      // Only show error feedback if explicitly requested or if it's a real error
      if (showFeedback && mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.error(
            title: 'Refresh Failed',
            message: 'Failed to refresh: ${e.toString()}',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }
  
  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
  
  String get _currentLocationType {
    switch (_selectedTab) {
      case 0:
        return 'cash';
      case 1:
        return 'bank';
      case 2:
        return 'vault';
      default:
        return 'cash';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty || storeId.isEmpty) {
      return TossScaffold(
        appBar: const TossAppBar(
          title: 'Cash Control',
          backgroundColor: TossColors.gray100,
        ),
        backgroundColor: TossColors.gray100,
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: Center(
                  child: Text(
                    'Please select a company and store',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    final allLocationsAsync = ref.watch(allCashLocationsProvider(
      CashLocationQueryParams(
        companyId: companyId, 
        storeId: storeId,
      ),
    ),);
    
    return TossScaffold(
      appBar: const TossAppBar(
        title: 'Cash Control',
        backgroundColor: TossColors.gray100,
      ),
      backgroundColor: TossColors.gray100,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            _buildTabBar(),
            
            // Content
            Expanded(
              child: allLocationsAsync.when(
                data: (allLocations) {
                  // Filter locations by selected tab
                  final filteredLocations = allLocations
                      .where((location) => location.locationType == _currentLocationType)
                      .toList();
                  
                  return RefreshIndicator(
                    onRefresh: () => _refreshData(showFeedback: true),
                    color: TossColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Balance Section
                          _buildBalanceSection(filteredLocations),
                          
                          const SizedBox(height: TossSpacing.space4),
                          
                          // Accounts Section
                          _buildAccountsSection(filteredLocations),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: TossLoadingView()),
                error: (error, stack) => RefreshIndicator(
                  onRefresh: () => _refreshData(showFeedback: true),
                  color: TossColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      padding: const EdgeInsets.all(TossSpacing.space5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Error icon
                          const Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: TossColors.gray400,
                          ),
                          const SizedBox(height: TossSpacing.space4),
                          Text(
                            'Connection Error',
                            style: TossTextStyles.h2.copyWith(
                              color: TossColors.gray700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: TossSpacing.space3),
                          Text(
                            'Unable to load cash locations.\nPlease check your internet connection.',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: TossSpacing.space5),
                          // Retry button
                          TossButton.primary(
                            text: 'Retry',
                            onPressed: () => _refreshData(),
                            leadingIcon: const Icon(Icons.refresh),
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space5,
                              vertical: TossSpacing.space3,
                            ),
                            borderRadius: TossBorderRadius.md,
                          ),
                          // Show technical error details in debug mode
                          if (error.toString().contains('SocketException'))
                            Padding(
                              padding: const EdgeInsets.only(top: TossSpacing.space4),
                              child: Container(
                                padding: const EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: TossColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                  border: Border.all(color: TossColors.error.withOpacity(0.3)),
                                ),
                                child: Text(
                                  'Network connection failed',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.error,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AiChatFab(
        featureName: _featureName ?? 'Cash Control',
        pageContext: _buildPageContext(companyId, storeId),
        featureId: _featureId,
      ),
    );
  }

  /// Build page context for AI Chat
  ///
  /// Returns clean JSON structure for Edge Function:
  /// {
  ///   "store_id": "uuid",
  ///   "location_type": "cash" | "bank" | "vault"
  /// }
  Map<String, dynamic> _buildPageContext(String companyId, String storeId) {
    final locationTypes = ['cash', 'bank', 'vault'];
    final locationType = _selectedTab < locationTypes.length
        ? locationTypes[_selectedTab]
        : 'cash';

    final context = <String, dynamic>{
      'location_type': locationType,
    };

    // Add store_id (cash_location is store-specific)
    if (storeId.isNotEmpty) {
      context['store_id'] = storeId;
    }

    return context;
  }

  // Removed _buildHeader method - now using TossAppBar
  
  Widget _buildTabBar() {
    return TossTabBar(
      tabs: const ['Cash', 'Bank', 'Vault'],
      controller: _tabController,
      onTabChanged: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
    );
  }
  
  Widget _buildBalanceSection(List<CashLocation> cashLocations) {
    // Calculate totals using cached provider (performance optimization)
    final totals = ref.read(cashLocationTotalsProvider(cashLocations));
    final totalJournal = totals.totalJournal;
    final totalReal = totals.totalReal;
    final totalError = totals.totalError;
    
    // Get currency symbol from first location (all should have same symbol)
    final currencySymbol = cashLocations.isNotEmpty ? cashLocations.first.currencySymbol : '';
    
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          
          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(totalJournal, currencySymbol),
            isIncome: true,
          ),
          
          const SizedBox(height: TossSpacing.space3),
          
          // Total Real (clickable for all tabs)
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(totalReal, currencySymbol),
            isIncome: false,
            isClickable: true, // Now clickable for all tabs: cash, bank, vault
          ),
          
          // Divider
          Container(
            margin: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            height: 1,
            color: TossColors.gray300,
          ),
          
          // Error
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Error',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _formatCurrency(totalError, currencySymbol),
                style: TossTextStyles.h3.copyWith(
                  color: TossColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildBalanceRow(String label, String amount, {required bool isIncome, bool isClickable = true}) {
    final Widget rowContent = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TossTextStyles.body.copyWith(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                amount,
                style: TossTextStyles.body.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: TossSpacing.space1),
              if (isClickable)
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: TossColors.gray400,
                ),
            ],
          ),
        ],
    );
    
    if (!isClickable) {
      // Return non-clickable row (not used anymore, but kept for flexibility)
      return rowContent;
    }
    
    // Return clickable row with navigation
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Refresh data before navigating
        _refreshData();
        
        // Navigate to appropriate page based on label
        if (label.toLowerCase().contains('journal')) {
          // Total Journal works for all tabs (cash, bank, vault)
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TotalJournalPage(
                locationType: _currentLocationType,
                journalType: 'journal',
              ),
            ),
          );
        } else if (label.toLowerCase().contains('real')) {
          // Total Real works for all tabs
          if (_currentLocationType == 'cash') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TotalRealPage(
                  locationType: _currentLocationType,
                ),
              ),
            );
          } else if (_currentLocationType == 'bank') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BankRealPage(),
              ),
            );
          } else if (_currentLocationType == 'vault') {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VaultRealPage(),
              ),
            );
          }
        }
        
        // Refresh data when returning from detail pages
        _refreshData();
      },
      child: rowContent,
    );
  }
  
  Widget _buildAccountsSection(List<CashLocation> cashLocations) {
    // Calculate total for percentage calculations (using cached provider)
    final totals = ref.read(cashLocationTotalsProvider(cashLocations));
    final totalAmount = totals.totalJournal;
    
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accounts',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: TossSpacing.space3),
          
          ...cashLocations.map((location) => _buildAccountCard(location, totalAmount)),
          
          // Add New Account button
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              // Navigate to Add Account page
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAccountPage(
                    locationType: _currentLocationType,
                  ),
                ),
              );
              
              // Refresh data when returning from add account page
              _refreshData();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  // Plus icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: TossColors.gray100,
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: TossColors.gray600,
                      size: 24,
                    ),
                  ),
                  
                  const SizedBox(width: TossSpacing.space3),
                  
                  // Text
                  Text(
                    _getAddAccountText(),
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray600,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAccountCard(CashLocation location, double totalAmount) {
    return CashAccountCard(
      location: location,
      totalAmount: totalAmount,
      locationType: _currentLocationType,
      onRefresh: _refreshData,
      icon: _getLocationIcon(_currentLocationType),
      formatCurrency: _formatCurrency,
    );
  }
  
  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance_outlined;
      case 'vault':
        return Icons.lock_outline;
      case 'cash':
      default:
        return Icons.attach_money_outlined;
    }
  }
  
  String _getAddAccountText() {
    switch (_currentLocationType) {
      case 'bank':
        return 'Add New Bank Account';
      case 'vault':
        return 'Add New Vault Account';
      case 'cash':
      default:
        return 'Add New Cash Account';
    }
  }
}
