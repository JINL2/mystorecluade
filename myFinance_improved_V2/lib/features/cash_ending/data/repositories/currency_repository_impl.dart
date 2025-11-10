// lib/features/cash_ending/data/repositories/currency_repository_impl.dart

import '../../../../core/data/base_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';

/// Repository Implementation for Currencies (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
///
/// ✅ Refactored with:
/// - Freezed Entity (no Model needed)
/// - BaseRepository (unified error handling)
/// - 30% less boilerplate
class CurrencyRepositoryImpl extends BaseRepository implements CurrencyRepository {
  final CurrencyRemoteDataSource _remoteDataSource;

  CurrencyRepositoryImpl({
    CurrencyRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CurrencyRemoteDataSource();

  @override
  Future<Result<List<Currency>, Failure>> getCompanyCurrencies(String companyId) {
    return executeFetchWithResult(
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

        // Step 6: Group denominations by currency (using Entity directly)
        final Map<String, List<Denomination>> denominationsByCurrency = {};
        for (var denomJson in allDenominations) {
          final currencyId = denomJson['currency_id']?.toString() ?? '';
          if (currencyId.isNotEmpty) {
            denominationsByCurrency.putIfAbsent(currencyId, () => []);
            denominationsByCurrency[currencyId]!
                .add(Denomination.fromJson(denomJson));
          }
        }

        // Step 7: Combine into currency entities (maintaining created_at order from companyCurrencies)
        final List<Currency> entities = [];
        for (var companyCurrency in companyCurrencies) {
          final currencyId = companyCurrency['currency_id']?.toString() ?? '';
          final currencyTypeJson = currencyTypeMap[currencyId];

          if (currencyTypeJson != null) {
            // Get denominations for this currency
            final denoms = denominationsByCurrency[currencyId] ?? [];

            // Build currency entity directly (Freezed handles it)
            final currency = Currency(
              currencyId: currencyId,
              currencyCode: currencyTypeJson['currency_code']?.toString() ?? '',
              currencyName: currencyTypeJson['currency_name']?.toString() ?? '',
              symbol: currencyTypeJson['symbol']?.toString() ?? '',
              denominations: denoms,
            );

            entities.add(currency);
          }
        }

        return entities;
      },
      operationName: 'company currencies',
    );
  }

  @override
  Future<Result<List<Denomination>, Failure>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  }) {
    return executeFetchWithResult(
      () async {
        if (companyId.isEmpty || currencyId.isEmpty) {
          return [];
        }

        // Call remote datasource
        final data = await _remoteDataSource.getDenominationsByCurrency(
          companyId: companyId,
          currencyId: currencyId,
        );

        // Convert JSON directly to entities (Freezed handles it)
        return data.map((json) => Denomination.fromJson(json)).toList();
      },
      operationName: 'denominations for currency: $currencyId',
    );
  }

  @override
  Future<Result<List<Currency>, Failure>> getAllCurrencyTypes() {
    return executeFetchWithResult(
      () async {
        // Call remote datasource
        final data = await _remoteDataSource.getCurrencyTypes();

        // Convert JSON directly to entities (Freezed handles it)
        return data.map((json) => Currency.fromJson(json)).toList();
      },
      operationName: 'currency types',
    );
  }
}
