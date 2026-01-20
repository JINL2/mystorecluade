import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../providers/states/session_detail_state.dart';

/// Dialog for confirming save action with item preview
class SaveConfirmDialog extends StatelessWidget {
  final List<SelectedProduct> selectedProducts;
  final int totalSelectedCount;
  final Color typeColor;
  final VoidCallback onConfirm;

  const SaveConfirmDialog({
    super.key,
    required this.selectedProducts,
    required this.totalSelectedCount,
    required this.typeColor,
    required this.onConfirm,
  });

  /// Show the dialog
  static Future<void> show({
    required BuildContext context,
    required List<SelectedProduct> selectedProducts,
    required int totalSelectedCount,
    required Color typeColor,
    required VoidCallback onConfirm,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => SaveConfirmDialog(
        selectedProducts: selectedProducts,
        totalSelectedCount: totalSelectedCount,
        typeColor: typeColor,
        onConfirm: () {
          Navigator.pop(dialogContext);
          onConfirm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Items?'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The following $totalSelectedCount item(s) will be saved:',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            _buildItemList(),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        TossSpacing.space4,
        0,
        TossSpacing.space4,
        TossSpacing.space4,
      ),
      actions: [_buildActions(context)],
    );
  }

  Widget _buildItemList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: selectedProducts.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final item = selectedProducts[index];
          return _buildItemRow(item);
        },
      ),
    );
  }

  Widget _buildItemRow(SelectedProduct item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: TossTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${item.quantity}',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: TossFontWeight.semibold,
              color: TossColors.primary,
            ),
          ),
          if (item.quantityRejected > 0) ...[
            const SizedBox(width: TossSpacing.space1),
            Text(
              '(${item.quantityRejected})',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: TossFontWeight.semibold,
                color: TossColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TossButton.outlinedGray(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: TossSpacing.space3),
        Expanded(
          child: TossButton.primary(
            text: 'Save',
            onPressed: onConfirm,
            backgroundColor: typeColor,
          ),
        ),
      ],
    );
  }
}
