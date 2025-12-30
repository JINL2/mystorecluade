import 'package:flutter/material.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TossTextStyles.label.copyWith(
                    color: TossColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Enter $title name',
                    hintStyle: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: const BorderSide(color: TossColors.gray300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide: const BorderSide(color: TossColors.gray300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      borderSide:
                          const BorderSide(color: TossColors.primary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                      vertical: TossSpacing.space3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isNotEmpty) {
                        Navigator.pop(context, name);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TossColors.primary,
                      foregroundColor: TossColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                    ),
                    child: const Text('Add'),
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
