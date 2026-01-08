// lib/features/cash_ending/presentation/widgets/tabs/cash_tab/cash_submit_button.dart

import 'package:flutter/material.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../providers/cash_ending_state.dart';
import '../../../providers/cash_tab_state.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Submit Button for Cash Tab
class CashSubmitButton extends StatelessWidget {
  final CashEndingState state;
  final CashTabState tabState;
  final Future<void> Function(BuildContext, CashEndingState, String) onSave;

  const CashSubmitButton({
    super.key,
    required this.state,
    required this.tabState,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // Get selected currency ID safely
    String? selectedCurrencyId;
    if (state.selectedCashCurrencyIds.isNotEmpty) {
      selectedCurrencyId = state.selectedCashCurrencyIds.first;
    } else if (state.currencies.isNotEmpty) {
      selectedCurrencyId = state.currencies.first.currencyId;
    }

    // If no currency available, disable submit button
    if (selectedCurrencyId == null) {
      return TossButton.primary(
        text: 'Submit Ending',
        isLoading: false,
        isEnabled: false,
        fullWidth: true,
        onPressed: null,
        textStyle: TossTextStyles.bodyLarge.copyWith(
          color: TossColors.white,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        borderRadius: 12,
      );
    }

    // At this point selectedCurrencyId is guaranteed to be non-null
    final currencyId = selectedCurrencyId;

    return TossButton.primary(
      text: 'Submit Ending',
      isLoading: tabState.isSaving,
      isEnabled: !tabState.isSaving,
      fullWidth: true,
      onPressed: !tabState.isSaving
          ? () async {
              await onSave(context, state, currencyId);
            }
          : null,
      textStyle: TossTextStyles.bodyLarge.copyWith(
        color: TossColors.white,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      borderRadius: 12,
    );
  }
}
