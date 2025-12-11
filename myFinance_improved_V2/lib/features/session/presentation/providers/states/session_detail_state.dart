import '../../../domain/entities/session_item.dart';

/// Selected product for session detail
class SelectedProduct {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final int quantity;
  final double? unitPrice;

  const SelectedProduct({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.quantity = 1,
    this.unitPrice,
  });

  SelectedProduct copyWith({
    String? productId,
    String? productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    int? quantity,
    double? unitPrice,
  }) {
    return SelectedProduct(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

/// State for session detail page
class SessionDetailState {
  final String sessionId;
  final String sessionType;
  final String storeId;
  final String? sessionName;

  // Session items from database
  final List<SessionItem> sessionItems;
  final bool isLoadingItems;

  // Locally selected products (before saving)
  final List<SelectedProduct> selectedProducts;

  // Search state
  final List<SearchProductResult> searchResults;
  final bool isSearching;
  final String searchQuery;
  final bool isSearchModeActive;

  // General state
  final bool isSaving;
  final String? error;

  const SessionDetailState({
    required this.sessionId,
    required this.sessionType,
    required this.storeId,
    this.sessionName,
    this.sessionItems = const [],
    this.isLoadingItems = false,
    this.selectedProducts = const [],
    this.searchResults = const [],
    this.isSearching = false,
    this.searchQuery = '',
    this.isSearchModeActive = false,
    this.isSaving = false,
    this.error,
  });

  factory SessionDetailState.initial({
    required String sessionId,
    required String sessionType,
    required String storeId,
    String? sessionName,
  }) {
    return SessionDetailState(
      sessionId: sessionId,
      sessionType: sessionType,
      storeId: storeId,
      sessionName: sessionName,
    );
  }

  SessionDetailState copyWith({
    String? sessionId,
    String? sessionType,
    String? storeId,
    String? sessionName,
    List<SessionItem>? sessionItems,
    bool? isLoadingItems,
    List<SelectedProduct>? selectedProducts,
    List<SearchProductResult>? searchResults,
    bool? isSearching,
    String? searchQuery,
    bool? isSearchModeActive,
    bool? isSaving,
    String? error,
  }) {
    return SessionDetailState(
      sessionId: sessionId ?? this.sessionId,
      sessionType: sessionType ?? this.sessionType,
      storeId: storeId ?? this.storeId,
      sessionName: sessionName ?? this.sessionName,
      sessionItems: sessionItems ?? this.sessionItems,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchModeActive: isSearchModeActive ?? this.isSearchModeActive,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  /// Check if a product is already selected
  bool isProductSelected(String productId) {
    return selectedProducts.any((p) => p.productId == productId);
  }

  /// Get selected product by ID
  SelectedProduct? getSelectedProduct(String productId) {
    try {
      return selectedProducts.firstWhere((p) => p.productId == productId);
    } catch (_) {
      return null;
    }
  }

  /// Check if in search mode
  bool get isInSearchMode =>
      isSearchModeActive || searchResults.isNotEmpty || isSearching;

  /// Total selected products count
  int get totalSelectedCount => selectedProducts.length;

  /// Total quantity of all selected products
  int get totalQuantity =>
      selectedProducts.fold(0, (sum, p) => sum + p.quantity);

  /// Check if has selected products
  bool get hasSelectedProducts => selectedProducts.isNotEmpty;
}

/// Search result product (from inventory search)
class SearchProductResult {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final double? sellingPrice;
  final int stockQuantity;

  const SearchProductResult({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.sellingPrice,
    this.stockQuantity = 0,
  });

  factory SearchProductResult.fromJson(Map<String, dynamic> json) {
    // Handle image URL from various formats
    String? imageUrl;
    if (json['images'] is Map) {
      final images = json['images'] as Map<String, dynamic>;
      imageUrl = images['thumbnail']?.toString() ?? images['main_image']?.toString();
    } else if (json['image_urls'] is List) {
      final urls = json['image_urls'] as List;
      if (urls.isNotEmpty) imageUrl = urls.first.toString();
    } else {
      imageUrl = json['image_url']?.toString() ?? json['thumbnail']?.toString();
    }

    // Handle pricing from various formats
    double? sellingPrice;
    if (json['pricing'] is Map) {
      final pricing = json['pricing'] as Map<String, dynamic>;
      sellingPrice = (pricing['selling'] as num?)?.toDouble() ??
          (pricing['selling_price'] as num?)?.toDouble();
    } else if (json['price'] is num) {
      sellingPrice = (json['price'] as num).toDouble();
    }

    // Handle stock quantity
    int stockQuantity = 0;
    if (json['total_stock_summary'] is Map) {
      final stock = json['total_stock_summary'] as Map<String, dynamic>;
      stockQuantity = (stock['total_quantity_available'] as num?)?.toInt() ?? 0;
    }

    return SearchProductResult(
      productId: json['product_id']?.toString() ?? json['id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? json['name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
      imageUrl: imageUrl,
      sellingPrice: sellingPrice,
      stockQuantity: stockQuantity,
    );
  }
}
