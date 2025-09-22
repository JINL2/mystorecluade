import 'package:flutter/material.dart';

// Main invoice model matching RPC response
class Invoice {
  final String invoiceId;
  final String invoiceNumber;
  final DateTime saleDate;
  final String status;
  final Customer? customer;
  final Store store;
  final Payment payment;
  final InvoiceAmounts amounts;
  final ItemsSummary itemsSummary;
  final CreatedBy? createdBy;
  final DateTime createdAt;

  Invoice({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.saleDate,
    required this.status,
    this.customer,
    required this.store,
    required this.payment,
    required this.amounts,
    required this.itemsSummary,
    this.createdBy,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceId: json['invoice_id']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      saleDate: DateTime.parse(json['sale_date'].toString()),
      status: json['status']?.toString() ?? 'draft',
      customer: json['customer'] != null 
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      store: Store.fromJson(json['store'] as Map<String, dynamic>),
      payment: Payment.fromJson(json['payment'] as Map<String, dynamic>),
      amounts: InvoiceAmounts.fromJson(json['amounts'] as Map<String, dynamic>),
      itemsSummary: ItemsSummary.fromJson(json['items_summary'] as Map<String, dynamic>),
      createdBy: json['created_by'] != null
          ? CreatedBy.fromJson(json['created_by'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  String get timeString {
    return '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';
  }

  String get dateString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final invoiceDay = DateTime(saleDate.year, saleDate.month, saleDate.day);
    
    if (invoiceDay == today) {
      return 'Today, ${_formatDate(saleDate)}';
    } else if (invoiceDay == today.subtract(Duration(days: 1))) {
      return 'Yesterday, ${_formatDate(saleDate)}';
    } else {
      return '${_getDayName(saleDate)}, ${_formatDate(saleDate)}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }

  bool get isCompleted => status == 'completed';
  bool get isDraft => status == 'draft';
  bool get isCancelled => status == 'cancelled';
}

class Customer {
  final String customerId;
  final String name;
  final String? phone;
  final String type;

  Customer({
    required this.customerId,
    required this.name,
    this.phone,
    required this.type,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Walk-in',
      phone: json['phone']?.toString(),
      type: json['type']?.toString() ?? 'individual',
    );
  }
}

class Store {
  final String storeId;
  final String storeName;
  final String storeCode;

  Store({
    required this.storeId,
    required this.storeName,
    required this.storeCode,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      storeCode: json['store_code']?.toString() ?? '',
    );
  }
}

class Payment {
  final String method;
  final String status;

  Payment({
    required this.method,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      method: json['method']?.toString() ?? 'cash',
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class InvoiceAmounts {
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;

  InvoiceAmounts({
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
  });

  factory InvoiceAmounts.fromJson(Map<String, dynamic> json) {
    return InvoiceAmounts(
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ItemsSummary {
  final int itemCount;
  final int totalQuantity;

  ItemsSummary({
    required this.itemCount,
    required this.totalQuantity,
  });

  factory ItemsSummary.fromJson(Map<String, dynamic> json) {
    return ItemsSummary(
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

class CreatedBy {
  final String userId;
  final String name;
  final String email;

  CreatedBy({
    required this.userId,
    required this.name,
    required this.email,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

// Response models
class InvoicePageResponse {
  final List<Invoice> invoices;
  final Pagination pagination;
  final FiltersApplied filtersApplied;
  final InvoiceSummary summary;
  final Currency currency;

  InvoicePageResponse({
    required this.invoices,
    required this.pagination,
    required this.filtersApplied,
    required this.summary,
    required this.currency,
  });

  factory InvoicePageResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return InvoicePageResponse(
      invoices: data['invoices'] != null 
          ? (data['invoices'] as List)
              .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      pagination: Pagination.fromJson((data['pagination'] as Map<String, dynamic>?) ?? {}),
      filtersApplied: FiltersApplied.fromJson((data['filters_applied'] as Map<String, dynamic>?) ?? {}),
      summary: InvoiceSummary.fromJson((data['summary'] as Map<String, dynamic>?) ?? {}),
      currency: Currency.fromJson((data['currency'] as Map<String, dynamic>?) ?? {}),
    );
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      hasNext: (json['has_next'] as bool?) ?? false,
      hasPrev: (json['has_prev'] as bool?) ?? false,
    );
  }
}

class FiltersApplied {
  final String? search;
  final DateRange dateRange;

  FiltersApplied({
    this.search,
    required this.dateRange,
  });

  factory FiltersApplied.fromJson(Map<String, dynamic> json) {
    return FiltersApplied(
      search: json['search'] as String?,
      dateRange: DateRange.fromJson(json['date_range'] as Map<String, dynamic>),
    );
  }
}

class DateRange {
  final DateTime? startDate;
  final DateTime? endDate;

  DateRange({
    this.startDate,
    this.endDate,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      startDate: json['start_date'] != null && json['start_date'] != ''
          ? DateTime.tryParse(json['start_date'].toString())
          : null,
      endDate: json['end_date'] != null && json['end_date'] != ''
          ? DateTime.tryParse(json['end_date'].toString())
          : null,
    );
  }
}

class InvoiceSummary {
  final PeriodTotal periodTotal;
  final StatusSummary byStatus;
  final PaymentSummary byPayment;

  InvoiceSummary({
    required this.periodTotal,
    required this.byStatus,
    required this.byPayment,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      periodTotal: PeriodTotal.fromJson(json['period_total'] as Map<String, dynamic>),
      byStatus: StatusSummary.fromJson(json['by_status'] as Map<String, dynamic>),
      byPayment: PaymentSummary.fromJson(json['by_payment'] as Map<String, dynamic>),
    );
  }
}

class PeriodTotal {
  final int invoiceCount;
  final double totalAmount;
  final double avgPerInvoice;

  PeriodTotal({
    required this.invoiceCount,
    required this.totalAmount,
    required this.avgPerInvoice,
  });

  factory PeriodTotal.fromJson(Map<String, dynamic> json) {
    return PeriodTotal(
      invoiceCount: (json['invoice_count'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      avgPerInvoice: (json['avg_per_invoice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class StatusSummary {
  final int completed;
  final int draft;
  final int cancelled;

  StatusSummary({
    required this.completed,
    required this.draft,
    required this.cancelled,
  });

  factory StatusSummary.fromJson(Map<String, dynamic> json) {
    return StatusSummary(
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      draft: (json['draft'] as num?)?.toInt() ?? 0,
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
    );
  }
}

class PaymentSummary {
  final int cash;
  final int card;
  final int transfer;

  PaymentSummary({
    required this.cash,
    required this.card,
    required this.transfer,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      cash: (json['cash'] as num?)?.toInt() ?? 0,
      card: (json['card'] as num?)?.toInt() ?? 0,
      transfer: (json['transfer'] as num?)?.toInt() ?? 0,
    );
  }
}

class Currency {
  final String code;
  final String name;
  final String symbol;

  Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code']?.toString() ?? 'VND',
      name: json['name']?.toString() ?? 'Vietnamese Dong',
      symbol: json['symbol']?.toString() ?? '₫',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
    };
  }
}

// Enums for filtering
enum InvoicePeriod {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  allTime;

  String get displayName {
    switch (this) {
      case InvoicePeriod.today:
        return 'Today';
      case InvoicePeriod.thisWeek:
        return 'This week';
      case InvoicePeriod.thisMonth:
        return 'This month';
      case InvoicePeriod.lastMonth:
        return 'Last month';
      case InvoicePeriod.allTime:
        return 'All time';
    }
  }

  DateRange getDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59); // End of today
    final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0); // Start of today
    
    switch (this) {
      case InvoicePeriod.today:
        return DateRange(startDate: startOfToday, endDate: today);
      case InvoicePeriod.thisWeek:
        final weekStart = startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
        return DateRange(startDate: weekStart, endDate: today);
      case InvoicePeriod.thisMonth:
        final monthStart = DateTime(now.year, now.month, 1, 0, 0, 0);
        final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59); // Last day of current month
        return DateRange(startDate: monthStart, endDate: monthEnd);
      case InvoicePeriod.lastMonth:
        final lastMonthStart = DateTime(now.year, now.month - 1, 1, 0, 0, 0);
        final lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59); // Last day of previous month
        return DateRange(startDate: lastMonthStart, endDate: lastMonthEnd);
      case InvoicePeriod.allTime:
        return DateRange(startDate: null, endDate: null);
    }
  }
}

enum InvoiceSortOption {
  date,
  invoiceId,
  user,
  products,
  amount;

  String get displayName {
    switch (this) {
      case InvoiceSortOption.date:
        return 'Date';
      case InvoiceSortOption.invoiceId:
        return 'Invoice ID';
      case InvoiceSortOption.user:
        return 'Customer';
      case InvoiceSortOption.products:
        return 'Products';
      case InvoiceSortOption.amount:
        return 'Amount';
    }
  }

  IconData get icon {
    switch (this) {
      case InvoiceSortOption.date:
        return Icons.calendar_today;
      case InvoiceSortOption.invoiceId:
        return Icons.tag;
      case InvoiceSortOption.user:
        return Icons.person;
      case InvoiceSortOption.products:
        return Icons.inventory_2;
      case InvoiceSortOption.amount:
        return Icons.attach_money;
    }
  }
}

// Sales Invoice Product Models

class SalesProductListResponse {
  final bool success;
  final SalesProductData data;

  SalesProductListResponse({
    required this.success,
    required this.data,
  });

  factory SalesProductListResponse.fromJson(Map<String, dynamic> json) {
    return SalesProductListResponse(
      success: (json['success'] as bool?) ?? false,
      data: SalesProductData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SalesProductData {
  final CompanyInfo company;
  final ProductSummary summary;
  final List<SalesProduct> products;

  SalesProductData({
    required this.company,
    required this.summary,
    required this.products,
  });

  factory SalesProductData.fromJson(Map<String, dynamic> json) {
    return SalesProductData(
      company: CompanyInfo.fromJson(json['company'] as Map<String, dynamic>? ?? {}),
      summary: ProductSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      products: json['products'] != null
          ? (json['products'] as List)
              .map((e) => SalesProduct.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class CompanyInfo {
  final Currency currency;
  final String companyId;
  final String companyName;

  CompanyInfo({
    required this.currency,
    required this.companyId,
    required this.companyName,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      currency: Currency.fromJson(json['currency'] as Map<String, dynamic>? ?? {}),
      companyId: json['company_id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
    );
  }
}

class ProductSummary {
  final StockAlerts stockAlerts;
  final int totalProducts;
  final int activeProducts;
  final Map<String, int> productsByBrand;
  final Map<String, int> productsByCategory;
  final double totalInventoryValue;

  ProductSummary({
    required this.stockAlerts,
    required this.totalProducts,
    required this.activeProducts,
    required this.productsByBrand,
    required this.productsByCategory,
    required this.totalInventoryValue,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    return ProductSummary(
      stockAlerts: StockAlerts.fromJson(json['stock_alerts'] as Map<String, dynamic>? ?? {}),
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      activeProducts: (json['active_products'] as num?)?.toInt() ?? 0,
      productsByBrand: json['products_by_brand'] != null ? Map<String, int>.from(json['products_by_brand'] as Map) : {},
      productsByCategory: json['products_by_category'] != null ? Map<String, int>.from(json['products_by_category'] as Map) : {},
      totalInventoryValue: (json['total_inventory_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class StockAlerts {
  final int lowStock;
  final int overstock;
  final int outOfStock;

  StockAlerts({
    required this.lowStock,
    required this.overstock,
    required this.outOfStock,
  });

  factory StockAlerts.fromJson(Map<String, dynamic> json) {
    return StockAlerts(
      lowStock: (json['low_stock'] as num?)?.toInt() ?? 0,
      overstock: (json['overstock'] as num?)?.toInt() ?? 0,
      outOfStock: (json['out_of_stock'] as num?)?.toInt() ?? 0,
    );
  }
}

class SalesProduct {
  final String sku;
  final String? unit;
  final String? brand;
  final ProductImages images;
  final ProductStatus status;
  final String barcode;
  final ProductPricing pricing;
  final String? category;
  final ProductAttributes attributes;
  final String productId;
  final String productName;
  final String productType;
  final List<StoreStock> storeStocks;
  final StockSettings stockSettings;
  final TotalStockSummary totalStockSummary;

  SalesProduct({
    required this.sku,
    this.unit,
    this.brand,
    required this.images,
    required this.status,
    required this.barcode,
    required this.pricing,
    this.category,
    required this.attributes,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.storeStocks,
    required this.stockSettings,
    required this.totalStockSummary,
  });

  factory SalesProduct.fromJson(Map<String, dynamic> json) {
    return SalesProduct(
      sku: json['sku']?.toString() ?? '',
      unit: json['unit']?.toString(),
      brand: json['brand'] is Map<String, dynamic> 
          ? json['brand']['brand_name']?.toString() 
          : json['brand']?.toString(),
      images: ProductImages.fromJson(json['images'] as Map<String, dynamic>? ?? {}),
      status: ProductStatus.fromJson(json['status'] as Map<String, dynamic>? ?? {}),
      barcode: json['barcode']?.toString() ?? '',
      pricing: ProductPricing.fromJson(json['pricing'] as Map<String, dynamic>? ?? {}),
      category: json['category'] is Map<String, dynamic> 
          ? json['category']['category_name']?.toString() 
          : json['category']?.toString(),
      attributes: ProductAttributes.fromJson(json['attributes'] as Map<String, dynamic>? ?? {}),
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      productType: json['product_type']?.toString() ?? 'commodity',
      storeStocks: json['store_stocks'] != null
          ? (json['store_stocks'] as List)
              .map((e) => StoreStock.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      stockSettings: StockSettings.fromJson(json['stock_settings'] as Map<String, dynamic>? ?? {}),
      totalStockSummary: TotalStockSummary.fromJson(json['total_stock_summary'] as Map<String, dynamic>? ?? {}),
    );
  }

  // Helper getter to check if product has available stock
  bool get hasAvailableStock => totalStockSummary.totalQuantityAvailable > 0;
  
  // Helper getter to get first store stock for display
  StoreStock? get firstStoreStock => storeStocks.isNotEmpty ? storeStocks.first : null;
  
  // Helper getter to get available quantity
  int get availableQuantity => totalStockSummary.totalQuantityAvailable;
  
  // Helper getter to get selling price
  double? get sellingPrice => pricing.sellingPrice;
}

class ProductImages {
  final String? thumbnail;
  final String? mainImage;
  final List<String> additionalImages;

  ProductImages({
    this.thumbnail,
    this.mainImage,
    required this.additionalImages,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
      thumbnail: json['thumbnail']?.toString(),
      mainImage: json['main_image']?.toString(),
      additionalImages: json['additional_images'] != null && json['additional_images'] is List
          ? (json['additional_images'] as List).map((item) => item.toString()).toList()
          : [],
    );
  }
}

class ProductStatus {
  final bool isActive;
  final DateTime createdAt;
  final bool isDeleted;
  final DateTime updatedAt;

  ProductStatus({
    required this.isActive,
    required this.createdAt,
    required this.isDeleted,
    required this.updatedAt,
  });

  factory ProductStatus.fromJson(Map<String, dynamic> json) {
    return ProductStatus(
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      isDeleted: (json['is_deleted'] as bool?) ?? false,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : DateTime.now(),
    );
  }
}

class ProductPricing {
  final double? minPrice;
  final double? costPrice;
  final double? profitAmount;
  final double? profitMargin;
  final double? sellingPrice;

  ProductPricing({
    this.minPrice,
    this.costPrice,
    this.profitAmount,
    this.profitMargin,
    this.sellingPrice,
  });

  factory ProductPricing.fromJson(Map<String, dynamic> json) {
    return ProductPricing(
      minPrice: (json['min_price'] as num?)?.toDouble(),
      costPrice: (json['cost_price'] as num?)?.toDouble(),
      profitAmount: (json['profit_amount'] as num?)?.toDouble(),
      profitMargin: (json['profit_margin'] as num?)?.toDouble(),
      sellingPrice: (json['selling_price'] as num?)?.toDouble(),
    );
  }
}

class ProductAttributes {
  final String? position;
  final double? weightG;

  ProductAttributes({
    this.position,
    this.weightG,
  });

  factory ProductAttributes.fromJson(Map<String, dynamic> json) {
    return ProductAttributes(
      position: json['position']?.toString(),
      weightG: (json['weight_g'] as num?)?.toDouble(),
    );
  }
}

class StoreStock {
  final Stock stock;
  final String storeId;
  final Valuation valuation;
  final String storeCode;
  final String storeName;
  final String stockStatus;

  StoreStock({
    required this.stock,
    required this.storeId,
    required this.valuation,
    required this.storeCode,
    required this.storeName,
    required this.stockStatus,
  });

  factory StoreStock.fromJson(Map<String, dynamic> json) {
    return StoreStock(
      stock: Stock.fromJson(json['stock'] as Map<String, dynamic>? ?? {}),
      storeId: json['store_id']?.toString() ?? '',
      valuation: Valuation.fromJson(json['valuation'] as Map<String, dynamic>? ?? {}),
      storeCode: json['store_code']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      stockStatus: json['stock_status']?.toString() ?? 'normal',
    );
  }
}

class Stock {
  final int quantityOnHand;
  final int quantityReserved;
  final int quantityAvailable;

  Stock({
    required this.quantityOnHand,
    required this.quantityReserved,
    required this.quantityAvailable,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      quantityOnHand: (json['quantity_on_hand'] as num?)?.toInt() ?? 0,
      quantityReserved: (json['quantity_reserved'] as num?)?.toInt() ?? 0,
      quantityAvailable: (json['quantity_available'] as num?)?.toInt() ?? 0,
    );
  }
}

class Valuation {
  final double totalValue;
  final double averageCost;

  Valuation({
    required this.totalValue,
    required this.averageCost,
  });

  factory Valuation.fromJson(Map<String, dynamic> json) {
    return Valuation(
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      averageCost: (json['average_cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class StockSettings {
  final int? maxStock;
  final int minStock;
  final int? reorderPoint;
  final int? reorderQuantity;

  StockSettings({
    this.maxStock,
    required this.minStock,
    this.reorderPoint,
    this.reorderQuantity,
  });

  factory StockSettings.fromJson(Map<String, dynamic> json) {
    return StockSettings(
      maxStock: (json['max_stock'] as num?)?.toInt(),
      minStock: (json['min_stock'] as num?)?.toInt() ?? 0,
      reorderPoint: (json['reorder_point'] as num?)?.toInt(),
      reorderQuantity: (json['reorder_quantity'] as num?)?.toInt(),
    );
  }
}

class TotalStockSummary {
  final int storeCount;
  final double totalValue;
  final int totalQuantityOnHand;
  final int totalQuantityReserved;
  final int totalQuantityAvailable;

  TotalStockSummary({
    required this.storeCount,
    required this.totalValue,
    required this.totalQuantityOnHand,
    required this.totalQuantityReserved,
    required this.totalQuantityAvailable,
  });

  factory TotalStockSummary.fromJson(Map<String, dynamic> json) {
    return TotalStockSummary(
      storeCount: (json['store_count'] as num?)?.toInt() ?? 0,
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0.0,
      totalQuantityOnHand: (json['total_quantity_on_hand'] as num?)?.toInt() ?? 0,
      totalQuantityReserved: (json['total_quantity_reserved'] as num?)?.toInt() ?? 0,
      totalQuantityAvailable: (json['total_quantity_available'] as num?)?.toInt() ?? 0,
    );
  }
}

// Currency and Payment Method Models

class CurrencyDenomination {
  final String denominationId;
  final int value;

  CurrencyDenomination({
    required this.denominationId,
    required this.value,
  });

  factory CurrencyDenomination.fromJson(Map<String, dynamic> json) {
    return CurrencyDenomination(
      denominationId: json['denomination_id']?.toString() ?? '',
      value: (json['value'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'denomination_id': denominationId,
      'value': value,
    };
  }
}

class PaymentCurrency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final String flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;
  final List<CurrencyDenomination> denominations;

  PaymentCurrency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
    this.denominations = const [],
  });

  factory PaymentCurrency.fromJson(Map<String, dynamic> json) {
    return PaymentCurrency(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      flagEmoji: json['flag_emoji']?.toString() ?? '',
      exchangeRateToBase: (json['exchange_rate_to_base'] as num?)?.toDouble(),
      rateDate: json['rate_date']?.toString(),
      denominations: json['denominations'] != null && json['denominations'] is List
          ? (json['denominations'] as List)
              .map((item) => CurrencyDenomination.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'symbol': symbol,
      'flag_emoji': flagEmoji,
      'exchange_rate_to_base': exchangeRateToBase,
      'rate_date': rateDate,
      'denominations': denominations.map((d) => d.toJson()).toList(),
    };
  }

  String get displayName => '$flagEmoji $currencyCode';
}

class BaseCurrencyResponse {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  BaseCurrencyResponse({
    required this.baseCurrency,
    required this.companyCurrencies,
  });

  factory BaseCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return BaseCurrencyResponse(
      baseCurrency: PaymentCurrency.fromJson(json['base_currency'] as Map<String, dynamic>),
      companyCurrencies: json['company_currencies'] != null && json['company_currencies'] is List
          ? (json['company_currencies'] as List)
              .map((item) => PaymentCurrency.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_currency': baseCurrency.toJson(),
      'company_currencies': companyCurrencies.map((c) => c.toJson()).toList(),
    };
  }

  // Helper method to find currency by code
  PaymentCurrency? findCurrencyByCode(String code) {
    try {
      return companyCurrencies.firstWhere(
        (currency) => currency.currencyCode == code,
      );
    } catch (e) {
      return baseCurrency.currencyCode == code ? baseCurrency : null;
    }
  }
}

// Cash Location Models
class CashLocation {
  final String id;
  final String name;
  final String type; // 'bank' or 'cash'
  final String storeId;
  final bool isCompanyWide;
  final String currencyCode;
  final String? bankAccount;
  final String? bankName;

  CashLocation({
    required this.id,
    required this.name,
    required this.type,
    required this.storeId,
    required this.isCompanyWide,
    required this.currencyCode,
    this.bankAccount,
    this.bankName,
  });

  factory CashLocation.fromJson(Map<String, dynamic> json) {
    return CashLocation(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'cash',
      storeId: json['store_id']?.toString() ?? '',
      isCompanyWide: (json['is_company_wide'] as bool?) ?? false,
      currencyCode: json['currency_code']?.toString() ?? 'VND',
      bankAccount: json['bank_account']?.toString(),
      bankName: json['bank_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'store_id': storeId,
      'is_company_wide': isCompanyWide,
      'currency_code': currencyCode,
      'bank_account': bankAccount,
      'bank_name': bankName,
    };
  }

  // Helper getters for UI display
  String get displayName {
    if (type == 'bank' && bankName != null) {
      return '$name - $bankName';
    }
    return name;
  }

  String get displayType {
    return type == 'bank' ? 'Bank' : 'Cash';
  }

  bool get isBank => type == 'bank';
  bool get isCash => type == 'cash';
}

// Payment Method Models
class PaymentMethod {
  final String paymentType; // 'cash', 'bank', 'transfer'
  final CashLocation? cashLocation;
  final Map<String, double> currencyAmounts; // currency_code -> amount
  final double totalAmount;

  PaymentMethod({
    required this.paymentType,
    this.cashLocation,
    this.currencyAmounts = const {},
    this.totalAmount = 0.0,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      paymentType: json['payment_type']?.toString() ?? '',
      cashLocation: json['cash_location'] != null 
          ? CashLocation.fromJson(json['cash_location'] as Map<String, dynamic>)
          : null,
      currencyAmounts: json['currency_amounts'] is Map<String, dynamic>
          ? Map<String, double>.from(
              (json['currency_amounts'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(key, (value as num?)?.toDouble() ?? 0.0)
              )
            )
          : {},
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_type': paymentType,
      'cash_location': cashLocation?.toJson(),
      'currency_amounts': currencyAmounts,
      'total_amount': totalAmount,
    };
  }
}