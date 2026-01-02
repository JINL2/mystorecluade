import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../di/inventory_providers.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../utils/store_utils.dart';
import '../widgets/inventory_history/history_item.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
    final stores = StoreUtils.getCompanyStores(appState);

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
                  ? const TossLoadingView()
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
                                  padding: EdgeInsets.all(TossSpacing.space4),
                                  child: TossLoadingView(),
                                );
                              }
                              return HistoryItem(entry: filteredEntries[index]);
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

  Widget _buildTopBar(BuildContext context, List<StoreOption> stores) {
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

  void _showStorePicker(BuildContext context, List<StoreOption> stores) {
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
}
