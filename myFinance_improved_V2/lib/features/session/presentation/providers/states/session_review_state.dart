import '../../../domain/entities/session_review_item.dart';

// Re-export domain entities for convenience
export '../../../domain/entities/session_review_item.dart';

/// Filter types for review items
enum ReviewFilter {
  all,
  increased,
  decreased,
  unchanged,
}

/// State for session review page
class SessionReviewState {
  final String sessionId;
  final String sessionType;
  final String? sessionName;
  final String storeId;
  final List<SessionReviewItem> items;
  final SessionReviewSummary? summary;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  // Filter and search
  final ReviewFilter activeFilter;
  final String searchQuery;

  // Manager edited quantities - key: itemKey (productId or productId:variantId), value: edited totalQuantity
  // Only stores edits (if key not in map, use original value)
  // v2: Uses composite key for variant products
  final Map<String, int> editedQuantities;

  const SessionReviewState({
    required this.sessionId,
    required this.sessionType,
    this.sessionName,
    required this.storeId,
    this.items = const [],
    this.summary,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.activeFilter = ReviewFilter.all,
    this.searchQuery = '',
    this.editedQuantities = const {},
  });

  factory SessionReviewState.initial({
    required String sessionId,
    required String sessionType,
    String? sessionName,
    required String storeId,
  }) {
    return SessionReviewState(
      sessionId: sessionId,
      sessionType: sessionType,
      sessionName: sessionName,
      storeId: storeId,
    );
  }

  SessionReviewState copyWith({
    String? sessionId,
    String? sessionType,
    String? sessionName,
    String? storeId,
    List<SessionReviewItem>? items,
    SessionReviewSummary? summary,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    ReviewFilter? activeFilter,
    String? searchQuery,
    Map<String, int>? editedQuantities,
  }) {
    return SessionReviewState(
      sessionId: sessionId ?? this.sessionId,
      sessionType: sessionType ?? this.sessionType,
      sessionName: sessionName ?? this.sessionName,
      storeId: storeId ?? this.storeId,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      editedQuantities: editedQuantities ?? this.editedQuantities,
    );
  }

  bool get hasItems => items.isNotEmpty;
  bool get hasError => error != null;

  /// Get filtered items based on active filter and search query
  List<SessionReviewItem> get filteredItems {
    var result = items;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      result = result.where((item) {
        return item.productName.toLowerCase().contains(query) ||
            (item.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply category filter
    switch (activeFilter) {
      case ReviewFilter.all:
        return result;
      case ReviewFilter.increased:
        return result.where((item) => item.stockChange > 0).toList();
      case ReviewFilter.decreased:
        return result.where((item) => item.stockChange < 0).toList();
      case ReviewFilter.unchanged:
        return result.where((item) => item.stockChange == 0).toList();
    }
  }

  /// Get count of items changed (increased or decreased)
  int get itemsChangedCount {
    return items.where((item) => item.stockChange != 0).length;
  }

  /// Generate unique key for item (handles variant products)
  /// v2: Uses composite key productId:variantId for variant products
  String getItemKey(SessionReviewItem item) {
    if (item.hasVariants && item.variantId != null) {
      return '${item.productId}:${item.variantId}';
    }
    return item.productId;
  }

  /// Check if an item has been edited by manager
  /// v2: Uses composite key for variant products
  bool isEdited(SessionReviewItem item) => editedQuantities.containsKey(getItemKey(item));

  /// Check if a product has been edited by manager (legacy - for backward compatibility)
  @Deprecated('Use isEdited(SessionReviewItem) instead for variant support')
  bool isEditedByProductId(String productId) => editedQuantities.containsKey(productId);

  /// Get effective quantity for an item (edited value if exists, otherwise original)
  /// v2: Uses composite key for variant products
  int getEffectiveQuantity(SessionReviewItem item) {
    return editedQuantities[getItemKey(item)] ?? item.totalQuantity;
  }

  /// Get effective quantity by key (for submit)
  int getEffectiveQuantityByKey(String itemKey, int originalQuantity) {
    return editedQuantities[itemKey] ?? originalQuantity;
  }

  /// Get stock change for display, considering edited quantity
  int getEffectiveStockChange(SessionReviewItem item) {
    final effectiveQty = getEffectiveQuantity(item);
    final netQty = effectiveQty - item.totalRejected;
    // For counting: newStock = netQty
    if (sessionType == 'counting') {
      return netQty - item.previousStock;
    }
    // For receiving: newStock = previousStock + netQty
    return netQty;
  }

  /// Get new stock value, considering edited quantity
  int getEffectiveNewStock(SessionReviewItem item) {
    final effectiveQty = getEffectiveQuantity(item);
    final netQty = effectiveQty - item.totalRejected;
    // For counting: newStock = netQty (counted quantity replaces stock)
    if (sessionType == 'counting') {
      return netQty;
    }
    // For receiving: newStock = previousStock + netQty
    return item.previousStock + netQty;
  }

  /// Check if there are any edits
  bool get hasEdits => editedQuantities.isNotEmpty;
}
