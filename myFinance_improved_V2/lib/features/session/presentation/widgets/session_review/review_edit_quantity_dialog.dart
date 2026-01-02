import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import '../../providers/states/session_review_state.dart';

/// Edit quantity dialog for manager override in session review
class ReviewEditQuantityDialog extends StatefulWidget {
  final SessionReviewItem item;
  final int currentQuantity;
  final void Function(int) onSave;

  const ReviewEditQuantityDialog({
    super.key,
    required this.item,
    required this.currentQuantity,
    required this.onSave,
  });

  @override
  State<ReviewEditQuantityDialog> createState() => _ReviewEditQuantityDialogState();
}

class _ReviewEditQuantityDialogState extends State<ReviewEditQuantityDialog> {
  late TextEditingController _controller;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.currentQuantity;
    _controller = TextEditingController(text: _quantity.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _quantity++;
      _controller.text = _quantity.toString();
    });
  }

  void _decrement() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        _controller.text = _quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isChanged = _quantity != widget.item.totalQuantity;

    return AlertDialog(
      title: Text(
        'Edit Count',
        style: TossTextStyles.h4.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info
          Text(
            widget.item.productName,
            style: TossTextStyles.bodyMedium.copyWith(
              color: TossColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.item.sku != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.item.sku!,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
          ],
          const SizedBox(height: TossSpacing.space4),

          // Original count info
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Original Count',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                Text(
                  '${widget.item.totalQuantity}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: TossSpacing.space4),

          // Quantity editor
          Text(
            'New Count',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          Row(
            children: [
              // Decrement button
              IconButton(
                onPressed: _quantity > 0 ? _decrement : null,
                icon: Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: const Icon(Icons.remove, size: 20),
                ),
              ),

              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TossTextStyles.h3.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isChanged ? TossColors.primary : TossColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space2,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color: isChanged ? TossColors.primary : TossColors.gray200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: BorderSide(
                        color: isChanged ? TossColors.primary : TossColors.gray200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: const BorderSide(
                        color: TossColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed >= 0) {
                      setState(() {
                        _quantity = parsed;
                      });
                    }
                  },
                ),
              ),

              // Increment button
              IconButton(
                onPressed: _increment,
                icon: Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: const Icon(Icons.add, size: 20, color: TossColors.primary),
                ),
              ),
            ],
          ),

          // Change indicator
          if (isChanged) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space3,
                vertical: TossSpacing.space2,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: TossColors.primary,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Changed from ${widget.item.totalQuantity} to $_quantity (${_quantity - widget.item.totalQuantity >= 0 ? '+' : ''}${_quantity - widget.item.totalQuantity})',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(TossSpacing.space4, 0, TossSpacing.space4, TossSpacing.space4),
      actions: [
        Row(
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
                onPressed: () => widget.onSave(_quantity),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
