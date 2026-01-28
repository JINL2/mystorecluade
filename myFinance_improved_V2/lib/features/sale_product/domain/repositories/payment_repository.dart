import '../entities/cash_location.dart';
import '../value_objects/invoice_types.dart';

// Re-export value objects for backward compatibility
export '../value_objects/invoice_types.dart';

/// Payment repository interface for sale product
abstract class PaymentRepository {
  /// Get currency data for payment
  Future<CurrencyDataResult> getCurrencyData({
    required String companyId,
  });

  /// Get cash locations
  Future<List<CashLocation>> getCashLocations({
    required String companyId,
    required String storeId,
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
