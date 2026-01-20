import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/constants/icon_mapper.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_font_weight.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/store_shift.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Shift List Item Widget
///
/// Displays a single shift with edit/delete actions.
/// This is a feature-specific widget for store_shift.
class ShiftListItem extends StatelessWidget {
  final StoreShift shift;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ShiftListItem({
    super.key,
    required this.shift,
    this.onEdit,
    this.onDelete,
  });

  /// Determine icon and color based on start time
  (IconData, Color) _getTimeBasedIconAndColor() {
    try {
      final hour = int.parse(shift.startTime.split(':')[0]);

      if (hour >= 5 && hour < 12) {
        return (LucideIcons.sun, TossColors.success); // Morning
      } else if (hour >= 12 && hour < 17) {
        return (LucideIcons.sun, TossColors.info); // Afternoon
      } else if (hour >= 17 && hour < 22) {
        return (LucideIcons.cloudSun, TossColors.warning); // Evening
      } else {
        return (LucideIcons.moon, TossColors.gray600); // Night
      }
    } catch (e) {
      return (LucideIcons.clock, TossColors.info); // Default
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getTimeBasedIconAndColor();

    return GestureDetector(
      onTap: onEdit,
      child: TossCard(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
        children: [
          // Icon Container
          Container(
            width: TossSpacing.iconXL + TossSpacing.space2,
            height: TossSpacing.iconXL + TossSpacing.space2,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            ),
            child: Icon(
              icon,
              color: color,
              size: TossSpacing.iconMD,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Shift Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shift.shiftName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray900,
                    fontWeight: TossFontWeight.semibold,
                  ),
                ),
                const SizedBox(height: TossSpacing.space1 / 2),
                Row(
                  children: [
                    Text(
                      '${shift.startTime} - ${shift.endTime}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          LucideIcons.users,
                          size: TossSpacing.space3,
                          color: TossColors.gray500,
                        ),
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          '${shift.numberShift}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontWeight: TossFontWeight.semibold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    IconMapper.getIcon('editRegular'),
                    color: TossColors.gray500,
                    size: TossSpacing.iconSM,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: TossSpacing.buttonHeightSM,
                    minHeight: TossSpacing.buttonHeightSM,
                  ),
                ),
              if (onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    IconMapper.getIcon('trash'),
                    color: TossColors.error,
                    size: TossSpacing.iconSM,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: TossSpacing.buttonHeightSM,
                    minHeight: TossSpacing.buttonHeightSM,
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
