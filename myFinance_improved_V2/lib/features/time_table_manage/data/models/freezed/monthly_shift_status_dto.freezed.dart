// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_shift_status_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MonthlyShiftStatusDto _$MonthlyShiftStatusDtoFromJson(
    Map<String, dynamic> json) {
  return _MonthlyShiftStatusDto.fromJson(json);
}

/// @nodoc
mixin _$MonthlyShiftStatusDto {
// RPC TABLE columns (exact names)
// v4: shift_date (from start_time_utc) instead of request_date
  @JsonKey(name: 'shift_date')
  String get shiftDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_required')
  int get totalRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_approved')
  int get totalApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pending')
  int get totalPending =>
      throw _privateConstructorUsedError; // shifts jsonb array from RPC
  @JsonKey(name: 'shifts')
  List<ShiftWithEmployeesDto> get shifts => throw _privateConstructorUsedError;

  /// Serializes this MonthlyShiftStatusDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyShiftStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyShiftStatusDtoCopyWith<MonthlyShiftStatusDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyShiftStatusDtoCopyWith<$Res> {
  factory $MonthlyShiftStatusDtoCopyWith(MonthlyShiftStatusDto value,
          $Res Function(MonthlyShiftStatusDto) then) =
      _$MonthlyShiftStatusDtoCopyWithImpl<$Res, MonthlyShiftStatusDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'shifts') List<ShiftWithEmployeesDto> shifts});
}

