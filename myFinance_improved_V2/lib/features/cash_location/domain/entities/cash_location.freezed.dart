// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CashLocation _$CashLocationFromJson(Map<String, dynamic> json) {
  return _CashLocation.fromJson(json);
}

/// @nodoc
mixin _$CashLocation {
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  double get totalJournalCashAmount => throw _privateConstructorUsedError;
  double get totalRealCashAmount => throw _privateConstructorUsedError;
  double get cashDifference => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String get currencySymbol => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this CashLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationCopyWith<CashLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationCopyWith<$Res> {
  factory $CashLocationCopyWith(
          CashLocation value, $Res Function(CashLocation) then) =
      _$CashLocationCopyWithImpl<$Res, CashLocation>;
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournalCashAmount,
      double totalRealCashAmount,
      double cashDifference,
      String companyId,
      String? storeId,
      String currencySymbol,
      bool isDeleted});
}

/// @nodoc
class _$CashLocationCopyWithImpl<$Res, $Val extends CashLocation>
    implements $CashLocationCopyWith<$Res> {
  _$CashLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournalCashAmount = null,
    Object? totalRealCashAmount = null,
    Object? cashDifference = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? currencySymbol = null,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalJournalCashAmount: null == totalJournalCashAmount
          ? _value.totalJournalCashAmount
          : totalJournalCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalRealCashAmount: null == totalRealCashAmount
          ? _value.totalRealCashAmount
          : totalRealCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cashDifference: null == cashDifference
          ? _value.cashDifference
          : cashDifference // ignore: cast_nullable_to_non_nullable
              as double,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationImplCopyWith<$Res>
    implements $CashLocationCopyWith<$Res> {
  factory _$$CashLocationImplCopyWith(
          _$CashLocationImpl value, $Res Function(_$CashLocationImpl) then) =
      __$$CashLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      double totalJournalCashAmount,
      double totalRealCashAmount,
      double cashDifference,
      String companyId,
      String? storeId,
      String currencySymbol,
      bool isDeleted});
}

/// @nodoc
class __$$CashLocationImplCopyWithImpl<$Res>
    extends _$CashLocationCopyWithImpl<$Res, _$CashLocationImpl>
    implements _$$CashLocationImplCopyWith<$Res> {
  __$$CashLocationImplCopyWithImpl(
      _$CashLocationImpl _value, $Res Function(_$CashLocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? totalJournalCashAmount = null,
    Object? totalRealCashAmount = null,
    Object? cashDifference = null,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? currencySymbol = null,
    Object? isDeleted = null,
  }) {
    return _then(_$CashLocationImpl(
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      totalJournalCashAmount: null == totalJournalCashAmount
          ? _value.totalJournalCashAmount
          : totalJournalCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      totalRealCashAmount: null == totalRealCashAmount
          ? _value.totalRealCashAmount
          : totalRealCashAmount // ignore: cast_nullable_to_non_nullable
              as double,
      cashDifference: null == cashDifference
          ? _value.cashDifference
          : cashDifference // ignore: cast_nullable_to_non_nullable
              as double,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencySymbol: null == currencySymbol
          ? _value.currencySymbol
          : currencySymbol // ignore: cast_nullable_to_non_nullable
              as String,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationImpl extends _CashLocation {
  const _$CashLocationImpl(
      {required this.locationId,
      required this.locationName,
      required this.locationType,
      required this.totalJournalCashAmount,
      required this.totalRealCashAmount,
      required this.cashDifference,
      required this.companyId,
      this.storeId,
      required this.currencySymbol,
      this.isDeleted = false})
      : super._();

  factory _$CashLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationImplFromJson(json);

  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final double totalJournalCashAmount;
  @override
  final double totalRealCashAmount;
  @override
  final double cashDifference;
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String currencySymbol;
  @override
  @JsonKey()
  final bool isDeleted;

  @override
  String toString() {
    return 'CashLocation(locationId: $locationId, locationName: $locationName, locationType: $locationType, totalJournalCashAmount: $totalJournalCashAmount, totalRealCashAmount: $totalRealCashAmount, cashDifference: $cashDifference, companyId: $companyId, storeId: $storeId, currencySymbol: $currencySymbol, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.totalJournalCashAmount, totalJournalCashAmount) ||
                other.totalJournalCashAmount == totalJournalCashAmount) &&
            (identical(other.totalRealCashAmount, totalRealCashAmount) ||
                other.totalRealCashAmount == totalRealCashAmount) &&
            (identical(other.cashDifference, cashDifference) ||
                other.cashDifference == cashDifference) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.currencySymbol, currencySymbol) ||
                other.currencySymbol == currencySymbol) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      locationId,
      locationName,
      locationType,
      totalJournalCashAmount,
      totalRealCashAmount,
      cashDifference,
      companyId,
      storeId,
      currencySymbol,
      isDeleted);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      __$$CashLocationImplCopyWithImpl<_$CashLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationImplToJson(
      this,
    );
  }
}

abstract class _CashLocation extends CashLocation {
  const factory _CashLocation(
      {required final String locationId,
      required final String locationName,
      required final String locationType,
      required final double totalJournalCashAmount,
      required final double totalRealCashAmount,
      required final double cashDifference,
      required final String companyId,
      final String? storeId,
      required final String currencySymbol,
      final bool isDeleted}) = _$CashLocationImpl;
  const _CashLocation._() : super._();

  factory _CashLocation.fromJson(Map<String, dynamic> json) =
      _$CashLocationImpl.fromJson;

  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  double get totalJournalCashAmount;
  @override
  double get totalRealCashAmount;
  @override
  double get cashDifference;
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String get currencySymbol;
  @override
  bool get isDeleted;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
