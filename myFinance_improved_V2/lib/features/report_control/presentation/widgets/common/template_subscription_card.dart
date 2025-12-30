// lib/features/report_control/presentation/widgets/template_subscription_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/datetime_utils.dart';
import '../../../../../shared/themes/index.dart';
import '../../constants/report_strings.dart';
import '../../constants/report_icons.dart';
import '../../utils/category_utils.dart';
import '../../../domain/entities/template_with_subscription.dart';

/// Modern Toss-style template subscription card
/// Clean, minimal design matching report_notification_card.dart
class TemplateSubscriptionCard extends StatelessWidget {
  final TemplateWithSubscription template;
  final VoidCallback onTap;

  const TemplateSubscriptionCard({
    super.key,
    required this.template,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSubscribed = template.isSubscribed;
    final isActive = template.isActive;

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
          color: isSubscribed
              ? TossColors.primary.withOpacity(0.3)
              : TossColors.gray100,
          width: isSubscribed ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCategoryColor().withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Icon(
                        ReportIcons.getCategoryIcon(template.categoryName),
                        size: 20,
                        color: _getCategoryColor(),
                      ),
                    ),
                    SizedBox(width: TossSpacing.space3),

                    // Template name and frequency
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.templateName,
                            style: TossTextStyles.h4.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: TossColors.gray500,
                              ),
                              SizedBox(width: 4),
                              Text(
                                _getFrequencyLabel(template.frequency),
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.gray600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Status badge
                    _buildCompactStatusBadge(isSubscribed, isActive),
                  ],
                ),

                // Category tag
                if (template.categoryName != null) ...[
                  SizedBox(height: TossSpacing.space2),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.05),
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Text(
                      template.categoryName!,
                      style: TossTextStyles.caption.copyWith(
                        color: _getCategoryColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                // Description (compact)
                if (template.description != null) ...[
                  SizedBox(height: TossSpacing.space2),
                  Text(
                    template.description!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                // Subscription details (if subscribed) - compact version
                if (isSubscribed) ...[
                  SizedBox(height: TossSpacing.space3),
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space2),
                    decoration: BoxDecoration(
                      color: TossColors.gray50,
                      borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Schedule time
                        if (template.subscriptionScheduleTime != null)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: TossColors.primary,
                              ),
                              SizedBox(width: 4),
                              Text(
                                _convertUtcToLocalTime(template
                                    .subscriptionScheduleTime!), // ✅ Convert UTC → Local
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                        // Schedule days
                        if (template.subscriptionScheduleDays != null &&
                            template.subscriptionScheduleDays!.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Text(
                            _formatScheduleDays(
                                template.subscriptionScheduleDays!),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontSize: 11,
                            ),
                          ),
                        ],

                        // Next schedule
                        if (template.subscriptionNextScheduledAt != null) ...[
                          SizedBox(height: 4),
                          Text(
                            'Next: ${DateFormat('MMM dd, HH:mm').format(template.subscriptionNextScheduledAt!)}',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Recent reports (compact)
                  if (template.recentReportsCount != null &&
                      template.recentReportsCount! > 0) ...[
                    SizedBox(height: TossSpacing.space2),
                    Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 12,
                          color: TossColors.gray500,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${template.recentReportsCount} reports',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                            fontSize: 11,
                          ),
                        ),
                        if (template.lastReportDate != null) ...[
                          Text(
                            ' · ',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray400,
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd')
                                .format(template.lastReportDate!),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get category color based on category name (matches report_notification_card.dart)
  Color _getCategoryColor() => CategoryUtils.getCategoryColor(template.categoryName);

  /// Build compact circular status badge (matches report_notification_card.dart)
  Widget _buildCompactStatusBadge(bool isSubscribed, bool isActive) {
    IconData icon;
    Color color;

    if (!isSubscribed) {
      icon = Icons.add_circle_outline;
      color = TossColors.gray400;
    } else if (!isActive) {
      icon = Icons.pause_circle;
      color = TossColors.warning;
    } else {
      icon = Icons.check_circle;
      color = TossColors.success;
    }

    return Container(
      padding: EdgeInsets.all(TossSpacing.space2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  /// Get frequency label with fallback
  String _getFrequencyLabel(String? frequency) {
    if (frequency == null) return 'On Demand';

    final normalized = frequency.toLowerCase();
    if (normalized.contains('daily') || normalized == 'daily') {
      return ReportStrings.frequencyDaily;
    } else if (normalized.contains('weekly') || normalized == 'weekly') {
      return ReportStrings.frequencyWeekly;
    } else if (normalized.contains('monthly') || normalized == 'monthly') {
      return ReportStrings.frequencyMonthly;
    }

    return frequency;
  }

  /// Format schedule days with day abbreviations
  String _formatScheduleDays(List<int> days) {
    if (days.isEmpty) return '';

    final sortedDays = List<int>.from(days)..sort();
    return sortedDays.map((d) => ReportStrings.dayNames[d % 7]).join(', ');
  }

  /// Convert UTC time string to local time for display
  /// Example: "08:30:00" (UTC) → "17:30" (KST, UTC+9)
  String _convertUtcToLocalTime(String utcTimeString) {
    try {
      final parts = utcTimeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Create UTC DateTime from time string
      final now = DateTime.now().toUtc();
      final utcDateTime =
          DateTime.utc(now.year, now.month, now.day, hour, minute);

      // Convert to local
      final localDateTime = utcDateTime.toLocal();

      return DateTimeUtils.formatTimeOnly(localDateTime);
    } catch (e) {
      return utcTimeString; // Fallback to original
    }
  }
}
