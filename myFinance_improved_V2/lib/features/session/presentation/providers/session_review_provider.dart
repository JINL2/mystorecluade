import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import 'states/session_review_state.dart';

part 'session_review_provider.g.dart';

/// Provider parameters record
typedef SessionReviewParams = ({
  String sessionId,
  String sessionType,
  String? sessionName,
  String storeId,
});

/// Notifier for session review state management
/// Migrated to @riverpod from StateNotifier (2025 Best Practice)
@riverpod
class SessionReviewNotifier extends _$SessionReviewNotifier {
  @override
  SessionReviewState build(SessionReviewParams params) {
    // Auto-load on creation
    Future.microtask(loadSessionItems);
    return SessionReviewState.initial(
      sessionId: params.sessionId,
      sessionType: params.sessionType,
      sessionName: params.sessionName,
      storeId: params.storeId,
    );
  }

  /// Load session items via UseCase and fetch current stock for each product
  Future<void> loadSessionItems() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;
      final getSessionReviewItems = ref.read(getSessionReviewItemsUseCaseProvider);
      final getProductStockByStore = ref.read(getProductStockByStoreUseCaseProvider);

      if (userId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not found',
        );
        return;
      }

      // 1. Get session review items
      final response = await getSessionReviewItems(
        sessionId: state.sessionId,
        userId: userId,
      );

      // 2. Get current stock for each product in this store
      final productIds = response.items.map((item) => item.productId).toList();

      Map<String, int> stockMap = {};
      if (productIds.isNotEmpty && state.storeId.isNotEmpty && companyId.isNotEmpty) {
        try {
          stockMap = await getProductStockByStore(
            companyId: companyId,
            storeId: state.storeId,
            productIds: productIds,
          );
        } catch (e) {
          // If stock fetch fails, continue with 0 stock (don't fail the whole operation)
        }
      }

      // 3. Merge stock data into items - create new items with correct previousStock and sessionType
      final itemsWithStock = response.items.map((item) {
        final currentStock = stockMap[item.productId] ?? 0;
        return SessionReviewItem(
          productId: item.productId,
          productName: item.productName,
          sku: item.sku,
          imageUrl: item.imageUrl,
          brand: item.brand,
          category: item.category,
          totalQuantity: item.totalQuantity,
          totalRejected: item.totalRejected,
          previousStock: currentStock,
          scannedBy: item.scannedBy,
          sessionType: state.sessionType,
        );
      }).toList();

      state = state.copyWith(
        items: itemsWithStock,
        summary: response.summary,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh session items
  Future<void> refresh() async {
    state = state.copyWith(items: [], summary: null);
    await loadSessionItems();
  }

  /// Set active filter
  void setFilter(ReviewFilter filter) {
    state = state.copyWith(activeFilter: filter);
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Clear search
  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  /// Update quantity for a product (manager edit)
  /// This stores the edited quantity to be used during submit
  void updateQuantity(String productId, int newQuantity) {
    final updatedEdits = Map<String, int>.from(state.editedQuantities);

    // Find the original item to compare
    final originalItem = state.items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => throw StateError('Product not found'),
    );

    // If the new quantity matches the original, remove from edits
    if (newQuantity == originalItem.totalQuantity) {
      updatedEdits.remove(productId);
    } else {
      updatedEdits[productId] = newQuantity;
    }

    state = state.copyWith(editedQuantities: updatedEdits);
  }

  /// Clear edit for a specific product (revert to original)
  void clearEdit(String productId) {
    final updatedEdits = Map<String, int>.from(state.editedQuantities);
    updatedEdits.remove(productId);
    state = state.copyWith(editedQuantities: updatedEdits);
  }

  /// Clear all edits
  void clearAllEdits() {
    state = state.copyWith(editedQuantities: {});
  }

  /// Submit session with confirmed items
  /// Returns success status and optional error message
  Future<({bool success, String? error, SessionSubmitResponse? data})>
      submitSession({
    bool isFinal = false,
    String? notes,
  }) async {
    if (state.items.isEmpty) {
      return (success: false, error: 'No items to submit', data: null);
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final appState = ref.read(appStateProvider);
      final userId = appState.userId;
      final submitSessionUseCase = ref.read(submitSessionUseCaseProvider);

      if (userId.isEmpty) {
        state = state.copyWith(isSubmitting: false, error: 'User not found');
        return (success: false, error: 'User not found', data: null);
      }

      // Convert state items to submit items
      // Use edited quantities if manager has made changes
      final submitItems = state.items
          .map((item) => SessionSubmitItem(
                productId: item.productId,
                quantity: state.getEffectiveQuantity(
                  item.productId,
                  item.totalQuantity,
                ),
                quantityRejected: item.totalRejected,
              ),)
          .toList();

      final response = await submitSessionUseCase(
        sessionId: state.sessionId,
        userId: userId,
        items: submitItems,
        isFinal: isFinal,
        notes: notes,
      );

      state = state.copyWith(isSubmitting: false);
      return (success: true, error: null, data: response);
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return (success: false, error: errorMsg, data: null);
    }
  }
}
