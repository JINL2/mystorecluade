import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/presentation/providers/entities/cash_location_provider.dart';
import 'package:myfinance_improved/data/models/selector_entities.dart';

// Provider to fetch cash locations for a specific company and store
final cashLocationsForStoreProvider = FutureProvider.family<List<CashLocationData>, CashLocationParams>((ref, params) async {
  if (params.storeId == null || params.storeId!.isEmpty || 
      params.companyId == null || params.companyId!.isEmpty) {
    return [];
  }
  
  try {
    // Use the existing cashLocationListProvider with company and store IDs
    final cashLocations = await ref.watch(
      cashLocationListProvider(params.companyId!, params.storeId).future
    );
    
    return cashLocations;
  } catch (e) {
    // Silently handle error
    return [];
  }
});

// Parameters class for cash location provider
class CashLocationParams {
  final String? companyId;
  final String? storeId;
  
  CashLocationParams({this.companyId, this.storeId});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashLocationParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ storeId.hashCode;
}

class CashLocationSelector extends ConsumerStatefulWidget {
  final String? companyId;
  final String? storeId;
  final String? selectedCashLocationId;
  final Function(String?) onChanged;
  final String label;
  final String hint;

  const CashLocationSelector({
    super.key,
    required this.companyId,
    required this.storeId,
    this.selectedCashLocationId,
    required this.onChanged,
    required this.label,
    required this.hint,
  });

  @override
  ConsumerState<CashLocationSelector> createState() => _CashLocationSelectorState();
}

class _CashLocationSelectorState extends ConsumerState<CashLocationSelector> {
  @override
  Widget build(BuildContext context) {
    final params = CashLocationParams(
      companyId: widget.companyId,
      storeId: widget.storeId,
    );
    final cashLocationsAsync = ref.watch(cashLocationsForStoreProvider(params));

    return cashLocationsAsync.when(
      data: (cashLocations) {

        // Create items list with "None" option at the beginning
        final items = <TossDropdownItem<String>>[
          const TossDropdownItem<String>(
            value: 'none',
            label: 'None',
            subtitle: 'No cash location',
          ),
          ...cashLocations.map((cashLocation) {
            return TossDropdownItem<String>(
              value: cashLocation.id,
              label: cashLocation.name,
              subtitle: cashLocation.type.isNotEmpty ? cashLocation.type : null,
            );
          }),
        ];

        return TossDropdown<String>(
          label: widget.label,
          hint: widget.hint,
          value: widget.selectedCashLocationId ?? 'none', // Convert null to 'none' for display
          onChanged: (value) {
            // Convert 'none' to null
            widget.onChanged(value == 'none' ? null : value);
          },
          items: items,
        );
      },
      loading: () => TossDropdown<String>(
        label: widget.label,
        hint: widget.hint,
        value: null,
        items: const [],
        isLoading: true,
      ),
      error: (error, stack) => TossDropdown<String>(
        label: widget.label,
        hint: widget.hint,
        value: null,
        items: const [],
        errorText: 'Error loading cash locations',
      ),
    );
  }

}