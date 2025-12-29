import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/session_history_item.dart';

/// Session header section widget for history detail
class HistoryHeaderSection extends StatelessWidget {
  final SessionHistoryItem session;

  const HistoryHeaderSection({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
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
