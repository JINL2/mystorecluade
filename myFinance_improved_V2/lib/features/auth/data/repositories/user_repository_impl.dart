// lib/features/auth/data/repositories/user_repository_impl.dart

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/entities/user_complete_data.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/supabase_user_datasource.dart';
import '../../../../core/data/base_repository.dart';

/// User Repository Implementation
///
/// 📜 Responsibilities:
/// - Implements Domain Repository Interface (UserRepository)
/// - Delegates data operations to UserDataSource
/// - Applies consistent error handling via BaseRepository
///
/// ✅ Improvements:
/// - Uses core BaseRepository for standardized error handling
/// - Clear operation names for debugging
/// - No Model → Entity conversion (Freezed handles it)
/// - Strong typing: getUserCompleteData returns UserCompleteData (not Map)
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final UserDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<User?> findById(String userId) {
    return executeFetch(
      () => _dataSource.getUserById(userId),
      operationName: 'user by ID',
    );
  }

  @override
  Future<User> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
  }) {
    return executeWithErrorHandling(
      () async {
        final updates = <String, dynamic>{};
        if (firstName != null) updates['first_name'] = firstName;
        if (lastName != null) updates['last_name'] = lastName;

        return await _dataSource.updateUserProfile(
          userId: userId,
          updates: updates,
        );
      },
      operationName: 'update user profile',
    );
  }

  @override
  Future<void> updateLastLogin({required String userId}) {
    return executeWithErrorHandling(
      () => _dataSource.updateLastLogin(userId),
      operationName: 'update last login',
    );
  }

  @override
  Future<List<Company>> getCompanies(String userId) {
    return executeFetch(
      () => _dataSource.getUserCompanies(userId),
      operationName: 'user companies',
    );
  }

  @override
  Future<List<Store>> getStores(String userId) {
    return executeFetch(
      () => _dataSource.getUserStores(userId),
      operationName: 'user stores',
    );
  }

  @override
  Future<bool> hasCompanyAccess({
    required String userId,
    required String companyId,
  }) {
    return executeFetch(
      () => _dataSource.hasCompanyAccess(
        userId: userId,
        companyId: companyId,
      ),
      operationName: 'company access check',
    );
  }

  @override
  Future<bool> hasStoreAccess({
    required String userId,
    required String storeId,
  }) {
    return executeFetch(
      () => _dataSource.hasStoreAccess(
        userId: userId,
        storeId: storeId,
      ),
      operationName: 'store access check',
    );
  }

  @override
  Future<UserCompleteData> getUserCompleteData(String userId) {
    return executeFetch(
      () async {
        final rawData = await _dataSource.getUserCompleteData(userId);
        return UserCompleteData.fromJson(rawData);
      },
      operationName: 'user complete data',
    );
  }
}
