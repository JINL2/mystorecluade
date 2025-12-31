// lib/features/cash_ending/domain/usecases/get_balance_summary_usecase.dart

import '../entities/balance_summary.dart';
import '../repositories/cash_ending_repository.dart';
import '../repositories/bank_repository.dart';
import '../repositories/vault_repository.dart';

/// Specialized use case for Cash balance summary
class GetCashBalanceSummaryUseCase {
  final CashEndingRepository _repository;

  GetCashBalanceSummaryUseCase(this._repository);

  Future<BalanceSummary> execute(String locationId) async {
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID is required');
    }
    return await _repository.getBalanceSummary(locationId: locationId);
  }
}

/// Specialized use case for Bank balance summary
class GetBankBalanceSummaryUseCase {
  final BankRepository _repository;

  GetBankBalanceSummaryUseCase(this._repository);

  Future<BalanceSummary> execute(String locationId) async {
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID is required');
    }
    return await _repository.getBalanceSummary(locationId: locationId);
  }
}

/// Specialized use case for Vault balance summary
class GetVaultBalanceSummaryUseCase {
  final VaultRepository _repository;

  GetVaultBalanceSummaryUseCase(this._repository);

  Future<BalanceSummary> execute(String locationId) async {
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID is required');
    }
    return await _repository.getBalanceSummary(locationId: locationId);
  }
}
