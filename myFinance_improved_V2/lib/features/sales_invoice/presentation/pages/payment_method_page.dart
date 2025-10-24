import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../core/navigation/safe_navigation.dart';
import '../../../sale_product/domain/entities/sales_product.dart';

/// Payment Method Page - Temporary placeholder
///
/// This page needs to be migrated from V1 to V2 with clean architecture.
/// V1 file: lib/presentation/pages/sales_invoice/payment_method_page.dart (2,114 lines)
///
/// TODO: Full migration with:
/// - Payment method selection (Cash, Card, Transfer, etc.)
/// - Amount input with currency support
/// - Cash location selection
/// - Discount calculation
/// - Invoice generation
class PaymentMethodPage extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;

  const PaymentMethodPage({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
  });

  @override
  ConsumerState<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends ConsumerState<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => SafeNavigation.instance.safePop(context: context),
        ),
        title: Text(
          'Payment Method',
          style: TossTextStyles.h3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: TossColors.gray100,
        foregroundColor: TossColors.black,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(TossSpacing.space4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 64,
                color: TossColors.gray400,
              ),
              SizedBox(height: TossSpacing.space4),
              Text(
                'Payment Method Page',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.gray900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space3),
              Text(
                'This page is under construction.\n\nFull migration from V1 needed:\n- Payment method selection\n- Amount input\n- Cash location\n- Invoice generation',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: TossSpacing.space4),
              Container(
                padding: EdgeInsets.all(TossSpacing.space3),
                decoration: BoxDecoration(
                  color: TossColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Products: ${widget.selectedProducts.length}',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: TossSpacing.space1),
                    ...widget.selectedProducts.map((product) {
                      final quantity = widget.productQuantities[product.productId] ?? 0;
                      return Padding(
                        padding: EdgeInsets.only(top: TossSpacing.space1),
                        child: Text(
                          '• ${product.productName} x $quantity',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.gray700,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
