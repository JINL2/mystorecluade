// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EmployeeState {
// Data
  List<EmployeeSalary> get employees =>
      throw _privateConstructorUsedError; // Loading states
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUpdatingSalary => throw _privateConstructorUsedError;
  bool get isSyncing => throw _privateConstructorUsedError; // Error handling
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Search & Filter
  String get searchQuery => throw _privateConstructorUsedError;
  String? get selectedRoleFilter => throw _privateConstructorUsedError;
  String? get selectedDepartmentFilter => throw _privateConstructorUsedError;
  String? get selectedSalaryTypeFilter =>
      throw _privateConstructorUsedError; // Sort
  String get sortOption =>
      throw _privateConstructorUsedError; // name, salary, role, recent
  bool get sortAscending => throw _privateConstructorUsedError; // Selection
  EmployeeSalary? get selectedEmployee => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeStateCopyWith<EmployeeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeStateCopyWith<$Res> {
  factory $EmployeeStateCopyWith(
          EmployeeState value, $Res Function(EmployeeState) then) =
      _$EmployeeStateCopyWithImpl<$Res, EmployeeState>;
  @useResult
  $Res call(
      {List<EmployeeSalary> employees,
      bool isLoading,
      bool isUpdatingSalary,
      bool isSyncing,
      String? errorMessage,
      String searchQuery,
      String? selectedRoleFilter,
      String? selectedDepartmentFilter,
      String? selectedSalaryTypeFilter,
      String sortOption,
      bool sortAscending,
      EmployeeSalary? selectedEmployee});
}

