/// Toss Amount Keypad
///
/// A reusable amount input keypad widget with optional exchange rate calculator button.
/// Provides a minimal gray-toned design with number pad for easy mobile input.
///
/// ## Basic Usage
/// ```dart
/// TossAmountKeypad(
///   initialAmount: 0,
///   currencySymbol: '₩',
///   onAmountChanged: (amount) => setState(() => _amount = amount),
/// )
/// ```
///
/// ## With Exchange Rate Calculator
/// ```dart
/// TossAmountKeypad(
///   initialAmount: _amount,
///   currencySymbol: currencySymbol,
///   onAmountChanged: _onAmountChanged,
///   onExchangeRateTap: _hasMultipleCurrencies
///     ? () => ExchangeRateCalculator.show(
///         context: context,
///         onAmountSelected: (amount) {
///           final value = double.tryParse(amount) ?? 0;
///           _onAmountChanged(value);
///         },
///       )
///     : null,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Amount Input Keypad with optional exchange rate calculator
/// Minimal design - gray tones, no colored borders
class TossAmountKeypad extends StatefulWidget {
  final double initialAmount;
  final String currencySymbol;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback? onSubmit;
  final bool showSubmitButton;
  final String submitButtonText;

  /// Optional callback for exchange rate calculator button
  /// When provided (not null), shows a calculator button next to the amount display
  /// When null, the calculator button is hidden
  final VoidCallback? onExchangeRateTap;

  const TossAmountKeypad({
    super.key,
    this.initialAmount = 0,
    this.currencySymbol = '₩',
    required this.onAmountChanged,
    this.onSubmit,
    this.showSubmitButton = true,
    this.submitButtonText = 'Confirm',
    this.onExchangeRateTap,
  });

  @override
  State<TossAmountKeypad> createState() => TossAmountKeypadState();
}

class TossAmountKeypadState extends State<TossAmountKeypad> {
  late String _amountString;
  final _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _amountString = widget.initialAmount > 0
        ? widget.initialAmount.toInt().toString()
        : '';
  }

  double get _currentAmount {
    if (_amountString.isEmpty) return 0;
    return double.tryParse(_amountString) ?? 0;
  }

  String get _formattedAmount {
    if (_amountString.isEmpty) return '0';
    final amount = int.tryParse(_amountString) ?? 0;
    return _formatter.format(amount);
  }

  /// Set amount externally (e.g., from exchange rate calculator result)
  void setAmount(double amount) {
    setState(() {
      _amountString = amount > 0 ? amount.toInt().toString() : '';
    });
    widget.onAmountChanged(_currentAmount);
  }

  void _onKeyPressed(String key) {
    HapticFeedback.lightImpact();

    setState(() {
      if (key == 'backspace') {
        if (_amountString.isNotEmpty) {
          _amountString = _amountString.substring(0, _amountString.length - 1);
        }
      } else if (key == '000') {
        if (_amountString.isNotEmpty && _amountString.length <= 12) {
          _amountString += '000';
        }
      } else {
        // Prevent leading zeros and limit length
        if (_amountString.isEmpty && key == '0') {
          return;
        }
        if (_amountString.length < 15) {
          _amountString += key;
        }
      }
    });

    widget.onAmountChanged(_currentAmount);
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _amountString = '';
    });
    widget.onAmountChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Amount display with optional calculator button
        _buildAmountDisplay(),

        const SizedBox(height: TossSpacing.space4),

        // Keypad
        _buildKeypad(),

        // Submit button
        if (widget.showSubmitButton) ...[
          const SizedBox(height: TossSpacing.space4),
          _buildSubmitButton(),
        ],
      ],
    );
  }

  Widget _buildAmountDisplay() {
    final hasAmount = _currentAmount > 0;
    final showCalculatorButton = widget.onExchangeRateTap != null;

    return GestureDetector(
      onLongPress: _onClear,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space5,
        ),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: hasAmount ? TossColors.gray900 : TossColors.gray200,
            width: hasAmount ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Spacer for symmetry when calculator button is shown
                if (showCalculatorButton) SizedBox(width: TossSpacing.iconXXL),

                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        widget.currencySymbol,
                        style: TossTextStyles.h2.copyWith(
                          color: TossColors.gray500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      AnimatedSwitcher(
                        duration: TossAnimations.quick,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _formattedAmount,
                          key: ValueKey(_formattedAmount),
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color:
                                hasAmount ? TossColors.gray900 : TossColors.gray300,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Exchange rate calculator button
                if (showCalculatorButton)
                  _buildCalculatorButton()
                else
                  const SizedBox.shrink(),
              ],
            ),
            if (!hasAmount) ...[
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Enter amount',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorButton() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: TossColors.primary.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: widget.onExchangeRateTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            child: const Icon(
              Icons.calculate_outlined,
              color: TossColors.white,
              size: TossSpacing.iconLG,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          children: [
            _buildKeyButton('1'),
            _buildKeyButton('2'),
            _buildKeyButton('3'),
          ],
        ),
        // Row 2: 4, 5, 6
        Row(
          children: [
            _buildKeyButton('4'),
            _buildKeyButton('5'),
            _buildKeyButton('6'),
          ],
        ),
        // Row 3: 7, 8, 9
        Row(
          children: [
            _buildKeyButton('7'),
            _buildKeyButton('8'),
            _buildKeyButton('9'),
          ],
        ),
        // Row 4: 000, 0, backspace
        Row(
          children: [
            _buildKeyButton('000'),
            _buildKeyButton('0'),
            _buildKeyButton('backspace', isIcon: true),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyButton(String key, {bool isIcon = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space1),
        child: Material(
          color: TossColors.transparent,
          child: InkWell(
            onTap: () => _onKeyPressed(key),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: isIcon
                    ? const Icon(
                        Icons.backspace_outlined,
                        color: TossColors.gray600,
                        size: TossSpacing.iconLG,
                      )
                    : Text(
                        key,
                        style: TossTextStyles.h3.copyWith(
                          color: TossColors.gray900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isEnabled = _currentAmount > 0;

    return SizedBox(
      width: double.infinity,
      height: TossSpacing.icon3XL,
      child: TossButton.primary(
        text: widget.submitButtonText,
        onPressed: isEnabled ? widget.onSubmit : null,
        isEnabled: isEnabled,
        fullWidth: true,
        height: TossSpacing.icon3XL,
        backgroundColor: TossColors.gray900,
        borderRadius: TossBorderRadius.lg,
        textStyle: TossTextStyles.h4.copyWith(
          fontWeight: FontWeight.bold,
          color: isEnabled ? TossColors.white : TossColors.gray400,
        ),
      ),
    );
  }
}
