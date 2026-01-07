import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/work_schedule_template.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Template Card Widget
///
/// Displays a work schedule template with working days and time range.
class TemplateCard extends StatelessWidget {
  final WorkScheduleTemplate template;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TemplateCard({
    super.key,
    required this.template,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TossWhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          const GrayDividerSpace(),

          // Content
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Range
                _buildTimeRange(),
                const SizedBox(height: TossSpacing.space3),

                // Working Days
                _buildWorkingDays(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(TossSpacing.space2),
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: const Icon(
              LucideIcons.calendarClock,
              color: TossColors.primary,
              size: TossSpacing.iconSM,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),

          // Title and badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        template.templateName,
                        style: TossTextStyles.bodyLarge.copyWith(
                          fontWeight: TossFontWeight.semibold,
                          color: TossColors.gray900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (template.isDefault) ...[
                      const SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: TossSpacing.space1 + 2,
                          vertical: TossSpacing.space1 / 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          'Default',
                          style: TossTextStyles.small.copyWith(
                            color: TossColors.success,
                            fontWeight: TossFontWeight.medium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: TossSpacing.space1 / 2),
                Text(
                  '${template.employeeCount} employee${template.employeeCount != 1 ? 's' : ''} assigned',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          if (onEdit != null || onDelete != null)
            PopupMenuButton<String>(
              icon: const Icon(
                LucideIcons.moreVertical,
                size: TossSpacing.iconSM,
                color: TossColors.gray500,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit?.call();
                } else if (value == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, size: TossSpacing.iconXS),
                        SizedBox(width: TossSpacing.space2),
                        const Text('Edit'),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: TossSpacing.iconXS, color: TossColors.error),
                        SizedBox(width: TossSpacing.space2),
                        const Text('Delete', style: TextStyle(color: TossColors.error)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimeRange() {
    return Row(
      children: [
        const Icon(
          LucideIcons.clock,
          size: TossSpacing.iconXS,
          color: TossColors.gray500,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          template.timeRangeText,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: TossFontWeight.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkingDays() {
    final days = [
      ('M', template.monday),
      ('T', template.tuesday),
      ('W', template.wednesday),
      ('T', template.thursday),
      ('F', template.friday),
      ('S', template.saturday),
      ('S', template.sunday),
    ];

    return Row(
      children: [
        const Icon(
          LucideIcons.calendar,
          size: TossSpacing.iconXS,
          color: TossColors.gray500,
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Wrap(
            spacing: TossSpacing.space1,
            children: days.map((day) {
              final isActive = day.$2;
              return Container(
                width: TossSpacing.space6 + TossSpacing.space1,
                height: TossSpacing.space6 + TossSpacing.space1,
                decoration: BoxDecoration(
                  color: isActive
                      ? TossColors.primary.withValues(alpha: 0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Center(
                  child: Text(
                    day.$1,
                    style: TossTextStyles.caption.copyWith(
                      color: isActive ? TossColors.primary : TossColors.gray400,
                      fontWeight: isActive ? TossFontWeight.semibold : TossFontWeight.regular,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Text(
          template.workingDaysText,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }
}
