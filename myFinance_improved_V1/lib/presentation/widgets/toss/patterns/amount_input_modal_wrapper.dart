import 'package:flutter/material.dart';
import '../keyboard/toss_keyboard_aware_bottom_sheet.dart';
import '../keyboard/toss_amount_input.dart';
import '../toss_smart_action_bar.dart';
import '../keyboard/amount_validator.dart';
import '../keyboard/keyboard_utils.dart';
import '../../../../core/themes/toss_spacing.dart';

/// Specialized wrapper for amount input modals
/// Provides a complete solution for amount input with smart keyboard handling
class AmountInputModalWrapper extends StatefulWidget {
  final String title;
  final String? label;
  final String? hintText;
  final String? currency;
  final double? initialAmount;
  final AmountValidator? validator;
  final ValueChanged<double?> onAmountChanged;
  final VoidCallback onCancel;
  final VoidCallback onDone;
  final Widget? additionalContent;
  final bool showClearButton;
  final bool autoFocus;
  final int maxDecimalPlaces;

  const AmountInputModalWrapper({
    super.key,
    required this.title,
    this.label,
    this.hintText,
    this.currency = '₩',
    this.initialAmount,
    this.validator,
    required this.onAmountChanged,
    required this.onCancel,
    required this.onDone,
    this.additionalContent,
    this.showClearButton = true,
    this.autoFocus = true,
    this.maxDecimalPlaces = 0,
  });

  /// Show amount input modal
  static Future<double?> show({
    required BuildContext context,
    required String title,
    String? label,
    String? hintText,
    String? currency = '₩',
    double? initialAmount,
    AmountValidator? validator,
    Widget? additionalContent,
    bool showClearButton = true,
    int maxDecimalPlaces = 0,
  }) {
    return TossKeyboardAwareBottomSheet.showAmount<double>(
      context: context,
      title: title,
      currency: currency,
      autoFocus: true,
      content: _AmountInputContent(
        label: label,
        hintText: hintText,
        currency: currency,
        initialAmount: initialAmount,
        validator: validator,
        additionalContent: additionalContent,
        showClearButton: showClearButton,
        maxDecimalPlaces: maxDecimalPlaces,
      ),
    );
  }

  @override
  State<AmountInputModalWrapper> createState() => _AmountInputModalWrapperState();
}

class _AmountInputModalWrapperState extends State<AmountInputModalWrapper> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  double? _currentAmount;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    if (widget.initialAmount != null) {
      _controller.text = widget.initialAmount!.toStringAsFixed(widget.maxDecimalPlaces);
      _currentAmount = widget.initialAmount;
    }

    // Auto-focus if requested
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleAmountChanged(double? amount) {
    setState(() {
      _currentAmount = amount;
      _hasError = widget.validator?.validate(_controller.text) != null;
    });
    widget.onAmountChanged(amount);
  }

  void _handleDone() {
    if (!_hasError && _currentAmount != null) {
      widget.onDone();
    }
  }

  void _handleClear() {
    _controller.clear();
    setState(() {
      _currentAmount = null;
      _hasError = false;
    });
    widget.onAmountChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    return TossKeyboardAwareBottomSheet(
      title: widget.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Amount Input
          TossAmountInput(
            label: widget.label,
            hintText: widget.hintText ?? 'Enter amount',
            controller: _controller,
            currency: widget.currency,
            validator: widget.validator,
            autoFocus: widget.autoFocus,
            maxDecimalPlaces: widget.maxDecimalPlaces,
            focusNode: _focusNode,
            onValueChanged: _handleAmountChanged,
            onKeyboardDone: _handleDone,
          ),

          // Additional Content
          if (widget.additionalContent != null) ...[
            const SizedBox(height: TossSpacing.space4),
            widget.additionalContent!,
          ],
        ],
      ),
      smartActionBar: TossSmartActionBar(
        actions: [
          if (widget.showClearButton)
            TossActionButton.secondary(
              label: 'Clear',
              onTap: _handleClear,
              icon: Icons.backspace,
              isEnabled: _currentAmount != null,
            ),
          TossActionButton.primary(
            label: 'Done',
            onTap: _handleDone,
            icon: Icons.check,
            isEnabled: !_hasError && _currentAmount != null,
          ),
        ],
        showWhenKeyboardVisible: true,
        position: SmartBarPosition.aboveKeyboard,
      ),
    );
  }
}

