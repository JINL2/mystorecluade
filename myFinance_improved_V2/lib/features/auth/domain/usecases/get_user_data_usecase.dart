// lib/features/auth/domain/usecases/get_user_data_usecase.dart

import '../entities/user_complete_data.dart';
import '../repositories/user_repository.dart';

/// Get user complete data use case
///
/// Retrieves user's complete data including companies and stores.
/// Applies filtering to remove deleted items.
///
/// ✅ Improvements:
/// - Returns strongly-typed UserCompleteData (not Map)
/// - Filtering is done at the entity level (more efficient)
/// - Business logic is clear and explicit
class GetUserDataUseCase {
  final UserRepository _userRepository;

  const GetUserDataUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  /// Execute user data retrieval
  ///
  /// Returns filtered UserCompleteData with active companies and stores only.
  /// Deleted items are automatically filtered out.
  ///
  /// 🎯 Before vs After:
  /// ```dart
  /// // ❌ Before (weak typing)
  /// final data = await useCase.execute(userId);
  /// final companies = data['companies']; // Runtime error prone
  ///
  /// // ✅ After (strong typing)
  /// final data = await useCase.execute(userId);
  /// final companies = data.activeCompanies; // Compile-time safe
  /// ```
  Future<UserCompleteData> execute(String userId) async {
    // Get user data from repository (already typed!)
    final data = await _userRepository.getUserCompleteData(userId);

    // Apply business rules: filter deleted items
    // Note: We return a new instance with filtered lists
    return data.copyWith(
      companies: data.activeCompanies,
      stores: data.activeStores,
    );
  }
}
