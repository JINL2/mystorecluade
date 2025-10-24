import '../../domain/repositories/product_repository.dart';
import 'sales_product_model.dart';

/// Product list response model
class ProductListResponseModel {
  final Map<String, dynamic> json;

  ProductListResponseModel(this.json);

  /// Create from JSON
  factory ProductListResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductListResponseModel(json);
  }

  /// Convert to domain result
  ProductListResult toResult() {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final company = data['company'] as Map<String, dynamic>? ?? {};
    final summary = data['summary'] as Map<String, dynamic>? ?? {};
    final products = data['products'] as List? ?? [];

    return ProductListResult(
      products: products
          .map((e) => SalesProductModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList(),
      company: _companyFromJson(company),
      summary: _summaryFromJson(summary),
    );
  }

  CompanyInfo _companyFromJson(Map<String, dynamic> json) {
    final currency = json['currency'] as Map<String, dynamic>? ?? {};

    return CompanyInfo(
      companyId: json['company_id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      currency: Currency(
        code: currency['code']?.toString() ?? 'VND',
        name: currency['name']?.toString() ?? 'Vietnamese Dong',
        symbol: currency['symbol']?.toString() ?? '₫',
      ),
    );
  }

  ProductSummary _summaryFromJson(Map<String, dynamic> json) {
    return ProductSummary(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      activeProducts: (json['active_products'] as num?)?.toInt() ?? 0,
      totalInventoryValue: (json['total_inventory_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
