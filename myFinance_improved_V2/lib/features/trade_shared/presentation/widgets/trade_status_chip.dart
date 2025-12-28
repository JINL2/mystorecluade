import 'package:flutter/material.dart';
import '../../domain/entities/trade_status.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';

/// Status chip widget for displaying trade entity status
class TradeStatusChip extends StatelessWidget {
  final String status;
  final bool compact;
  final bool showIcon;

  const TradeStatusChip({
    super.key,
    required this.status,
    this.compact = false,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = TradeStatus.getStatusColor(status);
    final icon = TradeStatus.getStatusIcon(status);
    final displayName = _formatStatusName(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              icon,
              size: compact ? 12 : 14,
              color: color,
            ),
            SizedBox(width: compact ? 4 : 6),
          ],
          Text(
            displayName,
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatusName(String status) {
    return status
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

/// Larger status badge with description
class TradeStatusBadge extends StatelessWidget {
  final String status;
  final String? description;
  final VoidCallback? onTap;

  const TradeStatusBadge({
    super.key,
    required this.status,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = TradeStatus.getStatusColor(status);
    final icon = TradeStatus.getStatusIcon(status);
    final displayName = _formatStatusName(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: TextStyle(
                        color: TossColors.gray600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
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

  String _formatStatusName(String status) {
    return status
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}

/// Status filter chip (selectable)
class TradeStatusFilterChip extends StatelessWidget {
  final String status;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const TradeStatusFilterChip({
    super.key,
    required this.status,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = TradeStatus.getStatusColor(status);
    final displayName = _formatStatusName(status);

    return FilterChip(
      label: Text(displayName),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : TossColors.gray600,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? color.withOpacity(0.5) : TossColors.gray300,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  String _formatStatusName(String status) {
    return status
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }
}
