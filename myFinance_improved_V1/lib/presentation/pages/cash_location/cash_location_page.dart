import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/toss/toss_tab_bar.dart';
import '../../../data/services/cash_location_service.dart';
import 'add_account_page.dart';
import 'total_journal_page.dart';
import 'total_real_page.dart';
import 'bank_real_page.dart';
import 'vault_real_page.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../../core/navigation/safe_navigation.dart';

class CashLocationPage extends ConsumerStatefulWidget {
  const CashLocationPage({super.key});

  @override
  ConsumerState<CashLocationPage> createState() => _CashLocationPageState();
}

class _CashLocationPageState extends ConsumerState<CashLocationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_selectedTab != _tabController.index) {
        setState(() {
          _selectedTab = _tabController.index;
        });
        // Data will be filtered client-side, no need to refresh
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _refreshData() async {
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      if (companyId.isNotEmpty && storeId.isNotEmpty) {
        // Invalidate the provider to force a refresh
        ref.invalidate(allCashLocationsProvider(
          CashLocationQueryParams(
            companyId: companyId, 
            storeId: storeId,
          ),
        ));
        
        // Wait for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Show success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Data refreshed successfully'),
              backgroundColor: TossColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
            ),
          );
        }
      }
    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
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
        appBar: TossAppBar(
          title: 'Cash Control',
        ),
        backgroundColor: TossColors.backgroundPage,
        body: SafeArea(
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: Center(
                  child: Text(
                    'Please select a company and store',
                    style: TossTextStyles.body.copyWith(
                      color: Colors.grey[500],
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
    ));
    
    return TossScaffold(
      appBar: TossAppBar(
        title: 'Cash Control',
      ),
      backgroundColor: TossColors.backgroundPage,
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
                    onRefresh: _refreshData,
                    color: TossColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(TossSpacing.space4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Balance Section
                          _buildBalanceSection(filteredLocations),
                          
                          SizedBox(height: TossSpacing.space4),
                          
                          // Accounts Section
                          _buildAccountsSection(filteredLocations),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => RefreshIndicator(
                  onRefresh: _refreshData,
                  color: TossColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      padding: EdgeInsets.all(TossSpacing.space5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Error icon
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: TossSpacing.space4),
                          Text(
                            'Connection Error',
                            style: TossTextStyles.h2.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space3),
                          Text(
                            'Unable to load cash locations.\nPlease check your internet connection.',
                            style: TossTextStyles.body.copyWith(
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: TossSpacing.space5),
                          // Retry button
                          ElevatedButton.icon(
                            onPressed: () => _refreshData(),
                            icon: Icon(Icons.refresh),
                            label: Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
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
                              padding: EdgeInsets.only(top: TossSpacing.space4),
                              child: Container(
                                padding: EdgeInsets.all(TossSpacing.space3),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  'Network connection failed',
                                  style: TossTextStyles.caption.copyWith(
                                    color: Colors.red[700],
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
    // Calculate totals from cash locations
    final totalJournal = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalJournalCashAmount
    );
    final totalReal = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalRealCashAmount
    );
    final totalError = totalReal - totalJournal;
    
    // Get currency symbol from first location (all should have same symbol)
    final currencySymbol = cashLocations.isNotEmpty ? cashLocations.first.currencySymbol : '';
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: Colors.white,
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
          SizedBox(height: TossSpacing.space4),
          
          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(totalJournal, currencySymbol),
            isIncome: true,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Total Real (clickable for all tabs)
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(totalReal, currencySymbol),
            isIncome: false,
            isClickable: true, // Now clickable for all tabs: cash, bank, vault
          ),
          
          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
            height: 1,
            color: const Color(0xFFE5E8EB),
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
                  color: const Color(0xFFE53935),
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
              SizedBox(width: TossSpacing.space1),
              if (isClickable)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.grey[400],
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
    // Calculate total for percentage calculations
    final totalAmount = cashLocations.fold<double>(
      0, (sum, location) => sum + location.totalJournalCashAmount
    );
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: Colors.white,
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
          SizedBox(height: TossSpacing.space3),
          
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
              padding: EdgeInsets.symmetric(
                vertical: TossSpacing.space4,
              ),
              child: Row(
                children: [
                  // Plus icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  
                  SizedBox(width: TossSpacing.space3),
                  
                  // Text
                  Text(
                    _getAddAccountText(),
                    style: TossTextStyles.body.copyWith(
                      color: Colors.grey[600],
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
        
        // Debug logging (uncomment for debugging)
        // print('Navigating to account detail:');
        // print('  locationId: ${location.locationId}');
        // print('  locationName: ${location.locationName}');
        // print('  locationType: $_currentLocationType');
        
        await context.safePush(
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
        padding: EdgeInsets.symmetric(
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
                  borderRadius: BorderRadius.circular(TossBorderRadius.buttonLarge),
                ),
                child: Icon(
                  _getLocationIcon(_currentLocationType),
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
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
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      '$percentage% of total balance',
                      style: TossTextStyles.caption.copyWith(
                        color: Colors.grey[600],
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
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        _formatCurrency(location.cashDifference.abs(), ''),
                        style: TossTextStyles.caption.copyWith(
                          color: const Color(0xFFE53935),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
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