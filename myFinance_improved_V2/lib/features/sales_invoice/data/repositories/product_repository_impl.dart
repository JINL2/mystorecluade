import '../../domain/entities/cash_location.dart';
import '../../domain/entities/payment_currency.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/payment_currency_model.dart';

/// Product repository implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<ProductListResult> getProductsForSales({
    required String companyId,
    required String storeId,
  }) async {
    final response = await _remoteDataSource.getProductsForSales(
      companyId: companyId,
      storeId: storeId,
    );

    return response.toResult();
  }

  @override
  Future<CurrencyDataResult> getCurrencyData({
    required String companyId,
  }) async {
    final response = await _remoteDataSource.getCurrencyData(
      companyId: companyId,
    );

    final baseCurrency = PaymentCurrencyModel.fromJson(
      response['base_currency'] as Map<String, dynamic>,
    ).toEntity();

    final companyCurrencies = (response['company_currencies'] as List?)
            ?.map((e) => PaymentCurrencyModel.fromJson(e as Map<String, dynamic>).toEntity())
            .toList() ??
        [];

    return CurrencyDataResult(
      baseCurrency: baseCurrency,
      companyCurrencies: companyCurrencies,
    );
  }

  @override
  Future<List<CashLocation>> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    final response = await _remoteDataSource.getCashLocations(
      companyId: companyId,
      storeId: storeId,
    );

    return response.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
  }) async {
    final response = await _remoteDataSource.getExchangeRates(
      companyId: companyId,
    );

    if (response == null) return null;

    return ExchangeRateData(
      baseCurrency: response['base_currency'] as Map<String, dynamic>,
      exchangeRates: (response['exchange_rates'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
    );
  }

  @override
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
  }) async {
    final response = await _remoteDataSource.createInvoice(
      companyId: companyId,
      storeId: storeId,
      userId: userId,
      saleDate: saleDate,
      items: items,
      paymentMethod: paymentMethod,
      discountAmount: discountAmount,
      taxRate: taxRate,
      notes: notes,
    );

    return CreateInvoiceResult(
      success: response['success'] as bool? ?? false,
      invoiceNumber: response['invoice_number']?.toString(),
      totalAmount: (response['total_amount'] as num?)?.toDouble(),
      warnings: response['warnings'] != null
          ? (response['warnings'] as List).map((e) => e.toString()).toList()
          : null,
      message: response['message']?.toString(),
    );
  }
}
