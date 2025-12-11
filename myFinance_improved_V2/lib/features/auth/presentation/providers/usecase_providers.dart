import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/create_store_usecase.dart';
import '../../domain/usecases/get_user_data_usecase.dart';
import '../../domain/usecases/apple_sign_in_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/join_company_usecase.dart';
// Domain Layer UseCases
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/resend_signup_otp_usecase.dart';
import '../../domain/usecases/send_password_otp_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_password_otp_usecase.dart';
import '../../domain/usecases/verify_signup_otp_usecase.dart';
// Repository Providers
import '../providers/repository_providers.dart';

/// Login UseCase Provider
///
/// Provides the login use case with all required dependencies.
/// Handles user authentication through email and password.
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository: authRepo);
});

/// Signup UseCase Provider
///
/// Provides the signup use case with all required dependencies.
/// Handles new user registration with profile creation.
final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SignupUseCase(authRepository: authRepo);
});

/// Logout UseCase Provider
///
/// Provides the logout use case with all required dependencies.
/// Handles user sign out and session cleanup.
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(authRepository: authRepo);
});

/// Create Company UseCase Provider
///
/// Provides the create company use case with all required dependencies.
/// Handles new company/business creation.
final createCompanyUseCaseProvider = Provider<CreateCompanyUseCase>((ref) {
  final companyRepo = ref.watch(companyRepositoryProvider);
  return CreateCompanyUseCase(companyRepository: companyRepo);
});

/// Create Store UseCase Provider
///
/// Provides the create store use case with all required dependencies.
/// Handles new store creation within a company.
final createStoreUseCaseProvider = Provider<CreateStoreUseCase>((ref) {
  final storeRepo = ref.watch(storeRepositoryProvider);
  return CreateStoreUseCase(storeRepository: storeRepo);
});

/// Join Company UseCase Provider
///
/// Provides the join company use case with all required dependencies.
/// Handles joining an existing company using a company code.
final joinCompanyUseCaseProvider = Provider<JoinCompanyUseCase>((ref) {
  final companyRepo = ref.watch(companyRepositoryProvider);
  return JoinCompanyUseCase(companyRepository: companyRepo);
});

/// Get User Data UseCase Provider
///
/// Provides the get user data use case with all required dependencies.
/// Retrieves complete user data including companies and stores.
final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  return GetUserDataUseCase(userRepository: userRepo);
});

/// Update Password UseCase Provider
///
/// Provides the update password use case with all required dependencies.
/// Updates the user's password after clicking reset link.
final updatePasswordUseCaseProvider = Provider<UpdatePasswordUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return UpdatePasswordUseCase(authRepo);
});

/// Send Password OTP UseCase Provider
///
/// Provides the send password OTP use case with all required dependencies.
/// Sends a 6-digit OTP code to email for password recovery.
final sendPasswordOtpUseCaseProvider = Provider<SendPasswordOtpUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return SendPasswordOtpUseCase(authRepo);
});

/// Verify Password OTP UseCase Provider
///
/// Provides the verify password OTP use case with all required dependencies.
/// Verifies the OTP code and establishes recovery session.
final verifyPasswordOtpUseCaseProvider =
    Provider<VerifyPasswordOtpUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return VerifyPasswordOtpUseCase(authRepo);
});

/// Resend Signup OTP UseCase Provider
///
/// Provides the resend signup OTP use case with all required dependencies.
/// Resends the email verification OTP code after signup.
final resendSignupOtpUseCaseProvider = Provider<ResendSignupOtpUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return ResendSignupOtpUseCase(authRepo);
});

/// Verify Signup OTP UseCase Provider
///
/// Provides the verify signup OTP use case with all required dependencies.
/// Verifies the email after signup with OTP code.
final verifySignupOtpUseCaseProvider = Provider<VerifySignupOtpUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return VerifySignupOtpUseCase(authRepo);
});

/// Google Sign-In UseCase Provider
///
/// Provides the Google sign-in use case with all required dependencies.
/// Handles authentication through Google OAuth.
final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return GoogleSignInUseCase(authRepository: authRepo);
});

/// Apple Sign-In UseCase Provider
///
/// Provides the Apple sign-in use case with all required dependencies.
/// Handles authentication through Apple Sign-In.
final appleSignInUseCaseProvider = Provider<AppleSignInUseCase>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AppleSignInUseCase(authRepository: authRepo);
});
