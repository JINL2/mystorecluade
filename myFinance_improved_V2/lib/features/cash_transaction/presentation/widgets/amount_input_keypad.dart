import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Amount Input Keypad
/// Minimal design - gray tones, no colored borders
class AmountInputKeypad extends StatefulWidget {
  final double initialAmount;
  final String currencySymbol;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback? onSubmit;
  final bool showSubmitButton;
  final String submitButtonText;

  const AmountInputKeypad({
    super.key,
    this.initialAmount = 0,
    this.currencySymbol = '₩',
    required this.onAmountChanged,
    this.onSubmit,
    this.showSubmitButton = true,
    this.submitButtonText = 'Confirm',
  });

  @override
  State<AmountInputKeypad> createState() => _AmountInputKeypadState();
}

class _AmountInputKeypadState extends State<AmountInputKeypad> {
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
        // Amount display
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
                      color: hasAmount ? TossColors.gray900 : TossColors.gray300,
                      letterSpacing: -1,
                    ),
                  ),
                ),
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
                        size: 24,
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
      height: 56,
      child: TossButton.primary(
        text: widget.submitButtonText,
        onPressed: isEnabled ? widget.onSubmit : null,
        isEnabled: isEnabled,
        fullWidth: true,
        height: 56,
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
