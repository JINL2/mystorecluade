import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../../domain/entities/invoice_detail.dart';

/// View Items Card - Collapsible card showing invoice items
class ViewItemsCard extends StatefulWidget {
  final Invoice invoice;
  final InvoiceDetail? detail;
  final String currencySymbol;

  const ViewItemsCard({
    super.key,
    required this.invoice,
    this.detail,
    this.currencySymbol = '',
  });

  @override
  State<ViewItemsCard> createState() => _ViewItemsCardState();
}

class _ViewItemsCardState extends State<ViewItemsCard> {
  bool _isExpanded = true;
  static final _currencyFormat =
      NumberFormat.currency(symbol: '', decimalDigits: 0);

  String get _symbol => widget.currencySymbol;

  @override
  Widget build(BuildContext context) {
    final itemCount =
        widget.detail?.itemCount ?? widget.invoice.itemsSummary.itemCount;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
            child: Row(
              children: [
                Text(
                  'View items',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                ),
                const SizedBox(width: TossSpacing.space2),
                // Item count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: TossColors.primary,
                    borderRadius: BorderRadius.circular(TossBorderRadius.full),
                  ),
                  child: Text(
                    '$itemCount',
                    style: TossTextStyles.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: TossColors.gray600,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Expanded content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildItemsList(),
            crossFadeState:
                _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    // Use actual items from detail if available
    if (widget.detail != null && widget.detail!.items.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
        child: Column(
          children: [
            const SizedBox(height: TossSpacing.space3),
            ...widget.detail!.items.map((item) => _buildItemRow(item)),
          ],
        ),
      );
    }

    // Fallback to summary info
    final itemCount = widget.invoice.itemsSummary.itemCount;
    final totalQty = widget.invoice.itemsSummary.totalQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const SizedBox(height: TossSpacing.space3),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: TossColors.gray200,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: TossColors.gray500,
                  size: 24,
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$itemCount product${itemCount > 1 ? 's' : ''}',
                      style: TossTextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: TossColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total quantity: $totalQty',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatAmount(widget.invoice.amounts.subtotal),
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(InvoiceDetailItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image or placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              image: item.productImage != null
                  ? DecorationImage(
                      image: NetworkImage(item.productImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.productImage == null
                ? const Icon(
                    Icons.shopping_bag_outlined,
                    color: TossColors.gray500,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: TossColors.gray900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatAmount(item.unitPrice)} × ${item.quantity}',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray500,
                  ),
                ),
                if (item.discountAmount > 0)
                  Text(
                    'Discount: -${_formatAmount(item.discountAmount)}',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: TossSpacing.space2),
          Text(
            _formatAmount(item.totalPrice),
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatted = _currencyFormat.format(amount);
    if (_symbol.isEmpty || _symbol == '\$') {
      return '$formattedđ';
    }
    return '$_symbol$formatted';
  }
}
