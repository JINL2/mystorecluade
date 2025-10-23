import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/stock_flow.dart';
import '../../domain/entities/vault_real_entry.dart';
import '../../domain/repositories/cash_location_repository.dart';
import '../../domain/value_objects/bank_real_params.dart';
import '../../domain/value_objects/cash_journal_params.dart';
import '../../domain/value_objects/cash_location_query_params.dart';
import '../../domain/value_objects/cash_real_params.dart';
import '../../domain/value_objects/stock_flow_params.dart';
import '../../domain/value_objects/vault_real_params.dart';

// Export parameter classes for use in pages
export '../../domain/value_objects/bank_real_params.dart';
export '../../domain/value_objects/cash_location_query_params.dart';
export '../../domain/value_objects/cash_real_params.dart';
export '../../domain/value_objects/cash_journal_params.dart';
export '../../domain/value_objects/vault_real_params.dart';
export '../../domain/value_objects/stock_flow_params.dart';

// Export domain entities for use in pages (hide duplicates)
export '../../domain/entities/bank_real_entry.dart';
export '../../domain/entities/cash_location.dart';
export '../../domain/entities/cash_real_entry.dart' hide CurrencySummary, Denomination;
export '../../domain/entities/journal_entry.dart';
export '../../domain/entities/stock_flow.dart';
export '../../domain/entities/vault_real_entry.dart' hide CurrencySummary, Denomination;

// Repository Provider is now imported from data layer (repository_providers.dart)
// This ensures presentation layer only depends on domain interfaces, not data implementations
// Re-export the repository provider for use in pages
export '../../data/repositories/repository_providers.dart' show cashLocationRepositoryProvider;

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

  /// Create foreign currency translation journal entry
  Future<Map<String, dynamic>> createForeignCurrencyTranslation({
    required double differenceAmount,
    required String companyId,
    required String userId,
    required String locationName,
    required String cashLocationId,
    String? storeId,
  }) async {
    // Constants for account IDs
    const cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
    const foreignCurrencyAccountId = '80b311db-f548-46e3-9854-67c5ff6766e8';

    // Get current date
    final now = DateTime.now().toLocal();
    final entryDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    // Calculate absolute amount
    final absAmount = differenceAmount.abs();
    final isPositiveDifference = differenceAmount > 0;

    // Create journal lines
    final lines = [
      {
        'account_id': cashAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': foreignCurrencyAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];

    return _repository.insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: companyId,
      createdBy: userId,
      description: 'Foreign Currency Translation - $locationName',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: storeId,
    );
  }

  /// Create error adjustment journal entry
  Future<Map<String, dynamic>> createErrorJournal({
    required double differenceAmount,
    required String companyId,
    required String userId,
    required String locationName,
    required String cashLocationId,
    String? storeId,
  }) async {
    // Constants for account IDs
    const cashAccountId = 'd4a7a16e-45a1-47fe-992b-ff807c8673f0';
    const errorAccountId = 'a45fac5d-010c-4b1b-92e9-ddcf8f3222bf';

    // Get current date
    final now = DateTime.now().toLocal();
    final entryDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    // Calculate absolute amount
    final absAmount = differenceAmount.abs();
    final isPositiveDifference = differenceAmount > 0;

    // Create journal lines
    final lines = [
      {
        'account_id': cashAccountId,
        'description': 'Make error',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': cashLocationId,
        },
      },
      {
        'account_id': errorAccountId,
        'description': 'Make error',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];

    return _repository.insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: companyId,
      createdBy: userId,
      description: 'Make Error - $locationName',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: storeId,
    );
  }
}


// Stock Flow Service Provider (for backward compatibility with old code)
final stockFlowServiceProvider = Provider<StockFlowService>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return StockFlowService(repository);
});

// Stock Flow Provider
final stockFlowProvider = FutureProvider.family<StockFlowResponse, StockFlowParams>((ref, params) async {
  final repository = ref.read(cashLocationRepositoryProvider);
  return repository.getLocationStockFlow(
    companyId: params.companyId,
    storeId: params.storeId,
    cashLocationId: params.cashLocationId,
    offset: params.offset,
    limit: params.limit,
  );
});

// Stock Flow Service (wrapper for repository)
class StockFlowService {
  final CashLocationRepository _repository;

  StockFlowService(this._repository);

  Future<StockFlowResponse> getLocationStockFlow(StockFlowParams params) async {
    return _repository.getLocationStockFlow(
      companyId: params.companyId,
      storeId: params.storeId,
      cashLocationId: params.cashLocationId,
      offset: params.offset,
      limit: params.limit,
    );
  }
}

// Currency Types Provider (placeholder - returns empty list for now)
// This will need proper implementation when currency RPC is available
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  // TODO: Implement actual currency fetching from repository
  // For now, return empty list to maintain compatibility
  return [];
});

// ============================================================================
// Display Models (Presentation Layer Concerns)
// ============================================================================

/// Display model for Bank Real UI
class BankRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final String currencySymbol;
  final BankRealEntry realEntry;

  BankRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.currencySymbol,
    required this.realEntry,
  });
}

/// Display model for Cash Real UI
class CashRealDisplay {
  final String date;
  final String time;
  final String title;
  final String locationName;
  final double amount;
  final CashRealEntry realEntry;

  CashRealDisplay({
    required this.date,
    required this.time,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.realEntry,
  });
}

/// Display model for Vault Real UI
class VaultRealDisplay {
  final String date;
  final String title;
  final String locationName;
  final double amount;
  final String currencySymbol;
  final VaultRealEntry realEntry;

  VaultRealDisplay({
    required this.date,
    required this.title,
    required this.locationName,
    required this.amount,
    required this.currencySymbol,
    required this.realEntry,
  });
}

