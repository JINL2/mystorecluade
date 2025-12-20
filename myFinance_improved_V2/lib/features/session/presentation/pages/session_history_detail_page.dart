import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../domain/entities/session_history_item.dart';

/// Session history detail page - view all details of a past session
class SessionHistoryDetailPage extends StatelessWidget {
  final SessionHistoryItem session;

  const SessionHistoryDetailPage({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TossAppBar1(
        title: session.sessionName,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session info header
            _buildSessionHeader(),
            const Divider(height: 1),

            // Statistics summary
            _buildStatisticsSummary(),
            const Divider(height: 1),

            // Merge info section (if merged session)
            if (session.hasMergeInfo) ...[
              _buildMergeInfoSection(),
              const Divider(height: 1),
            ],

            // Receiving info section (if receiving session with stock snapshot)
            if (session.hasReceivingInfo) ...[
              _buildReceivingInfoSection(),
              const Divider(height: 1),
            ],

            // Members section
            _buildMembersSection(),
            const Divider(height: 1),

            // Items section
            _buildItemsSection(),

            // Bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + TossSpacing.space6),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    final isCounting = session.sessionType == 'counting';
    final typeColor = isCounting ? TossColors.primary : TossColors.success;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge and status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCounting ? Icons.inventory_2_outlined : Icons.local_shipping_outlined,
                      size: 14,
                      color: typeColor,
                    ),
                    const SizedBox(width: TossSpacing.space1),
                    Text(
                      isCounting ? 'Counting' : 'Receiving',
                      style: TossTextStyles.caption.copyWith(
                        color: typeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: TossSpacing.space4),

          // Store info
          _buildInfoRow(
            Icons.store_outlined,
            'Store',
            session.storeName,
          ),
          const SizedBox(height: TossSpacing.space3),

          // Shipment info (for receiving)
          if (session.shipmentNumber != null) ...[
            _buildInfoRow(
              Icons.local_shipping_outlined,
              'Shipment',
              session.shipmentNumber!,
            ),
            const SizedBox(height: TossSpacing.space3),
          ],

          // Creator info
          _buildInfoRow(
            Icons.person_outline,
            'Created by',
            session.createdByName,
          ),
          const SizedBox(height: TossSpacing.space3),

          // Time info
          _buildInfoRow(
            Icons.access_time,
            'Started',
            _formatDateTime(session.createdAt),
          ),
          if (session.completedAt != null) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildInfoRow(
              Icons.check_circle_outline,
              'Completed',
              _formatDateTime(session.completedAt!),
            ),
          ],
          if (session.durationMinutes != null) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildInfoRow(
              Icons.timer_outlined,
              'Duration',
              _formatDuration(session.durationMinutes!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: TossColors.textTertiary),
        const SizedBox(width: TossSpacing.space2),
        Text(
          '$label: ',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.textTertiary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.bodySmall.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String label;

    if (session.isFinal) {
      bgColor = TossColors.success.withValues(alpha: 0.1);
      textColor = TossColors.success;
      label = 'Finalized';
    } else if (session.isActive) {
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
        style: TossTextStyles.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildStatisticsSummary() {
    final hasConfirmed = session.hasConfirmed;

    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      color: TossColors.gray50,
      child: Column(
        children: [
          // Main stats row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Products',
                  session.totalItemsCount.toString(),
                  Icons.inventory_2_outlined,
                  TossColors.primary,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStatCard(
                  hasConfirmed ? 'Confirmed' : 'Scanned',
                  session.totalQuantity.toString(),
                  Icons.numbers,
                  TossColors.success,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStatCard(
                  'Rejected',
                  session.totalRejected.toString(),
                  Icons.error_outline,
                  TossColors.error,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: _buildStatCard(
                  'Members',
                  session.memberCount.toString(),
                  Icons.group_outlined,
                  TossColors.info,
                ),
              ),
            ],
          ),

          // Show scanned vs confirmed comparison if finalized
          if (hasConfirmed && session.totalScannedQuantity != session.totalConfirmedQuantity) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit, size: 16, color: TossColors.primary),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Manager adjusted: ',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${session.totalScannedQuantity} → ${session.totalConfirmedQuantity}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      '${(session.totalConfirmedQuantity ?? 0) - session.totalScannedQuantity >= 0 ? '+' : ''}${(session.totalConfirmedQuantity ?? 0) - session.totalScannedQuantity}',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Show difference for counting sessions
          if (session.isCounting && session.totalDifference != null) ...[
            const SizedBox(height: TossSpacing.space3),
            Container(
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(
                  color: session.totalDifference! < 0
                      ? TossColors.error.withValues(alpha: 0.3)
                      : session.totalDifference! > 0
                          ? TossColors.success.withValues(alpha: 0.3)
                          : TossColors.gray200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    session.totalDifference! < 0
                        ? Icons.trending_down
                        : session.totalDifference! > 0
                            ? Icons.trending_up
                            : Icons.check_circle_outline,
                    size: 16,
                    color: session.totalDifference! < 0
                        ? TossColors.error
                        : session.totalDifference! > 0
                            ? TossColors.success
                            : TossColors.textSecondary,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Stock Difference: ',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${session.totalDifference! >= 0 ? '+' : ''}${session.totalDifference}',
                    style: TossTextStyles.caption.copyWith(
                      color: session.totalDifference! < 0
                          ? TossColors.error
                          : session.totalDifference! > 0
                              ? TossColors.success
                              : TossColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReceivingInfoSection() {
    final receivingInfo = session.receivingInfo!;
    final newProducts = receivingInfo.newProducts;
    final restockProducts = receivingInfo.restockProducts;

    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.inventory_2,
                    size: 18,
                    color: TossColors.success,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Stock Update',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Receiving #${receivingInfo.receivingNumber}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // Summary badges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Row(
              children: [
                if (newProducts.isNotEmpty)
                  _buildStockSummaryBadge(
                    icon: Icons.fiber_new,
                    label: 'New Products',
                    count: newProducts.length,
                    color: TossColors.warning,
                  ),
                if (newProducts.isNotEmpty && restockProducts.isNotEmpty)
                  const SizedBox(width: TossSpacing.space2),
                if (restockProducts.isNotEmpty)
                  _buildStockSummaryBadge(
                    icon: Icons.replay,
                    label: 'Restock',
                    count: restockProducts.length,
                    color: TossColors.success,
                  ),
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // New Products section
          if (newProducts.isNotEmpty) ...[
            _buildStockCategoryCard(
              title: 'New Products',
              subtitle: 'First time in stock',
              icon: Icons.fiber_new,
              color: TossColors.warning,
              items: newProducts,
            ),
          ],

          // Restock Products section
          if (restockProducts.isNotEmpty) ...[
            _buildStockCategoryCard(
              title: 'Restocked Products',
              subtitle: 'Added to existing stock',
              icon: Icons.replay,
              color: TossColors.success,
              items: restockProducts,
            ),
          ],

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  Widget _buildStockSummaryBadge({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: TossSpacing.space1),
          Text(
            '$count $label',
            style: TossTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<StockSnapshotItem> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildStockSnapshotItemRow(item, color);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStockSnapshotItemRow(StockSnapshotItem item, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SKU: ${item.sku}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Stock change indicator
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${item.quantityBefore}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 10, color: TossColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  '${item.quantityAfter}',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          // Received quantity
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              '+${item.quantityReceived}',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMergeInfoSection() {
    final mergeInfo = session.mergeInfo!;
    final originalSession = mergeInfo.originalSession;
    final mergedSessions = mergeInfo.mergedSessions;

    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.merge_type,
                    size: 18,
                    color: TossColors.info,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Merged Session',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${mergeInfo.totalMergedSessionsCount + 1} sessions',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Total summary after merge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.success.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
              border: Border.all(color: TossColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 18, color: TossColors.success),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Total after merge: ',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                Text(
                  '${session.totalQuantity} items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.success,
                  ),
                ),
                if (session.totalRejected > 0) ...[
                  Text(
                    ' (${session.totalRejected} rejected)',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: TossSpacing.space3),

          // Original session (this session's items before merge)
          _buildMergeSessionCard(
            sessionName: session.sessionName,
            isOriginal: true,
            items: originalSession.items,
            totalQuantity: originalSession.totalQuantity,
            totalRejected: originalSession.totalRejected,
          ),

          // Merged sessions
          ...mergedSessions.map(
            (mergedSession) => _buildMergeSessionCard(
              sessionName: mergedSession.sourceSessionName,
              isOriginal: false,
              items: mergedSession.items,
              totalQuantity: mergedSession.totalQuantity,
              totalRejected: mergedSession.totalRejected,
              createdBy: mergedSession.sourceCreatedBy,
            ),
          ),

          const SizedBox(height: TossSpacing.space3),
        ],
      ),
    );
  }

  Widget _buildMergeSessionCard({
    required String sessionName,
    required bool isOriginal,
    required List<MergedSessionItem> items,
    required int totalQuantity,
    required int totalRejected,
    SessionHistoryUser? createdBy,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: isOriginal ? TossColors.primary.withValues(alpha: 0.03) : TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: isOriginal ? TossColors.primary.withValues(alpha: 0.3) : TossColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session header
          Container(
            padding: const EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: isOriginal ? TossColors.primary.withValues(alpha: 0.08) : TossColors.gray100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TossBorderRadius.md - 1),
                topRight: Radius.circular(TossBorderRadius.md - 1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isOriginal ? Icons.star : Icons.merge_type,
                  size: 16,
                  color: isOriginal ? TossColors.primary : TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              sessionName,
                              style: TossTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isOriginal ? TossColors.primary : TossColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isOriginal) ...[
                            const SizedBox(width: TossSpacing.space2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.primary,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                'Original',
                                style: TossTextStyles.caption.copyWith(
                                  color: TossColors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (createdBy != null)
                        Text(
                          '${createdBy.firstName} ${createdBy.lastName}'.trim().isEmpty
                              ? 'by Unknown'
                              : 'by ${createdBy.firstName} ${createdBy.lastName}'.trim(),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.white,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$totalQuantity',
                        style: TossTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: TossColors.success,
                        ),
                      ),
                      if (totalRejected > 0) ...[
                        Text(
                          ' / ',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        Text(
                          '$totalRejected',
                          style: TossTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Items list
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Text(
                'No items',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 12, endIndent: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildMergedItemRow(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMergedItemRow(MergedSessionItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.sku.isNotEmpty)
                  Text(
                    'SKU: ${item.sku}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.quantity}',
                style: TossTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.success,
                ),
              ),
              if (item.quantityRejected > 0) ...[
                Text(
                  ' / ',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
                Text(
                  '${item.quantityRejected}',
                  style: TossTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.error,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: TossSpacing.space1),
          Text(
            value,
            style: TossTextStyles.h4.copyWith(
              color: TossColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.textTertiary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.group_outlined,
                  size: 20,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Members',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${session.members.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (session.members.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Center(
                child: Text(
                  'No members',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: session.members.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final member = session.members[index];
                return _buildMemberTile(member);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(SessionHistoryMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space5,
        vertical: TossSpacing.space3,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TossColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.userName.isNotEmpty ? member.userName[0].toUpperCase() : '?',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.userName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Joined: ${_formatDateTime(member.joinedAt)}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (member.isActive)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: TossColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                'Active',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.success,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      color: TossColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              TossSpacing.space5,
              TossSpacing.space4,
              TossSpacing.space5,
              TossSpacing.space3,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: TossColors.textSecondary,
                ),
                const SizedBox(width: TossSpacing.space2),
                Text(
                  'Items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Text(
                    '${session.items.length}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (session.items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space5),
              child: Center(
                child: Text(
                  'No items scanned',
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: session.items.length,
              itemBuilder: (context, index) {
                final item = session.items[index];
                return _buildItemCard(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildItemCard(SessionHistoryItemDetail item) {
    final hasConfirmed = item.hasConfirmed;
    final wasEdited = item.wasEdited;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(
          color: wasEdited ? TossColors.primary.withValues(alpha: 0.3) : TossColors.gray100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product info header
          Padding(
            padding: const EdgeInsets.all(TossSpacing.space4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.productName,
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.textPrimary,
                              ),
                            ),
                          ),
                          if (wasEdited)
                            Container(
                              margin: const EdgeInsets.only(left: TossSpacing.space2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.edit, size: 10, color: TossColors.primary),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Edited',
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.primary,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (item.sku != null && item.sku!.isNotEmpty)
                        Text(
                          'SKU: ${item.sku}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Show final quantity (confirmed if available)
                    Row(
                      children: [
                        Text(
                          hasConfirmed ? 'Confirmed: ' : 'Qty: ',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        Text(
                          '${item.finalQuantity}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: wasEdited ? TossColors.primary : TossColors.success,
                          ),
                        ),
                      ],
                    ),
                    // Show scanned if different from confirmed
                    if (wasEdited)
                      Row(
                        children: [
                          Text(
                            'Scanned: ',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                            ),
                          ),
                          Text(
                            '${item.scannedQuantity}',
                            style: TossTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w500,
                              color: TossColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    if (item.finalRejected > 0)
                      Row(
                        children: [
                          Text(
                            'Rejected: ',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                            ),
                          ),
                          Text(
                            '${item.finalRejected}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.error,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Counting specific: Expected vs Difference
          if (session.isCounting && item.quantityExpected != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              decoration: const BoxDecoration(
                color: TossColors.white,
                border: Border(
                  top: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Expected: ${item.quantityExpected}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (item.quantityDifference != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TossSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: item.quantityDifference! < 0
                            ? TossColors.error.withValues(alpha: 0.1)
                            : item.quantityDifference! > 0
                                ? TossColors.success.withValues(alpha: 0.1)
                                : TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      ),
                      child: Text(
                        'Diff: ${item.quantityDifference! >= 0 ? '+' : ''}${item.quantityDifference}',
                        style: TossTextStyles.caption.copyWith(
                          color: item.quantityDifference! < 0
                              ? TossColors.error
                              : item.quantityDifference! > 0
                                  ? TossColors.success
                                  : TossColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Scanned by breakdown
          if (item.scannedBy.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              decoration: const BoxDecoration(
                color: TossColors.white,
                border: Border(
                  top: BorderSide(color: TossColors.gray100),
                ),
              ),
              child: Text(
                'Scanned by',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...item.scannedBy.map((scanner) => _buildScannerRow(scanner)),
          ],
        ],
      ),
    );
  }

  Widget _buildScannerRow(ScannedByInfo scanner) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray50),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: TossColors.gray100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                scanner.userName.isNotEmpty ? scanner.userName[0].toUpperCase() : '?',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              scanner.userName,
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${scanner.quantity}',
            style: TossTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.success,
            ),
          ),
          if (scanner.quantityRejected > 0) ...[
            Text(
              ' / ',
              style: TossTextStyles.bodySmall.copyWith(
                color: TossColors.textTertiary,
              ),
            ),
            Text(
              '${scanner.quantityRejected}',
              style: TossTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    final date = DateTime.tryParse(dateString);
    if (date == null) return dateString;

    final now = DateTime.now();
    final diff = now.difference(date);

    String timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

    if (diff.inDays == 0) {
      return 'Today $timeStr';
    } else if (diff.inDays == 1) {
      return 'Yesterday $timeStr';
    } else {
      return '${date.month}/${date.day}/${date.year} $timeStr';
    }
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours hr';
    }
    return '$hours hr $mins min';
  }
}
