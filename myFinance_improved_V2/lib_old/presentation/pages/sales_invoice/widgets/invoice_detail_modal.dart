import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/themes/toss_colors.dart';
import '../../../../core/themes/toss_text_styles.dart';
import '../../../../core/themes/toss_spacing.dart';
import '../../../../core/themes/toss_border_radius.dart';
import '../models/invoice_models.dart';
import '../invoice_detail_page.dart';
import '../providers/invoice_provider.dart';
import 'refund_confirmation_dialog.dart';

class InvoiceDetailModal extends ConsumerWidget {
  final Invoice invoice;
  final Currency? currency;

  const InvoiceDetailModal({
    Key? key,
    required this.invoice,
    this.currency,
  }) : super(key: key);

  static void show(BuildContext context, Invoice invoice, Currency? currency) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => InvoiceDetailModal(
        invoice: invoice,
        currency: currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat.currency(symbol: '', decimalDigits: 0);
    final symbol = currency?.symbol ?? '';
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(TossBorderRadius.xl),
              topRight: Radius.circular(TossBorderRadius.xl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 48,
                height: 4,
                margin: EdgeInsets.only(top: TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                ),
              ),
              
              // Header
              Container(
                padding: EdgeInsets.all(TossSpacing.space4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.invoiceNumber,
                            style: TossTextStyles.h3.copyWith(
                              fontWeight: FontWeight.bold,
                              color: TossColors.gray900,
                            ),
                          ),
                          SizedBox(height: TossSpacing.space1),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(invoice.saleDate),
                            style: TossTextStyles.caption.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Actions
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.open_in_full),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InvoiceDetailPage(
                                  invoice: invoice,
                                  currency: currency,
                                ),
                              ),
                            );
                          },
                          color: TossColors.gray600,
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          color: TossColors.gray600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1, color: TossColors.gray100),
              
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.all(TossSpacing.space4),
                  children: [
                    // Quick Summary
                    _buildQuickSummary(currencyFormat, symbol),
                    
                    SizedBox(height: TossSpacing.space4),
                    
                    // Customer Info
                    _buildInfoCard(
                      icon: Icons.person,
                      title: 'Customer',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.customer?.name ?? 'Walk-in Customer',
                            style: TossTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.gray900,
                            ),
                          ),
                          if (invoice.customer?.phone != null) ...[
                            SizedBox(height: TossSpacing.space1),
                            Text(
                              invoice.customer!.phone!,
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    
                    // Items Summary
                    _buildInfoCard(
                      icon: Icons.shopping_cart,
                      title: 'Items',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${invoice.itemsSummary.itemCount} products',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                          ),
                          Text(
                            'Qty: ${invoice.itemsSummary.totalQuantity}',
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    
                    // Payment Info
                    _buildInfoCard(
                      icon: Icons.payment,
                      title: 'Payment',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            invoice.payment.method,
                            style: TossTextStyles.body.copyWith(
                              color: TossColors.gray900,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: TossSpacing.space2,
                              vertical: TossSpacing.space1,
                            ),
                            decoration: BoxDecoration(
                              color: invoice.payment.status == 'paid'
                                  ? TossColors.success.withValues(alpha: 0.1)
                                  : TossColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                            ),
                            child: Text(
                              invoice.payment.status,
                              style: TossTextStyles.caption.copyWith(
                                color: invoice.payment.status == 'paid'
                                    ? TossColors.success
                                    : TossColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: TossSpacing.space3),
                    
                    // Store Info
                    _buildInfoCard(
                      icon: Icons.store,
                      title: 'Store',
                      content: Text(
                        invoice.store.storeName,
                        style: TossTextStyles.body.copyWith(
                          color: TossColors.gray900,
                        ),
                      ),
                    ),
                    
                    if (invoice.createdBy != null) ...[
                      SizedBox(height: TossSpacing.space3),
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        title: 'Created By',
                        content: Text(
                          invoice.createdBy!.name,
                          style: TossTextStyles.body.copyWith(
                            color: TossColors.gray900,
                          ),
                        ),
                      ),
                    ],
                    
                    // Refund Button - only show for completed invoices
                    if (invoice.isCompleted) ...[
                      SizedBox(height: TossSpacing.space6),
                      _buildRefundButton(context, ref),
                    ],
                    
                    SizedBox(height: TossSpacing.space4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildRefundButton(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: ElevatedButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          _showRefundConfirmation(context, ref);
        },
        icon: Icon(Icons.assignment_return),
        label: Text('Refund'),
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.error,
          foregroundColor: TossColors.white,
          padding: EdgeInsets.symmetric(
            vertical: TossSpacing.space3,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          elevation: 0,
        ),
      ),
    );
  }
  
  void _showRefundConfirmation(BuildContext context, WidgetRef ref) {
    RefundConfirmationDialog.show(
      context,
      invoice,
      currency,
      onSuccess: (result) async {
        // Close the modal and show success
        Navigator.pop(context);
        _showRefundSuccess(context, result);
        
        // Refresh the invoice list data
        try {
          await ref.read(invoicePageProvider.notifier).refresh();
        } catch (e) {
          print('Error refreshing invoice data: $e');
        }
      },
    );
  }
  
  void _showRefundSuccess(BuildContext context, Map<String, dynamic> result) {
    final hasWarnings = result['warnings'] != null && 
                       (result['warnings'] as List).isNotEmpty;
    
    // Show SnackBar for immediate feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              hasWarnings ? Icons.warning : Icons.check_circle, 
              color: TossColors.white
            ),
            SizedBox(width: TossSpacing.space2),
            Expanded(
              child: Text(
                hasWarnings 
                  ? 'Refund processed with warnings'
                  : 'Invoice ${result['invoice_number']} refunded successfully',
                style: TossTextStyles.body.copyWith(color: TossColors.white),
              ),
            ),
          ],
        ),
        backgroundColor: hasWarnings ? TossColors.warning : TossColors.success,
        duration: Duration(seconds: hasWarnings ? 5 : 3),
      ),
    );

    // Show detailed dialog if there are warnings
    if (hasWarnings) {
      _showWarningsDialog(context, result);
    }
  }

  void _showWarningsDialog(BuildContext context, Map<String, dynamic> result) {
    final warnings = result['warnings'] as List<dynamic>;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TossColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: TossColors.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning,
                color: TossColors.warning,
                size: 20,
              ),
            ),
            SizedBox(width: TossSpacing.space3),
            Expanded(
              child: Text(
                'Refund Completed with Warnings',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice ${result['invoice_number']} has been refunded successfully, but there are some issues to note:',
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
                height: 1.4,
              ),
            ),
            SizedBox(height: TossSpacing.space3),
            Container(
              constraints: BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: Column(
                  children: warnings.map<Widget>((warning) {
                    return Container(
                      margin: EdgeInsets.only(bottom: TossSpacing.space2),
                      padding: EdgeInsets.all(TossSpacing.space3),
                      decoration: BoxDecoration(
                        color: TossColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: TossColors.warning,
                            size: 16,
                          ),
                          SizedBox(width: TossSpacing.space2),
                          Expanded(
                            child: Text(
                              _formatWarningMessage(warning),
                              style: TossTextStyles.caption.copyWith(
                                color: TossColors.gray800,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
            ),
            child: Text(
              'OK',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummary(NumberFormat formatter, String symbol) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (invoice.isCompleted) {
      statusColor = TossColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Completed';
    } else if (invoice.isDraft) {
      statusColor = TossColors.warning;
      statusIcon = Icons.schedule;
      statusText = 'Draft';
    } else if (invoice.isCancelled) {
      statusColor = TossColors.error;
      statusIcon = Icons.cancel;
      statusText = 'Cancelled';
    } else {
      statusColor = TossColors.gray600;
      statusIcon = Icons.info;
      statusText = invoice.status;
    }

    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TossColors.primary.withValues(alpha: 0.05),
            TossColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  SizedBox(height: TossSpacing.space1),
                  Text(
                    '$symbol${formatter.format(invoice.amounts.totalAmount)}',
                    style: TossTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: TossSpacing.space3,
                  vertical: TossSpacing.space2,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.full),
                ),
                child: Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 18,
                      color: statusColor,
                    ),
                    SizedBox(width: TossSpacing.space1),
                    Text(
                      statusText,
                      style: TossTextStyles.body.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (invoice.amounts.discountAmount > 0 || invoice.amounts.taxAmount > 0) ...[
            SizedBox(height: TossSpacing.space3),
            Divider(height: 1, color: TossColors.gray200),
            SizedBox(height: TossSpacing.space3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountDetail(
                  'Subtotal',
                  '$symbol${formatter.format(invoice.amounts.subtotal)}',
                ),
                if (invoice.amounts.taxAmount > 0)
                  _buildAmountDetail(
                    'Tax',
                    '$symbol${formatter.format(invoice.amounts.taxAmount)}',
                  ),
                if (invoice.amounts.discountAmount > 0)
                  _buildAmountDetail(
                    'Discount',
                    '-$symbol${formatter.format(invoice.amounts.discountAmount)}',
                    color: TossColors.success,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountDetail(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(
          label,
          style: TossTextStyles.caption.copyWith(
            color: TossColors.gray600,
          ),
        ),
        SizedBox(height: TossSpacing.space1),
        Text(
          value,
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? TossColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget content,
  }) {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.gray50,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: TossColors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: TossColors.primary,
            ),
          ),
          SizedBox(width: TossSpacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.gray600,
                  ),
                ),
                SizedBox(height: TossSpacing.space1),
                content,
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatWarningMessage(dynamic warning) {
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