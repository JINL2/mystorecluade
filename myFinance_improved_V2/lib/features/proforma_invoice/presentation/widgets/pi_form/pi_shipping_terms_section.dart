import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Incoterms and Payment Terms section for PI form
class PIShippingTermsSection extends ConsumerWidget {
  final String? incotermsCode;
  final TextEditingController incotermsPlaceController;
  final String? paymentTermsCode;
  final TextEditingController paymentTermsDetailController;
  final ValueChanged<String?> onIncotermsChanged;
  final ValueChanged<String?> onPaymentTermsChanged;

  const PIShippingTermsSection({
    super.key,
    required this.incotermsCode,
    required this.incotermsPlaceController,
    required this.paymentTermsCode,
    required this.paymentTermsDetailController,
    required this.onIncotermsChanged,
    required this.onPaymentTermsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final incoterms = masterDataState.incoterms;
    final paymentTerms = masterDataState.paymentTerms;

    // Fallback to hardcoded values if not loaded
    final incotermItems = incoterms.isNotEmpty
        ? incoterms.map((i) => TossDropdownItem<String>(
            value: i.code,
            label: i.code,
            subtitle: i.name,
          )).toList()
        : ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    final paymentTermItems = paymentTerms.isNotEmpty
        ? paymentTerms.map((p) => TossDropdownItem<String>(
            value: p.code,
            label: p.code,
            subtitle: p.name,
          )).toList()
        : ['LC_AT_SIGHT', 'LC_USANCE', 'TT_ADVANCE', 'TT_AFTER', 'DA', 'DP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return Column(
      children: [
        // Incoterms Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TossDropdown<String>(
                label: 'Incoterms',
                value: incotermsCode,
                hint: 'Select',
                isLoading: masterDataState.isLoading,
                items: incotermItems,
                onChanged: onIncotermsChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TossTextField.filled(
                controller: incotermsPlaceController,
                label: 'Place',
                hintText: 'Enter Place',
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        // Payment Terms Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TossDropdown<String>(
                label: 'Payment Terms',
                value: paymentTermsCode,
                hint: 'Select',
                isLoading: masterDataState.isLoading,
                items: paymentTermItems,
                onChanged: onPaymentTermsChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TossTextField.filled(
                controller: paymentTermsDetailController,
                label: 'Detail',
                hintText: 'Enter Detail',
              ),
            ),
          ],
        ),
      ],
    );
  }

}
