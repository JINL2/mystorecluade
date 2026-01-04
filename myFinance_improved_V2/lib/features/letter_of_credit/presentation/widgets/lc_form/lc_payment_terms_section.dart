import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../providers/lc_master_data_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Payment Terms section for LC form
class LCPaymentTermsSection extends ConsumerWidget {
  final String? paymentTermsCode;
  final TextEditingController usanceDaysController;
  final String? usanceFrom;
  final ValueChanged<String?> onPaymentTermsChanged;
  final ValueChanged<String?> onUsanceFromChanged;

  const LCPaymentTermsSection({
    super.key,
    required this.paymentTermsCode,
    required this.usanceDaysController,
    required this.usanceFrom,
    required this.onPaymentTermsChanged,
    required this.onUsanceFromChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentTermsDropdown(ref),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'Usance Days',
                controller: usanceDaysController,
                hintText: '',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(child: _buildUsanceFromDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentTermsDropdown(WidgetRef ref) {
    final lcPaymentTermsAsync = ref.watch(lcPaymentTermsProvider);

    return lcPaymentTermsAsync.when(
      loading: () => TossDropdown<String>(
        label: 'Payment Terms (LC)',
        items: const [],
        isLoading: true,
      ),
      error: (e, _) {
        // Fallback to hardcoded LC terms
        final fallbackTerms = [
          TossDropdownItem(value: 'lc_at_sight', label: 'L/C At Sight'),
          TossDropdownItem(value: 'lc_usance_30', label: 'L/C Usance 30 Days'),
          TossDropdownItem(value: 'lc_usance_60', label: 'L/C Usance 60 Days'),
          TossDropdownItem(value: 'lc_usance_90', label: 'L/C Usance 90 Days'),
        ];
        return TossDropdown<String>(
          label: 'Payment Terms (LC)',
          value: paymentTermsCode,
          items: fallbackTerms,
          onChanged: onPaymentTermsChanged,
          hint: 'Select',
        );
      },
      data: (paymentTerms) {
        return TossDropdown<String>(
          label: 'Payment Terms (LC)',
          value: paymentTermsCode,
          hint: 'Select LC payment term',
          items: paymentTerms
              .map((p) => TossDropdownItem<String>(
                    value: p.code,
                    label: p.name,
                    subtitle: p.description,
                  ))
              .toList(),
          onChanged: onPaymentTermsChanged,
        );
      },
    );
  }

  Widget _buildUsanceFromDropdown() {
    final usanceFromOptions = [
      TossDropdownItem(value: 'bl_date', label: 'B/L Date'),
      TossDropdownItem(value: 'shipment_date', label: 'Shipment Date'),
      TossDropdownItem(value: 'sight', label: 'At Sight'),
    ];

    return TossDropdown<String>(
      label: 'Usance From',
      value: usanceFrom,
      hint: 'Select',
      items: usanceFromOptions,
      onChanged: onUsanceFromChanged,
    );
  }
}
