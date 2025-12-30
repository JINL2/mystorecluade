import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Timeline widget for recent activities
class TradeTimelineWidget extends StatelessWidget {
  final List<RecentActivity> activities;
  final bool showDate;
  final int? maxItems;
  final VoidCallback? onViewAll;

  const TradeTimelineWidget({
    super.key,
    required this.activities,
    this.showDate = true,
    this.maxItems,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final displayActivities = maxItems != null
        ? activities.take(maxItems!).toList()
        : activities;

    if (displayActivities.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...displayActivities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == displayActivities.length - 1;

          return TradeTimelineItem(
            activity: activity,
            isLast: isLast,
            showDate: showDate,
          );
        }),
        if (onViewAll != null && activities.length > (maxItems ?? activities.length))
          Padding(
            padding: const EdgeInsets.only(
              left: 48,
              top: TossSpacing.space2,
            ),
            child: TextButton(
              onPressed: onViewAll,
              child: Text(
                'View all ${activities.length} activities',
                style: TossTextStyles.bodySmall.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.history_outlined,
              size: 48,
              color: TossColors.gray300,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'No recent activity',
              style: TossTextStyles.bodyMedium.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single timeline item
class TradeTimelineItem extends StatelessWidget {
  final RecentActivity activity;
  final bool isLast;
  final bool showDate;
  final VoidCallback? onTap;

  const TradeTimelineItem({
    super.key,
    required this.activity,
    this.isLast = false,
    this.showDate = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getActionColor(),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getActionColor().withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: TossColors.gray200,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : TossSpacing.space4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getEntityTypeColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                          ),
                          child: Text(
                            activity.entityType.toUpperCase(),
                            style: TossTextStyles.caption.copyWith(
                              color: _getEntityTypeColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space2),
                        if (activity.entityNumber != null)
                          Text(
                            activity.entityNumber!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        const Spacer(),
                        if (showDate)
                          Text(
                            _formatTimeAgo(activity.createdAt),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray400,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: TossSpacing.space1),
                    Text(
                      activity.description,
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (activity.performedBy != null) ...[
                      const SizedBox(height: TossSpacing.space1),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: TossColors.gray400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            activity.performedBy!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor() {
    switch (activity.action.toLowerCase()) {
      case 'created':
        return TossColors.success;
      case 'updated':
        return TossColors.info;
      case 'approved':
        return TossColors.success;
      case 'rejected':
        return TossColors.error;
      case 'submitted':
        return TossColors.primary;
      case 'cancelled':
        return TossColors.gray500;
      case 'completed':
        return TossColors.success;
      default:
        return TossColors.gray400;
    }
  }

  Color _getEntityTypeColor() {
    switch (activity.entityType.toLowerCase()) {
      case 'pi':
      case 'proforma_invoice':
        return TossColors.info;
      case 'po':
      case 'purchase_order':
        return TossColors.primary;
      case 'lc':
      case 'letter_of_credit':
        return TossColors.success;
      case 'shipment':
        return TossColors.warning;
      case 'ci':
      case 'commercial_invoice':
        return TossColors.error;
      default:
        return TossColors.gray600;
    }
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

/// Compact activity item for list view
class TradeActivityListItem extends StatelessWidget {
  final RecentActivity activity;
  final VoidCallback? onTap;

  const TradeActivityListItem({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TossColors.gray100,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _getActionColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                _getActionIcon(),
                color: _getActionColor(),
                size: 18,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        activity.entityType.toUpperCase(),
                        style: TossTextStyles.caption.copyWith(
                          color: _getEntityTypeColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (activity.entityNumber != null) ...[
                        const SizedBox(width: TossSpacing.space1),
                        Text(
                          activity.entityNumber!,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Text(
              _formatTimeAgo(activity.createdAt),
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getActionColor() {
    switch (activity.action.toLowerCase()) {
      case 'created':
        return TossColors.success;
      case 'updated':
        return TossColors.info;
      case 'approved':
        return TossColors.success;
      case 'rejected':
        return TossColors.error;
      case 'submitted':
        return TossColors.primary;
      case 'cancelled':
        return TossColors.gray500;
      case 'completed':
        return TossColors.success;
      default:
        return TossColors.gray400;
    }
  }

  IconData _getActionIcon() {
    switch (activity.action.toLowerCase()) {
      case 'created':
        return Icons.add_circle_outline;
      case 'updated':
        return Icons.edit_outlined;
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'submitted':
        return Icons.send_outlined;
      case 'cancelled':
        return Icons.block_outlined;
      case 'completed':
        return Icons.task_alt_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getEntityTypeColor() {
    switch (activity.entityType.toLowerCase()) {
      case 'pi':
      case 'proforma_invoice':
        return TossColors.info;
      case 'po':
      case 'purchase_order':
        return TossColors.primary;
      case 'lc':
      case 'letter_of_credit':
        return TossColors.success;
      case 'shipment':
        return TossColors.warning;
      case 'ci':
      case 'commercial_invoice':
        return TossColors.error;
      default:
        return TossColors.gray600;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
