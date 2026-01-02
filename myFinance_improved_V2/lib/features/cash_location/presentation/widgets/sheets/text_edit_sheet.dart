import 'package:flutter/material.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Bottom sheet for editing text fields (single line or multi-line)
/// Used in account_settings_page for Name, Bank Name, Account Number, Note editing
class TextEditSheet extends StatelessWidget {
  final String title;
  final String initialText;
  final String? hintText;
  final Function(String) onSave;
  final VoidCallback onCancel;
  final bool multiline;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;

  const TextEditSheet({
    super.key,
    required this.title,
    required this.initialText,
    required this.onSave,
    required this.onCancel,
    this.hintText,
    this.multiline = false,
    this.maxLines,
    this.minLines,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);
    final focusNode = FocusNode();

    return Container(
      decoration: const BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),

              // Header and Content
              Padding(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: TossSpacing.space2),

                    Text(
                      title,
                      style: TossTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Input field with underline
                    TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: keyboardType ??
                        (multiline ? TextInputType.multiline : TextInputType.text),
                      textInputAction: multiline
                        ? TextInputAction.newline
                        : TextInputAction.done,
                      maxLines: maxLines ?? (multiline ? 4 : 1),
                      minLines: minLines ?? (multiline ? 4 : 1),
                      onSubmitted: multiline ? null : (_) => onSave(controller.text),
                      style: TossTextStyles.body.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: TossColors.gray800,
                        height: multiline ? 1.4 : null,
                      ),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.only(
                          bottom: TossSpacing.space2,
                          top: TossSpacing.space1,
                        ),
                        fillColor: TossColors.transparent,
                        filled: false,
                        hintText: hintText,
                        hintStyle: hintText != null ? TossTextStyles.body.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: TossColors.gray400,
                        ) : null,
                        suffixIcon: !multiline ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: TossColors.gray400,
                            size: 20,
                          ),
                          onPressed: () {
                            controller.clear();
                          },
                        ) : null,
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space6),

                    // Bottom button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TossButton.primary(
                        text: 'Save',
                        onPressed: () => onSave(controller.text),
                        fullWidth: true,
                        height: 56,
                        borderRadius: TossBorderRadius.lg,
                        textStyle: TossTextStyles.body.copyWith(
                          color: TossColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: TossSpacing.space2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