/// @nodoc
class _$MonthlyShiftStatusDtoCopyWithImpl<$Res,
        $Val extends MonthlyShiftStatusDto>
    implements $MonthlyShiftStatusDtoCopyWith<$Res> {
  _$MonthlyShiftStatusDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyShiftStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftDate = null,
    Object? storeId = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? shifts = null,
  }) {
    return _then(_value.copyWith(
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      shifts: null == shifts
          ? _value.shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftWithEmployeesDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyShiftStatusDtoImplCopyWith<$Res>
    implements $MonthlyShiftStatusDtoCopyWith<$Res> {
  factory _$$MonthlyShiftStatusDtoImplCopyWith(
          _$MonthlyShiftStatusDtoImpl value,
          $Res Function(_$MonthlyShiftStatusDtoImpl) then) =
      __$$MonthlyShiftStatusDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_date') String shiftDate,
      @JsonKey(name: 'store_id') String storeId,
      @JsonKey(name: 'total_required') int totalRequired,
      @JsonKey(name: 'total_approved') int totalApproved,
      @JsonKey(name: 'total_pending') int totalPending,
      @JsonKey(name: 'shifts') List<ShiftWithEmployeesDto> shifts});
}

/// @nodoc
class __$$MonthlyShiftStatusDtoImplCopyWithImpl<$Res>
    extends _$MonthlyShiftStatusDtoCopyWithImpl<$Res,
        _$MonthlyShiftStatusDtoImpl>
    implements _$$MonthlyShiftStatusDtoImplCopyWith<$Res> {
  __$$MonthlyShiftStatusDtoImplCopyWithImpl(_$MonthlyShiftStatusDtoImpl _value,
      $Res Function(_$MonthlyShiftStatusDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyShiftStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftDate = null,
    Object? storeId = null,
    Object? totalRequired = null,
    Object? totalApproved = null,
    Object? totalPending = null,
    Object? shifts = null,
  }) {
    return _then(_$MonthlyShiftStatusDtoImpl(
      shiftDate: null == shiftDate
          ? _value.shiftDate
          : shiftDate // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      totalRequired: null == totalRequired
          ? _value.totalRequired
          : totalRequired // ignore: cast_nullable_to_non_nullable
              as int,
      totalApproved: null == totalApproved
          ? _value.totalApproved
          : totalApproved // ignore: cast_nullable_to_non_nullable
              as int,
      totalPending: null == totalPending
          ? _value.totalPending
          : totalPending // ignore: cast_nullable_to_non_nullable
              as int,
      shifts: null == shifts
          ? _value._shifts
          : shifts // ignore: cast_nullable_to_non_nullable
              as List<ShiftWithEmployeesDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyShiftStatusDtoImpl implements _MonthlyShiftStatusDto {
  const _$MonthlyShiftStatusDtoImpl(
      {@JsonKey(name: 'shift_date') required this.shiftDate,
      @JsonKey(name: 'store_id') required this.storeId,
      @JsonKey(name: 'total_required') this.totalRequired = 0,
      @JsonKey(name: 'total_approved') this.totalApproved = 0,
      @JsonKey(name: 'total_pending') this.totalPending = 0,
      @JsonKey(name: 'shifts')
      final List<ShiftWithEmployeesDto> shifts = const []})
      : _shifts = shifts;

  factory _$MonthlyShiftStatusDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyShiftStatusDtoImplFromJson(json);

// RPC TABLE columns (exact names)
// v4: shift_date (from start_time_utc) instead of request_date
  @override
  @JsonKey(name: 'shift_date')
  final String shiftDate;
  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  @JsonKey(name: 'total_required')
  final int totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  final int totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  final int totalPending;
// shifts jsonb array from RPC
  final List<ShiftWithEmployeesDto> _shifts;
// shifts jsonb array from RPC
  @override
  @JsonKey(name: 'shifts')
  List<ShiftWithEmployeesDto> get shifts {
    if (_shifts is EqualUnmodifiableListView) return _shifts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shifts);
  }

  @override
  String toString() {
    return 'MonthlyShiftStatusDto(shiftDate: $shiftDate, storeId: $storeId, totalRequired: $totalRequired, totalApproved: $totalApproved, totalPending: $totalPending, shifts: $shifts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyShiftStatusDtoImpl &&
            (identical(other.shiftDate, shiftDate) ||
                other.shiftDate == shiftDate) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.totalRequired, totalRequired) ||
                other.totalRequired == totalRequired) &&
            (identical(other.totalApproved, totalApproved) ||
                other.totalApproved == totalApproved) &&
            (identical(other.totalPending, totalPending) ||
                other.totalPending == totalPending) &&
            const DeepCollectionEquality().equals(other._shifts, _shifts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftDate,
      storeId,
      totalRequired,
      totalApproved,
      totalPending,
      const DeepCollectionEquality().hash(_shifts));

  /// Create a copy of MonthlyShiftStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyShiftStatusDtoImplCopyWith<_$MonthlyShiftStatusDtoImpl>
      get copyWith => __$$MonthlyShiftStatusDtoImplCopyWithImpl<
          _$MonthlyShiftStatusDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyShiftStatusDtoImplToJson(
      this,
    );
  }
}

abstract class _MonthlyShiftStatusDto implements MonthlyShiftStatusDto {
  const factory _MonthlyShiftStatusDto(
          {@JsonKey(name: 'shift_date') required final String shiftDate,
          @JsonKey(name: 'store_id') required final String storeId,
          @JsonKey(name: 'total_required') final int totalRequired,
          @JsonKey(name: 'total_approved') final int totalApproved,
          @JsonKey(name: 'total_pending') final int totalPending,
          @JsonKey(name: 'shifts') final List<ShiftWithEmployeesDto> shifts}) =
      _$MonthlyShiftStatusDtoImpl;

  factory _MonthlyShiftStatusDto.fromJson(Map<String, dynamic> json) =
      _$MonthlyShiftStatusDtoImpl.fromJson;

// RPC TABLE columns (exact names)
// v4: shift_date (from start_time_utc) instead of request_date
  @override
  @JsonKey(name: 'shift_date')
  String get shiftDate;
  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  @JsonKey(name: 'total_required')
  int get totalRequired;
  @override
  @JsonKey(name: 'total_approved')
  int get totalApproved;
  @override
  @JsonKey(name: 'total_pending')
  int get totalPending; // shifts jsonb array from RPC
  @override
  @JsonKey(name: 'shifts')
  List<ShiftWithEmployeesDto> get shifts;

  /// Create a copy of MonthlyShiftStatusDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyShiftStatusDtoImplCopyWith<_$MonthlyShiftStatusDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ShiftWithEmployeesDto _$ShiftWithEmployeesDtoFromJson(
    Map<String, dynamic> json) {
  return _ShiftWithEmployeesDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftWithEmployeesDto {
// Shift identification
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_name')
  String? get shiftName => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_employees')
  int get requiredEmployees => throw _privateConstructorUsedError; // Counts
  @JsonKey(name: 'approved_count')
  int get approvedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_count')
  int get pendingCount =>
      throw _privateConstructorUsedError; // Employee arrays from RPC nested SELECT
  @JsonKey(name: 'approved_employees')
  List<ShiftEmployeeDto> get approvedEmployees =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_employees')
  List<ShiftEmployeeDto> get pendingEmployees =>
      throw _privateConstructorUsedError;

  /// Serializes this ShiftWithEmployeesDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftWithEmployeesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftWithEmployeesDtoCopyWith<ShiftWithEmployeesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftWithEmployeesDtoCopyWith<$Res> {
  factory $ShiftWithEmployeesDtoCopyWith(ShiftWithEmployeesDto value,
          $Res Function(ShiftWithEmployeesDto) then) =
      _$ShiftWithEmployeesDtoCopyWithImpl<$Res, ShiftWithEmployeesDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'required_employees') int requiredEmployees,
      @JsonKey(name: 'approved_count') int approvedCount,
      @JsonKey(name: 'pending_count') int pendingCount,
      @JsonKey(name: 'approved_employees')
      List<ShiftEmployeeDto> approvedEmployees,
      @JsonKey(name: 'pending_employees')
      List<ShiftEmployeeDto> pendingEmployees});
}

