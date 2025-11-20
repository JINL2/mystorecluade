// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftRequestDto _$ShiftRequestDtoFromJson(Map<String, dynamic> json) {
  return _ShiftRequestDto.fromJson(json);
}

/// @nodoc
mixin _$ShiftRequestDto {
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  @JsonKey(name: 'employee')
  EmployeeInfoDto get employee => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  String? get approvedAt => throw _privateConstructorUsedError;

  /// Serializes this ShiftRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftRequestDtoCopyWith<ShiftRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftRequestDtoCopyWith<$Res> {
  factory $ShiftRequestDtoCopyWith(
          ShiftRequestDto value, $Res Function(ShiftRequestDto) then) =
      _$ShiftRequestDtoCopyWithImpl<$Res, ShiftRequestDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'employee') EmployeeInfoDto employee,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'approved_at') String? approvedAt});

  $EmployeeInfoDtoCopyWith<$Res> get employee;
}

/// @nodoc
class _$ShiftRequestDtoCopyWithImpl<$Res, $Val extends ShiftRequestDto>
    implements $ShiftRequestDtoCopyWith<$Res> {
  _$ShiftRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? shiftId = null,
    Object? employee = null,
    Object? isApproved = null,
    Object? createdAt = null,
    Object? approvedAt = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoDto,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoDtoCopyWith<$Res> get employee {
    return $EmployeeInfoDtoCopyWith<$Res>(_value.employee, (value) {
      return _then(_value.copyWith(employee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftRequestDtoImplCopyWith<$Res>
    implements $ShiftRequestDtoCopyWith<$Res> {
  factory _$$ShiftRequestDtoImplCopyWith(_$ShiftRequestDtoImpl value,
          $Res Function(_$ShiftRequestDtoImpl) then) =
      __$$ShiftRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_id') String shiftId,
      @JsonKey(name: 'employee') EmployeeInfoDto employee,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'approved_at') String? approvedAt});

  @override
  $EmployeeInfoDtoCopyWith<$Res> get employee;
}

/// @nodoc
class __$$ShiftRequestDtoImplCopyWithImpl<$Res>
    extends _$ShiftRequestDtoCopyWithImpl<$Res, _$ShiftRequestDtoImpl>
    implements _$$ShiftRequestDtoImplCopyWith<$Res> {
  __$$ShiftRequestDtoImplCopyWithImpl(
      _$ShiftRequestDtoImpl _value, $Res Function(_$ShiftRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? shiftId = null,
    Object? employee = null,
    Object? isApproved = null,
    Object? createdAt = null,
    Object? approvedAt = freezed,
  }) {
    return _then(_$ShiftRequestDtoImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      employee: null == employee
          ? _value.employee
          : employee // ignore: cast_nullable_to_non_nullable
              as EmployeeInfoDto,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftRequestDtoImpl implements _ShiftRequestDto {
  const _$ShiftRequestDtoImpl(
      {@JsonKey(name: 'shift_request_id') this.shiftRequestId = '',
      @JsonKey(name: 'shift_id') this.shiftId = '',
      @JsonKey(name: 'employee') required this.employee,
      @JsonKey(name: 'is_approved') this.isApproved = false,
      @JsonKey(name: 'created_at') this.createdAt = '',
      @JsonKey(name: 'approved_at') this.approvedAt});

  factory _$ShiftRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftRequestDtoImplFromJson(json);

  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  @JsonKey(name: 'employee')
  final EmployeeInfoDto employee;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'approved_at')
  final String? approvedAt;

  @override
  String toString() {
    return 'ShiftRequestDto(shiftRequestId: $shiftRequestId, shiftId: $shiftId, employee: $employee, isApproved: $isApproved, createdAt: $createdAt, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftRequestDtoImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.employee, employee) ||
                other.employee == employee) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, shiftRequestId, shiftId,
      employee, isApproved, createdAt, approvedAt);

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftRequestDtoImplCopyWith<_$ShiftRequestDtoImpl> get copyWith =>
      __$$ShiftRequestDtoImplCopyWithImpl<_$ShiftRequestDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _ShiftRequestDto implements ShiftRequestDto {
  const factory _ShiftRequestDto(
          {@JsonKey(name: 'shift_request_id') final String shiftRequestId,
          @JsonKey(name: 'shift_id') final String shiftId,
          @JsonKey(name: 'employee') required final EmployeeInfoDto employee,
          @JsonKey(name: 'is_approved') final bool isApproved,
          @JsonKey(name: 'created_at') final String createdAt,
          @JsonKey(name: 'approved_at') final String? approvedAt}) =
      _$ShiftRequestDtoImpl;

  factory _ShiftRequestDto.fromJson(Map<String, dynamic> json) =
      _$ShiftRequestDtoImpl.fromJson;

  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  @JsonKey(name: 'employee')
  EmployeeInfoDto get employee;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'approved_at')
  String? get approvedAt;

  /// Create a copy of ShiftRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftRequestDtoImplCopyWith<_$ShiftRequestDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
