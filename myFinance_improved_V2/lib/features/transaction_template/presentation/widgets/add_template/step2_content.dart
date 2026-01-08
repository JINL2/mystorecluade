/// Step 2 Content Widget - Account selection step for template creation
///
/// Purpose: Displays the account selection step (debit/credit accounts)
/// with counterparty and cash location selectors as needed
///
/// Clean Architecture: PRESENTATION LAYER - Widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/index.dart';

import '../wizard/account_selector_card.dart';
import 'account_mapping_status.dart';

/// Step 2 content for account selection
class Step2Content extends ConsumerWidget {
  final String? selectedDebitAccountId;
  final String? selectedDebitAccountCategoryTag;
  final String? selectedDebitCounterpartyId;
  final Map<String, dynamic>? selectedDebitCounterpartyData;
  final String? selectedDebitStoreId;
  final String? selectedDebitCashLocationId;
  final String? selectedDebitMyCashLocationId;

  final String? selectedCreditAccountId;
  final String? selectedCreditAccountCategoryTag;
  final String? selectedCreditCounterpartyId;
  final Map<String, dynamic>? selectedCreditCounterpartyData;
  final String? selectedCreditStoreId;
  final String? selectedCreditCashLocationId;
  final String? selectedCreditMyCashLocationId;

  final bool debitIsCashAccount;
  final bool creditIsCashAccount;
  final bool debitRequiresCounterparty;
  final bool creditRequiresCounterparty;

  // Account mapping validation state
  final bool isCheckingDebitMapping;
  final bool isCheckingCreditMapping;
  final String? debitMappingError;
  final String? creditMappingError;
  final Map<String, dynamic>? debitAccountMapping;
  final Map<String, dynamic>? creditAccountMapping;

  // Callbacks for debit account
  final ValueChanged<String?> onDebitAccountChanged;
  final void Function(String?, String?, String?) onDebitAccountChangedWithData;
  final ValueChanged<String?> onDebitCounterpartyChanged;
  final void Function(String?, String?) onDebitStoreChanged;
  final ValueChanged<String?> onDebitCashLocationChanged;
  final void Function(String?, String?) onDebitCashLocationChangedWithName;
  final ValueChanged<String?> onDebitMyCashLocationChanged;
  final void Function(String?, String?) onDebitMyCashLocationChangedWithName;
  final ValueChanged<Map<String, dynamic>?> onDebitCounterpartyDataChanged;

  // Callbacks for credit account
  final ValueChanged<String?> onCreditAccountChanged;
  final void Function(String?, String?, String?) onCreditAccountChangedWithData;
  final ValueChanged<String?> onCreditCounterpartyChanged;
  final void Function(String?, String?) onCreditStoreChanged;
  final ValueChanged<String?> onCreditCashLocationChanged;
  final void Function(String?, String?) onCreditCashLocationChangedWithName;
  final ValueChanged<String?> onCreditMyCashLocationChanged;
  final void Function(String?, String?) onCreditMyCashLocationChangedWithName;
  final ValueChanged<Map<String, dynamic>?> onCreditCounterpartyDataChanged;

  // Navigation callback for account settings
  final void Function(String counterpartyId, String counterpartyName)? onNavigateToSettings;

