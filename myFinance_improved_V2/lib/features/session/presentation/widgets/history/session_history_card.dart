import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Session history card widget
class SessionHistoryCard extends StatelessWidget {
  final SessionHistoryItem session;

  const SessionHistoryCard({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final isCounting = session.sessionType == 'counting';
    final typeColor = isCounting ? TossColors.primary : TossColors.success;

    return InkWell(
      onTap: () {
        context.pushNamed('session-history-detail', extra: session);
      },
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type indicator with merge/new badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: TossSpacing.iconXXL,
                  height: TossSpacing.iconXXL,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Icon(
                    isCounting ? Icons.inventory_2_outlined : Icons.local_shipping_outlined,
                    color: typeColor,
                    size: TossSpacing.iconMD2,
                  ),
                ),
                // Merge badge (top-right)
                if (session.isMergedSession)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(TossSpacing.space1),
                      decoration: BoxDecoration(
                        color: TossColors.info,
                        shape: BoxShape.circle,
                        border: Border.all(color: TossColors.white, width: 1.5),
                      ),
                      child: const Icon(
                        Icons.merge_type,
                        size: TossSpacing.iconXXS,
                        color: TossColors.white,
                      ),
                    ),
                  ),
                // New products badge (bottom-right) - receiving only
                if (session.isReceiving && session.newProductsCount > 0)
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space1, vertical: 1),
                      decoration: BoxDecoration(
                        color: TossColors.warning,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                        border: Border.all(color: TossColors.white, width: 1.5),
                      ),
                      child: Text(
                        'NEW ${session.newProductsCount}',
                        style: TossTextStyles.micro.copyWith(
                          color: TossColors.white,
                          fontWeight: TossFontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: TossSpacing.space3),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session name and status
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                session.sessionName,
                                style: TossTextStyles.body.copyWith(
                                  fontWeight: TossFontWeight.semibold,
                                  color: TossColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Inline merge indicator
                            if (session.isMergedSession) ...[
                              const SizedBox(width: TossSpacing.space1),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: TossColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.merge_type,
                                      size: TossSpacing.iconXXS,
                                      color: TossColors.info,
                                    ),
                                    const SizedBox(width: TossSpacing.space0_5),
                                    Text(
                                      'Merged',
                                      style: TossTextStyles.micro.copyWith(
                                        color: TossColors.info,
                                        fontWeight: TossFontWeight.semibold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Store name
                  Row(
                    children: [
                      const Icon(
                        Icons.store_outlined,
                        size: TossSpacing.iconXS,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Expanded(
                        child: Text(
                          session.storeName,
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  // Meta info
                  Row(
                    children: [
                      // Created by
                      const Icon(
                        Icons.person_outline,
                        size: TossSpacing.iconXS,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        session.createdByName,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space3),
                      // Member count
                      const Icon(
                        Icons.group_outlined,
                        size: TossSpacing.iconXS,
                        color: TossColors.textTertiary,
                      ),
                      const SizedBox(width: TossSpacing.space1),
                      Text(
                        '${session.memberCount}',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                      // New/Restock info for receiving sessions
                      if (session.hasReceivingInfo) ...[
                        const SizedBox(width: TossSpacing.space3),
                        if (session.newProductsCount > 0)
                          _buildReceivingBadge(
                            icon: Icons.fiber_new,
                            count: session.newProductsCount,
                            color: TossColors.warning,
                          ),
                        if (session.restockProductsCount > 0) ...[
                          const SizedBox(width: TossSpacing.space2),
                          _buildReceivingBadge(
                            icon: Icons.replay,
                            count: session.restockProductsCount,
                            color: TossColors.success,
                          ),
                        ],
                      ],
                      const Spacer(),
                      // Date
                      Text(
                        _formatDate(session.createdAt),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chevron
            const SizedBox(width: TossSpacing.space2),
            const Icon(
              Icons.chevron_right,
              color: TossColors.textTertiary,
              size: TossSpacing.iconMD,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceivingBadge({
    required IconData icon,
    required int count,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: TossSpacing.iconXXS, color: color),
        const SizedBox(width: TossSpacing.space0_5),
        Text(
          '$count',
          style: TossTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: TossFontWeight.semibold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final isActive = session.isActive;
    final isFinal = session.isFinal;

    Color bgColor;
    Color textColor;
    String label;

    if (isFinal) {
      bgColor = TossColors.success.withValues(alpha: 0.1);
      textColor = TossColors.success;
      label = 'Finalized';
    } else if (isActive) {
      bgColor = TossColors.warning.withValues(alpha: 0.1);
      textColor = TossColors.warning;
      label = 'Active';
    } else {
      bgColor = TossColors.gray200;
      textColor = TossColors.textSecondary;
      label = 'Closed';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      ),
      child: Text(
        label,
        style: TossTextStyles.micro.copyWith(
          color: textColor,
          fontWeight: TossFontWeight.medium,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;

    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
