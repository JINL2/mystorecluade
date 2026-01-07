/// Cash Location Selector
///
/// Autonomous cash location selector widget with scope awareness.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Basic Usage
/// ```dart
/// CashLocationSelector(
///   selectedLocationId: _locationId,
///   onCashLocationSelected: (location) {
///     setState(() => _locationId = location.id);
///   },
/// )
/// ```
///
/// ## With Company/Store Tabs
/// ```dart
/// CashLocationSelector(
///   showScopeTabs: true,
///   selectedLocationId: _locationId,
///   onCashLocationSelected: (location) => handleSelection(location),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/app/providers/cash_location_provider.dart';
import 'package:myfinance_improved/core/data/models/transaction_history_model.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import 'cash_location_selector_sheet.dart';

/// Callback type for cash location selection
typedef OnCashLocationSelectedCallback = void Function(CashLocationData location);

/// Cash location selector with scope awareness
class CashLocationSelector extends ConsumerStatefulWidget {
  final String? companyId;
  final String? storeId;
  final String? selectedLocationId;

  // Legacy callbacks
  final SingleSelectionCallback? onChanged;
  final SingleSelectionWithNameCallback? onChangedWithName;

  // Type-safe callback
  final OnCashLocationSelectedCallback? onCashLocationSelected;

  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final bool showScopeTabs;
  final TransactionScope? initialScope;
  final String? locationType;
  final Set<String>? blockedLocationIds;
  final bool hideLabel;
  final bool storeOnly;

  const CashLocationSelector({
    super.key,
    this.companyId,
    this.storeId,
    this.selectedLocationId,
    this.onChanged,
    this.onChangedWithName,
    this.onCashLocationSelected,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.showScopeTabs = true,
    this.initialScope,
    this.locationType,
    this.blockedLocationIds,
    this.hideLabel = false,
    this.storeOnly = false,
  });

  @override
  ConsumerState<CashLocationSelector> createState() => _CashLocationSelectorState();
}

class _CashLocationSelectorState extends ConsumerState<CashLocationSelector> {
  int _selectedTabIndex = 1; // Default to Store tab

  @override
  void initState() {
    super.initState();
    _forceRefreshData();
  }

  void _forceRefreshData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = ref.read(appStateProvider);
      final effectiveCompanyId = widget.companyId ?? appState.companyChoosen;

      if (effectiveCompanyId.isNotEmpty) {
        ref.invalidate(cashLocationListProvider(effectiveCompanyId, null, widget.locationType));

        try {
          final notifier = ref.read(
            cashLocationListProvider(effectiveCompanyId, null, widget.locationType).notifier,
          );
          notifier.forceRefresh();
        } catch (e) {
          // Relying on invalidation
        }
      }

