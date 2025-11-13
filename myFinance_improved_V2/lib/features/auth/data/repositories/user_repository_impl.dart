// lib/features/auth/data/repositories/user_repository_impl.dart

import '../../domain/entities/company_entity.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/supabase_user_datasource.dart';
import '../models/freezed/company_dto_mapper.dart';
import '../models/freezed/store_dto_mapper.dart';
import '../models/freezed/user_dto_mapper.dart';
import 'base_repository.dart';

/// User Repository Implementation
///
/// 📜 계약 이행자 - Domain Repository Interface를 구현
///
/// 책임:
/// - Domain 계약 준수 (UserRepository interface)
/// - UserDataSource 호출
/// - Model ↔ Entity 변환
/// - Exception 처리 및 변환 (BaseRepository 상속)
///
/// 이 계층은 Domain과 Data 사이의 변환을 담당합니다.
/// Supabase에 대한 지식은 없으며, UserDataSource를 통해서만 데이터에 접근합니다.
class UserRepositoryImpl extends BaseRepository implements UserRepository {
  final UserDataSource _dataSource;

  UserRepositoryImpl(this._dataSource);

  @override
  Future<User?> findById(String userId) {
    return executeNullable(() async {
      final userModel = await _dataSource.getUserById(userId);
      return userModel?.toEntity();
    });
  }

  @override
  Future<User?> findByEmail(String email) async {
    // Note: This would require adding email query to UserDataSource
    // For now, not implemented as it's not currently used in the app
    throw UnimplementedError(
      'findByEmail requires email query in UserDataSource. '
      'Add this method to UserDataSource if needed.',
    );
  }

  @override
  Future<bool> emailExists(String email) async {
    // Note: This would require adding email existence check to UserDataSource
    // For now, not implemented as it's not currently used in the app
    throw UnimplementedError(
      'emailExists requires email query in UserDataSource. '
      'Add this method to UserDataSource if needed.',
    );
  }

  @override
  Future<User> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
  }) {
    return execute(() async {
      final updates = <String, dynamic>{};

      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;

      final updatedModel = await _dataSource.updateUserProfile(
        userId: userId,
        updates: updates,
      );

      return updatedModel.toEntity();
    });
  }

  @override
  Future<void> updateLastLogin({required String userId}) {
    return execute(() => _dataSource.updateLastLogin(userId));
  }

  @override
  Future<List<Company>> getCompanies(String userId) {
    return execute(() async {
      final companyModels = await _dataSource.getUserCompanies(userId);
      return companyModels.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<List<Store>> getStores(String userId) {
    return execute(() async {
      final storeModels = await _dataSource.getUserStores(userId);
      return storeModels.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<bool> hasCompanyAccess({
    required String userId,
    required String companyId,
  }) {
    return execute(() async {
      return await _dataSource.hasCompanyAccess(
        userId: userId,
        companyId: companyId,
      );
    });
  }

  @override
  Future<bool> hasStoreAccess({
    required String userId,
    required String storeId,
  }) {
    return execute(() async {
      return await _dataSource.hasStoreAccess(
        userId: userId,
        storeId: storeId,
      );
    });
  }

  @override
  Future<Map<String, dynamic>> getUserCompleteData(String userId) {
    return execute(() => _dataSource.getUserCompleteData(userId));
  }
}