/// @nodoc
class _$ShiftWithEmployeesDtoCopyWithImpl<$Res,
        $Val extends ShiftWithEmployeesDto>
    implements $ShiftWithEmployeesDtoCopyWith<$Res> {
  _$ShiftWithEmployeesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftWithEmployeesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = freezed,
    Object? requiredEmployees = null,
    Object? approvedCount = null,
    Object? pendingCount = null,
    Object? approvedEmployees = null,
    Object? pendingEmployees = null,
  }) {
    return _then(_value.copyWith(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredEmployees: null == requiredEmployees
          ? _value.requiredEmployees
          : requiredEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _value.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedEmployees: null == approvedEmployees
          ? _value.approvedEmployees
          : approvedEmployees // ignore: cast_nullable_to_non_nullable
              as List<ShiftEmployeeDto>,
      pendingEmployees: null == pendingEmployees
          ? _value.pendingEmployees
          : pendingEmployees // ignore: cast_nullable_to_non_nullable
              as List<ShiftEmployeeDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftWithEmployeesDtoImplCopyWith<$Res>
    implements $ShiftWithEmployeesDtoCopyWith<$Res> {
  factory _$$ShiftWithEmployeesDtoImplCopyWith(
          _$ShiftWithEmployeesDtoImpl value,
          $Res Function(_$ShiftWithEmployeesDtoImpl) then) =
      __$$ShiftWithEmployeesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'shift_name') String? shiftName,
      @JsonKey(name: 'required_employees') int requiredEmployees,
      @JsonKey(name: 'approved_count') int approvedCount,
      @JsonKey(name: 'pending_count') int pendingCount,
      @JsonKey(name: 'approved_employees')
      List<ShiftEmployeeDto> approvedEmployees,
      @JsonKey(name: 'pending_employees')
      List<ShiftEmployeeDto> pendingEmployees});
}

