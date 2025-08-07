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

final simpleRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePageRedesigned(),
      ),
      GoRoute(
        path: '/employee-settings',
        builder: (context, state) => const EmployeeSettingsPage(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupPage(),
      ),
    ],
  );
});