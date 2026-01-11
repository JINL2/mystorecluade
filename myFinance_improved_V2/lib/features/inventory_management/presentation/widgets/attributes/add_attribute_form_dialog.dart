import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/attribute_types.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

// Re-export for backward compatibility (prevents DCM false positive)
export '../../../domain/entities/attribute_types.dart';

/// Dialog for adding a new attribute with options
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
  final List<TextEditingController> _optionControllers = [];
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    for (final controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
    // Focus the new option field after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_optionControllers.isNotEmpty) {
        FocusScope.of(context).nextFocus();
      }
    });
  }

  void _removeOption(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
  }

  void _onAdd() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      TossToast.warning(context, 'Please enter attribute name');
      return;
    }

    // Build options list from non-empty option values
    final options = <AttributeOptionItem>[];
    for (int i = 0; i < _optionControllers.length; i++) {
      final value = _optionControllers[i].text.trim();
      if (value.isNotEmpty) {
        options.add(
          AttributeOptionItem(
            value: value,
            sortOrder: i + 1,
          ),
        );
      }
    }

    Navigator.pop(
      context,
      AddAttributeResult(
        name: name,
        options: options,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 400,
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

              // Scrollable content area
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name input
                      TossTextField(
                        label: 'Name',
                        controller: _nameController,
                        hintText: 'Enter attribute name',
                        focusNode: _nameFocusNode,
                        autofocus: true,
                      ),
                      const SizedBox(height: 20),

                      // Options section
                      _buildOptionsSection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons (fixed at bottom)
              Row(
                children: [
                  Expanded(
                    child: TossButton.textButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TossButton.primary(
                      text: 'Add',
                      onPressed: _onAdd,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Options',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            Text(
              'Optional',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Options list
        ..._optionControllers.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(
                  bottom: entry.key < _optionControllers.length - 1 ? 8 : 0,
                ),
                child: _buildOptionRow(entry.key),
              ),
            ),

        // Add option button
        const SizedBox(height: 12),
        InkWell(
          onTap: _addOption,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: TossColors.gray200,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.plus,
                  size: 16,
                  color: TossColors.gray500,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Option',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRow(int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _optionControllers[index],
            decoration: InputDecoration(
              hintText: 'Option ${index + 1}',
              hintStyle: TossTextStyles.body.copyWith(
                color: TossColors.gray400,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
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
            ),
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _removeOption(index),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              LucideIcons.x,
              size: 18,
              color: TossColors.gray400,
            ),
          ),
        ),
      ],
    );
  }
}
