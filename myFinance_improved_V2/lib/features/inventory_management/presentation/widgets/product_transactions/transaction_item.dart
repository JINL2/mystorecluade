import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../domain/repositories/inventory_repository.dart';

/// Transaction type for display purposes
enum TransactionType {
  moveStock,
  stockIn,
  editStock,
  sell,
}

/// Widget for displaying a single transaction item in the list
class TransactionItem extends StatelessWidget {
  final ProductHistoryEntry transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final eventType = _parseEventType(transaction.eventType);
    final isTransfer = transaction.eventType == 'stock_transfer_out' ||
        transaction.eventType == 'stock_transfer_in';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon - aligned with title top
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              _getTransactionIcon(eventType),
              size: 20,
              color: TossColors.gray600,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type title
                Text(
                  _getTransactionTitle(eventType),
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                // Date and time
                Text(
                  _formatCreatedAt(transaction.createdAt),
                  style: TossTextStyles.bodySmall.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                const SizedBox(height: 4),
                // Location info
                if (isTransfer &&
                    transaction.fromStoreName != null &&
                    transaction.toStoreName != null)
                  _buildTransferInfo()
                else if (transaction.notes != null &&
                    transaction.notes!.isNotEmpty)
                  Text(
                    transaction.notes!,
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                const SizedBox(height: 8),
                // User info
                if (transaction.createdUser != null &&
                    transaction.createdUser!.isNotEmpty)
                  _buildUserInfo(),
              ],
            ),
          ),
          // Quantity change - only show if quantity changed
          if (transaction.quantityBefore != null &&
              transaction.quantityAfter != null &&
              transaction.quantityBefore != transaction.quantityAfter)
            _buildQuantityChange(),
        ],
      ),
    );
  }

  Widget _buildTransferInfo() {
    return Row(
      children: [
        Text(
          transaction.fromStoreName ?? '',
          style: TossTextStyles.bodySmall.copyWith(
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
          transaction.toStoreName ?? '',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: TossColors.gray200,
            shape: BoxShape.circle,
            image: transaction.createdUserProfileImage != null
                ? DecorationImage(
                    image: NetworkImage(transaction.createdUserProfileImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: transaction.createdUserProfileImage == null
              ? Center(
                  child: Text(
                    transaction.createdUser!.isNotEmpty
                        ? transaction.createdUser![0].toUpperCase()
                        : 'U',
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray600,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          transaction.createdUser!,
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityChange() {
    final change = transaction.quantityAfter! - transaction.quantityBefore!;
    final isIncrease = change > 0;
    final changeColor = isIncrease ? TossColors.primary : TossColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Change amount (colored, prominent)
        Text(
          '${isIncrease ? '+' : ''}$change',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: changeColor,
          ),
        ),
        const SizedBox(height: 4),
        // Before → After (gray, subtle)
        Text(
          '${transaction.quantityBefore} → ${transaction.quantityAfter}',
          style: TossTextStyles.bodySmall.copyWith(
            color: TossColors.gray500,
          ),
        ),
      ],
    );
  }

  TransactionType _parseEventType(String eventType) {
    switch (eventType) {
      case 'stock_sale':
        return TransactionType.sell;
      case 'stock_refund':
        return TransactionType.stockIn;
      case 'stock_receipt':
        return TransactionType.stockIn;
      case 'stock_transfer_out':
      case 'stock_transfer_in':
        return TransactionType.moveStock;
      case 'stock_adjustment':
        return TransactionType.editStock;
      default:
        return TransactionType.editStock;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.moveStock:
        return Icons.swap_horiz;
      case TransactionType.stockIn:
        return Icons.download_outlined;
      case TransactionType.editStock:
        return Icons.edit_outlined;
      case TransactionType.sell:
        return Icons.shopping_bag_outlined;
    }
  }

  String _getTransactionTitle(TransactionType type) {
    switch (type) {
      case TransactionType.moveStock:
        return 'Move Stock';
      case TransactionType.stockIn:
        return 'Stock In';
      case TransactionType.editStock:
        return 'Edit Stock';
      case TransactionType.sell:
        return 'Sell';
    }
  }

  /// Format created_at string from RPC (format: 'YYYY-MM-DD HH24:MI:SS')
  /// to user-friendly format (e.g., 'Oct 12, 2025 · 14:32')
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
      final year = int.parse(dateParts[0]);
      final hour = timeParts[0];
      final minute = timeParts[1];

      // Month names
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];

      final monthName = months[month - 1];
      return '$monthName $day, $year · $hour:$minute';
    } catch (e) {
      return createdAt;
    }
  }
}
