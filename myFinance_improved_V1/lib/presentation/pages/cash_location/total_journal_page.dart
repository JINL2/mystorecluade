import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../../core/themes/toss_shadows.dart';
import '../../../core/themes/toss_colors.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../../data/services/cash_journal_service.dart';
import '../../providers/app_state_provider.dart';
import 'utils/string_extensions.dart';

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
      final service = ref.read(cashJournalServiceProvider);
      final newEntries = await service.getCashJournal(
        companyId: companyId,
        storeId: storeId,
        locationType: widget.locationType,
        offset: _currentOffset + _limit,
        limit: _limit,
      );
      
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
      final transaction = entry.getTransactionDisplay(widget.locationType);
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
      return TossScaffold(
        backgroundColor: TossColors.backgroundPage,
        body: const Center(
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
    ));
    
    return TossScaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: TossAppBar(
        title: _pageTitle,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            // Content - Transaction List fills remaining space
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
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
                    child: CircularProgressIndicator(),
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
                        const SizedBox(height: 16),
                        ElevatedButton(
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
                            ));
                          },
                          child: const Text('Retry'),
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
    ));
  }
  
  Widget _buildLoadMoreMessage() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
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
      padding: EdgeInsets.only(
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
            Icon(
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
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
  
  Widget _buildTransactionItem(TransactionDisplay transaction, bool showDate) {
    final bool isRealType = widget.journalType == 'real';
    
    return GestureDetector(
      onTap: () => _showTransactionDetailBottomSheet(transaction),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
        children: [
          // Date section
          Container(
            width: 42,
            padding: EdgeInsets.only(left: TossSpacing.space1),
            child: showDate
                ? Text(
                    _formatDate(transaction.date),
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          
          SizedBox(width: TossSpacing.space3),
          
          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: TossColors.gray800,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          // Location name
                          Flexible(
                            child: Text(
                              transaction.locationName,
                              style: TossTextStyles.caption.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (transaction.personName.isNotEmpty) ...[
                            Text(
                              ' • ',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray400,
                                fontSize: 12,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                transaction.personName,
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray500,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                          if (transaction.time.isNotEmpty) ...[
                            Text(
                              ' • ',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray400,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              transaction.time,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: TossSpacing.space2),
          
          // Amount - different display for Real vs Journal
          if (isRealType)
            Text(
              _formatCurrency(transaction.amount.toInt()),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            )
          else
            Text(
              _formatTransactionAmount(transaction.amount.toInt(), transaction.isIncome),
              style: TossTextStyles.body.copyWith(
                color: transaction.isIncome 
                    ? Theme.of(context).colorScheme.primary 
                    : TossColors.gray800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
        ],
        ),
      ),
    );
  }
  
  List<TransactionDisplay> _getFilteredTransactions(List<TransactionDisplay> allTransactions) {
    var filtered = List<TransactionDisplay>.from(allTransactions);
    
    // Apply filter based on journal type
    if (widget.journalType == 'journal') {
      // Journal tab filters
      if (_selectedFilter == 'Money In') {
        filtered = filtered.where((t) => t.isIncome == true).toList();
      } else if (_selectedFilter == 'Money Out') {
        filtered = filtered.where((t) => t.isIncome == false).toList();
      } else if (_selectedFilter == 'Today') {
        // Filter by today's date
        final today = DateTime.now();
        filtered = filtered.where((t) {
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
        filtered = filtered.where((t) {
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
        filtered = filtered.where((t) {
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
      filtered = filtered.where((t) => t.isIncome == false).toList();
      
      // Apply date filters for real tab too
      if (_selectedFilter == 'Today') {
        final today = DateTime.now();
        filtered = filtered.where((t) {
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
        filtered = filtered.where((t) {
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
        filtered = filtered.where((t) {
          try {
            final transactionDate = DateTime.parse(t.date);
            return transactionDate.isAfter(lastWeek);
          } catch (e) {
            return false;
          }
        }).toList();
      } else if (_selectedFilter == 'Last Month') {
        final lastMonth = DateTime.now().subtract(const Duration(days: 30));
        filtered = filtered.where((t) {
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
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _TransactionDetailBottomSheet(
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
                  borderRadius: BorderRadius.circular(TossBorderRadius.micro),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.fromLTRB(24, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Transactions',
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
              
              // Filter options
              ..._getFilterOptions().map((option) => 
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
          // Reset scroll position when filter changes
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                size: 24,
              ),
          ],
        ),
      ),
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


class _TransactionDetailBottomSheet extends StatelessWidget {
  final TransactionDisplay transaction;

  const _TransactionDetailBottomSheet({
    required this.transaction,
  });

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final journalEntry = transaction.journalEntry;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
              borderRadius: BorderRadius.circular(TossBorderRadius.micro),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.title,
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
          
          // Transaction Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount and type
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: transaction.isIncome 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.isIncome ? 'Money In' : 'Money Out',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(transaction.amount),
                            style: TossTextStyles.h1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: transaction.isIncome 
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        transaction.isIncome ? Icons.trending_up : Icons.trending_down,
                        color: transaction.isIncome 
                            ? Theme.of(context).colorScheme.primary
                            : Colors.red,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Transaction Details
                _buildDetailRow(
                  'Date', 
                  _formatDate(transaction.date),
                ),
                _buildDetailRow(
                  'Time', 
                  _formatTime(journalEntry.transactionDate),
                ),
                _buildDetailRow(
                  'Location', 
                  transaction.locationName,
                ),
                if (transaction.description.isNotEmpty)
                  _buildDetailRow(
                    'Description', 
                    transaction.description,
                  ),
                
                const SizedBox(height: 24),
                
                // Journal Lines Section
                if (journalEntry.lines.length > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction Details',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      ..._buildFilteredJournalLines(journalEntry, transaction),
                    ],
                  ),
              ],
            ),
          ),
          
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildFilteredJournalLines(JournalEntry journalEntry, TransactionDisplay transaction) {
    final filteredLines = <JournalLine>[];
    final seenCashLocations = <String>{};
    
    for (final line in journalEntry.lines) {
      // For cash locations, check if we've already added this location
      if (line.cashLocationId != null) {
        final locationKey = '${line.cashLocationId}_${line.locationName}';
        // Skip if we've seen this cash location and it's the same as the main transaction location
        if (seenCashLocations.contains(locationKey) && 
            line.locationName == transaction.locationName) {
          continue;
        }
        seenCashLocations.add(locationKey);
        filteredLines.add(line);
      } else {
        // Always include non-cash accounts
        filteredLines.add(line);
      }
    }
    
    return filteredLines.map((line) => _buildJournalLine(line)).toList();
  }
  
  Widget _buildJournalLine(JournalLine line) {
    final amount = line.debit > 0 ? line.debit : line.credit;
    final isDebit = line.debit > 0;
    
    // Determine the display name - use location name for cash locations, otherwise account name
    String displayName;
    if (line.cashLocationId != null && line.locationName != null) {
      // This is a cash location transaction, show the location name
      displayName = line.locationName!;
      if (line.locationType != null) {
        // Add type indicator if available (e.g., "throng (Cash)")
        final typeLabel = line.locationType!.capitalize();
        displayName = '$displayName ($typeLabel)';
      }
    } else {
      // Regular account, format the account name
      displayName = _formatAccountName(line.accountName);
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${isDebit ? '+' : '-'}${_formatCurrency(amount)}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDebit ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (line.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              line.description,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  String _formatAccountName(String accountName) {
    // Convert account names like "office supplies expenses" to "Office Supplies"
    final words = accountName.toLowerCase()
        .replaceAll('expenses', '')
        .replaceAll('expense', '')
        .replaceAll('_', ' ')
        .trim()
        .split(' ');
    
    return words.map((word) => 
      word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : ''
    ).join(' ');
  }
}