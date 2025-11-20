// Dependency Injection for Cash Location Feature
// This file centralizes all dependency injection for clean architecture
// Following the Dependency Rule: dependencies point inward (Presentation -> Domain <- Data)

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/cash_location_data_source.dart';
import '../data/repositories/cash_location_repository_impl.dart';
import '../domain/repositories/cash_location_repository.dart';
import '../domain/usecases/create_cash_location_use_case.dart';
import '../domain/usecases/create_error_adjustment_use_case.dart';
import '../domain/usecases/create_foreign_currency_translation_use_case.dart';
import '../domain/usecases/delete_cash_location_use_case.dart';
import '../domain/usecases/get_all_cash_locations_use_case.dart';
import '../domain/usecases/get_bank_real_use_case.dart';
import '../domain/usecases/get_cash_journal_use_case.dart';
import '../domain/usecases/get_cash_location_by_id_use_case.dart';
import '../domain/usecases/get_cash_location_by_name_use_case.dart';
import '../domain/usecases/get_cash_real_use_case.dart';
import '../domain/usecases/get_stock_flow_use_case.dart';
import '../domain/usecases/get_vault_real_use_case.dart';
import '../domain/usecases/update_cash_location_use_case.dart';
import '../domain/usecases/update_main_account_status_use_case.dart';

// ============================================================================
// DATA LAYER PROVIDERS
// ============================================================================

/// Data Source Provider
final cashLocationDataSourceProvider = Provider<CashLocationDataSource>((ref) {
  return CashLocationDataSource();
});

/// Repository Implementation Provider
/// This is the only place where we instantiate the concrete repository
final cashLocationRepositoryProvider = Provider<CashLocationRepository>((ref) {
  final dataSource = ref.read(cashLocationDataSourceProvider);
  return CashLocationRepositoryImpl(dataSource: dataSource);
});

// ============================================================================
// DOMAIN LAYER PROVIDERS (USE CASES)
// ============================================================================

/// Create operations
final createCashLocationUseCaseProvider = Provider<CreateCashLocationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return CreateCashLocationUseCase(repository);
});

final createForeignCurrencyTranslationUseCaseProvider =
    Provider<CreateForeignCurrencyTranslationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return CreateForeignCurrencyTranslationUseCase(repository);
});

final createErrorAdjustmentUseCaseProvider = Provider<CreateErrorAdjustmentUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return CreateErrorAdjustmentUseCase(repository);
});

/// Query operations
final getAllCashLocationsUseCaseProvider = Provider<GetAllCashLocationsUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetAllCashLocationsUseCase(repository);
});

final getBankRealUseCaseProvider = Provider<GetBankRealUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetBankRealUseCase(repository);
});

final getCashRealUseCaseProvider = Provider<GetCashRealUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashRealUseCase(repository);
});

final getVaultRealUseCaseProvider = Provider<GetVaultRealUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetVaultRealUseCase(repository);
});

final getCashJournalUseCaseProvider = Provider<GetCashJournalUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashJournalUseCase(repository);
});

final getStockFlowUseCaseProvider = Provider<GetStockFlowUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetStockFlowUseCase(repository);
});

final getCashLocationByIdUseCaseProvider = Provider<GetCashLocationByIdUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashLocationByIdUseCase(repository);
});

final getCashLocationByNameUseCaseProvider = Provider<GetCashLocationByNameUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashLocationByNameUseCase(repository);
});

/// Update operations
final updateCashLocationUseCaseProvider = Provider<UpdateCashLocationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return UpdateCashLocationUseCase(repository);
});

final updateMainAccountStatusUseCaseProvider = Provider<UpdateMainAccountStatusUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return UpdateMainAccountStatusUseCase(repository);
});

/// Delete operations
final deleteCashLocationUseCaseProvider = Provider<DeleteCashLocationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return DeleteCashLocationUseCase(repository);
});
