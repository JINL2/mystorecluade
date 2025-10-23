import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import '../providers/cash_location_providers.dart';
import 'account_settings_page.dart';

class AccountDetailPage extends ConsumerStatefulWidget {
  final String? locationId;
  final String accountName;
  final String locationType;
  final int balance;
  final int errors;
  final int? totalJournal;
  final int? totalReal;
  final int? cashDifference;
  final String? currencySymbol;
  
  const AccountDetailPage({
    super.key,
    this.locationId,
    required this.accountName,
    required this.locationType,
    required this.balance,
    required this.errors,
    this.totalJournal,
    this.totalReal,
    this.cashDifference,
    this.currencySymbol,
  });

  @override
  ConsumerState<AccountDetailPage> createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends ConsumerState<AccountDetailPage> 
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _selectedTab = 0;
  String _selectedFilter = 'All';
  
  // Pagination state
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  
  // Cached data
  List<JournalFlow> _allJournalFlows = [];
  List<ActualFlow> _allActualFlows = [];
  LocationSummary? _locationSummary;
  
  // Updated balance values
  int? _updatedTotalJournal;
  int? _updatedTotalReal;
  int? _updatedCashDifference;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
    _scrollController.addListener(_onScroll);
    
    // Refresh data on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshDataSilently();
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh when app comes back to foreground
      _refreshDataSilently();
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }
  
  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (widget.locationId == null) return;
    
    try {
      final service = ref.read(stockFlowServiceProvider);
      final response = await service.getLocationStockFlow(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: widget.locationId!,
          offset: _currentOffset + _limit,
          limit: _limit,
        ),
      );
      
      if (response.success && response.data != null) {
        setState(() {
          _allJournalFlows.addAll(response.data!.journalFlows);
          _allActualFlows.addAll(response.data!.actualFlows);
          
          // Sort all flows by date in descending order (newest first)
          _allJournalFlows.sort((a, b) {
            try {
              final dateA = DateTime.parse(a.createdAt);
              final dateB = DateTime.parse(b.createdAt);
              return dateB.compareTo(dateA); // Descending order
            } catch (e) {
              return 0;
            }
          });
          
          _allActualFlows.sort((a, b) {
            try {
              final dateA = DateTime.parse(a.createdAt);
              final dateB = DateTime.parse(b.createdAt);
              return dateB.compareTo(dateA); // Descending order
            } catch (e) {
              return 0;
            }
          });
          
          _currentOffset += _limit;
          
          // Check if we have more data
          if (response.pagination != null) {
            _hasMoreData = response.pagination!.hasMore;
          } else {
            _hasMoreData = false;
          }
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  
  Future<void> _onRefresh() async {
    // Reset state and refresh data
    setState(() {
      _allJournalFlows.clear();
      _allActualFlows.clear();
      _currentOffset = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
    });
    
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (widget.locationId == null) return;
    
    // Invalidate to force refresh
    ref.invalidate(stockFlowProvider(
      StockFlowParams(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: widget.locationId!,
        offset: 0,
        limit: _limit,
      ),
    ));
    
    // Also invalidate and refresh cash locations to update balance
    ref.invalidate(allCashLocationsProvider(
      CashLocationQueryParams(
        companyId: companyId,
        storeId: storeId,
      ),
    ));
    
    // Force immediate data refresh by reading the provider
    try {
      final response = await ref.read(stockFlowProvider(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: widget.locationId!,
          offset: 0,
          limit: _limit,
        ),
      ).future);
      
      if (response.success && response.data != null) {
        setState(() {
          _allJournalFlows = List.from(response.data!.journalFlows);
          _allActualFlows = List.from(response.data!.actualFlows);
          
          // Sort all flows by date in descending order (newest first)
          _allJournalFlows.sort((a, b) {
            try {
              final dateA = DateTime.parse(a.createdAt);
              final dateB = DateTime.parse(b.createdAt);
              return dateB.compareTo(dateA);
            } catch (e) {
              return 0;
            }
          });
          
          _allActualFlows.sort((a, b) {
            try {
              final dateA = DateTime.parse(a.createdAt);
              final dateB = DateTime.parse(b.createdAt);
              return dateB.compareTo(dateA);
            } catch (e) {
              return 0;
            }
          });
          
          _locationSummary = response.data!.locationSummary;
          _currentOffset = 0;
          _hasMoreData = response.pagination?.hasMore ?? false;
        });
      }
    } catch (e) {
      // If fetching fails, the provider will handle the error state
    }
    
    // Fetch updated balance data
    await _fetchUpdatedBalance();
  }
  
  Future<void> _refreshDataSilently() async {
    // Silently refresh data without showing loading indicators
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (widget.locationId == null || companyId.isEmpty || storeId.isEmpty) return;
    
    try {
      // Invalidate providers to get fresh data
      ref.invalidate(stockFlowProvider(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: widget.locationId!,
          offset: 0,
          limit: _limit,
        ),
      ));
      
      ref.invalidate(allCashLocationsProvider(
        CashLocationQueryParams(
          companyId: companyId,
          storeId: storeId,
        ),
      ));
      
      // Fetch fresh data
      final response = await ref.read(stockFlowProvider(
        StockFlowParams(
          companyId: companyId,
          storeId: storeId,
          cashLocationId: widget.locationId!,
          offset: 0,
          limit: _limit,
        ),
      ).future);
      
      if (response.success && response.data != null) {
        if (mounted) {
          setState(() {
            _allJournalFlows = List.from(response.data!.journalFlows);
            _allActualFlows = List.from(response.data!.actualFlows);
            
            // Sort all flows by date in descending order
            _allJournalFlows.sort((a, b) {
              try {
                final dateA = DateTime.parse(a.createdAt);
                final dateB = DateTime.parse(b.createdAt);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            });
            
            _allActualFlows.sort((a, b) {
              try {
                final dateA = DateTime.parse(a.createdAt);
                final dateB = DateTime.parse(b.createdAt);
                return dateB.compareTo(dateA);
              } catch (e) {
                return 0;
              }
            });
            
            _locationSummary = response.data!.locationSummary;
            _currentOffset = 0;
            _hasMoreData = response.pagination?.hasMore ?? false;
          });
        }
      }
      
      // Also fetch updated balance
      await _fetchUpdatedBalance();
    } catch (e) {
      // Silently handle errors - don't show error messages for background refresh
    }
  }
  
  Future<void> _fetchUpdatedBalance() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (widget.locationId == null) return;
    
    try {
      // Fetch all cash locations
      final allLocations = await ref.read(allCashLocationsProvider(
        CashLocationQueryParams(
          companyId: companyId,
          storeId: storeId,
        ),
      ).future);
      
      // Find the current location
      final currentLocation = allLocations.firstWhere(
        (location) => location.locationId == widget.locationId,
        orElse: () => CashLocation(
          locationId: widget.locationId!,
          locationName: widget.accountName,
          locationType: widget.locationType,
          totalJournalCashAmount: widget.totalJournal?.toDouble() ?? widget.balance.toDouble(),
          totalRealCashAmount: widget.totalReal?.toDouble() ?? widget.balance.toDouble(),
          cashDifference: widget.cashDifference?.toDouble() ?? 0,
          companyId: companyId,
          storeId: storeId,
          currencySymbol: widget.currencySymbol ?? '',
        ),
      );
      
      // Update the balance values
      setState(() {
        _updatedTotalJournal = currentLocation.totalJournalCashAmount.round();
        _updatedTotalReal = currentLocation.totalRealCashAmount.round();
        _updatedCashDifference = currentLocation.cashDifference.round();
      });
    } catch (e) {
      // If fetching fails, keep using the original values
    }
  }
  
  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.abs().round())}';
  }
  
  String _formatCurrencyWithSign(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isNegative = amount < 0;
    final formattedAmount = formatter.format(amount.abs().round());
    return '${isNegative ? "-" : ""}$symbol$formattedAmount';
  }
  
  String _formatTransactionAmount(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isIncome = amount > 0;
    final prefix = isIncome ? '+$symbol' : '-$symbol';
    return '$prefix${formatter.format(amount.abs().round())}';
  }
  
  String _formatBalance(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
  
  String _getJournalDisplayText(JournalFlow flow) {
    // Priority: 1. Counter account name (always show if available)
    // 2. Journal description (fallback if no counter account)
    // 3. Default text if neither available
    
    if (flow.counterAccount != null && 
        flow.counterAccount!.accountName.isNotEmpty) {
      // Always show counter account name when available
      return flow.counterAccount!.accountName;
    }
    
    // Fallback to description if no counter account
    if (flow.journalDescription.isNotEmpty) {
      return flow.journalDescription;
    }
    
    // Default fallback
    return 'Transaction';
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh data when the page becomes visible again
    // This handles navigation back from other pages
    _refreshDataSilently();
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    // Debug logging (uncomment for debugging)
    // print('AccountDetailPage build:');
    // print('  locationId: ${widget.locationId}');
    // print('  accountName: ${widget.accountName}');
    // print('  companyId: $companyId');
    // print('  storeId: $storeId');
    
    if (companyId.isEmpty || storeId.isEmpty || widget.locationId == null || widget.locationId!.isEmpty) {
      return TossScaffold(
        appBar: TossAppBar1(
          title: widget.accountName,
          backgroundColor: TossColors.gray50,
          secondaryActionIcon: Icons.settings_outlined,
          onSecondaryAction: () async {
            // Navigate to account settings page
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountSettingsPage(
                  locationId: widget.locationId ?? '',
                  accountName: widget.accountName,
                  locationType: widget.locationType,
                ),
              ),
            );
            
            // Refresh data when returning from settings
            await _refreshDataSilently();
          },
        ),
        backgroundColor: TossColors.gray50,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    widget.locationId == null || widget.locationId!.isEmpty 
                        ? 'Location ID is missing'
                        : 'Please select a company and store',
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
    
    final stockFlowAsync = ref.watch(stockFlowProvider(
      StockFlowParams(
        companyId: companyId,
        storeId: storeId,
        cashLocationId: widget.locationId!,
        offset: 0,
        limit: _limit,
      ),
    ));
    
    return TossScaffold(
      appBar: TossAppBar1(
        title: widget.accountName,
        backgroundColor: TossColors.gray50,
        secondaryActionIcon: Icons.settings_outlined,
        onSecondaryAction: () async {
          // Navigate to account settings page
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountSettingsPage(
                locationId: widget.locationId ?? '',
                accountName: widget.accountName,
                locationType: widget.locationType,
              ),
            ),
          );
          
          // Refresh data when returning from settings
          await _refreshDataSilently();
        },
      ),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            
            // Content
            Expanded(
              child: stockFlowAsync.when(
                data: (response) {
                  // Always use fresh data from the provider
                  if (response.success && response.data != null) {
                    // Update data if it's different from cached
                    if (_allJournalFlows.isEmpty || 
                        _allActualFlows.isEmpty ||
                        _allJournalFlows.length != response.data!.journalFlows.length ||
                        _allActualFlows.length != response.data!.actualFlows.length) {
                      _allJournalFlows = List.from(response.data!.journalFlows);
                      _allActualFlows = List.from(response.data!.actualFlows);
                      
                      // Sort all flows by date in descending order (newest first)
                      _allJournalFlows.sort((a, b) {
                        try {
                          final dateA = DateTime.parse(a.createdAt);
                          final dateB = DateTime.parse(b.createdAt);
                          return dateB.compareTo(dateA); // Descending order
                        } catch (e) {
                          return 0;
                        }
                      });
                      
                      _allActualFlows.sort((a, b) {
                        try {
                          final dateA = DateTime.parse(a.createdAt);
                          final dateB = DateTime.parse(b.createdAt);
                          return dateB.compareTo(dateA); // Descending order
                        } catch (e) {
                          return 0;
                        }
                      });
                      
                      _locationSummary = response.data!.locationSummary;
                      _currentOffset = 0;
                      _hasMoreData = response.pagination?.hasMore ?? false;
                    }
                  }
                  
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Balance Card with padding
                          Padding(
                            padding: EdgeInsets.all(TossSpacing.space4),
                            child: _buildBalanceCard(),
                          ),
                          
                          // Transaction List (has its own padding)
                          _buildTransactionList(),
                          
                          // Loading indicator for pagination
                          if (_isLoadingMore)
                            Padding(
                              padding: EdgeInsets.all(TossSpacing.space4),
                              child: TossLoadingView(),
                            ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: TossLoadingView()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading data',
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space2),
                      ElevatedButton(
                        onPressed: () => _onRefresh(),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Removed _buildHeader method - now using TossAppBar with secondaryActionIcon
  
  Widget _buildBalanceCard() {
    // Use updated values if available, otherwise use widget values
    final totalJournal = _updatedTotalJournal ?? widget.totalJournal ?? widget.balance;
    final totalReal = _updatedTotalReal ?? widget.totalReal ?? widget.balance;
    final error = _updatedCashDifference ?? widget.cashDifference ?? (totalReal - totalJournal);
    final currencySymbol = widget.currencySymbol ?? '';
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space5),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance title and Auto Mapping button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Balance',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              GestureDetector(
                onTap: () => _showAutoMappingBottomSheet(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TossSpacing.space4,
                    vertical: TossSpacing.space2,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Text(
                    'Auto Mapping',
                    style: TossTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space4),
          
          // Total Journal
          _buildBalanceRow(
            'Total Journal',
            _formatCurrency(totalJournal.toDouble(), currencySymbol),
            isJournal: true,
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          // Total Real
          _buildBalanceRow(
            'Total Real',
            _formatCurrency(totalReal.toDouble(), currencySymbol),
            isJournal: false,
          ),
          
          // Divider
          Container(
            margin: EdgeInsets.symmetric(vertical: TossSpacing.space4),
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
                _formatCurrencyWithSign(error.toDouble(), currencySymbol),
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
  
  Widget _buildBalanceRow(String label, String amount, {required bool isJournal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
          ),
        ),
        Text(
          amount,
          style: TossTextStyles.body.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Future<void> _handleErrorMapping(double errorAmount) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TossLoadingView(),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'Processing...',
                    style: TossTextStyles.body.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    
    try {
      // Get necessary data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      // Extract user ID from user object
      String userId = '';
      try {
        if (appState.user is Map && appState.user['user_id'] != null) {
          userId = appState.user['user_id'];
        } else if (appState.user is Map && appState.user['id'] != null) {
          userId = appState.user['id'];
        }
      } catch (e) {
        // Handle error if user object structure is unexpected
      }
      
      if (widget.locationId == null || widget.locationId!.isEmpty) {
        Navigator.pop(context); // Close loading
        _showErrorDialog('Location ID is missing');
        return;
      }
      
      // Call the service
      final service = ref.read(cashJournalServiceProvider);
      final result = await service.createErrorJournal(
        differenceAmount: errorAmount,
        companyId: companyId,
        userId: userId,
        locationName: widget.accountName,
        cashLocationId: widget.locationId!,
        storeId: storeId,
      );
      
      Navigator.pop(context); // Close loading dialog
      
      if (result['success'] == true) {
        // Refresh data immediately after successful creation
        await Future.delayed(Duration(milliseconds: 500)); // Small delay to ensure server processing
        await _onRefresh();
        
        // Show success message after refresh
        _showSuccessDialog(isError: true);
      } else {
        // Show error message
        final errorMsg = result['error'] ?? 'Failed to create journal entry';
        _showErrorDialog(errorMsg);
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }
  
  Future<void> _handleForeignCurrencyTranslation(double errorAmount) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(TossSpacing.space5),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TossLoadingView(),
                  SizedBox(height: TossSpacing.space4),
                  Text(
                    'Processing...',
                    style: TossTextStyles.body.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    
    try {
      // Get necessary data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      // Extract user ID from user object
      String userId = '';
      try {
        if (appState.user is Map && appState.user['user_id'] != null) {
          userId = appState.user['user_id'];
        } else if (appState.user is Map && appState.user['id'] != null) {
          userId = appState.user['id'];
        }
      } catch (e) {
        // Handle error if user object structure is unexpected
      }
      
      if (widget.locationId == null || widget.locationId!.isEmpty) {
        Navigator.pop(context); // Close loading
        _showErrorDialog('Location ID is missing');
        return;
      }
      
      // Call the service
      final service = ref.read(cashJournalServiceProvider);
      final result = await service.createForeignCurrencyTranslation(
        differenceAmount: errorAmount,
        companyId: companyId,
        userId: userId,
        locationName: widget.accountName,
        cashLocationId: widget.locationId!,
        storeId: storeId,
      );
      
      Navigator.pop(context); // Close loading dialog
      
      if (result['success'] == true) {
        // Refresh data immediately after successful creation
        await Future.delayed(Duration(milliseconds: 500)); // Small delay to ensure server processing
        await _onRefresh();
        
        // Show success message after refresh
        _showSuccessDialog(isError: false);
      } else {
        // Show error message
        final errorMsg = result['error'] ?? 'Failed to create journal entry';
        _showErrorDialog(errorMsg);
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }
  
  void _showSuccessDialog({bool isError = false}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 40,
                    color: TossColors.success,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                Text(
                  'Success',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                Text(
                  isError 
                      ? 'Error adjustment\nhas been recorded successfully.'
                      : 'Foreign currency translation\nhas been recorded successfully.',
                  style: TossTextStyles.body.copyWith(
                    fontSize: 14,
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: TossSpacing.space5),
                
                // OK button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: TossColors.white,
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Container(
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Error icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: TossColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: TossColors.error,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                Text(
                  'Error',
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                Text(
                  message,
                  style: TossTextStyles.body.copyWith(
                    fontSize: 14,
                    color: TossColors.gray600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: TossSpacing.space5),
                
                // OK button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: TossColors.white,
                      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'OK',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  void _showMappingConfirmationDialog(String mappingType) async {
    // Calculate the error amount using updated values if available
    final totalJournal = _updatedTotalJournal ?? widget.totalJournal ?? widget.balance;
    final totalReal = _updatedTotalReal ?? widget.totalReal ?? widget.balance;
    final errorAmount = totalReal - totalJournal;
    final currencySymbol = widget.currencySymbol ?? '';

    // Custom content for Difference Amount
    final customContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Difference Amount label
        Text(
          'Difference Amount',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
            fontSize: 14,
          ),
        ),

        SizedBox(height: TossSpacing.space2),

        // Difference amount value
        Text(
          _formatCurrencyWithSign(errorAmount.toDouble(), currencySymbol),
          style: TossTextStyles.h3.copyWith(
            color: TossColors.error,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ],
    );

    // Show confirm/cancel dialog using TossConfirmCancelDialog
    final confirmed = await TossConfirmCancelDialog.show(
      context: context,
      title: 'Auto Mapping',
      message: 'Do you want to make\n$mappingType?',
      confirmButtonText: 'OK',
      cancelButtonText: 'Cancel',
      customContent: customContent,
      barrierDismissible: true,
    );

    // If user confirmed
    if (confirmed == true) {
      // Handle different mapping types
      if (mappingType == 'Exchange Rate Differences') {
        await _handleForeignCurrencyTranslation(errorAmount.toDouble());
      } else if (mappingType == 'Error') {
        await _handleErrorMapping(errorAmount.toDouble());
      }
    }
  }
  
  void _showFilterBottomSheet() {
    // Different filters based on tab
    List<String> filterOptions;
    if (_selectedTab == 0) {
      // Journal tab filters
      filterOptions = ['All', 'Money In', 'Money Out', 'Today', 'Yesterday', 'Last Week'];
    } else {
      // Real tab filters
      filterOptions = ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Filter options
              ...filterOptions.map((option) => 
                _buildFilterOption(option, _selectedFilter == option)
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFilterOption(String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = title;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TossTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
                weight: 900,
              ),
          ],
        ),
      ),
    );
  }
  
  void _showAutoMappingBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Mapping Reason',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Mapping options
              _buildMappingOption('Error', Icons.error_outline),
              _buildMappingOption('Exchange Rate Differences', Icons.currency_exchange),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMappingOption(String title, IconData icon) {
    return InkWell(
      onTap: () {
        // Close the bottom sheet first
        Navigator.pop(context);
        // Show the confirmation dialog
        _showMappingConfirmationDialog(title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: TossSpacing.space4),
            Expanded(
              child: Text(
                title,
                style: TossTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionList() {
    return Column(
      children: [
        // Transaction container with tab bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            boxShadow: TossShadows.card,
          ),
          child: Column(
            children: [
              // Tab bar for Journal/Real
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: TossColors.gray300,
                      width: 1,
                    ),
                  ),
                ),
                child: Theme(
                  data: ThemeData(
                    splashColor: TossColors.transparent,
                    highlightColor: TossColors.transparent,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 2.0,
                        color: TossColors.black87,
                      ),
                      insets: EdgeInsets.zero,
                    ),
                    indicatorColor: TossColors.black87,
                    labelColor: TossColors.black87,
                    unselectedLabelColor: TossColors.gray400,
                    labelStyle: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    unselectedLabelStyle: TossTextStyles.body.copyWith(
                      fontSize: 17,
                    ),
                    overlayColor: WidgetStateProperty.all(TossColors.transparent),
                    tabs: const [
                      Tab(text: 'Journal'),
                      Tab(text: 'Real'),
                    ],
                  ),
                ),
              ),
              
              // Header with filter - aligned with Balance text
              Container(
                padding: EdgeInsets.only(
                  left: TossSpacing.space5,
                  right: TossSpacing.space4,
                  top: TossSpacing.space5,
                  bottom: TossSpacing.space3,
                ),
                child: GestureDetector(
                  onTap: () => _showFilterBottomSheet(),
                  child: Row(
                    children: [
                      Text(
                        _selectedFilter,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: TossColors.gray600,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Transaction items based on selected tab
              if (_selectedTab == 0)
                ..._buildJournalItems()
              else
                ..._buildRealItems(),
              
              // Load more indicator
              if (_hasMoreData && !_isLoadingMore)
                GestureDetector(
                  onTap: _loadMoreData,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Load More',
                            style: TossTextStyles.body.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              
              // Loading indicator when fetching more
              if (_isLoadingMore)
                Container(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
                  child: Center(
                    child: const TossLoadingView(),
                  ),
                ),
            ],
          ),
        ),
        
        // Bottom spacing
        SizedBox(height: TossSpacing.space4),
      ],
    );
  }
  
  List<Widget> _buildJournalItems() {
    List<Widget> items = [];
    String? lastDate;
    
    // Apply filters
    var filteredFlows = List<JournalFlow>.from(_allJournalFlows);
    
    if (_selectedFilter == 'Money In') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount > 0).toList();
    } else if (_selectedFilter == 'Money Out') {
      filteredFlows = filteredFlows.where((f) => f.flowAmount < 0).toList();
    } else if (_selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year && date.month == today.month && date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    // Sort by date in descending order (newest first)
    filteredFlows.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA); // Descending order
      } catch (e) {
        return 0;
      }
    });
    
    for (int i = 0; i < filteredFlows.length; i++) {
      final flow = filteredFlows[i];
      final currentDate = flow.getFormattedDate();
      final bool showDate = currentDate != lastDate;
      
      if (showDate) {
        lastDate = currentDate;
      }
      
      items.add(_buildJournalItem(flow, showDate));
    }
    
    if (items.isEmpty) {
      items.add(
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Center(
            child: Text(
              'No journal entries found',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      );
    }
    
    return items;
  }
  
  List<Widget> _buildRealItems() {
    List<Widget> items = [];
    String? lastDate;
    
    // Apply filters
    var filteredFlows = List<ActualFlow>.from(_allActualFlows);
    
    if (_selectedFilter == 'Today') {
      final today = DateTime.now();
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == today.year && date.month == today.month && date.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(Duration(days: 7));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Last Month') {
      final lastMonth = DateTime.now().subtract(Duration(days: 30));
      filteredFlows = filteredFlows.where((f) {
        try {
          final date = DateTime.parse(f.createdAt);
          return date.isAfter(lastMonth);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    // Sort by date in descending order (newest first)
    filteredFlows.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.createdAt);
        final dateB = DateTime.parse(b.createdAt);
        return dateB.compareTo(dateA); // Descending order
      } catch (e) {
        return 0;
      }
    });
    
    for (int i = 0; i < filteredFlows.length; i++) {
      final flow = filteredFlows[i];
      final currentDate = flow.getFormattedDate();
      final bool showDate = currentDate != lastDate;
      
      if (showDate) {
        lastDate = currentDate;
      }
      
      items.add(_buildRealItem(flow, showDate));
    }
    
    if (items.isEmpty) {
      items.add(
        Container(
          padding: EdgeInsets.all(TossSpacing.space5),
          child: Center(
            child: Text(
              'No real entries found',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ),
        ),
      );
    }
    
    return items;
  }
  
  Widget _buildJournalItem(JournalFlow flow, bool showDate) {
    final isIncome = flow.flowAmount > 0;
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _locationSummary?.baseCurrencySymbol ?? 
                           (_locationSummary?.currencyCode == 'VND' ? '₫' : widget.currencySymbol ?? '');
    
    return GestureDetector(
      onTap: () => _showJournalDetailBottomSheet(flow),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
        children: [
          // Date section (centered vertically, aligned left)
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    flow.getFormattedDate(),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getJournalDisplayText(flow),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TossColors.black87,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        flow.createdBy.fullName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (flow.getFormattedTime().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        flow.getFormattedTime(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Amount and balance for Journal tab
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTransactionAmount(flow.flowAmount, currencySymbol),
                style: TossTextStyles.body.copyWith(
                  color: isIncome 
                      ? Theme.of(context).colorScheme.primary 
                      : TossColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              SizedBox(height: TossSpacing.space2),
              Text(
                _formatBalance(flow.balanceAfter, currencySymbol),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
  
  Widget _buildRealItem(ActualFlow flow, bool showDate) {
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _locationSummary?.baseCurrencySymbol ?? flow.currency.symbol;
    
    return GestureDetector(
      onTap: () => _showRealDetailBottomSheet(flow),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: TossSpacing.space4,
          right: TossSpacing.space4,
          top: TossSpacing.space3,
          bottom: TossSpacing.space3,
        ),
        child: Row(
        children: [
          // Date section (centered vertically, aligned left)
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    flow.getFormattedDate(),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Count',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TossColors.black87,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: TossSpacing.space2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        flow.createdBy.fullName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (flow.getFormattedTime().isNotEmpty) ...[
                      Text(
                        ' • ',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        flow.getFormattedTime(),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Amount and Balance for Real tab
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Flow amount (what was counted)
              Text(
                _formatBalance(flow.flowAmount, currencySymbol),
                style: TossTextStyles.body.copyWith(
                  color: flow.flowAmount >= 0 
                      ? Theme.of(context).colorScheme.primary 
                      : TossColors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              // Running balance
              Text(
                _formatBalance(flow.balanceAfter, currencySymbol),
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                  fontSize: 13,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
  
  void _showJournalDetailBottomSheet(JournalFlow flow) {
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _locationSummary?.baseCurrencySymbol ?? 
                           (_locationSummary?.currencyCode == 'VND' ? '₫' : widget.currencySymbol ?? '');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Journal Entry Details',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: TossColors.gray50,
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              flow.journalDescription.isNotEmpty 
                                  ? flow.journalDescription
                                  : (flow.counterAccount?.description?.isNotEmpty == true
                                      ? flow.counterAccount!.description
                                      : 'No description'),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      // Amount details
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: flow.flowAmount > 0 
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : TossColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('Transaction Amount', 
                              _formatTransactionAmount(flow.flowAmount, currencySymbol),
                              isHighlighted: true),
                            const SizedBox(height: TossSpacing.space3),
                            _buildDetailRow('Balance Before', 
                              _formatBalance(flow.balanceBefore, currencySymbol)),
                            const SizedBox(height: TossSpacing.space2),
                            _buildDetailRow('Balance After', 
                              _formatBalance(flow.balanceAfter, currencySymbol)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: TossSpacing.space4),
                      
                      // Transaction details
                      _buildDetailRow('Account', flow.accountName),
                      if (flow.counterAccount != null) ...[
                        _buildDetailRow('Counter Account', flow.counterAccount!.accountName),
                        _buildDetailRow('Account Type', flow.counterAccount!.accountType),
                      ],
                      _buildDetailRow('Type', flow.journalType),
                      _buildDetailRow('Created By', flow.createdBy.fullName),
                      _buildDetailRow('Date', DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt))),
                      _buildDetailRow('Time', flow.getFormattedTime()),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  void _showRealDetailBottomSheet(ActualFlow flow) {
    // Use base currency symbol for total amounts (flow amounts are in base currency)
    final baseCurrencySymbol = _locationSummary?.baseCurrencySymbol ?? flow.currency.symbol;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Cash Count Details',
                        style: TossTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance overview
                      Container(
                        padding: const EdgeInsets.all(TossSpacing.space4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Balance',
                                      style: TossTextStyles.caption.copyWith(
                                        color: TossColors.gray600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatBalance(flow.balanceAfter, baseCurrencySymbol),
                                      style: TossTextStyles.h1.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 32,
                                ),
                              ],
                            ),
                            const SizedBox(height: TossSpacing.space4),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Previous Balance',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        _formatBalance(flow.balanceBefore, baseCurrencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Change',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        _formatTransactionAmount(flow.flowAmount, baseCurrencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: flow.flowAmount >= 0 ? TossColors.success : TossColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Denomination breakdown
                      if (flow.currentDenominations.isNotEmpty) ...[
                        Text(
                          'Denomination Breakdown',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space3),
                        
                        ...flow.currentDenominations.map((denomination) => 
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(TossSpacing.space3),
                            decoration: BoxDecoration(
                              color: TossColors.gray50,
                              borderRadius: BorderRadius.circular(TossBorderRadius.md),
                              border: Border.all(color: TossColors.gray200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Denomination value
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: TossColors.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                      ),
                                      child: Text(
                                        _formatCurrency(denomination.denominationValue, denomination.currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: TossColors.primary,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    
                                    // Type badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: TossColors.gray200,
                                        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                      ),
                                      child: Text(
                                        denomination.denominationType.toUpperCase(),
                                        style: TossTextStyles.caption.copyWith(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: TossSpacing.space3),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Previous Qty',
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            '${denomination.previousQuantity}',
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Change',
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            '${denomination.quantityChange > 0 ? "+" : ""}${denomination.quantityChange}',
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: denomination.quantityChange > 0 
                                                  ? TossColors.success 
                                                  : denomination.quantityChange < 0 
                                                      ? TossColors.error 
                                                      : TossColors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Current Qty',
                                            style: TossTextStyles.caption.copyWith(
                                              color: TossColors.gray600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            '${denomination.currentQuantity}',
                                            style: TossTextStyles.body.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: TossSpacing.space2),
                                
                                // Subtotal
                                Container(
                                  padding: const EdgeInsets.all(TossSpacing.space2),
                                  decoration: BoxDecoration(
                                    color: TossColors.white,
                                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: TossTextStyles.caption.copyWith(
                                          color: TossColors.gray600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        _formatBalance(denomination.subtotal, denomination.currencySymbol),
                                        style: TossTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ),
                        
                        const SizedBox(height: TossSpacing.space4),
                      ],
                      
                      // Transaction info
                      _buildDetailRow('Counted By', flow.createdBy.fullName),
                      _buildDetailRow('Date', DateFormat('MMM d, yyyy').format(DateTime.parse(flow.createdAt))),
                      _buildDetailRow('Time', flow.getFormattedTime()),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
              // Bottom safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TossTextStyles.body.copyWith(
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
                fontSize: isHighlighted ? 16 : 14,
                color: isHighlighted ? Theme.of(context).colorScheme.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
