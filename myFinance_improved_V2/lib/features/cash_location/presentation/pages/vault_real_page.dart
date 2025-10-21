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
import 'package:myfinance_improved/shared/widgets/common/toss_loading_view.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import '../../data/models/vault_real_model.dart';
import '../../domain/entities/vault_real_entry.dart' as vault;
import '../providers/cash_location_providers.dart';

class VaultRealPage extends ConsumerStatefulWidget {
  const VaultRealPage({super.key});

  @override
  ConsumerState<VaultRealPage> createState() => _VaultRealPageState();
}

class _VaultRealPageState extends ConsumerState<VaultRealPage> {
  String _selectedFilter = 'All';
  
  // Pagination and scroll control
  final ScrollController _scrollController = ScrollController();
  int _currentOffset = 0;
  final int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  List<VaultRealEntry> _allRealEntries = [];
  
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
      final repository = ref.read(cashLocationRepositoryProvider);
      final newEntries = await repository.getVaultReal(
        companyId: companyId,
        storeId: storeId,
        offset: _currentOffset + _limit,
        limit: _limit,
      );
      
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
  
  List<VaultRealDisplay> _convertToDisplayItems(List<VaultRealEntry> entries) {
    final List<VaultRealDisplay> displayItems = [];
    
    for (final entry in entries) {
      displayItems.add(VaultRealDisplay(
        date: entry.recordDate,
        title: 'Vault Balance',
        locationName: entry.locationName,
        amount: entry.totalAmount,
        currencySymbol: entry.getCurrencySymbol(),
        realEntry: entry,
      ));
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
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    return '${isNegative ? "-" : ""}$symbol${formatter.format(absAmount.round())}';
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    
    if (companyId.isEmpty || storeId.isEmpty) {
      return TossScaffold(
        backgroundColor: TossColors.gray50,
        body: const Center(
          child: Text('Please select a company and store first'),
        ),
      );
    }
    
    final realDataAsync = ref.watch(vaultRealProvider(
      VaultRealParams(
        companyId: companyId,
        storeId: storeId,
        offset: 0,
        limit: _limit,
      ),
    ));
    
    return TossScaffold(
      backgroundColor: TossColors.gray50,
      appBar: TossAppBar1(
        title: 'Vault Total Real',
        backgroundColor: TossColors.gray50,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            // Content - Vault Real List fills remaining space
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                  TossSpacing.space4,
                ),
                child: realDataAsync.when(
                  data: (initialEntries) {
                    // Initialize the list only on first load
                    if (_allRealEntries.isEmpty && initialEntries.isNotEmpty) {
                      _allRealEntries = List<VaultRealEntry>.from(initialEntries);
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
                          'Failed to load vault balance records',
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
                            ref.invalidate(vaultRealProvider(
                              VaultRealParams(
                                companyId: companyId,
                                storeId: storeId,
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
  
  Widget _buildRealList(List<VaultRealDisplay> allItems) {
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
                      'No vault balance records found',
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
    ref.invalidate(vaultRealProvider(
      VaultRealParams(
        companyId: companyId,
        storeId: storeId,
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
        child: const TossLoadingView(),
      ),
    );
  }
  
  Widget _buildRealItem(VaultRealDisplay item, bool showDate) {
    final isNegative = item.amount < 0;
    
    return GestureDetector(
      onTap: () => _showVaultDetailBottomSheet(item),
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
                      _formatDate(item.date),
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            
            SizedBox(width: TossSpacing.space3),
            
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
                  SizedBox(height: 4),
                  Row(
                    children: [
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
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(width: TossSpacing.space2),
            
            // Amount (can be negative)
            Text(
              _formatCurrency(item.amount, item.currencySymbol),
              style: TossTextStyles.body.copyWith(
                color: isNegative ? TossColors.error : TossColors.gray800,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<VaultRealDisplay> _getFilteredItems(List<VaultRealDisplay> allItems) {
    var filtered = List<VaultRealDisplay>.from(allItems);
    
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
  
  void _showVaultDetailBottomSheet(VaultRealDisplay item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _VaultDetailBottomSheet(
          vaultRealItem: item,
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
                padding: EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
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
    return ['All', 'Today', 'Yesterday', 'Last Week', 'Last Month'];
  }
}

class _VaultDetailBottomSheet extends StatelessWidget {
  final VaultRealDisplay vaultRealItem;

  const _VaultDetailBottomSheet({
    required this.vaultRealItem,
  });

  String _formatCurrency(double amount, [String? currencySymbol]) {
    final formatter = NumberFormat('#,###', 'en_US');
    final symbol = currencySymbol ?? '';
    final isNegative = amount < 0;
    final absAmount = amount.abs();
    return '${isNegative ? "-" : ""}$symbol${formatter.format(absAmount.round())}';
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final realEntry = vaultRealItem.realEntry;
    final currencySymbol = vaultRealItem.currencySymbol;
    final totalValue = realEntry.totalAmount;
    final isNegative = totalValue < 0;
    
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
            padding: EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space5, TossSpacing.space5, TossSpacing.space4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Vault Balance Details',
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
                  // Total Running Balance
                  Container(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    decoration: BoxDecoration(
                      color: isNegative 
                          ? TossColors.error.withOpacity(0.1)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Running Balance',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatCurrency(totalValue, currencySymbol),
                              style: TossTextStyles.h1.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isNegative 
                                    ? TossColors.error
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.lock_outline,
                          color: isNegative 
                              ? TossColors.error
                              : Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Details
                  _buildDetailRow('Date', _formatDate(realEntry.recordDate)),
                  _buildDetailRow('Location', realEntry.locationName),
                  
                  const SizedBox(height: 24),
                  
                  // Running Denomination Breakdown
                  if (realEntry.currencySummary.isNotEmpty) ...[
                    Text(
                      'Running Denomination Balance',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: TossSpacing.space3),
                    
                    ...realEntry.currencySummary.expand((currency) =>
                      currency.denominations
                        .where((d) => d.quantity != 0) // Only show non-zero quantities
                        .map((denomination) => _buildRunningDenominationItem(denomination, currency.symbol))
                    ),
                  ],
                  
                  // Bottom padding
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
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
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
  
  Widget _buildRunningDenominationItem(vault.Denomination denomination, String symbol) {
    final isNegative = denomination.quantity < 0;
    
    return Container(
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      _formatCurrency(denomination.denominationValue, symbol),
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              // Running quantity
              Text(
                'Qty: ${denomination.quantity}',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: isNegative ? TossColors.error : TossColors.black87,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: TossSpacing.space2),
          
          // Running total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),

              // Running total (using subtotal since runningTotal doesn't exist)
              Text(
                _formatCurrency(denomination.subtotal, symbol),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isNegative ? TossColors.error : TossColors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
