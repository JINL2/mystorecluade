import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/safe_navigation.dart';
import '../../core/navigation/navigation_state_provider.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/auth_signup_page.dart';
import '../pages/auth/create_business_page.dart';
import '../pages/auth/create_store_page.dart';
import '../pages/auth/choose_role_page.dart';
import '../pages/auth/join_business_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../providers/auth_provider.dart';
import '../providers/app_state_provider.dart';
import '../pages/homepage/homepage_redesigned.dart';
import '../pages/attendance/attendance_main_page.dart';
import '../pages/time_table_manage/time_table_manage_page.dart';
import '../pages/cash_ending/cash_ending_page.dart';
import '../pages/journal_input/journal_input_page.dart';
import '../pages/employee_setting/employee_setting_page_v2.dart';
import '../pages/role_permission/role_permission_page.dart';
import '../pages/delegate_role/delegate_role_page.dart';
import '../pages/timetable/timetable_page.dart';
import '../pages/balance_sheet/balance_sheet_page.dart';
import '../pages/store_shift/store_shift_page.dart';
import '../pages/counter_party/counter_party_page.dart';
import '../pages/add_fix_asset/add_fix_asset_page.dart';
import '../pages/register_denomination/register_denomination_page.dart';
import '../pages/cash_location/cash_location_page.dart';
import '../pages/cash_location/account_detail_page.dart';
import '../pages/transactions/transaction_history_page.dart';
import '../pages/transaction_template/transaction_template_page.dart';
import '../pages/inventory_management/inventory_management.dart';
import '../pages/inventory_analysis/supply_chain_dashboard.dart';
import '../pages/sales_invoice/sales_invoice_page.dart';
import '../pages/sales_invoice/create_invoice_page.dart';
import '../pages/sale_product/sale_product_page.dart';
import '../pages/sale_product/sale_invoice_page.dart';
import '../pages/sale_product/sale_payment_page.dart';
import '../pages/my_page/my_page_redesigned.dart';
import '../pages/my_page/edit_profile/edit_profile_page.dart';
import '../pages/my_page/notifications_settings/notifications_settings_page.dart';
import '../pages/my_page/privacy_security/privacy_security_page.dart';
import '../pages/debt_account_settings/debt_account_settings_page.dart';
import '../pages/debt_control/smart_debt_control_page.dart';
import '../pages/debt_control/debt_relationship_page.dart';
import '../pages/component_test/component_test_page.dart';
import '../pages/debug/supabase_connection_test_page.dart';
import '../pages/debug/notification_debug_page.dart';
import '../pages/debug/push_notification_diagnostic.dart';
import '../pages/debug/fcm_token_debug_page.dart';
import '../../core/themes/toss_text_styles.dart';
import '../../core/themes/toss_colors.dart';
import '../widgets/common/toss_scaffold.dart';


