/// StateNotifier Providers for homepage module
///
/// Contains all StateNotifierProviders for business logic management.
/// These providers are used by UI components to trigger actions and watch state changes.
///
/// Using autoDispose for automatic cleanup when no longer needed.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/use_case_providers.dart';
import 'company_notifier.dart';
import 'join_notifier.dart';
import 'states/company_state.dart';
import 'states/join_state.dart';
import 'states/store_state.dart';
import 'store_notifier.dart';

// ============================================================================
// Company Notifier Providers
// ============================================================================

/// Company StateNotifier Provider
///
/// Manages company creation state and business logic.
/// Automatically disposed when no longer watched.
///
/// Usage:
/// ```dart
/// // Watch state
/// final companyState = ref.watch(companyNotifierProvider);
///
/// // Trigger action
/// ref.read(companyNotifierProvider.notifier).createCompany(
///   companyName: name,
///   companyTypeId: typeId,
///   baseCurrencyId: currencyId,
/// );
///
/// // Reset state
/// ref.read(companyNotifierProvider.notifier).reset();
/// ```
final companyNotifierProvider =
    StateNotifierProvider.autoDispose<CompanyNotifier, CompanyState>((ref) {
  final createCompany = ref.watch(createCompanyUseCaseProvider);
  return CompanyNotifier(createCompany);
});

// ============================================================================
// Store Notifier Providers
// ============================================================================

/// Store StateNotifier Provider
///
/// Manages store creation state and business logic.
/// Automatically disposed when no longer watched.
///
/// Usage:
/// ```dart
/// // Watch state
/// final storeState = ref.watch(storeNotifierProvider);
///
/// // Trigger action
/// ref.read(storeNotifierProvider.notifier).createStore(
///   storeName: name,
///   companyId: companyId,
/// );
///
/// // Reset state
/// ref.read(storeNotifierProvider.notifier).reset();
/// ```
final storeNotifierProvider =
    StateNotifierProvider.autoDispose<StoreNotifier, StoreState>((ref) {
  final createStore = ref.watch(createStoreUseCaseProvider);
  return StoreNotifier(createStore);
});

// ============================================================================
// Join Notifier Providers
// ============================================================================

/// Join StateNotifier Provider
///
/// Manages join-by-code state and business logic.
/// Automatically disposed when no longer watched.
///
/// Usage:
/// ```dart
/// // Watch state
/// final joinState = ref.watch(joinNotifierProvider);
///
/// // Trigger action
/// ref.read(joinNotifierProvider.notifier).joinByCode(
///   userId: userId,
///   code: code,
/// );
///
/// // Reset state
/// ref.read(joinNotifierProvider.notifier).reset();
/// ```
final joinNotifierProvider =
    StateNotifierProvider.autoDispose<JoinNotifier, JoinState>((ref) {
  final joinByCode = ref.watch(joinByCodeUseCaseProvider);
  return JoinNotifier(joinByCode);
});
