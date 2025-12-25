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

/// @nodoc
mixin _$CashLocation {
  String get cashLocationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get companyId => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;

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
      {String cashLocationId,
      String locationName,
      String locationType,
      String? storeId,
      String? companyId,
      String? accountId});
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
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
    Object? accountId = freezed,
  }) {
    return _then(_value.copyWith(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String cashLocationId,
      String locationName,
      String locationType,
      String? storeId,
      String? companyId,
      String? accountId});
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
    Object? cashLocationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
    Object? accountId = freezed,
  }) {
    return _then(_$CashLocationImpl(
      cashLocationId: null == cashLocationId
          ? _value.cashLocationId
          : cashLocationId // ignore: cast_nullable_to_non_nullable
              as String,
      locationName: null == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String,
      locationType: null == locationType
          ? _value.locationType
          : locationType // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CashLocationImpl extends _CashLocation {
  const _$CashLocationImpl(
      {required this.cashLocationId,
      required this.locationName,
      required this.locationType,
      this.storeId,
      this.companyId,
      this.accountId})
      : super._();

  @override
  final String cashLocationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final String? storeId;
  @override
  final String? companyId;
  @override
  final String? accountId;

  @override
  String toString() {
    return 'CashLocation(cashLocationId: $cashLocationId, locationName: $locationName, locationType: $locationType, storeId: $storeId, companyId: $companyId, accountId: $accountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationImpl &&
            (identical(other.cashLocationId, cashLocationId) ||
                other.cashLocationId == cashLocationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cashLocationId, locationName,
      locationType, storeId, companyId, accountId);

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      __$$CashLocationImplCopyWithImpl<_$CashLocationImpl>(this, _$identity);
}

abstract class _CashLocation extends CashLocation {
  const factory _CashLocation(
      {required final String cashLocationId,
      required final String locationName,
      required final String locationType,
      final String? storeId,
      final String? companyId,
      final String? accountId}) = _$CashLocationImpl;
  const _CashLocation._() : super._();

  @override
  String get cashLocationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  String? get storeId;
  @override
  String? get companyId;
  @override
  String? get accountId;

  /// Create a copy of CashLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationImplCopyWith<_$CashLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
