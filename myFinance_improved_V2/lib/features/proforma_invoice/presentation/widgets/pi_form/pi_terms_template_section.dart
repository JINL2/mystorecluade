import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/themes/toss_spacing.dart';
import '../../providers/pi_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

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
        TossTextField.filled(
          controller: termsController,
          label: 'Terms & Conditions Content',
          hintText: 'Enter Terms & Conditions Content',
          maxLines: 6,
        ),
        const SizedBox(height: TossSpacing.space2),

        // Save as template button
        Align(
          alignment: Alignment.centerRight,
          child: TossButton.textButton(
            text: 'Save as Template',
            leadingIcon: const Icon(Icons.save_outlined, size: 18),
            onPressed: termsController.text.isNotEmpty
                ? () => _showSaveTemplateDialog(context, ref)
                : null,
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
        content: TossTextField.filled(
          controller: nameController,
          inlineLabel: 'Template Name',
          hintText: 'e.g., Standard Export Terms',
          autofocus: true,
        ),
        actions: [
          TossButton.textButton(
            text: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          TossButton.primary(
            text: 'Save',
            onPressed: () async {
              if (nameController.text.isEmpty) {
                TossToast.error(context, 'Please enter a template name');
                return;
              }

              final result = await ref.read(termsTemplateProvider.notifier).saveAsTemplate(
                    nameController.text,
                    termsController.text,
                  );

              if (context.mounted) {
                Navigator.pop(context);
                if (result != null) {
                  TossToast.success(context, 'Template "${result.templateName}" saved');
                  onTemplateChanged(result.templateId);
                } else {
                  TossToast.error(context, 'Failed to save template');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
