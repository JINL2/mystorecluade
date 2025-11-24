// lib/features/cash_ending/domain/usecases/load_recent_cash_endings_usecase.dart

import '../entities/cash_ending.dart';
import '../repositories/cash_ending_repository.dart';

/// UseCase: Load recent cash endings for a location
///
/// Business Logic:
/// - Load last N cash endings for a location
/// - Sorted by creation date (newest first)
/// - Used for "Recent" section in Cash Ending page
class LoadRecentCashEndingsUseCase {
  final CashEndingRepository _repository;

  LoadRecentCashEndingsUseCase(this._repository);

  /// Execute the use case
  ///
  /// [locationId] - Location to load recent endings for
  /// [limit] - Maximum number of recent endings to load (default: 10)
  ///
  /// Returns list of recent cash endings sorted by date (newest first)
  Future<List<CashEnding>> execute({
    required String locationId,
    int limit = 10,
  }) async {
    return await _repository.getCashEndingHistory(
      locationId: locationId,
      limit: limit,
    );
  }
}