      if (widget.companyId == null) {
        ref.invalidate(companyCashLocationsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.read(appStateProvider);
    final effectiveCompanyId = widget.companyId ?? appState.companyChoosen;
    final effectiveStoreId = widget.storeId ?? appState.storeChoosen;

    final allLocationsAsync = widget.companyId != null
        ? ref.watch(cashLocationListProvider(effectiveCompanyId, null, widget.locationType))
        : ref.watch(companyCashLocationsProvider);

    CashLocationData? selectedLocation;
    if (widget.selectedLocationId != null) {
      allLocationsAsync.whenData((locations) {
        try {
          selectedLocation = locations.firstWhere(
            (location) => location.id == widget.selectedLocationId,
          );
        } catch (e) {
          selectedLocation = null;
        }
      });
    }

    final isLoading = allLocationsAsync.isLoading;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.hideLabel) ...[
          Text(
            widget.label ?? 'Cash Location',
            style: TossTextStyles.caption.copyWith(
              color: hasError ? TossColors.error : TossColors.gray600,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: TossSpacing.space2),
        ],
        GestureDetector(
          onTap: isLoading || widget.onChanged == null
              ? null
              : () => _showSelectionSheet(
                    allLocationsAsync,
                    effectiveCompanyId,
                    effectiveStoreId,
                  ),
          behavior: HitTestBehavior.opaque,
          child: _buildSelectorField(isLoading, selectedLocation),
        ),
        if (hasError) ...[
          const SizedBox(height: TossSpacing.space2),
          Text(
            widget.errorText!,
            style: TossTextStyles.caption.copyWith(color: TossColors.error),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _buildSelectorField(bool isLoading, CashLocationData? selectedLocation) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        color: TossColors.white,
        border: Border.all(
          color: hasError ? TossColors.error : TossColors.gray200,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(TossSpacing.space3),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: TossSpacing.iconSM,
            color: widget.selectedLocationId != null ? TossColors.primary : TossColors.gray400,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: isLoading
                ? const SizedBox(
                    height: TossSpacing.iconSM,
                    width: TossSpacing.iconSM,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: TossColors.primary,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedLocation?.displayName ?? widget.hint ?? 'Select Location',
                        style: TossTextStyles.body.copyWith(
                          color: widget.selectedLocationId != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                          fontWeight:
                              widget.selectedLocationId != null ? FontWeight.w600 : FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      if (selectedLocation != null && widget.showTransactionCount) ...[
                        SizedBox(height: TossSpacing.space1 / 2),
                        Text(
                          selectedLocation.subtitle,
                          style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: widget.selectedLocationId != null ? TossColors.primary : TossColors.gray400,
          ),
        ],
      ),
    );
  }

  void _showSelectionSheet(
    AsyncValue<List<CashLocationData>> allLocationsAsync,
    String? effectiveCompanyId,
    String? effectiveStoreId,
  ) {
    // Force refresh before showing
    if (widget.companyId != null && effectiveCompanyId != null) {
      ref.invalidate(cashLocationListProvider(effectiveCompanyId, null, widget.locationType));
    } else {
      ref.invalidate(companyCashLocationsProvider);
    }

    final locations = allLocationsAsync.maybeWhen(
      data: (locs) => locs,
      orElse: () => <CashLocationData>[],
    );

    // Prepare company and store locations
    final companyLocations = locations;
    final storeLocations = effectiveStoreId != null && effectiveStoreId.isNotEmpty
        ? locations.where((l) => l.isCompanyWide || l.storeId == effectiveStoreId).toList()
        : locations.where((l) => l.isCompanyWide).toList();

    if (!widget.showScopeTabs) {
      // Simple mode
      final filteredLocations = widget.storeOnly && effectiveStoreId != null
          ? storeLocations
          : locations;

      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: TossColors.transparent,
        builder: (context) => CashLocationSimpleSheet(
          locations: filteredLocations,
          selectedLocationId: widget.selectedLocationId,
          blockedLocationIds: widget.blockedLocationIds,
          onLocationSelected: _handleLocationSelected,
          onClear: _handleClear,
          label: widget.label,
          showTransactionCount: widget.showTransactionCount,
        ),
      );
    } else {
      // Scoped mode with tabs
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: TossColors.transparent,
        builder: (context) => CashLocationScopedSheet(
          companyLocations: companyLocations,
          storeLocations: storeLocations,
          selectedLocationId: widget.selectedLocationId,
          blockedLocationIds: widget.blockedLocationIds,
          onLocationSelected: _handleLocationSelected,
          onClear: _handleClear,
          label: widget.label,
          showSearch: widget.showSearch,
          showTransactionCount: widget.showTransactionCount,
          initialTabIndex: _selectedTabIndex,
        ),
      );
    }
  }

  void _handleLocationSelected(CashLocationData location) {
    widget.onCashLocationSelected?.call(location);
    widget.onChanged?.call(location.id);
    widget.onChangedWithName?.call(location.id, location.name);
  }

  void _handleClear() {
    widget.onChanged?.call(null);
    widget.onChangedWithName?.call(null, null);
  }
}

// ═══════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY
// ═══════════════════════════════════════════════════════════════

/// @Deprecated: Use [CashLocationSelector] instead. Will be removed in v2.0
@Deprecated('Use CashLocationSelector instead. Will be removed in v2.0')
typedef AutonomousCashLocationSelector = CashLocationSelector;
