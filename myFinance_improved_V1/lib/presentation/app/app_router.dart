import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../providers/auth_provider.dart';
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
import '../pages/component_test/component_test_page.dart';
import '../pages/notification_debug/notification_debug_page.dart';


// Router notifier to listen to auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<bool>(
      isAuthenticatedProvider,
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
    initialLocation: '/auth/login',
    refreshListenable: routerNotifier,
    restorationScopeId: 'app_router',
    redirect: (context, state) {
      final isAuth = ref.read(isAuthenticatedProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      // If not authenticated and not on auth route, go to login
      if (!isAuth && !isAuthRoute) {
        return '/auth/login';
      }
      
      // If authenticated and on auth route, go to home
      if (isAuth && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for does not exist.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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
            builder: (context, state) => const SignupPage(),
          ),
          GoRoute(
            path: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
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
          // Component Test Page
          GoRoute(
            path: 'test',
            builder: (context, state) => const ComponentTestPage(),
          ),
          // Notification Debug Page
          GoRoute(
            path: 'notification-debug',
            builder: (context, state) => const NotificationDebugPage(),
          ),
        ],
      ),
    ],
  );
  
  return router;
});