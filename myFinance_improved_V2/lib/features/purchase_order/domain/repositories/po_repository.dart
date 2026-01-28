import '../entities/purchase_order.dart';

/// Parameters for PO list query using inventory_get_order_list RPC
class POListParams {
  final String companyId;
  final String? storeId;
  // Legacy status filter - will be converted to orderStatuses
  final List<POStatus>? statuses;
  // New RPC status filters
  final List<OrderStatus>? orderStatuses;
  final List<ReceivingStatus>? receivingStatuses;
  // Supplier filter (was counterpartyId/buyerId)
  final String? supplierId;
  final String? counterpartyId; // Legacy alias for supplierId
  final bool? hasLc;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchQuery;
  final String? timezone;
  final int page;
  final int pageSize;

  POListParams({
    required this.companyId,
    this.storeId,
    this.statuses,
    this.orderStatuses,
    this.receivingStatuses,
    this.supplierId,
    this.counterpartyId,
    this.hasLc,
    this.dateFrom,
    this.dateTo,
    this.searchQuery,
    this.timezone,
    this.page = 1,
    this.pageSize = 20,
  });

  /// Get effective supplier ID (supplierId or legacy counterpartyId)
  String? get effectiveSupplierId => supplierId ?? counterpartyId;
}

/// Paginated PO response
class PaginatedPOResponse {
  final List<POListItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedPOResponse({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

/// PO Repository interface
abstract class PORepository {
  /// Get paginated list of POs
  Future<PaginatedPOResponse> getList(POListParams params);

  /// Get PO by ID
  Future<PurchaseOrder> getById(String poId, {required String companyId});

  /// Close order (cancel order and all linked shipments/sessions)
  Future<Map<String, dynamic>> closeOrder({
    required String orderId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  });

  /// Create order using inventory_create_order_v4 RPC
  Future<Map<String, dynamic>> createOrderV4({
    required String companyId,
    required String userId,
    required List<Map<String, dynamic>> items,
    required String orderTitle,
    String? counterpartyId,
    Map<String, dynamic>? supplierInfo,
    String? notes,
    String? orderNumber,
    String timezone = 'Asia/Ho_Chi_Minh',
  });

  /// Get suppliers/counterparties for filter selection
  Future<List<SupplierFilterItem>> getSuppliers(String companyId);

  /// Get base currency and company currencies
  Future<BaseCurrencyData> getBaseCurrency(String companyId);

  /// Search products for order items
  Future<ProductSearchResult> searchProducts({
    required String companyId,
    required String storeId,
    required String query,
    int page = 1,
    int limit = 20,
  });
}

/// Supplier item for filter selection
class SupplierFilterItem {
  final String counterpartyId;
  final String name;
  final String? type;
  final String? email;
  final String? phone;

  const SupplierFilterItem({
    required this.counterpartyId,
    required this.name,
    this.type,
    this.email,
    this.phone,
  });
}

/// Currency info
class CurrencyInfo {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String? flagEmoji;
  final double exchangeRateToBase;
  final DateTime? rateDate;

  const CurrencyInfo({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    this.flagEmoji,
    this.exchangeRateToBase = 1.0,
    this.rateDate,
  });
}

/// Base currency data
class BaseCurrencyData {
  final CurrencyInfo baseCurrency;
  final List<CurrencyInfo> companyCurrencies;

  const BaseCurrencyData({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  double? getExchangeRate(String currencyCode) {
    if (currencyCode == baseCurrency.currencyCode) return 1.0;
    final currency = companyCurrencies.where(
      (c) => c.currencyCode == currencyCode,
    ).firstOrNull;
    return currency?.exchangeRateToBase;
  }
}

/// Product item for search results
class ProductItem {
  final String productId;
  final String productName;
  final String? productSku;
  final String? productBarcode;
  final String? variantId;
  final String? variantName;
  final String? variantSku;
  final String displayName;
  final String? displaySku;
  final String unit;
  final double costPrice;
  final double sellingPrice;
  final double quantityOnHand;
  final List<String> imageUrls;
  final bool hasVariants;

  const ProductItem({
    required this.productId,
    required this.productName,
    this.productSku,
    this.productBarcode,
    this.variantId,
    this.variantName,
    this.variantSku,
    required this.displayName,
    this.displaySku,
    required this.unit,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantityOnHand,
    this.imageUrls = const [],
    this.hasVariants = false,
  });

  /// Unique key for item (product_id + variant_id or just product_id)
  String get uniqueKey => variantId != null ? '${productId}_$variantId' : productId;
}

/// Product search result
class ProductSearchResult {
  final List<ProductItem> items;
  final int totalCount;
  final int page;
  final bool hasMore;

  const ProductSearchResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.hasMore,
  });
}
