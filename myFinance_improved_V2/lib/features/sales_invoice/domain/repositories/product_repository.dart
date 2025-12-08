import '../entities/cash_location.dart';
import '../entities/exchange_rate_data.dart';
import '../entities/payment_currency.dart';

/// Product repository interface for sales invoice
abstract class ProductRepository {
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
    String? cashLocationId,
    String? customerId,
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

// ExchangeRateData moved to ../entities/exchange_rate_data.dart
// Import it from there if needed

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
