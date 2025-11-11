import 'package:flutter_riverpod/flutter_riverpod.dart';

// Domain Layer UseCases
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/create_store_usecase.dart';
import '../../domain/usecases/join_company_usecase.dart';
import '../../domain/usecases/get_user_data_usecase.dart';

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
