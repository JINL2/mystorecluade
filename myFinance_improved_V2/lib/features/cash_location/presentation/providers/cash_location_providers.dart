// Presentation Layer Providers
// This file contains only UI-related providers and re-exports necessary types
// All business logic is delegated to Domain UseCases
// Following Clean Architecture: Presentation depends only on Domain

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import DI providers (centralized dependency injection)
import '../../di/cash_location_providers.dart';

// Import domain entities for internal use
import '../../domain/entities/bank_real_entry.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/cash_real_entry.dart';
import '../../domain/entities/vault_real_entry.dart';

// Import domain value objects for internal use
import '../../domain/value_objects/bank_real_params.dart';
import '../../domain/value_objects/cash_journal_params.dart';
import '../../domain/value_objects/cash_location_query_params.dart';
import '../../domain/value_objects/cash_real_params.dart';
import '../../domain/value_objects/stock_flow_params.dart';
import '../../domain/value_objects/vault_real_params.dart';

// Import other domain entities used in providers
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/currency_type.dart';
import '../../domain/entities/stock_flow.dart';

// Export domain entities for use in presentation
export '../../domain/entities/bank_real_entry.dart';
export '../../domain/entities/cash_location.dart';
export '../../domain/entities/cash_real_entry.dart' hide CurrencySummary, Denomination;
export '../../domain/entities/currency_type.dart';
export '../../domain/entities/journal_entry.dart';
export '../../domain/entities/stock_flow.dart';
export '../../domain/entities/vault_real_entry.dart' hide CurrencySummary, Denomination;

// Export domain value objects (params)
export '../../domain/value_objects/bank_real_params.dart';
export '../../domain/value_objects/cash_journal_params.dart';
export '../../domain/value_objects/cash_location_query_params.dart';
export '../../domain/value_objects/cash_real_params.dart';
export '../../domain/value_objects/stock_flow_params.dart';
export '../../domain/value_objects/vault_real_params.dart';

// Export use case providers for presentation layer
export '../../di/cash_location_providers.dart';

// Export use case params for presentation layer
export '../../domain/usecases/create_error_adjustment_use_case.dart' show CreateErrorAdjustmentParams;
export '../../domain/usecases/create_foreign_currency_translation_use_case.dart' show CreateForeignCurrencyTranslationParams;
export '../../domain/usecases/update_cash_location_use_case.dart' show UpdateCashLocationParams;
export '../../domain/usecases/update_main_account_status_use_case.dart' show UpdateMainAccountStatusParams;

// ============================================================================
// PRESENTATION LAYER PROVIDERS (UI State)
// ============================================================================

/// Cash Location Providers - delegates to UseCases
final allCashLocationsProvider = FutureProvider.family<List<CashLocation>, CashLocationQueryParams>((ref, params) async {
  final useCase = ref.read(getAllCashLocationsUseCaseProvider);
  return useCase(params);
});

/// Cash Real Provider - delegates to UseCase
final cashRealProvider = FutureProvider.family<List<CashRealEntry>, CashRealParams>((ref, params) async {
  final useCase = ref.read(getCashRealUseCaseProvider);
  return useCase(params);
});

/// Bank Real Provider - delegates to UseCase
final bankRealProvider = FutureProvider.family<List<BankRealEntry>, BankRealParams>((ref, params) async {
  final useCase = ref.read(getBankRealUseCaseProvider);
  return useCase(params);
});

/// Vault Real Provider - delegates to UseCase
final vaultRealProvider = FutureProvider.family<List<VaultRealEntry>, VaultRealParams>((ref, params) async {
  final useCase = ref.read(getVaultRealUseCaseProvider);
  return useCase(params);
});

/// Cash Journal Provider - delegates to UseCase
final cashJournalProvider = FutureProvider.family<List<JournalEntry>, CashJournalParams>((ref, params) async {
  final useCase = ref.read(getCashJournalUseCaseProvider);
  return useCase(params);
});

/// Stock Flow Provider - delegates to UseCase
final stockFlowProvider = FutureProvider.family<StockFlowResponse, StockFlowParams>((ref, params) async {
  final useCase = ref.read(getStockFlowUseCaseProvider);
  return useCase(params);
});

/// Currency Types Provider (placeholder - returns empty list for now)
/// This will need proper implementation when currency RPC is available
final currencyTypesProvider = FutureProvider<List<CurrencyType>>((ref) async {
  // TODO: Implement actual currency fetching from repository
  // For now, return empty list to maintain compatibility
  return [];
});

// ============================================================================
// PRESENTATION DISPLAY MODELS (UI Concerns Only)
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

// ============================================================================
// PERFORMANCE OPTIMIZATION - Cached Calculations (UI Concern)
// ============================================================================

/// Cached total balances to avoid fold() in build methods
class CashLocationTotals {
  final double totalJournal;
  final double totalReal;
  final double totalError;

  const CashLocationTotals({
    required this.totalJournal,
    required this.totalReal,
    required this.totalError,
  });
}

/// Provider for cached totals (avoids fold() every build)
final cashLocationTotalsProvider = Provider.family<CashLocationTotals, List<CashLocation>>(
  (ref, locations) {
    final totalJournal = locations.fold<double>(
      0, (sum, loc) => sum + loc.totalJournalCashAmount,
    );
    final totalReal = locations.fold<double>(
      0, (sum, loc) => sum + loc.totalRealCashAmount,
    );
    final totalError = totalReal - totalJournal;

    return CashLocationTotals(
      totalJournal: totalJournal,
      totalReal: totalReal,
      totalError: totalError,
    );
  },
);
