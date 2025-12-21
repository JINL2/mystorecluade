import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App-level providers
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
// Shared imports - themes
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
// Shared imports - widgets
import '../../../../shared/widgets/common/gray_divider_space.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_button.dart';
// Feature imports - journal_input (for exchangeRatesProvider)
import '../../../journal_input/presentation/providers/journal_input_providers.dart';
// Feature imports - sale_product
import '../../../sale_product/domain/entities/sales_product.dart';
import '../../../sale_product/presentation/providers/cart_provider.dart';
import '../../../sale_product/presentation/providers/sales_product_provider.dart';
// Feature imports - sales_invoice
import '../../domain/entities/exchange_rate_data.dart';
import '../../domain/repositories/product_repository.dart';
import '../helpers/exchange_rate_helper.dart';
import '../providers/payment_providers.dart';
import '../providers/product_providers.dart';
import '../providers/states/payment_method_state.dart';
// Extracted widgets
import '../widgets/payment_method/bottom_sheets/invoice_success_bottom_sheet.dart';
import '../widgets/payment_method/sections/exchange_rate_panel.dart';
import '../widgets/payment_method/sections/payment_breakdown_section.dart';
import '../widgets/payment_method/sections/payment_method_section.dart';
import '../widgets/payment_method/sections/view_items_section.dart';

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
  ExchangeRateData? _exchangeRateData;
  // Controls visibility of exchange rate panel
  bool _isExchangeRatePanelExpanded = false;
  // Scroll controller for auto-scrolling when dropdown expands
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load currency and cash location data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodProvider.notifier).loadCurrencyData();
      _loadExchangeRates();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
          _exchangeRateData = ExchangeRateHelper.fromJson(exchangeRatesJson);
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
    final paymentState = ref.watch(paymentMethodProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = _cartTotal - discountAmount;

    return TossScaffold(
      backgroundColor: TossColors.white,
      appBar: AppBar(
        backgroundColor: TossColors.gray50,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Text(
          'Sales Invoice',
          style: TossTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: TossColors.gray900,
          ),
        ),
        actions: [
          _buildExchangeRateButton(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exchange Rate Panel (collapsible)
                  if (_exchangeRateData != null && _isExchangeRatePanelExpanded)
                    Padding(
                      padding: const EdgeInsets.all(TossSpacing.space3),
                      child: ExchangeRatePanel(
                        exchangeRateData: _exchangeRateData!,
                        finalTotal: finalTotal,
                      ),
                    ),

                  // View Items Section
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    child: ViewItemsSection(
                      selectedProducts: widget.selectedProducts,
                      productQuantities: widget.productQuantities,
                    ),
                  ),

                  // Section Divider - Full width
                  const GrayDividerSpace(),

                  // Payment Breakdown Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TossSpacing.space3,
                    ),
                    child: PaymentBreakdownSection(
                      selectedProducts: widget.selectedProducts,
                      productQuantities: widget.productQuantities,
                    ),
                  ),

                  // Section Divider - Full width
                  const GrayDividerSpace(),

                  // Payment Method Section
                  Padding(
                    padding: const EdgeInsets.all(TossSpacing.space3),
                    child: PaymentMethodSection(
                      onExpand: _scrollToBottom,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Complete Invoice Button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(TossSpacing.space3),
              child: TossButton.primary(
                text: 'Complete Invoice',
                onPressed: _proceedToInvoice,
                fullWidth: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExchangeRatePanelExpanded = !_isExchangeRatePanelExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: TossSpacing.space3),
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space2 + 2,
          vertical: TossSpacing.space1,
        ),
        decoration: BoxDecoration(
          color: TossColors.gray100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Exchange Rate',
              style: TossTextStyles.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(width: TossSpacing.space1),
            Icon(
              _isExchangeRatePanelExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 16,
              color: TossColors.gray600,
            ),
          ],
        ),
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

    // Validate cash location is selected
    if (paymentState.selectedCashLocation == null) {
      _showErrorDialog(
        'Payment Method Required',
        'Please select a cash location before completing the invoice.',
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
        invoiceItems.add(
          InvoiceItem(
            productId: item['product_id'] as String,
            quantity: item['quantity'] as int,
            unitPrice: item['unit_price'] as double?,
          ),
        );
      }

      // Build notes from cash location info
      String? notes;
      if (paymentState.selectedCashLocation != null) {
        final cashLoc = paymentState.selectedCashLocation!;
        notes = 'Cash Location: ${cashLoc.name} (${cashLoc.type})';
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
          result,
          paymentState,
          companyId,
          storeId,
          userId,
        );
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

    // Get store name from app state
    final appState = ref.read(appStateProvider);
    final storeName = appState.storeName.isNotEmpty
        ? appState.storeName
        : 'Store';

    // Get currency symbol from exchange rate data
    final currencySymbol = _exchangeRateData?.baseCurrency.symbol ?? 'đ';

    // Get payment type (Cash, Bank, Vault)
    final paymentType = paymentState.selectedCashLocation?.type ?? 'Cash';

    // Get cash location name
    final cashLocationName = paymentState.selectedCashLocation?.name ?? 'Cash';

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
        currencySymbol: currencySymbol,
        storeName: storeName,
        paymentType: paymentType,
        cashLocationName: cashLocationName,
        products: widget.selectedProducts,
        quantities: widget.productQuantities,
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

  double _getTotalCost() {
    double totalCost = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final cost = product.pricing.costPrice ?? 0;
      totalCost += cost * quantity;
    }
    return totalCost;
  }

  String _buildJournalDescription(
    PaymentMethodState paymentState,
    String invoiceNumber,
  ) {
    final baseCurrencyCode =
        _exchangeRateData?.baseCurrency.currencyCode ?? 'VND';

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
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space5),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(12),
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
