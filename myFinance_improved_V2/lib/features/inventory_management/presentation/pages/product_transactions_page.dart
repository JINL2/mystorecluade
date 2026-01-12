import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_dimensions.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../utils/store_utils.dart';
import '../widgets/product_transactions/transaction_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:myfinance_improved/shared/widgets/organisms/skeleton/toss_list_skeleton.dart';

/// Product Transactions Page - Shows history of stock movements
class ProductTransactionsPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductTransactionsPage({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductTransactionsPage> createState() =>
      _ProductTransactionsPageState();
}

class _ProductTransactionsPageState
    extends ConsumerState<ProductTransactionsPage> {
  String _selectedStoreId = '';
  String _selectedStoreName = '';
  DateRange? _selectedDateRange;

  // Transaction data state
  List<ProductHistoryEntry> _transactions = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    // Initialize with current store
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      setState(() {
        _selectedStoreId = appState.storeChoosen;
        _selectedStoreName = appState.storeName;
      });
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _isLoading = true;
      });
    }

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.getProductHistory(
        companyId: appState.companyChoosen,
        storeId: _selectedStoreId.isNotEmpty ? _selectedStoreId : appState.storeChoosen,
        productId: widget.product.id,
        variantId: widget.product.variantId,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (mounted && result != null) {
        setState(() {
          if (refresh || _currentPage == 1) {
            _transactions = result.entries;
          } else {
            _transactions.addAll(result.entries);
          }
          _totalPages = result.totalPages;
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _loadTransactions();
  }

  /// Filter transactions by date range (client-side filtering)
  List<ProductHistoryEntry> _getFilteredTransactions() {
    if (_selectedDateRange == null) {
      return _transactions;
    }

    return _transactions.where((entry) {
      final entryDate = _parseCreatedAt(entry.createdAt);
      if (entryDate == null) return true; // Include if can't parse

      // Check if entry date is within selected range
      final startOfDay = DateTime(
        _selectedDateRange!.start.year,
        _selectedDateRange!.start.month,
        _selectedDateRange!.start.day,
      );
      final endOfDay = DateTime(
        _selectedDateRange!.end.year,
        _selectedDateRange!.end.month,
        _selectedDateRange!.end.day,
        23, 59, 59,
      );

      return entryDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          entryDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
    }).toList();
  }

  /// Parse created_at string to DateTime
  DateTime? _parseCreatedAt(String createdAt) {
    try {
      final parts = createdAt.split(' ');
      if (parts.length != 2) return null;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length < 2) return null;

      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    // Get stores list
    final stores = StoreUtils.getCompanyStores(appState);

    // Apply date filter
    final filteredTransactions = _getFilteredTransactions();

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with store selector
            _buildTopBar(context, stores),
            // Product info
            _buildProductInfo(),
            // Date range indicator
            if (_selectedDateRange != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: TossSpacing.iconSM2,
                      color: TossColors.primary,
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      _selectedDateRange!.toShortString(),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.primary,
                        fontWeight: TossFontWeight.medium,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: TossSpacing.iconSM,
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            // Transactions list
            Expanded(
              child: _isLoading
                  ? const TossListSkeleton(
                      itemCount: 8,
                      style: ListSkeletonStyle.transaction,
                    )
                  : filteredTransactions.isEmpty
                      ? _buildEmptyState()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 200 &&
                                !_isLoadingMore &&
                                _currentPage < _totalPages) {
                              _loadMore();
                            }
                            return false;
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TossSpacing.space4,
                            ),
                            itemCount: filteredTransactions.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredTransactions.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(TossSpacing.space4),
                                  child: TossLoadingView(),
                                );
                              }
                              return TransactionItem(
                                transaction: filteredTransactions[index],
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: TossSpacing.icon4XL,
            color: TossColors.gray400,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'No transactions yet',
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Transaction history will appear here',
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, List<StoreOption> stores) {
    return Container(
      height: TossDimensions.headerHeightLarge,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: TossSpacing.iconLG2,
              height: TossSpacing.iconLG2,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                size: TossSpacing.iconMD + TossSpacing.space0_5,
                color: TossColors.gray900,
              ),
            ),
          ),
          // Store selector
          GestureDetector(
            onTap: () => _showStorePicker(context, stores),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedStoreName.isNotEmpty
                      ? _selectedStoreName
                      : 'All Stores',
                  style: TossTextStyles.titleLarge.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(width: TossSpacing.space1),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: TossSpacing.iconMD,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
          // Date filter button
          GestureDetector(
            onTap: () => _showDateRangePicker(context),
            child: Container(
              width: TossSpacing.iconLG2,
              height: TossSpacing.iconLG2,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: TossSpacing.iconMD,
                    color: _selectedDateRange != null
                        ? TossColors.primary
                        : TossColors.gray900,
                  ),
                  // Active indicator dot
                  if (_selectedDateRange != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: TossDimensions.statusDotXS,
                        height: TossDimensions.statusDotXS,
                        decoration: BoxDecoration(
                          color: TossColors.primary,
                          shape: BoxShape.circle,
                        ),
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

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${widget.product.name} · Qty in-store: ${widget.product.onHand} · Qty total: ${widget.product.onHand}',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStorePicker(BuildContext context, List<StoreOption> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xl)),
      ),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              Container(
                width: TossDimensions.dragHandleWidth,
                height: TossDimensions.dragHandleHeight,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Select Store',
                style: TossTextStyles.titleLarge.copyWith(
                  color: TossColors.gray900,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return ListTile(
                      leading: Icon(
                        Icons.store_outlined,
                        color: store.id == _selectedStoreId
                            ? TossColors.primary
                            : TossColors.gray600,
                      ),
                      title: Text(
                        store.name,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.medium,
                          color: store.id == _selectedStoreId
                              ? TossColors.primary
                              : TossColors.gray900,
                        ),
                      ),
                      trailing: store.id == _selectedStoreId
                          ? Icon(
                              Icons.check,
                              color: TossColors.primary,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _selectedStoreId = store.id;
                          _selectedStoreName = store.name;
                        });
                        // Reload transactions with new store
                        _loadTransactions(refresh: true);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    CalendarTimeRange.show(
      context: context,
      initialRange: _selectedDateRange,
      onRangeSelected: (range) {
        setState(() {
          _selectedDateRange = range;
        });
        // Client-side filtering is applied in _getFilteredTransactions()
      },
    );
  }

}
