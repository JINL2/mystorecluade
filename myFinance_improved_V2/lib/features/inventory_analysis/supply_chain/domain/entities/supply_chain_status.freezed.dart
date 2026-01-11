// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supply_chain_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SupplyChainProduct {
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get shortageDays => throw _privateConstructorUsedError;
  num get avgShortagePerDay => throw _privateConstructorUsedError;
  num get totalShortage => throw _privateConstructorUsedError;
  num get errorIntegral => throw _privateConstructorUsedError;
  String get riskLevel => throw _privateConstructorUsedError;

  /// Create a copy of SupplyChainProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplyChainProductCopyWith<SupplyChainProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplyChainProductCopyWith<$Res> {
  factory $SupplyChainProductCopyWith(
          SupplyChainProduct value, $Res Function(SupplyChainProduct) then) =
      _$SupplyChainProductCopyWithImpl<$Res, SupplyChainProduct>;
  @useResult
  $Res call(
      {String productId,
      String productName,
      int shortageDays,
      num avgShortagePerDay,
      num totalShortage,
      num errorIntegral,
      String riskLevel});
}

/// @nodoc
class _$SupplyChainProductCopyWithImpl<$Res, $Val extends SupplyChainProduct>
    implements $SupplyChainProductCopyWith<$Res> {
  _$SupplyChainProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplyChainProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? shortageDays = null,
    Object? avgShortagePerDay = null,
    Object? totalShortage = null,
    Object? errorIntegral = null,
    Object? riskLevel = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      shortageDays: null == shortageDays
          ? _value.shortageDays
          : shortageDays // ignore: cast_nullable_to_non_nullable
              as int,
      avgShortagePerDay: null == avgShortagePerDay
          ? _value.avgShortagePerDay
          : avgShortagePerDay // ignore: cast_nullable_to_non_nullable
              as num,
      totalShortage: null == totalShortage
          ? _value.totalShortage
          : totalShortage // ignore: cast_nullable_to_non_nullable
              as num,
      errorIntegral: null == errorIntegral
          ? _value.errorIntegral
          : errorIntegral // ignore: cast_nullable_to_non_nullable
              as num,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupplyChainProductImplCopyWith<$Res>
    implements $SupplyChainProductCopyWith<$Res> {
  factory _$$SupplyChainProductImplCopyWith(_$SupplyChainProductImpl value,
          $Res Function(_$SupplyChainProductImpl) then) =
      __$$SupplyChainProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String productId,
      String productName,
      int shortageDays,
      num avgShortagePerDay,
      num totalShortage,
      num errorIntegral,
      String riskLevel});
}

