import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/constants/ui_constants.dart';
import '../../../../../../../core/themes/toss_border_radius.dart';
import '../../../../../../../core/themes/toss_colors.dart';
import '../../../../../../../core/themes/toss_icons.dart';
import '../../../../../../../core/themes/toss_spacing.dart';
import '../../../../../../../core/themes/toss_text_styles.dart';
import '../../../../../widgets/toss/toss_card.dart';
import '../../../../../widgets/toss/toss_primary_button.dart';
import 'animated_tab_mixin.dart';

/// Bank tab component for Cash Ending page with automatic UI transitions
/// Enhanced with smooth animations when bank location is selected
class BankTab extends StatefulWidget {
  final String? selectedStoreId;
  final String? selectedBankLocationId;
  final String? selectedBankCurrencyType;
  final TextEditingController bankAmountController;
  final Widget Function() buildStoreSelector;
  final Widget Function(String) buildLocationSelector;
  final Widget Function({bool showSection}) buildRealJournalSection;
  final Future<void> Function() saveBankBalance;
  final VoidCallback onStateChange;

  const BankTab({
    super.key,
    required this.selectedStoreId,
    required this.selectedBankLocationId,
    required this.selectedBankCurrencyType,
    required this.bankAmountController,
    required this.buildStoreSelector,
    required this.buildLocationSelector,
    required this.buildRealJournalSection,
    required this.saveBankBalance,
    required this.onStateChange,
  });

  @override
  State<BankTab> createState() => _BankTabState();
}

class _BankTabState extends State<BankTab>
    with TickerProviderStateMixin, AnimatedTabMixin {
  
  @override
  void initState() {
    super.initState();
    // Initialize animations from mixin
    initializeAnimations();
  }
  
  @override
  void didUpdateWidget(BankTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check for bank location selection changes
    checkLocationChange(oldWidget.selectedBankLocationId, widget.selectedBankLocationId);
  }
  
  @override
  void dispose() {
    // Dispose animations from mixin
    disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController, // Use animated scroll controller from mixin
      padding: const EdgeInsets.all(TossSpacing.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build the location selection card
          _buildLocationSelectionCard(),
          
          // Build the animated bank balance input card (conditional)
          if (widget.selectedBankLocationId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            wrapWithFullAnimation(_buildBankBalanceCard()),
          ],
          
          // Build the animated transaction history section (conditional)
          if (widget.selectedBankLocationId != null && widget.selectedBankLocationId!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space5),
            buildDelayedAnimation(
              child: _buildTransactionHistorySection(),
              delay: const Duration(milliseconds: 300),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the first card containing store and bank location selection
  Widget _buildLocationSelectionCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store selector
          widget.buildStoreSelector(),
          
          // Bank location selector (conditional on store selection)
          if (widget.selectedStoreId != null) ...[
            const SizedBox(height: TossSpacing.space6),
            widget.buildLocationSelector('bank'),
          ],
        ],
      ),
    );
  }

  /// Builds the second card containing bank balance input
  Widget _buildBankBalanceCard() {
    return TossCard(
      padding: const EdgeInsets.all(TossSpacing.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bank balance input field
          _buildBankAmountInput(),
          
          const SizedBox(height: TossSpacing.space6),
          
          // Save button
          _buildBankSaveButton(),
        ],
      ),
    );
  }

  /// Builds the transaction history section
  Widget _buildTransactionHistorySection() {
    return widget.buildRealJournalSection(
      showSection: true,
    );
  }

  /// Builds the bank balance amount input field with proper styling
  Widget _buildBankAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              TossIcons.bank,
              size: UIConstants.iconSizeMedium,
              color: TossColors.primary,
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              'Bank Balance',
              style: TossTextStyles.bodyLarge.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: TossSpacing.space3),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            border: Border.all(
              color: widget.bankAmountController.text.isNotEmpty 
                  ? TossColors.primary.withValues(alpha: 0.3) 
                  : TossColors.gray200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: TossColors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            child: TextField(
              controller: widget.bankAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Auto-format with commas
                  if (newValue.text.isEmpty) return newValue;
                  final number = int.tryParse(newValue.text.replaceAll(',', ''));
                  if (number == null) return oldValue;
                  final formatted = NumberFormat('#,###').format(number);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }),
              ],
              textAlign: TextAlign.center,
              style: TossTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray400,
                  fontWeight: FontWeight.w600,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space4,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: TossColors.white,
                filled: true,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Text(
          'Enter the current bank balance amount',
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  /// Builds the save button with validation logic
  Widget _buildBankSaveButton() {
    // Enable button only when both amount is entered AND currency is selected
    final hasAmount = widget.bankAmountController.text.isNotEmpty;
    final hasCurrency = widget.selectedBankCurrencyType != null;
    final isEnabled = hasAmount && hasCurrency;
    
    return Center(
      child: TossPrimaryButton(
        text: 'Save Bank Balance',
        onPressed: isEnabled ? widget.saveBankBalance : null,
        isLoading: false,
      ),
    );
  }

  /// Triggers state change in parent widget
  @override
  void setState(VoidCallback callback) {
    callback();
    widget.onStateChange();
  }
}