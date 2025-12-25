import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../extensions/invoice_period_extension.dart';
import '../../providers/states/invoice_list_state.dart';

/// Sticky header delegate for invoice list filters
class FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final InvoiceListState invoiceState;
  final void Function(String) onFilterTap;

  FilterHeaderDelegate({
    required this.invoiceState,
    required this.onFilterTap,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterPill(
                  context,
                  'Time',
                  invoiceState.selectedPeriod.displayName,
                ),
                const SizedBox(width: 8),
                _buildFilterPill(
                  context,
                  'Cash Location',
                  invoiceState.selectedCashLocation?.name ?? 'All Locations',
                  isActive: invoiceState.selectedCashLocation != null,
                ),
                const SizedBox(width: 8),
                _buildFilterPill(
                  context,
                  'Status',
                  invoiceState.statusDisplayText,
                  isActive: invoiceState.selectedStatus != null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text with bold numbers
          RichText(
            text: TextSpan(
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
              children: [
                const TextSpan(text: 'Total invoice: '),
                TextSpan(
                  text: '${invoiceState.invoices.length} invoices',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
                const TextSpan(text: ' · Total money: '),
                TextSpan(
                  text: _formatCurrency(_calculateTotalAmount()),
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Divider
          Container(
            height: 1,
            color: TossColors.gray100,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    BuildContext context,
    String title,
    String subtitle, {
    bool isActive = false,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onFilterTap(title),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? TossColors.primary.withValues(alpha: 0.1)
                : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border:
                isActive ? Border.all(color: TossColors.primary, width: 1) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive ? TossColors.primary : TossColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TossTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w400,
                      color: isActive ? TossColors.primary : TossColors.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isActive ? TossColors.primary : TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    return invoiceState.invoices
        .fold(0.0, (sum, invoice) => sum + invoice.amounts.totalAmount);
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
