// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_bonus.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddBonusParams {
  String get shiftRequestId => throw _privateConstructorUsedError;
  double get bonusAmount => throw _privateConstructorUsedError;
  String get bonusReason => throw _privateConstructorUsedError;

  /// Create a copy of AddBonusParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddBonusParamsCopyWith<AddBonusParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddBonusParamsCopyWith<$Res> {
  factory $AddBonusParamsCopyWith(
          AddBonusParams value, $Res Function(AddBonusParams) then) =
      _$AddBonusParamsCopyWithImpl<$Res, AddBonusParams>;
  @useResult
  $Res call({String shiftRequestId, double bonusAmount, String bonusReason});
}

/// @nodoc
class _$AddBonusParamsCopyWithImpl<$Res, $Val extends AddBonusParams>
    implements $AddBonusParamsCopyWith<$Res> {
  _$AddBonusParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddBonusParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? bonusAmount = null,
    Object? bonusReason = null,
  }) {
    return _then(_value.copyWith(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bonusReason: null == bonusReason
          ? _value.bonusReason
          : bonusReason // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddBonusParamsImplCopyWith<$Res>
    implements $AddBonusParamsCopyWith<$Res> {
  factory _$$AddBonusParamsImplCopyWith(_$AddBonusParamsImpl value,
          $Res Function(_$AddBonusParamsImpl) then) =
      __$$AddBonusParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String shiftRequestId, double bonusAmount, String bonusReason});
}

/// @nodoc
class __$$AddBonusParamsImplCopyWithImpl<$Res>
    extends _$AddBonusParamsCopyWithImpl<$Res, _$AddBonusParamsImpl>
    implements _$$AddBonusParamsImplCopyWith<$Res> {
  __$$AddBonusParamsImplCopyWithImpl(
      _$AddBonusParamsImpl _value, $Res Function(_$AddBonusParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddBonusParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? bonusAmount = null,
    Object? bonusReason = null,
  }) {
    return _then(_$AddBonusParamsImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
      bonusReason: null == bonusReason
          ? _value.bonusReason
          : bonusReason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddBonusParamsImpl implements _AddBonusParams {
  const _$AddBonusParamsImpl(
      {required this.shiftRequestId,
      required this.bonusAmount,
      required this.bonusReason});

  @override
  final String shiftRequestId;
  @override
  final double bonusAmount;
  @override
  final String bonusReason;

  @override
  String toString() {
    return 'AddBonusParams(shiftRequestId: $shiftRequestId, bonusAmount: $bonusAmount, bonusReason: $bonusReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddBonusParamsImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount) &&
            (identical(other.bonusReason, bonusReason) ||
                other.bonusReason == bonusReason));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, shiftRequestId, bonusAmount, bonusReason);

  /// Create a copy of AddBonusParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddBonusParamsImplCopyWith<_$AddBonusParamsImpl> get copyWith =>
      __$$AddBonusParamsImplCopyWithImpl<_$AddBonusParamsImpl>(
          this, _$identity);
}

abstract class _AddBonusParams implements AddBonusParams {
  const factory _AddBonusParams(
      {required final String shiftRequestId,
      required final double bonusAmount,
      required final String bonusReason}) = _$AddBonusParamsImpl;

  @override
  String get shiftRequestId;
  @override
  double get bonusAmount;
  @override
  String get bonusReason;

  /// Create a copy of AddBonusParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddBonusParamsImplCopyWith<_$AddBonusParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
