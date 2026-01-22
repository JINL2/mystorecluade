import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/index.dart';
import '../../../../../shared/widgets/organisms/sheets/selection_bottom_sheet_common.dart';
import '../../../domain/entities/shipment.dart';

/// Bottom sheet picker for selecting shipment
class ShipmentPickerSheet extends StatelessWidget {
  final List<Shipment> shipments;
  final Shipment? selectedShipment;
  final void Function(Shipment shipment) onSelected;

  const ShipmentPickerSheet({
    super.key,
    required this.shipments,
    required this.selectedShipment,
    required this.onSelected,
  });

  /// Shows the shipment picker bottom sheet
  static Future<void> show({
    required BuildContext context,
    required List<Shipment> shipments,
    required Shipment? selectedShipment,
    required void Function(Shipment shipment) onSelected,
  }) {
    if (shipments.isEmpty) {
      TossToast.info(context, 'No pending shipments available');
      return Future.value();
    }

    return SelectionBottomSheetCommon.show(
      context: context,
      title: 'Select Shipment',
      maxHeightRatio: 0.6,
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        final isSelected = shipment.shipmentId == selectedShipment?.shipmentId;
        return ListTile(
          leading: Icon(
            Icons.local_shipping_outlined,
            color: isSelected ? TossColors.primary : TossColors.gray600,
          ),
          title: Text(
            shipment.shipmentNumber,
            style: TossTextStyles.body.copyWith(
              fontWeight: TossFontWeight.medium,
              color: isSelected ? TossColors.primary : TossColors.gray900,
            ),
          ),
          subtitle: Text(
            '${shipment.supplierName} - ${shipment.itemCount} items',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray500,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: TossColors.primary)
              : null,
          onTap: () {
            Navigator.pop(context);
            onSelected(shipment);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: TossSpacing.space2),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'Select Shipment',
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: shipments.length,
                itemBuilder: (context, index) {
                  final shipment = shipments[index];
                  final isSelected =
                      shipment.shipmentId == selectedShipment?.shipmentId;
                  return ListTile(
                    leading: Icon(
                      Icons.local_shipping_outlined,
                      color:
                          isSelected ? TossColors.primary : TossColors.gray600,
                    ),
                    title: Text(
                      shipment.shipmentNumber,
                      style: TossTextStyles.body.copyWith(
                        fontWeight: TossFontWeight.medium,
                        color: isSelected
                            ? TossColors.primary
                            : TossColors.gray900,
                      ),
                    ),
                    subtitle: Text(
                      '${shipment.supplierName} • ${shipment.itemCount} items',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check,
                            color: TossColors.primary,
                          )
                        : null,
                    onTap: () => onSelected(shipment),
                  );
                },
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
          ],
        ),
      ),
    );
  }
}
