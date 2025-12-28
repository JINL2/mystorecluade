/// Alert & Version Presentation Layer Providers
///
/// This file contains alert and version check providers.
/// - App version check
/// - Homepage alert
/// - Init scenario
///
/// Extracted from homepage_providers.dart for better organization.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../../core/services/app_init_service.dart';
import '../../domain/entities/homepage_alert.dart';
import '../../domain/providers/repository_providers.dart';

// ============================================================================
// App Init Scenario Provider
// ============================================================================

/// Provider that determines the initialization scenario
/// Used to optimize data loading based on how user entered the app
final initScenarioProvider = FutureProvider<InitScenario>((ref) async {
  final authState = ref.watch(authStateProvider);

  final userId = authState.when(
    data: (user) => user?.id,
    loading: () => null,
    error: (_, __) => null,
  );

  return await AppInitService().determineScenario(userId);
});

// ============================================================================
// App Version Check Provider
// ============================================================================

/// Provider for checking app version against server
///
/// Returns true if app is up to date, false if update required.
/// This should be called BEFORE loading other homepage data.
final appVersionCheckProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(homepageRepositoryProvider);
  return await repository.checkAppVersion();
});

// ============================================================================
// Homepage Alert Provider
// ============================================================================

/// Provider for fetching homepage alert
///
/// Returns alert data with is_show and is_checked flags.
/// Uses 6-hour cache in DataSource to prevent excessive API calls.
final homepageAlertProvider = FutureProvider<HomepageAlert>((ref) async {
  // Wait for authentication
  final authState = ref.watch(authStateProvider);
  final user = authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );

  if (user == null) {
    return const HomepageAlert(isShow: false, isChecked: false, content: null);
  }

  final repository = ref.watch(homepageRepositoryProvider);
  final alert = await repository.getHomepageAlert(userId: user.id);
  return alert;
});
