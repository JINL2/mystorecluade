import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

/// Currency exchange input modal with custom number pad
/// Used for entering currency amounts in exchange rate calculator
/// Shows a large number pad for easy input on mobile devices
class TossCurrencyExchangeModal extends StatefulWidget {
  final String? title;
  final String? initialValue;
  final String? currency; // Made optional - no symbol for percentages/other uses
  final bool allowDecimal;
  final int maxDecimalPlaces;
  final double? maxAmount;
  final ValueChanged<String> onConfirm;
  final VoidCallback? onClose;
  const TossCurrencyExchangeModal({
    super.key,
    this.title,
    this.initialValue,
    this.currency, // No default - let it be optional
    this.allowDecimal = true,
    this.maxDecimalPlaces = 2,
    this.maxAmount,
    required this.onConfirm,
    this.onClose,
  });
  /// Show currency exchange modal and return the entered value
  static Future<String?> show({
    required BuildContext context,
    String? title,
    String? initialValue,
    String? currency, // Made optional - no default
    bool allowDecimal = true,
    int maxDecimalPlaces = 2,
    double? maxAmount,
    required ValueChanged<String> onConfirm,
    VoidCallback? onClose,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      builder: (context) => TossCurrencyExchangeModal(
        title: title,
        initialValue: initialValue,
        currency: currency,
        allowDecimal: allowDecimal,
        maxDecimalPlaces: maxDecimalPlaces,
        maxAmount: maxAmount,
        onConfirm: onConfirm,
        onClose: onClose,
      ),
    );
  }
  @override
  State<TossCurrencyExchangeModal> createState() => _TossCurrencyExchangeModalState();
}
class _TossCurrencyExchangeModalState extends State<TossCurrencyExchangeModal> {
  late String _value;
  final _numberFormat = NumberFormat('#,##0.##');
  void initState() {
    super.initState();
    _value = widget.initialValue ?? '';
  void _onNumberTap(String number) {
    setState(() {
      // Handle decimal places
      if (_value.contains('.')) {
        final parts = _value.split('.');
        if (parts[1].length >= widget.maxDecimalPlaces) {
          return; // Max decimal places reached
        }
      }
      // Prevent leading zeros
      if (_value == '0' && number != '.') {
        _value = number;
      } else {
        _value += number;
      // Check max amount
      if (widget.maxAmount != null) {
        final amount = double.tryParse(_value.replaceAll(',', '')) ?? 0;
        if (amount > widget.maxAmount!) {
          _value = _value.substring(0, _value.length - 1);
    });
  void _onDecimalTap() {
    if (!widget.allowDecimal) return;
    if (_value.contains('.')) return;
      if (_value.isEmpty) {
        _value = '0.';
        _value += '.';
  void _onDelete() {
      if (_value.isNotEmpty) {
        _value = _value.substring(0, _value.length - 1);
  void _onClear() {
      _value = '';
  String _getFormattedAmount() {
    if (_value.isEmpty) return '0';
    // Handle decimal point at the end
    if (_value.endsWith('.')) {
      final baseValue = _value.substring(0, _value.length - 1);
      final formatted = baseValue.isEmpty ? '0' : _numberFormat.format(double.parse(baseValue));
      return '$formatted.';
    }
    // Handle decimal values
    if (_value.contains('.')) {
      final parts = _value.split('.');
      final integerPart = parts[0].isEmpty ? '0' : _numberFormat.format(double.parse(parts[0]));
      return '$integerPart.${parts[1]}';
    // Regular integer
    final amount = double.tryParse(_value) ?? 0;
    return _numberFormat.format(amount);
  Widget build(BuildContext context) {
    final formattedAmount = _getFormattedAmount();
    final isValid = _value.isNotEmpty && _value != '0' && _value != '0.';
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xxxl),
        ),
        boxShadow: TossShadows.bottomSheet,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            decoration: BoxDecoration(
              color: TossColors.gray300,
              borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2), // 2.0 - handle
            ),
          ),
          // Title
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                widget.title!,
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
          // Amount display
            margin: const EdgeInsets.all(TossSpacing.space4),
            padding: const EdgeInsets.all(TossSpacing.space4),
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: isValid ? TossColors.primary : TossColors.gray200,
                width: isValid ? 2 : 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.currency != null && widget.currency!.isNotEmpty) ...[
                  Text(
                    widget.currency!,
                    style: TossTextStyles.h2.copyWith(
                      color: TossColors.gray600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space2),
                ],
                Expanded(
                  child: Text(
                    formattedAmount,
                    textAlign: (widget.currency != null && widget.currency!.isNotEmpty)
                        ? TextAlign.right
                        : TextAlign.center,
                    style: TossTextStyles.h1.copyWith(
                      color: isValid ? TossColors.gray900 : TossColors.gray400,
                      fontWeight: FontWeight.bold,
              ],
          // Numberpad
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3),
            child: Column(
                // Row 1-3 (1-9)
                for (int row = 0; row < 3; row++)
                  Row(
                    children: [
                      for (int col = 1; col <= 3; col++)
                        _buildNumberButton((row * 3 + col).toString()),
                    ],
                // Row 4 (decimal, 0, delete)
                Row(
                  children: [
                    _buildSpecialButton(
                      widget.allowDecimal ? '.' : '',
                      onTap: widget.allowDecimal ? _onDecimalTap : null,
                      enabled: widget.allowDecimal,
                    _buildNumberButton('0'),
                      '',
                      icon: Icons.backspace_outlined,
                      onTap: _onDelete,
                      onLongPress: _onClear,
                  ],
          // Action buttons
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: TossColors.gray200,
                  width: 1,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Close button - Uses TossButton Atom
                  Expanded(
                    child: TossButton.secondary(
                      text: 'Close',
                      onPressed: () {
                        widget.onClose?.call();
                        Navigator.of(context).pop();
                      },
                      backgroundColor: TossColors.transparent,
                      textColor: TossColors.gray600,
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      borderRadius: TossBorderRadius.md,
                  const SizedBox(width: TossSpacing.space3),
                  // Confirm button - Uses TossButton Atom
                    flex: 2,
                    child: TossButton.primary(
                      text: 'Confirm',
                      onPressed: isValid
                          ? () {
                              widget.onConfirm(_value);
                              Navigator.of(context).pop(_value);
                            }
                          : null,
                      isEnabled: isValid,
        ],
  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(TossSpacing.space1),
        child: Material(
          color: TossColors.gray50,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              _onNumberTap(number);
            },
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: Center(
                number,
                style: TossTextStyles.h2.copyWith(
                  color: TossColors.gray900,
                  fontWeight: FontWeight.w600,
  Widget _buildSpecialButton(
    String text, {
    IconData? icon,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool enabled = true,
          color: enabled ? TossColors.gray50 : TossColors.gray50.withOpacity(0.5),
            onTap: enabled ? () {
              onTap?.call();
            } : null,
            onLongPress: enabled ? () {
              HapticFeedback.mediumImpact();
              onLongPress?.call();
              child: icon != null
                  ? Icon(
                      icon,
                      color: enabled ? TossColors.gray700 : TossColors.gray300,
                      size: TossSpacing.iconMD,
                    )
                  : Text(
                      text,
                      style: TossTextStyles.h2.copyWith(
                        color: enabled ? TossColors.gray900 : TossColors.gray300,
                        fontWeight: FontWeight.w600,
                      ),
/// Helper widget to wrap TextField with currency exchange modal
class TossCurrencyExchangeField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? currency; // Made optional
  final InputDecoration? decoration;
  final TextStyle? style;
  const TossCurrencyExchangeField({
    required this.controller,
    this.hintText,
    this.decoration,
    this.style,
    return GestureDetector(
      onTap: () async {
        final result = await TossCurrencyExchangeModal.show(
          context: context,
          title: title ?? 'Enter Amount',
          initialValue: controller.text.replaceAll(',', ''),
          currency: currency,
          allowDecimal: allowDecimal,
          maxDecimalPlaces: maxDecimalPlaces,
          maxAmount: maxAmount,
          onConfirm: (value) {
            controller.text = value;
            onConfirm(value);
          },
          onClose: onClose,
        );
        if (result != null) {
          controller.text = result;
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: decoration ?? InputDecoration(
            hintText: hintText ?? 'Tap to enter amount',
          style: style,
          keyboardType: TextInputType.none,
// Backward compatibility aliases
@Deprecated('Use TossCurrencyExchangeModal instead')
typedef TossNumberpadModal = TossCurrencyExchangeModal;
@Deprecated('Use TossCurrencyExchangeField instead')
typedef TossNumberpadField = TossCurrencyExchangeField;
