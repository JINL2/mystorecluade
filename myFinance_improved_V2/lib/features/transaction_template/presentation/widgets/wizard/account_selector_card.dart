/// Account Selector Card - Styled container for debit/credit account selection
///
/// Purpose: Provides a visually distinct container for account selection:
/// - Visual distinction between debit (red) and credit (green) accounts
/// - Conditional display of counterparty and cash location selectors
/// - Complex business rule validation and helper text
/// - Integrated account, counterparty, store, and cash location selection
///
/// Usage: AccountSelectorCard(type: AccountType.debit, onAccountChanged: callback)
library;

import 'package:myfinance_improved/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
// Autonomous Selectors

import '../common/store_selector.dart';

enum AccountType { debit, credit }

class AccountSelectorCard extends ConsumerStatefulWidget {
  final AccountType type;
  final String? selectedAccountId;
  final String? selectedAccountCategoryTag;
  final String? selectedCounterpartyId;
  final Map<String, dynamic>? selectedCounterpartyData;
  final String? selectedStoreId;
  final String? selectedCashLocationId;
  final String? selectedMyCashLocationId;
  final Function(String?) onAccountChanged;
  final Function(String?, String?, String?) onAccountChangedWithData;
  final Function(String?) onCounterpartyChanged;
  final Function(String?, String?) onStoreChanged;
  final Function(String?) onCashLocationChanged;
  final Function(String?, String?) onCashLocationChangedWithName;
  final Function(String?) onMyCashLocationChanged;
  final Function(String?, String?) onMyCashLocationChangedWithName;
  final Function(Map<String, dynamic>?) onCounterpartyDataChanged;
  final bool otherAccountIsCash;
  final bool otherAccountRequiresCounterparty;

  const AccountSelectorCard({
    super.key,
    required this.type,
    this.selectedAccountId,
    this.selectedAccountCategoryTag,
    this.selectedCounterpartyId,
    this.selectedCounterpartyData,
    this.selectedStoreId,
    this.selectedCashLocationId,
    this.selectedMyCashLocationId,
    required this.onAccountChanged,
    required this.onAccountChangedWithData,
    required this.onCounterpartyChanged,
    required this.onStoreChanged,
    required this.onCashLocationChanged,
    required this.onCashLocationChangedWithName,
    required this.onMyCashLocationChanged,
    required this.onMyCashLocationChangedWithName,
    required this.onCounterpartyDataChanged,
    this.otherAccountIsCash = false,
    this.otherAccountRequiresCounterparty = false,
  });

  @override
  ConsumerState<AccountSelectorCard> createState() =>
      _AccountSelectorCardState();
}

class _AccountSelectorCardState extends ConsumerState<AccountSelectorCard> {
  bool get _requiresCounterparty {
    final categoryTag = widget.selectedAccountCategoryTag?.toLowerCase();
    return categoryTag == 'payable' || categoryTag == 'receivable';
  }

  bool get _isCashAccount {
    final categoryTag = widget.selectedAccountCategoryTag?.toLowerCase();
    return categoryTag == 'cash';
  }

  bool get _showCounterpartyCashLocationWarning {
    return (_requiresCounterparty && widget.otherAccountIsCash) ||
        (_isCashAccount && widget.otherAccountRequiresCounterparty);
  }

