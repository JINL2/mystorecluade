import '../../domain/entities/exchange_rate_data.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../datasources/exchange_rate_datasource.dart';
import '../models/exchange_rate_data_model.dart';

/// Implementation of ExchangeRateRepository
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final ExchangeRateDataSource _dataSource;

  ExchangeRateRepositoryImpl(this._dataSource);

  @override
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
    String? storeId,
  }) async {
    final response = await _dataSource.getExchangeRates(
      companyId: companyId,
      storeId: storeId,
    );

    if (response.error != null) {
      return null;
    }

    return ExchangeRateDataModel(response.toJson()).toEntity();
  }
}
