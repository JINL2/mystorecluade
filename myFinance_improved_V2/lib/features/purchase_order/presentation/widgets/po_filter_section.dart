import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/index.dart';
import '../../domain/entities/purchase_order.dart';
import '../providers/po_providers.dart';

/// Date range preset options
enum DateRangePreset {
  thisMonth,
  lastMonth,
  thisYear,
  custom;

  String get label {
    switch (this) {
      case DateRangePreset.thisMonth:
        return 'This Month';
      case DateRangePreset.lastMonth:
        return 'Last Month';
      case DateRangePreset.thisYear:
        return 'This Year';
      case DateRangePreset.custom:
        return 'Custom';
    }
  }
}

/// Filter state for PO list
class POFilterState {
  final DateRangePreset datePreset;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<OrderStatus> orderStatuses;
  final List<ReceivingStatus> receivingStatuses;
  final String? supplierId;
  final String? supplierName;

  const POFilterState({
    this.datePreset = DateRangePreset.thisMonth,
    this.dateFrom,
    this.dateTo,
    this.orderStatuses = const [],
    this.receivingStatuses = const [],
    this.supplierId,
    this.supplierName,
  });

  POFilterState copyWith({
    DateRangePreset? datePreset,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<OrderStatus>? orderStatuses,
    List<ReceivingStatus>? receivingStatuses,
    String? supplierId,
    String? supplierName,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearSupplier = false,
  }) {
    return POFilterState(
      datePreset: datePreset ?? this.datePreset,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      orderStatuses: orderStatuses ?? this.orderStatuses,
      receivingStatuses: receivingStatuses ?? this.receivingStatuses,
      supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
      supplierName: clearSupplier ? null : (supplierName ?? this.supplierName),
    );
  }

  /// Get date range based on preset
  (DateTime, DateTime) getDateRange() {
    final now = DateTime.now();
    switch (datePreset) {
      case DateRangePreset.thisMonth:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        return (start, end);
      case DateRangePreset.lastMonth:
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month, 0, 23, 59, 59);
        return (start, end);
      case DateRangePreset.thisYear:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year, 12, 31, 23, 59, 59);
        return (start, end);
      case DateRangePreset.custom:
        return (
          dateFrom ?? DateTime(now.year, now.month, 1),
          dateTo ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        );
    }
  }
}

/// Main filter section widget
class POFilterSection extends StatelessWidget {
  final POFilterState filterState;
  final ValueChanged<POFilterState> onFilterChanged;

