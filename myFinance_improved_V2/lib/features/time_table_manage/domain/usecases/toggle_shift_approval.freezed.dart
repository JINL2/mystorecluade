// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'toggle_shift_approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ToggleShiftApprovalParams {
  String get shiftRequestId => throw _privateConstructorUsedError;
  bool get newApprovalState => throw _privateConstructorUsedError;

  /// Create a copy of ToggleShiftApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ToggleShiftApprovalParamsCopyWith<ToggleShiftApprovalParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ToggleShiftApprovalParamsCopyWith<$Res> {
  factory $ToggleShiftApprovalParamsCopyWith(ToggleShiftApprovalParams value,
          $Res Function(ToggleShiftApprovalParams) then) =
      _$ToggleShiftApprovalParamsCopyWithImpl<$Res, ToggleShiftApprovalParams>;
  @useResult
  $Res call({String shiftRequestId, bool newApprovalState});
}

/// @nodoc
class _$ToggleShiftApprovalParamsCopyWithImpl<$Res,
        $Val extends ToggleShiftApprovalParams>
    implements $ToggleShiftApprovalParamsCopyWith<$Res> {
  _$ToggleShiftApprovalParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ToggleShiftApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? newApprovalState = null,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      newApprovalState: null == newApprovalState
          ? _value.newApprovalState
          : newApprovalState // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ToggleShiftApprovalParamsImplCopyWith<$Res>
    implements $ToggleShiftApprovalParamsCopyWith<$Res> {
  factory _$$ToggleShiftApprovalParamsImplCopyWith(
          _$ToggleShiftApprovalParamsImpl value,
          $Res Function(_$ToggleShiftApprovalParamsImpl) then) =
      __$$ToggleShiftApprovalParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String shiftRequestId, bool newApprovalState});
}

/// @nodoc
class __$$ToggleShiftApprovalParamsImplCopyWithImpl<$Res>
    extends _$ToggleShiftApprovalParamsCopyWithImpl<$Res,
        _$ToggleShiftApprovalParamsImpl>
    implements _$$ToggleShiftApprovalParamsImplCopyWith<$Res> {
  __$$ToggleShiftApprovalParamsImplCopyWithImpl(
      _$ToggleShiftApprovalParamsImpl _value,
      $Res Function(_$ToggleShiftApprovalParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ToggleShiftApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? newApprovalState = null,
  }) {
    return _then(_$ToggleShiftApprovalParamsImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      newApprovalState: null == newApprovalState
          ? _value.newApprovalState
          : newApprovalState // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ToggleShiftApprovalParamsImpl implements _ToggleShiftApprovalParams {
  const _$ToggleShiftApprovalParamsImpl(
      {required this.shiftRequestId, required this.newApprovalState});

  @override
  final String shiftRequestId;
  @override
  final bool newApprovalState;

  @override
  String toString() {
    return 'ToggleShiftApprovalParams(shiftRequestId: $shiftRequestId, newApprovalState: $newApprovalState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ToggleShiftApprovalParamsImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.newApprovalState, newApprovalState) ||
                other.newApprovalState == newApprovalState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, shiftRequestId, newApprovalState);

  /// Create a copy of ToggleShiftApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ToggleShiftApprovalParamsImplCopyWith<_$ToggleShiftApprovalParamsImpl>
      get copyWith => __$$ToggleShiftApprovalParamsImplCopyWithImpl<
          _$ToggleShiftApprovalParamsImpl>(this, _$identity);
}

abstract class _ToggleShiftApprovalParams implements ToggleShiftApprovalParams {
  const factory _ToggleShiftApprovalParams(
      {required final String shiftRequestId,
      required final bool newApprovalState}) = _$ToggleShiftApprovalParamsImpl;

  @override
  String get shiftRequestId;
  @override
  bool get newApprovalState;

  /// Create a copy of ToggleShiftApprovalParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ToggleShiftApprovalParamsImplCopyWith<_$ToggleShiftApprovalParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
