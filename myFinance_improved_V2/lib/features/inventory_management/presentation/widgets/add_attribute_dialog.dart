import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Dialog for adding a new attribute value (Category, Brand, etc.)
class AddAttributeDialog extends StatelessWidget {
  const AddAttributeDialog({
    super.key,
    required this.title,
    required this.initialValue,
  });

  /// The attribute type title (e.g., "brand", "category")
  final String title;

  /// Initial value to populate the text field
  final String initialValue;

  /// Shows the dialog and returns the entered name, or null if cancelled
  static Future<String?> show({
    required BuildContext context,
    required String title,
    String initialValue = '',
  }) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AddAttributeDialog(
        title: title,
        initialValue: initialValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: initialValue);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space10),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add $title',
              style: TossTextStyles.h3.copyWith(
                fontWeight: FontWeight.w700,
                color: TossColors.gray900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TossTextField(
              label: 'Name',
              controller: nameController,
              hintText: 'Enter $title name',
              autofocus: true,
              autocorrect: false,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TossButton.secondary(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                    fullWidth: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TossButton.primary(
                    text: 'Add',
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        Navigator.pop(context, name);
                      }
                    },
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
