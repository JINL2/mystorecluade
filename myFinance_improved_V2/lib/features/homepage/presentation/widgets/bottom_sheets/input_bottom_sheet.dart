import 'package:flutter/material.dart';
import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';

/// Generic input bottom sheet for entering codes or text
class InputBottomSheet extends StatefulWidget {
  const InputBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.inputLabel,
    required this.buttonText,
    required this.onSubmit,
  });

  final String title;
  final String subtitle;
  final String inputLabel;
  final String buttonText;
  final void Function(String) onSubmit;

  @override
  State<InputBottomSheet> createState() => _InputBottomSheetState();

  /// Show the input bottom sheet
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String inputLabel,
    required String buttonText,
    required void Function(String) onSubmit,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: TossColors.transparent,
      builder: (modalContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: InputBottomSheet(
            title: title,
            subtitle: subtitle,
            inputLabel: inputLabel,
            buttonText: buttonText,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}

class _InputBottomSheetState extends State<InputBottomSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      // Basic validation for code format (alphanumeric, 6-15 chars)
      final validPattern = RegExp(r'^[a-zA-Z0-9]{6,15}$');
      if (!validPattern.hasMatch(code)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid code format. Please use alphanumeric characters only.'),
            backgroundColor: TossColors.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // Close the input modal first
      Navigator.of(context).pop();
      // Execute the submit callback
      widget.onSubmit(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Handle bar
        Container(
          width: TossSpacing.space10,
          height: TossSpacing.space1,
          margin: const EdgeInsets.only(top: TossSpacing.space2, bottom: TossSpacing.paddingXL),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
          ),
        ),

        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TossTextStyles.h3.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TossTextStyles.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: TossSpacing.space8),

        // Input Form
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.paddingXL),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: widget.inputLabel,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                  ),
                  autofocus: true,
                ),

                const SizedBox(height: TossSpacing.paddingXL),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                      ),
                    ),
                    child: Text(widget.buttonText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
