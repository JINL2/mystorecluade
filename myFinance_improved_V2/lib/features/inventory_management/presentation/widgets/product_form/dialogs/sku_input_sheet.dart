import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../pages/barcode_scanner_page.dart';
import 'barcode_input_dialog.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// A bottom sheet for selecting SKU input method
///
/// Provides options to scan barcode, enter manually, or auto-generate.
class SkuInputSheet {
  /// Shows the SKU input options sheet
  ///
  /// [showAutoGenerate] - If true, shows the auto-generate option (for AddProductPage)
  /// [onAutoGenerate] - Callback when auto-generate is selected
  static Future<void> show({
    required BuildContext context,
    String? currentSku,
    required ValueChanged<String> onSkuChanged,
    bool showAutoGenerate = false,
    VoidCallback? onAutoGenerate,
  }) async {
    final skuOptions = [
      const SelectionItem(
        id: 'scan',
        title: 'Scan Barcode',
        icon: Icons.view_week_outlined,
      ),
      const SelectionItem(
        id: 'manual',
        title: 'Enter Manually',
        icon: Icons.keyboard_outlined,
      ),
      if (showAutoGenerate)
        const SelectionItem(
          id: 'auto',
          title: 'Auto-generate',
          icon: Icons.auto_awesome_outlined,
        ),
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.xxl)),
      ),
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.only(top: TossSpacing.space3, bottom: TossSpacing.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: TossDimensions.dragHandleWidth,
              height: TossDimensions.dragHandleHeight,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.dragHandle),
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            // Header with title and close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: TossSpacing.iconMD2), // Spacer for centering
                  Text(
                    'Choose an SKU Option',
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: TossFontWeight.bold,
                      color: TossColors.gray900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(sheetContext),
                    child: const Icon(
                      Icons.close,
                      size: TossSpacing.iconMD2,
                      color: TossColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.paddingXL),
            // Options list
            ...skuOptions.map(
              (option) => InkWell(
                onTap: () {
                  Navigator.pop(sheetContext);
                  _handleOptionSelected(
                    context: context,
                    optionId: option.id,
                    currentSku: currentSku,
                    onSkuChanged: onSkuChanged,
                    onAutoGenerate: onAutoGenerate,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space5,
                    vertical: TossSpacing.space4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        option.icon,
                        size: TossSpacing.iconMD2,
                        color: TossColors.gray600,
                      ),
                      const SizedBox(width: TossSpacing.space4),
                      Expanded(
                        child: Text(
                          option.title,
                          style: TossTextStyles.body.copyWith(
                            fontWeight: TossFontWeight.medium,
                            color: TossColors.gray900,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: TossSpacing.iconMD,
                        color: TossColors.gray400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _handleOptionSelected({
    required BuildContext context,
    required String optionId,
    String? currentSku,
    required ValueChanged<String> onSkuChanged,
    VoidCallback? onAutoGenerate,
  }) async {
    switch (optionId) {
      case 'scan':
        final result = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => const BarcodeScannerPage(),
          ),
        );

        if (result != null && context.mounted) {
          if (result == 'MANUAL_ENTRY') {
            BarcodeInputDialog.show(
              context: context,
              initialValue: currentSku,
              onValueEntered: onSkuChanged,
            );
          } else {
            onSkuChanged(result);
          }
        }
        break;
      case 'manual':
        BarcodeInputDialog.show(
          context: context,
          initialValue: currentSku,
          onValueEntered: onSkuChanged,
        );
        break;
      case 'auto':
        onAutoGenerate?.call();
        break;
    }
  }
}
