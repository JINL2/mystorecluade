import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_white_card.dart';
import 'models/invoice_models.dart';
import 'providers/invoice_provider.dart';
import 'widgets/refund_confirmation_dialog.dart';

class InvoiceDetailPage extends ConsumerStatefulWidget {
  final Invoice invoice;
  final Currency? currency;

  const InvoiceDetailPage({
    Key? key,
    required this.invoice,
    this.currency,
  }) : super(key: key);

  @override
  ConsumerState<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends ConsumerState<InvoiceDetailPage> {
  final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
  final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Invoice Details',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Implement print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Invoice Header
            _buildInvoiceHeader(),
            
            // Customer Information
            _buildCustomerSection(),
            
            // Invoice Items Summary
            _buildItemsSummarySection(),
            
            // Payment Details
            _buildPaymentSection(),
            
            // Amount Breakdown
            _buildAmountBreakdown(),
            
            // Invoice Footer
            _buildInvoiceFooter(),
            
            SizedBox(height: TossSpacing.space8),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildInvoiceHeader() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          children: [
            // Invoice Number and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice Number',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    Text(
                      widget.invoice.invoiceNumber,
                      style: TossTextStyles.h2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TossColors.gray900,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(),
              ],
            ),
            
            SizedBox(height: TossSpacing.space4),
            Divider(height: 1, color: TossColors.gray200),
            SizedBox(height: TossSpacing.space4),
            
