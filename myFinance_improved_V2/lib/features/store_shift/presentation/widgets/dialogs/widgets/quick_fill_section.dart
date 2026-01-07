import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';
import 'quick_fill_row.dart';

/// Quick Fill Section Widget
///
/// Provides quick fill controls for weekday and weekend hours
class QuickFillSection extends StatelessWidget {
  final String weekdayOpen;
  final String weekdayClose;
  final String weekendOpen;
  final String weekendClose;
  final ValueChanged<String> onWeekdayOpenChanged;
  final ValueChanged<String> onWeekdayCloseChanged;
  final ValueChanged<String> onWeekendOpenChanged;
  final ValueChanged<String> onWeekendCloseChanged;
  final VoidCallback onApplyWeekdays;
  final VoidCallback onApplyWeekend;
  final VoidCallback onApplyBoth;
  final Future<void> Function(String currentTime, ValueChanged<String> onChanged)
      onShowTimePicker;

  const QuickFillSection({
    super.key,
    required this.weekdayOpen,
    required this.weekdayClose,
    required this.weekendOpen,
    required this.weekendClose,
    required this.onWeekdayOpenChanged,
    required this.onWeekdayCloseChanged,
    required this.onWeekendOpenChanged,
    required this.onWeekendCloseChanged,
    required this.onApplyWeekdays,
    required this.onApplyWeekend,
    required this.onApplyBoth,
    required this.onShowTimePicker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.zap,
                color: TossColors.primary,
                size: TossSpacing.iconSM,
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Quick Fill',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: TossFontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space3),

          // Weekday Quick Fill
          QuickFillRow(
            label: 'Weekdays (Mon-Fri)',
            openTime: weekdayOpen,
            closeTime: weekdayClose,
            onApply: onApplyWeekdays,
            onShowTimePicker: onShowTimePicker,
            onOpenChanged: onWeekdayOpenChanged,
            onCloseChanged: onWeekdayCloseChanged,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Weekend Quick Fill
          QuickFillRow(
            label: 'Weekend (Sat-Sun)',
            openTime: weekendOpen,
            closeTime: weekendClose,
            onApply: onApplyWeekend,
            onShowTimePicker: onShowTimePicker,
            onOpenChanged: onWeekendOpenChanged,
            onCloseChanged: onWeekendCloseChanged,
          ),

          const SizedBox(height: TossSpacing.space3),

          // Apply All Button
          SizedBox(
            width: double.infinity,
            child: TossButton.outlined(
              onPressed: onApplyBoth,
              leadingIcon: Icon(LucideIcons.copyCheck, size: TossSpacing.iconSM),
              text: 'Apply Both',
            ),
          ),
        ],
      ),
    );
  }
}
