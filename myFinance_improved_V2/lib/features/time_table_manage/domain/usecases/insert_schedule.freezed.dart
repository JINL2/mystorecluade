// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insert_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InsertScheduleParams {
  String get userId => throw _privateConstructorUsedError;
  String get shiftId => throw _privateConstructorUsedError;
  String get storeId => throw _privateConstructorUsedError;
  String get requestDate => throw _privateConstructorUsedError;
  String get approvedBy => throw _privateConstructorUsedError;

  /// Create a copy of InsertScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsertScheduleParamsCopyWith<InsertScheduleParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsertScheduleParamsCopyWith<$Res> {
  factory $InsertScheduleParamsCopyWith(InsertScheduleParams value,
          $Res Function(InsertScheduleParams) then) =
      _$InsertScheduleParamsCopyWithImpl<$Res, InsertScheduleParams>;
  @useResult
  $Res call(
      {String userId,
      String shiftId,
      String storeId,
      String requestDate,
      String approvedBy});
}

/// @nodoc
class _$InsertScheduleParamsCopyWithImpl<$Res,
        $Val extends InsertScheduleParams>
    implements $InsertScheduleParamsCopyWith<$Res> {
  _$InsertScheduleParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsertScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? shiftId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? approvedBy = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: null == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InsertScheduleParamsImplCopyWith<$Res>
    implements $InsertScheduleParamsCopyWith<$Res> {
  factory _$$InsertScheduleParamsImplCopyWith(_$InsertScheduleParamsImpl value,
          $Res Function(_$InsertScheduleParamsImpl) then) =
      __$$InsertScheduleParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String shiftId,
      String storeId,
      String requestDate,
      String approvedBy});
}

/// @nodoc
class __$$InsertScheduleParamsImplCopyWithImpl<$Res>
    extends _$InsertScheduleParamsCopyWithImpl<$Res, _$InsertScheduleParamsImpl>
    implements _$$InsertScheduleParamsImplCopyWith<$Res> {
  __$$InsertScheduleParamsImplCopyWithImpl(_$InsertScheduleParamsImpl _value,
      $Res Function(_$InsertScheduleParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of InsertScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? shiftId = null,
    Object? storeId = null,
    Object? requestDate = null,
    Object? approvedBy = null,
  }) {
    return _then(_$InsertScheduleParamsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      requestDate: null == requestDate
          ? _value.requestDate
          : requestDate // ignore: cast_nullable_to_non_nullable
              as String,
      approvedBy: null == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$InsertScheduleParamsImpl implements _InsertScheduleParams {
  const _$InsertScheduleParamsImpl(
      {required this.userId,
      required this.shiftId,
      required this.storeId,
      required this.requestDate,
      required this.approvedBy});

  @override
  final String userId;
  @override
  final String shiftId;
  @override
  final String storeId;
  @override
  final String requestDate;
  @override
  final String approvedBy;

  @override
  String toString() {
    return 'InsertScheduleParams(userId: $userId, shiftId: $shiftId, storeId: $storeId, requestDate: $requestDate, approvedBy: $approvedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsertScheduleParamsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.requestDate, requestDate) ||
                other.requestDate == requestDate) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, userId, shiftId, storeId, requestDate, approvedBy);

  /// Create a copy of InsertScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsertScheduleParamsImplCopyWith<_$InsertScheduleParamsImpl>
      get copyWith =>
          __$$InsertScheduleParamsImplCopyWithImpl<_$InsertScheduleParamsImpl>(
              this, _$identity);
}

abstract class _InsertScheduleParams implements InsertScheduleParams {
  const factory _InsertScheduleParams(
      {required final String userId,
      required final String shiftId,
      required final String storeId,
      required final String requestDate,
      required final String approvedBy}) = _$InsertScheduleParamsImpl;

  @override
  String get userId;
  @override
  String get shiftId;
  @override
  String get storeId;
  @override
  String get requestDate;
  @override
  String get approvedBy;

  /// Create a copy of InsertScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsertScheduleParamsImplCopyWith<_$InsertScheduleParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
