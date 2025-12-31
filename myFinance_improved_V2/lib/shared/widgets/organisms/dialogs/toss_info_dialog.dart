import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/index.dart';
import 'package:myfinance_improved/shared/widgets/atoms/buttons/toss_button.dart';

/// A simple informational dialog for help content with bullet points
///
/// Example:
/// ```dart
/// TossInfoDialog.show(
///   context: context,
///   title: 'What is an SKU?',
///   bulletPoints: [
///     'An SKU (Stock Keeping Unit) is a unique code used to identify an item.',
///     'You can enter your own or have Storebase generate one for you.',
///     'SKUs help you find items quickly and perform bulk actions in your inventory.',
///   ],
/// );
/// ```
class TossInfoDialog extends StatelessWidget {
  final String title;
  final List<String> bulletPoints;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  const TossInfoDialog({
    super.key,
    required this.title,
    required this.bulletPoints,
    this.buttonText = 'OK',
    this.onButtonPressed,
  });
  /// Shows the info dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<String> bulletPoints,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => TossInfoDialog(
        title: title,
        bulletPoints: bulletPoints,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: 20),
            ...bulletPoints.asMap().entries.map((entry) {
              final index = entry.key;
              final text = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < bulletPoints.length - 1 ? 12 : 0,
                ),
                child: _TossInfoBulletPoint(text: text),
              );
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: TossButton.primary(
                text: buttonText,
                fullWidth: true,
                onPressed: onButtonPressed ?? () => Navigator.pop(context),
          ],
        ),
}
/// Bullet point widget with default caption text style
class _TossInfoBulletPoint extends StatelessWidget {
  final String text;
  const _TossInfoBulletPoint({required this.text});
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: TossColors.gray600,
              shape: BoxShape.circle,
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
              height: 1.5,
      ],
