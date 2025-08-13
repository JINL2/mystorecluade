import 'package:go_router/go_router.dart';
import 'employee_setting_page.dart';

/// Route configuration for Employee Setting page
/// 
/// Add this to your main router configuration:
/// ```dart
/// GoRoute(
///   path: EmployeeSettingRoute.path,
///   name: EmployeeSettingRoute.name,
///   builder: (context, state) => const EmployeeSettingPage(),
/// ),
/// ```
class EmployeeSettingRoute {
  static const String path = '/employee-setting';
  static const String name = 'employeeSetting';
  
  static void go(context) => context.go(path);
  static void push(context) => context.push(path);
}