// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeNotifierHash() => r'cc65ad69bf47c2b1839c5f90b111154c5e4a177f';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Employee Notifier - 상태 관리 + UseCase 조율
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
///
/// Hybrid 구조:
/// - 단순 CRUD: Repository 직접 호출 (loadEmployees, searchEmployees)
/// - 복잡한 로직: UseCase 호출 (updateEmployeeSalary)
///
/// Copied from [EmployeeNotifier].
@ProviderFor(EmployeeNotifier)
final employeeNotifierProvider =
    AutoDisposeNotifierProvider<EmployeeNotifier, EmployeeState>.internal(
  EmployeeNotifier.new,
  name: r'employeeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeNotifier = AutoDisposeNotifier<EmployeeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
