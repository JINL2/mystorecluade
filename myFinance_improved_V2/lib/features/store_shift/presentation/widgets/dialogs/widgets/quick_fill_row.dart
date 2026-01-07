import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'time_button.dart';

/// Quick Fill Row Widget
///
/// A row for quick-filling business hours with label, time buttons, and apply action
class QuickFillRow extends StatelessWidget {
  final String label;
  final String openTime;
  final String closeTime;
  final ValueChanged<String> onOpenChanged;
  final ValueChanged<String> onCloseChanged;
  final VoidCallback onApply;
  final Future<void> Function(String currentTime, ValueChanged<String> onChanged)
      onShowTimePicker;

  const QuickFillRow({
    super.key,
    required this.label,
    required this.openTime,
    required this.closeTime,
    required this.onOpenChanged,
    required this.onCloseChanged,
    required this.onApply,
    required this.onShowTimePicker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
              fontWeight: TossFontWeight.medium,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: TimeButton(
            time: openTime,
            onTap: () => onShowTimePicker(openTime, onOpenChanged),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2),
          child: Text(
            '-',
            style: TossTextStyles.body.copyWith(color: TossColors.gray500),
          ),
        ),
        Expanded(
          flex: 2,
          child: TimeButton(
            time: closeTime,
            onTap: () => onShowTimePicker(closeTime, onCloseChanged),
          ),
        ),
        const SizedBox(width: TossSpacing.space2),
        IconButton(
          onPressed: onApply,
          icon: Icon(LucideIcons.check, size: TossSpacing.iconSM),
          color: TossColors.success,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: TossSpacing.buttonHeightSM,
            minHeight: TossSpacing.buttonHeightSM,
          ),
          tooltip: 'Apply',
        ),
      ],
    );
  }
}
