// lib/features/cash_ending/data/repositories/currency_repository_impl.dart

import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';
import '../models/freezed/currency_dto.dart';
import '../models/freezed/denomination_dto.dart';
import 'base_repository.dart';

/// Repository Implementation for Currencies (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping using BaseRepository.
class CurrencyRepositoryImpl extends BaseRepository
    implements CurrencyRepository {
  final CurrencyRemoteDataSource _remoteDataSource;

  CurrencyRepositoryImpl({
    CurrencyRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CurrencyRemoteDataSource();

  @override
  Future<List<Currency>> getCompanyCurrenciesWithExchangeRates({
    required String companyId,
    DateTime? rateDate,
  }) async {
    return executeWithErrorHandling(
      () async {
        if (companyId.isEmpty) {
          return [];
        }

        // RPC call (1 network request for all data)
        final data = await _remoteDataSource.getCompanyCurrenciesWithExchangeRates(
          companyId: companyId,
          rateDate: rateDate,
        );

        // JSON → DTO → Entity conversion
        // Use fromRpcJson to inject currency_id into denominations
        return data
            .map((json) => CurrencyDto.fromRpcJson(json).toEntity())
            .toList();
      },
      operationName: 'getCompanyCurrenciesWithExchangeRates',
    );
  }

  @override
  Future<List<Denomination>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  }) async {
    return executeWithErrorHandling(
      () async {
        if (companyId.isEmpty || currencyId.isEmpty) {
          return [];
        }

        // Call remote datasource
        final data = await _remoteDataSource.getDenominationsByCurrency(
          companyId: companyId,
          currencyId: currencyId,
        );

        // Convert JSON to DTOs then to entities
        return data
            .map((json) => DenominationDto.fromJson(json).toEntity())
            .toList();
      },
      operationName: 'getDenominationsByCurrency',
    );
  }
}
