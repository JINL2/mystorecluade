import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/counterparty_provider.dart';
import '../../../../core/domain/entities/selector_entities.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../providers/po_providers.dart';

class POFormPage extends ConsumerStatefulWidget {
  final String? poId;

  const POFormPage({super.key, this.poId});

  @override
  ConsumerState<POFormPage> createState() => _POFormPageState();
}

class _POFormPageState extends ConsumerState<POFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _orderTitleController = TextEditingController();
  final _notesController = TextEditingController();
  final _productSearchController = TextEditingController();

  // Supplier - One-time supplier fields
  final _supplierNameController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _supplierAddressController = TextEditingController();

  // Search debounce timer
  Timer? _searchDebounce;

  // Form values
  bool _isExistingSupplier = true;
  String? _selectedSupplierId;
  CounterpartyData? _selectedSupplier;

  // Items
  List<OrderItemData> _items = [];

  // Validation errors
  String? _orderTitleError;
  String? _supplierError;

  bool get isEditMode => widget.poId != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeForm();
    });
  }

  Future<void> _initializeForm() async {
    // Generate PO number for new orders
    if (!isEditMode) {
      ref.read(poFormProvider.notifier).generateNumber();
    }
  }

  @override
  void dispose() {
    _orderTitleController.dispose();
    _notesController.dispose();
    _productSearchController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _supplierEmailController.dispose();
    _supplierAddressController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(poFormProvider);

    return TossScaffold(
      appBar: TossAppBar(
        title: isEditMode ? 'Edit Order' : 'New Order',
        leading: TossIconButton.ghost(
          icon: LucideIcons.x,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/purchase-order');
            }
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(TossSpacing.space4),
                children: [
                  // 1. Order Title (Required)
                  _buildOrderTitleSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 2. Order Items
                  _buildOrderItemsSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 3. Supplier Information
                  _buildSupplierSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 4. Notes (Optional)
                  _buildNotesSection(),

                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          ),
          // Bottom Save Button
          Container(
            padding: EdgeInsets.only(
              left: TossSpacing.space4,
              right: TossSpacing.space4,
              top: TossSpacing.space3,
              bottom: MediaQuery.of(context).padding.bottom + TossSpacing.space3,
            ),
            decoration: const BoxDecoration(
              color: TossColors.white,
              border: Border(
                top: BorderSide(color: TossColors.gray200, width: 1),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: TossButton.primary(
                text: isEditMode ? 'Update Order' : 'Create Order',
                isLoading: formState.isSaving,
                onPressed: formState.isSaving ? null : _handleSave,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Order Title', isRequired: true),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _orderTitleController,
          hintText: 'Enter order title',
          errorText: _orderTitleError,
          onChanged: (_) {
            if (_orderTitleError != null) {
              setState(() => _orderTitleError = null);
            }
          },
        ),
      ],
    );
  }

  Widget _buildOrderItemsSection() {
    final searchState = ref.watch(productSearchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Order Items', isRequired: true),
        const SizedBox(height: TossSpacing.space2),

        // Search bar
        TossTextField.filled(
          controller: _productSearchController,
          hintText: 'Search products by name, SKU, or barcode',
          prefixIcon: const Icon(LucideIcons.search, color: TossColors.gray400),
          suffixIcon: _productSearchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, color: TossColors.gray400),
                  onPressed: () {
                    _productSearchController.clear();
                    ref.read(productSearchProvider.notifier).clear();
                  },
                )
              : null,
          onChanged: _onSearchChanged,
        ),

        // Search results
        if (searchState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: TossSpacing.space4),
            child: Center(child: TossLoadingView()),
          )
        else if (searchState.searchQuery.isNotEmpty && searchState.items.isNotEmpty)
          _buildSearchResults(searchState.items)
        else if (searchState.searchQuery.isNotEmpty && searchState.items.isEmpty)
          _buildNoSearchResults(),

        const SizedBox(height: TossSpacing.space4),

        // Added items list
        if (_items.isNotEmpty) ...[
          Text(
            'Added Items (${_items.length})',
            style: TossTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: TossColors.gray700,
            ),
          ),
          const SizedBox(height: TossSpacing.space2),
          ..._items.asMap().entries.map(
                (entry) => _buildItemCard(entry.key, entry.value),
              ),
        ] else
          _buildEmptyItemsPlaceholder(),
      ],
    );
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(productSearchProvider.notifier).search(value);
    });
  }

  Widget _buildSearchResults(List<InventoryProductItem> items) {
    return Container(
      margin: const EdgeInsets.only(top: TossSpacing.space2),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: TossColors.white,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: TossColors.gray200),
        boxShadow: [
          BoxShadow(
            color: TossColors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RawScrollbar(
        thumbColor: TossColors.gray300,
        radius: const Radius.circular(4),
        thickness: 4,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = items[index];
          final isAlreadyAdded = _items.any((i) => i.productId == item.uniqueKey);

          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: TossSpacing.space3,
              vertical: TossSpacing.space1,
            ),
            title: Text(
              item.displayName,
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isAlreadyAdded ? TossColors.gray400 : TossColors.gray900,
              ),
            ),
            subtitle: Text(
              '${item.displaySku ?? ''} • Stock: ${item.quantityOnHand.toInt()} ${item.unit}',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
            trailing: isAlreadyAdded
                ? TossBadge(label: 'Added')
                : Text(
                    _formatPrice(item.costPrice),
                    style: TossTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.primary,
                    ),
                  ),
            onTap: isAlreadyAdded ? null : () => _addProductItem(item),
          );
        },
        ),
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.only(top: TossSpacing.space2),
      child: TossCard(
        backgroundColor: TossColors.gray50,
        child: Center(
          child: Text(
            'No products found',
            style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyItemsPlaceholder() {
    return TossCard(
      backgroundColor: TossColors.gray50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.shoppingCart,
              size: TossSpacing.icon3XL,
              color: TossColors.gray400,
            ),
            const SizedBox(height: TossSpacing.space3),
            Text(
              'No items added yet',
              style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
            ),
            const SizedBox(height: TossSpacing.space1),
            Text(
              'Search and select products above',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(int index, OrderItemData item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product name and delete button
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 20),
                color: TossColors.gray400,
                onPressed: () => _deleteItem(index),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (item.sku != null) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              'SKU: ${item.sku}',
              style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
            ),
          ],
          const SizedBox(height: TossSpacing.space3),

          // Quantity and price row
          Row(
            children: [
              // Quantity controls using design system component
              TossQuantityInput(
                value: item.quantity.toInt(),
                minValue: 1,
                onChanged: (value) => _updateQuantity(index, value.toDouble()),
              ),
              const SizedBox(width: TossSpacing.space2),
              Text(
                item.unit,
                style: TossTextStyles.bodySmall.copyWith(color: TossColors.gray500),
              ),
              const Spacer(),

              // Price and total
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPrice(item.unitPrice)} × ${item.quantity.toInt()}',
                    style: TossTextStyles.caption.copyWith(color: TossColors.gray500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatPrice(item.total),
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return NumberFormat('#,##0').format(price);
  }

  void _addProductItem(InventoryProductItem product) {
    setState(() {
      _items.add(OrderItemData(
        productId: product.uniqueKey,
        name: product.displayName,
        sku: product.displaySku,
        quantity: 1,
        unit: product.unit,
        unitPrice: product.costPrice,
        variantId: product.variantId,
      ));
    });

    // Clear search
    _productSearchController.clear();
    ref.read(productSearchProvider.notifier).clear();
  }

  void _updateQuantity(int index, double newQuantity) {
    if (newQuantity < 1) return;
    setState(() {
      final item = _items[index];
      _items[index] = OrderItemData(
        productId: item.productId,
        name: item.name,
        sku: item.sku,
        quantity: newQuantity,
        unit: item.unit,
        unitPrice: item.unitPrice,
        variantId: item.variantId,
      );
    });
  }

  Widget _buildSupplierSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Supplier Information', isRequired: true),
        const SizedBox(height: TossSpacing.space3),

        // Toggle: Existing vs One-time supplier
        _buildSupplierTypeToggle(),
        const SizedBox(height: TossSpacing.space4),

        // Supplier form based on type
        if (_isExistingSupplier)
          _buildExistingSupplierSelector()
        else
          _buildOneTimeSupplierForm(),
      ],
    );
  }

  Widget _buildSupplierTypeToggle() {
    return ToggleButtonGroup(
      items: const [
        ToggleButtonItem(
          id: 'existing',
          label: 'Existing Supplier',
          icon: LucideIcons.building2,
        ),
        ToggleButtonItem(
          id: 'onetime',
          label: 'One-time Supplier',
          icon: LucideIcons.userPlus,
        ),
      ],
      selectedId: _isExistingSupplier ? 'existing' : 'onetime',
      onToggle: (id) {
        setState(() {
          _isExistingSupplier = id == 'existing';
          _supplierError = null;
        });
      },
      layout: ToggleButtonLayout.expanded,
    );
  }

  Widget _buildExistingSupplierSelector() {
    final counterpartyAsync = ref.watch(currentCounterpartiesProvider);

    return counterpartyAsync.when(
      loading: () => const Center(child: TossLoadingView()),
      error: (error, _) => Container(
        padding: const EdgeInsets.all(TossSpacing.space4),
        decoration: BoxDecoration(
          color: TossColors.errorLight,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Text(
          'Failed to load suppliers',
          style: TossTextStyles.bodyMedium.copyWith(color: TossColors.error),
        ),
      ),
      data: (counterparties) {
        if (counterparties.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Column(
              children: [
                Icon(LucideIcons.userPlus, size: TossSpacing.iconXL, color: TossColors.gray400),
                const SizedBox(height: TossSpacing.space2),
                Text(
                  'No suppliers found',
                  style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
                ),
                const SizedBox(height: TossSpacing.space1),
                Text(
                  'Add a supplier in Counterparty settings or use one-time supplier',
                  textAlign: TextAlign.center,
                  style: TossTextStyles.caption.copyWith(color: TossColors.gray400),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TossDropdown<String>(
              label: 'Select Supplier',
              value: _selectedSupplierId,
              hint: 'Choose a supplier',
              isRequired: true,
              errorText: _supplierError,
              items: counterparties
                  .map((c) => TossDropdownItem<String>(
                        value: c.id,
                        label: c.name,
                        subtitle: c.type.toUpperCase(),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                final selected = counterparties.firstWhere((c) => c.id == v);
                setState(() {
                  _selectedSupplierId = v;
                  _selectedSupplier = selected;
                  _supplierError = null;
                });
              },
            ),
            if (_selectedSupplier != null) ...[
              const SizedBox(height: TossSpacing.space3),
              _buildSelectedSupplierInfo(_selectedSupplier!),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSelectedSupplierInfo(CounterpartyData supplier) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space3),
      decoration: BoxDecoration(
        color: TossColors.primarySurface,
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.checkCircle, size: 16, color: TossColors.primary),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Selected Supplier',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            supplier.name,
            style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          if (supplier.phone != null && supplier.phone!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              supplier.phone!,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          ],
          if (supplier.email != null && supplier.email!.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space1),
            Text(
              supplier.email!,
              style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOneTimeSupplierForm() {
    return Column(
      children: [
        TossTextField.filled(
          controller: _supplierNameController,
          inlineLabel: 'Supplier Name',
          hintText: 'Enter supplier name',
          isRequired: true,
          errorText: _supplierError,
          onChanged: (_) {
            if (_supplierError != null) {
              setState(() => _supplierError = null);
            }
          },
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          controller: _supplierPhoneController,
          inlineLabel: 'Phone (Optional)',
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          controller: _supplierEmailController,
          inlineLabel: 'Email (Optional)',
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: TossSpacing.space3),
        TossTextField.filled(
          controller: _supplierAddressController,
          inlineLabel: 'Address (Optional)',
          hintText: 'Enter address',
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notes', isRequired: false),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _notesController,
          hintText: 'Add any notes for this order (optional)',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TossTextStyles.h4.copyWith(color: TossColors.gray900),
        ),
        if (isRequired) ...[
          const SizedBox(width: TossSpacing.space1),
          Text(
            '*',
            style: TossTextStyles.h4.copyWith(color: TossColors.error),
          ),
        ],
      ],
    );
  }

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  bool _validateForm() {
    bool isValid = true;

    // Validate Order Title
    if (_orderTitleController.text.trim().isEmpty) {
      _orderTitleError = 'Order title is required';
      isValid = false;
    } else {
      _orderTitleError = null;
    }

    // Validate Items
    if (_items.isEmpty) {
      isValid = false;
      TossToast.error(context, 'Please add at least one item');
      return false;
    }

    // Validate Supplier
    if (_isExistingSupplier) {
      if (_selectedSupplierId == null) {
        _supplierError = 'Please select a supplier';
        isValid = false;
      } else {
        _supplierError = null;
      }
    } else {
      if (_supplierNameController.text.trim().isEmpty) {
        _supplierError = 'Supplier name is required';
        isValid = false;
      } else {
        _supplierError = null;
      }
    }

    return isValid;
  }

  Future<void> _handleSave() async {
    if (!_validateForm()) {
      setState(() {});
      return;
    }

    // Build items array for RPC
    final itemsJson = _items.map((item) => {
      'sku': item.sku,
      'variant_id': item.variantId,
      'quantity': item.quantity,
      'unit_price': item.unitPrice,
    }).toList();

    // Build supplier_info for one-time supplier
    Map<String, dynamic>? supplierInfo;
    if (!_isExistingSupplier) {
      supplierInfo = {
        'name': _supplierNameController.text.trim(),
        if (_supplierPhoneController.text.trim().isNotEmpty)
          'phone': _supplierPhoneController.text.trim(),
        if (_supplierEmailController.text.trim().isNotEmpty)
          'email': _supplierEmailController.text.trim(),
        if (_supplierAddressController.text.trim().isNotEmpty)
          'address': _supplierAddressController.text.trim(),
      };
    }

    // Build notes with order title
    final notes = _notesController.text.trim().isNotEmpty
        ? '${_orderTitleController.text.trim()}\n${_notesController.text.trim()}'
        : _orderTitleController.text.trim();

    try {
      final response = await ref.read(poFormProvider.notifier).createOrder(
        items: itemsJson,
        orderTitle: _orderTitleController.text.trim(),
        counterpartyId: _isExistingSupplier ? _selectedSupplierId : null,
        supplierInfo: supplierInfo,
        notes: notes,
      );

      if (response != null && mounted) {
        final message = response['message'] as String? ?? 'Order created successfully!';

        // Show success dialog
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => TossDialog.success(
            title: 'Order Created',
            message: message,
            primaryButtonText: 'OK',
            onPrimaryPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        );

        // Refresh list and navigate back
        if (mounted) {
          ref.read(poListProvider.notifier).refresh();
          context.go('/purchase-order');
        }
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }
}

/// Data class for order items
class OrderItemData {
  final String productId;
  final String name;
  final String? sku;
  final String? variantId;
  final double quantity;
  final String unit;
  final double unitPrice;

  OrderItemData({
    required this.productId,
    required this.name,
    this.sku,
    this.variantId,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}
