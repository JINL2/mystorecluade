import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../domain/entities/invoice.dart';

/// Invoice Detail Page - Full page view for invoice details
///
/// Features:
/// - AppBar with invoice number, date/time/store info, and delete action
/// - Collapsible "View items" card with item count badge
/// - Payment breakdown section (subtotal, discount, total)
/// - Payment method section with icon
/// - Created by section with avatar
/// - Refund action for completed invoices
class InvoiceDetailPage extends StatefulWidget {
  final Invoice invoice;
  final String? currencySymbol;
  final void Function(Invoice invoice)? onRefundPressed;
  final void Function(Invoice invoice)? onDeletePressed;

  const InvoiceDetailPage({
    super.key,
    required this.invoice,
    this.currencySymbol,
    this.onRefundPressed,
    this.onDeletePressed,
  });

  /// Navigate to invoice detail page
  static void navigate(
    BuildContext context,
    Invoice invoice,
    String? currencySymbol, {
    void Function(Invoice invoice)? onRefundPressed,
    void Function(Invoice invoice)? onDeletePressed,
  }) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceDetailPage(
          invoice: invoice,
          currencySymbol: currencySymbol,
          onRefundPressed: onRefundPressed,
          onDeletePressed: onDeletePressed,
        ),
      ),
    );
  }

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  bool _isItemsExpanded = false;
  static final _currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);

  String get _symbol => widget.currencySymbol ?? '';

  Invoice get invoice => widget.invoice;

  /// Get payment method icon based on cash location type
  IconData get _paymentIcon {
    final locationType = invoice.cashLocation?.locationType.toLowerCase() ?? '';
    final paymentMethod = invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return Icons.payments_outlined;
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return Icons.account_balance_outlined;
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return Icons.grid_view_outlined;
    }
    return Icons.payments_outlined;
  }

  /// Get payment method display name
  String get _paymentMethodName {
    final locationType = invoice.cashLocation?.locationType.toLowerCase() ?? '';
    final paymentMethod = invoice.paymentMethod.toLowerCase();

    if (locationType == 'cash' || paymentMethod == 'cash') {
      return 'Cash';
    } else if (locationType == 'bank' || paymentMethod == 'bank') {
      return 'Bank Transfer';
    } else if (locationType == 'vault' || paymentMethod == 'vault') {
      return 'Vault';
    }
    return invoice.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // View Items Card (Collapsible)
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space4),
                    child: _buildViewItemsCard(),
                  ),

                  // Gray divider before Payment breakdown
                  const GrayDividerSpace(),

                  // Payment Breakdown Section
                  _buildPaymentBreakdownSection(),

                  // Gray divider before Payment method
                  const GrayDividerSpace(),

                  // Payment Method Section
                  _buildPaymentMethodSection(),

                  // Gray divider before Created by
                  const GrayDividerSpace(),

                  // Created By Section
                  _buildCreatedBySection(),

                  const SizedBox(height: TossSpacing.space6),
                ],
              ),
            ),
          ),

          // Refund Button (only for completed invoices)
          if (invoice.isCompleted && widget.onRefundPressed != null)
            _buildRefundButton(context),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return AppBar(
      backgroundColor: TossColors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24),
        onPressed: () => Navigator.of(context).pop(),
        color: TossColors.gray900,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            invoice.invoiceNumber,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${dateFormat.format(invoice.saleDate)} · ${timeFormat.format(invoice.saleDate)} · ${invoice.storeName}',
            style: TossTextStyles.small.copyWith(
              color: TossColors.gray500,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        if (widget.onDeletePressed != null && !invoice.isCancelled)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 24),
            onPressed: () => _showDeleteConfirmation(context),
            color: TossColors.gray600,
          ),
      ],
    );
  }

  Widget _buildViewItemsCard() {
    final itemCount = invoice.itemsSummary.itemCount;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _isItemsExpanded = !_isItemsExpanded;
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
                  turns: _isItemsExpanded ? 0.5 : 0,
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
            crossFadeState: _isItemsExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    // Since we don't have detailed items, show summary info
    final itemCount = invoice.itemsSummary.itemCount;
    final totalQty = invoice.itemsSummary.totalQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        children: [
          const Divider(height: 1, color: TossColors.gray200),
          const SizedBox(height: TossSpacing.space3),
          // Placeholder for items - in real app this would list each item
          Row(
            children: [
              // Product thumbnail placeholder
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
                _formatAmount(invoice.amounts.subtotal),
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

  Widget _buildPaymentBreakdownSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment breakdown',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),

          // Sub-total
          _buildPaymentRow(
            'Sub-total',
            _formatAmount(invoice.amounts.subtotal),
          ),

          // Discount (if any)
          if (invoice.amounts.discountAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildDiscountRow(),
          ],

          // Tax (if any)
          if (invoice.amounts.taxAmount > 0) ...[
            const SizedBox(height: TossSpacing.space3),
            _buildPaymentRow(
              'Tax',
              _formatAmount(invoice.amounts.taxAmount),
            ),
          ],

          const SizedBox(height: TossSpacing.space4),

          // Divider before total
          Container(
            height: 1,
            color: TossColors.gray200,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Total payment
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total payment',
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray900,
                ),
              ),
              Text(
                _formatAmount(invoice.amounts.totalAmount),
                style: TossTextStyles.h4.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray600,
          ),
        ),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            color: TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow() {
    final discountPercent = _calculateDiscountPercent();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            Text(
              '-${_formatAmount(invoice.amounts.discountAmount)}',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.error,
              ),
            ),
          ],
        ),
        if (discountPercent.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            '~$discountPercent discount',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.error.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Payment method',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          const SizedBox(height: TossSpacing.space4),
          Row(
            children: [
              // Payment icon
              Icon(
                _paymentIcon,
                color: TossColors.gray700,
                size: 24,
              ),
              const SizedBox(width: TossSpacing.space3),
              // Payment method name
              Text(
                _paymentMethodName,
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: TossColors.gray900,
                ),
              ),
              const Spacer(),
              // Location name or status
              if (invoice.cashLocation != null)
                Text(
                  invoice.cashLocation!.locationName,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.gray500,
                  ),
                )
              else
                // Payment status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TossSpacing.space2,
                    vertical: TossSpacing.space1,
                  ),
                  decoration: BoxDecoration(
                    color: invoice.isPaid
                        ? TossColors.success.withValues(alpha: 0.1)
                        : TossColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                  ),
                  child: Text(
                    invoice.isPaid ? 'Paid' : 'Pending',
                    style: TossTextStyles.small.copyWith(
                      color: invoice.isPaid ? TossColors.success : TossColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreatedBySection() {
    final createdByName = invoice.createdByName ?? 'Unknown';
    final initials = _getInitials(createdByName);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section title
          Text(
            'Created by',
            style: TossTextStyles.h4.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray900,
            ),
          ),
          // Avatar and name
          Row(
            children: [
              // Avatar
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: TossColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: TossTextStyles.small.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: TossSpacing.space2),
              // Name
              Text(
                createdByName,
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

  Widget _buildRefundButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        TossSpacing.space4,
        TossSpacing.space3,
        TossSpacing.space4,
        TossSpacing.space3 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: TossColors.white,
        border: Border(
          top: BorderSide(color: TossColors.gray100),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            _showRefundConfirmation(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.error,
            foregroundColor: TossColors.white,
            padding: const EdgeInsets.symmetric(vertical: TossSpacing.space4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay, size: 20),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Refund',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRefundConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.replay,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Refund Invoice'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund this invoice?',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
            const SizedBox(height: TossSpacing.space4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray50,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Column(
                children: [
                  Text(
                    'Refund Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    _formatAmount(invoice.amounts.totalAmount),
                    style: TossTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'Invoice: ${invoice.invoiceNumber}',
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close page
              widget.onRefundPressed?.call(invoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
            ),
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: TossColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: TossColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            const Text('Delete Invoice'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete invoice ${invoice.invoiceNumber}? This action cannot be undone.',
          style: TossTextStyles.body.copyWith(
            color: TossColors.gray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close page
              widget.onDeletePressed?.call(invoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
            ),
            child: const Text('Delete'),
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

  String _calculateDiscountPercent() {
    if (invoice.amounts.subtotal <= 0) return '';
    final percent = (invoice.amounts.discountAmount / invoice.amounts.subtotal) * 100;
    return '${percent.toStringAsFixed(1)}%';
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
