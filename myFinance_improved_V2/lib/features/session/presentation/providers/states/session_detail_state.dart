import '../../../domain/entities/session_item.dart';

/// Selected product for session detail
/// Supports v6 variant - variantId used to uniquely identify variants
class SelectedProduct {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final int quantity;
  final int quantityRejected;
  final double? unitPrice;

  // v6 variant fields
  final String? variantId;
  final String? displayName;

  const SelectedProduct({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.quantity = 1,
    this.quantityRejected = 0,
    this.unitPrice,
    this.variantId,
    this.displayName,
  });

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Total quantity (good + rejected)
  int get totalQuantity => quantity + quantityRejected;

  SelectedProduct copyWith({
    String? productId,
    String? productName,
    String? sku,
    String? barcode,
    String? imageUrl,
    int? quantity,
    int? quantityRejected,
    double? unitPrice,
    String? variantId,
    String? displayName,
  }) {
    return SelectedProduct(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      quantityRejected: quantityRejected ?? this.quantityRejected,
      unitPrice: unitPrice ?? this.unitPrice,
      variantId: variantId ?? this.variantId,
      displayName: displayName ?? this.displayName,
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

  // Inventory list state (for initial display)
  final List<SearchProductResult> inventoryProducts;
  final bool isLoadingInventory;
  final bool isLoadingMoreInventory;
  final int currentPage;
  final bool hasMoreInventory;
  final int totalInventoryCount;

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
    this.inventoryProducts = const [],
    this.isLoadingInventory = false,
    this.isLoadingMoreInventory = false,
    this.currentPage = 1,
    this.hasMoreInventory = true,
    this.totalInventoryCount = 0,
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
    List<SearchProductResult>? inventoryProducts,
    bool? isLoadingInventory,
    bool? isLoadingMoreInventory,
    int? currentPage,
    bool? hasMoreInventory,
    int? totalInventoryCount,
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
      inventoryProducts: inventoryProducts ?? this.inventoryProducts,
      isLoadingInventory: isLoadingInventory ?? this.isLoadingInventory,
      isLoadingMoreInventory: isLoadingMoreInventory ?? this.isLoadingMoreInventory,
      currentPage: currentPage ?? this.currentPage,
      hasMoreInventory: hasMoreInventory ?? this.hasMoreInventory,
      totalInventoryCount: totalInventoryCount ?? this.totalInventoryCount,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearchModeActive: isSearchModeActive ?? this.isSearchModeActive,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  /// Check if a product/variant is already selected
  /// For variants, uses productId + variantId combination
  bool isProductSelected(String productId, {String? variantId}) {
    return selectedProducts.any((p) =>
        p.productId == productId && p.variantId == variantId);
  }

  /// Get selected product by ID (and variantId for variants)
  SelectedProduct? getSelectedProduct(String productId, {String? variantId}) {
    try {
      return selectedProducts.firstWhere((p) =>
          p.productId == productId && p.variantId == variantId);
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
/// Supports v6 variant expansion - each variant is a separate row
class SearchProductResult {
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final double? sellingPrice;
  final int stockQuantity;

  // v6 variant fields
  final String? variantId;
  final String? variantName;
  final String? displayName;
  final String? displaySku;
  final String? displayBarcode;
  final bool hasVariants;

  const SearchProductResult({
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    this.sellingPrice,
    this.stockQuantity = 0,
    this.variantId,
    this.variantName,
    this.displayName,
    this.displaySku,
    this.displayBarcode,
    this.hasVariants = false,
  });

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Display SKU for UI - uses displaySku if available, otherwise sku
  String? get effectiveSku => displaySku ?? sku;

  /// Display barcode for UI - uses displayBarcode if available, otherwise barcode
  String? get effectiveBarcode => displayBarcode ?? barcode;
}