/// @nodoc
class _$EmployeeStateCopyWithImpl<$Res, $Val extends EmployeeState>
    implements $EmployeeStateCopyWith<$Res> {
  _$EmployeeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employees = null,
    Object? isLoading = null,
    Object? isUpdatingSalary = null,
    Object? isSyncing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = null,
    Object? selectedRoleFilter = freezed,
    Object? selectedDepartmentFilter = freezed,
    Object? selectedSalaryTypeFilter = freezed,
    Object? sortOption = null,
    Object? sortAscending = null,
    Object? selectedEmployee = freezed,
  }) {
    return _then(_value.copyWith(
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeSalary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdatingSalary: null == isUpdatingSalary
          ? _value.isUpdatingSalary
          : isUpdatingSalary // ignore: cast_nullable_to_non_nullable
              as bool,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedRoleFilter: freezed == selectedRoleFilter
          ? _value.selectedRoleFilter
          : selectedRoleFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDepartmentFilter: freezed == selectedDepartmentFilter
          ? _value.selectedDepartmentFilter
          : selectedDepartmentFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSalaryTypeFilter: freezed == selectedSalaryTypeFilter
          ? _value.selectedSalaryTypeFilter
          : selectedSalaryTypeFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOption: null == sortOption
          ? _value.sortOption
          : sortOption // ignore: cast_nullable_to_non_nullable
              as String,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedEmployee: freezed == selectedEmployee
          ? _value.selectedEmployee
          : selectedEmployee // ignore: cast_nullable_to_non_nullable
              as EmployeeSalary?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeStateImplCopyWith<$Res>
    implements $EmployeeStateCopyWith<$Res> {
  factory _$$EmployeeStateImplCopyWith(
          _$EmployeeStateImpl value, $Res Function(_$EmployeeStateImpl) then) =
      __$$EmployeeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<EmployeeSalary> employees,
      bool isLoading,
      bool isUpdatingSalary,
      bool isSyncing,
      String? errorMessage,
      String searchQuery,
      String? selectedRoleFilter,
      String? selectedDepartmentFilter,
      String? selectedSalaryTypeFilter,
      String sortOption,
      bool sortAscending,
      EmployeeSalary? selectedEmployee});
}

/// @nodoc
class __$$EmployeeStateImplCopyWithImpl<$Res>
    extends _$EmployeeStateCopyWithImpl<$Res, _$EmployeeStateImpl>
    implements _$$EmployeeStateImplCopyWith<$Res> {
  __$$EmployeeStateImplCopyWithImpl(
      _$EmployeeStateImpl _value, $Res Function(_$EmployeeStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EmployeeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employees = null,
    Object? isLoading = null,
    Object? isUpdatingSalary = null,
    Object? isSyncing = null,
    Object? errorMessage = freezed,
    Object? searchQuery = null,
    Object? selectedRoleFilter = freezed,
    Object? selectedDepartmentFilter = freezed,
    Object? selectedSalaryTypeFilter = freezed,
    Object? sortOption = null,
    Object? sortAscending = null,
    Object? selectedEmployee = freezed,
  }) {
    return _then(_$EmployeeStateImpl(
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeSalary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdatingSalary: null == isUpdatingSalary
          ? _value.isUpdatingSalary
          : isUpdatingSalary // ignore: cast_nullable_to_non_nullable
              as bool,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      selectedRoleFilter: freezed == selectedRoleFilter
          ? _value.selectedRoleFilter
          : selectedRoleFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDepartmentFilter: freezed == selectedDepartmentFilter
          ? _value.selectedDepartmentFilter
          : selectedDepartmentFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSalaryTypeFilter: freezed == selectedSalaryTypeFilter
          ? _value.selectedSalaryTypeFilter
          : selectedSalaryTypeFilter // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOption: null == sortOption
          ? _value.sortOption
          : sortOption // ignore: cast_nullable_to_non_nullable
              as String,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedEmployee: freezed == selectedEmployee
          ? _value.selectedEmployee
          : selectedEmployee // ignore: cast_nullable_to_non_nullable
              as EmployeeSalary?,
    ));
  }
}

/// @nodoc

class _$EmployeeStateImpl implements _EmployeeState {
  const _$EmployeeStateImpl(
      {final List<EmployeeSalary> employees = const [],
      this.isLoading = false,
      this.isUpdatingSalary = false,
      this.isSyncing = false,
      this.errorMessage,
      this.searchQuery = '',
      this.selectedRoleFilter,
      this.selectedDepartmentFilter,
      this.selectedSalaryTypeFilter,
      this.sortOption = 'name',
      this.sortAscending = true,
      this.selectedEmployee})
      : _employees = employees;

// Data
  final List<EmployeeSalary> _employees;
// Data
  @override
  @JsonKey()
  List<EmployeeSalary> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

// Loading states
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUpdatingSalary;
  @override
  @JsonKey()
  final bool isSyncing;
// Error handling
  @override
  final String? errorMessage;
// Search & Filter
  @override
  @JsonKey()
  final String searchQuery;
  @override
  final String? selectedRoleFilter;
  @override
  final String? selectedDepartmentFilter;
  @override
  final String? selectedSalaryTypeFilter;
// Sort
  @override
  @JsonKey()
  final String sortOption;
// name, salary, role, recent
  @override
  @JsonKey()
  final bool sortAscending;
// Selection
  @override
  final EmployeeSalary? selectedEmployee;

  @override
  String toString() {
    return 'EmployeeState(employees: $employees, isLoading: $isLoading, isUpdatingSalary: $isUpdatingSalary, isSyncing: $isSyncing, errorMessage: $errorMessage, searchQuery: $searchQuery, selectedRoleFilter: $selectedRoleFilter, selectedDepartmentFilter: $selectedDepartmentFilter, selectedSalaryTypeFilter: $selectedSalaryTypeFilter, sortOption: $sortOption, sortAscending: $sortAscending, selectedEmployee: $selectedEmployee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeStateImpl &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUpdatingSalary, isUpdatingSalary) ||
                other.isUpdatingSalary == isUpdatingSalary) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.selectedRoleFilter, selectedRoleFilter) ||
                other.selectedRoleFilter == selectedRoleFilter) &&
            (identical(
                    other.selectedDepartmentFilter, selectedDepartmentFilter) ||
                other.selectedDepartmentFilter == selectedDepartmentFilter) &&
            (identical(
                    other.selectedSalaryTypeFilter, selectedSalaryTypeFilter) ||
                other.selectedSalaryTypeFilter == selectedSalaryTypeFilter) &&
            (identical(other.sortOption, sortOption) ||
                other.sortOption == sortOption) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending) &&
            (identical(other.selectedEmployee, selectedEmployee) ||
                other.selectedEmployee == selectedEmployee));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_employees),
      isLoading,
      isUpdatingSalary,
      isSyncing,
      errorMessage,
      searchQuery,
      selectedRoleFilter,
      selectedDepartmentFilter,
      selectedSalaryTypeFilter,
      sortOption,
      sortAscending,
      selectedEmployee);

  /// Create a copy of EmployeeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeStateImplCopyWith<_$EmployeeStateImpl> get copyWith =>
      __$$EmployeeStateImplCopyWithImpl<_$EmployeeStateImpl>(this, _$identity);
}

abstract class _EmployeeState implements EmployeeState {
  const factory _EmployeeState(
      {final List<EmployeeSalary> employees,
      final bool isLoading,
      final bool isUpdatingSalary,
      final bool isSyncing,
      final String? errorMessage,
      final String searchQuery,
      final String? selectedRoleFilter,
      final String? selectedDepartmentFilter,
      final String? selectedSalaryTypeFilter,
      final String sortOption,
      final bool sortAscending,
      final EmployeeSalary? selectedEmployee}) = _$EmployeeStateImpl;

// Data
  @override
  List<EmployeeSalary> get employees; // Loading states
  @override
  bool get isLoading;
  @override
  bool get isUpdatingSalary;
  @override
  bool get isSyncing; // Error handling
  @override
  String? get errorMessage; // Search & Filter
  @override
  String get searchQuery;
  @override
  String? get selectedRoleFilter;
  @override
  String? get selectedDepartmentFilter;
  @override
  String? get selectedSalaryTypeFilter; // Sort
  @override
  String get sortOption; // name, salary, role, recent
  @override
  bool get sortAscending; // Selection
  @override
  EmployeeSalary? get selectedEmployee;

  /// Create a copy of EmployeeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeStateImplCopyWith<_$EmployeeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
