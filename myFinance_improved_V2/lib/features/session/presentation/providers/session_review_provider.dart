import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/session_providers.dart';
import '../../domain/repositories/session_repository.dart';
import '../../domain/usecases/get_session_review_items.dart';
import '../../domain/usecases/submit_session.dart';
import 'states/session_review_state.dart';

/// Notifier for session review state management
class SessionReviewNotifier extends StateNotifier<SessionReviewState> {
  final Ref _ref;
  final GetSessionReviewItems _getSessionReviewItems;
  final SubmitSession _submitSession;
  final SessionRepository _repository;

  SessionReviewNotifier({
    required Ref ref,
    required GetSessionReviewItems getSessionReviewItems,
    required SubmitSession submitSession,
    required SessionRepository repository,
    required String sessionId,
    required String sessionType,
    String? sessionName,
    required String storeId,
  })  : _ref = ref,
        _getSessionReviewItems = getSessionReviewItems,
        _submitSession = submitSession,
        _repository = repository,
        super(SessionReviewState.initial(
          sessionId: sessionId,
          sessionType: sessionType,
          sessionName: sessionName,
          storeId: storeId,
        ),);

  /// Load session items via UseCase and fetch current stock for each product
  Future<void> loadSessionItems() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final userId = appState.userId;
      final companyId = appState.companyChoosen;

      // DEBUG
      print('🔍 [SessionReview] Loading items...');
      print('🔍 [SessionReview] sessionId: ${state.sessionId}');
      print('🔍 [SessionReview] sessionType: ${state.sessionType}');
      print('🔍 [SessionReview] storeId: ${state.storeId}');
      print('🔍 [SessionReview] companyId: $companyId');
      print('🔍 [SessionReview] userId: $userId');

      if (userId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'User not found',
        );
        return;
      }

      // 1. Get session review items
      final response = await _getSessionReviewItems(
        sessionId: state.sessionId,
        userId: userId,
      );

      print('🔍 [SessionReview] Got ${response.items.length} items from RPC');
      for (final item in response.items) {
        print('🔍 [SessionReview] Item: ${item.productName}');
        print('   - productId: ${item.productId}');
        print('   - totalQuantity: ${item.totalQuantity}');
        print('   - totalRejected: ${item.totalRejected}');
        print('   - previousStock (from RPC): ${item.previousStock}');
      }

      // 2. Get current stock for each product in this store
      final productIds = response.items.map((item) => item.productId).toList();
      print('🔍 [SessionReview] Product IDs for stock lookup: $productIds');

      Map<String, int> stockMap = {};
      if (productIds.isNotEmpty && state.storeId.isNotEmpty && companyId.isNotEmpty) {
        try {
          stockMap = await _repository.getProductStockByStore(
            companyId: companyId,
            storeId: state.storeId,
            productIds: productIds,
          );
          print('🔍 [SessionReview] Stock map from RPC: $stockMap');
        } catch (e) {
          // If stock fetch fails, continue with 0 stock (don't fail the whole operation)
          print('❌ [SessionReview] Failed to fetch stock data: $e');
        }
      } else {
        print('⚠️ [SessionReview] Skipping stock lookup - missing data');
        print('   - productIds.isEmpty: ${productIds.isEmpty}');
        print('   - storeId.isEmpty: ${state.storeId.isEmpty}');
        print('   - companyId.isEmpty: ${companyId.isEmpty}');
      }

      // 3. Merge stock data into items - create new items with correct previousStock and sessionType
      final itemsWithStock = response.items.map((item) {
        final currentStock = stockMap[item.productId] ?? 0;
        final newItem = SessionReviewItem(
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

        print('🔍 [SessionReview] Final item: ${item.productName}');
        print('   - previousStock (from stock RPC): $currentStock');
        print('   - totalQuantity: ${item.totalQuantity}');
        print('   - totalRejected: ${item.totalRejected}');
        print('   - netQuantity: ${newItem.netQuantity}');
        print('   - newStock: ${newItem.newStock}');
        print('   - stockChange: ${newItem.stockChange}');

        return newItem;
      }).toList();

      state = state.copyWith(
        items: itemsWithStock,
        summary: response.summary,
        isLoading: false,
      );
    } catch (e) {
      print('❌ [SessionReview] Error loading items: $e');
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
    print('🔄 [SessionReview] submitSession called');
    print('🔄 [SessionReview] isFinal: $isFinal');
    print('🔄 [SessionReview] items count: ${state.items.length}');

    if (state.items.isEmpty) {
      print('❌ [SessionReview] No items to submit');
      return (success: false, error: 'No items to submit', data: null);
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final appState = _ref.read(appStateProvider);
      final userId = appState.userId;

      print('🔄 [SessionReview] userId: $userId');

      if (userId.isEmpty) {
        print('❌ [SessionReview] User not found');
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

      print('🔄 [SessionReview] submitItems: ${submitItems.length}');
      for (final item in submitItems) {
        print('   - productId: ${item.productId}, qty: ${item.quantity}, rejected: ${item.quantityRejected}');
      }

      print('🔄 [SessionReview] Calling _submitSession RPC...');
      final response = await _submitSession(
        sessionId: state.sessionId,
        userId: userId,
        items: submitItems,
        isFinal: isFinal,
        notes: notes,
      );

      print('✅ [SessionReview] RPC Success!');
      print('✅ [SessionReview] receivingNumber: ${response.receivingNumber}');
      print('✅ [SessionReview] stockChanges count: ${response.stockChanges.length}');
      print('✅ [SessionReview] newDisplayCount: ${response.newDisplayCount}');

      state = state.copyWith(isSubmitting: false);
      return (success: true, error: null, data: response);
    } catch (e, stackTrace) {
      print('❌ [SessionReview] Error: $e');
      print('❌ [SessionReview] StackTrace: $stackTrace');
      final errorMsg = e.toString();
      state = state.copyWith(isSubmitting: false, error: errorMsg);
      return (success: false, error: errorMsg, data: null);
    }
  }
}

/// Provider parameters record
typedef SessionReviewParams = ({
  String sessionId,
  String sessionType,
  String? sessionName,
  String storeId,
});

/// Provider for session review
final sessionReviewProvider = StateNotifierProvider.autoDispose
    .family<SessionReviewNotifier, SessionReviewState, SessionReviewParams>(
        (ref, params) {
  final getSessionReviewItems = ref.watch(getSessionReviewItemsUseCaseProvider);
  final submitSession = ref.watch(submitSessionUseCaseProvider);
  final repository = ref.watch(sessionRepositoryProvider);

  final notifier = SessionReviewNotifier(
    ref: ref,
    getSessionReviewItems: getSessionReviewItems,
    submitSession: submitSession,
    repository: repository,
    sessionId: params.sessionId,
    sessionType: params.sessionType,
    sessionName: params.sessionName,
    storeId: params.storeId,
  );

  // Auto-load on creation
  notifier.loadSessionItems();

  return notifier;
});
