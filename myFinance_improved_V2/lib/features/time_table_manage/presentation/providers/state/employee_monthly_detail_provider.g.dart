// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_monthly_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeMonthlyDetailNotifierHash() =>
    r'4fba6a82adedbc8392890f2b2d6dd2d07b4720ce';

/// Employee Monthly Detail Notifier
///
/// Features:
/// - User-month-based caching (key: userId_YYYY-MM)
/// - Debug logging for data loading
/// - Lazy loading with skip logic
///
/// Copied from [EmployeeMonthlyDetailNotifier].
@ProviderFor(EmployeeMonthlyDetailNotifier)
final employeeMonthlyDetailNotifierProvider = AutoDisposeNotifierProvider<
    EmployeeMonthlyDetailNotifier, EmployeeMonthlyDetailState>.internal(
  EmployeeMonthlyDetailNotifier.new,
  name: r'employeeMonthlyDetailNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeMonthlyDetailNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeMonthlyDetailNotifier
    = AutoDisposeNotifier<EmployeeMonthlyDetailState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
