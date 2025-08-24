import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import '../pages/my_page/my_page.dart';
import '../pages/debt_account_settings/debt_account_settings_page.dart';
import '../pages/debt_control/smart_debt_control_page_v3.dart';
import '../pages/component_test/component_test_page.dart';
import '../pages/debug/supabase_connection_test_page.dart';
import '../pages/debug/notification_debug_page.dart';
import '../../core/themes/toss_text_styles.dart';
import '../../core/themes/toss_colors.dart';
import '../widgets/common/toss_scaffold.dart';


// Router notifier to listen to auth and app state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to authentication state
    _ref.listen<bool>(
      isAuthenticatedProvider,
      (previous, next) {
        notifyListeners();
      },
    );
    
    // Listen to app state changes (includes user companies)
    _ref.listen<AppState>(
      appStateProvider,
      (previous, next) {
        notifyListeners();
      },
    );
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
      final isAuth = ref.read(isAuthenticatedProvider);
      final appState = ref.read(appStateProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboardingRoute = state.matchedLocation.startsWith('/onboarding');
      
      // Get company count from app state
      final userData = appState.user;
      final hasUserData = userData is Map && userData.isNotEmpty;
      final companyCount = userData is Map ? (userData['company_count'] ?? 0) : 0;
      
      
      // Priority 1: If not authenticated and not on auth route, go to login
      if (!isAuth && !isAuthRoute) {
        return '/auth/login';
      }
      
      // Priority 2: If authenticated, redirect away from auth pages to appropriate destination
      if (isAuth && isAuthRoute) {
        // If user has companies, go to main page
        if (hasUserData && companyCount > 0) {
          return '/';
        }
        // If user has no companies but has data, go to onboarding
        else if (hasUserData && companyCount == 0) {
          return '/onboarding/choose-role';
        }
        // If no user data yet, stay to let auth page load data
        else {
          return null;
        }
      }
      
      // Priority 3: If authenticated, on main pages, but no companies
      // Only redirect if we have loaded user data
      if (isAuth && !isAuthRoute && !isOnboardingRoute && 
          hasUserData && companyCount == 0) {
        return '/onboarding/choose-role';
      }
      
      return null;
    },
    errorBuilder: (context, state) {
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
                'The page you are looking for does not exist.',
                style: TossTextStyles.bodyLarge.copyWith(
                  color: TossColors.gray600,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
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
            builder: (context, state) => const SmartDebtControlPageV3(),
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
            builder: (context, state) => const TransactionHistoryPage(),
          ),
          // Transaction Template Page
          GoRoute(
            path: 'transactionTemplate',
            builder: (context, state) => const TransactionTemplatePage(),
          ),
          // My Page
          GoRoute(
            path: 'myPage',
            builder: (context, state) => const MyPage(),
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
        ],
      ),
    ],
  );
  
  return router;
});