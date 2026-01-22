import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/index.dart';
import '../../domain/entities/shipment.dart';
import '../providers/shipment_providers.dart' hide DateTimeRange;

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

/// Filter state for Shipment list
class ShipmentFilterState {
  final DateRangePreset datePreset;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final List<ShipmentStatus> statuses;
  final String? supplierId;
  final String? supplierName;
  final bool? hasOrder;

  const ShipmentFilterState({
    this.datePreset = DateRangePreset.thisMonth,
    this.dateFrom,
    this.dateTo,
    this.statuses = const [],
    this.supplierId,
    this.supplierName,
    this.hasOrder,
  });

  ShipmentFilterState copyWith({
    DateRangePreset? datePreset,
    DateTime? dateFrom,
    DateTime? dateTo,
    List<ShipmentStatus>? statuses,
    String? supplierId,
    String? supplierName,
    bool? hasOrder,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearSupplier = false,
    bool clearHasOrder = false,
  }) {
    return ShipmentFilterState(
      datePreset: datePreset ?? this.datePreset,
      dateFrom: clearDateFrom ? null : (dateFrom ?? this.dateFrom),
      dateTo: clearDateTo ? null : (dateTo ?? this.dateTo),
      statuses: statuses ?? this.statuses,
      supplierId: clearSupplier ? null : (supplierId ?? this.supplierId),
      supplierName: clearSupplier ? null : (supplierName ?? this.supplierName),
      hasOrder: clearHasOrder ? null : (hasOrder ?? this.hasOrder),
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
class ShipmentFilterSection extends StatelessWidget {
  final ShipmentFilterState filterState;
  final ValueChanged<ShipmentFilterState> onFilterChanged;

  const ShipmentFilterSection({
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
            _ShipmentFilterPill(
              title: 'Period',
              subtitle: _getPeriodSubtitle(),
              onTap: () => _showPeriodSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Status Filter
            _ShipmentFilterPill(
              title: 'Status',
              subtitle: _getStatusSubtitle(),
              onTap: () => _showStatusSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Supplier Filter
            _ShipmentFilterPill(
              title: 'Supplier',
              subtitle: _getSupplierSubtitle(),
              onTap: () => _showSupplierSheet(context),
            ),
            const SizedBox(width: TossSpacing.space2),
            // Order Linkage Filter
            _ShipmentFilterPill(
              title: 'Orders',
              subtitle: _getOrderLinkageSubtitle(),
              onTap: () => _showOrderLinkageSheet(context),
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

  String _getStatusSubtitle() {
    if (filterState.statuses.isEmpty) {
      return 'All';
    }
    if (filterState.statuses.length == 1) {
      return filterState.statuses.first.label;
    }
    return '${filterState.statuses.length} selected';
  }

  String _getOrderLinkageSubtitle() {
    if (filterState.hasOrder == null) {
      return 'All';
    }
    return filterState.hasOrder! ? 'Linked' : 'Unlinked';
  }

  String _getSupplierSubtitle() {
    if (filterState.supplierId == null) {
      return 'All';
    }
    return filterState.supplierName ?? 'Selected';
  }

  // ==================== Bottom Sheets ====================

  void _showPeriodSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Select Period',
      children: [
        _SelectionTile(
          label: 'This Month',
          isSelected: filterState.datePreset == DateRangePreset.thisMonth,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.thisMonth),
            );
          },
        ),
        _SelectionTile(
          label: 'Last Month',
          isSelected: filterState.datePreset == DateRangePreset.lastMonth,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.lastMonth),
            );
          },
        ),
        _SelectionTile(
          label: 'This Year',
          isSelected: filterState.datePreset == DateRangePreset.thisYear,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(
              filterState.copyWith(datePreset: DateRangePreset.thisYear),
            );
          },
        ),
        _SelectionTile(
          label: 'Custom Date Range',
          isSelected: filterState.datePreset == DateRangePreset.custom,
          icon: Icons.calendar_today,
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

  void _showStatusSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Shipment Status',
      children: [
        _SelectionTile(
          label: 'All',
          isSelected: filterState.statuses.isEmpty,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(statuses: []));
          },
        ),
        ...ShipmentStatus.values.map((status) {
          return _SelectionTile(
            label: status.label,
            isSelected: filterState.statuses.contains(status),
            onTap: () {
              _toggleStatus(status);
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }

  void _toggleStatus(ShipmentStatus status) {
    final current = filterState.statuses.toList();
    if (current.contains(status)) {
      current.remove(status);
    } else {
      current.add(status);
    }
    onFilterChanged(filterState.copyWith(statuses: current));
  }

  void _showOrderLinkageSheet(BuildContext context) {
    SelectionBottomSheetCommon.show<void>(
      context: context,
      title: 'Order Linkage',
      children: [
        _SelectionTile(
          label: 'All',
          isSelected: filterState.hasOrder == null,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(clearHasOrder: true));
          },
        ),
        _SelectionTile(
          label: 'Linked to Orders',
          isSelected: filterState.hasOrder == true,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(hasOrder: true));
          },
        ),
        _SelectionTile(
          label: 'Not Linked',
          isSelected: filterState.hasOrder == false,
          onTap: () {
            Navigator.pop(context);
            onFilterChanged(filterState.copyWith(hasOrder: false));
          },
        ),
      ],
    );
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

/// Filter pill widget
class _ShipmentFilterPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShipmentFilterPill({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space3,
            vertical: TossSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: TossFontWeight.semibold,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space0_5),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: TossFontWeight.regular,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: TossSpacing.space4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: TossSpacing.iconSM2,
                color: TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Selection tile for bottom sheets
class _SelectionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const _SelectionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      leading: icon != null
          ? Icon(
              icon,
              color: isSelected ? TossColors.primary : TossColors.gray600,
              size: TossSpacing.iconMD,
            )
          : null,
      title: Text(
        label,
        style: TossTextStyles.body.copyWith(
          fontWeight:
              isSelected ? TossFontWeight.semibold : TossFontWeight.regular,
          color: isSelected ? TossColors.primary : TossColors.gray900,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check,
              color: TossColors.primary,
              size: TossSpacing.iconMD,
            )
          : null,
      onTap: onTap,
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
    final suppliersAsync = ref.watch(shipmentCounterpartiesProvider);

    return Column(
      children: [
        // Handle bar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          child: Center(
            child: Container(
              width: TossSpacing.iconXL,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2),
              ),
            ),
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
            prefixIcon: const Icon(Icons.search, size: TossSpacing.iconMD),
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
                    Icons.error_outline,
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
                    onPressed: () =>
                        ref.invalidate(shipmentCounterpartiesProvider),
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
                        Icons.business_outlined,
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

                  return _SupplierListItem(
                    supplier: supplier,
                    isSelected: isSelected,
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

/// Supplier list item
class _SupplierListItem extends StatelessWidget {
  final CounterpartyFilterItem supplier;
  final bool isSelected;
  final VoidCallback onTap;

  const _SupplierListItem({
    required this.supplier,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? TossColors.primary.withValues(alpha: 0.1)
          : TossColors.white,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? TossColors.primary : TossColors.gray200,
            ),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: TossSpacing.iconXL,
                height: TossSpacing.iconXL,
                decoration: BoxDecoration(
                  color: isSelected
                      ? TossColors.primary.withValues(alpha: 0.2)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Icon(
                  Icons.business_outlined,
                  color: isSelected ? TossColors.primary : TossColors.gray500,
                  size: TossSpacing.iconMD,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: TossTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? TossColors.primary : TossColors.gray900,
                      ),
                    ),
                    if (supplier.email != null || supplier.phone != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        supplier.email ?? supplier.phone ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Check mark
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: TossColors.primary,
                  size: TossSpacing.iconMD,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
