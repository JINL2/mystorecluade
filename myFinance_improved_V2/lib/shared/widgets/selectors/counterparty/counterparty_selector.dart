/// Counterparty Selector
///
/// Autonomous counterparty selector widget for selecting counterparties.
/// Uses Riverpod providers internally for automatic data fetching.
///
/// ## Basic Usage
/// ```dart
/// CounterpartySelector(
///   selectedCounterpartyId: _counterpartyId,
///   onCounterpartySelected: (counterparty) {
///     setState(() => _counterpartyId = counterparty.id);
///   },
/// )
/// ```
///
/// ## With Type Filter
/// ```dart
/// CounterpartySelector(
///   counterpartyType: 'Customers',
///   selectedCounterpartyId: _counterpartyId,
///   onCounterpartySelected: (counterparty) => handleSelection(counterparty),
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/counterparty_provider.dart';
import 'package:myfinance_improved/core/domain/entities/selector_entities.dart';
import '../../../../shared/extensions/string_extensions.dart';

import '../base/index.dart';

/// Callback type for counterparty selection
typedef OnCounterpartySelectedCallback = void Function(CounterpartyData counterparty);

/// Counterparty selector widget
class CounterpartySelector extends ConsumerWidget {
  final String? selectedCounterpartyId;
  final SingleSelectionCallback? onChanged;
  final OnCounterpartySelectedCallback? onCounterpartySelected;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? counterpartyType;
  final bool? isInternal;
  final bool hideLabel;

