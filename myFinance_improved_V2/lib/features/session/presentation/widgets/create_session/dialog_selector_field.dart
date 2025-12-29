import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Reusable selector field for dialogs (store, shipment, etc.)
class DialogSelectorField extends StatelessWidget {
  final String? value;
  final String? subtitle;
  final String placeholder;
  final bool isLoading;
  final String loadingText;
  final VoidCallback? onTap;

  const DialogSelectorField({
    super.key,
    this.value,
    this.subtitle,
    required this.placeholder,
    this.isLoading = false,
    this.loadingText = 'Loading...',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: isLoading
                  ? _buildLoadingContent()
                  : _buildContent(),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: TossColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      children: [
        const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          loadingText,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final hasValue = value != null && value!.isNotEmpty;
    final hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    if (!hasValue) {
      return Text(
        placeholder,
        style: TossTextStyles.body.copyWith(
          color: TossColors.textTertiary,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value!,
          style: TossTextStyles.body.copyWith(
            color: TossColors.textPrimary,
          ),
        ),
        if (hasSubtitle) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
