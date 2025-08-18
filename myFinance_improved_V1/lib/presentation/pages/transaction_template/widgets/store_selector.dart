import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_dropdown.dart';
import '../providers/counterparty_providers.dart';

class StoreSelector extends ConsumerStatefulWidget {
  final String? linkedCompanyId;
  final String? selectedStoreId;
  final Function(String?, String?) onChanged; // storeId, storeName
  final String label;
  final String hint;

  const StoreSelector({
    super.key,
    required this.linkedCompanyId,
    this.selectedStoreId,
    required this.onChanged,
    required this.label,
    required this.hint,
  });

  @override
  ConsumerState<StoreSelector> createState() => _StoreSelectorState();
}

class _StoreSelectorState extends ConsumerState<StoreSelector> {
  @override
  Widget build(BuildContext context) {
    final storesAsync = ref.watch(storesForLinkedCompanyProvider(widget.linkedCompanyId));

    return storesAsync.when(
      data: (stores) {
        return TossDropdown<String>(
          label: widget.label,
          hint: widget.hint,
          value: widget.selectedStoreId,
          onChanged: (value) {
            if (value != null) {
              final selectedStore = stores.firstWhere(
                (s) => s['store_id'] == value,
                orElse: () => {},
              );
              widget.onChanged(value, selectedStore['store_name'] as String?);
            } else {
              widget.onChanged(null, null);
            }
          },
          items: stores.map((store) {
            final storeId = store['store_id'] as String;
            final storeName = store['store_name'] as String;
            
            return TossDropdownItem<String>(
              value: storeId,
              label: storeName,
            );
          }).toList(),
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
        errorText: 'Error loading stores',
      ),
    );
  }

}