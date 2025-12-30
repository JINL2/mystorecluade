import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';

/// Deadline countdown card for important dates
class TradeDeadlineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime deadline;
  final IconData icon;
  final VoidCallback? onTap;
  final String? entityNumber;

  const TradeDeadlineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.deadline,
    required this.icon,
    this.onTap,
    this.entityNumber,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = _calculateDaysRemaining();
    final urgencyColor = _getUrgencyColor(daysRemaining);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: urgencyColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: urgencyColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: urgencyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    icon,
                    color: urgencyColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (entityNumber != null)
                        Text(
                          entityNumber!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildCountdownBadge(daysRemaining, urgencyColor),
              ],
            ),
            const SizedBox(height: TossSpacing.space3),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 16,
                    color: urgencyColor,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray700,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(deadline),
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: urgencyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownBadge(int daysRemaining, Color color) {
    String text;
    if (daysRemaining < 0) {
      text = 'Overdue\n${daysRemaining.abs()}d';
    } else if (daysRemaining == 0) {
      text = 'Due\nToday';
    } else {
      text = '$daysRemaining\ndays';
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TossTextStyles.caption.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  int _calculateDaysRemaining() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineDate.difference(today).inDays;
  }

  Color _getUrgencyColor(int daysRemaining) {
    if (daysRemaining < 0) {
      return TossColors.error;
    } else if (daysRemaining <= 3) {
      return TossColors.error;
    } else if (daysRemaining <= 7) {
      return TossColors.warning;
    } else if (daysRemaining <= 14) {
      return TossColors.info;
    } else {
      return TossColors.success;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Compact deadline chip for inline display
class TradeDeadlineChip extends StatelessWidget {
  final DateTime deadline;
  final String? label;

  const TradeDeadlineChip({
    super.key,
    required this.deadline,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = _calculateDaysRemaining();
    final color = _getUrgencyColor(daysRemaining);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            daysRemaining < 0
                ? Icons.warning_amber_rounded
                : Icons.schedule_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDeadlineText(daysRemaining),
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDaysRemaining() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    return deadlineDate.difference(today).inDays;
  }

  Color _getUrgencyColor(int daysRemaining) {
    if (daysRemaining < 0) {
      return TossColors.error;
    } else if (daysRemaining <= 3) {
      return TossColors.error;
    } else if (daysRemaining <= 7) {
      return TossColors.warning;
    } else {
      return TossColors.success;
    }
  }

  String _formatDeadlineText(int daysRemaining) {
    if (daysRemaining < 0) {
      return 'Overdue ${daysRemaining.abs()}d';
    } else if (daysRemaining == 0) {
      return 'Due today';
    } else if (daysRemaining == 1) {
      return 'Due tomorrow';
    } else {
      return '${label ?? 'Due'} in ${daysRemaining}d';
    }
  }
}

/// Expiry calendar item for dashboard
class TradeExpiryCalendarItem extends StatelessWidget {
  final String title;
  final String entityType;
  final String entityNumber;
  final DateTime expiryDate;
  final VoidCallback? onTap;

  const TradeExpiryCalendarItem({
    super.key,
    required this.title,
    required this.entityType,
    required this.entityNumber,
    required this.expiryDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = _calculateDaysRemaining();
    final color = _getUrgencyColor(daysRemaining);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: TossSpacing.space1),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Column(
                children: [
                  Text(
                    _getMonthAbbr(expiryDate.month),
                    style: TossTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    expiryDate.day.toString(),
                    style: TossTextStyles.h3.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: TossColors.gray100,
                          borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                        ),
                        child: Text(
                          entityType,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        entityNumber,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TradeDeadlineChip(deadline: expiryDate),
          ],
        ),
      ),
    );
  }

  int _calculateDaysRemaining() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return deadlineDate.difference(today).inDays;
  }

  Color _getUrgencyColor(int daysRemaining) {
    if (daysRemaining < 0) {
      return TossColors.error;
    } else if (daysRemaining <= 3) {
      return TossColors.error;
    } else if (daysRemaining <= 7) {
      return TossColors.warning;
    } else {
      return TossColors.success;
    }
  }

  String _getMonthAbbr(int month) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
                    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[month - 1];
  }
}
