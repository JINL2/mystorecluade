// lib/features/auth/data/repositories/auth_repository_impl.dart

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';
import '../../../../core/data/base_repository.dart';

/// Auth Repository Implementation
///
/// 📜 Responsibilities:
/// - Implements Domain Repository Interface (AuthRepository)
/// - Delegates authentication operations to AuthDataSource
/// - Applies consistent error handling via BaseRepository
///
/// ✅ Improvements:
/// - Uses core BaseRepository for standardized error handling
/// - Clear operation names for debugging
/// - No Model → Entity conversion (Freezed handles it)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User?> login({
    required String email,
    required String password,
  }) {
    return executeFetch(
      () => _dataSource.signIn(
        email: email,
        password: password,
      ),
      operationName: 'user login',
    );
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) {
    return executeWithErrorHandling(
      () => _dataSource.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      ),
      operationName: 'user signup',
    );
  }

  @override
  Future<void> logout() {
    return executeWithErrorHandling(
      () => _dataSource.signOut(),
      operationName: 'user logout',
    );
  }
}