/// @nodoc
class __$$SupplyChainProductImplCopyWithImpl<$Res>
    extends _$SupplyChainProductCopyWithImpl<$Res, _$SupplyChainProductImpl>
    implements _$$SupplyChainProductImplCopyWith<$Res> {
  __$$SupplyChainProductImplCopyWithImpl(_$SupplyChainProductImpl _value,
      $Res Function(_$SupplyChainProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of SupplyChainProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? shortageDays = null,
    Object? avgShortagePerDay = null,
    Object? totalShortage = null,
    Object? errorIntegral = null,
    Object? riskLevel = null,
  }) {
    return _then(_$SupplyChainProductImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      shortageDays: null == shortageDays
          ? _value.shortageDays
          : shortageDays // ignore: cast_nullable_to_non_nullable
              as int,
      avgShortagePerDay: null == avgShortagePerDay
          ? _value.avgShortagePerDay
          : avgShortagePerDay // ignore: cast_nullable_to_non_nullable
              as num,
      totalShortage: null == totalShortage
          ? _value.totalShortage
          : totalShortage // ignore: cast_nullable_to_non_nullable
              as num,
      errorIntegral: null == errorIntegral
          ? _value.errorIntegral
          : errorIntegral // ignore: cast_nullable_to_non_nullable
              as num,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SupplyChainProductImpl extends _SupplyChainProduct {
  const _$SupplyChainProductImpl(
      {required this.productId,
      required this.productName,
      required this.shortageDays,
      required this.avgShortagePerDay,
      required this.totalShortage,
      required this.errorIntegral,
      required this.riskLevel})
      : super._();

  @override
  final String productId;
  @override
  final String productName;
  @override
  final int shortageDays;
  @override
  final num avgShortagePerDay;
  @override
  final num totalShortage;
  @override
  final num errorIntegral;
  @override
  final String riskLevel;

  @override
  String toString() {
    return 'SupplyChainProduct(productId: $productId, productName: $productName, shortageDays: $shortageDays, avgShortagePerDay: $avgShortagePerDay, totalShortage: $totalShortage, errorIntegral: $errorIntegral, riskLevel: $riskLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplyChainProductImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.shortageDays, shortageDays) ||
                other.shortageDays == shortageDays) &&
            (identical(other.avgShortagePerDay, avgShortagePerDay) ||
                other.avgShortagePerDay == avgShortagePerDay) &&
            (identical(other.totalShortage, totalShortage) ||
                other.totalShortage == totalShortage) &&
            (identical(other.errorIntegral, errorIntegral) ||
                other.errorIntegral == errorIntegral) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, productId, productName,
      shortageDays, avgShortagePerDay, totalShortage, errorIntegral, riskLevel);

  /// Create a copy of SupplyChainProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplyChainProductImplCopyWith<_$SupplyChainProductImpl> get copyWith =>
      __$$SupplyChainProductImplCopyWithImpl<_$SupplyChainProductImpl>(
          this, _$identity);
}

abstract class _SupplyChainProduct extends SupplyChainProduct {
  const factory _SupplyChainProduct(
      {required final String productId,
      required final String productName,
      required final int shortageDays,
      required final num avgShortagePerDay,
      required final num totalShortage,
      required final num errorIntegral,
      required final String riskLevel}) = _$SupplyChainProductImpl;
  const _SupplyChainProduct._() : super._();

  @override
  String get productId;
  @override
  String get productName;
  @override
  int get shortageDays;
  @override
  num get avgShortagePerDay;
  @override
  num get totalShortage;
  @override
  num get errorIntegral;
  @override
  String get riskLevel;

  /// Create a copy of SupplyChainProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplyChainProductImplCopyWith<_$SupplyChainProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SupplyChainStatus {
  List<SupplyChainProduct> get urgentProducts =>
      throw _privateConstructorUsedError;

  /// Create a copy of SupplyChainStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplyChainStatusCopyWith<SupplyChainStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplyChainStatusCopyWith<$Res> {
  factory $SupplyChainStatusCopyWith(
          SupplyChainStatus value, $Res Function(SupplyChainStatus) then) =
      _$SupplyChainStatusCopyWithImpl<$Res, SupplyChainStatus>;
  @useResult
  $Res call({List<SupplyChainProduct> urgentProducts});
}

/// @nodoc
class _$SupplyChainStatusCopyWithImpl<$Res, $Val extends SupplyChainStatus>
    implements $SupplyChainStatusCopyWith<$Res> {
  _$SupplyChainStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplyChainStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? urgentProducts = null,
  }) {
    return _then(_value.copyWith(
      urgentProducts: null == urgentProducts
          ? _value.urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<SupplyChainProduct>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SupplyChainStatusImplCopyWith<$Res>
    implements $SupplyChainStatusCopyWith<$Res> {
  factory _$$SupplyChainStatusImplCopyWith(_$SupplyChainStatusImpl value,
          $Res Function(_$SupplyChainStatusImpl) then) =
      __$$SupplyChainStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SupplyChainProduct> urgentProducts});
}

/// @nodoc
class __$$SupplyChainStatusImplCopyWithImpl<$Res>
    extends _$SupplyChainStatusCopyWithImpl<$Res, _$SupplyChainStatusImpl>
    implements _$$SupplyChainStatusImplCopyWith<$Res> {
  __$$SupplyChainStatusImplCopyWithImpl(_$SupplyChainStatusImpl _value,
      $Res Function(_$SupplyChainStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SupplyChainStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? urgentProducts = null,
  }) {
    return _then(_$SupplyChainStatusImpl(
      urgentProducts: null == urgentProducts
          ? _value._urgentProducts
          : urgentProducts // ignore: cast_nullable_to_non_nullable
              as List<SupplyChainProduct>,
    ));
  }
}

/// @nodoc

class _$SupplyChainStatusImpl extends _SupplyChainStatus {
  const _$SupplyChainStatusImpl(
      {required final List<SupplyChainProduct> urgentProducts})
      : _urgentProducts = urgentProducts,
        super._();

  final List<SupplyChainProduct> _urgentProducts;
  @override
  List<SupplyChainProduct> get urgentProducts {
    if (_urgentProducts is EqualUnmodifiableListView) return _urgentProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_urgentProducts);
  }

  @override
  String toString() {
    return 'SupplyChainStatus(urgentProducts: $urgentProducts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplyChainStatusImpl &&
            const DeepCollectionEquality()
                .equals(other._urgentProducts, _urgentProducts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_urgentProducts));

  /// Create a copy of SupplyChainStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplyChainStatusImplCopyWith<_$SupplyChainStatusImpl> get copyWith =>
      __$$SupplyChainStatusImplCopyWithImpl<_$SupplyChainStatusImpl>(
          this, _$identity);
}

abstract class _SupplyChainStatus extends SupplyChainStatus {
  const factory _SupplyChainStatus(
          {required final List<SupplyChainProduct> urgentProducts}) =
      _$SupplyChainStatusImpl;
  const _SupplyChainStatus._() : super._();

  @override
  List<SupplyChainProduct> get urgentProducts;

  /// Create a copy of SupplyChainStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplyChainStatusImplCopyWith<_$SupplyChainStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
