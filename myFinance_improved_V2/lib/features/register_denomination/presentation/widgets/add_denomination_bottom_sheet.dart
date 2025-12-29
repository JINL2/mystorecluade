import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_success_error_dialog.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_numberpad_modal.dart';

import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../providers/currency_providers.dart';
import '../providers/denomination_providers.dart';
class AddDenominationBottomSheet extends ConsumerStatefulWidget {
  final Currency currency;

  const AddDenominationBottomSheet({
    super.key,
    required this.currency,
  });

  @override
  ConsumerState<AddDenominationBottomSheet> createState() => _AddDenominationBottomSheetState();
}

class _AddDenominationBottomSheetState extends ConsumerState<AddDenominationBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  DenominationType selectedType = DenominationType.bill;
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    // Listen to text changes to trigger rebuild for button state
    _amountController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _amountController.text.isNotEmpty;
    
    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(TossBorderRadius.xs),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(TossSpacing.space5, 0, TossSpacing.space2, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add ${widget.currency.code} Denomination',
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                    color: TossColors.gray500,
                    padding: const EdgeInsets.all(TossSpacing.space2),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(TossSpacing.space5, TossSpacing.space5, TossSpacing.space5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount field
                  Text(
                    'Amount',
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  GestureDetector(
                    onTap: () async {
                      await TossNumberpadModal.show(
                        context: context,
                        title: 'Enter Amount',
                        initialValue: _amountController.text,
                        currency: widget.currency.symbol,
                        allowDecimal: true,
                        maxDecimalPlaces: 2,
                        onConfirm: (value) {
                          _amountController.text = value;
                          setState(() {});
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter amount (e.g., 5.00)',
                          hintStyle: TossTextStyles.body.copyWith(
                            color: TossColors.gray400,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: TossColors.gray50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            borderSide: const BorderSide(
                              color: TossColors.gray200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                            borderSide: const BorderSide(
                              color: TossColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Type selection
                  Text(
                    'Type',
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space2),
                  Row(
                    children: [
                      Expanded(
                        child: _TypeSelectionButton(
                          label: 'Coin',
                          emoji: '🪙',
                          isSelected: selectedType == DenominationType.coin,
                          onTap: () => setState(() => selectedType = DenominationType.coin),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _TypeSelectionButton(
                          label: 'Bill',
                          emoji: '💵',
                          isSelected: selectedType == DenominationType.bill,
                          onTap: () => setState(() => selectedType = DenominationType.bill),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bottom buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                20, 
                24, 
                20, 
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                          side: const BorderSide(color: TossColors.gray200, width: 1),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.button.copyWith(
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                  // Add button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isValid && !isLoading ? _addDenomination : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid ? TossColors.primary : TossColors.gray200,
                        foregroundColor: isValid ? TossColors.white : TossColors.gray400,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(TossColors.white),
                              ),
                            )
                          : Text(
                              'Add Denomination',
                              style: TossTextStyles.button,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addDenomination() async {
    if (_amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Invalid Amount',
          message: 'Please enter a valid amount',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    // Create formatted value for display
    String displayValue;
    if (widget.currency.code == 'KRW') {
      displayValue = '₩${amount.toInt()}';
    } else if (amount < 1.0) {
      displayValue = '${(amount * 100).toInt()}¢';
    } else {
      displayValue = '${widget.currency.symbol}${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
    }

    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;

    if (companyId.isEmpty) {
      await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'Error',
          message: 'No company selected',
          primaryButtonText: 'OK',
        ),
      );
      return;
    }

    final denominationInput = DenominationInput(
      companyId: companyId,
      currencyId: widget.currency.id,
      value: amount,
      type: selectedType,
    );

    try {
      await ref.read(denominationOperationsProvider.notifier)
          .addDenomination(denominationInput);

      // Refresh providers to update UI
      ref.invalidate(companyCurrenciesProvider);
      ref.invalidate(companyCurrenciesStreamProvider);
      ref.invalidate(searchFilteredCurrenciesProvider);
      ref.invalidate(denominationListProvider(widget.currency.id));
      ref.invalidate(effectiveDenominationListProvider(widget.currency.id));

      if (mounted) {
        context.pop();
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.success(
            title: 'Success',
            message: '$displayValue ${selectedType.name} added successfully!',
            primaryButtonText: 'OK',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'Failed to add denomination: $e',
            primaryButtonText: 'OK',
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

class _TypeSelectionButton extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelectionButton({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: TossAnimations.normal,
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: isSelected ? TossColors.primary : TossColors.gray200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TossTextStyles.bodyLarge,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TossTextStyles.button.copyWith(
                color: isSelected ? TossColors.white : TossColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}