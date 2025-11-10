// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Location {
  String get locationId => throw _privateConstructorUsedError;
  String get locationName => throw _privateConstructorUsedError;
  String get locationType => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String? get currencyId => throw _privateConstructorUsedError;
  String? get accountId => throw _privateConstructorUsedError;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationCopyWith<Location> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationCopyWith<$Res> {
  factory $LocationCopyWith(Location value, $Res Function(Location) then) =
      _$LocationCopyWithImpl<$Res, Location>;
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      String? storeId,
      String? currencyId,
      String? accountId});
}

/// @nodoc
class _$LocationCopyWithImpl<$Res, $Val extends Location>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = freezed,
    Object? currencyId = freezed,
    Object? accountId = freezed,
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
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationImplCopyWith<$Res>
    implements $LocationCopyWith<$Res> {
  factory _$$LocationImplCopyWith(
          _$LocationImpl value, $Res Function(_$LocationImpl) then) =
      __$$LocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String locationId,
      String locationName,
      String locationType,
      String? storeId,
      String? currencyId,
      String? accountId});
}

/// @nodoc
class __$$LocationImplCopyWithImpl<$Res>
    extends _$LocationCopyWithImpl<$Res, _$LocationImpl>
    implements _$$LocationImplCopyWith<$Res> {
  __$$LocationImplCopyWithImpl(
      _$LocationImpl _value, $Res Function(_$LocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locationId = null,
    Object? locationName = null,
    Object? locationType = null,
    Object? storeId = freezed,
    Object? currencyId = freezed,
    Object? accountId = freezed,
  }) {
    return _then(_$LocationImpl(
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
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyId: freezed == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LocationImpl extends _Location {
  const _$LocationImpl(
      {required this.locationId,
      required this.locationName,
      required this.locationType,
      this.storeId,
      this.currencyId,
      this.accountId})
      : assert(
            locationType == 'cash' ||
                locationType == 'bank' ||
                locationType == 'vault',
            'Invalid location type. Must be cash, bank, or vault'),
        super._();

  @override
  final String locationId;
  @override
  final String locationName;
  @override
  final String locationType;
  @override
  final String? storeId;
  @override
  final String? currencyId;
  @override
  final String? accountId;

  @override
  String toString() {
    return 'Location(locationId: $locationId, locationName: $locationName, locationType: $locationType, storeId: $storeId, currencyId: $currencyId, accountId: $accountId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationImpl &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.locationType, locationType) ||
                other.locationType == locationType) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, locationId, locationName,
      locationType, storeId, currencyId, accountId);

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      __$$LocationImplCopyWithImpl<_$LocationImpl>(this, _$identity);
}

abstract class _Location extends Location {
  const factory _Location(
      {required final String locationId,
      required final String locationName,
      required final String locationType,
      final String? storeId,
      final String? currencyId,
      final String? accountId}) = _$LocationImpl;
  const _Location._() : super._();

  @override
  String get locationId;
  @override
  String get locationName;
  @override
  String get locationType;
  @override
  String? get storeId;
  @override
  String? get currencyId;
  @override
  String? get accountId;

  /// Create a copy of Location
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationImplCopyWith<_$LocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
