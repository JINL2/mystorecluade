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
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space5),
      color: TossColors.gray50,
      child: Row(
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
              'Total Qty',
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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space4,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray100),
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
                      Text(
                        item.productName,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.textPrimary,
                        ),
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
                    Row(
                      children: [
                        Text(
                          'Qty: ',
                          style: TossTextStyles.bodySmall.copyWith(
                            color: TossColors.textTertiary,
                          ),
                        ),
                        Text(
                          '${item.totalQuantity}',
                          style: TossTextStyles.body.copyWith(
                            fontWeight: FontWeight.w700,
                            color: TossColors.success,
                          ),
                        ),
                      ],
                    ),
                    if (item.totalRejected > 0)
                      Row(
                        children: [
                          Text(
                            'Rejected: ',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.textTertiary,
                            ),
                          ),
                          Text(
                            '${item.totalRejected}',
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
