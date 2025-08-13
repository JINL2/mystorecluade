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
import '../pages/employee_setting/enhanced_employee_setting_page.dart';
import '../pages/role_permission/role_permission_page.dart';
import '../pages/delegate_role/delegate_role_page.dart';
import '../pages/timetable/timetable_page.dart';
import '../pages/balance_sheet/balance_sheet_page.dart';
import '../pages/store_shift/store_shift_page.dart';

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
            builder: (context, state) => const EnhancedEmployeeSettingPage(),
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
        ],
      ),
    ],
  );
  
  return router;
});