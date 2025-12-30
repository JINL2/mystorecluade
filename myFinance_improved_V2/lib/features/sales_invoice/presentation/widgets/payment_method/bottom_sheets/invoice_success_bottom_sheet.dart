import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../shared/themes/toss_border_radius.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../../../shared/themes/toss_spacing.dart';
import '../../../../../../shared/themes/toss_text_styles.dart';
import '../../../../../sale_product/domain/entities/sales_product.dart';
import '../../../../../sale_product/presentation/widgets/common/product_image_widget.dart';
import '../helpers/payment_helpers.dart';

/// Bottom sheet for showing invoice creation success
class InvoiceSuccessBottomSheet extends StatefulWidget {
  final String invoiceNumber;
  final double totalAmount;
  final String currencySymbol;
  final String storeName;
  final String paymentType;
  final String cashLocationName;
  final List<SalesProduct> products;
  final Map<String, int> quantities;
  final String warningMessage;
  final VoidCallback onDismiss;

  const InvoiceSuccessBottomSheet({
    super.key,
    required this.invoiceNumber,
    required this.totalAmount,
    this.currencySymbol = 'đ',
    required this.storeName,
    required this.paymentType,
    required this.cashLocationName,
    required this.products,
    required this.quantities,
    this.warningMessage = '',
    required this.onDismiss,
  });

  /// Show the invoice success page (full screen)
  static void show(
    BuildContext context, {
    required String invoiceNumber,
    required double totalAmount,
    String currencySymbol = 'đ',
    required String storeName,
    required String paymentType,
    required String cashLocationName,
    required List<SalesProduct> products,
    required Map<String, int> quantities,
    String warningMessage = '',
    required VoidCallback onDismiss,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => InvoiceSuccessBottomSheet(
          invoiceNumber: invoiceNumber,
          totalAmount: totalAmount,
          currencySymbol: currencySymbol,
          storeName: storeName,
          paymentType: paymentType,
          cashLocationName: cashLocationName,
          products: products,
          quantities: quantities,
          warningMessage: warningMessage,
          onDismiss: onDismiss,
        ),
      ),
    );
  }

  @override
  State<InvoiceSuccessBottomSheet> createState() =>
      _InvoiceSuccessBottomSheetState();
}

class _InvoiceSuccessBottomSheetState extends State<InvoiceSuccessBottomSheet> {
  bool _isItemsExpanded = true; // Expanded by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header - Title centered at top
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Sale Completed!',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray900,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                child: Column(
                  children: [
                    const SizedBox(height: TossSpacing.space4),

                    // Total amount with currency symbol before number (like cash ending)
                    Text(
                      '${widget.currencySymbol}${PaymentHelpers.formatNumber(widget.totalAmount.toInt())}',
                      style: TossTextStyles.display.copyWith(
                        color: TossColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TossSpacing.space2),

                    // Store • Payment Type • Location
                    Text(
                      '${widget.paymentType} · ${widget.storeName} · ${widget.cashLocationName}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TossSpacing.space6),

                    // View items section in white card with border
                    _buildViewItemsSection(),
                  ],
                ),
              ),
            ),

            // OK button - fixed at bottom
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: _buildOkButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewItemsSection() {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
        border: Border.all(
          color: TossColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isItemsExpanded = !_isItemsExpanded;
              });
            },
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(TossBorderRadius.lg),
              bottom: _isItemsExpanded
                  ? Radius.zero
                  : const Radius.circular(TossBorderRadius.lg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'View items',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray900,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      // Item count badge
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TossColors.primary,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.products.length}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    _isItemsExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: TossColors.gray400,
                  ),
                ],
              ),
            ),
          ),

          // Items list
          if (_isItemsExpanded) ...[
            Container(
              height: 1,
              color: TossColors.gray200,
            ),
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: Column(
                children: widget.products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final quantity = widget.quantities[product.productId] ?? 0;
                  final price = product.pricing.sellingPrice ?? 0;
                  final isLast = index == widget.products.length - 1;
                  return _buildItemRow(product, quantity, price, isLast);
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(
    SalesProduct product,
    int quantity,
    double price,
    bool isLast,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : TossSpacing.space3),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
            child: ProductImageWidget(
              imageUrl: product.images.mainImage,
              size: 48,
              fallbackIcon: Icons.inventory_2,
            ),
          ),
          const SizedBox(width: TossSpacing.space3),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: TossColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  product.sku,
                  style: TossTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w400,
                    color: TossColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          // Quantity x Price
          Text(
            '$quantity × ${PaymentHelpers.formatNumber(price.toInt())}',
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: TossColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOkButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.pop(); // Close bottom sheet
          widget.onDismiss();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: TossColors.primary,
          foregroundColor: TossColors.white,
          padding: const EdgeInsets.symmetric(
            vertical: TossSpacing.space3 + 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.md),
          ),
          elevation: 0,
        ),
        child: Text(
          'OK! Back to Sale',
          style: TossTextStyles.bodyLarge.copyWith(
            color: TossColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
