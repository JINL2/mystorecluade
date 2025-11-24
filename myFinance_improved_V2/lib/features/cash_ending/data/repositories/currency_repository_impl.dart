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
  @Deprecated('Use getCompanyCurrenciesWithExchangeRates instead')
  Future<List<Currency>> getCompanyCurrencies(String companyId) async {
    return executeWithErrorHandling(
      () async {
        if (companyId.isEmpty) {
          return [];
        }

        // Step 1: Get company currency associations
        final companyCurrencies =
            await _remoteDataSource.getCompanyCurrencies(companyId);

        if (companyCurrencies.isEmpty) {
          return [];
        }

        // Step 2: Extract currency IDs (preserving order from companyCurrencies)
        final currencyIds = companyCurrencies
            .map((item) => item['currency_id']?.toString() ?? '')
            .where((id) => id.isNotEmpty)
            .toList();

        // Step 3: Get currency type details
        final currencyTypes =
            await _remoteDataSource.getCurrencyTypes(currencyIds: currencyIds);

        // Step 4: Create a map of currency_id to currency type for quick lookup
        final Map<String, Map<String, dynamic>> currencyTypeMap = {};
        for (var currencyType in currencyTypes) {
          final currencyId = currencyType['currency_id']?.toString() ?? '';
          if (currencyId.isNotEmpty) {
            currencyTypeMap[currencyId] = currencyType;
          }
        }

        // Step 5: Get all denominations for this company
        final allDenominations =
            await _remoteDataSource.getAllDenominations(companyId);

        // Step 6: Group denominations by currency
        final Map<String, List<DenominationDto>> denominationsByCurrency = {};
        for (var denomJson in allDenominations) {
          final currencyId = denomJson['currency_id']?.toString() ?? '';
          if (currencyId.isNotEmpty) {
            denominationsByCurrency.putIfAbsent(currencyId, () => []);
            denominationsByCurrency[currencyId]!
                .add(DenominationDto.fromJson(denomJson));
          }
        }

        // Step 7: Combine into currency entities (maintaining created_at order from companyCurrencies)
        final List<Currency> entities = [];
        for (var companyCurrency in companyCurrencies) {
          final currencyId = companyCurrency['currency_id']?.toString() ?? '';
          final currencyTypeJson = currencyTypeMap[currencyId];

          if (currencyTypeJson != null) {
            // Get denominations for this currency
            final denomDtos = denominationsByCurrency[currencyId] ?? [];

            // Build currency DTO with denominations
            final currencyDto = CurrencyDto.fromJson(currencyTypeJson).copyWith(
              denominations: denomDtos,
            );

            entities.add(currencyDto.toEntity());
          }
        }

        return entities;
      },
      operationName: 'getCompanyCurrencies',
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

  @override
  Future<List<Currency>> getAllCurrencyTypes() async {
    return executeWithErrorHandling(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getCurrencyTypes();

        // Convert JSON to DTOs then to entities
        return data
            .map((json) => CurrencyDto.fromJson(json).toEntity())
            .toList();
      },
      operationName: 'getAllCurrencyTypes',
    );
  }
}
