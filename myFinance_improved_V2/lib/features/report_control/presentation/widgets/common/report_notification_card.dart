// lib/features/report_control/presentation/widgets/report_notification_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/index.dart';
import '../../constants/report_icons.dart';
import '../../utils/category_utils.dart';
import '../../../domain/entities/report_notification.dart';

/// Modern Toss-style report notification card
/// Clean, minimal design with smooth animations
class ReportNotificationCard extends StatelessWidget {
  final ReportNotification report;
  final VoidCallback onTap;

  const ReportNotificationCard({
    super.key,
    required this.report,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: TossSpacing.space4,
        right: TossSpacing.space4,
        bottom: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: report.isRead
              ? TossColors.gray100
              : TossColors.primary.withValues(alpha: TossOpacity.heavy),
          width: report.isRead ? 1 : 1.5,
        ),
      ),
      child: Material(
        color: TossColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          child: Padding(
            padding: EdgeInsets.all(TossSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Icon circle with category icon
                    Container(
                      width: TossDimensions.avatarLG,
                      height: TossDimensions.avatarLG,
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withValues(alpha: TossOpacity.light),
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Icon(
                        ReportIcons.getCategoryIcon(report.categoryName),
                        size: TossSpacing.iconMD,
                        color: _getCategoryColor(),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),
                    // Title and metadata
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  report.templateName,
                                  style: report.isRead
                                      ? TossTextStyles.bodyMedium.copyWith(
                                          color: TossColors.gray700,
                                        )
                                      : TossTextStyles.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!report.isRead) ...[
                                SizedBox(width: TossSpacing.space2),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: TossSpacing.space2,
                                    vertical: TossSpacing.space0_5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TossColors.primary,
                                    borderRadius: BorderRadius.circular(
                                        TossBorderRadius.xs),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: TossTextStyles.small.copyWith(
                                      color: TossColors.white,
                                      fontWeight: TossFontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: TossSpacing.space1),
                          // Date and time
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: TossSpacing.iconXS2,
                                color: TossColors.gray500,
                              ),
                              SizedBox(width: TossSpacing.space1),
                              Text(
                                DateFormat('MM/dd').format(report.reportDate),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: TossFontWeight.medium,
                                ),
                              ),
                              if (report.sentAt != null) ...[
                                Text(
                                  ' · ',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray400,
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(report.sentAt!),
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    _buildCompactStatusBadge(),
                  ],
                ),
                // Store info (if available)
                if (report.storeName != null) ...[
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.store_outlined,
                          size: TossSpacing.iconXS2,
                          color: TossColors.gray600,
                        ),
                        SizedBox(width: TossSpacing.space1),
                        Flexible(
                          child: Text(
                            report.storeName!,
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray700,
                              fontWeight: TossFontWeight.medium,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                // Category tag (if available)
                if (report.categoryName != null) ...[
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: TossOpacity.subtle),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      report.categoryName!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: TossFontWeight.semibold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get status color based on report state
  Color _getStatusColor() {
    if (report.isCompleted) return TossColors.success;
    if (report.isFailed) return TossColors.error;
    if (report.isPending) return TossColors.warning;
    return TossColors.gray400;
  }

  /// Get category color based on category name
  Color _getCategoryColor() => CategoryUtils.getCategoryColor(report.categoryName);

  /// Build compact status badge
  Widget _buildCompactStatusBadge() {
    IconData icon;
    Color color;

    if (report.isCompleted) {
      icon = Icons.check_circle;
      color = TossColors.success;
    } else if (report.isFailed) {
      icon = Icons.error;
      color = TossColors.error;
    } else if (report.isPending) {
      icon = Icons.schedule;
      color = TossColors.warning;
    } else {
      icon = Icons.help_outline;
      color = TossColors.gray400;
    }

    return Container(
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: TossOpacity.light),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: TossSpacing.iconSM2,
        color: color,
      ),
    );
  }
}
