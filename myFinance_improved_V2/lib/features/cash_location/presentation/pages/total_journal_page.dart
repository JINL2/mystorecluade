import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/extensions/string_extensions.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

// Import providers (includes domain entities via export)
import '../providers/cash_location_providers.dart';
import '../widgets/transaction_item.dart';
import '../widgets/sheets/transaction_detail_sheet.dart';
import '../widgets/sheets/filter_bottom_sheet.dart';
import '../formatters/cash_location_formatters.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TotalJournalPage extends ConsumerStatefulWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  final String journalType; // 'journal', 'real'
  
  const TotalJournalPage({
    super.key,
    required this.locationType,
    required this.journalType,
  });

  @override
  ConsumerState<TotalJournalPage> createState() => _TotalJournalPageState();
}

class _TotalJournalPageState extends ConsumerState<TotalJournalPage> {
  String _selectedFilter = 'All';
  
  // Pagination and scroll control
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<JournalEntry> _allJournalEntries = [];
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
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

    try {
      final params = CashJournalParams(
        companyId: companyId,
        storeId: storeId,
        locationType: widget.locationType,
        offset: _currentOffset + _limit,
        limit: _limit,
      );
      final newEntries = await ref.read(cashJournalProvider(params).future);

      setState(() {
        if (newEntries.isEmpty || newEntries.length < _limit) {
          _hasMoreData = false;
        }
        _allJournalEntries.addAll(newEntries);
        _currentOffset += _limit;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  
  List<TransactionDisplay> _convertToTransactions(List<JournalEntry> entries) {
    final List<TransactionDisplay> transactions = [];

    for (final entry in entries) {
      final transaction = CashLocationFormatters.getTransactionDisplay(entry, widget.locationType);
      if (transaction != null) {
        transactions.add(transaction);
      }
    }

    return transactions;
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}';
    } catch (e) {
      // If it's already in d/M format, return as is
      return dateStr;
    }
  }
  
  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    // Note: Currency symbol would come from database but not available in this page yet
    return formatter.format(amount.abs());
  }
  
  String _formatTransactionAmount(int amount, bool isIncome) {
    final formatter = NumberFormat('#,###', 'en_US');
    // Note: Currency symbol would come from database but not available in this page yet
    final prefix = isIncome ? '+' : '-';
    return '$prefix${formatter.format(amount.abs())}';
  }
  
  String get _pageTitle {
    String type = widget.locationType.capitalize();
    String journal = widget.journalType == 'journal' ? 'Total Journal' : 'Total Real';
    return '$type $journal';
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty || storeId.isEmpty) {
      return const TossScaffold(
        backgroundColor: TossColors.gray50,
        body: Center(
          child: Text('Please select a company and store first'),
        ),
      );
    }
    
