import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../shared/themes/toss_border_radius.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../../../shared/themes/toss_spacing.dart';
import '../../../../shared/themes/toss_text_styles.dart';
import '../../../../shared/widgets/common/toss_app_bar_1.dart';
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

  String get _typeLabel => _isCounting ? 'stock count' : 'receiving';

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
        return _SessionItemCard(
          item: item,
          onQuantityChanged: (newQuantity) {
            ref
                .read(sessionDetailProvider(_params).notifier)
                .updateQuantity(item.productId, newQuantity);
          },
          onDelete: () {
            ref
                .read(sessionDetailProvider(_params).notifier)
                .removeProduct(item.productId);
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
                  // Submit Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          state.hasSelectedProducts ? _onSubmitPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _typeColor,
                        foregroundColor: TossColors.white,
                        disabledBackgroundColor: TossColors.gray300,
                        disabledForegroundColor: TossColors.textTertiary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(TossBorderRadius.lg),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit',
                        style: TossTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: state.hasSelectedProducts
                              ? TossColors.white
                              : TossColors.textTertiary,
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
                            'x${item.quantity}',
                            style: TossTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: TossColors.primary,
                            ),
                          ),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
      return;
    }

    final result = await ref
        .read(sessionDetailProvider(_params).notifier)
        .saveItems(userId);

    if (mounted) {
      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Items saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.error ?? 'Failed to save items')),
        );
      }
    }
  }

  void _onSubmitPressed() {
    final state = ref.read(sessionDetailProvider(_params));
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Session?'),
        content: Text(
          'Are you sure you want to submit this $_typeLabel session with ${state.totalSelectedCount} items?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual submission
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session submitted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _typeColor,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
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

/// Session item card widget - inventory management style
class _SessionItemCard extends StatelessWidget {
  final SelectedProduct item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const _SessionItemCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TossColors.white,
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

          // Quantity Controls
          Row(
            children: [
              _QuantityButton(
                icon: Icons.remove,
                onTap: item.quantity > 1
                    ? () => onQuantityChanged(item.quantity - 1)
                    : null,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '${item.quantity}',
                  style: TossTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: TossColors.textPrimary,
                  ),
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                onTap: () => onQuantityChanged(item.quantity + 1),
              ),
            ],
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
    );
  }
}

/// Quantity adjustment button
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TossBorderRadius.sm),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null ? TossColors.gray200 : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.sm),
        ),
        child: Icon(
          icon,
          size: 18,
          color:
              onTap != null ? TossColors.textPrimary : TossColors.textTertiary,
        ),
      ),
    );
  }
}
