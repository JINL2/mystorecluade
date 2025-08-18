import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_dropdown.dart';
import 'package:myfinance_improved/presentation/providers/entities/cash_location_provider.dart';

class MyCashLocationSelector extends ConsumerWidget {
  final String? selectedLocationId;
  final Function(String?) onChanged;
  final String label;
  final String hint;

  const MyCashLocationSelector({
    super.key,
    this.selectedLocationId,
    required this.onChanged,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use companyCashLocations to get all locations for the company
    final cashLocationsAsync = ref.watch(companyCashLocationsProvider);

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
          label: label,
          hint: hint,
          value: selectedLocationId ?? 'none', // Convert null to 'none' for display
          onChanged: (value) {
            // Convert 'none' to null
            onChanged(value == 'none' ? null : value);
          },
          items: items,
        );
      },
      loading: () => TossDropdown<String>(
        label: label,
        hint: hint,
        value: null,
        items: const [],
        isLoading: true,
      ),
      error: (error, stack) => TossDropdown<String>(
        label: label,
        hint: hint,
        value: null,
        items: const [],
        errorText: 'Error loading cash locations',
      ),
    );
  }
}