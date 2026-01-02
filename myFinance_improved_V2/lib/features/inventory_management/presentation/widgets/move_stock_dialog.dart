// Widget: Move Stock Dialog
// Reusable dialog for moving stock between stores

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../di/inventory_providers.dart';
import 'store_picker_sheet.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

/// Store location data class for Move Stock Dialog
class StoreLocation {
  final String id;
  final String name;
  final int stock;
  final bool isCurrentStore;

  StoreLocation({
    required this.id,
    required this.name,
    required this.stock,
    this.isCurrentStore = false,
  });

  /// Create a copy with updated stock
  StoreLocation copyWith({int? stock}) {
    return StoreLocation(
      id: id,
      name: name,
      stock: stock ?? this.stock,
      isCurrentStore: isCurrentStore,
    );
  }
}

/// Move Stock Dialog Widget
class MoveStockDialog extends ConsumerStatefulWidget {
  final String productName;
  final String productId;
  final StoreLocation fromLocation;
  final List<StoreLocation> allStores;
  /// Returns true on success, false on failure
  final Future<bool> Function(StoreLocation from, StoreLocation to, int quantity) onSubmit;

  const MoveStockDialog({
    super.key,
    required this.productName,
    required this.productId,
    required this.fromLocation,
    required this.allStores,
    required this.onSubmit,
  });

  /// Show the move stock dialog
  static Future<void> show({
    required BuildContext context,
    required String productName,
    required String productId,
    required StoreLocation fromLocation,
    required List<StoreLocation> allStores,
    required Future<bool> Function(StoreLocation from, StoreLocation to, int quantity) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => MoveStockDialog(
        productName: productName,
        productId: productId,
        fromLocation: fromLocation,
        allStores: allStores,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  ConsumerState<MoveStockDialog> createState() => _MoveStockDialogState();
}

class _MoveStockDialogState extends ConsumerState<MoveStockDialog> {
  late StoreLocation _fromStore;
  late StoreLocation _toStore;
  int _quantity = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  List<StoreLocation> _storesWithRealStock = [];

  @override
  void initState() {
    super.initState();
    // Initialize from/to stores with passed data first
    _fromStore = widget.fromLocation;

    // Find a different store for "To" (first store that's not the from store)
    final otherStores =
        widget.allStores.where((s) => s.id != _fromStore.id).toList();
    _toStore = otherStores.isNotEmpty ? otherStores.first : _fromStore;
    _storesWithRealStock = widget.allStores;

    // Load real stock data from RPC
    _loadStockData();
  }

  Future<void> _loadStockData() async {
    try {
      final appState = ref.read(appStateProvider);
      final repository = ref.read(inventoryRepositoryProvider);

      final result = await repository.getProductStockByStores(
        companyId: appState.companyChoosen,
        productIds: [widget.productId],
      );

      if (result != null && result.products.isNotEmpty && mounted) {
        final productStock = result.products.first;

        // Update stores with real stock data from RPC
        final finalStores = widget.allStores.map((store) {
          try {
            final storeStock = productStock.stores.firstWhere(
              (s) => s.storeId == store.id,
            );
            return store.copyWith(stock: storeStock.quantityOnHand);
          } catch (_) {
            return store;
          }
        }).toList();

        setState(() {
          _storesWithRealStock = finalStores;
          // Update from/to stores with real stock
          _fromStore = finalStores.firstWhere(
            (s) => s.id == _fromStore.id,
            orElse: () => _fromStore,
          );
          _toStore = finalStores.firstWhere(
            (s) => s.id == _toStore.id,
            orElse: () => _toStore,
          );
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _swapStores() {
    setState(() {
      final temp = _fromStore;
      _fromStore = _toStore;
      _toStore = temp;
      // Reset quantity when swapping since available stock changes
      _quantity = 0;
    });
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await widget.onSubmit(_fromStore, _toStore, _quantity);
      if (mounted) {
        Navigator.pop(context, success);
      }
    } catch (e) {
      // On error, reset submitting state and keep dialog open
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Allow any quantity (including negative stock), only require different stores
    final canSubmit = _quantity != 0 && _fromStore.id != _toStore.id;

    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TossBorderRadius.xl),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: TossSpacing.space6, vertical: TossSpacing.space6),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Enter Move Stock Quantity',
              style: TossTextStyles.titleLarge.copyWith(
                color: TossColors.gray900,
              ),
            ),
            const SizedBox(height: 8),
            // Product name
            Text(
              widget.productName,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: 24),
            // From label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'From',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // From store selector
            _buildStoreSelector(
              store: _fromStore,
              onTap: () => _showStorePickerSheet(isFrom: true),
            ),
            const SizedBox(height: 16),
            // Swap button
            GestureDetector(
              onTap: _swapStores,
              child: Icon(
                Icons.swap_vert,
                size: 24,
                color: TossColors.gray600,
              ),
            ),
            const SizedBox(height: 16),
            // To label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'To',
                style: TossTextStyles.caption.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // To store selector
            _buildStoreSelector(
              store: _toStore,
              onTap: () => _showStorePickerSheet(isFrom: false),
            ),
            const SizedBox(height: 24),
            // Quantity stepper (no max limit - allow negative stock)
            TossQuantityStepper(
              initialValue: 0,
              maxValue: 999999,
              previousValue: _fromStore.stock,
              stockChangeMode: StockChangeMode.subtract,
              onChanged: (value) {
                setState(() {
                  _quantity = value;
                });
              },
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: TossColors.gray100,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.gray700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit button
                Expanded(
                  child: GestureDetector(
                    onTap: canSubmit && !_isSubmitting ? _handleSubmit : null,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: canSubmit && !_isSubmitting ? TossColors.primary : TossColors.gray300,
                        borderRadius: BorderRadius.circular(TossBorderRadius.md),
                      ),
                      alignment: Alignment.center,
                      child: _isSubmitting
                          ? TossLoadingView.inline(
                              size: 20,
                              color: TossColors.white,
                            )
                          : Text(
                              'Submit',
                              style: TossTextStyles.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreSelector({
    required StoreLocation store,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4, vertical: TossSpacing.space3),
        decoration: BoxDecoration(
          color: TossColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: TossColors.gray100,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Store name
            Expanded(
              child: Row(
                children: [
                  Text(
                    store.name,
                    style: TossTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: TossColors.gray900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '·',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.gray400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Stock badge with loading state
                  _isLoading
                      ? TossLoadingView.inline(size: 16)
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space2, vertical: TossSpacing.space1),
                          decoration: BoxDecoration(
                            color: TossColors.primarySurface,
                            borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                          ),
                          child: Text(
                            '${store.stock}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: TossColors.gray500,
            ),
          ],
        ),
      ),
    );
  }

  void _showStorePickerSheet({required bool isFrom}) {
    // Use stores with real stock data
    final availableStores = _storesWithRealStock.where((s) {
      // If picking "From", exclude current "To" store
      // If picking "To", exclude current "From" store
      return isFrom ? s.id != _toStore.id : s.id != _fromStore.id;
    }).toList();

    StorePickerSheet.show(
      context: context,
      title: isFrom ? 'Select From Store' : 'Select To Store',
      stores: availableStores,
      onSelect: (store) {
        setState(() {
          if (isFrom) {
            _fromStore = store;
            // Reset quantity when changing from store
            _quantity = 0;
          } else {
            _toStore = store;
          }
        });
      },
    );
  }
}
