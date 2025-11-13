import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_tab_bar_1.dart';
import '../providers/cash_location_providers.dart';
import 'add_account_page.dart';
import 'bank_real_page.dart';
import 'total_journal_page.dart';
import 'total_real_page.dart';
import 'vault_real_page.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  const CashLocationPage({super.key});

  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _selectedTab = 0;
  
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
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule refresh after build to avoid showSnackBar during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }
  
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
        appBar: const TossAppBar1(
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
      appBar: const TossAppBar1(
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
                          ElevatedButton.icon(
                            onPressed: () => _refreshData(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: TossColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space5,
                                vertical: TossSpacing.space3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              ),
                            ),
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
    );
  }
  
  // Removed _buildHeader method - now using TossAppBar
  
  Widget _buildTabBar() {
    return TossTabBar1(
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
    // Calculate percentage
    final percentage = totalAmount > 0 
        ? ((location.totalJournalCashAmount / totalAmount) * 100).round()
        : 0;
    
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Refresh data before navigating
        _refreshData();

        await context.push(
          '/cashLocation/account/${Uri.encodeComponent(location.locationName)}',
          extra: {
            'locationId': location.locationId,
            'locationType': _currentLocationType,
            'accountName': location.locationName,
            'totalJournal': location.totalJournalCashAmount.round(),
            'totalReal': location.totalRealCashAmount.round(),
            'cashDifference': location.cashDifference.round(),
            'currencySymbol': location.currencySymbol,
            // Legacy fields for compatibility (can be removed later)
            'balance': location.totalJournalCashAmount.round(),
            'errors': location.cashDifference.abs().round(),
          },
        );
        
        // Refresh data when returning from detail page
        _refreshData();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: TossSpacing.space4,
        ),
        child: Row(
          children: [
              // Logo icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Icon(
                  _getLocationIcon(_currentLocationType),
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              
              const SizedBox(width: TossSpacing.space3),
              
              // Account details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location.locationName,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: TossColors.black87,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      '$percentage% of total balance',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Total Journal and Error with arrow
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatCurrency(location.totalJournalCashAmount, location.currencySymbol),
                        style: TossTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: TossSpacing.space1),
                      Text(
                        _formatCurrency(location.cashDifference.abs(), ''),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  const Icon(
                    Icons.chevron_right,
                    color: TossColors.gray400,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
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
