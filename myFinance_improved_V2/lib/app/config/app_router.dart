import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_state.dart';
import '../providers/app_state_provider.dart';
import '../../features/auth/presentation/pages/choose_role_page.dart';
import '../../features/auth/presentation/pages/create_business_page.dart';
import '../../features/auth/presentation/pages/create_store_page.dart';
import '../../features/auth/presentation/pages/join_business_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/homepage/presentation/pages/homepage.dart';
import '../../features/transaction_template_refectore/presentation/pages/transaction_template_page.dart';
import '../../shared/themes/toss_colors.dart';
import '../../shared/themes/toss_spacing.dart';
import '../../shared/themes/toss_text_styles.dart';
import '../../shared/widgets/common/toss_scaffold.dart';

// Router notifier to listen to auth and app state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription<bool> _authListener;
  late final ProviderSubscription<AppState> _appStateListener;

  final List<String> _redirectHistory = [];
  static const int _maxRedirectHistory = 10;
  static const Duration _redirectTimeWindow = Duration(seconds: 5);
  final List<DateTime> _redirectTimestamps = [];

  // Navigation lock to prevent redirect interference during navigation
  bool _isNavigationInProgress = false;
  DateTime? _lastAuthNavigationTime;

  RouterNotifier(this._ref) {
    // Listen to authentication state
    _authListener = _ref.listen<bool>(
      isAuthenticatedProvider,
      (previous, next) {
        // Skip notifications during active auth navigation
        if (_lastAuthNavigationTime != null &&
            DateTime.now().difference(_lastAuthNavigationTime!) < Duration(seconds: 2)) {
          return;
        }

        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_lastAuthNavigationTime == null ||
              DateTime.now().difference(_lastAuthNavigationTime!) >= Duration(seconds: 3)) {
            notifyListeners();
          }
        });
      },
    );

    // Listen to app state changes (includes user companies)
    _appStateListener = _ref.listen<AppState>(
      appStateProvider,
      (previous, next) {
        // Skip notifications during active auth navigation
        if (_lastAuthNavigationTime != null &&
            DateTime.now().difference(_lastAuthNavigationTime!) < Duration(seconds: 2)) {
          return;
        }

        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_lastAuthNavigationTime == null ||
              DateTime.now().difference(_lastAuthNavigationTime!) >= Duration(seconds: 3)) {
            notifyListeners();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _authListener.close();
    _appStateListener.close();
    super.dispose();
  }

  // Check for redirect loops
  bool _checkForRedirectLoop(String path) {
    final now = DateTime.now();

    // Remove old entries outside the time window
    while (_redirectTimestamps.isNotEmpty &&
           now.difference(_redirectTimestamps.first) > _redirectTimeWindow) {
      _redirectHistory.removeAt(0);
      _redirectTimestamps.removeAt(0);
    }

    // Check if this path would cause a loop
    final recentPathCount = _redirectHistory.where((p) => p == path).length;

    if (recentPathCount >= 3) {
      _clearRedirectHistory();
      return true;
    }

    return false;
  }

  // Add path to redirect history
  void _trackRedirect(String path) {
    final now = DateTime.now();

    _redirectHistory.add(path);
    _redirectTimestamps.add(now);

    // Keep history limited
    if (_redirectHistory.length > _maxRedirectHistory) {
      _redirectHistory.removeAt(0);
      _redirectTimestamps.removeAt(0);
    }
  }

  void _clearRedirectHistory() {
    _redirectHistory.clear();
    _redirectTimestamps.clear();
  }

  void clearRedirectHistory() {
    _clearRedirectHistory();
  }

  // Navigation lock methods
  void lockNavigation() {
    _isNavigationInProgress = true;
  }

  void unlockNavigation() {
    _isNavigationInProgress = false;
  }

  bool get isNavigationLocked => _isNavigationInProgress;
}

