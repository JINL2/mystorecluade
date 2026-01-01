import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/core/monitoring/sentry_config.dart';
import 'package:myfinance_improved/core/utils/number_formatter.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../providers/cash_location_providers.dart';
import '../widgets/account_balance_card_widget.dart';
import '../widgets/journal_detail_sheet.dart';
import '../widgets/real_detail_sheet.dart';
import '../widgets/account_detail/account_detail_widgets.dart';
import 'account_settings_page.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
  late AccountDetailDialogs _dialogs;
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
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dialogs = AccountDetailDialogs(context);
      _refreshDataSilently();
    });
  }

  void _onTabChanged() {
    setState(() {
      _selectedTab = _tabController.index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshDataSilently();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // Data Loading Methods
  // ============================================================

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    final appState = ref.read(appStateProvider);
    if (widget.locationId == null) return;

    try {
      final useCase = ref.read(getStockFlowUseCaseProvider);
      final response = await useCase(
        StockFlowParams(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
          cashLocationId: widget.locationId!,
          offset: _currentOffset + _limit,
          limit: _limit,
        ),
      );

      if (response.success && response.data != null) {
        setState(() {
          _allJournalFlows.addAll(response.data!.journalFlows);
          _allActualFlows.addAll(response.data!.actualFlows);
          _sortFlowsByDate();
          _currentOffset += _limit;
          _hasMoreData = response.pagination?.hasMore ?? false;
          _isLoadingMore = false;
        });
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Failed to load more data',
          extra: {'locationId': widget.locationId, 'offset': _currentOffset});
      setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _onRefresh() async {
    if (!mounted) return;

    setState(() {
      _allJournalFlows.clear();
      _allActualFlows.clear();
      _currentOffset = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
    });

    final appState = ref.read(appStateProvider);
    if (widget.locationId == null ||
        widget.locationId!.isEmpty ||
        appState.companyChoosen.isEmpty ||
        appState.storeChoosen.isEmpty) return;

    _invalidateProviders(appState);

    try {
      final response = await ref.read(stockFlowProvider(
        StockFlowParams(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
          cashLocationId: widget.locationId!,
          offset: 0,
          limit: _limit,
        ),
      ).future);

      if (!mounted) return;

      if (response.success && response.data != null) {
        setState(() {
          _allJournalFlows = List.from(response.data!.journalFlows);
          _allActualFlows = List.from(response.data!.actualFlows);
          _sortFlowsByDate();
          _locationSummary = response.data!.locationSummary;
          _currentOffset = 0;
          _hasMoreData = response.pagination?.hasMore ?? false;
        });
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Failed to refresh data',
          extra: {'locationId': widget.locationId});
    }

    await _fetchUpdatedBalance();
  }

  Future<void> _refreshDataSilently() async {
    final appState = ref.read(appStateProvider);
    if (widget.locationId == null ||
        appState.companyChoosen.isEmpty ||
        appState.storeChoosen.isEmpty) return;

    try {
      _invalidateProviders(appState);

      final response = await ref.read(stockFlowProvider(
        StockFlowParams(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
          cashLocationId: widget.locationId!,
          offset: 0,
          limit: _limit,
        ),
      ).future);

      if (response.success && response.data != null && mounted) {
        setState(() {
          _allJournalFlows = List.from(response.data!.journalFlows);
          _allActualFlows = List.from(response.data!.actualFlows);
          _sortFlowsByDate();
          _locationSummary = response.data!.locationSummary;
          _currentOffset = 0;
          _hasMoreData = response.pagination?.hasMore ?? false;
        });
      }

      await _fetchUpdatedBalance();
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Silent refresh failed',
          extra: {'locationId': widget.locationId});
    }
  }

  void _invalidateProviders(AppState appState) {
    ref.invalidate(stockFlowProvider(
      StockFlowParams(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        cashLocationId: widget.locationId!,
        offset: 0,
        limit: _limit,
      ),
    ));

    ref.invalidate(allCashLocationsProvider(
      CashLocationQueryParams(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
      ),
    ));
  }

  Future<void> _fetchUpdatedBalance() async {
    if (!mounted) return;

    final appState = ref.read(appStateProvider);
    if (widget.locationId == null ||
        widget.locationId!.isEmpty ||
        appState.companyChoosen.isEmpty ||
        appState.storeChoosen.isEmpty) return;

    try {
      final allLocations = await ref.read(allCashLocationsProvider(
        CashLocationQueryParams(
          companyId: appState.companyChoosen,
          storeId: appState.storeChoosen,
        ),
      ).future);

      if (!mounted) return;

      CashLocation? currentLocation;
      for (final location in allLocations) {
        if (location.locationId == widget.locationId) {
          currentLocation = location;
          break;
        }
      }

      if (currentLocation != null) {
        setState(() {
          _updatedTotalJournal = currentLocation!.totalJournalCashAmount.round();
          _updatedTotalReal = currentLocation.totalRealCashAmount.round();
          _updatedCashDifference = currentLocation.cashDifference.round();
        });
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Failed to fetch updated balance',
          extra: {'locationId': widget.locationId});
    }
  }

  void _sortFlowsByDate() {
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

  // ============================================================
  // Business Logic Handlers
  // ============================================================

  Future<void> _handleErrorMapping(double errorAmount) async {
    _dialogs.showProcessingDialog();

    try {
      final appState = ref.read(appStateProvider);
      final userId = _extractUserId(appState);

      if (widget.locationId == null || widget.locationId!.isEmpty) {
        _dialogs.closeDialog();
        _dialogs.showErrorDialog('Location ID is missing');
        return;
      }

      final useCase = ref.read(createErrorAdjustmentUseCaseProvider);
      final result = await useCase(
        CreateErrorAdjustmentParams(
          differenceAmount: errorAmount,
          companyId: appState.companyChoosen,
          userId: userId,
          locationName: widget.accountName,
          cashLocationId: widget.locationId!,
          storeId: appState.storeChoosen,
        ),
      );

      _dialogs.closeDialog();

      result.when(
        success: (journalId, message, additionalData) async {
          await Future.delayed(const Duration(milliseconds: 500));
          await _onRefresh();
          _dialogs.showSuccessDialog(isError: true);
        },
        failure: (error, errorCode, errorDetails) {
          _dialogs.showErrorDialog(error);
        },
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Error mapping failed',
          extra: {'locationId': widget.locationId, 'errorAmount': errorAmount});
      _dialogs.closeDialog();
      _dialogs.showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  Future<void> _handleForeignCurrencyTranslation(double errorAmount) async {
    _dialogs.showProcessingDialog();

    try {
      final appState = ref.read(appStateProvider);
      final userId = _extractUserId(appState);

      if (widget.locationId == null || widget.locationId!.isEmpty) {
        _dialogs.closeDialog();
        _dialogs.showErrorDialog('Location ID is missing');
        return;
      }

      final useCase = ref.read(createForeignCurrencyTranslationUseCaseProvider);
      final result = await useCase(
        CreateForeignCurrencyTranslationParams(
          differenceAmount: errorAmount,
          companyId: appState.companyChoosen,
          userId: userId,
          locationName: widget.accountName,
          cashLocationId: widget.locationId!,
          storeId: appState.storeChoosen,
        ),
      );

      _dialogs.closeDialog();

      result.when(
        success: (journalId, message, additionalData) async {
          await Future.delayed(const Duration(milliseconds: 500));
          await _onRefresh();
          _dialogs.showSuccessDialog(isError: false);
        },
        failure: (error, errorCode, errorDetails) {
          _dialogs.showErrorDialog(error);
        },
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(e, stackTrace,
          hint: 'AccountDetailPage: Foreign currency translation failed',
          extra: {'locationId': widget.locationId, 'errorAmount': errorAmount});
      _dialogs.closeDialog();
      _dialogs.showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  String _extractUserId(AppState appState) {
    try {
      if (appState.user['user_id'] != null) {
        return appState.user['user_id'].toString();
      } else if (appState.user['id'] != null) {
        return appState.user['id'].toString();
      }
    } catch (e) {
      // Handle error if user object structure is unexpected
    }
    return '';
  }

  void _handleMappingConfirmation(String mappingType) async {
    final totalJournal =
        _updatedTotalJournal ?? widget.totalJournal ?? widget.balance;
    final totalReal = _updatedTotalReal ?? widget.totalReal ?? widget.balance;
    final errorAmount = totalReal - totalJournal;
    final currencySymbol = widget.currencySymbol ?? '';

    final confirmed = await _dialogs.showMappingConfirmationDialog(
      mappingType: mappingType,
      errorAmount: errorAmount.toDouble(),
      currencySymbol: currencySymbol,
      formatCurrencyWithSign: _formatCurrencyWithSign,
    );

    if (confirmed) {
      if (mappingType == 'Exchange Rate Differences') {
        await _handleForeignCurrencyTranslation(errorAmount.toDouble());
      } else if (mappingType == 'Error') {
        await _handleErrorMapping(errorAmount.toDouble());
      }
    }
  }

  // ============================================================
  // Formatting Helpers
  // ============================================================

  String _getCurrencySymbol() {
    return _locationSummary?.baseCurrencySymbol ??
        (_locationSummary?.currencyCode == 'VND'
            ? '₫'
            : widget.currencySymbol ?? '');
  }

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final symbol = currencySymbol ?? '';
    final isNegative = amount < 0;
    final formatted = NumberFormatter.formatWithCommas(amount.abs().round());
    return '${isNegative ? "-" : ""}$symbol$formatted';
  }

  String _formatCurrencyWithSign(double amount, [String? currencySymbol]) =>
      _formatCurrency(amount, currencySymbol);

  String _formatTransactionAmount(double amount, [String? currencySymbol]) {
    final symbol = currencySymbol ?? '';
    final prefix = amount > 0 ? '+$symbol' : '-$symbol';
    return '$prefix${NumberFormatter.formatWithCommas(amount.abs().round())}';
  }

  String _formatBalance(double amount, [String? currencySymbol]) {
    final symbol = currencySymbol ?? '';
    return '$symbol${NumberFormatter.formatWithCommas(amount.round())}';
  }

  String _getJournalDisplayText(JournalFlow flow) {
    if (flow.counterAccount != null &&
        flow.counterAccount!.accountName.isNotEmpty) {
      return flow.counterAccount!.accountName;
    }
    if (flow.journalDescription.isNotEmpty) {
      return flow.journalDescription;
    }
    return 'Transaction';
  }

  // ============================================================
  // Bottom Sheet Handlers
  // ============================================================

  void _showFilterBottomSheet() {
    _dialogs.showFilterBottomSheet(
      selectedTab: _selectedTab,
      selectedFilter: _selectedFilter,
      onFilterSelected: (filter) {
        setState(() => _selectedFilter = filter);
      },
    );
  }

  void _showAutoMappingBottomSheet() {
    _dialogs.showAutoMappingBottomSheet(
      onMappingSelected: _handleMappingConfirmation,
    );
  }

  void _showJournalDetailBottomSheet(JournalFlow flow) {
    final currencySymbol = _getCurrencySymbol();
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => JournalDetailSheet(
        flow: flow,
        currencySymbol: currencySymbol,
        formatTransactionAmount: _formatTransactionAmount,
        formatBalance: _formatBalance,
      ),
    );
  }

  void _showRealDetailBottomSheet(ActualFlow flow) {
    final baseCurrencySymbol =
        _locationSummary?.baseCurrencySymbol ?? flow.currency.symbol;
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (context) => RealDetailSheet(
        flow: flow,
        baseCurrencySymbol: baseCurrencySymbol,
        formatBalance: _formatBalance,
        formatTransactionAmount: _formatTransactionAmount,
        formatCurrency: _formatCurrency,
      ),
    );
  }

  // ============================================================
  // Build Methods
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    if (appState.companyChoosen.isEmpty ||
        appState.storeChoosen.isEmpty ||
        widget.locationId == null ||
        widget.locationId!.isEmpty) {
      return _buildEmptyState();
    }

    final stockFlowAsync = ref.watch(stockFlowProvider(
      StockFlowParams(
        companyId: appState.companyChoosen,
        storeId: appState.storeChoosen,
        cashLocationId: widget.locationId!,
        offset: 0,
        limit: _limit,
      ),
    ));

    return TossScaffold(
      appBar: _buildAppBar(),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: stockFlowAsync.when(
                data: (response) => _buildContent(response),
                loading: () => const Center(child: TossLoadingView()),
                error: (error, stack) => _buildErrorState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TossAppBar _buildAppBar() {
    return TossAppBar(
      title: widget.accountName,
      backgroundColor: TossColors.gray50,
      secondaryActionIcon: Icons.settings_outlined,
      onSecondaryAction: () async {
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
        await _refreshDataSilently();
      },
    );
  }

  Widget _buildEmptyState() {
    return TossScaffold(
      appBar: _buildAppBar(),
      backgroundColor: TossColors.gray50,
      body: SafeArea(
        child: Center(
          child: Text(
            widget.locationId == null || widget.locationId!.isEmpty
                ? 'Location ID is missing'
                : 'Please select a company and store',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error loading data',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
          SizedBox(height: TossSpacing.space2),
          ElevatedButton(
            onPressed: _onRefresh,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(StockFlowResponse response) {
    if (response.success && response.data != null) {
      _updateCachedDataIfNeeded(response);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: _buildBalanceCard(),
            ),
            TransactionListSection(
              tabController: _tabController,
              selectedTab: _selectedTab,
              selectedFilter: _selectedFilter,
              onFilterTap: _showFilterBottomSheet,
              journalFlows: _allJournalFlows,
              actualFlows: _allActualFlows,
              hasMoreData: _hasMoreData,
              isLoadingMore: _isLoadingMore,
              onLoadMore: _loadMoreData,
              getJournalDisplayText: _getJournalDisplayText,
              formatTransactionAmount: _formatTransactionAmount,
              formatBalance: _formatBalance,
              onJournalItemTap: _showJournalDetailBottomSheet,
              onRealItemTap: _showRealDetailBottomSheet,
              currencySymbol: _getCurrencySymbol(),
              baseCurrencySymbol: _locationSummary?.baseCurrencySymbol,
            ),
            if (_isLoadingMore)
              Padding(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: TossLoadingView(),
              ),
          ],
        ),
      ),
    );
  }

  void _updateCachedDataIfNeeded(StockFlowResponse response) {
    if (_allJournalFlows.isEmpty ||
        _allActualFlows.isEmpty ||
        _allJournalFlows.length != response.data!.journalFlows.length ||
        _allActualFlows.length != response.data!.actualFlows.length) {
      _allJournalFlows = List.from(response.data!.journalFlows);
      _allActualFlows = List.from(response.data!.actualFlows);
      _sortFlowsByDate();
      _locationSummary = response.data!.locationSummary;
      _currentOffset = 0;
      _hasMoreData = response.pagination?.hasMore ?? false;
    }
  }

  Widget _buildBalanceCard() {
    final totalJournal =
        _updatedTotalJournal ?? widget.totalJournal ?? widget.balance;
    final totalReal = _updatedTotalReal ?? widget.totalReal ?? widget.balance;
    final error = _updatedCashDifference ??
        widget.cashDifference ??
        (totalReal - totalJournal);
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
}
