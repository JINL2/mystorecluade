import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_fix_asset/presentation/pages/add_fix_asset_page.dart';
import '../../features/attendance/presentation/pages/attendance_main_page.dart';
import '../../features/attendance/presentation/pages/qr_scanner_page.dart';
import '../../features/auth/presentation/pages/choose_role_page.dart';
import '../../features/auth/presentation/pages/create_business_page.dart';
import '../../features/auth/presentation/pages/create_store_page.dart';
import '../../features/auth/presentation/pages/join_business_page.dart';
import '../../features/auth/presentation/pages/auth_welcome_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/verify_email_otp_page.dart';
import '../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../features/auth/presentation/pages/complete_profile_page.dart';
import '../../features/balance_sheet/presentation/pages/balance_sheet_page.dart';
import '../../features/cash_ending/presentation/pages/cash_ending_page.dart';
import '../../features/cash_location/presentation/pages/account_detail_page.dart';
import '../../features/cash_location/presentation/pages/account_settings_page.dart';
import '../../features/cash_location/presentation/pages/cash_location_page.dart';
import '../../features/counter_party/presentation/pages/counter_party_page.dart';
import '../../features/counter_party/presentation/pages/debt_account_settings_page.dart';
import '../../features/report_control/presentation/pages/report_control_page.dart';
import '../../features/debt_control/presentation/pages/smart_debt_control_page.dart';
import '../../features/delegate_role/presentation/pages/delegate_role_page.dart';
import '../../features/employee_setting/presentation/pages/employee_setting_page.dart';
import '../../features/homepage/presentation/pages/homepage.dart';
import '../../features/inventory_management/presentation/pages/add_product_page.dart';
import '../../features/inventory_management/presentation/pages/edit_product_page.dart';
import '../../features/inventory_management/presentation/pages/inventory_management_page.dart';
import '../../features/inventory_management/presentation/pages/product_detail_page.dart';
import '../../features/journal_input/presentation/pages/journal_input_page.dart';
import '../../features/my_page/presentation/pages/edit_profile_page.dart';
import '../../features/my_page/presentation/pages/my_page.dart';
import '../../features/my_page/presentation/pages/notifications_settings_page.dart';
import '../../features/my_page/presentation/pages/privacy_security_page.dart';
import '../../features/my_page/presentation/pages/subscription_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/register_denomination/presentation/pages/register_denomination_page.dart';
import '../../features/sale_product/presentation/pages/sale_product_page.dart';
import '../../features/sales_invoice/presentation/pages/sales_invoice_page.dart';
import '../../features/session/presentation/pages/session_page.dart';
import '../../features/store_shift/presentation/pages/store_shift_page.dart';
import '../../features/theme_library/presentation/pages/theme_library_page.dart';
import '../../features/time_table_manage/presentation/pages/time_table_manage_page.dart';
import '../../features/transaction_history/presentation/pages/transaction_history_page.dart';
import '../../features/transaction_template/presentation/pages/transaction_template_page.dart';
import '../../shared/themes/toss_colors.dart';
import '../../shared/themes/toss_spacing.dart';
import '../../shared/themes/toss_text_styles.dart';
import '../../shared/widgets/common/toss_scaffold.dart';
import '../providers/app_state.dart';
import '../providers/app_state_provider.dart';
import '../providers/auth_providers.dart';
import '../../features/homepage/presentation/providers/homepage_providers.dart';

