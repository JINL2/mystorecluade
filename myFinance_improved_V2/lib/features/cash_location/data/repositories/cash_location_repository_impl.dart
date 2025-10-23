// Data Layer - Repository Implementation
// This implements the interface defined in domain layer

import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/cash_location_detail.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/vault_real_entry.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/repositories/cash_location_repository.dart';
import '../datasources/cash_location_data_source.dart';

/// Implementation of CashLocationRepository
/// Coordinates between domain and data layers
class CashLocationRepositoryImpl implements CashLocationRepository {
  final CashLocationDataSource dataSource;

  CashLocationRepositoryImpl({required this.dataSource});

  /// Factory method to create DataSource instance
  /// This hides the DataSource implementation from presentation layer
  static CashLocationDataSource createDataSource() {
    return CashLocationDataSource();
  }

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
  Future<CashLocationDetail?> getCashLocationById({
    required String locationId,
  }) async {
    final model = await dataSource.getCashLocationById(
      locationId: locationId,
    );
    return model?.toEntity();
  }

  @override
  Future<CashLocationDetail?> getCashLocationByName({
    required String locationName,
    required String locationType,
    required String companyId,
    required String storeId,
  }) async {
    final model = await dataSource.getCashLocationByName(
      locationName: locationName,
      locationType: locationType,
      companyId: companyId,
      storeId: storeId,
    );
    return model?.toEntity();
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

    // Convert models to domain entities
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<StockFlowResponse> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) async {
    // Get response from data source
    final response = await dataSource.getLocationStockFlow(
      companyId: companyId,
      storeId: storeId,
      cashLocationId: cashLocationId,
      offset: offset,
      limit: limit,
    );

    // Response is already a domain entity (StockFlowResponse)
    return response;
  }

  @override
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  }) async {
    return dataSource.insertJournalWithEverything(
      baseAmount: baseAmount,
      companyId: companyId,
      createdBy: createdBy,
      description: description,
      entryDate: entryDate,
      lines: lines,
      counterpartyId: counterpartyId,
      ifCashLocationId: ifCashLocationId,
      storeId: storeId,
    );
  }

  @override
  Future<void> updateCashLocation({
    required String locationId,
    required String name,
    String? note,
    String? description,
    String? bankName,
    String? accountNumber,
  }) async {
    await dataSource.updateCashLocation(
      locationId: locationId,
      name: name,
      note: note,
      description: description,
      bankName: bankName,
      accountNumber: accountNumber,
    );
  }

  @override
  Future<void> deleteCashLocation(String locationId) async {
    await dataSource.deleteCashLocation(locationId);
  }

  @override
  Future<void> updateMainAccountStatus({
    required String locationId,
    required bool isMain,
    required String companyId,
    required String storeId,
    required String locationType,
  }) async {
    await dataSource.updateMainAccountStatus(
      locationId: locationId,
      isMain: isMain,
      companyId: companyId,
      storeId: storeId,
      locationType: locationType,
    );
  }
}
