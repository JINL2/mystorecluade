import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../widgets/toss/toss_primary_button.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/constants/ui_constants.dart';

/// Result dialogs for Cash Ending page
/// FROM PRODUCTION LINES 2991-3098, 4042-4144
class ResultDialogs {
  
  /// Show bank balance result dialog
  /// FROM PRODUCTION LINES 2991-3098
  static void showBankBalanceResultDialog({
    required BuildContext context,
    required bool isSuccess,
    String? amount,
    String? errorMessage,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allow dismissing loading dialogs
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space6),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72, // Custom size for transaction result
                  height: 72,
                  decoration: BoxDecoration(
                    color: isSuccess 
                        ? TossColors.success.withOpacity(0.1)
                        : TossColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? TossIcons.checkCircle : TossIcons.error,
                    color: isSuccess ? TossColors.success : TossColors.error,
                    size: UIConstants.avatarSizeSmall,
                  ),
                ),
                const SizedBox(height: TossSpacing.space5),
                
                // Title
                Text(
                  isSuccess ? 'Success!' : 'Failed',
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: TossSpacing.space3),
                
                // Message
                Text(
                  isSuccess 
                      ? 'Bank balance saved'
                      : errorMessage ?? 'Failed to save bank balance',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                // Amount (for success only)
                if (isSuccess && amount != null) ...[
                  const SizedBox(height: TossSpacing.space3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Text(
                      amount,
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w700,
                        fontFamily: TossTextStyles.fontFamilyMono,
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: TossSpacing.space6),
                
                // Button
                SizedBox(
                  width: double.infinity,
                  child: TossPrimaryButton(
                    text: isSuccess ? 'Done' : 'Try Again',
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (!isSuccess) {
                        // Keep the form data for retry
                        HapticFeedback.lightImpact();
                      }
                    },
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Show success dialog for cash ending save
  /// FROM PRODUCTION LINES 4042-4144
  static void showSuccessBottomSheet({
    required BuildContext context,
    required double savedTotal,
    required TabController tabController,
    required List<Map<String, dynamic>> companyCurrencies,
    required String? selectedBankCurrencyType,
    required String? selectedVaultCurrencyId,
    required Map<String, dynamic> Function() getBaseCurrency,
    required Function(String) currencyHasData,
  }) {
    // For cash tab with multiple currencies, show a generic success message
    String displayMessage = '';
    
    if (tabController.index == 0) {
      // Cash tab - show count of currencies saved
      int currencyCount = 0;
      for (var currency in companyCurrencies) {
        final currencyId = currency['currency_id']?.toString();
        if (currencyId != null && currencyHasData(currencyId)) {
          currencyCount++;
        }
      }
      displayMessage = currencyCount > 1 
          ? 'Saved cash ending for $currencyCount currencies' 
          : 'Cash ending saved successfully';
    } else {
      // For bank and vault tabs, show the currency symbol
      final baseCurrency = getBaseCurrency();
      String currencySymbol = baseCurrency['symbol'] ?? '';
      if (tabController.index == 1 && selectedBankCurrencyType != null) {
        final currency = companyCurrencies.firstWhere(
          (c) => c['currency_id'].toString() == selectedBankCurrencyType,
          orElse: () => baseCurrency,
        );
        currencySymbol = currency['symbol'] ?? baseCurrency['symbol'] ?? '';
      } else if (tabController.index == 2 && selectedVaultCurrencyId != null) {
        final currency = companyCurrencies.firstWhere(
          (c) => c['currency_id'].toString() == selectedVaultCurrencyId,
          orElse: () => baseCurrency,
        );
        currencySymbol = currency['symbol'] ?? baseCurrency['symbol'] ?? '';
      }
      displayMessage = NumberFormat.currency(
        symbol: currencySymbol,
        decimalDigits: 0,
      ).format(savedTotal);
    }
    
    // Show dialog in center of screen instead of bottom sheet
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
        ),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space6),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.xxl),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: UIConstants.iconSizeHuge + 16, // 64px for success state
                height: UIConstants.iconSizeHuge + 16,
                decoration: BoxDecoration(
                  color: TossColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  TossIcons.check,
                  color: TossColors.success,
                  size: UIConstants.iconSizeXL,
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Cash Ending Saved',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                displayMessage,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              const SizedBox(height: TossSpacing.space6),
              SizedBox(
                width: double.infinity,
                child: TossPrimaryButton(
                  text: 'Done',
                  onPressed: () {
                    Navigator.pop(context);
                    // Form is already cleared in the save process
                  },
                  isLoading: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}