  @override
  Widget build(BuildContext context) {
    final isDebit = widget.type == AccountType.debit;
    final badgeColor =
        isDebit ? TossColors.errorLight : TossColors.successLight;
    final textColor = isDebit ? TossColors.error : TossColors.success;
    final iconData =
        isDebit ? Icons.remove_circle_outline : Icons.add_circle_outline;
    final label = isDebit ? 'DEBIT' : 'CREDIT';

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account type badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space2,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Text(
                  label,
                  style: TossTextStyles.caption.copyWith(
                    color: textColor,
                    fontWeight: TossFontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              Icon(
                iconData,
                size: TossSpacing.iconSM2,
                color: textColor,
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Account selector - EnhancedAccountSelector
          EnhancedAccountSelector(
            selectedAccountId: widget.selectedAccountId,
            contextType: 'template',
            showQuickAccess: true,
            maxQuickItems: 5,
            onAccountSelected: (account) {
              widget.onAccountChanged(account.id);
              widget.onAccountChangedWithData(account.id, account.name, account.categoryTag);

              // Reset dependent selections when account changes
              widget.onCounterpartyChanged(null);
              widget.onCounterpartyDataChanged(null);
              widget.onMyCashLocationChanged(null);
              widget.onStoreChanged(null, null);
              widget.onCashLocationChanged(null);
            },
            label: '${isDebit ? 'Debit' : 'Credit'} Account',
            hint: 'Select account to ${isDebit ? 'debit' : 'credit'}',
            showTransactionCount: false,
          ),

          // Counterparty section
          if (_requiresCounterparty && widget.selectedAccountId != null) ...[
            const SizedBox(height: TossSpacing.space3),
            AutonomousCounterpartySelector(
              selectedCounterpartyId: widget.selectedCounterpartyId,
              label: 'Counterparty',
              hint: 'Select counterparty',
              onCounterpartySelected: (counterparty) {
                widget.onCounterpartyChanged(counterparty.id);
                widget.onCounterpartyDataChanged({
                  'name': counterparty.name,
                  'is_internal': counterparty.isInternal,
                  'linked_company_id': counterparty.linkedCompanyId,
                });
                // Reset dependent selections
                widget.onStoreChanged(null, null);
                widget.onCashLocationChanged(null);
              },
              onChanged: (counterpartyId) {
                if (counterpartyId == null) {
                  widget.onCounterpartyChanged(null);
                  widget.onCounterpartyDataChanged(null);
                  widget.onStoreChanged(null, null);
                  widget.onCashLocationChanged(null);
                }
              },
            ),

            // Internal counterparty store and cash location
            if (widget.selectedCounterpartyId != null)
              _buildInternalCounterpartySection(),
          ],

          // My company's cash location for cash accounts
          if (_isCashAccount && widget.selectedAccountId != null) ...[
            const SizedBox(height: TossSpacing.space3),
            AutonomousCashLocationSelector(
              selectedLocationId: widget.selectedMyCashLocationId,
              label: 'Cash Location',
              hint: 'Select cash location',
              onCashLocationSelected: (cashLocation) {
                widget.onMyCashLocationChanged(cashLocation.id);
                widget.onMyCashLocationChangedWithName(cashLocation.id, cashLocation.name);
              },
              onChanged: (locationId) {
                if (locationId == null) {
                  widget.onMyCashLocationChanged(null);
                  widget.onMyCashLocationChangedWithName(null, null);
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInternalCounterpartySection() {
    if (widget.selectedCounterpartyData == null) {
      return const SizedBox.shrink();
    }

    final counterpartyData = widget.selectedCounterpartyData!;
    final isInternal = counterpartyData['is_internal'] as bool? ?? false;
    final linkedCompanyId = counterpartyData['linked_company_id'] as String?;

    if (isInternal && linkedCompanyId != null) {
      return Column(
        children: [
          const SizedBox(height: TossSpacing.space3),

          // Store selector
          StoreSelector(
            linkedCompanyId: counterpartyData['linked_company_id'] as String?,
            selectedStoreId: widget.selectedStoreId,
            onChanged: (storeId, storeName) {
              widget.onStoreChanged(storeId, storeName);
              widget.onCashLocationChanged(null);
            },
            label: 'Counterparty Store',
            hint: 'Select store',
          ),

          // Cash location selector with business rule warning
          if (widget.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space3),

            // Business rule warning
            if (_showCounterpartyCashLocationWarning) ...[
              Container(
                padding: const EdgeInsets.all(TossSpacing.space2),
                margin: const EdgeInsets.only(bottom: TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.warningLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  border: Border.all(
                    color: TossColors.warning.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: TossSpacing.iconSM2,
                      color: TossColors.warning,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Expanded(
                      child: Text(
                        'Required: Where will the cash be received in the internal company?',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.warning,
                          fontWeight: TossFontWeight.medium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Counterparty cash location selector - AutonomousCashLocationSelector
            AutonomousCashLocationSelector(
              companyId: linkedCompanyId,
              storeId: widget.selectedStoreId,
              selectedLocationId: widget.selectedCashLocationId,
              label: 'Counterparty Cash Location',
              hint: 'Select counterparty cash location',
              showScopeTabs: false,
              storeOnly: true,
              onCashLocationSelected: (cashLocation) {
                widget.onCashLocationChanged(cashLocation.id);
                widget.onCashLocationChangedWithName(cashLocation.id, cashLocation.name);
              },
              onChanged: (locationId) {
                if (locationId == null) {
                  widget.onCashLocationChanged(null);
                  widget.onCashLocationChangedWithName(null, null);
                }
              },
            ),
          ],
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
