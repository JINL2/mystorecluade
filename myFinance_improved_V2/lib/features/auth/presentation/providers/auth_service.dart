import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// Domain Layer
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/apple_sign_in_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/resend_signup_otp_usecase.dart';
import '../../domain/usecases/send_password_otp_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_password_otp_usecase.dart';
import '../../domain/usecases/verify_signup_otp_usecase.dart';
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
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final SendPasswordOtpUseCase _sendPasswordOtpUseCase;
  final VerifyPasswordOtpUseCase _verifyPasswordOtpUseCase;
  final ResendSignupOtpUseCase _resendSignupOtpUseCase;
  final VerifySignupOtpUseCase _verifySignupOtpUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final AppleSignInUseCase _appleSignInUseCase;
  final Ref _ref; // Still needed for session manager

  const AuthService({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required SendPasswordOtpUseCase sendPasswordOtpUseCase,
    required VerifyPasswordOtpUseCase verifyPasswordOtpUseCase,
    required ResendSignupOtpUseCase resendSignupOtpUseCase,
    required VerifySignupOtpUseCase verifySignupOtpUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required AppleSignInUseCase appleSignInUseCase,
    required Ref ref,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        _updatePasswordUseCase = updatePasswordUseCase,
        _sendPasswordOtpUseCase = sendPasswordOtpUseCase,
        _verifyPasswordOtpUseCase = verifyPasswordOtpUseCase,
        _resendSignupOtpUseCase = resendSignupOtpUseCase,
        _verifySignupOtpUseCase = verifySignupOtpUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        _appleSignInUseCase = appleSignInUseCase,
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
  /// 2. Creates user profile (name will be added on Complete Profile page)
  /// 3. Records login event for session tracking
  ///
  /// Note: firstName and lastName are optional - they will be collected
  /// on the Complete Profile page after OTP verification.
  ///
  /// Throws:
  /// - [AuthException] if signup fails
  /// - [ValidationException] if validation fails
  /// - [NetworkException] if network error occurs
  Future<User> signUp({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    // 1. Execute signup UseCase
    final user = await _signupUseCase.execute(
      SignupCommand(
        email: email.trim(),
        password: password,
        firstName: firstName?.trim(),
        lastName: lastName?.trim(),
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
  /// 2. Clears AppState and SharedPreferences cache
  /// 3. Executes logout UseCase (Supabase signOut)
  /// 4. Invalidates all providers automatically
  /// 5. Clears local cache and storage
  ///
  /// This method ensures complete cleanup without manual invalidation.
  Future<void> signOut() async {
    // 1. Clear session first
    await _ref.read(sessionManagerProvider.notifier).clearSession();

    // 2. Clear AppState and SharedPreferences (company/store selection cache)
    // This prevents previous user's data from showing on next login
    _ref.read(appStateProvider.notifier).signOut();

    // 3. Execute logout UseCase (Supabase signOut)
    await _logoutUseCase.execute();

    // 4. Invalidate all providers automatically
    // This is safer than manual invalidation as it catches all providers
    final container = _ref.container;
    final allProviders = container.getAllProviderElements();

    for (final element in allProviders) {
      // Get provider identifier - try both name and runtimeType
      final providerName = element.origin.name?.toString() ?? '';
      final providerType = element.origin.runtimeType.toString();
      final providerString = '$providerName $providerType'.toLowerCase();

      // Skip auth-related providers to avoid recursion
      // Skip router provider to prevent double page creation during logout
      final shouldSkip = providerString.contains('auth') ||
          providerString.contains('session') ||
          providerString.contains('router') ||
          providerString.contains('approuter');

      if (!shouldSkip) {
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

  /// Update user password
  ///
  /// Updates the password for the currently authenticated user.
  /// User must be authenticated (via reset link or OTP) to call this.
  ///
  /// Throws:
  /// - [ValidationException] if password is invalid
  /// - [AuthException] if user is not authenticated
  /// - [NetworkException] if network error occurs
  Future<void> updatePassword({
    required String newPassword,
  }) async {
    await _updatePasswordUseCase.execute(newPassword: newPassword);
  }

  /// Send password recovery OTP code
  ///
  /// Sends a 6-digit OTP code to the specified email address.
  /// User enters this code in the app to verify their identity.
  ///
  /// Throws:
  /// - [ValidationException] if email is invalid
  /// - [NetworkException] if network error occurs
  Future<void> sendPasswordOtp({
    required String email,
  }) async {
    await _sendPasswordOtpUseCase.execute(email: email);
  }

  /// Verify password recovery OTP code
  ///
  /// Verifies the OTP code and establishes a recovery session.
  /// After successful verification, user can set a new password.
  ///
  /// Throws:
  /// - [ValidationException] if OTP is invalid format
  /// - [AuthException] if OTP is wrong or expired
  /// - [NetworkException] if network error occurs
  Future<void> verifyPasswordOtp({
    required String email,
    required String token,
  }) async {
    await _verifyPasswordOtpUseCase.execute(email: email, token: token);
  }

  /// Resend signup email verification OTP
  ///
  /// Resends the 6-digit OTP code for email verification after signup.
  /// Use when the user didn't receive the original code or it expired.
  ///
  /// Throws:
  /// - [ValidationException] if email is invalid
  /// - [NetworkException] if network error occurs
  Future<void> resendSignupOtp({
    required String email,
  }) async {
    await _resendSignupOtpUseCase.execute(email: email);
  }

  /// Verify signup email OTP code
  ///
  /// Verifies the OTP code sent after signup to confirm the email.
  /// After successful verification, user is fully registered.
  ///
  /// Throws:
  /// - [ValidationException] if OTP is invalid format
  /// - [AuthException] if OTP is wrong or expired
  /// - [NetworkException] if network error occurs
  Future<User> verifySignupOtp({
    required String email,
    required String token,
  }) async {
    final user = await _verifySignupOtpUseCase.execute(
      email: email,
      token: token,
    );

    // Record login for session management after successful verification
    await _ref.read(sessionManagerProvider.notifier).recordLogin();

    return user;
  }

  /// Sign in with Google
  ///
  /// Performs the following operations:
  /// 1. Triggers native Google Sign-In flow
  /// 2. Authenticates with Supabase using ID token
  /// 3. Creates or retrieves user profile
  /// 4. Records login event for session tracking
  ///
  /// Throws:
  /// - [Exception] if user cancelled or sign-in failed
  /// - [NetworkException] if network error occurs
  Future<User> signInWithGoogle() async {
    // 1. Execute Google Sign-In UseCase
    final user = await _googleSignInUseCase.execute();

    // 2. Record login for session management
    await _ref.read(sessionManagerProvider.notifier).recordLogin();

    return user;
  }

  /// Sign in with Apple
  ///
  /// Performs the following operations:
  /// 1. Triggers native Apple Sign-In flow
  /// 2. Authenticates with Supabase using ID token
  /// 3. Creates or retrieves user profile
  /// 4. Records login event for session tracking
  ///
  /// Throws:
  /// - [Exception] if user cancelled or sign-in failed
  /// - [NetworkException] if network error occurs
  Future<User> signInWithApple() async {
    // 1. Execute Apple Sign-In UseCase
    final user = await _appleSignInUseCase.execute();

    // 2. Record login for session management
    await _ref.read(sessionManagerProvider.notifier).recordLogin();

    return user;
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
    updatePasswordUseCase: ref.watch(updatePasswordUseCaseProvider),
    sendPasswordOtpUseCase: ref.watch(sendPasswordOtpUseCaseProvider),
    verifyPasswordOtpUseCase: ref.watch(verifyPasswordOtpUseCaseProvider),
    resendSignupOtpUseCase: ref.watch(resendSignupOtpUseCaseProvider),
    verifySignupOtpUseCase: ref.watch(verifySignupOtpUseCaseProvider),
    googleSignInUseCase: ref.watch(googleSignInUseCaseProvider),
    appleSignInUseCase: ref.watch(appleSignInUseCaseProvider),
    ref: ref,
  );
});
