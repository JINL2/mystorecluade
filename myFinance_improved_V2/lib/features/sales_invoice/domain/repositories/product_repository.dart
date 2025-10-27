import '../entities/sales_product.dart';
import '../entities/cash_location.dart';
import '../entities/payment_currency.dart';

/// Product repository interface for sales invoice
abstract class ProductRepository {
  /// Get all products for sales
  Future<ProductListResult> getProductsForSales({
    required String companyId,
    required String storeId,
  });

  /// Get currency data for payment
  Future<CurrencyDataResult> getCurrencyData({
    required String companyId,
  });

  /// Get cash locations
  Future<List<CashLocation>> getCashLocations({
    required String companyId,
    required String storeId,
  });

  /// Get exchange rates
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
  });

  /// Create invoice from products
  Future<CreateInvoiceResult> createInvoice({
    required String companyId,
    required String storeId,
    required String userId,
    required DateTime saleDate,
    required List<InvoiceItem> items,
    required String paymentMethod,
    double? discountAmount,
    double? taxRate,
    String? notes,
  });
}

/// Product list result
class ProductListResult {
  final List<SalesProduct> products;
  final CompanyInfo company;
  final ProductSummary summary;

  const ProductListResult({
    required this.products,
    required this.company,
    required this.summary,
  });
}

/// Company info
class CompanyInfo {
  final String companyId;
  final String companyName;
  final Currency currency;

  const CompanyInfo({
    required this.companyId,
    required this.companyName,
    required this.currency,
  });
}

/// Currency
class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}

/// Product summary
class ProductSummary {
  final int totalProducts;
  final int activeProducts;
  final double totalInventoryValue;

  const ProductSummary({
    required this.totalProducts,
    required this.activeProducts,
    required this.totalInventoryValue,
  });
}

/// Currency data result
class CurrencyDataResult {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  const CurrencyDataResult({
    required this.baseCurrency,
    required this.companyCurrencies,
  });
}

/// Exchange rate data
class ExchangeRateData {
  final Map<String, dynamic> baseCurrency;
  final List<Map<String, dynamic>> exchangeRates;

  const ExchangeRateData({
    required this.baseCurrency,
    required this.exchangeRates,
  });
}

/// Invoice item for creation
class InvoiceItem {
  final String productId;
  final int quantity;
  final double? unitPrice;

  const InvoiceItem({
    required this.productId,
    required this.quantity,
    this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
    };
    if (unitPrice != null && unitPrice! > 0) {
      json['unit_price'] = unitPrice;
    }
    return json;
  }
}

/// Create invoice result
class CreateInvoiceResult {
  final bool success;
  final String? invoiceNumber;
  final double? totalAmount;
  final List<String>? warnings;
  final String? message;

  const CreateInvoiceResult({
    required this.success,
    this.invoiceNumber,
    this.totalAmount,
    this.warnings,
    this.message,
  });
}
