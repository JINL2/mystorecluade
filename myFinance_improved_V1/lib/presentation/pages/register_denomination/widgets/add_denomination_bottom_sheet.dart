import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/toss/toss_primary_button.dart';
import '../../../widgets/toss/toss_secondary_button.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../../../../core/themes/toss_animations.dart';
import '../../../../domain/entities/currency.dart';
import '../../../../domain/entities/denomination.dart';
import '../providers/denomination_providers.dart';
import '../providers/currency_providers.dart';
import '../../../providers/app_state_provider.dart';

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
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: TossColors.gray500,
                    padding: const EdgeInsets.all(8),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                  const SizedBox(height: 8),
                  TextField(
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
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: TossColors.gray200,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: TossColors.primary,
                          width: 1.5,
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
                  const SizedBox(height: 8),
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
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: TossColors.gray200, width: 1),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
                          borderRadius: BorderRadius.circular(12),
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
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: TossColors.error,
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
    
    // Close bottom sheet immediately for better UX
    if (mounted) {
      Navigator.of(context).pop();
      
      // Show immediate success message (optimistic)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$displayValue ${selectedType.name} added successfully!'),
          backgroundColor: TossColors.success,
        ),
      );
    }
    
    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      
      if (companyId.isEmpty) {
        throw Exception('No company selected');
      }
      
      final denominationInput = DenominationInput(
        companyId: companyId,
        currencyId: widget.currency.id,
        value: amount,
        type: selectedType,
      );
      
      // Add denomination (this already has optimistic updates)
      await ref.read(denominationOperationsProvider.notifier)
          .addDenomination(denominationInput);
      
      // Refresh the company currencies to update the count
      ref.invalidate(companyCurrenciesProvider);
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add denomination: $e. Change reverted.'),
            backgroundColor: TossColors.error,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? TossColors.primary : TossColors.gray50,
          borderRadius: BorderRadius.circular(12),
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
              style: const TextStyle(fontSize: 17),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : TossColors.gray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}