import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../trade_shared/presentation/providers/trade_shared_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Trade Terms section for LC form (Incoterms, Ports, Shipping Method, Switches)
class LCTradeTermsSection extends ConsumerWidget {
  final String? incotermsCode;
  final TextEditingController incotermsPlaceController;
  final TextEditingController portOfLoadingController;
  final TextEditingController portOfDischargeController;
  final String? shippingMethodCode;
  final bool partialShipmentAllowed;
  final bool transshipmentAllowed;
  final ValueChanged<String?> onIncotermsChanged;
  final ValueChanged<String?> onShippingMethodChanged;
  final ValueChanged<bool> onPartialShipmentChanged;
  final ValueChanged<bool> onTransshipmentChanged;

  const LCTradeTermsSection({
    super.key,
    required this.incotermsCode,
    required this.incotermsPlaceController,
    required this.portOfLoadingController,
    required this.portOfDischargeController,
    required this.shippingMethodCode,
    required this.partialShipmentAllowed,
    required this.transshipmentAllowed,
    required this.onIncotermsChanged,
    required this.onShippingMethodChanged,
    required this.onPartialShipmentChanged,
    required this.onTransshipmentChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIncotermsDropdown(ref),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          inlineLabel: 'Incoterms Place',
          controller: incotermsPlaceController,
          hintText: '',
        ),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'Port of Loading',
                controller: portOfLoadingController,
                hintText: '',
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: TossTextField.filled(
                inlineLabel: 'Port of Discharge',
                controller: portOfDischargeController,
                hintText: '',
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        _buildShippingMethodDropdown(ref),
        const SizedBox(height: TossSpacing.space3),
        Row(
          children: [
            Expanded(
              child: _buildSwitchTile(
                'Partial Shipment',
                partialShipmentAllowed,
                onPartialShipmentChanged,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: _buildSwitchTile(
                'Transshipment',
                transshipmentAllowed,
                onTransshipmentChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncotermsDropdown(WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final incoterms = masterDataState.incoterms;

    final incotermItems = incoterms.isNotEmpty
        ? incoterms
            .map((i) => TossDropdownItem<String>(
                  value: i.code,
                  label: i.code,
                  subtitle: i.name,
                ))
            .toList()
        : ['FOB', 'CIF', 'CFR', 'EXW', 'DDP', 'DAP']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return TossDropdown<String>(
      label: 'Incoterms',
      value: incotermsCode,
      items: incotermItems,
      onChanged: onIncotermsChanged,
      hint: 'Select',
    );
  }

  Widget _buildShippingMethodDropdown(WidgetRef ref) {
    final masterDataState = ref.watch(masterDataProvider);
    final shippingMethods = masterDataState.shippingMethods;

    final shippingItems = shippingMethods.isNotEmpty
        ? shippingMethods
            .map((m) => TossDropdownItem<String>(
                  value: m.code,
                  label: m.code,
                  subtitle: m.name,
                ))
            .toList()
        : ['SEA', 'AIR', 'RAIL', 'ROAD', 'MULTI']
            .map((c) => TossDropdownItem<String>(value: c, label: c))
            .toList();

    return TossDropdown<String>(
      label: 'Shipping Method',
      value: shippingMethodCode,
      items: shippingItems,
      onChanged: onShippingMethodChanged,
      hint: 'Select',
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