/// @nodoc
class __$$ShiftWithEmployeesDtoImplCopyWithImpl<$Res>
    extends _$ShiftWithEmployeesDtoCopyWithImpl<$Res,
        _$ShiftWithEmployeesDtoImpl>
    implements _$$ShiftWithEmployeesDtoImplCopyWith<$Res> {
  __$$ShiftWithEmployeesDtoImplCopyWithImpl(_$ShiftWithEmployeesDtoImpl _value,
      $Res Function(_$ShiftWithEmployeesDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftWithEmployeesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
    Object? shiftName = freezed,
    Object? requiredEmployees = null,
    Object? approvedCount = null,
    Object? pendingCount = null,
    Object? approvedEmployees = null,
    Object? pendingEmployees = null,
  }) {
    return _then(_$ShiftWithEmployeesDtoImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftName: freezed == shiftName
          ? _value.shiftName
          : shiftName // ignore: cast_nullable_to_non_nullable
              as String?,
      requiredEmployees: null == requiredEmployees
          ? _value.requiredEmployees
          : requiredEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      approvedCount: null == approvedCount
          ? _value.approvedCount
          : approvedCount // ignore: cast_nullable_to_non_nullable
              as int,
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      approvedEmployees: null == approvedEmployees
          ? _value._approvedEmployees
          : approvedEmployees // ignore: cast_nullable_to_non_nullable
              as List<ShiftEmployeeDto>,
      pendingEmployees: null == pendingEmployees
          ? _value._pendingEmployees
          : pendingEmployees // ignore: cast_nullable_to_non_nullable
              as List<ShiftEmployeeDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftWithEmployeesDtoImpl implements _ShiftWithEmployeesDto {
  const _$ShiftWithEmployeesDtoImpl(
      {@JsonKey(name: 'shift_id') required this.shiftId,
      @JsonKey(name: 'shift_name') this.shiftName,
      @JsonKey(name: 'required_employees') this.requiredEmployees = 0,
      @JsonKey(name: 'approved_count') this.approvedCount = 0,
      @JsonKey(name: 'pending_count') this.pendingCount = 0,
      @JsonKey(name: 'approved_employees')
      final List<ShiftEmployeeDto> approvedEmployees = const [],
      @JsonKey(name: 'pending_employees')
      final List<ShiftEmployeeDto> pendingEmployees = const []})
      : _approvedEmployees = approvedEmployees,
        _pendingEmployees = pendingEmployees;

  factory _$ShiftWithEmployeesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftWithEmployeesDtoImplFromJson(json);

// Shift identification
  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  @override
  @JsonKey(name: 'required_employees')
  final int requiredEmployees;
// Counts
  @override
  @JsonKey(name: 'approved_count')
  final int approvedCount;
  @override
  @JsonKey(name: 'pending_count')
  final int pendingCount;
// Employee arrays from RPC nested SELECT
  final List<ShiftEmployeeDto> _approvedEmployees;
// Employee arrays from RPC nested SELECT
  @override
  @JsonKey(name: 'approved_employees')
  List<ShiftEmployeeDto> get approvedEmployees {
    if (_approvedEmployees is EqualUnmodifiableListView)
      return _approvedEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_approvedEmployees);
  }

  final List<ShiftEmployeeDto> _pendingEmployees;
  @override
  @JsonKey(name: 'pending_employees')
  List<ShiftEmployeeDto> get pendingEmployees {
    if (_pendingEmployees is EqualUnmodifiableListView)
      return _pendingEmployees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pendingEmployees);
  }

  @override
  String toString() {
    return 'ShiftWithEmployeesDto(shiftId: $shiftId, shiftName: $shiftName, requiredEmployees: $requiredEmployees, approvedCount: $approvedCount, pendingCount: $pendingCount, approvedEmployees: $approvedEmployees, pendingEmployees: $pendingEmployees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftWithEmployeesDtoImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.shiftName, shiftName) ||
                other.shiftName == shiftName) &&
            (identical(other.requiredEmployees, requiredEmployees) ||
                other.requiredEmployees == requiredEmployees) &&
            (identical(other.approvedCount, approvedCount) ||
                other.approvedCount == approvedCount) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            const DeepCollectionEquality()
                .equals(other._approvedEmployees, _approvedEmployees) &&
            const DeepCollectionEquality()
                .equals(other._pendingEmployees, _pendingEmployees));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shiftId,
      shiftName,
      requiredEmployees,
      approvedCount,
      pendingCount,
      const DeepCollectionEquality().hash(_approvedEmployees),
      const DeepCollectionEquality().hash(_pendingEmployees));

  /// Create a copy of ShiftWithEmployeesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftWithEmployeesDtoImplCopyWith<_$ShiftWithEmployeesDtoImpl>
      get copyWith => __$$ShiftWithEmployeesDtoImplCopyWithImpl<
          _$ShiftWithEmployeesDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftWithEmployeesDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftWithEmployeesDto implements ShiftWithEmployeesDto {
  const factory _ShiftWithEmployeesDto(
          {@JsonKey(name: 'shift_id') required final String shiftId,
          @JsonKey(name: 'shift_name') final String? shiftName,
          @JsonKey(name: 'required_employees') final int requiredEmployees,
          @JsonKey(name: 'approved_count') final int approvedCount,
          @JsonKey(name: 'pending_count') final int pendingCount,
          @JsonKey(name: 'approved_employees')
          final List<ShiftEmployeeDto> approvedEmployees,
          @JsonKey(name: 'pending_employees')
          final List<ShiftEmployeeDto> pendingEmployees}) =
      _$ShiftWithEmployeesDtoImpl;

  factory _ShiftWithEmployeesDto.fromJson(Map<String, dynamic> json) =
      _$ShiftWithEmployeesDtoImpl.fromJson;

// Shift identification
  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'shift_name')
  String? get shiftName;
  @override
  @JsonKey(name: 'required_employees')
  int get requiredEmployees; // Counts
  @override
  @JsonKey(name: 'approved_count')
  int get approvedCount;
  @override
  @JsonKey(name: 'pending_count')
  int get pendingCount; // Employee arrays from RPC nested SELECT
  @override
  @JsonKey(name: 'approved_employees')
  List<ShiftEmployeeDto> get approvedEmployees;
  @override
  @JsonKey(name: 'pending_employees')
  List<ShiftEmployeeDto> get pendingEmployees;

  /// Create a copy of ShiftWithEmployeesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftWithEmployeesDtoImplCopyWith<_$ShiftWithEmployeesDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ShiftEmployeeDto _$ShiftEmployeeDtoFromJson(Map<String, dynamic> json) {
  return _ShiftEmployeeDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftEmployeeDto {
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this ShiftEmployeeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftEmployeeDtoCopyWith<ShiftEmployeeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftEmployeeDtoCopyWith<$Res> {
  factory $ShiftEmployeeDtoCopyWith(
          ShiftEmployeeDto value, $Res Function(ShiftEmployeeDto) then) =
      _$ShiftEmployeeDtoCopyWithImpl<$Res, ShiftEmployeeDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'profile_image') String? profileImage});
}

