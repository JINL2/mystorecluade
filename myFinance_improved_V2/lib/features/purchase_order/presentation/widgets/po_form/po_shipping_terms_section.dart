import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shipping terms section for PO form (Incoterms & Payment Terms)
class POShippingTermsSection extends ConsumerWidget {
  final String? incotermsCode;
  final TextEditingController incotermsPlaceController;
  final String? paymentTermsCode;
  final ValueChanged<String?> onIncotermsChanged;
  final ValueChanged<String?> onPaymentTermsChanged;

  const POShippingTermsSection({
    super.key,
    required this.incotermsCode,
    required this.incotermsPlaceController,
    required this.paymentTermsCode,
    required this.onIncotermsChanged,
    required this.onPaymentTermsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIncotermsRow(ref),
        const SizedBox(height: TossSpacing.space3),
        _buildPaymentTermsDropdown(ref),
      ],
    );
  }

  Widget _buildIncotermsRow(WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final incoterms = masterDataState.incoterms;

    final incotermItems = incoterms.isNotEmpty
        ? incoterms.map((i) => TossDropdownItem<String>(
              value: i.code,
              label: i.code,
              subtitle: i.name,
            )).toList()
        : ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TossDropdown<String>(
            label: 'Incoterms',
            value: incotermsCode,
            items: incotermItems,
            onChanged: onIncotermsChanged,
            hint: 'Select',
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: TossTextField.filled(
            controller: incotermsPlaceController,
            inlineLabel: 'Place',
            hintText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTermsDropdown(WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final paymentTerms = masterDataState.paymentTerms;

    final paymentTermItems = paymentTerms.isNotEmpty
        ? paymentTerms.map((p) => TossDropdownItem<String>(
              value: p.code,
              label: p.code,
              subtitle: p.name,
            )).toList()
        : ['T/T', 'L/C', 'D/P', 'D/A', 'CAD']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return TossDropdown<String>(
      label: 'Payment Terms',
      value: paymentTermsCode,
      items: paymentTermItems,
      onChanged: onPaymentTermsChanged,
      hint: 'Select',
    );
  }
}

/// Shipment options section for PO form (Partial Shipment & Transshipment toggles)
class POShipmentOptionsSection extends StatelessWidget {
  final bool partialShipmentAllowed;
  final bool transshipmentAllowed;
  final ValueChanged<bool> onPartialShipmentChanged;
  final ValueChanged<bool> onTransshipmentChanged;

  const POShipmentOptionsSection({
    super.key,
    required this.partialShipmentAllowed,
    required this.transshipmentAllowed,
    required this.onPartialShipmentChanged,
    required this.onTransshipmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildSwitchTile(
            'Partial Shipment',
            partialShipmentAllowed,
            onPartialShipmentChanged,
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: _buildSwitchTile(
            'Transshipment',
            transshipmentAllowed,
            onTransshipmentChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray300),
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              label,
              style: TossTextStyles.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            height: 24,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
