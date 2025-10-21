import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/cash_location_data_source.dart';
import '../../data/models/bank_real_model.dart';
import '../../data/models/cash_location_model.dart';
import '../../data/models/cash_real_model.dart';
import '../../data/models/vault_real_model.dart';
import '../../data/repositories/cash_location_repository_impl.dart';
import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/entities/vault_real_entry.dart';
import '../../domain/repositories/cash_location_repository.dart';

// Export parameter classes for use in pages
export '../../data/models/bank_real_model.dart' show BankRealParams;
export '../../data/models/cash_location_model.dart' show CashLocationQueryParams;
export '../../data/models/cash_real_model.dart' show CashRealParams;
export '../../data/models/vault_real_model.dart' show VaultRealParams;

// Note: StockFlowParams is defined in this file and exported automatically

// Export domain entities for use in pages (hide duplicates)
export '../../domain/entities/bank_real_entry.dart';
export '../../domain/entities/cash_location.dart';
export '../../domain/entities/cash_real_entry.dart' hide CurrencySummary, Denomination;
export '../../domain/entities/stock_flow.dart';
export '../../domain/entities/vault_real_entry.dart' hide CurrencySummary, Denomination;

// Data Source Provider
final cashLocationDataSourceProvider = Provider<CashLocationDataSource>((ref) {
  return CashLocationDataSource();
});

// Repository Provider
final cashLocationRepositoryProvider = Provider<CashLocationRepository>((ref) {
  final dataSource = ref.read(cashLocationDataSourceProvider);
  return CashLocationRepositoryImpl(dataSource: dataSource);
});

// Cash Location Providers
final allCashLocationsProvider = FutureProvider.family<List<CashLocation>, CashLocationQueryParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getAllCashLocations(
    companyId: params.companyId,
    storeId: params.storeId,
  );
});

// Cash Real Provider
final cashRealProvider = FutureProvider.family<List<CashRealEntry>, CashRealParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getCashReal(
    companyId: params.companyId,
    storeId: params.storeId,
    locationType: params.locationType,
    offset: params.offset,
    limit: params.limit,
  );
});

// Bank Real Provider
final bankRealProvider = FutureProvider.family<List<BankRealEntry>, BankRealParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getBankReal(
    companyId: params.companyId,
    storeId: params.storeId,
    offset: params.offset,
    limit: params.limit,
  );
});

// Vault Real Provider
final vaultRealProvider = FutureProvider.family<List<VaultRealEntry>, VaultRealParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getVaultReal(
    companyId: params.companyId,
    storeId: params.storeId,
    offset: params.offset,
    limit: params.limit,
  );
});

// Cash Journal Service Provider (for backward compatibility)
final cashJournalServiceProvider = Provider<CashJournalService>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return CashJournalService(repository);
});

// Cash Journal Provider
final cashJournalProvider = FutureProvider.family<List<JournalEntry>, CashJournalParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getCashJournal(
    companyId: params.companyId,
    storeId: params.storeId,
    locationType: params.locationType,
    offset: params.offset,
    limit: params.limit,
  );
});

// Cash Journal Service (wrapper for repository)
class CashJournalService {
  final CashLocationRepository _repository;

  CashJournalService(this._repository);

  Future<List<JournalEntry>> getCashJournal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    return _repository.getCashJournal(
      companyId: companyId,
      storeId: storeId,
      locationType: locationType,
      offset: offset,
      limit: limit,
    );
  }
}

// Parameters for the provider
class CashJournalParams {
  final String companyId;
  final String storeId;
  final String locationType;
  final int offset;
  final int limit;

  CashJournalParams({
    required this.companyId,
    required this.storeId,
    required this.locationType,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashJournalParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationType == other.locationType &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationType.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}

// Stock Flow Service Provider (for backward compatibility with old code)
final stockFlowServiceProvider = Provider<StockFlowService>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return StockFlowService(repository);
});

// Stock Flow Provider (placeholder - returns empty lists for now)
// This will need proper implementation when stock flow RPC is available
final stockFlowProvider = FutureProvider.family<StockFlowResponse, StockFlowParams>((ref, params) async {
  // TODO: Implement actual stock flow fetching from repository
  // For now, return empty response to maintain compatibility
  return StockFlowResponse(
    journalFlows: [],
    actualFlows: [],
    locationSummary: null,
  );
});

// Stock Flow Service (wrapper for repository)
class StockFlowService {
  final CashLocationRepository _repository;

  StockFlowService(this._repository);

  Future<StockFlowResponse> getStockFlow({
    required String companyId,
    required String storeId,
    required String locationId,
    int offset = 0,
    int limit = 20,
  }) async {
    // TODO: Implement actual stock flow fetching
    // For now, return empty response to maintain compatibility
    return StockFlowResponse(
      journalFlows: [],
      actualFlows: [],
      locationSummary: null,
    );
  }
}

// Stock Flow Response
class StockFlowResponse {
  final List<JournalFlow> journalFlows;
  final List<ActualFlow> actualFlows;
  final LocationSummary? locationSummary;

  StockFlowResponse({
    required this.journalFlows,
    required this.actualFlows,
    this.locationSummary,
  });
}

// Parameters for Stock Flow Provider
class StockFlowParams {
  final String companyId;
  final String storeId;
  final String locationId;
  final int offset;
  final int limit;

  StockFlowParams({
    required this.companyId,
    required this.storeId,
    required this.locationId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockFlowParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          locationId == other.locationId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      locationId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}

// Currency Types Provider (placeholder - returns empty list for now)
// This will need proper implementation when currency RPC is available
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  // TODO: Implement actual currency fetching from repository
  // For now, return empty list to maintain compatibility
  return [];
});

