import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_confirm_cancel_dialog.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';

import '../providers/cash_location_providers.dart';
import '../widgets/account_balance_card_widget.dart';
import '../widgets/actual_flow_item.dart';
import '../widgets/journal_detail_sheet.dart';
import '../widgets/journal_flow_item.dart';
import '../widgets/real_detail_sheet.dart';
import '../widgets/sheets/auto_mapping_sheet.dart';
import '../widgets/sheets/filter_bottom_sheet.dart';
import '../formatters/cash_location_formatters.dart';
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

  // Helper method to sort flows by date in descending order (newest first)
  // Optimized: Cache parsed dates to avoid O(n²) DateTime.parse() calls
  void _sortFlowsByDate() {
    // Cache for parsed dates to avoid redundant parsing during sort
    final parsedDates = <String, DateTime?>{};

    DateTime? parseDate(String dateStr) {
      return parsedDates.putIfAbsent(dateStr, () {
        try {
          return DateTime.parse(dateStr);
        } catch (e) {
          return null;
        }
      });
    }

    _allJournalFlows.sort((a, b) {
      final dateA = parseDate(a.createdAt);
      final dateB = parseDate(b.createdAt);
      if (dateA == null || dateB == null) return 0;
      return dateB.compareTo(dateA);
    });

    _allActualFlows.sort((a, b) {
      final dateA = parseDate(a.createdAt);
      final dateB = parseDate(b.createdAt);
      if (dateA == null || dateB == null) return 0;
      return dateB.compareTo(dateA);
    });
  }

  // Helper method to show processing dialog with loading indicator
  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
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
  }

  // Helper method to get currency symbol with fallback
  String _getCurrencySymbol() {
    return _locationSummary?.baseCurrencySymbol ??
           (_locationSummary?.currencyCode == 'VND' ? '₫' : widget.currencySymbol ?? '');
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
      final useCase = ref.read(getStockFlowUseCaseProvider);
      final response = await useCase(
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
          _sortFlowsByDate();
          
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
          _sortFlowsByDate();

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
            _sortFlowsByDate();

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
    final isNegative = amount < 0;
    final formattedAmount = formatter.format(amount.abs().round());
    return '${isNegative ? "-" : ""}$symbol$formattedAmount';
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
  
  // Note: Removed didChangeDependencies override that was causing AppBar to disappear.
  // The method was calling _refreshDataSilently() on every dependency change,
  // which triggered excessive rebuilds and UI flickering.
  // Data refresh is already handled by:
  // - initState (initial load)
  // - didChangeAppLifecycleState (app resume)
  // - _onRefresh (pull-to-refresh)
  // - Navigation callbacks (returning from settings page)
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

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
                      _sortFlowsByDate();

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

    return AccountBalanceCardWidget(
      totalJournal: totalJournal,
      totalReal: totalReal,
      error: error,
      currencySymbol: currencySymbol,
      onAutoMappingTap: _showAutoMappingBottomSheet,
      formatCurrency: _formatCurrency,
      formatCurrencyWithSign: _formatCurrencyWithSign,
    );
  }
  
  Future<void> _handleErrorMapping(double errorAmount) async {
    // Show loading indicator
    _showProcessingDialog();

    try {
      // Get necessary data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;
      
      // Extract user ID from user object
      String userId = '';
      try {
        if (appState.user['user_id'] != null) {
          userId = appState.user['user_id'].toString();
        } else if (appState.user['id'] != null) {
          userId = appState.user['id'].toString();
        }
      } catch (e) {
        // Handle error if user object structure is unexpected
      }

      if (widget.locationId == null || widget.locationId!.isEmpty) {
        Navigator.pop(context); // Close loading
        _showErrorDialog('Location ID is missing');
        return;
      }

      // Call the use case
      final useCase = ref.read(createErrorAdjustmentUseCaseProvider);
      final result = await useCase(
        CreateErrorAdjustmentParams(
          differenceAmount: errorAmount,
          companyId: companyId,
          userId: userId,
          locationName: widget.accountName,
          cashLocationId: widget.locationId!,
          storeId: storeId,
        ),
      );
      
      Navigator.pop(context); // Close loading dialog

      // Use pattern matching with sealed class
      result.when(
        success: (journalId, message, additionalData) async {
          // Refresh data immediately after successful creation
          await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure server processing
          await _onRefresh();

          // Show success message after refresh
          _showSuccessDialog(isError: true);
        },
        failure: (error, errorCode, errorDetails) {
          // Show error message
          _showErrorDialog(error);
        },
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }
  
  Future<void> _handleForeignCurrencyTranslation(double errorAmount) async {
    // Show loading indicator
    _showProcessingDialog();

    try {
      // Get necessary data
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      // Extract user ID from user object
      String userId = '';
      try {
        if (appState.user['user_id'] != null) {
          userId = appState.user['user_id'].toString();
        } else if (appState.user['id'] != null) {
          userId = appState.user['id'].toString();
        }
      } catch (e) {
        // Handle error if user object structure is unexpected
      }

      if (widget.locationId == null || widget.locationId!.isEmpty) {
        Navigator.pop(context); // Close loading
        _showErrorDialog('Location ID is missing');
        return;
      }

      // Call the use case
      final useCase = ref.read(createForeignCurrencyTranslationUseCaseProvider);
      final result = await useCase(
        CreateForeignCurrencyTranslationParams(
          differenceAmount: errorAmount,
          companyId: companyId,
          userId: userId,
          locationName: widget.accountName,
          cashLocationId: widget.locationId!,
          storeId: storeId,
        ),
      );

      Navigator.pop(context); // Close loading dialog

      // Use pattern matching with sealed class
      result.when(
        success: (journalId, message, additionalData) async {
          // Refresh data immediately after successful creation
          await Future.delayed(const Duration(milliseconds: 500)); // Small delay to ensure server processing
          await _onRefresh();

          // Show success message after refresh
          _showSuccessDialog(isError: false);
        },
        failure: (error, errorCode, errorDetails) {
          // Show error message
          _showErrorDialog(error);
        },
      );
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
        return TossDialog.success(
          title: 'Success',
          message: isError
              ? 'Error adjustment has been recorded successfully.'
              : 'Foreign currency translation has been recorded successfully.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.pop(context),
        );
      },
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TossDialog.error(
          title: 'Error',
          message: message,
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.pop(context),
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
        return FilterBottomSheet(
          selectedFilter: _selectedFilter,
          filterOptions: filterOptions,
          onFilterSelected: (String filter) {
            setState(() {
              _selectedFilter = filter;
            });
          },
        );
      },
    );
  }
  
  void _showAutoMappingBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AutoMappingSheet(
          onMappingSelected: (String mappingType) {
            // Show the confirmation dialog after selecting mapping type
            _showMappingConfirmationDialog(mappingType);
          },
        );
      },
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
      final currentDate = CashLocationFormatters.formatJournalFlowDate(flow);
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
      final currentDate = CashLocationFormatters.formatActualFlowDate(flow);
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
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _getCurrencySymbol();

    return JournalFlowItem(
      flow: flow,
      showDate: showDate,
      currencySymbol: currencySymbol,
      onTap: () => _showJournalDetailBottomSheet(flow),
      formatTransactionAmount: _formatTransactionAmount,
      formatBalance: _formatBalance,
      getJournalDisplayText: _getJournalDisplayText,
    );
  }
  
  Widget _buildRealItem(ActualFlow flow, bool showDate) {
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _locationSummary?.baseCurrencySymbol ?? flow.currency.symbol;

    return ActualFlowItem(
      flow: flow,
      showDate: showDate,
      currencySymbol: currencySymbol,
      onTap: () => _showRealDetailBottomSheet(flow),
      formatBalance: _formatBalance,
    );
  }
  
  void _showJournalDetailBottomSheet(JournalFlow flow) {
    // Use base currency symbol from location summary for consistent display
    final currencySymbol = _getCurrencySymbol();

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return JournalDetailSheet(
          flow: flow,
          currencySymbol: currencySymbol,
          formatTransactionAmount: _formatTransactionAmount,
          formatBalance: _formatBalance,
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
        return RealDetailSheet(
          flow: flow,
          baseCurrencySymbol: baseCurrencySymbol,
          formatBalance: _formatBalance,
          formatTransactionAmount: _formatTransactionAmount,
          formatCurrency: _formatCurrency,
        );
      },
    );
  }
}
