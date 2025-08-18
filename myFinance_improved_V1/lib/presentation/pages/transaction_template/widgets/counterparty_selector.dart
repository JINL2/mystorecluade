import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_dropdown.dart';
import '../providers/counterparty_providers.dart';

class CounterpartySelector extends ConsumerStatefulWidget {
  final String? accountId;
  final String? selectedCounterpartyId;
  final Function(String?, Map<String, dynamic>?) onChanged;
  final String label;
  final String hint;

  const CounterpartySelector({
    super.key,
    required this.accountId,
    this.selectedCounterpartyId,
    required this.onChanged,
    required this.label,
    required this.hint,
  });

  @override
  ConsumerState<CounterpartySelector> createState() => _CounterpartySelectorState();
}

class _CounterpartySelectorState extends ConsumerState<CounterpartySelector> {
  @override
  Widget build(BuildContext context) {
    final counterpartiesAsync = ref.watch(counterpartiesForSelectionProvider(widget.accountId));
    final mappedCounterpartiesAsync = ref.watch(mappedCounterpartiesProvider(widget.accountId));

    return counterpartiesAsync.when(
      data: (counterparties) {
        final mappedCounterparties = mappedCounterpartiesAsync.value ?? [];
        
        // Create dropdown items with custom subtitles
        final items = counterparties.map((counterparty) {
          final counterpartyId = counterparty['counterparty_id'] as String;
          final name = counterparty['name'] as String;
          final isInternal = counterparty['is_internal'] as bool? ?? false;
          final isMapped = mappedCounterparties.any((m) => m['counterparty_id'] == counterpartyId);
          
          // Build subtitle with status badges
          final statusParts = <String>[];
          statusParts.add(isInternal ? 'Internal' : 'External');
          if (isMapped) statusParts.add('Mapped');
          
          return TossDropdownItem<String>(
            value: counterpartyId,
            label: name,
            subtitle: statusParts.join(' • '),
          );
        }).toList();

        return TossDropdown<String>(
          label: widget.label,
          hint: widget.hint,
          value: widget.selectedCounterpartyId,
          onChanged: (value) {
            if (value != null) {
              final selectedData = counterparties.firstWhere(
                (c) => c['counterparty_id'] == value,
                orElse: () => {},
              );
              widget.onChanged(value, selectedData);
            } else {
              widget.onChanged(null, null);
            }
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
        errorText: 'Error loading counterparties',
      ),
    );
  }

}