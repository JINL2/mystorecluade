// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_bonus_amount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UpdateBonusAmountParams {
  String get shiftRequestId => throw _privateConstructorUsedError;
  double get bonusAmount => throw _privateConstructorUsedError;

  /// Create a copy of UpdateBonusAmountParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateBonusAmountParamsCopyWith<UpdateBonusAmountParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateBonusAmountParamsCopyWith<$Res> {
  factory $UpdateBonusAmountParamsCopyWith(UpdateBonusAmountParams value,
          $Res Function(UpdateBonusAmountParams) then) =
      _$UpdateBonusAmountParamsCopyWithImpl<$Res, UpdateBonusAmountParams>;
  @useResult
  $Res call({String shiftRequestId, double bonusAmount});
}

/// @nodoc
class _$UpdateBonusAmountParamsCopyWithImpl<$Res,
        $Val extends UpdateBonusAmountParams>
    implements $UpdateBonusAmountParamsCopyWith<$Res> {
  _$UpdateBonusAmountParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateBonusAmountParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? bonusAmount = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateBonusAmountParamsImplCopyWith<$Res>
    implements $UpdateBonusAmountParamsCopyWith<$Res> {
  factory _$$UpdateBonusAmountParamsImplCopyWith(
          _$UpdateBonusAmountParamsImpl value,
          $Res Function(_$UpdateBonusAmountParamsImpl) then) =
      __$$UpdateBonusAmountParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String shiftRequestId, double bonusAmount});
}

/// @nodoc
class __$$UpdateBonusAmountParamsImplCopyWithImpl<$Res>
    extends _$UpdateBonusAmountParamsCopyWithImpl<$Res,
        _$UpdateBonusAmountParamsImpl>
    implements _$$UpdateBonusAmountParamsImplCopyWith<$Res> {
  __$$UpdateBonusAmountParamsImplCopyWithImpl(
      _$UpdateBonusAmountParamsImpl _value,
      $Res Function(_$UpdateBonusAmountParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateBonusAmountParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shiftRequestId = null,
    Object? bonusAmount = null,
  }) {
    return _then(_$UpdateBonusAmountParamsImpl(
      shiftRequestId: null == shiftRequestId
          ? _value.shiftRequestId
          : shiftRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      bonusAmount: null == bonusAmount
          ? _value.bonusAmount
          : bonusAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$UpdateBonusAmountParamsImpl implements _UpdateBonusAmountParams {
  const _$UpdateBonusAmountParamsImpl(
      {required this.shiftRequestId, required this.bonusAmount});

  @override
  final String shiftRequestId;
  @override
  final double bonusAmount;

  @override
  String toString() {
    return 'UpdateBonusAmountParams(shiftRequestId: $shiftRequestId, bonusAmount: $bonusAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateBonusAmountParamsImpl &&
            (identical(other.shiftRequestId, shiftRequestId) ||
                other.shiftRequestId == shiftRequestId) &&
            (identical(other.bonusAmount, bonusAmount) ||
                other.bonusAmount == bonusAmount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shiftRequestId, bonusAmount);

  /// Create a copy of UpdateBonusAmountParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateBonusAmountParamsImplCopyWith<_$UpdateBonusAmountParamsImpl>
      get copyWith => __$$UpdateBonusAmountParamsImplCopyWithImpl<
          _$UpdateBonusAmountParamsImpl>(this, _$identity);
}

abstract class _UpdateBonusAmountParams implements UpdateBonusAmountParams {
  const factory _UpdateBonusAmountParams(
      {required final String shiftRequestId,
      required final double bonusAmount}) = _$UpdateBonusAmountParamsImpl;

  @override
  String get shiftRequestId;
  @override
  double get bonusAmount;

  /// Create a copy of UpdateBonusAmountParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateBonusAmountParamsImplCopyWith<_$UpdateBonusAmountParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
