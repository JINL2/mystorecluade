import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/value_objects/login_command.dart';
import '../../domain/value_objects/signup_command.dart';

// Providers
import 'session_manager_provider.dart';
import 'usecase_providers.dart';

/// Authentication Service
///
/// Provides high-level authentication operations with session management.
/// Facade pattern to simplify authentication flow.
///
/// Responsibilities:
/// - Execute authentication UseCases
/// - Manage session tracking
/// - Coordinate with session manager
class AuthService {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final Ref _ref; // Still needed for session manager

  const AuthService({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required Ref ref,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        _ref = ref;

  /// Sign in with email and password
  ///
  /// Performs the following operations:
  /// 1. Validates credentials via LoginUseCase
  /// 2. Records login event for session tracking
  ///
  /// Throws:
  /// - [AuthException] if credentials are invalid
  /// - [NetworkException] if network error occurs
  /// - [ValidationException] if validation fails
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    // 1. Execute login UseCase
    final user = await _loginUseCase.execute(
      LoginCommand(
        email: email.trim(),
        password: password,
      ),
    );

    // 2. Record login for session management
    await _ref.read(sessionManagerProvider.notifier).recordLogin();

    return user;
  }

  /// Sign up new user with email and password
  ///
  /// Performs the following operations:
  /// 1. Creates new user account via SignupUseCase
  /// 2. Creates user profile
  /// 3. Records login event for session tracking
  ///
  /// Throws:
  /// - [AuthException] if signup fails
  /// - [ValidationException] if validation fails
  /// - [NetworkException] if network error occurs
  Future<User> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // 1. Execute signup UseCase
    final user = await _signupUseCase.execute(
      SignupCommand(
        email: email.trim(),
        password: password,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      ),
    );

    // 2. Record login for session management
    // (Signup is treated as login for session tracking)
    await _ref.read(sessionManagerProvider.notifier).recordLogin();

    return user;
  }

  /// Sign out current user
  ///
  /// Enterprise-grade logout with complete cleanup:
  /// 1. Clears session state
  /// 2. Executes logout UseCase (Supabase signOut)
  /// 3. Invalidates all providers automatically
  /// 4. Clears local cache and storage
  ///
  /// This method ensures complete cleanup without manual invalidation.
  Future<void> signOut() async {
    // 1. Clear session first
    await _ref.read(sessionManagerProvider.notifier).clearSession();

    // 2. Execute logout UseCase
    await _logoutUseCase.execute();

    // 3. Invalidate all providers automatically
    // This is safer than manual invalidation as it catches all providers
    final container = _ref.container;
    final allProviders = container.getAllProviderElements();

    for (final element in allProviders) {
      // Skip auth-related providers to avoid recursion
      if (!element.origin.name.toString().contains('auth') &&
          !element.origin.name.toString().contains('session')) {
        element.invalidateSelf();
      }
    }
  }

  /// Get session status for debugging
  Map<String, dynamic> getSessionStatus() {
    return _ref.read(sessionManagerProvider.notifier).getCacheStatus();
  }

  /// Force expire cache (for pull-to-refresh)
  Future<void> expireCache() {
    return _ref.read(sessionManagerProvider.notifier).expireCache();
  }
}

/// Auth Service Provider
///
/// Provides AuthService instance with all dependencies injected.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    loginUseCase: ref.watch(loginUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    ref: ref,
  );
});
