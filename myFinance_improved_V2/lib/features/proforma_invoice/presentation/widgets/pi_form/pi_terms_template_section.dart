import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/widgets/toss/toss_dropdown.dart';
import '../../providers/pi_providers.dart';

/// Terms template section for PI form
class PITermsTemplateSection extends ConsumerWidget {
  final String? selectedTemplateId;
  final TextEditingController termsController;
  final ValueChanged<String?> onTemplateChanged;

  const PITermsTemplateSection({
    super.key,
    required this.selectedTemplateId,
    required this.termsController,
    required this.onTemplateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsState = ref.watch(termsTemplateProvider);

    final templateItems = [
      const TossDropdownItem<String?>(
        value: null,
        label: '-- No Template --',
      ),
      ...termsState.items.map((t) => TossDropdownItem<String?>(
        value: t.templateId,
        label: t.templateName,
        subtitle: t.isDefault ? 'Default' : null,
      )),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template dropdown
        TossDropdown<String?>(
          label: 'Template (optional)',
          value: selectedTemplateId,
          hint: 'Select template',
          isLoading: termsState.isLoading,
          items: templateItems,
          onChanged: (v) {
            onTemplateChanged(v);
            if (v != null) {
              try {
                final selected = termsState.items.firstWhere((t) => t.templateId == v);
                termsController.text = selected.content;
              } catch (e) {
                // Template not found
              }
            }
          },
        ),
        const SizedBox(height: TossSpacing.space3),

        // Terms content (editable)
        _buildTextField(
          controller: termsController,
          label: 'Terms & Conditions Content',
          maxLines: 6,
        ),
        const SizedBox(height: TossSpacing.space2),

        // Save as template button
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: termsController.text.isNotEmpty
                ? () => _showSaveTemplateDialog(context, ref)
                : null,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save as Template'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TossTextStyles.label.copyWith(
            color: TossColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: TossSpacing.space2),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: TossTextStyles.bodyLarge.copyWith(
              color: TossColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: TossColors.surface,
            contentPadding: const EdgeInsets.all(TossSpacing.space3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              borderSide: const BorderSide(color: TossColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  void _showSaveTemplateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as Template'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Template Name',
            hintText: 'e.g., Standard Export Terms',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a template name')),
                );
                return;
              }

              final result = await ref.read(termsTemplateProvider.notifier).saveAsTemplate(
                    nameController.text,
                    termsController.text,
                  );

              if (context.mounted) {
                Navigator.pop(context);
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Template "${result.templateName}" saved')),
                  );
                  onTemplateChanged(result.templateId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save template')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
