// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShiftRequest _$ShiftRequestFromJson(Map<String, dynamic> json) {
  return _ShiftRequest.fromJson(json);
}

/// @nodoc
mixin _$ShiftRequest {
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_id')
  String get shiftId => throw _privateConstructorUsedError;
  EmployeeInfo get employee => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_approved')
  bool get isApproved => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;

  /// Serializes this ShiftRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShiftRequestCopyWith<ShiftRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftRequestCopyWith<$Res> {
  factory $ShiftRequestCopyWith(
          ShiftRequest value, $Res Function(ShiftRequest) then) =
      _$ShiftRequestCopyWithImpl<$Res, ShiftRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_id') String shiftId,
      EmployeeInfo employee,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});

  $EmployeeInfoCopyWith<$Res> get employee;
}

/// @nodoc
class _$ShiftRequestCopyWithImpl<$Res, $Val extends ShiftRequest>
    implements $ShiftRequestCopyWith<$Res> {
  _$ShiftRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShiftRequest
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
              as EmployeeInfo,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EmployeeInfoCopyWith<$Res> get employee {
    return $EmployeeInfoCopyWith<$Res>(_value.employee, (value) {
      return _then(_value.copyWith(employee: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ShiftRequestImplCopyWith<$Res>
    implements $ShiftRequestCopyWith<$Res> {
  factory _$$ShiftRequestImplCopyWith(
          _$ShiftRequestImpl value, $Res Function(_$ShiftRequestImpl) then) =
      __$$ShiftRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'shift_request_id') String shiftRequestId,
      @JsonKey(name: 'shift_id') String shiftId,
      EmployeeInfo employee,
      @JsonKey(name: 'is_approved') bool isApproved,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'approved_at') DateTime? approvedAt});

  @override
  $EmployeeInfoCopyWith<$Res> get employee;
}

/// @nodoc
class __$$ShiftRequestImplCopyWithImpl<$Res>
    extends _$ShiftRequestCopyWithImpl<$Res, _$ShiftRequestImpl>
    implements _$$ShiftRequestImplCopyWith<$Res> {
  __$$ShiftRequestImplCopyWithImpl(
      _$ShiftRequestImpl _value, $Res Function(_$ShiftRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShiftRequest
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
    return _then(_$ShiftRequestImpl(
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
              as EmployeeInfo,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftRequestImpl extends _ShiftRequest {
  const _$ShiftRequestImpl(
      {@JsonKey(name: 'shift_request_id') required this.shiftRequestId,
      @JsonKey(name: 'shift_id') required this.shiftId,
      required this.employee,
      @JsonKey(name: 'is_approved') required this.isApproved,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'approved_at') this.approvedAt})
      : super._();

  factory _$ShiftRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftRequestImplFromJson(json);

  @override
  @JsonKey(name: 'shift_request_id')
  final String shiftRequestId;
  @override
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @override
  final EmployeeInfo employee;
  @override
  @JsonKey(name: 'is_approved')
  final bool isApproved;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;

  @override
  String toString() {
    return 'ShiftRequest(shiftRequestId: $shiftRequestId, shiftId: $shiftId, employee: $employee, isApproved: $isApproved, createdAt: $createdAt, approvedAt: $approvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftRequestImpl &&
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

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftRequestImplCopyWith<_$ShiftRequestImpl> get copyWith =>
      __$$ShiftRequestImplCopyWithImpl<_$ShiftRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftRequestImplToJson(
      this,
    );
  }
}

abstract class _ShiftRequest extends ShiftRequest {
  const factory _ShiftRequest(
      {@JsonKey(name: 'shift_request_id') required final String shiftRequestId,
      @JsonKey(name: 'shift_id') required final String shiftId,
      required final EmployeeInfo employee,
      @JsonKey(name: 'is_approved') required final bool isApproved,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'approved_at')
      final DateTime? approvedAt}) = _$ShiftRequestImpl;
  const _ShiftRequest._() : super._();

  factory _ShiftRequest.fromJson(Map<String, dynamic> json) =
      _$ShiftRequestImpl.fromJson;

  @override
  @JsonKey(name: 'shift_request_id')
  String get shiftRequestId;
  @override
  @JsonKey(name: 'shift_id')
  String get shiftId;
  @override
  EmployeeInfo get employee;
  @override
  @JsonKey(name: 'is_approved')
  bool get isApproved;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;

  /// Create a copy of ShiftRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShiftRequestImplCopyWith<_$ShiftRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