  const CounterpartySelector({
    super.key,
    this.selectedCounterpartyId,
    this.onChanged,
    this.onCounterpartySelected,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.counterpartyType,
    this.isInternal,
    this.hideLabel = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late AsyncValue<List<CounterpartyData>> counterpartiesAsync;

    if (counterpartyType != null) {
      counterpartiesAsync = ref.watch(currentCounterpartiesByTypeProvider(counterpartyType!));
    } else if (isInternal == true) {
      counterpartiesAsync = ref.watch(currentInternalCounterpartiesProvider);
    } else if (isInternal == false) {
      counterpartiesAsync = ref.watch(currentExternalCounterpartiesProvider);
    } else {
      counterpartiesAsync = ref.watch(currentCounterpartiesProvider);
    }

    CounterpartyData? selectedCounterparty;
    final counterpartiesList = counterpartiesAsync.maybeWhen(
      data: (counterparties) => counterparties,
      orElse: () => <CounterpartyData>[],
    );

    if (selectedCounterpartyId != null && counterpartiesList.isNotEmpty) {
      try {
        selectedCounterparty = counterpartiesList.firstWhere(
          (cp) => cp.id == selectedCounterpartyId,
          orElse: () => throw StateError('Counterparty not found'),
        );
      } catch (e) {
        debugPrint('\u26a0\ufe0f Selected counterparty $selectedCounterpartyId not found in list');
        selectedCounterparty = null;
      }
    }

    return TossSingleSelector<CounterpartyData>(
      items: counterpartiesList,
      selectedItem: selectedCounterparty,
      onChanged: (selectedId) {
        onChanged?.call(selectedId);

        if (selectedId == null) return;

        try {
          final selected = counterpartiesList.firstWhere(
            (cp) => cp.id == selectedId,
            orElse: () => throw StateError('Counterparty not found'),
          );

          debugPrint('\ud83c\udfaf Counterparty selected: ${selected.name} (${selected.id})');
          onCounterpartySelected?.call(selected);
          onChanged?.call(selectedId);
        } catch (e) {
          debugPrint('\u274c Failed to find selected counterparty: $e');
          onChanged?.call(selectedId);
        }
      },
      isLoading: counterpartiesAsync.isLoading,
      config: SelectorConfig(
        label: label ?? _getCounterpartyTypeLabel(),
        hint: hint ?? _getCounterpartyTypeHint(),
        errorText: errorText,
        showSearch: showSearch,
        showTransactionCount: showTransactionCount,
        icon: _getCounterpartyIcon(),
        emptyMessage: 'No ${_getCounterpartyTypeLabel().toLowerCase()} available',
        searchHint: 'Search ${_getCounterpartyTypeLabel().toLowerCase()}',
        hideLabel: hideLabel,
      ),
      itemTitleBuilder: (counterparty) => _buildCounterpartyTitle(counterparty),
      itemSubtitleBuilder: (counterparty) => _buildCounterpartySubtitle(counterparty),
      itemIdBuilder: (counterparty) => counterparty.id,
    );
  }

  String _getCounterpartyTypeLabel() {
    if (counterpartyType != null) {
      switch (counterpartyType!) {
        case 'Customers':
        case 'customers':
        case 'customer':
          return 'Customer';
        case 'Suppliers':
        case 'suppliers':
        case 'supplier':
          return 'Supplier';
        case 'My Company':
        case 'myCompany':
          return 'My Company';
        case 'Team Member':
        case 'teamMember':
          return 'Team Member';
        case 'Employees':
        case 'employees':
        case 'employee':
          return 'Employee';
        case 'Others':
        case 'others':
        case 'other':
          return 'Other';
        default:
          return counterpartyType!;
      }
    }

    if (isInternal == true) return 'Internal Counterparty';
    if (isInternal == false) return 'External Counterparty';

    return label ?? 'Counterparty';
  }

  String _getCounterpartyTypeHint() {
    if (counterpartyType != null) {
      switch (counterpartyType!) {
        case 'Customers':
        case 'customers':
          return 'Select Customer';
        case 'Suppliers':
        case 'suppliers':
          return 'Select Supplier';
        case 'My Company':
        case 'myCompany':
          return 'Select Company';
        case 'Team Member':
        case 'teamMember':
          return 'Select Team Member';
        case 'Employees':
        case 'employees':
          return 'Select Employee';
        case 'Others':
        case 'others':
          return 'Select Other';
        default:
          return 'Select ${counterpartyType!}';
      }
    }

    if (isInternal == true) return 'Select Internal';
    if (isInternal == false) return 'Select External';

    return hint ?? 'All Counterparties';
  }

  IconData _getCounterpartyIcon() {
    if (counterpartyType != null) {
      switch (counterpartyType!) {
        case 'Customers':
        case 'customers':
          return Icons.person;
        case 'Suppliers':
        case 'suppliers':
          return Icons.business;
        case 'My Company':
        case 'myCompany':
          return Icons.domain;
        case 'Team Member':
        case 'teamMember':
          return Icons.groups;
        case 'Employees':
        case 'employees':
          return Icons.badge;
        case 'Others':
        case 'others':
          return Icons.more_horiz;
        default:
          return Icons.people;
      }
    }

    if (isInternal == true) return Icons.badge;
    if (isInternal == false) return Icons.public;

    return Icons.people;
  }

  String _buildCounterpartyTitle(CounterpartyData counterparty) {
    if (counterparty.isInternal) {
      return '\ud83c\udfe2 ${counterparty.name}';
    }
    return counterparty.name;
  }

  String _buildCounterpartySubtitle(CounterpartyData counterparty) {
    final parts = <String>[];

    if (counterparty.isInternal) {
      parts.add('Internal Company');
    }

    if (counterparty.type.isNotEmpty &&
        counterparty.type != 'My Company' &&
        counterparty.type != 'Team Member') {
      parts.add(counterparty.type);
    }

    if (showTransactionCount && counterparty.transactionCount > 0) {
      parts.add('${counterparty.transactionCount} transactions');
    }

    if (parts.isEmpty && counterparty.type.isNotEmpty) {
      parts.add(counterparty.type);
    }

    return parts.join(' \u2022 ');
  }
}

/// Multi-counterparty selector widget
class CounterpartyMultiSelector extends ConsumerStatefulWidget {
  final List<String>? selectedCounterpartyIds;
  final MultiSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? counterpartyType;
  final bool? isInternal;

  const CounterpartyMultiSelector({
    super.key,
    this.selectedCounterpartyIds,
    this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.showSearch = true,
    this.showTransactionCount = true,
    this.counterpartyType,
    this.isInternal,
  });

  @override
  ConsumerState<CounterpartyMultiSelector> createState() => _CounterpartyMultiSelectorState();
}

class _CounterpartyMultiSelectorState extends ConsumerState<CounterpartyMultiSelector> {
  List<String> _tempSelectedIds = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = widget.selectedCounterpartyIds?.toList() ?? [];
  }

