/// Quick Amount Input - Reusable amount input component with number formatting
///
/// Purpose: Specialized amount input for quick template transactions with:
/// - Number formatting with thousands separators
/// - Custom numberpad modal integration  
/// - Visual feedback based on input state
/// - Automatic formatting and validation
///
/// Usage: QuickAmountInput(controller: controller, onChanged: callback)
library;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/toss/keyboard/toss_currency_exchange_modal.dart';

class QuickAmountInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;
  final String label;
  final String hint;
  final bool enabled;
  
  const QuickAmountInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.label = 'Amount',
    this.hint = '0',
    this.enabled = true,
  });

  @override
  State<QuickAmountInput> createState() => _QuickAmountInputState();
}

class _QuickAmountInputState extends State<QuickAmountInput> {
  final _numberFormat = NumberFormat('#,###');
  String _previousValue = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatNumber);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatNumber);
    super.dispose();
  }

  void _formatNumber() {
    final text = widget.controller.text;
    if (text == _previousValue) return;
    
    final cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      _previousValue = '';
      widget.onChanged?.call();
      return;
    }
    
    final number = int.tryParse(cleanText);
    if (number == null) return;
    
    final formatted = _numberFormat.format(number);
    widget.controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _previousValue = formatted;
    widget.onChanged?.call();
  }

  Future<void> _showNumberpad() async {
    if (!widget.enabled) return;
    
    await TossCurrencyExchangeModal.show(
      context: context,
      title: 'Enter ${widget.label}',
      initialValue: widget.controller.text.replaceAll(',', ''),
      allowDecimal: false,
      onConfirm: (value) {
        if (value.isNotEmpty) {
          final number = int.tryParse(value);
          if (number != null) {
            widget.controller.text = _numberFormat.format(number);
            widget.onChanged?.call();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.controller.text.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            color: widget.enabled ? TossColors.white : TossColors.gray50,
            border: Border.all(
              color: hasValue 
                ? TossColors.primary
                : TossColors.gray300,
              width: 2,
            ),
            boxShadow: hasValue && widget.enabled ? [
              BoxShadow(
                color: TossColors.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: GestureDetector(
            onTap: _showNumberpad,
            child: AbsorbPointer(
              child: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.none,
                enabled: widget.enabled,
                style: TossTextStyles.h2.copyWith(
                  color: widget.enabled ? TossColors.gray900 : TossColors.gray500,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TossTextStyles.h2.copyWith(
                    color: TossColors.gray300,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: TossSpacing.space5,
                    horizontal: TossSpacing.space4,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final cleanAmount = value.replaceAll(',', '');
                  final amount = int.tryParse(cleanAmount);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount greater than 0';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Get the numeric value from the formatted text
  double? get numericValue {
    final cleanText = widget.controller.text.replaceAll(',', '');
    return double.tryParse(cleanText);
  }
  
  /// Check if the current value is valid
  bool get isValid {
    final value = numericValue;
    return value != null && value > 0;
  }
}