  const POFilterSection({
    super.key,
    required this.filterState,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: SizedBox(
        height: TossSpacing.space14,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            // Period Filter
            TossChip(
              label: 'Period: ${_getPeriodSubtitle()}',
              isSelected: false,
              trailing: const Icon(
                LucideIcons.chevronDown,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
              onTap: () => _showPeriodSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Order Status Filter
            TossChip(
              label: 'Order: ${_getOrderStatusSubtitle()}',
              isSelected: false,
              trailing: const Icon(
                LucideIcons.chevronDown,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
              onTap: () => _showOrderStatusSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Receiving Status Filter
            TossChip(
              label: 'Receiving: ${_getReceivingStatusSubtitle()}',
              isSelected: false,
              trailing: const Icon(
                LucideIcons.chevronDown,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
              onTap: () => _showReceivingStatusSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Supplier Filter
            TossChip(
              label: 'Supplier: ${_getSupplierSubtitle()}',
              isSelected: false,
              trailing: const Icon(
                LucideIcons.chevronDown,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
              onTap: () => _showSupplierSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getPeriodSubtitle() {
    if (filterState.datePreset == DateRangePreset.custom &&
        filterState.dateFrom != null &&
        filterState.dateTo != null) {
      final fromStr =
          '${filterState.dateFrom!.month}/${filterState.dateFrom!.day}';
      final toStr = '${filterState.dateTo!.month}/${filterState.dateTo!.day}';
      return '$fromStr - $toStr';
    }
    return filterState.datePreset.label;
  }

  String _getOrderStatusSubtitle() {
    if (filterState.orderStatuses.isEmpty) {
      return 'All';
    }
    if (filterState.orderStatuses.length == 1) {
      return _orderStatusLabel(filterState.orderStatuses.first);
    }
    return '${filterState.orderStatuses.length} selected';
  }

  String _getReceivingStatusSubtitle() {
    if (filterState.receivingStatuses.isEmpty) {
      return 'All';
    }
    if (filterState.receivingStatuses.length == 1) {
      return _receivingStatusLabel(filterState.receivingStatuses.first);
    }
    return '${filterState.receivingStatuses.length} selected';
  }

  String _getSupplierSubtitle() {
    if (filterState.supplierId == null) {
      return 'All';
    }
    return filterState.supplierName ?? 'Selected';
  }

  String _orderStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.process:
        return 'Process';
      case OrderStatus.complete:
        return 'Complete';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _receivingStatusLabel(ReceivingStatus status) {
    switch (status) {
      case ReceivingStatus.pending:
        return 'Pending';
      case ReceivingStatus.process:
        return 'Process';
      case ReceivingStatus.complete:
        return 'Complete';
    }
  }

  // ==================== Bottom Sheets ====================

  void _showPeriodSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Select Period',
      children: [
        SelectionListItem(
          item: const SelectionItem(id: 'this_month', title: 'This Month'),
          isSelected: filterState.datePreset == DateRangePreset.thisMonth,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.thisMonth),
            );
          },
        ),
        SelectionListItem(
          item: const SelectionItem(id: 'last_month', title: 'Last Month'),
          isSelected: filterState.datePreset == DateRangePreset.lastMonth,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.lastMonth),
            );
          },
        ),
        SelectionListItem(
          item: const SelectionItem(id: 'this_year', title: 'This Year'),
          isSelected: filterState.datePreset == DateRangePreset.thisYear,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.thisYear),
            );
          },
        ),
        SelectionListItem(
          item: const SelectionItem(
            id: 'custom',
            title: 'Custom Date Range',
            icon: LucideIcons.calendar,
          ),
          isSelected: filterState.datePreset == DateRangePreset.custom,
          variant: SelectionItemVariant.standard,
          onTap: () async {
            Navigator.pop(context);
            await _showDateRangePicker(context);
          },
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDateRange = DateTimeRange(
      start: filterState.dateFrom ?? DateTime(now.year, now.month, 1),
      end: filterState.dateTo ?? now,
    );

    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: initialDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TossColors.primary,
              onPrimary: TossColors.white,
              surface: TossColors.white,
              onSurface: TossColors.gray900,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      onFilterChanged(
        filterState.copyWith(
          datePreset: DateRangePreset.custom,
          dateFrom: pickedRange.start,
          dateTo: pickedRange.end,
        ),
      );
    }
  }

  void _showOrderStatusSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Order Status',
      children: [
        SelectionListItem(
          item: const SelectionItem(id: 'all', title: 'All'),
          isSelected: filterState.orderStatuses.isEmpty,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(orderStatuses: []));
          },
        ),
        ...OrderStatus.values.map((status) {
          return SelectionListItem(
            item: SelectionItem(id: status.name, title: _orderStatusLabel(status)),
            isSelected: filterState.orderStatuses.contains(status),
            variant: SelectionItemVariant.minimal,
            onTap: () {
              _toggleOrderStatus(status);
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }

  void _toggleOrderStatus(OrderStatus status) {
    final current = filterState.orderStatuses.toList();
    if (current.contains(status)) {
      current.remove(status);
    } else {
      current.add(status);
    }
    onFilterChanged(filterState.copyWith(orderStatuses: current));
  }

  void _showReceivingStatusSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Receiving Status',
      children: [
        SelectionListItem(
          item: const SelectionItem(id: 'all', title: 'All'),
          isSelected: filterState.receivingStatuses.isEmpty,
          variant: SelectionItemVariant.minimal,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(receivingStatuses: []));
          },
        ),
        ...ReceivingStatus.values.map((status) {
          return SelectionListItem(
            item: SelectionItem(id: status.name, title: _receivingStatusLabel(status)),
            isSelected: filterState.receivingStatuses.contains(status),
            variant: SelectionItemVariant.minimal,
            onTap: () {
              _toggleReceivingStatus(status);
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }

  void _toggleReceivingStatus(ReceivingStatus status) {
    final current = filterState.receivingStatuses.toList();
    if (current.contains(status)) {
      current.remove(status);
    } else {
      current.add(status);
    }
    onFilterChanged(filterState.copyWith(receivingStatuses: current));
  }

  void _showSupplierSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _SupplierSelectorSheet(
          scrollController: scrollController,
          selectedSupplierId: filterState.supplierId,
          onSupplierSelected: (id, name) {
            Navigator.pop(sheetContext);
            onFilterChanged(
              filterState.copyWith(
                supplierId: id,
                supplierName: name,
              ),
            );
          },
          onClear: () {
            Navigator.pop(sheetContext);
            onFilterChanged(filterState.copyWith(clearSupplier: true));
          },
        ),
      ),
    );
  }
}

/// Supplier selector bottom sheet
class _SupplierSelectorSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final String? selectedSupplierId;
  final void Function(String id, String name) onSupplierSelected;
  final VoidCallback onClear;

  const _SupplierSelectorSheet({
    required this.scrollController,
    this.selectedSupplierId,
    required this.onSupplierSelected,
    required this.onClear,
  });

  @override
  ConsumerState<_SupplierSelectorSheet> createState() =>
      _SupplierSelectorSheetState();
}

class _SupplierSelectorSheetState
    extends ConsumerState<_SupplierSelectorSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final suppliersAsync = ref.watch(supplierListProvider);

    return Column(
      children: [
        // Handle bar
        const Padding(
          padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Center(
            child: DragHandle(),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Supplier',
                style: TossTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
              ),
              if (widget.selectedSupplierId != null)
                TextButton(
                  onPressed: widget.onClear,
                  child: Text(
                    'Clear',
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space3),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
          child: TossTextField.filled(
            hintText: 'Search supplier...',
            prefixIcon: const Icon(LucideIcons.search, size: TossSpacing.iconMD),
            onChanged: (value) {
              setState(() => _searchQuery = value.toLowerCase());
            },
          ),
        ),

        const SizedBox(height: TossSpacing.space3),
        const Divider(height: 1),

        // Content
        Expanded(
          child: suppliersAsync.when(
            loading: () => const TossLoadingView(),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.alertCircle,
                    size: TossSpacing.iconXXL,
                    color: TossColors.gray400,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  Text(
                    'Failed to load suppliers',
                    style: TossTextStyles.bodyLarge
                        .copyWith(color: TossColors.gray600),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  TossButton.textButton(
                    text: 'Retry',
                    onPressed: () => ref.invalidate(supplierListProvider),
                  ),
                ],
              ),
            ),
            data: (suppliers) {
              // Filter by search query
              final filteredSuppliers = _searchQuery.isEmpty
                  ? suppliers
                  : suppliers.where((s) {
                      return s.name.toLowerCase().contains(_searchQuery) ||
                          (s.email?.toLowerCase().contains(_searchQuery) ??
                              false) ||
                          (s.phone?.contains(_searchQuery) ?? false);
                    }).toList();

              if (filteredSuppliers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.building2,
                        size: TossSpacing.icon4XL,
                        color: TossColors.gray400,
                      ),
                      const SizedBox(height: TossSpacing.space4),
                      Text(
                        _searchQuery.isEmpty ? 'No Suppliers' : 'No Results',
                        style:
                            TossTextStyles.h3.copyWith(color: TossColors.gray600),
                      ),
                      const SizedBox(height: TossSpacing.space2),
                      Text(
                        _searchQuery.isEmpty
                            ? 'Add suppliers in Counterparty menu'
                            : 'Try a different search term',
                        textAlign: TextAlign.center,
                        style: TossTextStyles.bodyMedium
                            .copyWith(color: TossColors.gray500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                controller: widget.scrollController,
                padding: const EdgeInsets.all(TossSpacing.space4),
                itemCount: filteredSuppliers.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: TossSpacing.space2),
                itemBuilder: (context, index) {
                  final supplier = filteredSuppliers[index];
                  final isSelected =
                      supplier.counterpartyId == widget.selectedSupplierId;

                  return SelectionListItem(
                    item: SelectionItem(
                      id: supplier.counterpartyId,
                      title: supplier.name,
                      subtitle: supplier.email ?? supplier.phone,
                      icon: LucideIcons.building2,
                    ),
                    isSelected: isSelected,
                    variant: SelectionItemVariant.standard,
                    onTap: () => widget.onSupplierSelected(
                      supplier.counterpartyId,
                      supplier.name,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
