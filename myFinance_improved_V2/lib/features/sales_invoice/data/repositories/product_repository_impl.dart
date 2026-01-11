import '../../domain/entities/cash_location.dart';
import '../../domain/entities/exchange_rate_data.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/exchange_rate_data_model.dart';
import '../models/payment_currency_model.dart';

/// Product repository implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl(this._remoteDataSource);

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

    return ExchangeRateDataModel(response).toEntity();
  }

}
