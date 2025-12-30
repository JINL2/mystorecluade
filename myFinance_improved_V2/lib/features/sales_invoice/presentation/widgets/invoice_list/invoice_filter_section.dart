// lib/features/sales_invoice/presentation/widgets/invoice_list/invoice_filter_section.dart
//
// Extracted filter section widget from sales_invoice_page.dart
// Following Clean Architecture 2025 - Single Responsibility Principle

import 'package:flutter/material.dart';

import '../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../shared/themes/toss_colors.dart';
import '../../../../../shared/themes/toss_spacing.dart';
import '../../../../../shared/themes/toss_text_styles.dart';
import '../../../domain/entities/invoice.dart';
import '../../extensions/invoice_period_extension.dart';
import '../../providers/states/invoice_list_state.dart';

/// Invoice filter section widget
///
/// Displays filter pills for Time, Location, and Status filters
/// with summary text showing total invoices and amount.
class InvoiceFilterSection extends StatelessWidget {
  final InvoiceListState invoiceState;
  final void Function(String filterType) onFilterTap;

  const InvoiceFilterSection({
    super.key,
    required this.invoiceState,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.fromLTRB(TossSpacing.space3, TossSpacing.space2, TossSpacing.space3, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter pills row - equal distribution
          SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: _FilterPill(
                    title: 'Time',
                    subtitle: invoiceState.selectedPeriod.displayName,
                    onTap: () => onFilterTap('Time'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterPill(
                    title: 'Location',
                    subtitle: invoiceState.selectedCashLocation?.name ?? 'All',
                    isActive: invoiceState.selectedCashLocation != null,
                    onTap: () => onFilterTap('Cash Location'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FilterPill(
                    title: 'Status',
                    subtitle: invoiceState.statusDisplayText,
                    isActive: invoiceState.selectedStatus != null,
                    onTap: () => onFilterTap('Status'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Summary text with bold numbers
          _buildSummaryText(),
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

  Widget _buildSummaryText() {
    final totalAmount = _calculateTotalAmount(invoiceState.filteredInvoices);

    return RichText(
      text: TextSpan(
        style: TossTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
          color: TossColors.gray600,
        ),
        children: [
          const TextSpan(text: 'Total invoice: '),
          TextSpan(
            text: '${invoiceState.filteredInvoices.length} invoices',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
          const TextSpan(text: ' · Total money: '),
          TextSpan(
            text: _formatCurrency(totalAmount),
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: TossColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount(List<Invoice> invoices) {
    return invoices.fold(0.0, (sum, invoice) => sum + invoice.amounts.totalAmount);
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

/// Individual filter pill widget
class _FilterPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.title,
    required this.subtitle,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: TossColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space3, vertical: TossSpacing.space2),
          decoration: BoxDecoration(
            color: isActive ? TossColors.primary.withValues(alpha: 0.1) : TossColors.gray50,
            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            border: isActive ? Border.all(color: TossColors.primary, width: 1) : null,
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
                        fontWeight: FontWeight.w600,
                        color: isActive ? TossColors.primary : TossColors.gray900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TossTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w400,
                        color: isActive ? TossColors.primary : TossColors.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
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
}
