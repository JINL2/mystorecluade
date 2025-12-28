import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/trade_alert.dart';

/// Alert list item widget
class TradeAlertListItem extends StatelessWidget {
  final TradeAlert alert;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final VoidCallback? onMarkRead;

  const TradeAlertListItem({
    super.key,
    required this.alert,
    this.onTap,
    this.onDismiss,
    this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alert.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Icon(
          Icons.delete_outline,
          color: TossColors.error,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (!alert.isRead) {
            onMarkRead?.call();
          }
          onTap?.call();
        },
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space3),
          decoration: BoxDecoration(
            color: alert.isRead ? TossColors.white : TossColors.primary.withOpacity(0.03),
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            border: Border.all(
              color: alert.isRead ? TossColors.gray200 : TossColors.primary.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriorityIndicator(),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: TossTextStyles.bodyMedium.copyWith(
                              fontWeight: alert.isRead ? FontWeight.w500 : FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!alert.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: TossColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      alert.message ?? '',
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        _buildAlertTypeChip(),
                        const Spacer(),
                        Text(
                          _formatTimeAgo(alert.createdAt),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: alert.priority.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Icon(
        alert.alertType.icon,
        color: alert.priority.color,
        size: 18,
      ),
    );
  }

  Widget _buildAlertTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.xs),
      ),
      child: Text(
        alert.alertType.label,
        style: TossTextStyles.caption.copyWith(
          color: TossColors.gray600,
          fontSize: 10,
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}

/// Compact alert card for dashboard
class TradeAlertCard extends StatelessWidget {
  final TradeAlert alert;
  final VoidCallback? onTap;

  const TradeAlertCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: alert.priority.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: alert.priority.color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              alert.alertType.icon,
              color: alert.priority.color,
              size: 20,
            ),
            const SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (alert.dueDate != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDueDate(alert.dueDate!),
                      style: TossTextStyles.caption.copyWith(
                        color: alert.priority.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: TossColors.gray400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue by ${difference.inDays.abs()} days';
    } else if (difference.inDays == 0) {
      return 'Due today';
    } else if (difference.inDays == 1) {
      return 'Due tomorrow';
    } else if (difference.inDays <= 7) {
      return 'Due in ${difference.inDays} days';
    } else {
      return 'Due ${dueDate.month}/${dueDate.day}';
    }
  }
}

/// Alert summary widget for dashboard header
class TradeAlertSummary extends StatelessWidget {
  final int totalCount;
  final int urgentCount;
  final int highCount;
  final VoidCallback? onViewAll;

  const TradeAlertSummary({
    super.key,
    required this.totalCount,
    this.urgentCount = 0,
    this.highCount = 0,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onViewAll,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space3,
          vertical: TossSpacing.space2,
        ),
        decoration: BoxDecoration(
          color: urgentCount > 0
              ? TossColors.error.withOpacity(0.1)
              : highCount > 0
                  ? TossColors.warning.withOpacity(0.1)
                  : TossColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 16,
              color: urgentCount > 0
                  ? TossColors.error
                  : highCount > 0
                      ? TossColors.warning
                      : TossColors.primary,
            ),
            const SizedBox(width: TossSpacing.space1),
            Text(
              '$totalCount alerts',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: urgentCount > 0
                    ? TossColors.error
                    : highCount > 0
                        ? TossColors.warning
                        : TossColors.primary,
              ),
            ),
            if (urgentCount > 0) ...[
              const SizedBox(width: TossSpacing.space1),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: TossColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$urgentCount urgent',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
