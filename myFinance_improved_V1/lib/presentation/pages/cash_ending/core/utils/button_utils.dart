import 'package:flutter/material.dart';
import '../../../../../core/themes/toss_colors.dart';
import '../../../../widgets/toss/toss_primary_button.dart';
import '../../presentation/widgets/common/toggle_buttons.dart';

/// Button utility functions for Cash Ending page
/// FROM PRODUCTION LINES 936-957, 2021-2053
class ButtonUtils {
  
  /// Build debit/credit toggle for vault transactions
  /// FROM PRODUCTION LINES 936-957
  static Widget buildDebitCreditToggle({
    required String? vaultTransactionType,
    required Function(String?) onPressed,
  }) {
    return TossToggleButtonGroup(
      buttons: [
        TossToggleButtonData(
          label: 'In',
          value: 'debit',
          activeColor: TossColors.primary,
        ),
        TossToggleButtonData(
          label: 'Out',
          value: 'credit',
          activeColor: TossColors.success,
        ),
      ],
      selectedValue: vaultTransactionType,
      onPressed: (value) {
        onPressed(value);
      },
    );
  }

  /// Build submit button with tab-specific logic
  /// FROM PRODUCTION LINES 2021-2053
  static Widget buildSubmitButton({
    required TabController tabController,
    required String? vaultTransactionType,
    required Function({required String tabType}) calculateTotalAmount,
    required Future<void> Function() saveVaultBalance,
    required Future<void> Function() saveCashEnding,
  }) {
    // Determine button text and calculate total based on current tab
    String buttonText = 'Save Cash Ending';
    bool canSubmit = false;
    
    if (tabController.index == 0) {
      // Cash tab
      canSubmit = calculateTotalAmount(tabType: 'cash') > 0;
    } else if (tabController.index == 1) {
      // Bank tab  
      canSubmit = calculateTotalAmount(tabType: 'bank') > 0;
    } else if (tabController.index == 2) {
      // Vault tab
      buttonText = 'Save Vault Balance';
      canSubmit = calculateTotalAmount(tabType: 'vault') > 0 && vaultTransactionType != null;
    }
    
    return Center(
      child: TossPrimaryButton(
        text: buttonText,
        onPressed: canSubmit ? () async {
          if (tabController.index == 2) {
            // For vault tab, use the vault-specific save function
            await saveVaultBalance();
          } else {
            // For cash and bank tabs, use the existing save function
            await saveCashEnding();
          }
        } : null,
        isLoading: false,
      ),
    );
  }
}