    final journalDataAsync = ref.watch(cashJournalProvider(
      CashJournalParams(
        companyId: companyId,
        storeId: storeId,
        locationType: widget.locationType,
        offset: 0,
        limit: _limit,
      ),
    ),);
    
    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar(
        title: _pageTitle,
        backgroundColor: TossColors.gray50,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            // Content - Transaction List fills remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                ),
                child: journalDataAsync.when(
                  data: (initialEntries) {
                    // Initialize the list only on first load
                    if (_allJournalEntries.isEmpty && initialEntries.isNotEmpty) {
                      _allJournalEntries = List.from(initialEntries);
                      _currentOffset = 0;
                      _hasMoreData = initialEntries.length >= _limit;
                    }
                    
                    final transactions = _convertToTransactions(_allJournalEntries);
                    return _buildTransactionList(transactions);
                  },
                  loading: () => const Center(
                    child: TossLoadingView(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load transactions',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space4),
                        TossButton.primary(
                          text: 'Retry',
                          onPressed: () {
                            // Reset state and refresh the data
                            setState(() {
                              _allJournalEntries.clear();
                              _currentOffset = 0;
                              _hasMoreData = true;
                              _isLoadingMore = false;
                            });
                            ref.invalidate(cashJournalProvider(
                              CashJournalParams(
                                companyId: companyId,
                                storeId: storeId,
                                locationType: widget.locationType,
                                offset: 0,
                                limit: _limit,
                              ),
                            ),);
                          },
                        ),
                      ],
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
  
  
  Widget _buildTransactionList(List<TransactionDisplay> allTransactions) {
    final filteredTransactions = _getFilteredTransactions(allTransactions);
    
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        children: [
          // Header with filters
          _buildListHeader(),
          
          // Scrollable transaction items
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Text(
                      'No transactions found',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredTransactions.length + (_isLoadingMore || _hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredTransactions.length) {
                          if (_isLoadingMore) {
                            // Show loading indicator at the bottom
                            return _buildLoadingIndicator();
                          } else if (_hasMoreData) {
                            // Show message to load more
                            return _buildLoadMoreMessage();
                          }
                          return const SizedBox.shrink();
                        }
                        
                        final transaction = filteredTransactions[index];
                        final showDate = index == 0 || 
                            transaction.date != filteredTransactions[index - 1].date;
                        
                        return _buildTransactionItem(transaction, showDate);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _onRefresh() async {
    // Reset state and refresh data
    setState(() {
      _allJournalEntries.clear();
      _currentOffset = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
    });
    
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    // Invalidate to force refresh
    ref.invalidate(cashJournalProvider(
      CashJournalParams(
        companyId: companyId,
        storeId: storeId,
        locationType: widget.locationType,
        offset: 0,
        limit: _limit,
      ),
    ),);
  }
  
  Widget _buildLoadMoreMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
      child: Center(
        child: Text(
          'Scroll to load more',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
  
  Widget _buildListHeader() {
    return Container(
      padding: const EdgeInsets.only(
        left: TossSpacing.space5,
        right: TossSpacing.space4,
        top: TossSpacing.space4,
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
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: TossColors.gray600,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: const Center(
        child: TossLoadingView(),
      ),
    );
  }
  
  Widget _buildTransactionItem(TransactionDisplay transaction, bool showDate) {
    final bool isRealType = widget.journalType == 'real';

    return TransactionItem(
      transaction: transaction,
      showDate: showDate,
      isRealType: isRealType,
      onTap: () => _showTransactionDetailBottomSheet(transaction),
      formatDate: _formatDate,
      formatCurrency: _formatCurrency,
      formatTransactionAmount: _formatTransactionAmount,
    );
  }
  
  List<TransactionDisplay> _getFilteredTransactions(List<TransactionDisplay> allTransactions) {
    var filtered = List<TransactionDisplay>.from(allTransactions);
    
    // Apply filter based on journal type
    if (widget.journalType == 'journal') {
      // Journal tab filters
      if (_selectedFilter == 'Money In') {
        filtered = filtered.where((TransactionDisplay t) => t.isIncome == true).toList();
      } else if (_selectedFilter == 'Money Out') {
        filtered = filtered.where((TransactionDisplay t) => t.isIncome == false).toList();
      } else if (_selectedFilter == 'Today') {
        // Filter by today's date
        final today = DateTime.now();
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.year == today.year &&
                   transactionDate.month == today.month &&
                   transactionDate.day == today.day;
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Yesterday') {
        // Filter by yesterday's date
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.year == yesterday.year &&
                   transactionDate.month == yesterday.month &&
                   transactionDate.day == yesterday.day;
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Last Week') {
        // Filter by last week
        final lastWeek = DateTime.now().subtract(const Duration(days: 7));
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.isAfter(lastWeek);
          } catch (e) {
            return false;
          }
        }).toList();
      }
    } else {
      // Real tab filters - show only expenses
      filtered = filtered.where((TransactionDisplay t) => t.isIncome == false).toList();

      // Apply date filters for real tab too
      if (_selectedFilter == 'Today') {
        final today = DateTime.now();
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.year == today.year &&
                   transactionDate.month == today.month &&
                   transactionDate.day == today.day;
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Yesterday') {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.year == yesterday.year &&
                   transactionDate.month == yesterday.month &&
                   transactionDate.day == yesterday.day;
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Last Week') {
        final lastWeek = DateTime.now().subtract(const Duration(days: 7));
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.isAfter(lastWeek);
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Last Month') {
        final lastMonth = DateTime.now().subtract(const Duration(days: 30));
        filtered = filtered.where((TransactionDisplay t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.isAfter(lastMonth);
          } catch (e) {
            return false;
          }
        }).toList();
      }
    }
    
    return filtered;
  }
  
  void _showTransactionDetailBottomSheet(TransactionDisplay transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return TransactionDetailSheet(
          transaction: transaction,
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterBottomSheet(
          selectedFilter: _selectedFilter,
          filterOptions: _getFilterOptions(),
          onFilterSelected: (String filter) {
            setState(() {
              _selectedFilter = filter;
              // Reset scroll position when filter changes
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(0);
              }
            });
          },
        );
      },
    );
  }

  List<String> _getFilterOptions() {
    if (widget.journalType == 'journal') {
      // Journal tab filters
      return ['All', 'Money In', 'Money Out', 'Today', 'Yesterday', 'Last Week'];
    } else {
      // Real tab filters
      return ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
    }
  }
}
