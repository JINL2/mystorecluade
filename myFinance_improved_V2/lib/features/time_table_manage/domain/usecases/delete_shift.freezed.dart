// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_shift.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DeleteShiftParams {
  String get shiftId => throw _privateConstructorUsedError;

  /// Create a copy of DeleteShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeleteShiftParamsCopyWith<DeleteShiftParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeleteShiftParamsCopyWith<$Res> {
  factory $DeleteShiftParamsCopyWith(
          DeleteShiftParams value, $Res Function(DeleteShiftParams) then) =
      _$DeleteShiftParamsCopyWithImpl<$Res, DeleteShiftParams>;
  @useResult
  $Res call({String shiftId});
}

/// @nodoc
class _$DeleteShiftParamsCopyWithImpl<$Res, $Val extends DeleteShiftParams>
    implements $DeleteShiftParamsCopyWith<$Res> {
  _$DeleteShiftParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeleteShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
  }) {
    return _then(_value.copyWith(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeleteShiftParamsImplCopyWith<$Res>
    implements $DeleteShiftParamsCopyWith<$Res> {
  factory _$$DeleteShiftParamsImplCopyWith(_$DeleteShiftParamsImpl value,
          $Res Function(_$DeleteShiftParamsImpl) then) =
      __$$DeleteShiftParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String shiftId});
}

/// @nodoc
class __$$DeleteShiftParamsImplCopyWithImpl<$Res>
    extends _$DeleteShiftParamsCopyWithImpl<$Res, _$DeleteShiftParamsImpl>
    implements _$$DeleteShiftParamsImplCopyWith<$Res> {
  __$$DeleteShiftParamsImplCopyWithImpl(_$DeleteShiftParamsImpl _value,
      $Res Function(_$DeleteShiftParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DeleteShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftId = null,
  }) {
    return _then(_$DeleteShiftParamsImpl(
      shiftId: null == shiftId
          ? _value.shiftId
          : shiftId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeleteShiftParamsImpl implements _DeleteShiftParams {
  const _$DeleteShiftParamsImpl({required this.shiftId});

  @override
  final String shiftId;

  @override
  String toString() {
    return 'DeleteShiftParams(shiftId: $shiftId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteShiftParamsImpl &&
            (identical(other.shiftId, shiftId) || other.shiftId == shiftId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shiftId);

  /// Create a copy of DeleteShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeleteShiftParamsImplCopyWith<_$DeleteShiftParamsImpl> get copyWith =>
      __$$DeleteShiftParamsImplCopyWithImpl<_$DeleteShiftParamsImpl>(
          this, _$identity);
}

abstract class _DeleteShiftParams implements DeleteShiftParams {
  const factory _DeleteShiftParams({required final String shiftId}) =
      _$DeleteShiftParamsImpl;

  @override
  String get shiftId;

  /// Create a copy of DeleteShiftParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeleteShiftParamsImplCopyWith<_$DeleteShiftParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