// Router notifier to listen to auth and app state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription<bool> _authListener;
  late final ProviderSubscription<AppState> _appStateListener;
  late final ProviderSubscription<AsyncValue<Map<String, dynamic>?>> _userCompaniesListener;

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
        debugPrint('🔄 [RouterNotifier] Auth state changed: $previous -> $next');
        // Skip notifications during active auth navigation
        if (_lastAuthNavigationTime != null &&
            DateTime.now().difference(_lastAuthNavigationTime!) < const Duration(seconds: 2)) {
          return;
        }

        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_lastAuthNavigationTime == null ||
              DateTime.now().difference(_lastAuthNavigationTime!) >= const Duration(seconds: 3)) {
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
            DateTime.now().difference(_lastAuthNavigationTime!) < const Duration(seconds: 2)) {
          return;
        }

        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_lastAuthNavigationTime == null ||
              DateTime.now().difference(_lastAuthNavigationTime!) >= const Duration(seconds: 3)) {
            notifyListeners();
          }
        });
      },
    );

    // ✅ NEW: Listen to userCompaniesProvider for seamless workflow transitions
    // When user companies data loads, trigger router refresh to navigate appropriately
    _userCompaniesListener = _ref.listen<AsyncValue<Map<String, dynamic>?>>(
      userCompaniesProvider,
      (previous, next) {
        debugPrint('🔄 [RouterNotifier] UserCompanies state changed');
        next.when(
          data: (data) {
            debugPrint('✅ [RouterNotifier] UserCompanies data loaded: ${data != null}');
            // Data loaded - trigger router refresh for next step navigation
            Future.delayed(const Duration(milliseconds: 200), () {
              notifyListeners();
            });
          },
          loading: () {
            debugPrint('⏳ [RouterNotifier] UserCompanies loading...');
          },
          error: (error, stack) {
            debugPrint('❌ [RouterNotifier] UserCompanies error: $error');
            // Error (e.g., orphan session) - trigger refresh to handle redirect
            Future.delayed(const Duration(milliseconds: 100), () {
              notifyListeners();
            });
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _authListener.close();
    _appStateListener.close();
    _userCompaniesListener.close();
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

        // Skip redirects during active navigation
        if (routerNotifier.isNavigationLocked) {
          debugPrint('└─────────────────────────────────────────────────────');
          return null;
        }

        // Helper function for safe redirect with loop detection
        String? safeRedirect(String targetPath, String reason) {
          if (routerNotifier._checkForRedirectLoop(targetPath)) {
            debugPrint('└─────────────────────────────────────────────────────');
            routerNotifier._clearRedirectHistory();
            return '/';
          }

          debugPrint('└─────────────────────────────────────────────────────');
          routerNotifier._trackRedirect(targetPath);
          return targetPath;
        }

        // Check authentication
        final authState = ref.read(authStateProvider);

        authState.when(
          data: (user) {
          },
          loading: () {
          },
          error: (error, stack) {
          },
        );

        final isAuth = ref.read(isAuthenticatedProvider);

        final appState = ref.read(appStateProvider);

        final isOnboardingRoute = currentPath.startsWith('/onboarding');
        final isAuthRoute = currentPath.startsWith('/auth');
        final isCompleteProfileRoute = currentPath == '/auth/complete-profile';

        // Get company count from app state
        final userData = appState.user;
        final hasUserData = userData.isNotEmpty;

        // Calculate company count from companies array (not company_count field)
        int companyCount = 0;
        if (userData['companies'] is List) {
          companyCount = (userData['companies'] as List).length;
        }

        // Check if profile is complete (has first_name)
        final userFirstName = userData['user_first_name']?.toString() ?? '';
        final hasCompletedProfile = userFirstName.isNotEmpty;


        // Redirect to auth welcome if not authenticated AND trying to access protected pages
        if (!isAuth && !isAuthRoute && !isOnboardingRoute) {
          return safeRedirect('/auth', 'Not authenticated');
        }

        // Allow unauthenticated users to access auth pages (login, signup)
        if (!isAuth && isAuthRoute) {
          debugPrint('└─────────────────────────────────────────────────────');
          return null;
        }

        // ✅ NEW: Redirect to complete profile if authenticated but profile incomplete
        // Skip if already on complete-profile page
        if (isAuth && hasUserData && !hasCompletedProfile && !isCompleteProfileRoute) {
          return safeRedirect('/auth/complete-profile', 'Profile incomplete');
        }

        // ✅ Redirect authenticated users away from auth pages
        if (isAuth && isAuthRoute && !isCompleteProfileRoute) {

          // If user has companies, go straight to home
          if (hasUserData && companyCount > 0) {
            return safeRedirect('/', 'Authenticated, has companies');
          }

          // ⚠️ CRITICAL FIX: Check if AppState data is still loading
          // If AppState is empty, stay on auth page and wait for data to load
          if (!hasUserData) {
            debugPrint('└─────────────────────────────────────────────────────');
            return null;  // Stay on current page, wait for data to load
          }

          // If user has NO companies (data loaded but empty), go to onboarding
          return safeRedirect('/onboarding/choose-role', 'Authenticated, needs onboarding');
        }

        // Redirect to onboarding if authenticated but no companies (from homepage)
        if (isAuth && !isOnboardingRoute && hasUserData && companyCount == 0 && hasCompletedProfile) {
          return safeRedirect('/onboarding/choose-role', 'No companies');
        }

        debugPrint('└─────────────────────────────────────────────────────');
        return null;
      } catch (error) {
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
        builder: (context, state) => const Homepage(), // ✅ Removed const to allow rebuilds
        routes: [
          // Time Table Management (nested route)
          GoRoute(
            path: 'timetableManage',
            name: 'timetableManage',
            builder: (context, state) {
              final feature = state.extra;
              return TimeTableManagePage(feature: feature);
            },
          ),
          // Transaction Template (nested route)
          GoRoute(
            path: 'transactionTemplate',
            name: 'transactionTemplate',
            builder: (context, state) => const TransactionTemplatePage(),
          ),
        ],
      ),

      // Auth Routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthWelcomePage(),
      ),
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

      // Email Verification Route (after signup)
      GoRoute(
        path: '/auth/verify-email',
        name: 'verify-email',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyEmailOtpPage(email: email);
        },
      ),

      // Forgot Password Routes (OTP-based)
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/auth/verify-otp',
        name: 'verify-otp',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerifyOtpPage(email: email);
        },
      ),
      GoRoute(
        path: '/auth/reset-password',
        name: 'reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),

      // Complete Profile Route (for social login users with incomplete profile)
      GoRoute(
        path: '/auth/complete-profile',
        name: 'complete-profile',
        builder: (context, state) => const CompleteProfilePage(),
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

      // Cash Ending Route
      GoRoute(
        path: '/cashEnding',
        name: 'cashEnding',
        builder: (context, state) {
          final feature = state.extra;
          return CashEndingPage(feature: feature);
        },
      ),

      // Cash Location Route
      GoRoute(
        path: '/cashLocation',
        name: 'cashLocation',
        builder: (context, state) {
          final feature = state.extra;
          return CashLocationPage(feature: feature);
        },
        routes: [
          GoRoute(
            path: 'account/:accountName',
            name: 'accountDetail',
            builder: (context, state) {
              final accountName = state.pathParameters['accountName'] ?? '';
              final extra = state.extra as Map<String, dynamic>?;

              return AccountDetailPage(
                locationId: extra?['locationId'] as String?,
                accountName: accountName,
                locationType: extra?['locationType'] as String? ?? 'cash',
                balance: extra?['balance'] as int? ?? 0,
                errors: extra?['errors'] as int? ?? 0,
                totalJournal: extra?['totalJournal'] as int?,
                totalReal: extra?['totalReal'] as int?,
                cashDifference: extra?['cashDifference'] as int?,
                currencySymbol: extra?['currencySymbol'] as String?,
              );
            },
          ),
        ],
      ),

      // Register Denomination Route
      GoRoute(
        path: '/registerDenomination',
        name: 'registerDenomination',
        builder: (context, state) => const RegisterDenominationPage(),
      ),

      // Journal Input Route
      GoRoute(
        path: '/journal-input',
        name: 'journal-input',
        builder: (context, state) => const JournalInputPage(),
      ),

      // Journal Input Route (legacy alias for database compatibility)
      GoRoute(
        path: '/journalInput',
        name: 'journalInput',
        builder: (context, state) => const JournalInputPage(),
      ),

      // Employee Setting Route
      GoRoute(
        path: '/employeeSetting',
        name: 'employeeSetting',
        builder: (context, state) => const EmployeeSettingPageV2(),
      ),

      // Transaction History Route
      GoRoute(
        path: '/transactionHistory',
        name: 'transactionHistory',
        builder: (context, state) {
          final counterpartyId = state.uri.queryParameters['counterpartyId'];
          final counterpartyName = state.uri.queryParameters['counterpartyName'];
          final scope = state.uri.queryParameters['scope'];
          return TransactionHistoryPage(
            counterpartyId: counterpartyId,
            counterpartyName: counterpartyName,
            scope: scope,
          );
        },
      ),

      // My Page Routes
      GoRoute(
        path: '/my-page',
        name: 'my-page',
        builder: (context, state) => const MyPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/notifications-settings',
        name: 'notifications-settings',
        builder: (context, state) => const NotificationsSettingsPage(),
      ),
      GoRoute(
        path: '/privacy-security',
        name: 'privacy-security',
        builder: (context, state) => const PrivacySecurityPage(),
      ),
      GoRoute(
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionPage(),
      ),

      // Store Shift Route
      GoRoute(
        path: '/storeShiftSetting',
        name: 'storeShiftSetting',
        builder: (context, state) => const StoreShiftPage(),
      ),

      // Delegate Role Route
      GoRoute(
        path: '/delegateRolePage',
        name: 'delegateRolePage',
        builder: (context, state) => const DelegateRolePage(),
      ),

      // Balance Sheet Route
      GoRoute(
        path: '/balanceSheet',
        name: 'balanceSheet',
        builder: (context, state) => const BalanceSheetPage(),
      ),

      // Counter Party Route
      GoRoute(
        path: '/registerCounterparty',
        name: 'registerCounterparty',
        builder: (context, state) => const CounterPartyPage(),
      ),

      // Debt Account Settings Route (for internal counter parties)
      GoRoute(
        path: '/debtAccountSettings/:counterpartyId/:name',
        name: 'debtAccountSettings',
        builder: (context, state) {
          final counterpartyId = state.pathParameters['counterpartyId']!;
          final name = state.pathParameters['name']!; // go_router already decodes

          return DebtAccountSettingsPage(
            counterpartyId: counterpartyId,
            counterpartyName: name,
          );
        },
      ),

      // Add Fix Asset Route
      GoRoute(
        path: '/addFixAsset',
        name: 'addFixAsset',
        builder: (context, state) => const AddFixAssetPage(),
      ),

      // Debt Control Route
      GoRoute(
        path: '/debtControl',
        name: 'debtControl',
        builder: (context, state) => const SmartDebtControlPage(),
      ),

      // Inventory Management Route
      GoRoute(
        path: '/inventoryManagement',
        name: 'inventoryManagement',
        builder: (context, state) => const InventoryManagementPage(),
        routes: [
          GoRoute(
            path: 'addProduct',
            name: 'addProduct',
            builder: (context, state) => const AddProductPage(),
          ),
          GoRoute(
            path: 'product/:productId',
            name: 'productDetail',
            builder: (context, state) {
              final productId = state.pathParameters['productId']!;
              return ProductDetailPage(productId: productId);
            },
          ),
          GoRoute(
            path: 'editProduct/:productId',
            name: 'editProduct',
            builder: (context, state) {
              final productId = state.pathParameters['productId']!;
              return EditProductPage(productId: productId);
            },
          ),
        ],
      ),

      // Attendance Routes
      GoRoute(
        path: '/attendance',
        name: 'attendance',
        builder: (context, state) => const AttendanceMainPage(),
        routes: [
          GoRoute(
            path: 'qr-scanner',
            name: 'qr-scanner',
            builder: (context, state) => const QRScannerPage(),
          ),
        ],
      ),

      // Sale Product Route
      GoRoute(
        path: '/saleProduct',
        name: 'saleProduct',
        builder: (context, state) => const SaleProductPage(),
      ),

      // Sales Invoice Route
      GoRoute(
        path: '/salesInvoice',
        name: 'salesInvoice',
        builder: (context, state) => const SalesInvoicePage(),
      ),

      // Theme Library Route
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const ThemeLibraryPage(),
      ),

      // Report Control Route
      GoRoute(
        path: '/reportControl',
        name: 'reportControl',
        builder: (context, state) {
          final feature = state.extra;
          return ReportControlPage(feature: feature);
        },
      ),

      // Session Route
      GoRoute(
        path: '/session',
        name: 'session',
        builder: (context, state) {
          final feature = state.extra;
          return SessionPage(feature: feature);
        },
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