            // Date and Time
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: TossSpacing.iconSM,
                  color: TossColors.gray600,
                ),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sale Date',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray600,
                        ),
                      ),
                      Text(
                        dateFormat.format(widget.invoice.saleDate),
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color backgroundColor;
    Color textColor;
    String statusText;
    IconData icon;

    if (widget.invoice.isCompleted) {
      backgroundColor = TossColors.success.withValues(alpha: 0.1);
      textColor = TossColors.success;
      statusText = 'Completed';
      icon = Icons.check_circle;
    } else if (widget.invoice.isDraft) {
      backgroundColor = TossColors.warning.withValues(alpha: 0.1);
      textColor = TossColors.warning;
      statusText = 'Draft';
      icon = Icons.schedule;
    } else if (widget.invoice.isCancelled) {
      backgroundColor = TossColors.error.withValues(alpha: 0.1);
      textColor = TossColors.error;
      statusText = 'Cancelled';
      icon = Icons.cancel;
    } else {
      backgroundColor = TossColors.gray200;
      textColor = TossColors.gray700;
      statusText = widget.invoice.status;
      icon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TossSpacing.space3,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(TossBorderRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: textColor,
          ),
          SizedBox(width: TossSpacing.space1),
          Text(
            statusText,
            style: TossTextStyles.caption.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Customer Information',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            // Customer Name
            _buildInfoRow(
              'Name',
              widget.invoice.customer?.name ?? 'Walk-in Customer',
            ),
            
            // Customer Phone
            if (widget.invoice.customer?.phone != null) ...[
              SizedBox(height: TossSpacing.space2),
              _buildInfoRow(
                'Phone',
                widget.invoice.customer!.phone!,
              ),
            ],
            
            // Customer Type
            if (widget.invoice.customer != null) ...[
              SizedBox(height: TossSpacing.space2),
              _buildInfoRow(
                'Type',
                widget.invoice.customer!.type,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSummarySection() {
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Items Summary',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Products',
                  widget.invoice.itemsSummary.itemCount.toString(),
                  Icons.inventory_2,
                ),
                _buildSummaryItem(
                  'Total Quantity',
                  widget.invoice.itemsSummary.totalQuantity.toString(),
                  Icons.format_list_numbered,
                ),
              ],
            ),
            
            // TODO: Add actual invoice items list when RPC is available
            SizedBox(height: TossSpacing.space3),
            Container(
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: TossColors.gray600,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Detailed item list will be available soon',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: TossColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: TossColors.primary,
            size: 24,
          ),
        ),
        SizedBox(height: TossSpacing.space2),
        Text(
          value,
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: TossColors.gray900,
          ),
        ),
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Payment Information',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            _buildInfoRow('Payment Method', widget.invoice.payment.method),
            SizedBox(height: TossSpacing.space2),
            _buildInfoRow('Payment Status', widget.invoice.payment.status),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountBreakdown() {
    final symbol = widget.currency?.symbol ?? '';
    
    return Container(
      margin: EdgeInsets.all(TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Amount Breakdown',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            // Subtotal
            _buildAmountRow(
              'Subtotal',
              '$symbol${currencyFormat.format(widget.invoice.amounts.subtotal)}',
            ),
            
            // Tax
            if (widget.invoice.amounts.taxAmount > 0) ...[
              SizedBox(height: TossSpacing.space2),
              _buildAmountRow(
                'Tax',
                '+$symbol${currencyFormat.format(widget.invoice.amounts.taxAmount)}',
                color: TossColors.gray600,
              ),
            ],
            
            // Discount
            if (widget.invoice.amounts.discountAmount > 0) ...[
              SizedBox(height: TossSpacing.space2),
              _buildAmountRow(
                'Discount',
                '-$symbol${currencyFormat.format(widget.invoice.amounts.discountAmount)}',
                color: TossColors.success,
              ),
            ],
            
            SizedBox(height: TossSpacing.space3),
            Divider(height: 1, color: TossColors.gray200),
            SizedBox(height: TossSpacing.space3),
            
            // Total
            _buildAmountRow(
              'Total Amount',
              '$symbol${currencyFormat.format(widget.invoice.amounts.totalAmount)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossWhiteCard(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.store,
                  size: TossSpacing.iconSM,
                  color: TossColors.primary,
                ),
                SizedBox(width: TossSpacing.space2),
                Text(
                  'Store Information',
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                ),
              ],
            ),
            SizedBox(height: TossSpacing.space3),
            
            _buildInfoRow('Store', widget.invoice.store.storeName),
            SizedBox(height: TossSpacing.space2),
            _buildInfoRow('Store Code', widget.invoice.store.storeCode),
            
            if (widget.invoice.createdBy != null) ...[
              SizedBox(height: TossSpacing.space4),
              Divider(height: 1, color: TossColors.gray200),
              SizedBox(height: TossSpacing.space4),
              
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: TossSpacing.iconSM,
                    color: TossColors.primary,
                  ),
                  SizedBox(width: TossSpacing.space2),
                  Text(
                    'Created By',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: TossColors.gray900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: TossSpacing.space3),
              
              _buildInfoRow('Name', widget.invoice.createdBy!.name),
              SizedBox(height: TossSpacing.space2),
              _buildInfoRow('Email', widget.invoice.createdBy!.email),
              SizedBox(height: TossSpacing.space2),
              _buildInfoRow(
                'Created At',
                dateFormat.format(widget.invoice.createdAt),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray900,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountRow(String label, String value, {
    Color? color,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isTotal ? TossTextStyles.body : TossTextStyles.caption).copyWith(
            color: TossColors.gray600,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: (isTotal ? TossTextStyles.h3 : TossTextStyles.body).copyWith(
            color: color ?? (isTotal ? TossColors.primary : TossColors.gray900),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    if (!widget.invoice.isCompleted) return SizedBox.shrink();
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  RefundConfirmationDialog.show(
                    context,
                    widget.invoice,
                    widget.currency,
                    onSuccess: (result) async {
                      // Show success message
                      _showRefundResult(context, result);
                      
                      // Refresh the invoice list data
                      try {
                        await ref.read(invoicePageProvider.notifier).refresh();
                      } catch (e) {
                        print('Error refreshing invoice data: $e');
                      }
                    },
                  );
                },
                icon: Icon(Icons.assignment_return),
                label: Text('Refund'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                  backgroundColor: TossColors.error,
                  foregroundColor: TossColors.white,
                ),
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement email invoice
                },
                icon: Icon(Icons.email),
                label: Text('Email'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: TossSpacing.space3),
                  backgroundColor: TossColors.primary,
                  foregroundColor: TossColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showRefundResult(BuildContext context, Map<String, dynamic> result) {
    if (result['success'] == true) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.xl),
              boxShadow: [
                BoxShadow(
                  color: TossColors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: TossColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: TossColors.success,
                    size: 32,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space4),
                
                // Title
                Text(
                  'Refund Successful',
                  style: TossTextStyles.h2.copyWith(
                    fontWeight: FontWeight.bold,
                    color: TossColors.gray900,
                  ),
                ),
                
                SizedBox(height: TossSpacing.space3),
                
                // Details
                Container(
                  padding: EdgeInsets.all(TossSpacing.space3),
                  decoration: BoxDecoration(
                    color: TossColors.gray50,
                    borderRadius: BorderRadius.circular(TossBorderRadius.md),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invoice:',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          Text(
                            result['invoice_number']?.toString() ?? '',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: TossSpacing.space2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Refunded:',
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                          Text(
                            '${widget.currency?.symbol ?? ''}${currencyFormat.format(result['total_refunded'] ?? 0)}',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: TossColors.success,
                            ),
                          ),
                        ],
                      ),
                      if (result['items_refunded'] != null) ...[
                        SizedBox(height: TossSpacing.space2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Items Refunded:',
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                            Text(
                              '${result['items_refunded']?.toString() ?? ''}',
                              style: TossTextStyles.body.copyWith(
                                color: TossColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Warnings if any
                if (result['warnings'] != null && (result['warnings'] as List).isNotEmpty) ...[
                  SizedBox(height: TossSpacing.space3),
                  Container(
                    padding: EdgeInsets.all(TossSpacing.space3),
                    decoration: BoxDecoration(
                      color: TossColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: TossColors.warning,
                              size: 20,
                            ),
                            SizedBox(width: TossSpacing.space2),
                            Text(
                              'Warnings:',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.warning,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: TossSpacing.space2),
                        ...(result['warnings'] as List).map((warning) => 
                          Padding(
                            padding: EdgeInsets.only(top: TossSpacing.space1),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '• ',
                                  style: TossTextStyles.caption.copyWith(
                                    color: TossColors.gray700,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _formatWarningText(warning),
                                    style: TossTextStyles.caption.copyWith(
                                      color: TossColors.gray700,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: TossSpacing.space5),
                
                // OK Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    // Go back to invoice list
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TossColors.primary,
                    foregroundColor: TossColors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: TossSpacing.space6,
                      vertical: TossSpacing.space3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  String _formatWarningText(dynamic warning) {
    if (warning is String) {
      return warning;
    } else if (warning is Map) {
      final type = warning['type']?.toString() ?? '';
      final product = warning['product']?.toString() ?? '';
      final stockAfter = warning['stock_after_refund']?.toString() ?? '';
      final stockBefore = warning['stock_before_refund']?.toString() ?? '';
      
      switch (type) {
        case 'still_negative_stock':
          return 'Product "$product" still has negative stock after refund (Current: $stockAfter)';
        case 'insufficient_stock':
          return 'Product "$product" has insufficient stock for refund';
        case 'stock_warning':
          return 'Product "$product" stock level warning (Stock: $stockAfter)';
        default:
          if (product.isNotEmpty && stockAfter.isNotEmpty) {
            return 'Product "$product" - Stock after refund: $stockAfter';
          } else if (product.isNotEmpty) {
            return 'Product "$product" - $type';
          } else {
            return warning['message']?.toString() ?? warning.toString();
          }
      }
    } else {
      return warning.toString();
    }
  }
}