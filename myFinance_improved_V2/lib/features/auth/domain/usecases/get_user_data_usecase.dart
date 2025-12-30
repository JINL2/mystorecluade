// lib/features/auth/domain/usecases/get_user_data_usecase.dart

import '../../../../core/utils/data_filter_utils.dart';
import '../repositories/user_repository.dart';

/// Get user complete data use case
///
/// Retrieves user's complete data including companies and stores.
/// Applies filtering to remove deleted companies and stores.
///
/// This UseCase encapsulates the business logic for user data retrieval
/// and ensures data is properly filtered before being returned.
class GetUserDataUseCase {
  final UserRepository _userRepository;

  const GetUserDataUseCase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  /// Execute user data retrieval
  ///
  /// Returns filtered user data with companies and stores.
  /// Deleted companies and stores are automatically filtered out.
  Future<Map<String, dynamic>> execute(String userId) async {
    // Get raw user data
    final rawData = await _userRepository.getUserCompleteData(userId);

    // Apply filtering to remove deleted items
    final filteredData = DataFilterUtils.filterDeletedCompaniesAndStores(rawData);

    return filteredData;
  }
}
