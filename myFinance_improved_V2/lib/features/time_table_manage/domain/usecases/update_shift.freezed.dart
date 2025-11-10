// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_shift.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateShiftParams {
  String get shiftRequestId => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  bool? get isProblemSolved => throw _privateConstructorUsedError;

  /// Create a copy of UpdateShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateShiftParamsCopyWith<UpdateShiftParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateShiftParamsCopyWith<$Res> {
  factory $UpdateShiftParamsCopyWith(
          UpdateShiftParams value, $Res Function(UpdateShiftParams) then) =
      _$UpdateShiftParamsCopyWithImpl<$Res, UpdateShiftParams>;
  @useResult
  $Res call(
      {String shiftRequestId,
      String? startTime,
      String? endTime,
      bool? isProblemSolved});
}

/// @nodoc
class _$UpdateShiftParamsCopyWithImpl<$Res, $Val extends UpdateShiftParams>
    implements $UpdateShiftParamsCopyWith<$Res> {
  _$UpdateShiftParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? isProblemSolved = freezed,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isProblemSolved: freezed == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateShiftParamsImplCopyWith<$Res>
    implements $UpdateShiftParamsCopyWith<$Res> {
  factory _$$UpdateShiftParamsImplCopyWith(_$UpdateShiftParamsImpl value,
          $Res Function(_$UpdateShiftParamsImpl) then) =
      __$$UpdateShiftParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String shiftRequestId,
      String? startTime,
      String? endTime,
      bool? isProblemSolved});
}

/// @nodoc
class __$$UpdateShiftParamsImplCopyWithImpl<$Res>
    extends _$UpdateShiftParamsCopyWithImpl<$Res, _$UpdateShiftParamsImpl>
    implements _$$UpdateShiftParamsImplCopyWith<$Res> {
  __$$UpdateShiftParamsImplCopyWithImpl(_$UpdateShiftParamsImpl _value,
      $Res Function(_$UpdateShiftParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? isProblemSolved = freezed,
  }) {
    return _then(_$UpdateShiftParamsImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      isProblemSolved: freezed == isProblemSolved
          ? _value.isProblemSolved
          : isProblemSolved // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$UpdateShiftParamsImpl implements _UpdateShiftParams {
  const _$UpdateShiftParamsImpl(
      {required this.shiftRequestId,
      this.startTime,
      this.endTime,
      this.isProblemSolved});

  @override
  final String shiftRequestId;
  @override
  final String? startTime;
  @override
  final String? endTime;
  @override
  final bool? isProblemSolved;

  @override
  String toString() {
    return 'UpdateShiftParams(shiftRequestId: $shiftRequestId, startTime: $startTime, endTime: $endTime, isProblemSolved: $isProblemSolved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateShiftParamsImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isProblemSolved, isProblemSolved) ||
                other.isProblemSolved == isProblemSolved));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, shiftRequestId, startTime, endTime, isProblemSolved);

  /// Create a copy of UpdateShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateShiftParamsImplCopyWith<_$UpdateShiftParamsImpl> get copyWith =>
      __$$UpdateShiftParamsImplCopyWithImpl<_$UpdateShiftParamsImpl>(
          this, _$identity);
}

abstract class _UpdateShiftParams implements UpdateShiftParams {
  const factory _UpdateShiftParams(
      {required final String shiftRequestId,
      final String? startTime,
      final String? endTime,
      final bool? isProblemSolved}) = _$UpdateShiftParamsImpl;

  @override
  String get shiftRequestId;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override
  bool? get isProblemSolved;

  /// Create a copy of UpdateShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateShiftParamsImplCopyWith<_$UpdateShiftParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
