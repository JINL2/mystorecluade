import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_primary_button.dart';
import '../../../../../shared/widgets/toss/toss_selection_bottom_sheet.dart';
import '../../../domain/entities/attribute_types.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../../domain/entities/attribute_types.dart';

/// Dialog for adding a new attribute
class AddAttributeFormDialog extends StatefulWidget {
  const AddAttributeFormDialog({super.key});

  /// Shows the dialog and returns the result
  static Future<AddAttributeResult?> show(BuildContext context) {
    return showDialog<AddAttributeResult>(
      context: context,
      builder: (context) => const AddAttributeFormDialog(),
    );
  }

  @override
  State<AddAttributeFormDialog> createState() => _AddAttributeFormDialogState();
}

class _AddAttributeFormDialogState extends State<AddAttributeFormDialog> {
  final TextEditingController _nameController = TextEditingController();
  AttributeType _selectedType = AttributeType.text;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showTypeSelector() async {
    final items = AttributeType.values.map((type) {
      return TossSelectionItem(
        id: type.name,
        title: type.label,
      );
    }).toList();

    final result = await TossSelectionBottomSheet.show<TossSelectionItem>(
      context: context,
      title: 'Select Type',
      items: items,
      selectedId: _selectedType.name,
      maxHeightFraction: 0.4,
      showSubtitle: false,
      showIcon: false,
      checkIcon: LucideIcons.check,
      borderBottomWidth: 0,
      showSelectedBackground: false,
    );

    if (result != null) {
      setState(() {
        _selectedType =
            AttributeType.values.firstWhere((t) => t.name == result.id);
      });
    }
  }

  void _onAdd() {
    if (_nameController.text.trim().isNotEmpty) {
      Navigator.pop(
        context,
        AddAttributeResult(
          name: _nameController.text.trim(),
          type: _selectedType,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'Add Attribute',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.gray900,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name input
            Text(
              'Name',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter attribute name',
                hintStyle: TossTextStyles.body.copyWith(
                  color: TossColors.gray400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.gray200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  borderSide: const BorderSide(color: TossColors.primary),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space4,
                  vertical: TossSpacing.space3,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Type selector
            Text(
              'Type',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _showTypeSelector,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: TossColors.gray200),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedType.label,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                    ),
                    const Icon(
                      LucideIcons.chevronDown,
                      size: 18,
                      color: TossColors.gray400,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.md),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TossPrimaryButton(
                    text: 'Add',
                    onPressed: _onAdd,
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