/// @nodoc
class _$ShiftEmployeeDtoCopyWithImpl<$Res, $Val extends ShiftEmployeeDto>
    implements $ShiftEmployeeDtoCopyWith<$Res> {
  _$ShiftEmployeeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? userName = null,
    Object? isApproved = null,
    Object? profileImage = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftEmployeeDtoImplCopyWith<$Res>
    implements $ShiftEmployeeDtoCopyWith<$Res> {
  factory _$$ShiftEmployeeDtoImplCopyWith(_$ShiftEmployeeDtoImpl value,
          $Res Function(_$ShiftEmployeeDtoImpl) then) =
      __$$ShiftEmployeeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'user_name') String userName,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'profile_image') String? profileImage});
}

/// @nodoc
class __$$ShiftEmployeeDtoImplCopyWithImpl<$Res>
    extends _$ShiftEmployeeDtoCopyWithImpl<$Res, _$ShiftEmployeeDtoImpl>
    implements _$$ShiftEmployeeDtoImplCopyWith<$Res> {
  __$$ShiftEmployeeDtoImplCopyWithImpl(_$ShiftEmployeeDtoImpl _value,
      $Res Function(_$ShiftEmployeeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? userId = null,
    Object? userName = null,
    Object? isApproved = null,
    Object? profileImage = freezed,
  }) {
    return _then(_$ShiftEmployeeDtoImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftEmployeeDtoImpl implements _ShiftEmployeeDto {
  const _$ShiftEmployeeDtoImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'user_name') required this.userName,
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'profile_image') this.profileImage});

  factory _$ShiftEmployeeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftEmployeeDtoImplFromJson(json);

  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'user_name')
  final String userName;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @override
  String toString() {
    return 'ShiftEmployeeDto(shiftRequestId: $shiftRequestId, userId: $userId, userName: $userName, isApproved: $isApproved, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftEmployeeDtoImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, shiftRequestId, userId, userName, isApproved, profileImage);

  /// Create a copy of ShiftEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftEmployeeDtoImplCopyWith<_$ShiftEmployeeDtoImpl> get copyWith =>
      __$$ShiftEmployeeDtoImplCopyWithImpl<_$ShiftEmployeeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftEmployeeDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftEmployeeDto implements ShiftEmployeeDto {
  const factory _ShiftEmployeeDto(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'user_name') required final String userName,
      @JsonKey(name: 'is_approved') final bool isApproved,
      @JsonKey(name: 'profile_image')
      final String? profileImage}) = _$ShiftEmployeeDtoImpl;

  factory _ShiftEmployeeDto.fromJson(Map<String, dynamic> json) =
      _$ShiftEmployeeDtoImpl.fromJson;

  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'user_name')
  String get userName;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;

  /// Create a copy of ShiftEmployeeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftEmployeeDtoImplCopyWith<_$ShiftEmployeeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
