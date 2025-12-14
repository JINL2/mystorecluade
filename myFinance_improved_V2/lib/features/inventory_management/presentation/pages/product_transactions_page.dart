import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/toss/calendar_time_range.dart';
import '../../domain/entities/product.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);

    // Get stores list
    final stores = _getCompanyStores(appState);

    // Mock transactions data - TODO: Replace with actual API data
    final transactions = _getMockTransactions();

    return TossScaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with store selector
            _buildTopBar(context, stores),
            // Product info
            _buildProductInfo(),
            // Transactions list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                ),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionItem(transactions[index]);
                },
              ),
            ),
          ],
        ),
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

  Widget _buildTransactionItem(_Transaction transaction) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon - aligned with title top
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              _getTransactionIcon(transaction.type),
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
                  _getTransactionTitle(transaction.type),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                // Date and time
                Text(
                  transaction.dateTime,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 4),
                // Location info
                if (transaction.type == _TransactionType.moveStock)
                  Row(
                    children: [
                      Text(
                        transaction.fromStore ?? '',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: TossColors.gray500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction.toStore ?? '',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    transaction.store,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                const SizedBox(height: 8),
                // User info
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: TossColors.gray200,
                        shape: BoxShape.circle,
                        image: transaction.userAvatar != null
                            ? DecorationImage(
                                image: NetworkImage(transaction.userAvatar!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: transaction.userAvatar == null
                          ? Center(
                              child: Text(
                                transaction.userName.isNotEmpty
                                    ? transaction.userName[0].toUpperCase()
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
                      transaction.userName,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Quantity change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Qty',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${transaction.qtyBefore}',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: TossColors.gray500,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${transaction.qtyAfter}',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
        // TODO: Filter transactions by date range when API is implemented
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

  // Mock data - TODO: Replace with actual API call
  List<_Transaction> _getMockTransactions() {
    return [
      _Transaction(
        type: _TransactionType.moveStock,
        dateTime: 'Oct 12, 2025 · 14:32',
        store: 'Lux 1',
        fromStore: 'Lux 1',
        toStore: 'Lux 2',
        userName: 'Alex Nguyen',
        userAvatar: null,
        qtyBefore: 12,
        qtyAfter: 8,
      ),
      _Transaction(
        type: _TransactionType.stockIn,
        dateTime: 'Oct 10, 2025 · 09:05',
        store: 'Lux 1',
        userName: 'Jamie Lee',
        userAvatar: null,
        qtyBefore: 3,
        qtyAfter: 15,
      ),
      _Transaction(
        type: _TransactionType.editStock,
        dateTime: 'Oct 8, 2025 · 18:47',
        store: 'Lux 1',
        userName: 'Morgan Park',
        userAvatar: null,
        qtyBefore: 10,
        qtyAfter: 9,
      ),
      _Transaction(
        type: _TransactionType.moveStock,
        dateTime: 'Oct 5, 2025 · 11:20',
        store: 'Lux 1',
        fromStore: 'Lux 1',
        toStore: 'Warehouse',
        userName: 'Taylor Kim',
        userAvatar: null,
        qtyBefore: 20,
        qtyAfter: 5,
      ),
      _Transaction(
        type: _TransactionType.sell,
        dateTime: 'Oct 3, 2025 · 16:10',
        store: 'Lux 1',
        userName: 'Jordan Blake',
        userAvatar: null,
        qtyBefore: 15,
        qtyAfter: 12,
      ),
    ];
  }
}

enum _TransactionType {
  moveStock,
  stockIn,
  editStock,
  sell,
}

class _Transaction {
  final _TransactionType type;
  final String dateTime;
  final String store;
  final String? fromStore;
  final String? toStore;
  final String userName;
  final String? userAvatar;
  final int qtyBefore;
  final int qtyAfter;

  _Transaction({
    required this.type,
    required this.dateTime,
    required this.store,
    this.fromStore,
    this.toStore,
    required this.userName,
    this.userAvatar,
    required this.qtyBefore,
    required this.qtyAfter,
  });
}

class _StoreOption {
  final String id;
  final String name;

  _StoreOption({
    required this.id,
    required this.name,
  });
}
