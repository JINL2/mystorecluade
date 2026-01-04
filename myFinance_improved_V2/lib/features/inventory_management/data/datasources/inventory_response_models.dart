// Inventory Response Models
// Data classes for RPC responses from Supabase inventory functions

import '../models/product_model.dart';

/// Product Page Response Model
class ProductPageResponse {
  final List<ProductModel> products;
  final PaginationData pagination;
  final CurrencyData currency;
  final InventorySummaryData summary;

  ProductPageResponse({
    required this.products,
    required this.pagination,
    required this.currency,
    required this.summary,
  });

  factory ProductPageResponse.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List? ?? [];
    final products = productsJson
        .map((p) => ProductModel.fromJson(p as Map<String, dynamic>))
        .toList();

    final paginationJson = json['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationData.fromJson(paginationJson);

    final currencyJson = json['currency'] as Map<String, dynamic>? ?? {};
    final currency = CurrencyData.fromJson(currencyJson);

    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final summary = InventorySummaryData.fromJson(summaryJson);

    return ProductPageResponse(
      products: products,
      pagination: pagination,
      currency: currency,
      summary: summary,
    );
  }
}

/// Summary data from get_inventory_page_v5
class InventorySummaryData {
  final double totalValue;
  final int filteredCount;

  InventorySummaryData({
    required this.totalValue,
    required this.filteredCount,
  });

