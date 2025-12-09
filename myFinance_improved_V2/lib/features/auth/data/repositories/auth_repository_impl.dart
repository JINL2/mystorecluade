// lib/features/auth/data/repositories/auth_repository_impl.dart

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';
import '../models/freezed/user_dto_mapper.dart';
import 'base_repository.dart';

/// Auth Repository Implementation
///
/// 📜 계약 이행자 - Domain Repository Interface를 구현
///
/// 책임:
/// - Domain 계약 준수 (AuthRepository interface)
/// - AuthDataSource 호출
/// - Model ↔ Entity 변환
/// - Exception 처리 및 변환 (BaseRepository 상속)
///
/// 이 계층은 Domain과 Data 사이의 변환을 담당합니다.
/// Supabase에 대한 지식은 없으며, AuthDataSource를 통해서만 데이터에 접근합니다.
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<User?> login({
    required String email,
    required String password,
  }) {
    return executeNullable(() async {
      // Call DataSource
      final userModel = await _dataSource.signIn(
        email: email,
        password: password,
      );

      // Convert Model to Entity
      return userModel.toEntity();
    });
  }

  @override
  Future<User> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) {
    return execute(() async {
      // Call DataSource
      final userModel = await _dataSource.signUp(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      // Convert Model to Entity
      return userModel.toEntity();
    });
  }

  @override
  Future<void> logout() {
    return execute(() => _dataSource.signOut());
  }

  @override
  Future<void> updatePassword({
    required String newPassword,
  }) {
    return execute(() => _dataSource.updatePassword(
          newPassword: newPassword,
        ));
  }

  @override
  Future<void> sendPasswordRecoveryOtp({
    required String email,
  }) {
    return execute(() => _dataSource.sendPasswordRecoveryOtp(
          email: email,
        ));
  }

  @override
  Future<void> verifyPasswordRecoveryOtp({
    required String email,
    required String token,
  }) {
    return execute(() => _dataSource.verifyPasswordRecoveryOtp(
          email: email,
          token: token,
        ));
  }

  @override
  Future<void> resendSignupOtp({
    required String email,
  }) {
    return execute(() => _dataSource.resendSignupOtp(
          email: email,
        ));
  }

  @override
  Future<User> verifySignupOtp({
    required String email,
    required String token,
  }) {
    return execute(() async {
      final userModel = await _dataSource.verifySignupOtp(
        email: email,
        token: token,
      );
      return userModel.toEntity();
    });
  }

  @override
  Future<User> signInWithGoogle() {
    return execute(() async {
      final userModel = await _dataSource.signInWithGoogle();
      return userModel.toEntity();
    });
  }

  @override
  Future<User> signInWithApple() {
    return execute(() async {
      final userModel = await _dataSource.signInWithApple();
      return userModel.toEntity();
    });
  }
}
