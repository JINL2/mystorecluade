import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Submit confirmation dialog with is_final option
class ReviewSubmitDialog extends StatefulWidget {
  final bool isCounting;
  final void Function(bool isFinal) onSubmit;

  const ReviewSubmitDialog({
    super.key,
    required this.isCounting,
    required this.onSubmit,
  });

  @override
  State<ReviewSubmitDialog> createState() => _ReviewSubmitDialogState();
}

class _ReviewSubmitDialogState extends State<ReviewSubmitDialog> {
  bool _isFinal = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Submit Session?'),
      contentPadding: const EdgeInsets.fromLTRB(TossSpacing.space6, TossSpacing.space4, TossSpacing.space6, 0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to submit this ${widget.isCounting ? 'stock count' : 'receiving'} session? '
            'This action cannot be undone.',
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          if (!widget.isCounting) ...[
            const SizedBox(height: TossSpacing.space4),
            Container(
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: _isFinal ? TossColors.success : TossColors.gray200,
                  width: _isFinal ? 1.5 : 1,
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isFinal = !_isFinal;
                  });
                },
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                child: Padding(
                  padding: const EdgeInsets.all(TossSpacing.space3),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _isFinal,
                          onChanged: (value) {
                            setState(() {
                              _isFinal = value ?? false;
                            });
                          },
                          activeColor: TossColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No more deliveries expected',
                              style: TossTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                color: TossColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Check this only when this is the final delivery for this shipment',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.all(TossSpacing.space4),
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
                text: 'Submit',
                onPressed: () => widget.onSubmit(_isFinal),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
