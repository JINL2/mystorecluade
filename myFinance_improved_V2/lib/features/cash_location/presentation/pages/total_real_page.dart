import 'package:flutter/material.dart';
import '../formatters/cash_location_formatters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/extensions/string_extensions.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_shadows.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';

import '../../domain/entities/bank_real_entry.dart' as bank;
import '../../domain/entities/cash_real_entry.dart' as cash;
import '../providers/cash_location_providers.dart';
import '../widgets/sheets/denomination_detail_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class TotalRealPage extends ConsumerStatefulWidget {
  final String locationType; // 'cash', 'bank', 'vault'
  
  const TotalRealPage({
    super.key,
    required this.locationType,
  });

  @override
  ConsumerState<TotalRealPage> createState() => _TotalRealPageState();
}

class _TotalRealPageState extends ConsumerState<TotalRealPage> {
  String _selectedFilter = 'All';
  
  // Pagination and scroll control
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<CashRealEntry> _allRealEntries = [];
  
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
      final useCase = ref.read(getCashRealUseCaseProvider);
      final newEntries = await useCase(CashRealParams(
        companyId: companyId,
        storeId: storeId,
        locationType: widget.locationType,
        offset: _currentOffset + _limit,
        limit: _limit,
      ));
      
      setState(() {
        if (newEntries.isEmpty || newEntries.length < _limit) {
          _hasMoreData = false;
        }
        _allRealEntries.addAll(newEntries);
        _currentOffset += _limit;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }
  
  List<CashRealDisplay> _convertToDisplayItems(List<CashRealEntry> entries) {
    final List<CashRealDisplay> displayItems = [];
    
    for (final entry in entries) {
      displayItems.add(CashRealDisplay(
        date: entry.recordDate,
        time: CashLocationFormatters.formatCashRealTime(entry),
        title: entry.getTransactionType(),
        locationName: entry.locationName,
        amount: entry.totalAmount,
        realEntry: entry,
      ),);
    }
    
    return displayItems;
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}';
    } catch (e) {
      return dateStr;
    }
  }
  
  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    return '$symbol${formatter.format(amount.round())}';
  }
  
  String get _pageTitle {
    String type = widget.locationType.capitalize();
    return '$type Total Real';
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
    
    final realDataAsync = ref.watch(cashRealProvider(
      CashRealParams(
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
            
            // Content - Cash Real List fills remaining space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                ),
                child: realDataAsync.when(
                  data: (initialEntries) {
                    // Initialize the list only on first load
                    if (_allRealEntries.isEmpty && initialEntries.isNotEmpty) {
                      _allRealEntries = List<CashRealEntry>.from(initialEntries);
                      _currentOffset = 0;
                      _hasMoreData = initialEntries.length >= _limit;
                    }
                    
                    final displayItems = _convertToDisplayItems(_allRealEntries);
                    return _buildRealList(displayItems);
                  },
                  loading: () => const Center(
                    child: TossLoadingView(),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Failed to load cash counting records',
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                        const SizedBox(height: TossSpacing.space4),
                        ElevatedButton(
                          onPressed: () {
                            // Reset state and refresh the data
                            setState(() {
                              _allRealEntries.clear();
                              _currentOffset = 0;
                              _hasMoreData = true;
                              _isLoadingMore = false;
                            });
                            ref.invalidate(cashRealProvider(
                              CashRealParams(
                                companyId: companyId,
                                storeId: storeId,
                                locationType: widget.locationType,
                                offset: 0,
                                limit: _limit,
                              ),
                            ),);
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
  
  Widget _buildRealList(List<CashRealDisplay> allItems) {
    final filteredItems = _getFilteredItems(allItems);
    
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
          
          // Scrollable real items
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Text(
                      'No cash counting records found',
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
                      itemCount: filteredItems.length + (_isLoadingMore || _hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredItems.length) {
                          if (_isLoadingMore) {
                            return _buildLoadingIndicator();
                          } else if (_hasMoreData) {
                            return _buildLoadMoreMessage();
                          }
                          return const SizedBox.shrink();
                        }
                        
                        final item = filteredItems[index];
                        final showDate = index == 0 || 
                            item.date != filteredItems[index - 1].date;
                        
                        return _buildRealItem(item, showDate);
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
      _allRealEntries.clear();
      _currentOffset = 0;
      _hasMoreData = true;
      _isLoadingMore = false;
    });
    
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    // Invalidate to force refresh
    ref.invalidate(cashRealProvider(
      CashRealParams(
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
  
  Widget _buildRealItem(CashRealDisplay item, bool showDate) {
    return GestureDetector(
      onTap: () => _showDenominationDetailBottomSheet(item),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Date section
            Container(
              width: 42,
              padding: const EdgeInsets.only(left: TossSpacing.space1),
              child: showDate
                  ? Text(
                      _formatDate(item.date),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            
            const SizedBox(width: TossSpacing.space3),
            
            // Real details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: TossColors.gray800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            // Location name
                            Flexible(
                              child: Text(
                                item.locationName,
                                style: TossTextStyles.caption.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.time.isNotEmpty) ...[
                              Text(
                                ' • ',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray400,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                item.time,
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
            
            const SizedBox(width: TossSpacing.space2),
            
            // Amount
            Text(
              _formatCurrency(item.amount, item.realEntry.getCurrencySymbol()),
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<CashRealDisplay> _getFilteredItems(List<CashRealDisplay> allItems) {
    var filtered = List<CashRealDisplay>.from(allItems);
    
    // Apply filter based on selected filter
    if (_selectedFilter == 'Today') {
      final today = DateTime.now();
      filtered = filtered.where((item) {
        try {
          final itemDate = DateTime.parse(item.date);
          return itemDate.year == today.year &&
                 itemDate.month == today.month &&
                 itemDate.day == today.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Yesterday') {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      filtered = filtered.where((item) {
        try {
          final itemDate = DateTime.parse(item.date);
          return itemDate.year == yesterday.year &&
                 itemDate.month == yesterday.month &&
                 itemDate.day == yesterday.day;
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Last Week') {
      final lastWeek = DateTime.now().subtract(const Duration(days: 7));
      filtered = filtered.where((item) {
        try {
          final itemDate = DateTime.parse(item.date);
          return itemDate.isAfter(lastWeek);
        } catch (e) {
          return false;
        }
      }).toList();
    } else if (_selectedFilter == 'Last Month') {
      final lastMonth = DateTime.now().subtract(const Duration(days: 30));
      filtered = filtered.where((item) {
        try {
          final itemDate = DateTime.parse(item.date);
          return itemDate.isAfter(lastMonth);
        } catch (e) {
          return false;
        }
      }).toList();
    }
    
    return filtered;
  }
  
  void _showDenominationDetailBottomSheet(CashRealDisplay item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DenominationDetailSheet(
          cashRealItem: item,
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
                      'Filter Records',
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
                _buildFilterOption(option, _selectedFilter == option),
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
    return ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
  }
}
