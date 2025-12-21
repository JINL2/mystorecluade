// =====================================================
// AUTONOMOUS COUNTERPARTY SELECTOR
// Truly reusable counterparty selector using entity providers
// =====================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/selector_entities.dart';
import '../../../providers/entities/counterparty_provider.dart';
import 'toss_base_selector.dart';
import 'selector_utils.dart';

/// Autonomous counterparty selector that can be used anywhere in the app
/// Uses dedicated RPC function and entity providers
class AutonomousCounterpartySelector extends ConsumerWidget {
  final String? selectedCounterpartyId;
  final SingleSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? counterpartyType; // Filter by specific type (customer, vendor, supplier)
  final bool? isInternal; // Filter by internal/external

  const AutonomousCounterpartySelector({
    super.key,
    this.selectedCounterpartyId,
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
  Widget build(BuildContext context, WidgetRef ref) {
    
    // Choose the appropriate provider based on filters
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
    
    print('DEBUG: AutonomousCounterpartySelector - counterpartiesAsync state: ${counterpartiesAsync.when(
      data: (data) => 'data: ${data.length} items',
      loading: () => 'loading',
      error: (error, stack) => 'error: $error',
    )}');
    

    // Find selected counterparty
    CounterpartyData? selectedCounterparty;
    if (selectedCounterpartyId != null) {
      counterpartiesAsync.whenData((counterparties) {
        try {
          selectedCounterparty = counterparties.firstWhere((cp) => cp.id == selectedCounterpartyId);
        } catch (e) {
          selectedCounterparty = null;
        }
      });
    }

    return TossSingleSelector<CounterpartyData>(
      items: counterpartiesAsync.maybeWhen(
        data: (counterparties) => counterparties,
        orElse: () => [],
      ),
      selectedItem: selectedCounterparty,
      onChanged: onChanged ?? (_) {},
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
      ),
      itemTitleBuilder: (counterparty) => _buildCounterpartyTitle(counterparty),
      itemSubtitleBuilder: showTransactionCount 
          ? (counterparty) => _buildCounterpartySubtitle(counterparty)
          : (counterparty) => _buildCounterpartySubtitle(counterparty),
      itemIdBuilder: (counterparty) => counterparty.id,
    );
  }

  String _getCounterpartyTypeLabel() {
    if (counterpartyType != null) {
      // Handle your actual counterparty types
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
      // Handle your actual counterparty types
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
      // Handle your actual counterparty types
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
    // Add [Internal] prefix for internal counterparties
    if (counterparty.isInternal) {
      return '🏢 ${counterparty.name}';
    }
    return counterparty.name;
  }
  
  String _buildCounterpartySubtitle(CounterpartyData counterparty) {
    final parts = <String>[];
    
    // Add internal badge first if internal
    if (counterparty.isInternal) {
      parts.add('Internal Company');
    }
    
    // Add type if not redundant with internal status
    if (counterparty.type.isNotEmpty && 
        counterparty.type != 'My Company' && 
        counterparty.type != 'Team Member') {
      parts.add(counterparty.type);
    }
    
    // Add transaction count if enabled
    if (showTransactionCount && counterparty.transactionCount > 0) {
      parts.add('${counterparty.transactionCount} transactions');
    }
    
    // If no parts, at least show the type
    if (parts.isEmpty && counterparty.type.isNotEmpty) {
      parts.add(counterparty.type);
    }
    
    return parts.join(' • ');
  }
}

/// Autonomous multi-counterparty selector for multiple counterparty selection
class AutonomousMultiCounterpartySelector extends ConsumerStatefulWidget {
  final List<String>? selectedCounterpartyIds;
  final MultiSelectionCallback? onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool showSearch;
  final bool showTransactionCount;
  final String? counterpartyType;
  final bool? isInternal;

  const AutonomousMultiCounterpartySelector({
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
  ConsumerState<AutonomousMultiCounterpartySelector> createState() => _AutonomousMultiCounterpartySelectorState();
}

class _AutonomousMultiCounterpartySelectorState extends ConsumerState<AutonomousMultiCounterpartySelector> {
  List<String> _tempSelectedIds = [];

  @override
  void initState() {
    super.initState();
    _tempSelectedIds = widget.selectedCounterpartyIds?.toList() ?? [];
  }

  @override
  void didUpdateWidget(AutonomousMultiCounterpartySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCounterpartyIds != oldWidget.selectedCounterpartyIds) {
      _tempSelectedIds = widget.selectedCounterpartyIds?.toList() ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Choose the appropriate provider based on filters
    late AsyncValue<List<CounterpartyData>> counterpartiesAsync;
    
    if (widget.counterpartyType != null) {
      counterpartiesAsync = ref.watch(currentCounterpartiesByTypeProvider(widget.counterpartyType!));
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
    // Add building emoji for internal counterparties
    if (counterparty.isInternal) {
      return '🏢 ${counterparty.name}';
    }
    return counterparty.name;
  }
  
  String _buildCounterpartySubtitle(CounterpartyData counterparty) {
    final parts = <String>[];
    
    // Add internal badge first if internal
    if (counterparty.isInternal) {
      parts.add('Internal Company');
    }
    
    // Add type if not redundant with internal status
    if (counterparty.type.isNotEmpty && 
        counterparty.type != 'My Company' && 
        counterparty.type != 'Team Member') {
      parts.add(counterparty.type);
    }
    
    // Add transaction count if enabled
    if (widget.showTransactionCount && counterparty.transactionCount > 0) {
      parts.add('${counterparty.transactionCount} transactions');
    }
    
    // If no parts, at least show the type
    if (parts.isEmpty && counterparty.type.isNotEmpty) {
      parts.add(counterparty.type);
    }
    
    return parts.join(' • ');
  }
}

// Helper extension for string capitalization