  @override
  void didUpdateWidget(CounterpartyMultiSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCounterpartyIds != oldWidget.selectedCounterpartyIds) {
      _tempSelectedIds = widget.selectedCounterpartyIds?.toList() ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    late AsyncValue<List<CounterpartyData>> counterpartiesAsync;

    if (widget.counterpartyType != null) {
      counterpartiesAsync =
          ref.watch(currentCounterpartiesByTypeProvider(widget.counterpartyType!));
    } else if (widget.isInternal == true) {
      counterpartiesAsync = ref.watch(currentInternalCounterpartiesProvider);
    } else if (widget.isInternal == false) {
      counterpartiesAsync = ref.watch(currentExternalCounterpartiesProvider);
    } else {
      counterpartiesAsync = ref.watch(currentCounterpartiesProvider);
    }

    return TossMultiSelector<CounterpartyData>(
      items: counterpartiesAsync.maybeWhen(
        data: (counterparties) => counterparties,
        orElse: () => [],
      ),
      selectedIds: widget.selectedCounterpartyIds ?? [],
      tempSelectedIds: _tempSelectedIds,
      onTempSelectionChanged: (ids) {
        setState(() {
          _tempSelectedIds = ids;
        });
      },
      onConfirm: () {
        widget.onChanged?.call(_tempSelectedIds);
      },
      onCancel: () {
        setState(() {
          _tempSelectedIds = widget.selectedCounterpartyIds?.toList() ?? [];
        });
      },
      isLoading: counterpartiesAsync.isLoading,
      config: SelectorConfig(
        label: widget.label ?? _getCounterpartyTypeLabel(),
        hint: widget.hint ?? _getCounterpartyTypeHint(),
        errorText: widget.errorText,
        showSearch: widget.showSearch,
        showTransactionCount: widget.showTransactionCount,
        icon: _getCounterpartyIcon(),
        emptyMessage: 'No ${_getCounterpartyTypeLabel().toLowerCase()} available',
        searchHint: 'Search ${_getCounterpartyTypeLabel().toLowerCase()}',
      ),
      itemTitleBuilder: (counterparty) => _buildCounterpartyTitle(counterparty),
      itemSubtitleBuilder: (counterparty) => _buildCounterpartySubtitle(counterparty),
      itemIdBuilder: (counterparty) => counterparty.id,
    );
  }

  String _getCounterpartyTypeLabel() {
    if (widget.counterpartyType != null) {
      switch (widget.counterpartyType!.toLowerCase()) {
        case 'customer':
          return 'Customers';
        case 'vendor':
          return 'Counterparties';
        case 'supplier':
          return 'Suppliers';
        default:
          return '${widget.counterpartyType!.capitalize()} Counterparties';
      }
    }

    if (widget.isInternal == true) return 'Internal Counterparties';
    if (widget.isInternal == false) return 'External Counterparties';

    return widget.label ?? 'Counterparties';
  }

  String _getCounterpartyTypeHint() {
    if (widget.counterpartyType != null) {
      return 'Select ${_getCounterpartyTypeLabel()}';
    }

    if (widget.isInternal == true) return 'Select Internal';
    if (widget.isInternal == false) return 'Select External';

    return widget.hint ?? 'Select Counterparties';
  }

  IconData _getCounterpartyIcon() {
    if (widget.counterpartyType != null) {
      switch (widget.counterpartyType!.toLowerCase()) {
        case 'customer':
          return Icons.person;
        case 'vendor':
        case 'supplier':
          return Icons.business;
        default:
          return Icons.people;
      }
    }

    if (widget.isInternal == true) return Icons.badge;
    if (widget.isInternal == false) return Icons.public;

    return Icons.people;
  }

  String _buildCounterpartyTitle(CounterpartyData counterparty) {
    if (counterparty.isInternal) {
      return '\ud83c\udfe2 ${counterparty.name}';
    }
    return counterparty.name;
  }

  String _buildCounterpartySubtitle(CounterpartyData counterparty) {
    final parts = <String>[];

    if (counterparty.isInternal) {
      parts.add('Internal Company');
    }

    if (counterparty.type.isNotEmpty &&
        counterparty.type != 'My Company' &&
        counterparty.type != 'Team Member') {
      parts.add(counterparty.type);
    }

    if (widget.showTransactionCount && counterparty.transactionCount > 0) {
      parts.add('${counterparty.transactionCount} transactions');
    }

    if (parts.isEmpty && counterparty.type.isNotEmpty) {
      parts.add(counterparty.type);
    }

    return parts.join(' \u2022 ');
  }
}

// ═══════════════════════════════════════════════════════════════
// BACKWARD COMPATIBILITY
// ═══════════════════════════════════════════════════════════════

/// @Deprecated: Use [CounterpartySelector] instead. Will be removed in v2.0
@Deprecated('Use CounterpartySelector instead. Will be removed in v2.0')
typedef AutonomousCounterpartySelector = CounterpartySelector;

/// @Deprecated: Use [CounterpartyMultiSelector] instead. Will be removed in v2.0
@Deprecated('Use CounterpartyMultiSelector instead. Will be removed in v2.0')
typedef AutonomousMultiCounterpartySelector = CounterpartyMultiSelector;
