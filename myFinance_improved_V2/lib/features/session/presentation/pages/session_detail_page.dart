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
import '../../../../shared/widgets/common/toss_confirm_cancel_dialog.dart';
import '../../../../shared/widgets/common/toss_success_error_dialog.dart';
import '../../di/session_providers.dart';
import '../dialogs/save_confirm_dialog.dart';
import '../providers/session_detail_provider.dart';
import '../providers/states/session_detail_state.dart';
import '../widgets/session_detail/search_result_card.dart';
import '../widgets/session_detail/session_detail_bottom_buttons.dart';
import '../widgets/session_detail/session_item_card.dart';

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
  bool _isClosing = false;

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

  void _onCloseSessionPressed() {
    TossConfirmCancelDialog.show(
      context: context,
      title: 'Close Session?',
      message: 'Are you sure you want to close this session?\n\nAll unsaved data will be lost and cannot be recovered.',
      confirmButtonText: 'Close',
      cancelButtonText: 'Cancel',
      isDangerousAction: true,
      onConfirm: () {
        Navigator.of(context).pop(); // Close dialog
        _executeCloseSession();
      },
      onCancel: () {
        Navigator.of(context).pop(); // Close dialog
      },
    );
  }

  Future<void> _executeCloseSession() async {
    if (_isClosing) return;

    final appState = ref.read(appStateProvider);
    final userId = appState.userId;
    final companyId = appState.companyChoosen;

    if (userId.isEmpty || companyId.isEmpty) {
      if (mounted) {
        showDialog<void>(
          context: context,
          builder: (context) => TossDialog.error(
            title: 'Error',
            message: 'User or company information not found',
            primaryButtonText: 'OK',
            onPrimaryPressed: () => Navigator.of(context).pop(),
          ),
        );
      }
      return;
    }

    setState(() => _isClosing = true);

    try {
      final closeSession = ref.read(closeSessionUseCaseProvider);
      await closeSession(
        sessionId: widget.sessionId,
        userId: userId,
        companyId: companyId,
      );

      if (!mounted) return;

      // Show success and navigate back to entry point
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => TossDialog.success(
          title: 'Session Closed',
          message: 'The session has been closed successfully.',
          primaryButtonText: 'OK',
          onPrimaryPressed: () {
            Navigator.of(ctx).pop(); // Close dialog
            // Pop twice: detail → action list → entry point
            context.pop();
            context.pop();
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog<void>(
        context: context,
        builder: (ctx) => TossDialog.error(
          title: 'Failed to Close',
          message: e.toString().replaceFirst('Exception: ', ''),
          primaryButtonText: 'OK',
          onPrimaryPressed: () => Navigator.of(ctx).pop(),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isClosing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionDetailProvider(_params));

    return Scaffold(
      appBar: TossAppBar1(
        title: widget.sessionName ?? 'Session Detail',
        actions: [
          // Close button - only visible for session owner
          if (widget.isOwner)
            Padding(
              padding: const EdgeInsets.only(right: TossSpacing.space3),
              child: TextButton(
                onPressed: _onCloseSessionPressed,
                child: Text(
                  'Close',
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(state),
          Expanded(child: _buildContent(state)),
          SessionDetailBottomButtons(
            isOwner: widget.isOwner,
            typeColor: _typeColor,
            onSavePressed: _onSavePressed,
            onNextPressed: _onSubmitPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(SessionDetailState state) {
    if (state.isInSearchMode) {
      return _buildSearchResults(state);
    }
    if (state.selectedProducts.isEmpty) {
      return _buildEmptyState();
    }
    return _buildSelectedProductsList(state);
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
      return _buildSearchEmptyState(
        icon: Icons.search_off,
        title: 'No products found',
        subtitle: 'Try a different search term',
      );
    }

    if (state.searchResults.isEmpty) {
      return _buildSearchEmptyState(
        icon: Icons.search,
        title: 'Search for products',
        subtitle: 'Type to search by name, SKU, or barcode',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final product = state.searchResults[index];
        final isSelected = state.isProductSelected(product.productId);

        return SearchResultCard(
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

  Widget _buildSearchEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TossSpacing.space6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: TossColors.textTertiary),
            const SizedBox(height: TossSpacing.space4),
            Text(
              title,
              style: TossTextStyles.h4.copyWith(color: TossColors.textPrimary),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              subtitle,
              style:
                  TossTextStyles.body.copyWith(color: TossColors.textSecondary),
            ),
          ],
        ),
      ),
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
              style: TossTextStyles.h4.copyWith(color: TossColors.textPrimary),
            ),
            const SizedBox(height: TossSpacing.space2),
            Text(
              'Search for products to add items',
              style:
                  TossTextStyles.body.copyWith(color: TossColors.textSecondary),
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
        return SessionItemCard(
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

  void _onSavePressed() {
    final state = ref.read(sessionDetailProvider(_params));

    if (state.selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items to save')),
      );
      return;
    }

    SaveConfirmDialog.show(
      context: context,
      selectedProducts: state.selectedProducts,
      totalSelectedCount: state.totalSelectedCount,
      typeColor: _typeColor,
      onConfirm: _executeSave,
    );
  }

  Future<void> _executeSave() async {
    final appState = ref.read(appStateProvider);
    final userId = appState.userId;

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
    context.push(
      '/session/review/${widget.sessionId}'
      '?sessionType=${widget.sessionType}'
      '&sessionName=${Uri.encodeComponent(widget.sessionName ?? '')}',
    );
  }
}
