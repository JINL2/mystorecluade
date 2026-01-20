import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/molecules/inputs/toss_quantity_input.dart';
import '../../providers/states/session_detail_state.dart';
import 'rejected_quantity_stepper.dart';

/// Dialog for entering session quantity with optional rejected quantity
class SessionQuantityDialog extends StatefulWidget {
  final SelectedProduct item;
  final void Function(int counted, int rejected) onSubmit;

  const SessionQuantityDialog({
    super.key,
    required this.item,
    required this.onSubmit,
  });

  @override
  State<SessionQuantityDialog> createState() => _SessionQuantityDialogState();
}

class _SessionQuantityDialogState extends State<SessionQuantityDialog> {
  late int _quantity;
  late int _rejected;
  bool _showRejected = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
    _rejected = widget.item.quantityRejected;
    _showRejected = widget.item.quantityRejected != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space10),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Enter Quantity',
              style: TossTextStyles.h3.copyWith(
                fontWeight: TossFontWeight.bold,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TossSpacing.space2),
            // Product name (uses displayName if available for variant products)
            Text(
              widget.item.name,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Product SKU
            if (widget.item.sku != null)
              Text(
                widget.item.sku!,
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: TossSpacing.space6),
            // Quantity input using TossQuantityInput.stepper
            TossQuantityInput.stepper(
              value: _quantity,
              minValue: 0,
              previousValue: 0,
              stockChangeMode: StockChangeMode.add,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
            const SizedBox(height: TossSpacing.space4),
            // Rejected quantity toggle
            GestureDetector(
              onTap: () {
                setState(() {
                  _showRejected = !_showRejected;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Rejected Quantity (Optional)',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space1),
                  Icon(
                    _showRejected
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: TossColors.gray400,
                    size: TossSpacing.iconMD,
                  ),
                ],
              ),
            ),
            // Rejected quantity input (expandable)
            if (_showRejected) ...[
              const SizedBox(height: TossSpacing.space4),
              RejectedQuantityStepper(
                initialValue: _rejected,
                minValue: 0,
                onChanged: (value) {
                  setState(() {
                    _rejected = value;
                  });
                },
              ),
            ],
            const SizedBox(height: TossSpacing.space6),
            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                // Submit button
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onSubmit(_quantity, _rejected);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.primary,
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Save',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
