import 'package:flutter/material.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';

class TossCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? label;
  final bool enabled;

  const TossCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onChanged(!value);
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value
                  ? (enabled ? TossColors.primary : TossColors.gray400)
                  : TossColors.gray100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: value
                    ? (enabled ? TossColors.primary : TossColors.gray400)
                    : TossColors.gray300,
                width: 1.5,
              ),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 100),
              scale: value ? 1.0 : 0.0,
              child: Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: TossSpacing.space3),
            Flexible(child: label!),
          ],
        ],
      ),
    );
  }
}