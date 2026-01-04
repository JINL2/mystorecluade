// lib/features/report_control/presentation/pages/templates/daily_attendance/widgets/action_items_section.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../../../shared/themes/toss_shadows.dart';
import '../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';

/// Action Items Section
class ActionItemsSection extends StatefulWidget {
  final List<UrgentAction> actions;

  const ActionItemsSection({
    super.key,
    required this.actions,
  });

  @override
  State<ActionItemsSection> createState() => _ActionItemsSectionState();
}

class _ActionItemsSectionState extends State<ActionItemsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.paddingLG),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
        boxShadow: TossShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: TossColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    LucideIcons.clipboardCheck,
                    size: TossSpacing.iconSM,
                    color: TossColors.primary,
                  ),
                ),
                SizedBox(width: TossSpacing.gapMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Action Items',
                        style: TossTextStyles.h4.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                      SizedBox(height: TossSpacing.space1),
                      Text(
                        '${widget.actions.length} tasks',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.gray600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: TossColors.gray600,
                  size: TossSpacing.iconSM,
                ),
              ],
            ),
          ),

          // Actions List
          if (_isExpanded) ...[
            SizedBox(height: TossSpacing.gapLG),
            ...widget.actions.asMap().entries.map((entry) {
              final index = entry.key;
              final action = entry.value;
              return _buildActionItem(action, index);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildActionItem(UrgentAction action, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: TossSpacing.space2),
      padding: EdgeInsets.all(TossSpacing.paddingSM),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${index + 1}',
              style: TossTextStyles.labelMedium.copyWith(
                color: TossColors.primary,
              ),
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee + Store info
                Row(
                  children: [
                    Icon(
                      LucideIcons.user,
                      size: 12,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      action.employee,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: TossSpacing.space2),
                    Icon(
                      LucideIcons.store,
                      size: 12,
                      color: TossColors.gray500,
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        action.store,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: TossSpacing.space1),
                // Issue type
                Text(
                  '${action.issue}: ${action.action}',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