/// App Router Provider
///
/// Provides the GoRouter configuration for the entire app.
/// Routes are organized by feature modules.
///
/// IMPORTANT: This must be a regular Provider (not StateProvider)
/// because GoRouter should only be created once and reused.
final appRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  final router = GoRouter(
    initialLocation: '/',
    restorationScopeId: 'app_router',
    refreshListenable: routerNotifier,  // ✅ CRITICAL: Listen to auth changes
    redirect: (context, state) {
      try {
        final currentPath = state.matchedLocation;

        // 🔍 DEBUG: Current path
        debugPrint('┌─────────────────────────────────────────────────────');
        debugPrint('│ [Router Debug] Current path: $currentPath');

        // Skip redirects during active navigation
        if (routerNotifier.isNavigationLocked) {
          debugPrint('│ [Router Debug] Navigation locked, skipping redirect');
          debugPrint('└─────────────────────────────────────────────────────');
          return null;
        }

        // Helper function for safe redirect with loop detection
        String? safeRedirect(String targetPath, String reason) {
          if (routerNotifier._checkForRedirectLoop(targetPath)) {
            debugPrint('│ [Router Debug] ⚠️ Redirect loop detected!');
            debugPrint('│ [Router Debug] Returning to /');
            debugPrint('└─────────────────────────────────────────────────────');
            routerNotifier._clearRedirectHistory();
            return '/';
          }

          debugPrint('│ [Router Debug] ➡️ REDIRECTING: $currentPath -> $targetPath');
          debugPrint('│ [Router Debug] Reason: $reason');
          debugPrint('└─────────────────────────────────────────────────────');
          routerNotifier._trackRedirect(targetPath);
          return targetPath;
        }

        // Check authentication
        final authState = ref.read(authStateProvider);
        debugPrint('│ [Router Debug] Auth State: ${authState.runtimeType}');

        authState.when(
          data: (user) {
            debugPrint('│ [Router Debug] Auth State = AsyncData');
            debugPrint('│ [Router Debug] User: ${user != null ? user.id : 'null'}');
          },
          loading: () {
            debugPrint('│ [Router Debug] Auth State = AsyncLoading');
          },
          error: (error, stack) {
            debugPrint('│ [Router Debug] Auth State = AsyncError: $error');
          },
        );

        final isAuth = ref.read(isAuthenticatedProvider);
        debugPrint('│ [Router Debug] isAuthenticated: $isAuth');

        final appState = ref.read(appStateProvider);
        debugPrint('│ [Router Debug] App State: ${appState.runtimeType}');
        debugPrint('│ [Router Debug] App State user: ${appState.user}');

        final isOnboardingRoute = currentPath.startsWith('/onboarding');
        final isAuthRoute = currentPath.startsWith('/auth');
        debugPrint('│ [Router Debug] Is onboarding route: $isOnboardingRoute');
        debugPrint('│ [Router Debug] Is auth route: $isAuthRoute');

        // Get company count from app state
        final userData = appState.user;
        final hasUserData = userData is Map && userData.isNotEmpty;

        // Calculate company count from companies array (not company_count field)
        int companyCount = 0;
        if (userData is Map && userData['companies'] is List) {
          companyCount = (userData['companies'] as List).length;
        }

        debugPrint('│ [Router Debug] Has user data: $hasUserData');
        debugPrint('│ [Router Debug] Company count: $companyCount');

        // Redirect to login if not authenticated AND trying to access protected pages
        if (!isAuth && !isAuthRoute && !isOnboardingRoute) {
          debugPrint('│ [Router Debug] ❌ User NOT authenticated, redirecting to login');
          return safeRedirect('/auth/login', 'Not authenticated');
        }

        // Allow unauthenticated users to access auth pages (login, signup)
        if (!isAuth && isAuthRoute) {
          debugPrint('│ [Router Debug] ✅ Unauthenticated user on auth page, allowing access');
          debugPrint('└─────────────────────────────────────────────────────');
          return null;
        }

        debugPrint('│ [Router Debug] ✅ User IS authenticated');

        // ✅ Redirect authenticated users away from auth pages
        if (isAuth && isAuthRoute) {
          debugPrint('│ [Router Debug] 🔄 Authenticated user on auth page, redirecting...');

          // If user has companies, go straight to home
          if (hasUserData && companyCount > 0) {
            debugPrint('│ [Router Debug] 📊 User has companies, going to home');
            return safeRedirect('/', 'Authenticated, has companies');
          }

          // ⚠️ CRITICAL FIX: Check if AppState data is still loading
          // If AppState is empty, stay on auth page and wait for data to load
          if (!hasUserData) {
            debugPrint('│ [Router Debug] ⏳ AppState empty, staying on auth page (data loading)');
            debugPrint('└─────────────────────────────────────────────────────');
            return null;  // Stay on current page, wait for data to load
          }

          // If user has NO companies (data loaded but empty), go to onboarding
          debugPrint('│ [Router Debug] 📊 User has no companies, going to onboarding');
          return safeRedirect('/onboarding/choose-role', 'Authenticated, needs onboarding');
        }

        // Redirect to onboarding if authenticated but no companies (from homepage)
        if (isAuth && !isOnboardingRoute && hasUserData && companyCount == 0) {
          debugPrint('│ [Router Debug] ⚠️ No companies found, redirecting to onboarding');
          debugPrint('│ [Router Debug] 🔍 hasUserData: $hasUserData, companyCount: $companyCount');
          debugPrint('│ [Router Debug] 🔍 userData.companies: ${userData['companies']}');
          return safeRedirect('/onboarding/choose-role', 'No companies');
        }

        debugPrint('│ [Router Debug] ✅ No redirect needed, continuing to: $currentPath');
        debugPrint('└─────────────────────────────────────────────────────');
        return null;
      } catch (error, stackTrace) {
        debugPrint('│ [Router Debug] ❌ ERROR: $error');
        debugPrint('│ [Router Debug] Stack trace: $stackTrace');
        debugPrint('└─────────────────────────────────────────────────────');
        return '/';
      }
    },
    errorBuilder: (context, state) {
      final error = state.error;

      return TossScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: TossColors.error,
              ),
              const SizedBox(height: TossSpacing.space4),
              Text(
                'Page Not Found',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TossSpacing.space2),
              Text(
                error?.toString() ?? 'The page you are looking for does not exist.',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: TossSpacing.space3),
              TextButton(
                onPressed: () {
                  try {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  } catch (e) {
                    // If canPop throws error, just go home
                    context.go('/');
                  }
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    },
    routes: [
      // Homepage
      GoRoute(
        path: '/',
        builder: (context, state) => Homepage(), // ✅ Removed const to allow rebuilds
      ),

      // Test Route (독립 route) - TransactionTemplatePage 연결
      GoRoute(
        path: '/test',
        name: 'test',
        builder: (context, state) {
          print('🟢 [AppRouter] /test route builder 호출됨!');
          print('🟢 [AppRouter] state.uri: ${state.uri}');
          print('🟢 [AppRouter] state.matchedLocation: ${state.matchedLocation}');
          return const TransactionTemplatePage();
        },
      ),

      // Auth Routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Onboarding Routes
      GoRoute(
        path: '/onboarding/choose-role',
        name: 'choose-role',
        builder: (context, state) => const ChooseRolePage(),
      ),
      GoRoute(
        path: '/onboarding/create-business',
        name: 'create-business',
        builder: (context, state) => const CreateBusinessPage(),
      ),
      GoRoute(
        path: '/onboarding/create-store',
        name: 'create-store',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final companyId = extra?['companyId'] as String? ?? '';
          final companyName = extra?['companyName'] as String? ?? '';
          return CreateStorePage(
            companyId: companyId,
            companyName: companyName,
          );
        },
      ),
      GoRoute(
        path: '/onboarding/join-business',
        name: 'join-business',
        builder: (context, state) => const JoinBusinessPage(),
      ),
    ],
  );

  // 🔍 DEBUG: Log all registered routes
  debugPrint('🔍 [Router Init] Total routes: ${router.configuration.routes.length}');
  for (var route in router.configuration.routes) {
    if (route is GoRoute) {
      debugPrint('🔍 [Router Init] Path: ${route.path}, Name: ${route.name}');
    }
  }

  return router;
});

// Auth state provider is imported from features/auth/presentation/providers/auth_state_provider.dart
// App state provider is imported from app/providers/app_state_provider.dart
