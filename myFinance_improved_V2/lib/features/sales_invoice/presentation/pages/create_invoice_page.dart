import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_scaffold.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../../../shared/widgets/toss/toss_search_field.dart';
import '../../domain/entities/sales_product.dart';
import '../providers/invoice_creation_provider.dart';
import '../widgets/create_invoice/added_items_section.dart';
import '../widgets/create_invoice/invoice_bottom_button.dart';
import '../widgets/create_invoice/product_list_section.dart';

class CreateInvoicePage extends ConsumerStatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  ConsumerState<CreateInvoicePage> createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends ConsumerState<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize products load when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(invoiceCreationProvider.notifier).loadProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    ref.read(invoiceCreationProvider.notifier).searchProducts(query);
  }

  void _updateProductCount(SalesProduct product, int count) {
    ref.read(invoiceCreationProvider.notifier).updateProductCount(product, count);
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Create Invoice',
        backgroundColor: TossColors.gray100,
        leading: IconButton(
          icon: const Icon(Icons.close, size: TossSpacing.iconMD),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Search Field
              _buildSearchSection(),

              // Added Items Section
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(invoiceCreationProvider);
                  if (state.selectedProducts.isNotEmpty) {
                    return AddedItemsSection(
                      onUpdateProductCount: _updateProductCount,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Product List with bottom padding for button
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: ProductListSection(
                    onUpdateProductCount: _updateProductCount,
                  ),
                ),
              ),

              // Fixed Bottom Button
              InvoiceBottomButton(
                onPressed: _proceedToNext,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      child: TossSearchField(
        controller: _searchController,
        hintText: 'Search products to add...',
        onChanged: _filterProducts,
      ),
    );
  }

  void _proceedToNext() {
    final state = ref.read(invoiceCreationProvider);

    if (state.selectedProducts.isEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => TossDialog.error(
          title: 'No Products Selected',
          message: 'Please add at least one product',
          primaryButtonText: 'OK',
          onPrimaryPressed: () => context.pop(),
        ),
      );
      return;
    }

    // TODO: Uncomment when PaymentMethodPage is created
    // Get selected products and their quantities
    // final selectedProducts = <SalesProduct>[];
    // final productQuantities = Map<String, int>.from(state.selectedProducts);

    // if (state.productData != null) {
    //   for (final productId in state.selectedProducts.keys) {
    //     try {
    //       final product = state.productData!.products
    //           .firstWhere((p) => p.productId == productId);
    //       selectedProducts.add(product);
    //     } catch (e) {
    //       debugPrint('Warning: Product with ID $productId not found');
    //     }
    //   }
    // }

    // Navigate to payment method selection page
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (context) => PaymentMethodPage(
    //       selectedProducts: selectedProducts,
    //       productQuantities: productQuantities,
    //     ),
    //   ),
    // );

    // Temporary placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment method page coming soon (${state.totalSelectedItems} items selected)',
        ),
        backgroundColor: TossColors.primary,
      ),
    );
  }
}
