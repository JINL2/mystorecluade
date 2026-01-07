import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_dimensions.dart';
import '../../../../../shared/themes/toss_font_weight.dart';
import '../../../../../shared/themes/toss_opacity.dart';
import '../../../../../shared/themes/toss_spacing.dart';
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
      padding: EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space2, TossSpacing.space3, TossSpacing.space0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row - equal distribution
          SizedBox(
            height: TossDimensions.headerHeight,
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterPill(
                    context,
                    'Time',
                    invoiceState.selectedPeriod.displayName,
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: _buildFilterPill(
                    context,
                    'Location',
                    invoiceState.selectedCashLocation?.name ?? 'All',
                    isActive: invoiceState.selectedCashLocation != null,
                    filterKey: 'Cash Location',
                  ),
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: _buildFilterPill(
                    context,
                    'Status',
                    invoiceState.statusDisplayText,
                    isActive: invoiceState.selectedStatus != null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: TossSpacing.space3),
          // Summary text with bold numbers
          RichText(
            text: TextSpan(
              style: TossTextStyles.caption.copyWith(
                fontWeight: TossFontWeight.medium,
                color: TossColors.gray600,
              ),
              children: [
                const TextSpan(text: 'Total invoice: '),
                TextSpan(
                  text: '${invoiceState.filteredInvoices.length} invoices',
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                const TextSpan(text: ' · Total money: '),
                TextSpan(
                  text: _formatCurrency(_calculateTotalAmount()),
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: TossFontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          // Divider
          Container(
            height: TossDimensions.dividerThickness,
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
    String? filterKey,
  }) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: () => onFilterTap(filterKey ?? title),
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: isActive
                ? TossColors.primary.withValues(alpha: TossOpacity.light)
                : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border:
                isActive ? Border.all(color: TossColors.primary, width: TossDimensions.dividerThickness) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TossTextStyles.bodySmall.copyWith(
                        fontWeight: TossFontWeight.semibold,
                        color: isActive ? TossColors.primary : TossColors.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: TossFontWeight.regular,
                        color: isActive ? TossColors.primary : TossColors.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: TossSpacing.space1),
              Icon(
                Icons.keyboard_arrow_down,
                size: TossSpacing.iconSM2,
                color: isActive ? TossColors.primary : TossColors.gray600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    return invoiceState.filteredInvoices
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
