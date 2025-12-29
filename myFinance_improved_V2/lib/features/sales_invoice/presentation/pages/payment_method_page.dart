// lib/features/sales_invoice/presentation/pages/payment_method_page.dart
//
// Payment Method Page - Invoice completion flow
// Refactored following Clean Architecture 2025 - Single Responsibility Principle
//
// Extracted widgets:
// - PaymentMethodAppBar: AppBar with exchange rate button
// - ExchangeRateButton: Toggle button for exchange rate panel
// - InvoiceLoadingDialog: Loading dialog for invoice creation
// - ViewItemsSection: Selected products display
// - PaymentBreakdownSection: Discount and total calculation
// - PaymentMethodSection: Cash location selection
// - ExchangeRatePanel: Currency conversion display
// - InvoiceSuccessBottomSheet: Success confirmation

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// App-level providers
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
// Shared imports - themes
import '../../../../shared/themes/toss_spacing.dart';
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
import '../widgets/payment_method/invoice_loading_dialog.dart';
import '../widgets/payment_method/payment_method_app_bar.dart';
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
  ExchangeRateData? _exchangeRateData;
  bool _isExchangeRatePanelExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodNotifierProvider.notifier).loadCurrencyData();
      _loadExchangeRates();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Build
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentMethodNotifierProvider);
    final discountAmount = paymentState.discountAmount;
    final finalTotal = _cartTotal - discountAmount;

    return TossScaffold(
      appBar: PaymentMethodAppBar(
        isExchangeRatePanelExpanded: _isExchangeRatePanelExpanded,
        onExchangeRateToggle: _toggleExchangeRatePanel,
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

  // ============================================================================
  // Helpers
  // ============================================================================

  double get _cartTotal {
    double total = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final price = product.pricing.sellingPrice ?? 0;
      total += price * quantity;
    }
    return total;
  }

  double get _totalCost {
    double totalCost = 0;
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      final cost = product.pricing.costPrice ?? 0;
      totalCost += cost * quantity;
    }
    return totalCost;
  }

  void _toggleExchangeRatePanel() {
    setState(() {
      _isExchangeRatePanelExpanded = !_isExchangeRatePanelExpanded;
    });
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
    } catch (_) {
      // Exchange rate loading failed - will use default rates
    }
  }

  // ============================================================================
  // Invoice Processing
  // ============================================================================

  Future<void> _proceedToInvoice() async {
    final paymentState = ref.read(paymentMethodNotifierProvider);
    final appState = ref.read(appStateProvider);
    final authState = ref.read(authStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final userId = authState.value?.id;

    // Validate required fields
    if (!_validateInvoiceRequirements(companyId, storeId, userId, paymentState)) {
      return;
    }

    // Prepare invoice items
    final items = _prepareInvoiceItems();
    if (items.isEmpty) {
      _showErrorDialog('No Items', 'No valid items to invoice');
      return;
    }

    InvoiceLoadingDialog.show(context);

    try {
      final result = await _createInvoice(
        companyId: companyId,
        storeId: storeId,
        userId: userId!,
        paymentState: paymentState,
        items: items,
      );

      if (mounted) context.pop(); // Close loading dialog

      if (result.success) {
        await _handleInvoiceSuccess(result, paymentState, companyId, storeId, userId);
      } else {
        _showErrorDialog(
          'Invoice Creation Failed',
          result.message ?? 'Failed to create invoice',
        );
      }
    } catch (e) {
      if (mounted) context.pop();
      _showErrorDialog('Error', 'Error creating invoice: ${e.toString()}');
    }
  }

  bool _validateInvoiceRequirements(
    String companyId,
    String storeId,
    String? userId,
    PaymentMethodState paymentState,
  ) {
    if (companyId.isEmpty || storeId.isEmpty || userId == null) {
      _showErrorDialog(
        'Missing Information',
        'Please ensure you are logged in and have selected a company and store.',
      );
      return false;
    }

    if (paymentState.selectedCashLocation == null) {
      _showErrorDialog(
        'Payment Method Required',
        'Please select a cash location before completing the invoice.',
      );
      return false;
    }

    return true;
  }

  List<InvoiceItem> _prepareInvoiceItems() {
    final items = <InvoiceItem>[];
    for (final product in widget.selectedProducts) {
      final quantity = widget.productQuantities[product.productId] ?? 0;
      if (quantity > 0) {
        items.add(
          InvoiceItem(
            productId: product.productId,
            quantity: quantity,
            unitPrice: product.pricing.sellingPrice,
          ),
        );
      }
    }
    return items;
  }

  Future<CreateInvoiceResult> _createInvoice({
    required String companyId,
    required String storeId,
    required String userId,
    required PaymentMethodState paymentState,
    required List<InvoiceItem> items,
  }) async {
    final productRepository = ref.read(productRepositoryProvider);

    String paymentMethod = 'cash';
    if (paymentState.selectedCashLocation != null) {
      paymentMethod =
          paymentState.selectedCashLocation!.isBank ? 'transfer' : 'cash';
    }

    String? notes;
    if (paymentState.selectedCashLocation != null) {
      final cashLoc = paymentState.selectedCashLocation!;
      notes = 'Cash Location: ${cashLoc.name} (${cashLoc.type})';
    }

    return productRepository.createInvoice(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      saleDate: DateTime.now(),
      items: items,
      paymentMethod: paymentMethod,
      discountAmount: paymentState.discountAmount > 0
          ? paymentState.discountAmount.roundToDouble()
          : null,
      taxRate: 0.0,
      notes: notes,
      cashLocationId: paymentState.selectedCashLocation?.id,
    );
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

    // Create journal entry
    await _createJournalEntry(
      paymentState: paymentState,
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      invoiceNumber: invoiceNumber,
      totalAmount: totalAmount,
    );

    // Build warning message
    final warnings = result.warnings ?? [];
    String warningMessage = '';
    if (warnings.isNotEmpty) {
      warningMessage = 'Warnings:\n${warnings.map((w) => '⚠️ $w').join('\n')}';
    }

    // Clear cart and payment selections
    ref.read(cartNotifierProvider.notifier).clearCart();
    ref.read(paymentMethodNotifierProvider.notifier).clearSelections();

    // Show success bottom sheet
    if (mounted) {
      final appState = ref.read(appStateProvider);
      InvoiceSuccessBottomSheet.show(
        context,
        invoiceNumber: invoiceNumber,
        totalAmount: totalAmount,
        currencySymbol: _exchangeRateData?.baseCurrency.symbol ?? 'đ',
        storeName: appState.storeName.isNotEmpty ? appState.storeName : 'Store',
        paymentType: paymentState.selectedCashLocation?.type ?? 'Cash',
        cashLocationName: paymentState.selectedCashLocation?.name ?? 'Cash',
        products: widget.selectedProducts,
        quantities: widget.productQuantities,
        warningMessage: warningMessage,
        onDismiss: () {
          ref.invalidate(salesProductNotifierProvider);
          context.pop();
        },
      );
    }
  }

  Future<void> _createJournalEntry({
    required PaymentMethodState paymentState,
    required String companyId,
    required String storeId,
    required String userId,
    required String invoiceNumber,
    required double totalAmount,
  }) async {
    if (paymentState.selectedCashLocation == null) return;

    try {
      final journalDescription = _buildJournalDescription(paymentState, invoiceNumber);

      await ref.read(paymentMethodNotifierProvider.notifier).createSalesJournalEntry(
            companyId: companyId,
            storeId: storeId,
            userId: userId,
            amount: totalAmount,
            description: 'Cash sales - Invoice $invoiceNumber',
            lineDescription: journalDescription,
            cashLocationId: paymentState.selectedCashLocation!.id,
            totalCost: _totalCost,
          );
    } catch (_) {
      // Journal entry creation failed but don't fail the whole transaction
    }
  }

  String _buildJournalDescription(PaymentMethodState paymentState, String invoiceNumber) {
    final baseCurrencyCode = _exchangeRateData?.baseCurrency.currencyCode ?? 'VND';

    String description = '';
    if (widget.selectedProducts.length == 1) {
      description = widget.selectedProducts.first.productName;
    } else if (widget.selectedProducts.isNotEmpty) {
      final additionalCount = widget.selectedProducts.length - 1;
      description = '${widget.selectedProducts.first.productName} +$additionalCount products';
    }

    if (paymentState.discountAmount > 0) {
      final discountFormatted = paymentState.discountAmount.toStringAsFixed(0);
      description += ' $discountFormatted$baseCurrencyCode discount';
    }

    return description.isEmpty ? 'Sales - Invoice $invoiceNumber' : description;
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