  factory InventorySummaryData.fromJson(Map<String, dynamic> json) {
    return InventorySummaryData(
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      filteredCount: (json['filtered_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class PaginationData {
  final int page;
  final int limit;
  final int total;
  final bool hasNext;
  final int totalPages;

  PaginationData({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
    required this.totalPages,
  });

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      page: (json['page'] ?? 1) as int,
      limit: (json['limit'] ?? 10) as int,
      total: (json['total'] ?? 0) as int,
      hasNext: (json['has_next'] ?? false) as bool,
      totalPages: (json['total_pages'] ?? 1) as int,
    );
  }
}

class CurrencyData {
  final String? code;
  final String? name;
  final String? symbol;

  CurrencyData({
    this.code,
    this.name,
    this.symbol,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
    );
  }
}

/// Edit Validation Result from inventory_check_edit RPC
class EditValidationResult {
  final bool success;
  final String? message;
  final EditValidationError? error;
  final EditValidations validations;

  EditValidationResult({
    required this.success,
    this.message,
    this.error,
    required this.validations,
  });

  factory EditValidationResult.fromJson(Map<String, dynamic> json) {
    return EditValidationResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      error: json['error'] != null
          ? EditValidationError.fromJson(json['error'] as Map<String, dynamic>)
          : null,
      validations: EditValidations.fromJson(
        json['validations'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Error details from validation
class EditValidationError {
  final String code;
  final String message;
  final String? details;

  EditValidationError({
    required this.code,
    required this.message,
    this.details,
  });

  factory EditValidationError.fromJson(Map<String, dynamic> json) {
    return EditValidationError(
      code: json['code'] as String? ?? 'UNKNOWN_ERROR',
      message: json['message'] as String? ?? 'Unknown error occurred',
      details: json['details'] as String?,
    );
  }
}

/// Validation flags from check
class EditValidations {
  final bool productExists;
  final bool nameAvailable;
  final bool skuAvailable;

  EditValidations({
    required this.productExists,
    required this.nameAvailable,
    required this.skuAvailable,
  });

  factory EditValidations.fromJson(Map<String, dynamic> json) {
    return EditValidations(
      productExists: json['product_exists'] as bool? ?? false,
      nameAvailable: json['name_available'] as bool? ?? true,
      skuAvailable: json['sku_available'] as bool? ?? true,
    );
  }
}

/// Result from inventory_product_stock_stores RPC
class ProductStockStoresResult {
  final List<ProductStockInfo> products;
  final ProductStockSummary summary;

  ProductStockStoresResult({
    required this.products,
    required this.summary,
  });

  factory ProductStockStoresResult.fromJson(Map<String, dynamic> json) {
    final productsJson = json['products'] as List<dynamic>? ?? [];
    return ProductStockStoresResult(
      products: productsJson
          .map((p) => ProductStockInfo.fromJson(p as Map<String, dynamic>))
          .toList(),
      summary: ProductStockSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Product stock info with stores
class ProductStockInfo {
  final String productId;
  final String productName;
  final String sku;
  final int totalQuantity;
  final int storesWithStock;
  final List<StoreStockInfo> stores;

  ProductStockInfo({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.totalQuantity,
    required this.storesWithStock,
    required this.stores,
  });

  factory ProductStockInfo.fromJson(Map<String, dynamic> json) {
    final storesJson = json['stores'] as List<dynamic>? ?? [];
    return ProductStockInfo(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      storesWithStock: (json['stores_with_stock'] as num?)?.toInt() ?? 0,
      stores: storesJson
          .map((s) => StoreStockInfo.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Store stock info
class StoreStockInfo {
  final String storeId;
  final String storeName;
  final String storeCode;
  final int quantityOnHand;
  final int quantityAvailable;
  final int quantityReserved;

  StoreStockInfo({
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    required this.quantityOnHand,
    required this.quantityAvailable,
    required this.quantityReserved,
  });

  factory StoreStockInfo.fromJson(Map<String, dynamic> json) {
    return StoreStockInfo(
      storeId: json['store_id'] as String? ?? '',
      storeName: json['store_name'] as String? ?? '',
      storeCode: json['store_code'] as String? ?? '',
      quantityOnHand: (json['quantity_on_hand'] as num?)?.toInt() ?? 0,
      quantityAvailable: (json['quantity_available'] as num?)?.toInt() ?? 0,
      quantityReserved: (json['quantity_reserved'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Summary of product stock query
class ProductStockSummary {
  final int totalProductsRequested;
  final int totalProductsFound;
  final int totalStores;
  final int grandTotalQuantity;

  ProductStockSummary({
    required this.totalProductsRequested,
    required this.totalProductsFound,
    required this.totalStores,
    required this.grandTotalQuantity,
  });

  factory ProductStockSummary.fromJson(Map<String, dynamic> json) {
    return ProductStockSummary(
      totalProductsRequested: (json['total_products_requested'] as num?)?.toInt() ?? 0,
      totalProductsFound: (json['total_products_found'] as num?)?.toInt() ?? 0,
      totalStores: (json['total_stores'] as num?)?.toInt() ?? 0,
      grandTotalQuantity: (json['grand_total_quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Result from inventory_product_history RPC
class ProductHistoryResult {
  final List<ProductHistoryItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  ProductHistoryResult({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory ProductHistoryResult.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as List<dynamic>? ?? [];
    return ProductHistoryResult(
      data: dataJson
          .map((item) => ProductHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Individual history item from product history
class ProductHistoryItem {
  final String logId;
  final String eventCategory;
  final String eventType;
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  // Price fields
  final double? costBefore;
  final double? costAfter;
  final double? sellingPriceBefore;
  final double? sellingPriceAfter;
  final double? minPriceBefore;
  final double? minPriceAfter;
  // Product fields
  final String? nameBefore;
  final String? nameAfter;
  final String? skuBefore;
  final String? skuAfter;
  final String? barcodeBefore;
  final String? barcodeAfter;
  final String? brandIdBefore;
  final String? brandIdAfter;
  final String? brandNameBefore;
  final String? brandNameAfter;
  final String? categoryIdBefore;
  final String? categoryIdAfter;
  final String? categoryNameBefore;
  final String? categoryNameAfter;
  final double? weightBefore;
  final double? weightAfter;
  // Reference fields
  final String? invoiceId;
  final String? invoiceNumber;
  final String? transferId;
  final String? fromStoreId;
  final String? fromStoreName;
  final String? toStoreId;
  final String? toStoreName;
  // Other fields
  final String? reason;
  final String? notes;
  final String? createdBy;
  final String? createdUser;
  final String? createdUserProfileImage;
  final String createdAt;

  ProductHistoryItem({
    required this.logId,
    required this.eventCategory,
    required this.eventType,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.costBefore,
    this.costAfter,
    this.sellingPriceBefore,
    this.sellingPriceAfter,
    this.minPriceBefore,
    this.minPriceAfter,
    this.nameBefore,
    this.nameAfter,
    this.skuBefore,
    this.skuAfter,
    this.barcodeBefore,
    this.barcodeAfter,
    this.brandIdBefore,
    this.brandIdAfter,
    this.brandNameBefore,
    this.brandNameAfter,
    this.categoryIdBefore,
    this.categoryIdAfter,
    this.categoryNameBefore,
    this.categoryNameAfter,
    this.weightBefore,
    this.weightAfter,
    this.invoiceId,
    this.invoiceNumber,
    this.transferId,
    this.fromStoreId,
    this.fromStoreName,
    this.toStoreId,
    this.toStoreName,
    this.reason,
    this.notes,
    this.createdBy,
    this.createdUser,
    this.createdUserProfileImage,
    required this.createdAt,
  });

  factory ProductHistoryItem.fromJson(Map<String, dynamic> json) {
    return ProductHistoryItem(
      logId: json['log_id'] as String? ?? '',
      eventCategory: json['event_category'] as String? ?? '',
      eventType: json['event_type'] as String? ?? '',
      quantityBefore: (json['quantity_before'] as num?)?.toInt(),
      quantityAfter: (json['quantity_after'] as num?)?.toInt(),
      quantityChange: (json['quantity_change'] as num?)?.toInt(),
      costBefore: (json['cost_before'] as num?)?.toDouble(),
      costAfter: (json['cost_after'] as num?)?.toDouble(),
      sellingPriceBefore: (json['selling_price_before'] as num?)?.toDouble(),
      sellingPriceAfter: (json['selling_price_after'] as num?)?.toDouble(),
      minPriceBefore: (json['min_price_before'] as num?)?.toDouble(),
      minPriceAfter: (json['min_price_after'] as num?)?.toDouble(),
      nameBefore: json['name_before'] as String?,
      nameAfter: json['name_after'] as String?,
      skuBefore: json['sku_before'] as String?,
      skuAfter: json['sku_after'] as String?,
      barcodeBefore: json['barcode_before'] as String?,
      barcodeAfter: json['barcode_after'] as String?,
      brandIdBefore: json['brand_id_before'] as String?,
      brandIdAfter: json['brand_id_after'] as String?,
      brandNameBefore: json['brand_name_before'] as String?,
      brandNameAfter: json['brand_name_after'] as String?,
      categoryIdBefore: json['category_id_before'] as String?,
      categoryIdAfter: json['category_id_after'] as String?,
      categoryNameBefore: json['category_name_before'] as String?,
      categoryNameAfter: json['category_name_after'] as String?,
      weightBefore: (json['weight_before'] as num?)?.toDouble(),
      weightAfter: (json['weight_after'] as num?)?.toDouble(),
      invoiceId: json['invoice_id'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      transferId: json['transfer_id'] as String?,
      fromStoreId: json['from_store_id'] as String?,
      fromStoreName: json['from_store_name'] as String?,
      toStoreId: json['to_store_id'] as String?,
      toStoreName: json['to_store_name'] as String?,
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdUser: json['created_user'] as String?,
      createdUserProfileImage: json['created_user_profile_image'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}

/// Base Currency Response from get_base_currency RPC
class BaseCurrencyResponse {
  final BaseCurrencyData baseCurrency;
  final List<CompanyCurrencyData> companyCurrencies;

  BaseCurrencyResponse({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  factory BaseCurrencyResponse.fromJson(Map<String, dynamic> json) {
    final baseCurrencyJson = json['base_currency'] as Map<String, dynamic>? ?? {};
    final companyCurrenciesJson = json['company_currencies'] as List? ?? [];

    return BaseCurrencyResponse(
      baseCurrency: BaseCurrencyData.fromJson(baseCurrencyJson),
      companyCurrencies: companyCurrenciesJson
          .map((c) => CompanyCurrencyData.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Base Currency Data
class BaseCurrencyData {
  final String? currencyId;
  final String? currencyCode;
  final String? currencyName;
  final String? symbol;
  final String? flagEmoji;

  BaseCurrencyData({
    this.currencyId,
    this.currencyCode,
    this.currencyName,
    this.symbol,
    this.flagEmoji,
  });

  factory BaseCurrencyData.fromJson(Map<String, dynamic> json) {
    return BaseCurrencyData(
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String?,
      currencyName: json['currency_name'] as String?,
      symbol: json['symbol'] as String?,
      flagEmoji: json['flag_emoji'] as String?,
    );
  }

  String get displaySymbol => symbol ?? currencyCode ?? '';
}

/// Company Currency Data with exchange rate
class CompanyCurrencyData {
  final String? currencyId;
  final String? currencyCode;
  final String? currencyName;
  final String? symbol;
  final String? flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;
  final List<DenominationData> denominations;

  CompanyCurrencyData({
    this.currencyId,
    this.currencyCode,
    this.currencyName,
    this.symbol,
    this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
    this.denominations = const [],
  });

  factory CompanyCurrencyData.fromJson(Map<String, dynamic> json) {
    final denominationsJson = json['denominations'] as List? ?? [];
    return CompanyCurrencyData(
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String?,
      currencyName: json['currency_name'] as String?,
      symbol: json['symbol'] as String?,
      flagEmoji: json['flag_emoji'] as String?,
      exchangeRateToBase: (json['exchange_rate_to_base'] as num?)?.toDouble(),
      rateDate: json['rate_date'] as String?,
      denominations: denominationsJson
          .map((d) => DenominationData.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Denomination Data
class DenominationData {
  final String? denominationId;
  final double? value;

  DenominationData({
    this.denominationId,
    this.value,
  });

  factory DenominationData.fromJson(Map<String, dynamic> json) {
    return DenominationData(
      denominationId: json['denomination_id'] as String?,
      value: (json['value'] as num?)?.toDouble(),
    );
  }
}

/// Create Validation Result from inventory_check_create RPC
class CreateValidationResult {
  final bool success;
  final String? message;
  final String? errorCode;
  final String? errorMessage;
  final CreateValidationData? data;

  CreateValidationResult({
    required this.success,
    this.message,
    this.errorCode,
    this.errorMessage,
    this.data,
  });

  factory CreateValidationResult.fromJson(Map<String, dynamic> json) {
    return CreateValidationResult(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      errorCode: json['code'] as String?,
      errorMessage: json['error'] as String?,
      data: json['data'] != null
          ? CreateValidationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Data from successful create validation
class CreateValidationData {
  final String sku;
  final String barcode;
  final AutoGeneratedFlags autoGenerated;

  CreateValidationData({
    required this.sku,
    required this.barcode,
    required this.autoGenerated,
  });

  factory CreateValidationData.fromJson(Map<String, dynamic> json) {
    return CreateValidationData(
      sku: json['sku'] as String? ?? '',
      barcode: json['barcode'] as String? ?? '',
      autoGenerated: AutoGeneratedFlags.fromJson(
        json['auto_generated'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Auto-generated flags indicating which fields were auto-generated
class AutoGeneratedFlags {
  final bool sku;
  final bool barcode;

  AutoGeneratedFlags({
    required this.sku,
    required this.barcode,
  });

  factory AutoGeneratedFlags.fromJson(Map<String, dynamic> json) {
    return AutoGeneratedFlags(
      sku: json['sku'] as bool? ?? false,
      barcode: json['barcode'] as bool? ?? false,
    );
  }
}

/// Inventory History Result from inventory_history RPC
class InventoryHistoryResult {
  final List<InventoryHistoryItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  InventoryHistoryResult({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory InventoryHistoryResult.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'] as List<dynamic>? ?? [];
    return InventoryHistoryResult(
      data: dataJson
          .map((item) => InventoryHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}

/// Individual history item from inventory history (includes product info)
class InventoryHistoryItem {
  final String logId;
  final String eventCategory;
  final String eventType;
  // Product info
  final String? productId;
  final String? productName;
  final String? productSku;
  final String? productImage;
  // Store info
  final String? storeId;
  final String? storeName;
  // Quantity fields
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  // Price fields
  final double? costBefore;
  final double? costAfter;
  final double? sellingPriceBefore;
  final double? sellingPriceAfter;
  final double? minPriceBefore;
  final double? minPriceAfter;
  // Product change fields
  final String? nameBefore;
  final String? nameAfter;
  final String? skuBefore;
  final String? skuAfter;
  final String? barcodeBefore;
  final String? barcodeAfter;
  final String? brandIdBefore;
  final String? brandIdAfter;
  final String? brandNameBefore;
  final String? brandNameAfter;
  final String? categoryIdBefore;
  final String? categoryIdAfter;
  final String? categoryNameBefore;
  final String? categoryNameAfter;
  final double? weightBefore;
  final double? weightAfter;
  // Reference fields
  final String? invoiceId;
  final String? invoiceNumber;
  final String? transferId;
  final String? fromStoreId;
  final String? fromStoreName;
  final String? toStoreId;
  final String? toStoreName;
  // Other fields
  final String? reason;
  final String? notes;
  final String? createdBy;
  final String? createdUser;
  final String? createdUserProfileImage;
  final String createdAt;

  InventoryHistoryItem({
    required this.logId,
    required this.eventCategory,
    required this.eventType,
    this.productId,
    this.productName,
    this.productSku,
    this.productImage,
    this.storeId,
    this.storeName,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.costBefore,
    this.costAfter,
    this.sellingPriceBefore,
    this.sellingPriceAfter,
    this.minPriceBefore,
    this.minPriceAfter,
    this.nameBefore,
    this.nameAfter,
    this.skuBefore,
    this.skuAfter,
    this.barcodeBefore,
    this.barcodeAfter,
    this.brandIdBefore,
    this.brandIdAfter,
    this.brandNameBefore,
    this.brandNameAfter,
    this.categoryIdBefore,
    this.categoryIdAfter,
    this.categoryNameBefore,
    this.categoryNameAfter,
    this.weightBefore,
    this.weightAfter,
    this.invoiceId,
    this.invoiceNumber,
    this.transferId,
    this.fromStoreId,
    this.fromStoreName,
    this.toStoreId,
    this.toStoreName,
    this.reason,
    this.notes,
    this.createdBy,
    this.createdUser,
    this.createdUserProfileImage,
    required this.createdAt,
  });

  factory InventoryHistoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryHistoryItem(
      logId: json['log_id'] as String? ?? '',
      eventCategory: json['event_category'] as String? ?? '',
      eventType: json['event_type'] as String? ?? '',
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      productSku: json['product_sku'] as String?,
      productImage: json['product_image'] as String?,
      storeId: json['store_id'] as String?,
      storeName: json['store_name'] as String?,
      quantityBefore: (json['quantity_before'] as num?)?.toInt(),
      quantityAfter: (json['quantity_after'] as num?)?.toInt(),
      quantityChange: (json['quantity_change'] as num?)?.toInt(),
      costBefore: (json['cost_before'] as num?)?.toDouble(),
      costAfter: (json['cost_after'] as num?)?.toDouble(),
      sellingPriceBefore: (json['selling_price_before'] as num?)?.toDouble(),
      sellingPriceAfter: (json['selling_price_after'] as num?)?.toDouble(),
      minPriceBefore: (json['min_price_before'] as num?)?.toDouble(),
      minPriceAfter: (json['min_price_after'] as num?)?.toDouble(),
      nameBefore: json['name_before'] as String?,
      nameAfter: json['name_after'] as String?,
      skuBefore: json['sku_before'] as String?,
      skuAfter: json['sku_after'] as String?,
      barcodeBefore: json['barcode_before'] as String?,
      barcodeAfter: json['barcode_after'] as String?,
      brandIdBefore: json['brand_id_before'] as String?,
      brandIdAfter: json['brand_id_after'] as String?,
      brandNameBefore: json['brand_name_before'] as String?,
      brandNameAfter: json['brand_name_after'] as String?,
      categoryIdBefore: json['category_id_before'] as String?,
      categoryIdAfter: json['category_id_after'] as String?,
      categoryNameBefore: json['category_name_before'] as String?,
      categoryNameAfter: json['category_name_after'] as String?,
      weightBefore: (json['weight_before'] as num?)?.toDouble(),
      weightAfter: (json['weight_after'] as num?)?.toDouble(),
      invoiceId: json['invoice_id'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
      transferId: json['transfer_id'] as String?,
      fromStoreId: json['from_store_id'] as String?,
      fromStoreName: json['from_store_name'] as String?,
      toStoreId: json['to_store_id'] as String?,
      toStoreName: json['to_store_name'] as String?,
      reason: json['reason'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdUser: json['created_user'] as String?,
      createdUserProfileImage: json['created_user_profile_image'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
