import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// App-level providers
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
// Shared imports - themes
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
// Shared imports - widgets
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
// Feature imports - journal_input (for exchangeRatesProvider)
import '../../../journal_input/presentation/providers/journal_input_providers.dart';
// Feature imports - sale_product
import '../../../sale_product/domain/entities/sales_product.dart';
import '../../../sale_product/presentation/providers/cart_provider.dart';
import '../../../sale_product/presentation/providers/sales_product_provider.dart';
import '../../../sale_product/presentation/widgets/common/product_image_widget.dart';
// Feature imports - sales_invoice
import '../../data/models/exchange_rate_data_model.dart';
import '../../domain/entities/exchange_rate_data.dart' as entities;
import '../../domain/repositories/product_repository.dart';
import '../providers/payment_providers.dart';
import '../providers/product_providers.dart';
import '../providers/states/payment_method_state.dart';
// Extracted widgets
import '../widgets/payment_method/bottom_sheets/invoice_success_bottom_sheet.dart';
import '../widgets/payment_method/payment_bottom_button.dart';
import '../widgets/payment_method/sections/cash_location_section.dart';
import '../widgets/payment_method/sections/currency_converter_section.dart';
import '../widgets/payment_method/sections/discount_total_section.dart';

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
  // Exchange rate data (strongly typed)
  entities.ExchangeRateData? _exchangeRateData;

  @override
  void initState() {
    super.initState();
    // Load currency and cash location data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodProvider.notifier).loadCurrencyData();
      _loadExchangeRates();
    });
  }

  Future<void> _loadExchangeRates() async {
    final appState = ref.read(appStateProvider);
    final String companyId = appState.companyChoosen;

    if (companyId.isEmpty) return;

    try {
      final exchangeRatesJson =
          await ref.read(exchangeRatesProvider(companyId).future);
      if (mounted) {
        setState(() {
          if (exchangeRatesJson != null) {
            _exchangeRateData = ExchangeRateDataModel(exchangeRatesJson).toEntity();
          }
        });
      }
    } catch (e) {
      // Exchange rate loading failed - will use default rates
    }
  }

  double get _cartTotal {
    double total = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing.sellingPrice ?? 0;
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Payment Method',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: TossSpacing.iconMD),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: TossSpacing.space2,
                bottom: TossSpacing.space2,
              ),
              child: _buildPaymentMethodSelection(),
            ),
          ),
          SafeArea(
            top: false,
            child: PaymentBottomButton(
              selectedProducts: widget.selectedProducts,
              productQuantities: widget.productQuantities,
              onPressed: _proceedToInvoice,
            ),
          ),
        ],
      ),
    );
  }

  void _showViewItemsBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TossColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(TossBorderRadius.xl),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: TossSpacing.space3),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: TossColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(TossSpacing.space4),
              child: Row(
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: TossColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: TossSpacing.space2),
                  Text(
                    'Selected Items',
                    style: TossTextStyles.h4.copyWith(
                      color: TossColors.gray900,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space2,
                      vertical: TossSpacing.space1,
                    ),
                    decoration: BoxDecoration(
                      color: TossColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                    ),
                    child: Text(
                      '${_getTotalItemCount()} items',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: TossColors.gray200),
            // Items list
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: TossSpacing.space2),
                itemCount: widget.selectedProducts.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: TossColors.gray100,
                  indent: TossSpacing.space4,
                  endIndent: TossSpacing.space4,
                ),
                itemBuilder: (context, index) {
                  final product = widget.selectedProducts[index];
                  final quantity = widget.productQuantities[product.productId] ?? 0;
                  final price = product.pricing.sellingPrice ?? 0;
                  final subtotal = price * quantity;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space4,
                      vertical: TossSpacing.space3,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Product Image
                        ProductImageWidget(
                          imageUrl: product.images.mainImage,
                          size: 48,
                          fallbackIcon: Icons.inventory_2,
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
                                  fontWeight: FontWeight.w500,
                                  color: TossColors.gray900,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: TossSpacing.space1),
                              Text(
                                product.sku,
                                style: TossTextStyles.bodySmall.copyWith(
                                  color: TossColors.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: TossSpacing.space3),
                        // Quantity and price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: TossSpacing.space2,
                                vertical: TossSpacing.space1,
                              ),
                              decoration: BoxDecoration(
                                color: TossColors.gray100,
                                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                              ),
                              child: Text(
                                'x$quantity',
                                style: TossTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: TossColors.gray700,
                                ),
                              ),
                            ),
                            const SizedBox(height: TossSpacing.space1),
                            Text(
                              NumberFormat('#,###').format(subtotal.round()),
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.gray900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Total Cost Summary
            Container(
              padding: const EdgeInsets.all(TossSpacing.space4),
              decoration: const BoxDecoration(
                color: TossColors.gray50,
                border: Border(
                  top: BorderSide(color: TossColors.gray200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Cost',
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray700,
                    ),
                  ),
                  Text(
                    NumberFormat('#,###').format(_getTotalCost().round()),
                    style: TossTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: TossColors.gray900,
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

  int _getTotalItemCount() {
    int total = 0;
    for (final quantity in widget.productQuantities.values) {
      total += quantity;
    }
    return total;
  }

  double _getTotalCost() {
    double totalCost = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final cost = product.pricing.costPrice ?? 0;
      totalCost += cost * quantity;
    }
    return totalCost;
  }

  Widget _buildViewItemsSection() {
    return GestureDetector(
      onTap: _showViewItemsBottomSheet,
      child: Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.surface,
          borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: TossColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              color: TossColors.primary,
              size: 22,
            ),
            const SizedBox(width: TossSpacing.space3),
            Text(
              'View Items',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(width: TossSpacing.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space2,
                vertical: TossSpacing.space1,
              ),
              decoration: BoxDecoration(
                color: TossColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: Text(
                '${_getTotalItemCount()}',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: TossColors.gray400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    final paymentState = ref.watch(paymentMethodProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = _cartTotal - discountAmount;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View Items Section
          _buildViewItemsSection(),

          const SizedBox(height: TossSpacing.space4),

          // Unified Discount and Total Section
          DiscountTotalSection(
            selectedProducts: widget.selectedProducts,
            productQuantities: widget.productQuantities,
          ),

          const SizedBox(height: TossSpacing.space4),

          // Cash Location Selection
          const CashLocationSection(),

          // Currency Converter Section
          if (_exchangeRateData != null) ...[
            const SizedBox(height: TossSpacing.space4),
            CurrencyConverterSection(
              exchangeRateData: _exchangeRateData!,
              finalTotal: finalTotal,
            ),
          ],

          // Add extra padding for better scrolling when keyboard is open
          const SizedBox(height: TossSpacing.space8),
        ],
      ),
    );
  }

  Future<void> _proceedToInvoice() async {
    final paymentState = ref.read(paymentMethodProvider);

    // Get required IDs
    final appState = ref.read(appStateProvider);
    final authState = ref.read(authStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final userId = authState.value?.id;

    // Validate required fields
    if (companyId.isEmpty || storeId.isEmpty || userId == null) {
      _showErrorDialog(
        'Missing Information',
        'Please ensure you are logged in and have selected a company and store.',
      );
      return;
    }

    // Format items array for the RPC
    final items = <Map<String, dynamic>>[];
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      if (quantity > 0) {
        final itemData = <String, dynamic>{
          'product_id': product.productId,
          'quantity': quantity,
        };

        final sellingPrice = product.pricing.sellingPrice;
        if (sellingPrice != null && sellingPrice > 0) {
          itemData['unit_price'] = sellingPrice;
        }

        items.add(itemData);
      }
    }

    if (items.isEmpty) {
      _showErrorDialog('No Items', 'No valid items to invoice');
      return;
    }

    // Show loading indicator
    _showLoadingDialog();

    try {
      // Get repository via provider
      final productRepository = ref.read(productRepositoryProvider);

      // Determine payment method based on cash location type
      String paymentMethod = 'cash';
      if (paymentState.selectedCashLocation != null) {
        paymentMethod =
            paymentState.selectedCashLocation!.isBank ? 'transfer' : 'cash';
      }

      // Prepare invoice items
      final invoiceItems = <InvoiceItem>[];
      for (final item in items) {
        invoiceItems.add(InvoiceItem(
          productId: item['product_id'] as String,
          quantity: item['quantity'] as int,
          unitPrice: item['unit_price'] as double?,
        ));
      }

      // Build notes from cash location info
      String? notes;
      if (paymentState.selectedCashLocation != null) {
        final cashLoc = paymentState.selectedCashLocation!;
        notes =
            'Cash Location: ${cashLoc.displayName} (${cashLoc.displayType})';
      }

      // Call repository to create invoice
      final result = await productRepository.createInvoice(
        companyId: companyId,
        storeId: storeId,
        userId: userId,
        saleDate: DateTime.now(),
        items: invoiceItems,
        paymentMethod: paymentMethod,
        discountAmount: paymentState.discountAmount > 0
            ? paymentState.discountAmount.roundToDouble()
            : null,
        taxRate: 0.0,
        notes: notes,
        cashLocationId: paymentState.selectedCashLocation?.id,
      );

      // Close loading dialog
      if (mounted) {
        context.pop();
      }

      // Check response
      if (result.success) {
        await _handleInvoiceSuccess(
            result, paymentState, companyId, storeId, userId);
      } else {
        _showErrorDialog(
          'Invoice Creation Failed',
          result.message ?? 'Failed to create invoice',
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        context.pop();
      }

      _showErrorDialog('Error', 'Error creating invoice: ${e.toString()}');
    }
  }

  Future<void> _handleInvoiceSuccess(
    CreateInvoiceResult result,
    PaymentMethodState paymentState,
    String companyId,
    String storeId,
    String userId,
  ) async {
    final invoiceNumber = result.invoiceNumber ?? 'Unknown';
    final totalAmount = result.totalAmount ?? 0;

    // Create journal entry for the cash sales transaction
    try {
      if (paymentState.selectedCashLocation != null) {
        final journalDescription = _buildJournalDescription(
          paymentState,
          invoiceNumber,
        );

        // Calculate total cost for COGS entry
        final totalCost = _getTotalCost();

        await ref.read(paymentMethodProvider.notifier).createSalesJournalEntry(
              companyId: companyId,
              storeId: storeId,
              userId: userId,
              amount: totalAmount,
              description: 'Cash sales - Invoice $invoiceNumber',
              lineDescription: journalDescription,
              cashLocationId: paymentState.selectedCashLocation!.id,
              totalCost: totalCost,
            );
      }
    } catch (journalError) {
      // Journal entry creation failed but don't fail the whole transaction
    }

    // Build warning message
    final warnings = result.warnings ?? [];
    String warningMessage = '';
    if (warnings.isNotEmpty) {
      warningMessage = 'Warnings:\n';
      for (final warning in warnings) {
        warningMessage += '⚠️ $warning\n';
      }
    }

    // Clear the cart
    ref.read(cartProvider.notifier).clearCart();

    // Clear payment method selections for next invoice
    ref.read(paymentMethodProvider.notifier).clearSelections();

    // Show success bottom sheet
    if (mounted) {
      InvoiceSuccessBottomSheet.show(
        context,
        invoiceNumber: invoiceNumber,
        totalAmount: totalAmount,
        warningMessage: warningMessage,
        onDismiss: () {
          // Force refresh of sales product data
          ref.invalidate(salesProductProvider);
          // Navigate back to Sales Product page
          context.pop();
        },
      );
    }
  }

  String _buildJournalDescription(
    PaymentMethodState paymentState,
    String invoiceNumber,
  ) {
    final baseCurrencyCode = _exchangeRateData?.baseCurrency.currencyCode ?? 'VND';

    String journalDescription = '';

    if (widget.selectedProducts.length == 1) {
      journalDescription = widget.selectedProducts.first.productName;
    } else if (widget.selectedProducts.isNotEmpty) {
      final additionalCount = widget.selectedProducts.length - 1;
      journalDescription =
          '${widget.selectedProducts.first.productName} +$additionalCount products';
    }

    if (paymentState.discountAmount > 0) {
      final discountFormatted = paymentState.discountAmount.toStringAsFixed(0);
      journalDescription += ' $discountFormatted$baseCurrencyCode discount';
    }

    if (journalDescription.isEmpty) {
      journalDescription = 'Sales - Invoice $invoiceNumber';
    }

    return journalDescription;
  }

  void _showLoadingDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(TossSpacing.space5),
          decoration: BoxDecoration(
            color: TossColors.white,
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: TossColors.primary),
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Creating invoice...',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => TossDialog.error(
        title: title,
        message: message,
        primaryButtonText: 'OK',
        onPrimaryPressed: () => context.pop(),
      ),
    );
  }
}
