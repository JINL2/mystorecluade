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
import '../../domain/repositories/inventory_repository.dart';

/// Inventory History Page - Shows history of all stock movements in the store
class InventoryHistoryPage extends ConsumerStatefulWidget {
  const InventoryHistoryPage({super.key});

  @override
  ConsumerState<InventoryHistoryPage> createState() =>
      _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends ConsumerState<InventoryHistoryPage> {
  String _selectedStoreId = '';
  String _selectedStoreName = '';
  DateRange? _selectedDateRange;

  // History data state
  List<InventoryHistoryEntry> _historyEntries = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
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
      _loadHistory();
    });
  }

  Future<void> _loadHistory({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _currentPage = 1;
        _isLoading = true;
      });
    }

    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.getInventoryHistory(
        companyId: appState.companyChoosen,
        storeId: _selectedStoreId.isNotEmpty ? _selectedStoreId : appState.storeChoosen,
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (mounted && result != null) {
        setState(() {
          if (refresh || _currentPage == 1) {
            _historyEntries = result.entries;
          } else {
            _historyEntries.addAll(result.entries);
          }
          _totalPages = result.totalPages;
          _totalCount = result.totalCount;
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
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

    await _loadHistory();
  }

  /// Filter entries by date range (client-side filtering)
  List<InventoryHistoryEntry> _getFilteredEntries() {
    if (_selectedDateRange == null) {
      return _historyEntries;
    }

    return _historyEntries.where((entry) {
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
    final filteredEntries = _getFilteredEntries();

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with store selector
            _buildTopBar(context, stores),
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
            // History list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEntries.isEmpty
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
                            itemCount: filteredEntries.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredEntries.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
                              return _buildHistoryItem(filteredEntries[index]);
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
            'No history yet',
            style: TossTextStyles.h4.copyWith(
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Inventory history will appear here',
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

  Widget _buildHistoryItem(InventoryHistoryEntry entry) {
    final eventType = _parseEventType(entry.eventType);
    final isTransfer = entry.eventType == 'stock_transfer_out' ||
        entry.eventType == 'stock_transfer_in';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(8),
              image: entry.productImage != null
                  ? DecorationImage(
                      image: NetworkImage(entry.productImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: entry.productImage == null
                ? Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 24,
                      color: TossColors.gray400,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  entry.productName ?? 'Unknown Product',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // SKU
                if (entry.productSku != null && entry.productSku!.isNotEmpty)
                  Text(
                    entry.productSku!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                const SizedBox(height: 4),
                // Event type with icon
                Row(
                  children: [
                    Icon(
                      _getTransactionIcon(eventType),
                      size: 14,
                      color: TossColors.gray600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTransactionTitle(eventType),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Date and time
                Text(
                  _formatCreatedAt(entry.createdAt),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                // Location info for transfers
                if (isTransfer && entry.fromStoreName != null && entry.toStoreName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Text(
                          entry.fromStoreName ?? '',
                          style: TossTextStyles.caption.copyWith(
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
                          entry.toStoreName ?? '',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ),
                // User info
                if (entry.createdUser != null && entry.createdUser!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: TossColors.gray200,
                            shape: BoxShape.circle,
                            image: entry.createdUserProfileImage != null
                                ? DecorationImage(
                                    image: NetworkImage(entry.createdUserProfileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: entry.createdUserProfileImage == null
                              ? Center(
                                  child: Text(
                                    entry.createdUser!.isNotEmpty
                                        ? entry.createdUser![0].toUpperCase()
                                        : 'U',
                                    style: TossTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: TossColors.gray600,
                                      fontSize: 10,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          entry.createdUser!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Quantity change - only show if quantity changed
          if (entry.quantityBefore != null &&
              entry.quantityAfter != null &&
              entry.quantityBefore != entry.quantityAfter)
            Builder(
              builder: (context) {
                final isIncrease = entry.quantityAfter! > entry.quantityBefore!;
                final changeColor = isIncrease ? TossColors.primary : TossColors.error;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Before quantity (gray, on top)
                    Text(
                      '${entry.quantityBefore}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // After quantity with arrow (colored, below)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: changeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${entry.quantityAfter}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                            color: changeColor,
                          ),
                        ),
                      ],
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
                        // Reload history with new store
                        _loadHistory(refresh: true);
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
        // Client-side filtering is applied in _getFilteredEntries()
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
      return '$monthName $day · $hour:$minute';
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
