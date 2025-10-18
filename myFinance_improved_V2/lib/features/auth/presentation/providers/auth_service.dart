import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer
import '../../domain/entities/user_entity.dart';
import '../../domain/value_objects/login_command.dart';
import '../../domain/value_objects/signup_command.dart';

// Providers
import 'usecase_providers.dart';
import 'session_manager_provider.dart';

/// Authentication Service
///
/// Provides high-level authentication operations with session management.
/// This service follows the legacy pattern of Provider<Service> for minimal
/// UI code changes during migration.
///
/// Responsibilities:
/// - Execute authentication UseCases
/// - Manage session tracking
/// - Coordinate with session manager
///
/// Usage:
/// ```dart
/// final authService = ref.read(authServiceProvider);
/// await authService.signIn(email: 'user@example.com', password: 'password');
/// ```
class AuthService {
  const AuthService(this.ref);

  final Ref ref;

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
    try {
      // 1. Execute login UseCase
      final command = LoginCommand(
        email: email.trim(),
        password: password,
      );

      final user = await ref.read(loginUseCaseProvider).execute(command);

      // 2. Record login for session management
      await ref.read(sessionManagerProvider.notifier).recordLogin();

      return user;
    } catch (e) {
      rethrow;
    }
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
    try {
      // 1. Execute signup UseCase
      final command = SignupCommand(
        email: email.trim(),
        password: password,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
      );

      final user = await ref.read(signupUseCaseProvider).execute(command);

      // 2. Record login for session management
      // (Signup is treated as login for session tracking)
      await ref.read(sessionManagerProvider.notifier).recordLogin();

      return user;
    } catch (e) {
      rethrow;
    }
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
    try {
      // 1. Clear session first
      await ref.read(sessionManagerProvider.notifier).clearSession();

      // 2. Execute logout UseCase
      await ref.read(logoutUseCaseProvider).execute();

      // 3. Invalidate all providers automatically
      // This is safer than manual invalidation as it catches all providers
      final container = ref.container;
      final allProviders = container.getAllProviderElements();

      for (final element in allProviders) {
        // Skip auth-related providers to avoid recursion
        if (!element.origin.name.toString().contains('auth') &&
            !element.origin.name.toString().contains('session')) {
          element.invalidateSelf();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get session status for debugging
  ///
  /// Returns cache status including:
  /// - isFreshLogin
  /// - isUserDataStale
  /// - areFeaturesStale
  /// - cache expiry times
  Map<String, dynamic> getSessionStatus() {
    final sessionManager = ref.read(sessionManagerProvider.notifier);
    return sessionManager.getCacheStatus();
  }

  /// Force expire cache (for pull-to-refresh)
  ///
  /// Use this when user explicitly requests fresh data.
  Future<void> expireCache() async {
    await ref.read(sessionManagerProvider.notifier).expireCache();
  }
}

/// Auth Service Provider
///
/// Provides AuthService instance with all dependencies injected.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});
