import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/counterparty_provider.dart';
import '../../../../app/providers/product_search_provider.dart';
import '../../../../core/domain/entities/selector_entities.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/shipment_providers.dart';
import '../../domain/entities/create_shipment_params.dart';
import '../providers/shipment_providers.dart';

class ShipmentFormPage extends ConsumerStatefulWidget {
  final String? shipmentId;

  const ShipmentFormPage({super.key, this.shipmentId});

  @override
  ConsumerState<ShipmentFormPage> createState() => _ShipmentFormPageState();
}

class _ShipmentFormPageState extends ConsumerState<ShipmentFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _shipmentTitleController = TextEditingController();
  final _notesController = TextEditingController();
  final _productSearchController = TextEditingController();
  final _trackingNumberController = TextEditingController();

  // Supplier - One-time supplier fields
  final _supplierNameController = TextEditingController();
  final _supplierPhoneController = TextEditingController();
  final _supplierEmailController = TextEditingController();
  final _supplierAddressController = TextEditingController();

  // Search debounce timer
  Timer? _searchDebounce;

  // Source type: 'order' or 'supplier'
  String _sourceType = 'supplier'; // default to supplier

  // Order selection
  String? _selectedOrderId;
  String? _selectedOrderNumber;

  // Supplier selection
  bool _isExistingSupplier = true;
  String? _selectedSupplierId;
  CounterpartyData? _selectedSupplier;

  // Items
  final List<ShipmentItemData> _items = [];

  // Validation errors
  String? _shipmentTitleError;
  String? _sourceError;
  String? _supplierError;

  // Loading states
  bool _isSaving = false;

  bool get isEditMode => widget.shipmentId != null;

  @override
  void dispose() {
    _shipmentTitleController.dispose();
    _notesController.dispose();
    _productSearchController.dispose();
    _trackingNumberController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _supplierEmailController.dispose();
    _supplierAddressController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: TossAppBar(
        title: isEditMode ? 'Edit Shipment' : 'New Shipment',
        leading: TossIconButton.ghost(
          icon: LucideIcons.x,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/shipment');
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
                  // 1. Shipment Title (Required)
                  _buildShipmentTitleSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 2. Source Selection: Order OR Supplier
                  _buildSourceSelectionSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 3. Select Items
                  _buildSelectItemsSection(),
                  const SizedBox(height: TossSpacing.space5),

                  // 4. Shipment Details (Tracking Number, Notes)
                  _buildShipmentDetailsSection(),

                  const SizedBox(height: TossSpacing.space4),
                ],
              ),
            ),
          ),
          // Bottom Save Button
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
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
          text: isEditMode ? 'Update Shipment' : 'Create Shipment',
          isLoading: _isSaving,
          onPressed: _isSaving ? null : _handleSave,
        ),
      ),
    );
  }

  // ==========================================================================
  // Section 1: Shipment Title
  // ==========================================================================

  Widget _buildShipmentTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Shipment Title', isRequired: true),
        const SizedBox(height: TossSpacing.space2),
        TossTextField.filled(
          controller: _shipmentTitleController,
          hintText: 'Enter shipment title',
          errorText: _shipmentTitleError,
          onChanged: (_) {
            if (_shipmentTitleError != null) {
              setState(() => _shipmentTitleError = null);
            }
          },
        ),
      ],
    );
  }

  // ==========================================================================
  // Section 3: Source Selection (Order OR Supplier - Mutually Exclusive)
  // ==========================================================================

  Widget _buildSourceSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Link to Order or Supplier', isRequired: true),
        const SizedBox(height: TossSpacing.space3),

        // Toggle: Order vs Supplier
        _buildSourceTypeToggle(),
        const SizedBox(height: TossSpacing.space4),

        // Show error if any
        if (_sourceError != null) ...[
          InfoCard.alertError(message: _sourceError!),
          const SizedBox(height: TossSpacing.space3),
        ],

        // Content based on source type
        if (_sourceType == 'order')
          _buildOrderSelectionContent()
        else
          _buildSupplierSelectionContent(),
      ],
    );
  }

  Widget _buildSourceTypeToggle() {
    return ToggleButtonGroup(
      items: const [
        ToggleButtonItem(
          id: 'order',
          label: 'Link to Order',
          icon: LucideIcons.shoppingBag,
        ),
        ToggleButtonItem(
          id: 'supplier',
          label: 'Select Supplier',
          icon: LucideIcons.user,
        ),
      ],
      selectedId: _sourceType,
      onToggle: (id) {
        setState(() {
          _sourceType = id;
          _sourceError = null;
          if (id == 'order') {
            // Clear supplier selection when switching to order
            _selectedSupplierId = null;
            _selectedSupplier = null;
          } else {
            // Clear order selection when switching to supplier
            _selectedOrderId = null;
            _selectedOrderNumber = null;
          }
        });
      },
      layout: ToggleButtonLayout.expanded,
    );
  }

  // Order Selection Content
  Widget _buildOrderSelectionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order search/select button
        GestureDetector(
          onTap: _showOrderSelectionSheet,
          child: Container(
            padding: const EdgeInsets.all(TossSpacing.space4),
            decoration: BoxDecoration(
              color: TossColors.white,
              borderRadius: BorderRadius.circular(TossBorderRadius.lg),
              border: Border.all(
                color: _selectedOrderId != null ? TossColors.primary : TossColors.gray200,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: _selectedOrderId != null
                        ? TossColors.primarySurface
                        : TossColors.gray100,
                    borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                  ),
                  child: Icon(
                    LucideIcons.shoppingBag,
                    size: 20,
                    color: _selectedOrderId != null ? TossColors.primary : TossColors.gray400,
                  ),
                ),
                const SizedBox(width: TossSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedOrderId != null ? 'Selected Order' : 'Select Order',
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedOrderNumber ?? 'Tap to search and select an order',
                        style: TossTextStyles.bodyMedium.copyWith(
                          color: _selectedOrderId != null
                              ? TossColors.gray900
                              : TossColors.gray400,
                          fontWeight:
                              _selectedOrderId != null ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _selectedOrderId != null ? LucideIcons.checkCircle : LucideIcons.chevronRight,
                  color: _selectedOrderId != null ? TossColors.primary : TossColors.gray400,
                ),
              ],
            ),
          ),
        ),

        // Selected order info
        if (_selectedOrderId != null) ...[
          const SizedBox(height: TossSpacing.space3),
          _buildSelectedOrderInfo(),
        ],
      ],
    );
  }

  Widget _buildSelectedOrderInfo() {
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
              const Icon(LucideIcons.checkCircle, size: 16, color: TossColors.primary),
              const SizedBox(width: TossSpacing.space2),
              Text(
                'Order Linked',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOrderId = null;
                    _selectedOrderNumber = null;
                  });
                },
                child: Text(
                  'Remove',
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TossSpacing.space2),
          Text(
            _selectedOrderNumber ?? '',
            style: TossTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            'Items from this order will be available for shipment',
            style: TossTextStyles.caption.copyWith(color: TossColors.gray600),
          ),
        ],
      ),
    );
  }

  void _showOrderSelectionSheet() {
    // Reset search when opening
    ref.read(linkableOrderSearchProvider.notifier).state = '';

    TossBottomSheet.show<void>(
      context: context,
      title: 'Select Order',
      content: _OrderSelectionSheetContent(
        onOrderSelected: (LinkableOrderItem order) {
          setState(() {
            _selectedOrderId = order.orderId;
            _selectedOrderNumber = order.orderNumber;
            _sourceError = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  // Supplier Selection Content
  Widget _buildSupplierSelectionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        ),
        ToggleButtonItem(
          id: 'onetime',
          label: 'One-time Supplier',
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
      error: (error, _) => InfoCard.alertError(
        message: 'Failed to load suppliers',
      ),
      data: (counterparties) {
        if (counterparties.isEmpty) {
          return TossCard(
            backgroundColor: TossColors.gray50,
            child: Column(
              children: [
                const Icon(
                  LucideIcons.userPlus,
                  size: TossSpacing.iconXL,
                  color: TossColors.gray400,
                ),
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
              const Icon(LucideIcons.checkCircle, size: 16, color: TossColors.primary),
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

  // ==========================================================================
  // Section 4: Select Items
  // ==========================================================================

  Widget _buildSelectItemsSection() {
    final searchState = ref.watch(productSearchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Select Items', isRequired: true),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Added Items (${_items.length})',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.gray700,
                ),
              ),
              Text(
                'Total: ${_formatPrice(_calculateTotal())}',
                style: TossTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: TossColors.primary,
                ),
              ),
            ],
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

  double _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.total);
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
      padding: const EdgeInsets.all(TossSpacing.space6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.truck,
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

  Widget _buildItemCard(int index, ShipmentItemData item) {
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
                TossIconButton.ghost(
                  icon: LucideIcons.trash2,
                  size: TossIconButtonSize.small,
                  onPressed: () => _deleteItem(index),
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
      _items.add(ShipmentItemData(
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
      _items[index] = ShipmentItemData(
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

  void _deleteItem(int index) {
    setState(() => _items.removeAt(index));
  }

  // ==========================================================================
  // Section 5: Shipment Details (Tracking Number, Notes)
  // ==========================================================================

  Widget _buildShipmentDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Shipment Details', isRequired: false),
        const SizedBox(height: TossSpacing.space3),

        // Tracking Number
        TossTextField.filled(
          controller: _trackingNumberController,
          inlineLabel: 'Tracking Number (Optional)',
          hintText: 'Enter tracking number',
          prefixIcon: const Icon(LucideIcons.truck, color: TossColors.gray400),
        ),
        const SizedBox(height: TossSpacing.space3),

        // Notes
        TossTextField.filled(
          controller: _notesController,
          inlineLabel: 'Notes (Optional)',
          hintText: 'Add any notes for this shipment',
          maxLines: 3,
        ),
      ],
    );
  }

  // ==========================================================================
  // Helpers
  // ==========================================================================

  Widget _buildSectionHeader(String title, {bool isRequired = false}) {
    return TossSectionHeader(
      title: title,
      trailing: isRequired
          ? Text(
              '*',
              style: TossTextStyles.h4.copyWith(color: TossColors.error),
            )
          : null,
      backgroundColor: TossColors.transparent,
      padding: EdgeInsets.zero,
    );
  }

  bool _validateForm() {
    bool isValid = true;

    // Validate Shipment Title
    if (_shipmentTitleController.text.trim().isEmpty) {
      _shipmentTitleError = 'Shipment title is required';
      isValid = false;
    } else {
      _shipmentTitleError = null;
    }

    // Validate Source (Order or Supplier)
    if (_sourceType == 'order') {
      if (_selectedOrderId == null) {
        _sourceError = 'Please select an order';
        isValid = false;
      } else {
        _sourceError = null;
      }
    } else {
      // Supplier validation
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
    }

    // Validate Items
    if (_items.isEmpty) {
      isValid = false;
      TossToast.error(context, 'Please add at least one item');
      return false;
    }

    return isValid;
  }

  Future<void> _handleSave() async {
    if (!_validateForm()) {
      setState(() {});
      return;
    }

    setState(() => _isSaving = true);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final userId = appState.userId;

      if (companyId.isEmpty || userId.isEmpty) {
        TossToast.error(context, 'Company or user not selected');
        return;
      }

      // Get current local time and timezone for RPC v3
      final now = DateTime.now();
      final localTime = now.toIso8601String();
      const timezone = 'Asia/Ho_Chi_Minh';

      // Build supplier_info for one-time supplier
      Map<String, dynamic>? supplierInfo;
      if (_sourceType == 'supplier' && !_isExistingSupplier) {
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

      // Build order_ids array (RPC v3 uses array instead of single order_id)
      List<String>? orderIds;
      if (_sourceType == 'order' && _selectedOrderId != null) {
        orderIds = [_selectedOrderId!];
      }

      // Build CreateShipmentParams for UseCase
      final params = CreateShipmentParams(
        companyId: companyId,
        userId: userId,
        items: _items
            .map((item) => CreateShipmentItemParams(
                  productId: item.productId,
                  variantId: item.variantId,
                  quantity: item.quantity,
                  unit: item.unit,
                  unitPrice: item.unitPrice,
                ))
            .toList(),
        time: localTime,
        timezone: timezone,
        orderIds: orderIds,
        counterpartyId: _sourceType == 'supplier' && _isExistingSupplier
            ? _selectedSupplierId
            : null,
        supplierInfo: supplierInfo,
        trackingNumber: _trackingNumberController.text.trim().isNotEmpty
            ? _trackingNumberController.text.trim()
            : null,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
        shipmentNumber: _shipmentTitleController.text.trim().isNotEmpty
            ? _shipmentTitleController.text.trim()
            : null,
      );

      // Call UseCase to create shipment (Clean Architecture)
      final createShipmentUseCase = ref.read(createShipmentV3UseCaseProvider);
      final response = await createShipmentUseCase(params);

      if (mounted) {
        if (response.success) {
          final shipmentNumber = response.shipmentNumber ?? 'Shipment';

          // Show success dialog
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) => TossDialog.success(
              title: 'Shipment Created',
              subtitle: shipmentNumber,
              message: 'Shipment has been created successfully.',
              primaryButtonText: 'OK',
              onPrimaryPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          );

          // Refresh list and navigate back
          if (mounted) {
            ref.invalidate(shipmentsWithContextProvider);
            context.go('/shipment');
          }
        } else {
          final error = response.error ?? 'Failed to create shipment';
          TossToast.error(context, error);
        }
      }
    } catch (e) {
      if (mounted) {
        TossToast.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

/// Data class for shipment items
class ShipmentItemData {
  final String productId;
  final String name;
  final String? sku;
  final String? variantId;
  final double quantity;
  final String unit;
  final double unitPrice;

  ShipmentItemData({
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

// =============================================================================
// Order Selection Bottom Sheet Content Widget
// =============================================================================

class _OrderSelectionSheetContent extends ConsumerStatefulWidget {
  final void Function(LinkableOrderItem order) onOrderSelected;

  const _OrderSelectionSheetContent({required this.onOrderSelected});

  @override
  ConsumerState<_OrderSelectionSheetContent> createState() => _OrderSelectionSheetContentState();
}

class _OrderSelectionSheetContentState extends ConsumerState<_OrderSelectionSheetContent> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(linkableOrderSearchProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(linkableOrdersProvider);

    // Content for TossBottomSheet - handle and title are provided by TossBottomSheet
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search
        TossTextField.filled(
          controller: _searchController,
          hintText: 'Search by order number or supplier...',
          prefixIcon: const Icon(LucideIcons.search, color: TossColors.gray400),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: TossSpacing.space3),
        // Order list
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ordersAsync.when(
            loading: () => const Center(child: TossLoadingView()),
            error: (error, _) => _buildErrorView(error.toString()),
            data: (orders) {
              if (orders.isEmpty) {
                return _buildEmptyView();
              }
              return _buildOrderList(orders);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.alertCircle,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            'Failed to load orders',
            style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
          ),
          const SizedBox(height: TossSpacing.space2),
          TossButton.textButton(
            text: 'Retry',
            onPressed: () => ref.invalidate(linkableOrdersProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    final searchQuery = ref.watch(linkableOrderSearchProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.shoppingBag,
            size: 48,
            color: TossColors.gray300,
          ),
          const SizedBox(height: TossSpacing.space3),
          Text(
            searchQuery.isEmpty
                ? 'No linkable orders found'
                : 'No orders match your search',
            style: TossTextStyles.bodyMedium.copyWith(color: TossColors.gray500),
          ),
          const SizedBox(height: TossSpacing.space1),
          Text(
            searchQuery.isEmpty
                ? 'Only pending or processing orders can be linked'
                : 'Try a different search term',
            style: TossTextStyles.caption.copyWith(color: TossColors.gray400),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<LinkableOrderItem> orders) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderListTile(
          order: order,
          onTap: () => widget.onOrderSelected(order),
        );
      },
    );
  }
}

class _OrderListTile extends StatelessWidget {
  final LinkableOrderItem order;
  final VoidCallback onTap;

  const _OrderListTile({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TossSpacing.space3),
        child: Row(
          children: [
            // Order icon
            Container(
              padding: const EdgeInsets.all(TossSpacing.space2),
              decoration: BoxDecoration(
                color: TossColors.primarySurface,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: const Icon(
                LucideIcons.shoppingBag,
                size: 20,
                color: TossColors.primary,
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Order info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.orderNumber,
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: TossSpacing.space2),
                      _buildStatusBadge(order.status),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.supplierName ?? 'No supplier',
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray600,
                    ),
                  ),
                  if (order.orderDate != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      order.orderDate!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.gray400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat('#,##0').format(order.totalAmount),
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: TossColors.gray400,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    BadgeStatus badgeStatus;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeStatus = BadgeStatus.warning;
        label = 'Pending';
        break;
      case 'process':
        badgeStatus = BadgeStatus.info;
        label = 'Processing';
        break;
      default:
        badgeStatus = BadgeStatus.neutral;
        label = status;
    }

    return TossBadge.status(
      label: label,
      status: badgeStatus,
    );
  }
}
