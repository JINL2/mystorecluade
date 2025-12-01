import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
// Feature imports - sales_invoice
import '../../domain/repositories/product_repository.dart';
import '../providers/payment_providers.dart';
import '../providers/product_providers.dart';
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
  // Exchange rate data
  Map<String, dynamic>? _exchangeRateData;

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
      final exchangeRatesData =
          await ref.read(exchangeRatesProvider(companyId).future);
      if (mounted) {
        setState(() {
          _exchangeRateData = exchangeRatesData;
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

        await ref.read(paymentMethodProvider.notifier).createSalesJournalEntry(
              companyId: companyId,
              storeId: storeId,
              userId: userId,
              amount: totalAmount,
              description: 'Cash sales - Invoice $invoiceNumber',
              lineDescription: journalDescription,
              cashLocationId: paymentState.selectedCashLocation!.id,
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
    final baseCurrencyCode =
        _exchangeRateData?['base_currency']?['currency_code'] ?? 'VND';

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
