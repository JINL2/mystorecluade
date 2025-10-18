import 'package:flutter/material.dart';
import '../../../../core/themes/index.dart';
import '../models/product_model.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class StockMovementCard extends StatelessWidget {
  final StockMovement movement;
  final bool showDetails;
  final VoidCallback? onTap;

  const StockMovementCard({
    Key? key,
    required this.movement,
    this.showDetails = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      child: Container(
        margin: EdgeInsets.only(bottom: TossSpacing.space2),
        padding: EdgeInsets.all(TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          border: Border.all(
            color: TossColors.gray100,
          ),
        ),
        child: Row(
          children: [
            // Movement Type Icon
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: _getMovementColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Icon(
                _getMovementIcon(),
                color: _getMovementColor(),
                size: TossSpacing.iconSM,
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            
            // Movement Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _getMovementTitle(),
                        style: TossTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: TossSpacing.space2),
                      Text(
                        movement.reference ?? '',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Row(
                    children: [
                      Text(
                        _formatDate(movement.date),
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      if (showDetails) ...[
                        Text(' • ', style: TossTextStyles.body.copyWith(color: TossColors.gray400)),
                        Text(
                          movement.user ?? '',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (movement.note != null && showDetails) ...[
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      movement.note!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Quantity Change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${movement.quantity > 0 ? '+' : ''}${movement.quantity}',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: movement.quantity > 0 
                        ? TossColors.success 
                        : TossColors.error,
                  ),
                ),
                Text(
                  'Balance: ${movement.balanceAfter}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getMovementColor() {
    switch (movement.type) {
      case MovementType.sale:
        return TossColors.primary;
      case MovementType.purchase:
        return TossColors.success;
      case MovementType.adjustment:
        return TossColors.warning;
      case MovementType.stockReturn:
        return TossColors.info;
      case MovementType.transfer:
        return TossColors.gray600;
    }
  }

  IconData _getMovementIcon() {
    switch (movement.type) {
      case MovementType.sale:
        return Icons.shopping_cart;
      case MovementType.purchase:
        return Icons.inventory;
      case MovementType.adjustment:
        return Icons.tune;
      case MovementType.stockReturn:
        return Icons.undo;
      case MovementType.transfer:
        return Icons.swap_horiz;
    }
  }

  String _getMovementTitle() {
    switch (movement.type) {
      case MovementType.sale:
        return 'Sale';
      case MovementType.purchase:
        return 'Received';
      case MovementType.adjustment:
        return 'Adjustment';
      case MovementType.stockReturn:
        return 'Return';
      case MovementType.transfer:
        return 'Transfer';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}