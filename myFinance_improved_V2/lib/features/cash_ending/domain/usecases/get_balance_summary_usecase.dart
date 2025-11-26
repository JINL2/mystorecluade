// lib/features/cash_ending/domain/usecases/get_balance_summary_usecase.dart

import '../entities/balance_summary.dart';
import '../repositories/cash_ending_repository.dart';
import '../repositories/bank_repository.dart';
import '../repositories/vault_repository.dart';

/// UseCase: Get balance summary for a location
///
/// This is a generic use case that can work with any repository
/// that provides balance summary functionality (Cash, Bank, Vault)
///
/// Business Logic:
/// - Validate location ID is not empty
/// - Fetch balance summary from appropriate repository
/// - Return balance comparison data
class GetBalanceSummaryUseCase {
  final CashEndingRepository? _cashRepository;
  final BankRepository? _bankRepository;
  final VaultRepository? _vaultRepository;

  GetBalanceSummaryUseCase({
    CashEndingRepository? cashRepository,
    BankRepository? bankRepository,
    VaultRepository? vaultRepository,
  })  : _cashRepository = cashRepository,
        _bankRepository = bankRepository,
        _vaultRepository = vaultRepository;

  /// Execute the use case
  ///
  /// [locationId] - The location to get balance summary for
  /// [type] - The type of balance summary (cash, bank, vault)
  ///
  /// Returns balance summary with:
  /// - Total Journal (book balance)
  /// - Total Real (actual count)
  /// - Difference
  ///
  /// Throws [ArgumentError] if location ID is empty
  /// Throws [StateError] if no repository is provided for the type
  Future<BalanceSummary> execute({
    required String locationId,
    required String type,
  }) async {
    // Business Rule: Validate location ID
    if (locationId.isEmpty) {
      throw ArgumentError('Location ID is required');
    }

    // Business Rule: Route to appropriate repository based on type
    switch (type.toLowerCase()) {
      case 'cash':
        if (_cashRepository == null) {
          throw StateError('CashEndingRepository not provided');
        }
        return await _cashRepository!.getBalanceSummary(
          locationId: locationId,
        );

      case 'bank':
        if (_bankRepository == null) {
          throw StateError('BankRepository not provided');
        }
        return await _bankRepository!.getBalanceSummary(
          locationId: locationId,
        );

      case 'vault':
        if (_vaultRepository == null) {
          throw StateError('VaultRepository not provided');
        }
        return await _vaultRepository!.getBalanceSummary(
          locationId: locationId,
        );

      default:
        throw ArgumentError('Invalid balance summary type: $type');
    }
  }
}

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