// Router notifier to listen to auth and app state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription<bool> _authListener;
  late final ProviderSubscription<AppState> _appStateListener;

  final List<String> _redirectHistory = [];
  static const int _maxRedirectHistory = 10;
  static const Duration _redirectTimeWindow = Duration(seconds: 5);
  final List<DateTime> _redirectTimestamps = [];
  

  RouterNotifier(this._ref) {
    // Listen to authentication state
    _authListener = _ref.listen<bool>(
      isAuthenticatedProvider,
      (previous, next) {
        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          notifyListeners();
        });
      },
    );
    
    // Listen to app state changes (includes user companies)
    _appStateListener = _ref.listen<AppState>(
      appStateProvider,
      (previous, next) {
        // Add delay to prevent rapid redirects
        Future.delayed(const Duration(milliseconds: 100), () {
          notifyListeners();
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
  
  // Check for redirect loops - only track actual redirects, not user navigation
  bool _checkForRedirectLoop(String path) {
    final now = DateTime.now();
    
    // Remove old entries outside the time window FIRST
    while (_redirectTimestamps.isNotEmpty && 
           now.difference(_redirectTimestamps.first) > _redirectTimeWindow) {
      _redirectHistory.removeAt(0);
      _redirectTimestamps.removeAt(0);
    }
    
    // Check if this path would cause a loop BEFORE adding it
    // Only consider paths within the recent time window
    final recentPathCount = _redirectHistory.where((p) => p == path).length;
    
    // If the same path appears 3+ times in the time window, it's likely a loop
    if (recentPathCount >= 3) {
      debugPrint('[RouterNotifier] Redirect loop detected for path: $path');
      debugPrint('[RouterNotifier] Path appeared ${recentPathCount + 1} times in last ${_redirectTimeWindow.inSeconds} seconds');
      _clearRedirectHistory();
      return true;
    }
    
    return false;
  }
  
  // Add path to redirect history (only call this for actual redirects)
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

}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Create router with refresh listenable
  final routerNotifier = RouterNotifier(ref);
  
  final router = GoRouter(
    initialLocation: '/', // Start at home page instead of login page
    refreshListenable: routerNotifier,
    restorationScopeId: 'app_router',
    redirect: (context, state) {
      try {
        final currentPath = state.matchedLocation;
        
        // Helper function to safely return a redirect with loop detection
        String? safeRedirect(String targetPath, String reason) {
          // First check if this would cause a loop
          if (routerNotifier._checkForRedirectLoop(targetPath)) {
            debugPrint('[AppRouter] Redirect loop detected, navigating to home');
            SafeNavigation.instance.clearAllLocks();
            routerNotifier._clearRedirectHistory();
            return '/';
          }
          
          // Only track as redirect if we're actually redirecting
          debugPrint('[AppRouter] $reason');
          routerNotifier._trackRedirect(targetPath);
          return targetPath;
        }
        
        // Special handling for /cashEnding to prevent redirect loops
        if (currentPath == '/cashEnding') {
          final isAuth = ref.read(isAuthenticatedProvider);
          final userData = ref.read(appStateProvider).user;
          final hasUserData = userData is Map && userData.isNotEmpty;
          final companyCount = userData is Map ? (userData['company_count'] ?? 0) : 0;
          
          // Allow access if user is authenticated and has companies
          if (isAuth && hasUserData && companyCount > 0) {
            debugPrint('[AppRouter] Allowing access to /cashEnding');
            return null; // Allow navigation
          }
          
          // Redirect to appropriate page if not authenticated or no companies
          if (!isAuth) {
            return safeRedirect('/auth/login', 'CashEnding: Not authenticated, redirecting to login');
          } else if (hasUserData && companyCount == 0) {
            return safeRedirect('/onboarding/choose-role', 'CashEnding: No companies, redirecting to onboarding');
          }
          
          // If waiting for user data, allow the page to load (it will handle the loading state)
          return null;
        }
        
        // Navigation state will be updated after widget build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final navNotifier = ref.read(navigationStateProvider.notifier);
            navNotifier.updateCurrentRoute(currentPath);
          } catch (e) {
            // Silently handle any provider access errors
            debugPrint('[AppRouter] Could not update navigation state: $e');
          }
        });
        
        final isAuth = ref.read(isAuthenticatedProvider);
        final appState = ref.read(appStateProvider);
        final isAuthRoute = state.matchedLocation.startsWith('/auth');
        final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
        
        // Get company count from app state
        final userData = appState.user;
        final hasUserData = userData is Map && userData.isNotEmpty;
        final companyCount = userData is Map ? (userData['company_count'] ?? 0) : 0;
        
        // Log navigation attempt for debugging
        debugPrint('[AppRouter] Redirect check - Path: $currentPath, Auth: $isAuth, Companies: $companyCount');
        
        // Priority 1: If not authenticated and not on auth route, go to login
        if (!isAuth && !isAuthRoute) {
          return safeRedirect('/auth/login', 'Not authenticated, redirecting to login');
        }
        
        // Priority 2: If authenticated, redirect away from auth pages to appropriate destination
        if (isAuth && isAuthRoute) {
          // If user has companies, go to main page
          if (hasUserData && companyCount > 0) {
            routerNotifier.clearRedirectHistory(); // Clear history on successful auth redirect
            return safeRedirect('/', 'Authenticated with companies, redirecting to home');
          }
          // If user has no companies but has data, go to onboarding
          else if (hasUserData && companyCount == 0) {
            return safeRedirect('/onboarding/choose-role', 'Authenticated without companies, redirecting to onboarding');
          }
          // If no user data yet, stay to let auth page load data
          else {
            debugPrint('[AppRouter] Authenticated but waiting for user data');
            return null;
          }
        }
        
        // Priority 3: If authenticated, on main pages, but no companies
        // Only redirect if we have loaded user data
        if (isAuth && !isAuthRoute && !isOnboardingRoute && 
            hasUserData && companyCount == 0) {
          return safeRedirect('/onboarding/choose-role', 'Authenticated on main page without companies, redirecting to onboarding');
        }
        
        // No redirect needed - clear history periodically
        // This prevents false positives from accumulating over time
        if (routerNotifier._redirectHistory.isNotEmpty) {
          final now = DateTime.now();
          if (routerNotifier._redirectTimestamps.isNotEmpty &&
              now.difference(routerNotifier._redirectTimestamps.first) > Duration(seconds: 10)) {
            routerNotifier._clearRedirectHistory();
          }
        }
        
        return null;
      } catch (error, stackTrace) {
        debugPrint('[AppRouter] Error in redirect: $error');
        debugPrintStack(stackTrace: stackTrace);
        
        // Update navigation state with error after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final navNotifier = ref.read(navigationStateProvider.notifier);
            navNotifier.setNavigationError(error);
          } catch (e) {
            debugPrint('[AppRouter] Could not set navigation error: $e');
          }
        });
        
        // Return to home on error
        return '/';
      }
    },
    errorBuilder: (context, state) {
      // Log navigation error
      final error = state.error;
      debugPrint('[AppRouter] Navigation error - Path: ${state.matchedLocation}, Error: $error');
      
      // Clear navigation locks on error
      SafeNavigation.instance.clearAllLocks();
      
      // Update navigation state after build completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final navNotifier = ref.read(navigationStateProvider.notifier);
          navNotifier.setNavigationError(error ?? 'Page not found');
        } catch (e) {
          debugPrint('[AppRouter] Could not set error state: $e');
        }
      });
      
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
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: TossTextStyles.h2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'The page you are looking for does not exist.',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Use safe navigation for error recovery
                  context.safeGo('/');
                },
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Try to go back safely
                  if (context.canPop()) {
                    context.safePop();
                  } else {
                    context.safeGo('/');
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
      // Auth Routes
      GoRoute(
        path: '/auth',
        redirect: (context, state) => '/auth/login',
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) {
              return const AuthSignupPage();
            },
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
        ],
      ),
      
      // Onboarding Routes (for authenticated users who need to complete profile)
      GoRoute(
        path: '/onboarding',
        redirect: (context, state) {
          final isAuth = ref.read(isAuthenticatedProvider);
          if (!isAuth) {
            return '/auth/login';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'choose-role',
            builder: (context, state) => const ChooseRolePage(),
          ),
          GoRoute(
            path: 'create-business',
            builder: (context, state) => const CreateBusinessPage(),
          ),
          GoRoute(
            path: 'create-store',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return CreateStorePage(
                companyId: extra?['companyId'] ?? '',
                companyName: extra?['companyName'] ?? '',
              );
            },
          ),
          GoRoute(
            path: 'join-business',
            builder: (context, state) => const JoinBusinessPage(),
          ),
        ],
      ),
      
      // Main App Routes (protected)
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePageRedesigned(),
        routes: [
          // HR Features
          GoRoute(
            path: 'attendance',
            builder: (context, state) => const AttendanceMainPage(),
          ),
          GoRoute(
            path: 'timetableManage',
            builder: (context, state) => const TimeTableManagePage(),
          ),
          GoRoute(
            path: 'cashEnding',
            builder: (context, state) => const CashEndingPage(),
          ),
          GoRoute(
            path: 'journalInput',
            builder: (context, state) => const JournalInputPage(),
          ),
          // Additional HR Features
          GoRoute(
            path: 'employeeSetting',
            builder: (context, state) => const EmployeeSettingPageV2(),
          ),
          GoRoute(
            path: 'rolePermissionPage',
            builder: (context, state) => const RolePermissionPage(),
          ),
          GoRoute(
            path: 'delegateRolePage',
            builder: (context, state) => const DelegateRolePage(),
          ),
          GoRoute(
            path: 'storeShiftSetting',
            builder: (context, state) => const StoreShiftPage(),
          ),
          GoRoute(
            path: 'timetable',
            builder: (context, state) => const TimetablePage(),
          ),
          // Finance Features
          GoRoute(
            path: 'balanceSheet',
            builder: (context, state) => const BalanceSheetPage(),
          ),
          // Counter Party Management
          GoRoute(
            path: 'registerCounterparty',
            builder: (context, state) => const CounterPartyPage(),
          ),
          // Debt Account Settings
          GoRoute(
            path: 'debtAccountSettings/:counterpartyId/:counterpartyName',
            builder: (context, state) {
              final counterpartyId = state.pathParameters['counterpartyId'] ?? '';
              final counterpartyName = state.pathParameters['counterpartyName'] ?? '';
              return DebtAccountSettingsPage(
                counterpartyId: counterpartyId,
                counterpartyName: counterpartyName,
              );
            },
          ),
          // Smart Debt Control
          GoRoute(
            path: 'debtControl',
            builder: (context, state) => const SmartDebtControlPage(),
          ),
          // Debt Relationship Detail Page
          GoRoute(
            path: 'debtRelationship/:counterpartyId',
            builder: (context, state) {
              final counterpartyId = state.pathParameters['counterpartyId'] ?? '';
              final extra = state.extra as Map<String, dynamic>?;
              final counterpartyName = extra?['counterpartyName'] ?? 'Unknown';
              return DebtRelationshipPage(
                counterpartyId: counterpartyId,
                counterpartyName: counterpartyName,
              );
            },
          ),
          GoRoute(
            path: 'addFixAsset',
            builder: (context, state) => const AddFixAssetPage(),
          ),
          // Register Denomination Page
          GoRoute(
            path: 'registerDenomination',
            builder: (context, state) => const RegisterDenominationPage(),
          ),
          // Transaction History Page
          GoRoute(
            path: 'transactionHistory',
            builder: (context, state) {
              // Extract query parameters
              final counterpartyId = state.uri.queryParameters['counterparty'];
              final scope = state.uri.queryParameters['scope'];
              final extra = state.extra as Map<String, dynamic>?;
              final counterpartyName = extra?['counterpartyName'];
              
              return TransactionHistoryPage(
                counterpartyId: counterpartyId,
                counterpartyName: counterpartyName,
                scope: scope,
              );
            },
          ),
          // Transaction Template Page
          GoRoute(
            path: 'transactionTemplate',
            builder: (context, state) => const TransactionTemplatePage(),
          ),
          // Sales Invoice
          GoRoute(
            path: 'salesInvoice',
            builder: (context, state) => const SalesInvoicePage(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateInvoicePage(),
              ),
            ],
          ),
          // Sale Product Flow
          GoRoute(
            path: 'saleProduct',
            builder: (context, state) => const SaleProductPage(),
            routes: [
              GoRoute(
                path: 'invoice',
                builder: (context, state) => const SaleInvoicePage(),
              ),
              GoRoute(
                path: 'payment',
                builder: (context, state) => const SalePaymentPage(),
              ),
            ],
          ),
          // Inventory Management
          GoRoute(
            path: 'inventoryManagement',
            builder: (context, state) => const InventoryManagementPage(),
            routes: [
              GoRoute(
                path: 'addProduct',
                builder: (context, state) => const AddProductPage(),
              ),
              GoRoute(
                path: 'editProduct',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final product = extra?['product'] as Product?;
                  return EditProductPage(product: product!);
                },
              ),
              GoRoute(
                path: 'product/:productId',
                builder: (context, state) {
                  // final productId = state.pathParameters['productId'] ?? '';
                  // Could use productId to fetch from database in the future
                  final extra = state.extra as Map<String, dynamic>?;
                  final product = extra?['product'] as Product?;
                  if (product != null) {
                    return ProductDetailPage(product: product);
                  }
                  // If no product passed, could fetch from database using productId
                  // For now, return to inventory management
                  return const InventoryManagementPage();
                },
              ),
              GoRoute(
                path: 'count',
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final products = extra?['products'] as List<Product>?;
                  return InventoryCountPage(products: products);
                },
              ),
            ],
          ),
          // Inventory Analysis - Supply Chain Analytics Dashboard
          GoRoute(
            path: 'inventoryAnalysis',
            builder: (context, state) => const SupplyChainDashboard(),
          ),
          // My Page
          GoRoute(
            path: 'myPage',
            builder: (context, state) => const MyPageRedesigned(),
          ),
          // Edit Profile Page
          GoRoute(
            path: 'edit-profile',
            builder: (context, state) => const EditProfilePage(),
          ),
          // Notifications Settings Page
          GoRoute(
            path: 'notifications-settings',
            builder: (context, state) => const NotificationsSettingsPage(),
          ),
          // Privacy & Security Page
          GoRoute(
            path: 'privacy-security',
            builder: (context, state) => const PrivacySecurityPage(),
          ),
          GoRoute(
            path: 'cashLocation',
            builder: (context, state) => const CashLocationPage(),
            routes: [
              GoRoute(
                path: 'account/:accountName',
                builder: (context, state) {
                  final accountName = state.pathParameters['accountName'] ?? '';
                  final extra = state.extra as Map<String, dynamic>?;
                  return AccountDetailPage(
                    locationId: extra?['locationId'],
                    accountName: accountName,
                    locationType: extra?['locationType'] ?? 'cash',
                    balance: extra?['balance'] ?? 0,
                    errors: extra?['errors'] ?? 0,
                    totalJournal: extra?['totalJournal'],
                    totalReal: extra?['totalReal'],
                    cashDifference: extra?['cashDifference'],
                    currencySymbol: extra?['currencySymbol'],
                  );
                },
              ),
            ],
          ),
          // Test Page (Notification Debug)
          GoRoute(
            path: 'test',
            builder: (context, state) => const ComponentTestPage(),
          ),
          // Debug Page (Supabase Connection Test)
          GoRoute(
            path: 'debug/supabase',
            builder: (context, state) => const SupabaseConnectionTestPage(),
          ),
          // Debug Page (Notification Debug)
          GoRoute(
            path: 'debug/notifications',
            builder: (context, state) => const NotificationDebugPage(),
          ),
          GoRoute(
            path: 'debug/push-diagnostic',
            builder: (context, state) => const PushNotificationDiagnostic(),
          ),
          // Debug Page (FCM Token Debug)
          GoRoute(
            path: 'debug/fcm-token',
            builder: (context, state) => const FcmTokenDebugPage(),
          ),
        ],
      ),
    ],
  );
  
  return router;
});