  const Step2Content({
    super.key,
    this.selectedDebitAccountId,
    this.selectedDebitAccountCategoryTag,
    this.selectedDebitCounterpartyId,
    this.selectedDebitCounterpartyData,
    this.selectedDebitStoreId,
    this.selectedDebitCashLocationId,
    this.selectedDebitMyCashLocationId,
    this.selectedCreditAccountId,
    this.selectedCreditAccountCategoryTag,
    this.selectedCreditCounterpartyId,
    this.selectedCreditCounterpartyData,
    this.selectedCreditStoreId,
    this.selectedCreditCashLocationId,
    this.selectedCreditMyCashLocationId,
    this.debitIsCashAccount = false,
    this.creditIsCashAccount = false,
    this.debitRequiresCounterparty = false,
    this.creditRequiresCounterparty = false,
    this.isCheckingDebitMapping = false,
    this.isCheckingCreditMapping = false,
    this.debitMappingError,
    this.creditMappingError,
    this.debitAccountMapping,
    this.creditAccountMapping,
    required this.onDebitAccountChanged,
    required this.onDebitAccountChangedWithData,
    required this.onDebitCounterpartyChanged,
    required this.onDebitStoreChanged,
    required this.onDebitCashLocationChanged,
    required this.onDebitCashLocationChangedWithName,
    required this.onDebitMyCashLocationChanged,
    required this.onDebitMyCashLocationChangedWithName,
    required this.onDebitCounterpartyDataChanged,
    required this.onCreditAccountChanged,
    required this.onCreditAccountChangedWithData,
    required this.onCreditCounterpartyChanged,
    required this.onCreditStoreChanged,
    required this.onCreditCashLocationChanged,
    required this.onCreditCashLocationChangedWithName,
    required this.onCreditMyCashLocationChanged,
    required this.onCreditMyCashLocationChangedWithName,
    required this.onCreditCounterpartyDataChanged,
    this.onNavigateToSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2: Transaction Details',
            style: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.gray600,
              fontWeight: TossFontWeight.medium,
            ),
          ),
          const SizedBox(height: TossSpacing.space5),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Debit Account Card
                  AccountSelectorCard(
                    type: AccountType.debit,
                    selectedAccountId: selectedDebitAccountId,
                    selectedAccountCategoryTag: selectedDebitAccountCategoryTag,
                    selectedCounterpartyId: selectedDebitCounterpartyId,
                    selectedCounterpartyData: selectedDebitCounterpartyData,
                    selectedStoreId: selectedDebitStoreId,
                    selectedCashLocationId: selectedDebitCashLocationId,
                    selectedMyCashLocationId: selectedDebitMyCashLocationId,
                    otherAccountIsCash: creditIsCashAccount,
                    otherAccountRequiresCounterparty: creditRequiresCounterparty,
                    onAccountChanged: onDebitAccountChanged,
                    onAccountChangedWithData: onDebitAccountChangedWithData,
                    onCounterpartyChanged: onDebitCounterpartyChanged,
                    onStoreChanged: onDebitStoreChanged,
                    onCashLocationChanged: onDebitCashLocationChanged,
                    onCashLocationChangedWithName: onDebitCashLocationChangedWithName,
                    onMyCashLocationChanged: onDebitMyCashLocationChanged,
                    onMyCashLocationChangedWithName: onDebitMyCashLocationChangedWithName,
                    onCounterpartyDataChanged: onDebitCounterpartyDataChanged,
                  ),

                  const SizedBox(height: TossSpacing.space4),

                  // Credit Account Card
                  AccountSelectorCard(
                    type: AccountType.credit,
                    selectedAccountId: selectedCreditAccountId,
                    selectedAccountCategoryTag: selectedCreditAccountCategoryTag,
                    selectedCounterpartyId: selectedCreditCounterpartyId,
                    selectedCounterpartyData: selectedCreditCounterpartyData,
                    selectedStoreId: selectedCreditStoreId,
                    selectedCashLocationId: selectedCreditCashLocationId,
                    selectedMyCashLocationId: selectedCreditMyCashLocationId,
                    otherAccountIsCash: debitIsCashAccount,
                    otherAccountRequiresCounterparty: debitRequiresCounterparty,
                    onAccountChanged: onCreditAccountChanged,
                    onAccountChangedWithData: onCreditAccountChangedWithData,
                    onCounterpartyChanged: onCreditCounterpartyChanged,
                    onStoreChanged: onCreditStoreChanged,
                    onCashLocationChanged: onCreditCashLocationChanged,
                    onCashLocationChangedWithName: onCreditCashLocationChangedWithName,
                    onMyCashLocationChanged: onCreditMyCashLocationChanged,
                    onMyCashLocationChangedWithName: onCreditMyCashLocationChangedWithName,
                    onCounterpartyDataChanged: onCreditCounterpartyDataChanged,
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Account mapping warnings
                  AccountMappingWarnings(
                    isCheckingDebitMapping: isCheckingDebitMapping,
                    isCheckingCreditMapping: isCheckingCreditMapping,
                    debitMappingError: debitMappingError,
                    creditMappingError: creditMappingError,
                    debitAccountMapping: debitAccountMapping,
                    creditAccountMapping: creditAccountMapping,
                    debitCounterpartyId: selectedDebitCounterpartyId,
                    creditCounterpartyId: selectedCreditCounterpartyId,
                    debitCounterpartyData: selectedDebitCounterpartyData,
                    creditCounterpartyData: selectedCreditCounterpartyData,
                    onNavigateToSettings: onNavigateToSettings,
                  ),

                  const SizedBox(height: TossSpacing.space3),

                  // Helpful explanation
                  _buildHelpfulExplanation(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpfulExplanation() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: TossSpacing.iconSM2,
            color: TossColors.gray600,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              'Debit increases assets/expenses, decreases liabilities/income.\nCredit increases liabilities/income, decreases assets/expenses.',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
