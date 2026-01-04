import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/lc_master_data_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// LC Type selector section for LC form
class LCTypeSection extends ConsumerWidget {
  final String? lcTypeCode;
  final ValueChanged<String?> onLCTypeChanged;

  const LCTypeSection({
    super.key,
    required this.lcTypeCode,
    required this.onLCTypeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lcTypesAsync = ref.watch(lcTypesProvider);

    return lcTypesAsync.when(
      loading: () => TossDropdown<String>(
        label: 'LC Type',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) {
        // Fallback to hardcoded if DB fails
        final fallbackTypes = [
          TossDropdownItem(value: 'irrevocable', label: 'Irrevocable'),
          TossDropdownItem(value: 'confirmed', label: 'Confirmed'),
          TossDropdownItem(value: 'transferable', label: 'Transferable'),
          TossDropdownItem(value: 'revolving', label: 'Revolving'),
          TossDropdownItem(value: 'standby', label: 'Standby'),
        ];
        return TossDropdown<String>(
          label: 'LC Type',
          value: lcTypeCode,
          hint: 'Select LC type',
          items: fallbackTypes,
          onChanged: onLCTypeChanged,
        );
      },
      data: (lcTypes) {
        return TossDropdown<String>(
          label: 'LC Type',
          value: lcTypeCode,
          hint: 'Select LC type',
          items: lcTypes
              .map((t) => TossDropdownItem<String>(
                    value: t.code,
                    label: t.name,
                    subtitle: t.description,
                  ))
              .toList(),
          onChanged: onLCTypeChanged,
        );
      },
    );
  }
}
