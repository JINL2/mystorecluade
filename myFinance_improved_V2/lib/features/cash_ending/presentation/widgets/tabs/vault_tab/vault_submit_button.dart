// lib/features/cash_ending/presentation/widgets/tabs/vault_tab/vault_submit_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../providers/cash_ending_state.dart';
import '../../../providers/vault_tab_provider.dart';
import '../../../providers/vault_tab_state.dart';
import 'debit_credit_toggle.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Vault Submit Button Widget
/// Handles submit and recount button based on transaction type
class VaultSubmitButton extends ConsumerWidget {
  final CashEndingState state;
  final List<String> selectedCurrencyIds;
  final VaultTransactionType transactionType;
  final VoidCallback onRecountPressed;
  final Future<void> Function() onSubmitPressed;

  const VaultSubmitButton({
    super.key,
    required this.state,
    required this.selectedCurrencyIds,
    required this.transactionType,
    required this.onRecountPressed,
    required this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabState = ref.watch(vaultTabProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: _buildButton(tabState),
    );
  }

  Widget _buildButton(VaultTabState tabState) {
    if (transactionType == VaultTransactionType.recount) {
      return TossButton.primary(
        text: 'Show Recount Summary',
        isLoading: false,
        isEnabled: true,
        fullWidth: true,
        onPressed: onRecountPressed,
        textStyle: TossTextStyles.titleLarge.copyWith(
          color: TossColors.white,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        borderRadius: 12,
      );
    }

    return TossButton.primary(
      text: 'Submit Ending',
      isLoading: tabState.isSaving,
      isEnabled: !tabState.isSaving,
      fullWidth: true,
      onPressed: !tabState.isSaving ? onSubmitPressed : null,
      textStyle: TossTextStyles.titleLarge.copyWith(
        color: TossColors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      borderRadius: 12,
    );
  }
}
