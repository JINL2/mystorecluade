// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$employeeShiftAuditLogsHash() =>
    r'd0d3bcdcdd54852e51b5b4e33ce5fdac8c54b706';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Employee Shift Audit Logs Provider with pagination support
///
/// Uses RPC: employee_setting_get_employee_shift_audit_logs
/// Returns ShiftAuditLogsResult with logs and pagination metadata
///
/// Copied from [employeeShiftAuditLogs].
@ProviderFor(employeeShiftAuditLogs)
const employeeShiftAuditLogsProvider = EmployeeShiftAuditLogsFamily();

/// Employee Shift Audit Logs Provider with pagination support
///
/// Uses RPC: employee_setting_get_employee_shift_audit_logs
/// Returns ShiftAuditLogsResult with logs and pagination metadata
///
/// Copied from [employeeShiftAuditLogs].
class EmployeeShiftAuditLogsFamily
    extends Family<AsyncValue<ShiftAuditLogsResult>> {
  /// Employee Shift Audit Logs Provider with pagination support
  ///
  /// Uses RPC: employee_setting_get_employee_shift_audit_logs
  /// Returns ShiftAuditLogsResult with logs and pagination metadata
  ///
  /// Copied from [employeeShiftAuditLogs].
  const EmployeeShiftAuditLogsFamily();

  /// Employee Shift Audit Logs Provider with pagination support
  ///
  /// Uses RPC: employee_setting_get_employee_shift_audit_logs
  /// Returns ShiftAuditLogsResult with logs and pagination metadata
  ///
  /// Copied from [employeeShiftAuditLogs].
  EmployeeShiftAuditLogsProvider call(
    EmployeeAuditLogParams params,
  ) {
    return EmployeeShiftAuditLogsProvider(
      params,
    );
  }

  @override
  EmployeeShiftAuditLogsProvider getProviderOverride(
    covariant EmployeeShiftAuditLogsProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'employeeShiftAuditLogsProvider';
}

/// Employee Shift Audit Logs Provider with pagination support
///
/// Uses RPC: employee_setting_get_employee_shift_audit_logs
/// Returns ShiftAuditLogsResult with logs and pagination metadata
///
/// Copied from [employeeShiftAuditLogs].
class EmployeeShiftAuditLogsProvider
    extends AutoDisposeFutureProvider<ShiftAuditLogsResult> {
  /// Employee Shift Audit Logs Provider with pagination support
  ///
  /// Uses RPC: employee_setting_get_employee_shift_audit_logs
  /// Returns ShiftAuditLogsResult with logs and pagination metadata
  ///
  /// Copied from [employeeShiftAuditLogs].
  EmployeeShiftAuditLogsProvider(
    EmployeeAuditLogParams params,
  ) : this._internal(
          (ref) => employeeShiftAuditLogs(
            ref as EmployeeShiftAuditLogsRef,
            params,
          ),
          from: employeeShiftAuditLogsProvider,
          name: r'employeeShiftAuditLogsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$employeeShiftAuditLogsHash,
          dependencies: EmployeeShiftAuditLogsFamily._dependencies,
          allTransitiveDependencies:
              EmployeeShiftAuditLogsFamily._allTransitiveDependencies,
          params: params,
        );

  EmployeeShiftAuditLogsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final EmployeeAuditLogParams params;

  @override
  Override overrideWith(
    FutureOr<ShiftAuditLogsResult> Function(EmployeeShiftAuditLogsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EmployeeShiftAuditLogsProvider._internal(
        (ref) => create(ref as EmployeeShiftAuditLogsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ShiftAuditLogsResult> createElement() {
    return _EmployeeShiftAuditLogsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EmployeeShiftAuditLogsProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EmployeeShiftAuditLogsRef
    on AutoDisposeFutureProviderRef<ShiftAuditLogsResult> {
  /// The parameter `params` of this provider.
  EmployeeAuditLogParams get params;
}

class _EmployeeShiftAuditLogsProviderElement
    extends AutoDisposeFutureProviderElement<ShiftAuditLogsResult>
    with EmployeeShiftAuditLogsRef {
  _EmployeeShiftAuditLogsProviderElement(super.provider);

  @override
  EmployeeAuditLogParams get params =>
      (origin as EmployeeShiftAuditLogsProvider).params;
}

String _$filteredEmployeesHash() => r'6eb179b1cbed22b63fb5ae632838ec6959f9fe89';

/// See also [filteredEmployees].
@ProviderFor(filteredEmployees)
final filteredEmployeesProvider =
    AutoDisposeProvider<AsyncValue<List<EmployeeSalary>>>.internal(
  filteredEmployees,
  name: r'filteredEmployeesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredEmployeesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredEmployeesRef
    = AutoDisposeProviderRef<AsyncValue<List<EmployeeSalary>>>;
String _$assignWorkScheduleTemplateHash() =>
    r'd6fb41a00f6d871398f7f4d7d935279074dda1b2';

/// Assign or unassign a work schedule template to an employee
///
/// Uses RPC: employee_setting_assign_work_schedule_template
/// - Owner-only permission (companies.owner_id = auth.uid())
/// - Pass null for templateId to unassign the current template
/// - Returns warning for non-monthly salary types
///
/// Copied from [assignWorkScheduleTemplate].
@ProviderFor(assignWorkScheduleTemplate)
final assignWorkScheduleTemplateProvider = AutoDisposeProvider<
    Future<WorkScheduleAssignResult> Function(
        {required String employeeUserId, String? templateId})>.internal(
  assignWorkScheduleTemplate,
  name: r'assignWorkScheduleTemplateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$assignWorkScheduleTemplateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssignWorkScheduleTemplateRef = AutoDisposeProviderRef<
    Future<WorkScheduleAssignResult> Function(
        {required String employeeUserId, String? templateId})>;
String _$mutableEmployeeListHash() =>
    r'06b0aeb4fd5b02a08c4ce67a25db40b4b144904a';

/// Mutable Employee List Notifier for instant updates
///
/// Copied from [MutableEmployeeList].
@ProviderFor(MutableEmployeeList)
final mutableEmployeeListProvider = AutoDisposeNotifierProvider<
    MutableEmployeeList, List<EmployeeSalary>?>.internal(
  MutableEmployeeList.new,
  name: r'mutableEmployeeListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mutableEmployeeListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MutableEmployeeList = AutoDisposeNotifier<List<EmployeeSalary>?>;
String _$employeeSearchQueryHash() =>
    r'eb77bc215b2b4d7c7a334c6bdc4039a9a3b69626';

/// Search Query Notifier
///
/// Copied from [EmployeeSearchQuery].
@ProviderFor(EmployeeSearchQuery)
final employeeSearchQueryProvider =
    AutoDisposeNotifierProvider<EmployeeSearchQuery, String>.internal(
  EmployeeSearchQuery.new,
  name: r'employeeSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeSearchQuery = AutoDisposeNotifier<String>;
String _$employeeSortOptionHash() =>
    r'ab7847ac6fffaccd244739e77ae063c81d898017';

/// Sort Option Notifier
///
/// Copied from [EmployeeSortOption].
@ProviderFor(EmployeeSortOption)
final employeeSortOptionProvider =
    AutoDisposeNotifierProvider<EmployeeSortOption, String>.internal(
  EmployeeSortOption.new,
  name: r'employeeSortOptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeSortOptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeSortOption = AutoDisposeNotifier<String>;
String _$employeeSortDirectionHash() =>
    r'7656919c0e80f2b54112e8950d3de7944b2acb4a';

/// Sort Direction Notifier - true for ascending, false for descending
///
/// Copied from [EmployeeSortDirection].
@ProviderFor(EmployeeSortDirection)
final employeeSortDirectionProvider =
    AutoDisposeNotifierProvider<EmployeeSortDirection, bool>.internal(
  EmployeeSortDirection.new,
  name: r'employeeSortDirectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$employeeSortDirectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EmployeeSortDirection = AutoDisposeNotifier<bool>;
String _$selectedRoleFilterHash() =>
    r'3fbb9a5ac863b1ce5706a3c213ba17b401ad7149';

/// Role Filter Notifier
///
/// Copied from [SelectedRoleFilter].
@ProviderFor(SelectedRoleFilter)
final selectedRoleFilterProvider =
    AutoDisposeNotifierProvider<SelectedRoleFilter, String?>.internal(
  SelectedRoleFilter.new,
  name: r'selectedRoleFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRoleFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRoleFilter = AutoDisposeNotifier<String?>;
String _$selectedDepartmentFilterHash() =>
    r'b74660559cdc6ffce50301d1925fcceaa14e4dc0';

/// Department Filter Notifier
///
/// Copied from [SelectedDepartmentFilter].
@ProviderFor(SelectedDepartmentFilter)
final selectedDepartmentFilterProvider =
    AutoDisposeNotifierProvider<SelectedDepartmentFilter, String?>.internal(
  SelectedDepartmentFilter.new,
  name: r'selectedDepartmentFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDepartmentFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedDepartmentFilter = AutoDisposeNotifier<String?>;
String _$selectedSalaryTypeFilterHash() =>
    r'd486663f912bef86f38720e82c71f7e72aec8e09';

/// Salary Type Filter Notifier
///
/// Copied from [SelectedSalaryTypeFilter].
@ProviderFor(SelectedSalaryTypeFilter)
final selectedSalaryTypeFilterProvider =
    AutoDisposeNotifierProvider<SelectedSalaryTypeFilter, String?>.internal(
  SelectedSalaryTypeFilter.new,
  name: r'selectedSalaryTypeFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSalaryTypeFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSalaryTypeFilter = AutoDisposeNotifier<String?>;
String _$isUpdatingSalaryHash() => r'45c33df8d54bc25b3916fee42c1204464001afa4';

/// Loading State Notifier for salary updates
///
/// Copied from [IsUpdatingSalary].
@ProviderFor(IsUpdatingSalary)
final isUpdatingSalaryProvider =
    AutoDisposeNotifierProvider<IsUpdatingSalary, bool>.internal(
  IsUpdatingSalary.new,
  name: r'isUpdatingSalaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isUpdatingSalaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsUpdatingSalary = AutoDisposeNotifier<bool>;
String _$isSyncingHash() => r'7d245ca47f176a35a2395d0fa08db90f2f269f64';

/// Sync State Notifier
///
/// Copied from [IsSyncing].
@ProviderFor(IsSyncing)
final isSyncingProvider = AutoDisposeNotifierProvider<IsSyncing, bool>.internal(
  IsSyncing.new,
  name: r'isSyncingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isSyncingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsSyncing = AutoDisposeNotifier<bool>;
String _$selectedEmployeeHash() => r'1ad5509253e9dd78c58746cc6ef8f5fc80f5e713';

/// Selected Employee Notifier
///
/// Copied from [SelectedEmployee].
@ProviderFor(SelectedEmployee)
final selectedEmployeeProvider =
    AutoDisposeNotifierProvider<SelectedEmployee, EmployeeSalary?>.internal(
  SelectedEmployee.new,
  name: r'selectedEmployeeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedEmployeeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedEmployee = AutoDisposeNotifier<EmployeeSalary?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
