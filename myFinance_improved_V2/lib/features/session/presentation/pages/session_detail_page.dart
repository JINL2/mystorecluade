import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../providers/session_detail_provider.dart';
import '../providers/states/session_detail_state.dart';

/// Session detail page - view and manage session items
class SessionDetailPage extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionType;
  final String storeId;
  final String? sessionName;
  final bool isOwner;

  const SessionDetailPage({
    super.key,
    required this.sessionId,
    required this.sessionType,
    required this.storeId,
    this.sessionName,
    this.isOwner = false,
  });

  @override
  ConsumerState<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends ConsumerState<SessionDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  SessionDetailParams get _params => (
        sessionId: widget.sessionId,
        sessionType: widget.sessionType,
        storeId: widget.storeId,
        sessionName: widget.sessionName,
      );

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  bool get _isCounting => widget.sessionType == 'counting';

  Color get _typeColor =>
      _isCounting ? TossColors.primary : TossColors.success;

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      ref.read(sessionDetailProvider(_params).notifier).searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionDetailProvider(_params));

    return Scaffold(
      appBar: TossAppBar1(
        title: widget.sessionName ?? 'Session Detail',
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(state),

          // Content Area
          Expanded(
            child: state.isInSearchMode
                ? _buildSearchResults(state)
                : state.selectedProducts.isEmpty
                    ? _buildEmptyState()
                    : _buildSelectedProductsList(state),
          ),

          // Bottom Action Buttons
          _buildBottomButtons(state),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SessionDetailState state) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      color: TossColors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search products by name, SKU, or barcode',
          hintStyle: TossTextStyles.body.copyWith(
            color: TossColors.textTertiary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: TossColors.textTertiary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    ref
                        .read(sessionDetailProvider(_params).notifier)
                        .clearSearchResults();
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: TossColors.textTertiary,
                  ),
                )
              : null,
          filled: true,
          fillColor: TossColors.gray50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TossBorderRadius.lg),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: TossSpacing.space4,
            vertical: TossSpacing.space3,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          _onSearchChanged(value);
        },
        onTap: () {
          ref.read(sessionDetailProvider(_params).notifier).enterSearchMode();
        },
      ),
    );
  }

  Widget _buildSearchResults(SessionDetailState state) {
    if (state.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.searchResults.isEmpty && state.searchQuery.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: TossColors.textTertiary,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'No products found',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Try a different search term',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TossSpacing.space6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search,
                size: 64,
                color: TossColors.textTertiary,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Search for products',
                style: TossTextStyles.h4.copyWith(
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                'Type to search by name, SKU, or barcode',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = state.searchResults[index];
        final isSelected = state.isProductSelected(product.productId);

        return _SearchResultCard(
          product: product,
          isSelected: isSelected,
          onTap: () {
            ref
                .read(sessionDetailProvider(_params).notifier)
                .addProductAndExitSearch(product);
            _searchController.clear();
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: TossColors.textTertiary,
            ),
            const SizedBox(height: TossSpacing.space4),
            Text(
              'No items added yet',
              style: TossTextStyles.h4.copyWith(
                color: TossColors.textPrimary,
              ),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Search for products to add items',
              style: TossTextStyles.body.copyWith(
                color: TossColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProductsList(SessionDetailState state) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.selectedProducts.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = state.selectedProducts[index];
        final notifier = ref.read(sessionDetailProvider(_params).notifier);
        return _SessionItemCard(
          item: item,
          onQuantityChanged: (newQuantity) {
            notifier.updateQuantity(item.productId, newQuantity);
          },
          onQuantityRejectedChanged: (newQuantity) {
            notifier.updateQuantityRejected(item.productId, newQuantity);
          },
          onDelete: () {
            notifier.removeProduct(item.productId);
          },
        );
      },
    );
  }

  Widget _buildBottomButtons(SessionDetailState state) {
    return Container(
      padding: const EdgeInsets.all(TossSpacing.space4),
      decoration: const BoxDecoration(
        color: TossColors.white,
        boxShadow: [
          BoxShadow(
            color: TossColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: widget.isOwner
            ? Row(
                children: [
                  // Save Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _onSavePressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: TossColors.textPrimary,
                        side: const BorderSide(color: TossColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.lg),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: TossSpacing.space3),
                  // Next Button - Always enabled for owner
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onSubmitPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _typeColor,
                        foregroundColor: TossColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Next',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: TossColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _onSavePressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.textPrimary,
                    side: const BorderSide(color: TossColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TossTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void _onSavePressed() {
    final state = ref.read(sessionDetailProvider(_params));

    if (state.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items to save')),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Save Items?'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The following ${state.totalSelectedCount} item(s) will be saved:',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.textSecondary,
                ),
              ),
              const SizedBox(height: TossSpacing.space3),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.selectedProducts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final item = state.selectedProducts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: TossSpacing.space2,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.productName,
                              style: TossTextStyles.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${item.quantity}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
                          if (item.quantityRejected > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '(${item.quantityRejected})',
                              style: TossTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                color: TossColors.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          TossSpacing.space4,
          0,
          TossSpacing.space4,
          TossSpacing.space4,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TossColors.textPrimary,
                    side: const BorderSide(color: TossColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: TossSpacing.space3),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _executeSave();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _typeColor,
                    foregroundColor: TossColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(TossBorderRadius.md),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _executeSave() async {
    final appState = ref.read(appStateProvider);
    final userId = appState.user['user_id']?.toString() ?? '';

    if (userId.isEmpty) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'User not found',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
      return;
    }

    final result = await ref
        .read(sessionDetailProvider(_params).notifier)
        .saveItems(userId);

    if (mounted) {
      if (result.success) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.success(
            title: 'Items Saved',
            message: 'Items saved successfully',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      } else {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Failed to Save',
            message: result.error ?? 'Failed to save items',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
    }
  }

  void _onSubmitPressed() {
    // Navigate to session review page
    context.push(
      '/session/review/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&sessionName=${Uri.encodeComponent(widget.sessionName ?? '')}',
    );
  }
}

/// Search result card - inventory management style
class _SearchResultCard extends StatelessWidget {
  final SearchProductResult product;
  final bool isSelected;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected
            ? TossColors.primary.withValues(alpha: 0.05)
            : TossColors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.sm),
              ),
              child: product.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                      child: Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_outlined,
                          color: TossColors.textTertiary,
                          size: 24,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: TossColors.textTertiary,
                      size: 24,
                    ),
            ),
            const SizedBox(width: TossSpacing.space3),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: TossTextStyles.bodyMedium.copyWith(
                      color: TossColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (product.sku != null)
                    Text(
                      product.sku!,
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: 24,
              )
            else
              const Icon(
                Icons.add_circle_outline,
                color: TossColors.textTertiary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

/// Session item card widget - inventory management style with dual quantity inputs
class _SessionItemCard extends StatelessWidget {
  final SelectedProduct item;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onQuantityRejectedChanged;
  final VoidCallback onDelete;

  const _SessionItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onQuantityRejectedChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
      padding: const EdgeInsets.all(TossSpacing.space4),
      child: Column(
        children: [
          // Top Row: Image, Product Info, Delete Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: TossColors.gray100,
                  borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                ),
                child: item.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(TossBorderRadius.sm),
                        child: Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_outlined,
                            color: TossColors.textTertiary,
                            size: 24,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.image_outlined,
                        color: TossColors.textTertiary,
                        size: 24,
                      ),
              ),
              const SizedBox(width: TossSpacing.space3),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: TossTextStyles.bodyMedium.copyWith(
                        color: TossColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (item.sku != null)
                      Text(
                        item.sku!,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textTertiary,
                        ),
                      ),
                  ],
                ),
              ),

              // Delete Button
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.close,
                  color: TossColors.textTertiary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),

          const SizedBox(height: TossSpacing.space3),

          // Bottom Row: Quantity Controls
          Row(
            children: [
              // Good Quantity
              Expanded(
                child: _QuantityRow(
                  label: 'Good',
                  quantity: item.quantity,
                  color: TossColors.primary,
                  onDecrement: item.quantity > 0
                      ? () => onQuantityChanged(item.quantity - 1)
                      : null,
                  onIncrement: () => onQuantityChanged(item.quantity + 1),
                ),
              ),

              const SizedBox(width: TossSpacing.space3),

              // Rejected Quantity
              Expanded(
                child: _QuantityRow(
                  label: 'Rejected',
                  quantity: item.quantityRejected,
                  color: TossColors.error,
                  onDecrement: item.quantityRejected > 0
                      ? () => onQuantityRejectedChanged(item.quantityRejected - 1)
                      : null,
                  onIncrement: () => onQuantityRejectedChanged(item.quantityRejected + 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Quantity row with label and controls
class _QuantityRow extends StatelessWidget {
  final String label;
  final int quantity;
  final Color color;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _QuantityRow({
    required this.label,
    required this.quantity,
    required this.color,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TossSpacing.space2,
        vertical: TossSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(TossBorderRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Label
          Text(
            label,
            style: TossTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Controls
          _QuantityButton(
            icon: Icons.remove,
            onTap: onDecrement,
            small: true,
          ),
          Container(
            width: 32,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: TossTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onTap: onIncrement,
            small: true,
          ),
        ],
      ),
    );
  }
}

/// Quantity adjustment button
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool small;

  const _QuantityButton({
    required this.icon,
    this.onTap,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = small ? 28.0 : 32.0;
    final iconSize = small ? 16.0 : 18.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: onTap != null ? TossColors.gray200 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color:
              onTap != null ? TossColors.textPrimary : TossColors.textTertiary,
        ),
      ),
    );
  }
}
