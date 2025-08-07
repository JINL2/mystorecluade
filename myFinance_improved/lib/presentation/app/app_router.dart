import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/signup_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../providers/auth_provider.dart';
import '../pages/homepage/homepage_redesigned.dart';
import '../pages/attendance/attendance_page.dart';
import '../pages/employee_settings/employee_settings_page.dart';
import '../pages/role_permission/role_permission_page.dart';
import '../pages/delegate_role/delegate_role_page.dart';
import '../pages/cash_location/cash_location_page.dart';
import '../pages/placeholder_page.dart';

// Router notifier to listen to auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<bool>(
      isAuthenticatedProvider,
      (previous, next) {
        print('RouterNotifier: Auth state changed from $previous to $next');
        notifyListeners();
      },
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  // Create router with refresh listenable
  final router = GoRouter(
    initialLocation: '/auth/login',
    refreshListenable: RouterNotifier(ref),
    redirect: (context, state) {
      final isAuth = ref.read(isAuthenticatedProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      
      print('Router redirect: isAuth=$isAuth, location=${state.matchedLocation}, isAuthRoute=$isAuthRoute');
      
      // If not authenticated and not on auth route, go to login
      if (!isAuth && !isAuthRoute) {
        print('Router redirect: Not authenticated, redirecting to login');
        return '/auth/login';
      }
      
      // If authenticated and on auth route, go to home
      if (isAuth && isAuthRoute) {
        print('Router redirect: Authenticated on auth route, redirecting to home');
        return '/';
      }
      
      print('Router redirect: No redirect needed');
      return null;
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
          // Settings Route
          GoRoute(
            path: 'settings',
            builder: (context, state) => const PlaceholderPage(
              title: 'Settings',
              route: '/settings',
            ),
          ),
          
          // Human Resources Features
          GoRoute(
            path: 'delegateRole',
            builder: (context, state) => const DelegateRolePage(),
          ),
          GoRoute(
            path: 'delegateRolePage',
            builder: (context, state) => const DelegateRolePage(),
          ),
          GoRoute(
            path: 'employeeSettings',
            builder: (context, state) => const EmployeeSettingsPage(),
          ),
          GoRoute(
            path: 'employee-settings',
            builder: (context, state) => const EmployeeSettingsPage(),
          ),
          GoRoute(
            path: 'employeeSettingsPage',
            builder: (context, state) => const EmployeeSettingsPage(),
          ),
          GoRoute(
            path: 'rolePermissionPage',
            builder: (context, state) => const RolePermissionPage(),
          ),
          GoRoute(
            path: 'timetable',
            builder: (context, state) => const PlaceholderPage(
              title: 'Timetable',
              route: '/timetable',
            ),
          ),
          GoRoute(
            path: 'timetablePage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Timetable',
              route: '/timetablePage',
            ),
          ),
          GoRoute(
            path: 'timetableManage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Timetable Manage',
              route: '/timetableManage',
            ),
          ),
          GoRoute(
            path: 'timetableManagePage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Timetable Manage',
              route: '/timetableManagePage',
            ),
          ),
          GoRoute(
            path: 'attendance',
            builder: (context, state) => const AttendancePage(),
          ),
          GoRoute(
            path: 'attendancePage',
            builder: (context, state) => const AttendancePage(),
          ),
          GoRoute(
            path: 'surveyDashboard',
            builder: (context, state) => const PlaceholderPage(
              title: 'Survey Dashboard',
              route: '/surveyDashboard',
            ),
          ),
          GoRoute(
            path: 'surveyDashboardPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Survey Dashboard',
              route: '/surveyDashboardPage',
            ),
          ),
          GoRoute(
            path: 'contentsHelper',
            builder: (context, state) => const PlaceholderPage(
              title: 'Contents Helper',
              route: '/contentsHelper',
            ),
          ),
          GoRoute(
            path: 'contentsHelperPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Contents Helper',
              route: '/contentsHelperPage',
            ),
          ),
          
          // Finance Features
          GoRoute(
            path: 'accountMapping',
            builder: (context, state) => const PlaceholderPage(
              title: 'Account Mapping',
              route: '/accountMapping',
            ),
          ),
          GoRoute(
            path: 'accountMappingPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Account Mapping',
              route: '/accountMappingPage',
            ),
          ),
          GoRoute(
            path: 'addFixAsset',
            builder: (context, state) => const PlaceholderPage(
              title: 'Add Fix Asset',
              route: '/addFixAsset',
            ),
          ),
          GoRoute(
            path: 'addFixAssetPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Add Fix Asset',
              route: '/addFixAssetPage',
            ),
          ),
          GoRoute(
            path: 'cashEnding',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Ending',
              route: '/cashEnding',
            ),
          ),
          GoRoute(
            path: 'cashEndingPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Ending',
              route: '/cashEndingPage',
            ),
          ),
          GoRoute(
            path: 'journalInput',
            builder: (context, state) => const PlaceholderPage(
              title: 'Journal Input',
              route: '/journalInput',
            ),
          ),
          GoRoute(
            path: 'journalInputPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Journal Input',
              route: '/journalInputPage',
            ),
          ),
          GoRoute(
            path: 'registerCounterparty',
            builder: (context, state) => const PlaceholderPage(
              title: 'Register Counterparty',
              route: '/registerCounterparty',
            ),
          ),
          GoRoute(
            path: 'registerCounterpartyPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Register Counterparty',
              route: '/registerCounterpartyPage',
            ),
          ),
          GoRoute(
            path: 'cashBalance',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Balance',
              route: '/cashBalance',
            ),
          ),
          GoRoute(
            path: 'cashBalancePage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Balance',
              route: '/cashBalancePage',
            ),
          ),
          GoRoute(
            path: 'transactionTemplate',
            builder: (context, state) => const PlaceholderPage(
              title: 'Transaction Template',
              route: '/transactionTemplate',
            ),
          ),
          GoRoute(
            path: 'transactionTemplatePage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Transaction Template',
              route: '/transactionTemplatePage',
            ),
          ),
          GoRoute(
            path: 'cashControl',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Control',
              route: '/cashControl',
            ),
          ),
          GoRoute(
            path: 'cashControlPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Cash Control',
              route: '/cashControlPage',
            ),
          ),
          GoRoute(
            path: 'registerDenomination',
            builder: (context, state) => const PlaceholderPage(
              title: 'Register Denomination',
              route: '/registerDenomination',
            ),
          ),
          GoRoute(
            path: 'registerDenominationPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Register Denomination',
              route: '/registerDenominationPage',
            ),
          ),
          GoRoute(
            path: 'bankVaultEnding',
            builder: (context, state) => const PlaceholderPage(
              title: 'Bank Vault Ending',
              route: '/bankVaultEnding',
            ),
          ),
          GoRoute(
            path: 'bankVaultEndingPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Bank Vault Ending',
              route: '/bankVaultEndingPage',
            ),
          ),
          GoRoute(
            path: 'incomeStatement',
            builder: (context, state) => const PlaceholderPage(
              title: 'Income Statement',
              route: '/incomeStatement',
            ),
          ),
          GoRoute(
            path: 'incomeStatementPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Income Statement',
              route: '/incomeStatementPage',
            ),
          ),
          GoRoute(
            path: 'balanceSheet',
            builder: (context, state) => const PlaceholderPage(
              title: 'Balance Sheet',
              route: '/balanceSheet',
            ),
          ),
          GoRoute(
            path: 'balanceSheetPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Balance Sheet',
              route: '/balanceSheetPage',
            ),
          ),
          GoRoute(
            path: 'transactionHistory',
            builder: (context, state) => const PlaceholderPage(
              title: 'Transaction History',
              route: '/transactionHistory',
            ),
          ),
          GoRoute(
            path: 'transactionHistoryPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Transaction History',
              route: '/transactionHistoryPage',
            ),
          ),
          GoRoute(
            path: 'cashLocation',
            builder: (context, state) => const CashLocationPage(),
          ),
          GoRoute(
            path: 'cashLocationPage',
            builder: (context, state) => const CashLocationPage(),
          ),
          GoRoute(
            path: 'debtControl',
            builder: (context, state) => const PlaceholderPage(
              title: 'Debt Control',
              route: '/debtControl',
            ),
          ),
          GoRoute(
            path: 'debtControlPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Debt Control',
              route: '/debtControlPage',
            ),
          ),
          
          // Store Setting Features
          GoRoute(
            path: 'storeShift',
            builder: (context, state) => const PlaceholderPage(
              title: 'Store Shift',
              route: '/storeShift',
            ),
          ),
          GoRoute(
            path: 'storeShiftPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Store Shift',
              route: '/storeShiftPage',
            ),
          ),
          
          // Setting Features
          GoRoute(
            path: 'test',
            builder: (context, state) => const PlaceholderPage(
              title: 'Test',
              route: '/test',
            ),
          ),
          GoRoute(
            path: 'testPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'Test',
              route: '/testPage',
            ),
          ),
          GoRoute(
            path: 'myPage',
            builder: (context, state) => const PlaceholderPage(
              title: 'My Page',
              route: '/myPage',
            ),
          ),
          GoRoute(
            path: 'myPagePage',
            builder: (context, state) => const PlaceholderPage(
              title: 'My Page',
              route: '/myPagePage',
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Route Error: ${state.error}'),
            const SizedBox(height: 8),
            Text('Location: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
  
  return router;
});