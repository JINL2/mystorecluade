// lib/features/cash_ending/data/repositories/currency_repository_impl.dart

import '../../domain/entities/currency.dart';
import '../../domain/entities/denomination.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../domain/exceptions/cash_ending_exception.dart';
import '../datasources/currency_remote_datasource.dart';
import '../models/currency_model.dart';
import '../models/denomination_model.dart';

/// Repository Implementation for Currencies (Data Layer)
///
/// Implements the domain repository interface.
/// Coordinates between datasource (Supabase) and domain entities.
/// Handles data transformation and error mapping.
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource _remoteDataSource;

  CurrencyRepositoryImpl({
    CurrencyRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? CurrencyRemoteDataSource();

  @override
  Future<List<Currency>> getCompanyCurrencies(String companyId) async {
    try {
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
      final Map<String, List<DenominationModel>> denominationsByCurrency = {};
      for (var denomJson in allDenominations) {
        final currencyId = denomJson['currency_id']?.toString() ?? '';
        if (currencyId.isNotEmpty) {
          denominationsByCurrency.putIfAbsent(currencyId, () => []);
          denominationsByCurrency[currencyId]!
              .add(DenominationModel.fromJson(denomJson));
        }
      }

      // Step 7: Combine into currency entities (maintaining created_at order from companyCurrencies)
      final List<Currency> entities = [];
      for (var companyCurrency in companyCurrencies) {
        final currencyId = companyCurrency['currency_id']?.toString() ?? '';
        final currencyTypeJson = currencyTypeMap[currencyId];

        if (currencyTypeJson != null) {
          // Get denominations for this currency
          final denomModels = denominationsByCurrency[currencyId] ?? [];

          // Build currency model with denominations
          final currencyModel = CurrencyModel(
            currencyId: currencyId,
            currencyCode: currencyTypeJson['currency_code']?.toString() ?? '',
            currencyName: currencyTypeJson['currency_name']?.toString() ?? '',
            symbol: currencyTypeJson['symbol']?.toString() ?? '',
            denominations: denomModels,
          );

          entities.add(currencyModel.toEntity());
        }
      }

      return entities;
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch company currencies',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Denomination>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  }) async {
    try {
      if (companyId.isEmpty || currencyId.isEmpty) {
        return [];
      }

      // Call remote datasource
      final data = await _remoteDataSource.getDenominationsByCurrency(
        companyId: companyId,
        currencyId: currencyId,
      );

      // Convert JSON to models then to entities
      return data.map((json) => DenominationModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch denominations for currency: $currencyId',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Currency>> getAllCurrencyTypes() async {
    try {
      // Call remote datasource
      final data = await _remoteDataSource.getCurrencyTypes();

      // Convert JSON to models then to entities
      return data.map((json) => CurrencyModel.fromJson(json).toEntity()).toList();
    } catch (e) {
      throw FetchFailedException(
        'Failed to fetch currency types',
        originalError: e,
      );
    }
  }
}
