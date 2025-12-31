import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

/// Enhanced bottom sheet with fixed UX pattern for keyboard handling
/// 
/// UX Design:
/// - Transaction Actions (Cancel/Create) stay at bottom - NEVER move with keyboard
/// - Keyboard has its own "Done" button for dismissing keyboard
/// - Text fields scroll into view when keyboard appears
/// - Clear visual separation between keyboard controls and transaction controls
class TossTextFieldKeyboardModal extends StatefulWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actionButtons;
  final EdgeInsets? contentPadding;
  final bool showHandle;
  final double maxHeightFactor;
  final bool dismissOnTapOutside;
  final VoidCallback? onDismiss;
  const TossTextFieldKeyboardModal({
    super.key,
    this.title,
    required this.content,
    this.actionButtons,
    this.contentPadding,
    this.showHandle = true,
    this.maxHeightFactor = 0.9,
    this.dismissOnTapOutside = true,
    this.onDismiss,
  });
  /// Show modal with smart keyboard handling
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actionButtons,
    EdgeInsets? contentPadding,
    bool showHandle = true,
    double maxHeightFactor = 0.9,
    bool dismissOnTapOutside = true,
    VoidCallback? onDismiss,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: TossColors.transparent,
      barrierColor: TossColors.black54,
      isScrollControlled: true,
      isDismissible: dismissOnTapOutside,
      enableDrag: true,
      useSafeArea: true,
      builder: (context) => TossTextFieldKeyboardModal(
        title: title,
        content: content,
        actionButtons: actionButtons,
        contentPadding: contentPadding,
        showHandle: showHandle,
        maxHeightFactor: maxHeightFactor,
        dismissOnTapOutside: dismissOnTapOutside,
        onDismiss: onDismiss,
      ),
    );
  }
  /// Specialized method for amount input scenarios
  static Future<double?> showAmountInput({
    required String title,
    String? hint,
    String? initialValue,
    String? currency,
    required void Function(double) onSubmit,
    String submitButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
  }) async {
    final controller = TextEditingController(text: initialValue);
    double? result;
    await show<double>(
      title: title,
      content: _AmountInputContent(
        controller: controller,
        hint: hint,
        currency: currency,
        onSubmit: (value) {
          result = value;
          Navigator.of(context).pop(value);
        },
      actionButtons: [
        _buildCancelButton(context, cancelButtonText),
        _buildSubmitButton(
          context: context,
          controller: controller,
          onSubmit: onSubmit,
          text: submitButtonText,
        ),
      ],
    return result;
  static Widget _buildCancelButton(BuildContext context, String text) {
    return Expanded(
      // Uses TossButton Atom for consistent design
      child: TossButton.secondary(
        text: text,
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: TossColors.transparent,
        textColor: TossColors.textSecondary,
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
  static Widget _buildSubmitButton({
    required TextEditingController controller,
    required String text,
      flex: 2,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          final cleanText = value.text.replaceAll(RegExp(r'[^0-9.]'), '');
          final amount = double.tryParse(cleanText) ?? 0;
          final isEnabled = amount > 0;
          // Uses TossButton Atom for consistent design
          return TossButton.primary(
            text: text,
            onPressed: isEnabled
                ? () {
                    onSubmit(amount);
                    Navigator.of(context).pop(amount);
                  }
                : null,
            isEnabled: isEnabled,
            fontWeight: FontWeight.w600,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            borderRadius: TossBorderRadius.md,
          );
  @override
  State<TossTextFieldKeyboardModal> createState() =>
      _TossTextFieldKeyboardModalState();
}
class _TossTextFieldKeyboardModalState
    extends State<TossTextFieldKeyboardModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  double _keyboardHeight = 0;
  bool _isKeyboardVisible = false;
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    _animationController.forward();
  void dispose() {
    _animationController.dispose();
    super.dispose();
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _keyboardHeight = mediaQuery.viewInsets.bottom;
    _isKeyboardVisible = _keyboardHeight > 0;
    final maxHeight = mediaQuery.size.height * widget.maxHeightFactor;
    final safePadding = mediaQuery.padding.bottom;
    
    // Calculate proper action bar height
    final actionBarHeight = widget.actionButtons != null ? 80.0 : 0.0;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            minHeight: 0,
          ),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(TossBorderRadius.bottomSheet),
            ),
            boxShadow: TossShadows.bottomSheet,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showHandle) _buildHandle(),
              if (widget.title != null) _buildTitle(),
              Flexible(
                child: Stack(
                  children: [
                    // Scrollable content area
                    Positioned.fill(
                      bottom: actionBarHeight,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: widget.contentPadding ??
                            EdgeInsets.fromLTRB(
                              TossSpacing.space4,
                              TossSpacing.space3,
                              // Add keyboard space + action bar space
                              (widget.actionButtons != null ? actionBarHeight : TossSpacing.space4) + 
                              (_isKeyboardVisible ? _keyboardHeight : 0),
                            ),
                        child: widget.content,
                      ),
                    ),
                    // Fixed action bar - NEVER moves with keyboard
                    // This prevents confusion between keyboard and transaction actions
                    if (widget.actionButtons != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0, // Always at bottom - clear UX separation
                        child: _buildFixedActionBar(safePadding),
                  ],
                ),
              ),
            ],
        );
      },
  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: TossColors.gray300,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs / 2), // 2.0 - handle
  Widget _buildTitle() {
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title!,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
          if (widget.dismissOnTapOutside)
            IconButton(
              onPressed: () {
                widget.onDismiss?.call();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close,
                color: TossColors.gray600,
                size: TossSpacing.iconMD,
        ],
  Widget _buildFixedActionBar(double safePadding) {
        color: TossColors.white,
        border: const Border(
          top: BorderSide(
            color: TossColors.gray300, // Stronger border to separate from content
            width: 2, // Thicker border for clear separation
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.12), // Stronger shadow
            blurRadius: 12,
            offset: const Offset(0, -4), // Higher shadow for more emphasis
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space3 + safePadding, // Already includes safe area
          for (int i = 0; i < widget.actionButtons!.length; i++) ...[
            if (i > 0) const SizedBox(width: TossSpacing.space3),
            widget.actionButtons![i],
          ],
/// Internal widget for amount input
class _AmountInputContent extends StatefulWidget {
  final TextEditingController controller;
  final String? hint;
  final String? currency;
  final Function(double) onSubmit;
  const _AmountInputContent({
    required this.controller,
    this.hint,
    this.currency,
    required this.onSubmit,
  State<_AmountInputContent> createState() => _AmountInputContentState();
class _AmountInputContentState extends State<_AmountInputContent> {
  final _focusNode = FocusNode();
    // Delay auto-focus to let the modal settle first
    // This prevents the keyboard from appearing immediately 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && context.mounted) {
          _focusNode.requestFocus();
        }
      });
    });
    _focusNode.dispose();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Amount',
          style: TossTextStyles.labelLarge.copyWith(
            color: TossColors.textSecondary,
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          style: TossTextStyles.h2.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w700,
          decoration: InputDecoration(
            prefixText: widget.currency,
            hintText: widget.hint ?? '0',
            hintStyle: TossTextStyles.h2.copyWith(
              color: TossColors.gray300,
            filled: true,
            fillColor: TossColors.white, // White background for better visibility
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.gray300, width: 1.5),
            enabledBorder: OutlineInputBorder(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: TossColors.primary, width: 2.5), // Thicker focus border
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space4,
              vertical: TossSpacing.space5, // More padding for easier tapping
          onFieldSubmitted: (value) {
            final cleanText = value.replaceAll(RegExp(r'[^0-9.]'), '');
            final amount = double.tryParse(cleanText) ?? 0;
            if (amount > 0) {
              widget.onSubmit(amount);
            }
          },
}