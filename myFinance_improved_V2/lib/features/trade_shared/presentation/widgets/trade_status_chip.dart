import 'package:flutter/material.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_spacing.dart';

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
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);
    final displayName = _formatStatusName(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? TossSpacing.space2 : TossSpacing.space3,
        vertical: compact ? TossSpacing.space1 : TossSpacing.space1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
            SizedBox(width: compact ? TossSpacing.space1 : TossSpacing.space1),
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

  /// Get color using TossColors
  static Color _getStatusColor(String status) {
    final s = status.toLowerCase();

    // Success states
    if (s.contains('paid') ||
        s.contains('completed') ||
        s.contains('delivered') ||
        s.contains('accepted') ||
        s.contains('converted')) {
      return TossColors.success;
    }

    // Error states
    if (s.contains('rejected') ||
        s.contains('cancelled') ||
        s.contains('expired') ||
        s.contains('discrepancy') ||
        s.contains('failed')) {
      return TossColors.error;
    }

    // Warning states
    if (s.contains('pending') ||
        s.contains('waiting') ||
        s.contains('negotiating') ||
        s.contains('amendment') ||
        s.contains('examination') ||
        s.contains('review')) {
      return TossColors.warning;
    }

    // In Progress states
    if (s.contains('sent') ||
        s.contains('confirmed') ||
        s.contains('issued') ||
        s.contains('advised') ||
        s.contains('production') ||
        s.contains('transit') ||
        s.contains('shipped') ||
        s.contains('submitted') ||
        s.contains('booked') ||
        s.contains('loaded') ||
        s.contains('departed')) {
      return TossColors.primary;
    }

    // Default (draft, etc.)
    return TossColors.gray600;
  }

  static IconData _getStatusIcon(String status) {
    final s = status.toLowerCase();

    if (s.contains('draft')) return Icons.edit_note;
    if (s.contains('sent')) return Icons.send;
    if (s.contains('accepted') || s.contains('confirmed')) return Icons.check_circle;
    if (s.contains('rejected') || s.contains('cancelled')) return Icons.cancel;
    if (s.contains('expired')) return Icons.timer_off;
    if (s.contains('pending') || s.contains('waiting')) return Icons.hourglass_empty;
    if (s.contains('shipped') || s.contains('transit')) return Icons.local_shipping;
    if (s.contains('delivered')) return Icons.inventory;
    if (s.contains('paid')) return Icons.paid;
    if (s.contains('discrepancy')) return Icons.warning_amber;
    if (s.contains('production')) return Icons.precision_manufacturing;
    if (s.contains('examination') || s.contains('review')) return Icons.search;
    if (s.contains('document')) return Icons.description;

    return Icons.circle;
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
    final color = TradeStatusChip._getStatusColor(status);
    final icon = TradeStatusChip._getStatusIcon(status);
    final displayName = _formatStatusName(status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
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
                    SizedBox(height: TossSpacing.space1 / 2),
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
    final color = TradeStatusChip._getStatusColor(status);
    final displayName = _formatStatusName(status);

    return FilterChip(
      label: Text(displayName),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : TossColors.gray600,
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? color.withValues(alpha: 0.5) : TossColors.gray300,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space1,
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
