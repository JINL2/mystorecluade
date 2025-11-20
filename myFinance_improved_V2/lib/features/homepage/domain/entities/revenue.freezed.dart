// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revenue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Revenue {
  double get amount => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  RevenuePeriod get period => throw _privateConstructorUsedError;
  double get previousAmount => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;

  /// Create a copy of Revenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RevenueCopyWith<Revenue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RevenueCopyWith<$Res> {
  factory $RevenueCopyWith(Revenue value, $Res Function(Revenue) then) =
      _$RevenueCopyWithImpl<$Res, Revenue>;
  @useResult
  $Res call(
      {double amount,
      String currencyCode,
      RevenuePeriod period,
      double previousAmount,
      DateTime lastUpdated,
      String? storeId,
      String? companyId});
}

/// @nodoc
class _$RevenueCopyWithImpl<$Res, $Val extends Revenue>
    implements $RevenueCopyWith<$Res> {
  _$RevenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Revenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencyCode = null,
    Object? period = null,
    Object? previousAmount = null,
    Object? lastUpdated = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as RevenuePeriod,
      previousAmount: null == previousAmount
          ? _value.previousAmount
          : previousAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RevenueImplCopyWith<$Res> implements $RevenueCopyWith<$Res> {
  factory _$$RevenueImplCopyWith(
          _$RevenueImpl value, $Res Function(_$RevenueImpl) then) =
      __$$RevenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double amount,
      String currencyCode,
      RevenuePeriod period,
      double previousAmount,
      DateTime lastUpdated,
      String? storeId,
      String? companyId});
}

/// @nodoc
class __$$RevenueImplCopyWithImpl<$Res>
    extends _$RevenueCopyWithImpl<$Res, _$RevenueImpl>
    implements _$$RevenueImplCopyWith<$Res> {
  __$$RevenueImplCopyWithImpl(
      _$RevenueImpl _value, $Res Function(_$RevenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of Revenue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currencyCode = null,
    Object? period = null,
    Object? previousAmount = null,
    Object? lastUpdated = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
  }) {
    return _then(_$RevenueImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as RevenuePeriod,
      previousAmount: null == previousAmount
          ? _value.previousAmount
          : previousAmount // ignore: cast_nullable_to_non_nullable
              as double,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RevenueImpl extends _Revenue {
  const _$RevenueImpl(
      {required this.amount,
      required this.currencyCode,
      required this.period,
      required this.previousAmount,
      required this.lastUpdated,
      this.storeId,
      this.companyId})
      : super._();

  @override
  final double amount;
  @override
  final String currencyCode;
  @override
  final RevenuePeriod period;
  @override
  final double previousAmount;
  @override
  final DateTime lastUpdated;
  @override
  final String? storeId;
  @override
  final String? companyId;

  @override
  String toString() {
    return 'Revenue(amount: $amount, currencyCode: $currencyCode, period: $period, previousAmount: $previousAmount, lastUpdated: $lastUpdated, storeId: $storeId, companyId: $companyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RevenueImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.previousAmount, previousAmount) ||
                other.previousAmount == previousAmount) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, currencyCode, period,
      previousAmount, lastUpdated, storeId, companyId);

  /// Create a copy of Revenue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RevenueImplCopyWith<_$RevenueImpl> get copyWith =>
      __$$RevenueImplCopyWithImpl<_$RevenueImpl>(this, _$identity);
}

abstract class _Revenue extends Revenue {
  const factory _Revenue(
      {required final double amount,
      required final String currencyCode,
      required final RevenuePeriod period,
      required final double previousAmount,
      required final DateTime lastUpdated,
      final String? storeId,
      final String? companyId}) = _$RevenueImpl;
  const _Revenue._() : super._();

  @override
  double get amount;
  @override
  String get currencyCode;
  @override
  RevenuePeriod get period;
  @override
  double get previousAmount;
  @override
  DateTime get lastUpdated;
  @override
  String? get storeId;
  @override
  String? get companyId;

  /// Create a copy of Revenue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RevenueImplCopyWith<_$RevenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
