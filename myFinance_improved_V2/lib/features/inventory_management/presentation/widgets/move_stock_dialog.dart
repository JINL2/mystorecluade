// Widget: Move Stock Dialog
// Reusable dialog for moving stock between stores

import 'package:flutter/material.dart';

import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/toss/toss_quantity_stepper.dart';

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
}

/// Move Stock Dialog Widget
class MoveStockDialog extends StatefulWidget {
  final String productName;
  final StoreLocation fromLocation;
  final List<StoreLocation> allStores;
  final void Function(StoreLocation from, StoreLocation to, int quantity) onSubmit;

  const MoveStockDialog({
    super.key,
    required this.productName,
    required this.fromLocation,
    required this.allStores,
    required this.onSubmit,
  });

  /// Show the move stock dialog
  static Future<void> show({
    required BuildContext context,
    required String productName,
    required StoreLocation fromLocation,
    required List<StoreLocation> allStores,
    required void Function(StoreLocation from, StoreLocation to, int quantity) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => MoveStockDialog(
        productName: productName,
        fromLocation: fromLocation,
        allStores: allStores,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<MoveStockDialog> createState() => _MoveStockDialogState();
}

class _MoveStockDialogState extends State<MoveStockDialog> {
  late StoreLocation _fromStore;
  late StoreLocation _toStore;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    // Initialize from/to stores
    _fromStore = widget.fromLocation;

    // Find a different store for "To" (first store that's not the from store)
    final otherStores =
        widget.allStores.where((s) => s.id != _fromStore.id).toList();
    _toStore = otherStores.isNotEmpty ? otherStores.first : _fromStore;
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

  @override
  Widget build(BuildContext context) {
    final canSubmit = _quantity > 0 && _fromStore.id != _toStore.id;

    return Dialog(
      backgroundColor: TossColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
            // Quantity stepper
            TossQuantityStepper(
              initialValue: 0,
              maxValue: _fromStore.stock,
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
                        borderRadius: BorderRadius.circular(8),
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
                    onTap: canSubmit ? () => widget.onSubmit(_fromStore, _toStore, _quantity) : null,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: canSubmit ? TossColors.primary : TossColors.gray300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // Stock badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: TossColors.primarySurface,
                      borderRadius: BorderRadius.circular(6),
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
    final availableStores = widget.allStores.where((s) {
      // If picking "From", exclude current "To" store
      // If picking "To", exclude current "From" store
      return isFrom ? s.id != _toStore.id : s.id != _fromStore.id;
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: TossColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(TossBorderRadius.bottomSheet)),
      ),
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: TossSpacing.space2),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: TossColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
                child: Text(
                  isFrom ? 'Select From Store' : 'Select To Store',
                  style: TossTextStyles.titleLarge.copyWith(
                    color: TossColors.gray900,
                  ),
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableStores.length,
                  itemBuilder: (context, index) {
                    final store = availableStores[index];
                    return ListTile(
                      leading: Icon(
                        Icons.store_outlined,
                        color: TossColors.gray600,
                      ),
                      title: Text(
                        store.name,
                        style: TossTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: TossColors.gray900,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: TossColors.primarySurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${store.stock}',
                          style: TossTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: TossColors.primary,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
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
                  },
                ),
              ),
              const SizedBox(height: TossSpacing.space4),
            ],
          ),
        ),
      ),
    );
  }
}
