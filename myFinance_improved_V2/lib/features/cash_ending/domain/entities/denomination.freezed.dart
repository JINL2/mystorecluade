// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'denomination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Denomination {
  String get denominationId => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DenominationCopyWith<Denomination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DenominationCopyWith<$Res> {
  factory $DenominationCopyWith(
          Denomination value, $Res Function(Denomination) then) =
      _$DenominationCopyWithImpl<$Res, Denomination>;
  @useResult
  $Res call(
      {String denominationId, String currencyId, double value, int quantity});
}

/// @nodoc
class _$DenominationCopyWithImpl<$Res, $Val extends Denomination>
    implements $DenominationCopyWith<$Res> {
  _$DenominationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DenominationImplCopyWith<$Res>
    implements $DenominationCopyWith<$Res> {
  factory _$$DenominationImplCopyWith(
          _$DenominationImpl value, $Res Function(_$DenominationImpl) then) =
      __$$DenominationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String denominationId, String currencyId, double value, int quantity});
}

/// @nodoc
class __$$DenominationImplCopyWithImpl<$Res>
    extends _$DenominationCopyWithImpl<$Res, _$DenominationImpl>
    implements _$$DenominationImplCopyWith<$Res> {
  __$$DenominationImplCopyWithImpl(
      _$DenominationImpl _value, $Res Function(_$DenominationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? denominationId = null,
    Object? currencyId = null,
    Object? value = null,
    Object? quantity = null,
  }) {
    return _then(_$DenominationImpl(
      denominationId: null == denominationId
          ? _value.denominationId
          : denominationId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DenominationImpl extends _Denomination {
  const _$DenominationImpl(
      {required this.denominationId,
      required this.currencyId,
      required this.value,
      this.quantity = 0})
      : super._();

  @override
  final String denominationId;
  @override
  final String currencyId;
  @override
  final double value;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'Denomination(denominationId: $denominationId, currencyId: $currencyId, value: $value, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DenominationImpl &&
            (identical(other.denominationId, denominationId) ||
                other.denominationId == denominationId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, denominationId, currencyId, value, quantity);

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      __$$DenominationImplCopyWithImpl<_$DenominationImpl>(this, _$identity);
}

abstract class _Denomination extends Denomination {
  const factory _Denomination(
      {required final String denominationId,
      required final String currencyId,
      required final double value,
      final int quantity}) = _$DenominationImpl;
  const _Denomination._() : super._();

  @override
  String get denominationId;
  @override
  String get currencyId;
  @override
  double get value;
  @override
  int get quantity;

  /// Create a copy of Denomination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DenominationImplCopyWith<_$DenominationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
