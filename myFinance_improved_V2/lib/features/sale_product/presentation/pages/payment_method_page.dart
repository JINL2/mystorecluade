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
// Feature imports - sale_product domain
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/exchange_rate_data.dart';
import '../../domain/repositories/payment_repository.dart';
// Feature imports - sale_product presentation
import '../helpers/exchange_rate_helper.dart';
import '../../di/sale_product_providers.dart';
import '../providers/payment_providers.dart';
import '../providers/sales_product_provider.dart';
import '../providers/states/payment_method_state.dart';
import '../providers/cart_provider.dart';
// Sale product entities
import '../../domain/entities/sales_product.dart';
// Extracted widgets
import '../widgets/payment_method/bottom_sheets/invoice_success_bottom_sheet.dart';
import '../widgets/payment_method/sections/exchange_rate_panel.dart';
import '../widgets/payment_method/sections/payment_breakdown_section.dart';
import '../widgets/payment_method/sections/payment_method_section.dart';
import '../widgets/payment_method/sections/view_items_section.dart';

class PaymentMethodPage extends ConsumerStatefulWidget {
  final List<SalesProduct> selectedProducts;
  final Map<String, int> productQuantities;
  final ExchangeRateData? exchangeRateData;
  final List<CashLocation> cashLocations;

  const PaymentMethodPage({
    super.key,
    required this.selectedProducts,
    required this.productQuantities,
    this.exchangeRateData,
    this.cashLocations = const [],
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
    // Use exchange rate data passed from SaleProductPage if available
    if (widget.exchangeRateData != null) {
      _exchangeRateData = widget.exchangeRateData;
    }
    // Set preloaded cash locations (already loaded in SaleProductPage)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Cash locations are preloaded in SaleProductPage via salePreloadProvider
      // No RPC call needed here - just set the data to provider
      ref
          .read(paymentMethodProvider.notifier)
          .setCashLocations(widget.cashLocations);

      // Only load exchange rates if not already provided
      if (_exchangeRateData == null) {
        _loadExchangeRates();
      }
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

    // Determine if invoice can be completed
    // - finalTotal >= 0 (allow free/gift, but not negative)
    // - cash location must be selected
    final bool canCompleteInvoice = finalTotal >= 0 &&
        paymentState.selectedCashLocation != null;

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
                      currencySymbol:
                          _exchangeRateData?.baseCurrency.symbol ?? '₫',
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
                isEnabled: canCompleteInvoice,
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
    print('🚀 [INVOICE] _proceedToInvoice() START');

    final paymentState = ref.read(paymentMethodProvider);
    print('📋 [INVOICE] paymentState: selectedCashLocation=${paymentState.selectedCashLocation?.name}, discountAmount=${paymentState.discountAmount}');

    // Get required IDs
    final appState = ref.read(appStateProvider);
    final authState = ref.read(authStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;
    final userId = authState.value?.id;

    print('🔑 [INVOICE] IDs: companyId=$companyId, storeId=$storeId, userId=$userId');

    // Validate required fields
    if (companyId.isEmpty || storeId.isEmpty || userId == null) {
      print('❌ [INVOICE] VALIDATION FAILED: Missing IDs');
      _showErrorDialog(
        'Missing Information',
        'Please ensure you are logged in and have selected a company and store.',
      );
      return;
    }

    // Validate cash location is selected
    if (paymentState.selectedCashLocation == null) {
      print('❌ [INVOICE] VALIDATION FAILED: No cash location selected');
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
        print('📦 [INVOICE] Item: productId=${product.productId}, quantity=$quantity, unitPrice=$sellingPrice');
      }
    }

    if (items.isEmpty) {
      print('❌ [INVOICE] VALIDATION FAILED: No items');
      _showErrorDialog('No Items', 'No valid items to invoice');
      return;
    }

    print('✅ [INVOICE] Validation passed. Total items: ${items.length}');

    // Show loading indicator
    _showLoadingDialog();

    try {
      // Get repository via provider
      final paymentRepository = ref.read(paymentRepositoryProvider);
      print('🔧 [INVOICE] Got paymentRepository');

      // Determine payment method based on cash location type
      String paymentMethod = 'cash';
      if (paymentState.selectedCashLocation != null) {
        paymentMethod =
            paymentState.selectedCashLocation!.isBank ? 'transfer' : 'cash';
      }
      print('💳 [INVOICE] paymentMethod=$paymentMethod');

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
      print('📝 [INVOICE] invoiceItems prepared: ${invoiceItems.length} items');

      // Build notes from cash location info
      String? notes;
      if (paymentState.selectedCashLocation != null) {
        final cashLoc = paymentState.selectedCashLocation!;
        notes = 'Cash Location: ${cashLoc.name} (${cashLoc.type})';
      }
      print('📄 [INVOICE] notes=$notes');

      final saleDate = DateTime.now();
      final discountAmt = paymentState.discountAmount > 0
          ? paymentState.discountAmount.roundToDouble()
          : null;
      final cashLocId = paymentState.selectedCashLocation?.id;

      print('📤 [INVOICE] Calling createInvoice with:');
      print('   companyId: $companyId');
      print('   storeId: $storeId');
      print('   userId: $userId');
      print('   saleDate: $saleDate');
      print('   items count: ${invoiceItems.length}');
      print('   paymentMethod: $paymentMethod');
      print('   discountAmount: $discountAmt');
      print('   taxRate: 0.0');
      print('   notes: $notes');
      print('   cashLocationId: $cashLocId');

      // Call repository to create invoice
      final result = await paymentRepository.createInvoice(
        companyId: companyId,
        storeId: storeId,
        userId: userId,
        saleDate: saleDate,
        items: invoiceItems,
        paymentMethod: paymentMethod,
        discountAmount: discountAmt,
        taxRate: 0.0,
        notes: notes,
        cashLocationId: cashLocId,
      );

      print('📥 [INVOICE] createInvoice result:');
      print('   success: ${result.success}');
      print('   invoiceNumber: ${result.invoiceNumber}');
      print('   totalAmount: ${result.totalAmount}');
      print('   message: ${result.message}');
      print('   warnings: ${result.warnings}');

      // Close loading dialog
      if (mounted) {
        context.pop();
      }

      // Check response
      if (result.success) {
        print('✅ [INVOICE] Invoice SUCCESS! Calling _handleInvoiceSuccess');
        await _handleInvoiceSuccess(
          result,
          paymentState,
          companyId,
          storeId,
          userId,
        );
      } else {
        print('❌ [INVOICE] Invoice FAILED: ${result.message}');
        _showErrorDialog(
          'Invoice Creation Failed',
          result.message ?? 'Failed to create invoice',
        );
      }
    } catch (e, stackTrace) {
      print('💥 [INVOICE] EXCEPTION: $e');
      print('📚 [INVOICE] StackTrace: $stackTrace');

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
    final invoiceId = result.invoiceId;
    final invoiceNumber = result.invoiceNumber ?? 'Unknown';
    final totalAmount = result.totalAmount ?? 0;

    // Create journal entry for the cash sales transaction
    try {
      print('📒 [JOURNAL] Starting journal entry creation...');
      print('📒 [JOURNAL] selectedCashLocation: ${paymentState.selectedCashLocation}');
      print('📒 [JOURNAL] invoiceId: $invoiceId');

      if (paymentState.selectedCashLocation != null && invoiceId != null) {
        final journalDescription = _buildJournalDescription(
          paymentState,
          invoiceNumber,
        );

        // Calculate total cost for COGS entry
        final totalCost = _getTotalCost();

        print('📒 [JOURNAL] Calling createSalesJournalEntry...');
        print('📒 [JOURNAL] amount: $totalAmount, totalCost: $totalCost');
        print('📒 [JOURNAL] cashLocationId: ${paymentState.selectedCashLocation!.id}');

        await ref.read(paymentMethodProvider.notifier).createSalesJournalEntry(
              companyId: companyId,
              storeId: storeId,
              userId: userId,
              amount: totalAmount,
              description: 'Cash sales - Invoice $invoiceNumber',
              lineDescription: journalDescription,
              cashLocationId: paymentState.selectedCashLocation!.id,
              totalCost: totalCost,
              invoiceId: invoiceId,
            );
        print('✅ [JOURNAL] Journal entry created successfully!');
      } else {
        print('⚠️ [JOURNAL] Skipped - selectedCashLocation: ${paymentState.selectedCashLocation != null}, invoiceId: ${invoiceId != null}');
      }
    } catch (journalError) {
      print('❌ [JOURNAL] Error creating journal entry: $journalError');
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
