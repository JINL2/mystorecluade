/// Account Selector Card - Styled container for debit/credit account selection
///
/// Purpose: Provides a visually distinct container for account selection:
/// - Visual distinction between debit (red) and credit (green) accounts
/// - Conditional display of counterparty and cash location selectors
/// - Complex business rule validation and helper text
/// - Integrated account, counterparty, store, and cash location selection
///
/// Usage: AccountSelectorCard(type: AccountType.debit, onAccountChanged: callback)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/widgets/selectors/enhanced_account_selector.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_counterparty_selector.dart';
import 'package:myfinance_improved/shared/widgets/selectors/autonomous_cash_location_selector.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/app/providers/account_provider.dart';
import 'package:myfinance_improved/app/providers/counterparty_provider.dart';
// Updated imports to use new application layer providers
import '../../providers/template_provider.dart';
import '../common/store_selector.dart';

enum AccountType { debit, credit }

class AccountSelectorCard extends ConsumerStatefulWidget {
  final AccountType type;
  final String? selectedAccountId;
  final String? selectedCounterpartyId;
  final Map<String, dynamic>? selectedCounterpartyData;
  final String? selectedStoreId;
  final String? selectedCashLocationId;
  final String? selectedMyCashLocationId;
  final Function(String?) onAccountChanged;
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
    this.selectedCounterpartyId,
    this.selectedCounterpartyData,
    this.selectedStoreId,
    this.selectedCashLocationId,
    this.selectedMyCashLocationId,
    required this.onAccountChanged,
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
  ConsumerState<AccountSelectorCard> createState() => _AccountSelectorCardState();
}

class _AccountSelectorCardState extends ConsumerState<AccountSelectorCard> {
  
  bool get _requiresCounterparty {
    final accountAsync = ref.watch(accountByIdProvider(widget.selectedAccountId ?? ''));
    return accountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'payable' || account?.categoryTag == 'receivable',
      orElse: () => false,
    );
  }
  
  bool get _isCashAccount {
    final accountAsync = ref.watch(accountByIdProvider(widget.selectedAccountId ?? ''));
    return accountAsync.maybeWhen(
      data: (account) => account?.categoryTag == 'cash',
      orElse: () => false,
    );
  }
  
  bool get _showCounterpartyCashLocationWarning {
    return (_requiresCounterparty && widget.otherAccountIsCash) || 
           (_isCashAccount && widget.otherAccountRequiresCounterparty);
  }

  @override
  Widget build(BuildContext context) {
    final isDebit = widget.type == AccountType.debit;
    final badgeColor = isDebit ? TossColors.errorLight : TossColors.successLight;
    final textColor = isDebit ? TossColors.error : TossColors.success;
    final iconData = isDebit ? Icons.remove_circle_outline : Icons.add_circle_outline;
    final label = isDebit ? 'DEBIT' : 'CREDIT';
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
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
                padding: EdgeInsets.symmetric(
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(width: TossSpacing.space2),
              Icon(
                iconData,
                size: 16,
                color: textColor,
              ),
            ],
          ),
          SizedBox(height: TossSpacing.space3),
          
          // Account selector
          EnhancedAccountSelector(
            selectedAccountId: widget.selectedAccountId,
            contextType: 'template',
            showQuickAccess: true,
            maxQuickItems: 5,
            onChanged: (accountId) {
              widget.onAccountChanged(accountId);
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
            SizedBox(height: TossSpacing.space3),
            AutonomousCounterpartySelector(
              selectedCounterpartyId: widget.selectedCounterpartyId,
              onChanged: (counterpartyId) {
                widget.onCounterpartyChanged(counterpartyId);
                widget.onCounterpartyDataChanged(null);
                widget.onStoreChanged(null, null);
                widget.onCashLocationChanged(null);
              },
              label: 'Counterparty',
              hint: 'Select counterparty',
              showSearch: true,
              showTransactionCount: false,
            ),
            
            // Internal counterparty store and cash location
            if (widget.selectedCounterpartyId != null)
              _buildInternalCounterpartySection(),
          ],
          
          // My company's cash location for cash accounts
          if (_isCashAccount && widget.selectedAccountId != null) ...[
            SizedBox(height: TossSpacing.space3),
            AutonomousCashLocationSelector(
              selectedLocationId: widget.selectedMyCashLocationId,
              onChanged: widget.onMyCashLocationChanged,
              onChangedWithName: widget.onMyCashLocationChangedWithName,
              label: 'Cash Location',
              hint: 'Select cash location',
              showSearch: true,
              showTransactionCount: false,
              showScopeTabs: true,
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildInternalCounterpartySection() {
    return Consumer(
      builder: (context, ref, child) {
        // ✅ FIXED: Load counterparty data from provider
        final counterpartyAsync = ref.watch(counterpartyByIdProvider(widget.selectedCounterpartyId!));

        return counterpartyAsync.when(
          data: (counterparty) {
            if (counterparty == null) return SizedBox.shrink();

            // Convert CounterpartyData to Map for compatibility
            final counterpartyData = {
              'name': counterparty.name,  // Add name for Party display in template card
              'is_internal': counterparty.isInternal,
              'linked_company_id': counterparty.additionalData?['linked_company_id'] as String?,
            };

            // ✅ FIXED: Use Future.microtask to avoid setState during build
            // Only update if data actually changed
            if (widget.selectedCounterpartyData?['name'] != counterpartyData['name'] ||
                widget.selectedCounterpartyData?['linked_company_id'] != counterpartyData['linked_company_id'] ||
                widget.selectedCounterpartyData?['is_internal'] != counterpartyData['is_internal']) {
              Future.microtask(() {
                if (mounted) {
                  widget.onCounterpartyDataChanged(counterpartyData);
                }
              });
            }

            if (counterparty.isInternal && counterpartyData['linked_company_id'] != null) {
          return Column(
            children: [
              SizedBox(height: TossSpacing.space3),
              
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
                SizedBox(height: TossSpacing.space3),
                
                // Business rule warning
                if (_showCounterpartyCashLocationWarning) ...[
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    margin: EdgeInsets.only(bottom: TossSpacing.space2),
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
                          size: 16,
                          color: TossColors.warning,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Expanded(
                          child: Text(
                            'Required: Where will the cash be received in the internal company?',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.warning,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Counterparty cash location selector
                AutonomousCashLocationSelector(
                  companyId: counterpartyData['linked_company_id'] as String?,
                  storeId: widget.selectedStoreId,
                  selectedLocationId: widget.selectedCashLocationId,
                  onChanged: widget.onCashLocationChanged,
                  onChangedWithName: widget.onCashLocationChangedWithName,
                  label: 'Counterparty Cash Location',
                  hint: 'Select counterparty cash location',
                  showSearch: true,
                  showTransactionCount: false,
                  showScopeTabs: widget.selectedStoreId != null,
                ),
              ],
            ],
          );
            } else {
              return SizedBox.shrink();
            }
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) {
            return SizedBox.shrink();
          },
        );
      },
    );
  }
}