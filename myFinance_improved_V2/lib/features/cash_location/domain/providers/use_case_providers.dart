import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../usecases/create_cash_location_use_case.dart';
import '../usecases/create_error_adjustment_use_case.dart';
import '../usecases/create_foreign_currency_translation_use_case.dart';
import '../usecases/delete_cash_location_use_case.dart';
import '../usecases/get_all_cash_locations_use_case.dart';
import '../usecases/get_bank_real_use_case.dart';
import '../usecases/get_cash_journal_use_case.dart';
import '../usecases/get_cash_location_by_id_use_case.dart';
import '../usecases/get_cash_location_by_name_use_case.dart';
import '../usecases/get_cash_real_use_case.dart';
import '../usecases/get_stock_flow_use_case.dart';
import '../usecases/get_vault_real_use_case.dart';
import '../usecases/update_cash_location_use_case.dart';
import '../usecases/update_main_account_status_use_case.dart';

/// Use Case Providers
/// These providers inject repository into use cases

// Create operations
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

// Query operations
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

// Newly added query operations
final getCashLocationByIdUseCaseProvider = Provider<GetCashLocationByIdUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashLocationByIdUseCase(repository);
});

final getCashLocationByNameUseCaseProvider = Provider<GetCashLocationByNameUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return GetCashLocationByNameUseCase(repository);
});

// Update operations
final updateCashLocationUseCaseProvider = Provider<UpdateCashLocationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return UpdateCashLocationUseCase(repository);
});

final updateMainAccountStatusUseCaseProvider = Provider<UpdateMainAccountStatusUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return UpdateMainAccountStatusUseCase(repository);
});

// Delete operations
final deleteCashLocationUseCaseProvider = Provider<DeleteCashLocationUseCase>((ref) {
  final repository = ref.read(cashLocationRepositoryProvider);
  return DeleteCashLocationUseCase(repository);
});
