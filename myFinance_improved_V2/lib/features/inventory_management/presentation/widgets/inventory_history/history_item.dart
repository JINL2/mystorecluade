import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../domain/repositories/inventory_repository.dart';

/// Transaction type for display purposes
enum HistoryTransactionType {
  moveStock,
  stockIn,
  editStock,
  sell,
}

/// Widget for displaying a single history item in the inventory history list
class HistoryItem extends StatelessWidget {
  final InventoryHistoryEntry entry;

  const HistoryItem({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final eventType = _parseEventType(entry.eventType);
    final isTransfer = entry.eventType == 'stock_transfer_out' ||
        entry.eventType == 'stock_transfer_in';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          _buildProductImage(),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  entry.productName ?? 'Unknown Product',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // SKU
                if (entry.productSku != null && entry.productSku!.isNotEmpty)
                  Text(
                    entry.productSku!,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                const SizedBox(height: 4),
                // Event type with icon
                Row(
                  children: [
                    Icon(
                      _getTransactionIcon(eventType),
                      size: 14,
                      color: TossColors.gray600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTransactionTitle(eventType),
                      style: TossTextStyles.bodySmall.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Date and time
                Text(
                  _formatCreatedAt(entry.createdAt),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                // Location info for transfers
                if (isTransfer &&
                    entry.fromStoreName != null &&
                    entry.toStoreName != null)
                  _buildTransferInfo(),
                // User info
                if (entry.createdUser != null && entry.createdUser!.isNotEmpty)
                  _buildUserInfo(),
              ],
            ),
          ),
          // Quantity change - only show if quantity changed
          if (entry.quantityBefore != null &&
              entry.quantityAfter != null &&
              entry.quantityBefore != entry.quantityAfter)
            _buildQuantityChange(),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: TossColors.gray100,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        image: entry.productImage != null
            ? DecorationImage(
                image: NetworkImage(entry.productImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: entry.productImage == null
          ? const Center(
              child: Icon(
                Icons.inventory_2_outlined,
                size: 24,
                color: TossColors.gray400,
              ),
            )
          : null,
    );
  }

  Widget _buildTransferInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Text(
            entry.fromStoreName ?? '',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.arrow_forward,
            size: 12,
            color: TossColors.gray500,
          ),
          const SizedBox(width: 4),
          Text(
            entry.toStoreName ?? '',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              shape: BoxShape.circle,
              image: entry.createdUserProfileImage != null
                  ? DecorationImage(
                      image: NetworkImage(entry.createdUserProfileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: entry.createdUserProfileImage == null
                ? Center(
                    child: Text(
                      entry.createdUser!.isNotEmpty
                          ? entry.createdUser![0].toUpperCase()
                          : 'U',
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: TossColors.gray600,
                        fontSize: 10,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            entry.createdUser!,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityChange() {
    final isIncrease = entry.quantityAfter! > entry.quantityBefore!;
    final changeColor = isIncrease ? TossColors.primary : TossColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Before quantity (gray, on top)
        Text(
          '${entry.quantityBefore}',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray500,
          ),
        ),
        const SizedBox(height: 4),
        // After quantity with arrow (colored, below)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.arrow_forward,
              size: 14,
              color: changeColor,
            ),
            const SizedBox(width: 4),
            Text(
              '${entry.quantityAfter}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: changeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  HistoryTransactionType _parseEventType(String eventType) {
    switch (eventType) {
      case 'stock_sale':
        return HistoryTransactionType.sell;
      case 'stock_refund':
        return HistoryTransactionType.stockIn;
      case 'stock_receipt':
        return HistoryTransactionType.stockIn;
      case 'stock_transfer_out':
      case 'stock_transfer_in':
        return HistoryTransactionType.moveStock;
      case 'stock_adjustment':
        return HistoryTransactionType.editStock;
      default:
        return HistoryTransactionType.editStock;
    }
  }

  IconData _getTransactionIcon(HistoryTransactionType type) {
    switch (type) {
      case HistoryTransactionType.moveStock:
        return Icons.swap_horiz;
      case HistoryTransactionType.stockIn:
        return Icons.download_outlined;
      case HistoryTransactionType.editStock:
        return Icons.edit_outlined;
      case HistoryTransactionType.sell:
        return Icons.shopping_bag_outlined;
    }
  }

  String _getTransactionTitle(HistoryTransactionType type) {
    switch (type) {
      case HistoryTransactionType.moveStock:
        return 'Move Stock';
      case HistoryTransactionType.stockIn:
        return 'Stock In';
      case HistoryTransactionType.editStock:
        return 'Edit Stock';
      case HistoryTransactionType.sell:
        return 'Sell';
    }
  }

  /// Format created_at string from RPC (format: 'YYYY-MM-DD HH24:MI:SS')
  /// to user-friendly format (e.g., 'Oct 12 · 14:32')
  String _formatCreatedAt(String createdAt) {
    try {
      // Parse the datetime string from RPC
      final parts = createdAt.split(' ');
      if (parts.length != 2) return createdAt;

      final dateParts = parts[0].split('-');
      final timeParts = parts[1].split(':');

      if (dateParts.length != 3 || timeParts.length < 2) return createdAt;

      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);
      final hour = timeParts[0];
      final minute = timeParts[1];

      // Month names
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      final monthName = months[month - 1];
      return '$monthName $day · $hour:$minute';
    } catch (e) {
      return createdAt;
    }
  }
}
