import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pending shipments available'),
          backgroundColor: TossColors.gray600,
        ),
      );
      return Future.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.bottomSheet),
        ),
      ),
      builder: (context) => ShipmentPickerSheet(
        shipments: shipments,
        selectedShipment: selectedShipment,
        onSelected: (shipment) {
          Navigator.pop(context);
          onSelected(shipment);
        },
      ),
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
                borderRadius: BorderRadius.circular(2),
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
                        fontWeight: FontWeight.w500,
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
