import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../providers/invoice_creation_provider.dart';

/// Bottom button widget for create invoice page
class InvoiceBottomButton extends ConsumerWidget {
  final VoidCallback onPressed;

  const InvoiceBottomButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceCreationProvider);
    final hasSelectedItems = state.selectedProducts.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.gray300.withValues(alpha: 0.3),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: hasSelectedItems ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              hasSelectedItems ? TossColors.primary : TossColors.gray300,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          'Next',
          style: TossTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: TossColors.white,
          ),
        ),
      ),
    );
  }
}