/// Internal content widget for static show method
class _AmountInputContent extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? currency;
  final double? initialAmount;
  final AmountValidator? validator;
  final Widget? additionalContent;
  final bool showClearButton;
  final int maxDecimalPlaces;

  const _AmountInputContent({
    this.label,
    this.hintText,
    this.currency,
    this.initialAmount,
    this.validator,
    this.additionalContent,
    this.showClearButton = true,
    this.maxDecimalPlaces = 0,
  });

  @override
  State<_AmountInputContent> createState() => _AmountInputContentState();
}

class _AmountInputContentState extends State<_AmountInputContent> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  double? _currentAmount;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    
    if (widget.initialAmount != null) {
      _controller.text = widget.initialAmount!.toStringAsFixed(widget.maxDecimalPlaces);
      _currentAmount = widget.initialAmount;
    }

    // Auto-focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleAmountChanged(double? amount) {
    setState(() {
      _currentAmount = amount;
      _hasError = widget.validator?.validate(_controller.text) != null;
    });
  }

  void _handleDone() {
    if (!_hasError && _currentAmount != null) {
      Navigator.of(context).pop(_currentAmount);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleClear() {
    _controller.clear();
    setState(() {
      _currentAmount = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Amount Input
        TossAmountInput(
          label: widget.label,
          hintText: widget.hintText ?? 'Enter amount',
          controller: _controller,
          currency: widget.currency,
          validator: widget.validator,
          autoFocus: true,
          maxDecimalPlaces: widget.maxDecimalPlaces,
          focusNode: _focusNode,
          onValueChanged: _handleAmountChanged,
          onKeyboardDone: _handleDone,
        ),

        // Additional Content
        if (widget.additionalContent != null) ...[
          const SizedBox(height: TossSpacing.space4),
          widget.additionalContent!,
        ],

        // Action Bar
        const SizedBox(height: TossSpacing.space4),
        TossSmartActionBar(
          actions: [
            TossActionButton.secondary(
              label: 'Cancel',
              onTap: _handleCancel,
              icon: Icons.close,
            ),
            if (widget.showClearButton)
              TossActionButton.secondary(
                label: 'Clear',
                onTap: _handleClear,
                icon: Icons.backspace,
                isEnabled: _currentAmount != null,
              ),
            TossActionButton.primary(
              label: 'Done',
              onTap: _handleDone,
              icon: Icons.check,
              isEnabled: !_hasError && _currentAmount != null,
            ),
          ],
          showWhenKeyboardVisible: true,
          position: SmartBarPosition.aboveKeyboard,
        ),
      ],
    );
  }
}

/// Preset amount input modals for common scenarios
class AmountInputModals {
  /// Show transaction amount input
  static Future<double?> showTransactionAmount(
    BuildContext context, {
    String title = 'Enter Amount',
    double? initialAmount,
    String? currency = '₩',
  }) {
    return AmountInputModalWrapper.show(
      context: context,
      title: title,
      label: 'Transaction Amount',
      hintText: 'Enter transaction amount',
      currency: currency,
      initialAmount: initialAmount,
      validator: AmountValidators.transaction(currency: currency),
      maxDecimalPlaces: currency == '₩' ? 0 : 2,
    );
  }

  /// Show salary amount input
  static Future<double?> showSalaryAmount(
    BuildContext context, {
    String title = 'Enter Salary',
    double? initialAmount,
    String? currency = '₩',
  }) {
    return AmountInputModalWrapper.show(
      context: context,
      title: title,
      label: 'Monthly Salary',
      hintText: 'Enter monthly salary',
      currency: currency,
      initialAmount: initialAmount,
      validator: AmountValidators.salary(currency: currency),
      maxDecimalPlaces: 0,
    );
  }

  /// Show product price input
  static Future<double?> showProductPrice(
    BuildContext context, {
    String title = 'Enter Price',
    double? initialAmount,
    String? currency = '₩',
  }) {
    return AmountInputModalWrapper.show(
      context: context,
      title: title,
      label: 'Product Price',
      hintText: 'Enter product price',
      currency: currency,
      initialAmount: initialAmount,
      validator: AmountValidators.productPrice(currency: currency),
      maxDecimalPlaces: currency == '₩' ? 0 : 2,
    );
  }

  /// Show interest rate input
  static Future<double?> showInterestRate(
    BuildContext context, {
    String title = 'Enter Interest Rate',
    double? initialAmount,
  }) {
    return AmountInputModalWrapper.show(
      context: context,
      title: title,
      label: 'Interest Rate',
      hintText: 'Enter interest rate',
      currency: '%',
      initialAmount: initialAmount,
      validator: AmountValidators.interestRate(),
      maxDecimalPlaces: 2,
    );
  }
}