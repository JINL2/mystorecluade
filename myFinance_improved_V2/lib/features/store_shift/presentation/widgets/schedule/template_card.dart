import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/work_schedule_template.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: TossColors.gray900.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          const Divider(height: 1, color: TossColors.gray200),

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
              color: TossColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              LucideIcons.calendarClock,
              color: TossColors.primary,
              size: 18,
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
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (template.isDefault) ...[
                      const SizedBox(width: TossSpacing.space2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Default',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.success,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
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
                size: 18,
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
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(LucideIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(LucideIcons.trash2, size: 16, color: TossColors.error),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: TossColors.error)),
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
          size: 16,
          color: TossColors.gray500,
        ),
        const SizedBox(width: TossSpacing.space2),
        Text(
          template.timeRangeText,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
            fontWeight: FontWeight.w500,
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
          size: 16,
          color: TossColors.gray500,
        ),
        const SizedBox(width: TossSpacing.space2),
        Expanded(
          child: Wrap(
            spacing: 4,
            children: days.map((day) {
              final isActive = day.$2;
              return Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isActive
                      ? TossColors.primary.withOpacity(0.1)
                      : TossColors.gray100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    day.$1,
                    style: TossTextStyles.caption.copyWith(
                      color: isActive ? TossColors.primary : TossColors.gray400,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
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
