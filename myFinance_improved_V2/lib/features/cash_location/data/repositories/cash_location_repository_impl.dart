// Data Layer - Repository Implementation
// This implements the interface defined in domain layer

import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/vault_real_entry.dart';
import '../../domain/repositories/cash_location_repository.dart';
import '../datasources/cash_location_data_source.dart';

/// Implementation of CashLocationRepository
/// Coordinates between domain and data layers
class CashLocationRepositoryImpl implements CashLocationRepository {
  final CashLocationDataSource dataSource;

  CashLocationRepositoryImpl({required this.dataSource});

  @override
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    // Get models from data source
    final models = await dataSource.getAllCashLocations(
      companyId: companyId,
      storeId: storeId,
    );

    // Convert models to domain entities
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CashRealEntry>> getCashReal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    final models = await dataSource.getCashReal(
      companyId: companyId,
      storeId: storeId,
      locationType: locationType,
      offset: offset,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<BankRealEntry>> getBankReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    final models = await dataSource.getBankReal(
      companyId: companyId,
      storeId: storeId,
      offset: offset,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<VaultRealEntry>> getVaultReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    final models = await dataSource.getVaultReal(
      companyId: companyId,
      storeId: storeId,
      offset: offset,
      limit: limit,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<JournalEntry>> getCashJournal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    final models = await dataSource.getCashJournal(
      companyId: companyId,
      storeId: storeId,
      locationType: locationType,
      offset: offset,
      limit: limit,
    );

    // Models already are entities in this case
    return models;
  }
}
