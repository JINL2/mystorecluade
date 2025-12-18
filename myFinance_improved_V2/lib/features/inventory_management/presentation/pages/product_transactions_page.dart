import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/calendar_time_range.dart';
import '../../di/inventory_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/inventory_repository.dart';

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
  int _totalCount = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print('🔴 [ProductTransactions] initState called - product: ${widget.product.id}');
    // Initialize with current store
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: avoid_print
      print('🔴 [ProductTransactions] postFrameCallback called');
      final appState = ref.read(appStateProvider);
      // ignore: avoid_print
      print('🔴 [ProductTransactions] storeId: ${appState.storeChoosen}, companyId: ${appState.companyChoosen}');
      setState(() {
        _selectedStoreId = appState.storeChoosen;
        _selectedStoreName = appState.storeName;
      });
      // ignore: avoid_print
      print('🔴 [ProductTransactions] About to call _loadTransactions');
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    // ignore: avoid_print
    print('🔴 [ProductTransactions] _loadTransactions called, refresh: $refresh');
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _isLoading = true;
      });
    }

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      // ignore: avoid_print
      print('🔴 [ProductTransactions] Loading history for product: ${widget.product.id}');
      // ignore: avoid_print
      print('🔴 [ProductTransactions] Store: $_selectedStoreId, Company: ${appState.companyChoosen}');

      final result = await repository.getProductHistory(
        companyId: appState.companyChoosen,
        storeId: _selectedStoreId.isNotEmpty ? _selectedStoreId : appState.storeChoosen,
        productId: widget.product.id,
        page: _currentPage,
        pageSize: _pageSize,
      );

      // ignore: avoid_print
      print('🔴 [ProductTransactions] Result: ${result?.entries.length ?? 0} entries, totalCount: ${result?.totalCount ?? 0}');

      if (mounted && result != null) {
        setState(() {
          if (refresh || _currentPage == 1) {
            _transactions = result.entries;
          } else {
            _transactions.addAll(result.entries);
          }
          _totalPages = result.totalPages;
          _totalCount = result.totalCount;
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e, stackTrace) {
      // ignore: avoid_print
      print('🔴 [ProductTransactions] ERROR: $e');
      // ignore: avoid_print
      print('🔴 [ProductTransactions] StackTrace: $stackTrace');
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
    final stores = _getCompanyStores(appState);

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
                      size: 16,
                      color: TossColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedDateRange!.toShortString(),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w500,
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
                        size: 18,
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
            // Transactions list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return _buildTransactionItem(filteredTransactions[index]);
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
            size: 64,
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

  Widget _buildTopBar(BuildContext context, List<_StoreOption> stores) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                size: 22,
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
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: TossColors.gray600,
                ),
              ],
            ),
          ),
          // Date filter button
          GestureDetector(
            onTap: () => _showDateRangePicker(context),
            child: Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
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
                        width: 8,
                        height: 8,
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

  Widget _buildTransactionItem(ProductHistoryEntry transaction) {
    final eventType = _parseEventType(transaction.eventType);
    final isTransfer = transaction.eventType == 'stock_transfer_out' ||
        transaction.eventType == 'stock_transfer_in';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon - aligned with title top
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              _getTransactionIcon(eventType),
              size: 20,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type title
                Text(
                  _getTransactionTitle(eventType),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                // Date and time
                Text(
                  _formatCreatedAt(transaction.createdAt),
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 4),
                // Location info
                if (isTransfer && transaction.fromStoreName != null && transaction.toStoreName != null)
                  Row(
                    children: [
                      Text(
                        transaction.fromStoreName ?? '',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: TossColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction.toStoreName ?? '',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  )
                else if (transaction.notes != null && transaction.notes!.isNotEmpty)
                  Text(
                    transaction.notes!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                const SizedBox(height: 8),
                // User info
                if (transaction.createdUser != null && transaction.createdUser!.isNotEmpty)
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: TossColors.gray200,
                          shape: BoxShape.circle,
                          image: transaction.createdUserProfileImage != null
                              ? DecorationImage(
                                  image: NetworkImage(transaction.createdUserProfileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: transaction.createdUserProfileImage == null
                            ? Center(
                                child: Text(
                                  transaction.createdUser!.isNotEmpty
                                      ? transaction.createdUser![0].toUpperCase()
                                      : 'U',
                                  style: TossTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: TossColors.gray600,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction.createdUser!,
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Quantity change - only show if quantity changed
          if (transaction.quantityBefore != null &&
              transaction.quantityAfter != null &&
              transaction.quantityBefore != transaction.quantityAfter)
            Builder(
              builder: (context) {
                final change = transaction.quantityAfter! - transaction.quantityBefore!;
                final isIncrease = change > 0;
                final changeColor = isIncrease ? TossColors.primary : TossColors.error;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Change amount (colored, prominent)
                    Text(
                      '${isIncrease ? '+' : ''}$change',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: changeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Before → After (gray, subtle)
                    Text(
                      '${transaction.quantityBefore} → ${transaction.quantityAfter}',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  _TransactionType _parseEventType(String eventType) {
    switch (eventType) {
      case 'stock_sale':
        return _TransactionType.sell;
      case 'stock_refund':
        return _TransactionType.stockIn;
      case 'stock_receipt':
        return _TransactionType.stockIn;
      case 'stock_transfer_out':
      case 'stock_transfer_in':
        return _TransactionType.moveStock;
      case 'stock_adjustment':
        return _TransactionType.editStock;
      default:
        return _TransactionType.editStock;
    }
  }

  void _showStorePicker(BuildContext context, List<_StoreOption> stores) {
    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
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
                          fontWeight: FontWeight.w500,
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

  List<_StoreOption> _getCompanyStores(AppState appState) {
    final currentCompanyId = appState.companyChoosen;
    final companies = appState.user['companies'] as List<dynamic>? ?? [];

    Map<String, dynamic>? company;
    for (final c in companies) {
      if (c is Map<String, dynamic> && c['company_id'] == currentCompanyId) {
        company = c;
        break;
      }
    }

    if (company == null) {
      return [
        _StoreOption(
          id: appState.storeChoosen,
          name: appState.storeName.isNotEmpty ? appState.storeName : 'Main Store',
        ),
      ];
    }

    final storesList = company['stores'] as List<dynamic>? ?? [];

    return storesList.map((store) {
      final storeMap = store as Map<String, dynamic>;
      return _StoreOption(
        id: storeMap['store_id'] as String? ?? '',
        name: storeMap['store_name'] as String? ?? 'Unknown Store',
      );
    }).toList();
  }

  IconData _getTransactionIcon(_TransactionType type) {
    switch (type) {
      case _TransactionType.moveStock:
        return Icons.swap_horiz;
      case _TransactionType.stockIn:
        return Icons.download_outlined;
      case _TransactionType.editStock:
        return Icons.edit_outlined;
      case _TransactionType.sell:
        return Icons.shopping_bag_outlined;
    }
  }

  String _getTransactionTitle(_TransactionType type) {
    switch (type) {
      case _TransactionType.moveStock:
        return 'Move Stock';
      case _TransactionType.stockIn:
        return 'Stock In';
      case _TransactionType.editStock:
        return 'Edit Stock';
      case _TransactionType.sell:
        return 'Sell';
    }
  }

  /// Format created_at string from RPC (format: 'YYYY-MM-DD HH24:MI:SS')
  /// to user-friendly format (e.g., 'Oct 12, 2025 · 14:32')
  String _formatCreatedAt(String createdAt) {
    try {
      // Parse the datetime string from RPC
      final parts = createdAt.split(' ');
      if (parts.length != 2) return createdAt;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length < 2) return createdAt;

      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      final hour = timeParts[0];
      final minute = timeParts[1];

      // Month names
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      final monthName = months[month - 1];
      return '$monthName $day, $year · $hour:$minute';
    } catch (e) {
      return createdAt;
    }
  }
}

enum _TransactionType {
  moveStock,
  stockIn,
  editStock,
  sell,
}

class _StoreOption {
  final String id;
  final String name;

  _StoreOption({
    required this.id,
    required this.name,
  });
}
