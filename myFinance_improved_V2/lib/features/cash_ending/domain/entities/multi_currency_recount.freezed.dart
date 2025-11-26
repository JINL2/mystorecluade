// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multi_currency_recount.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MultiCurrencyRecount {
  String get companyId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  List<VaultRecount> get currencyRecounts => throw _privateConstructorUsedError;

  /// Create a copy of MultiCurrencyRecount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiCurrencyRecountCopyWith<MultiCurrencyRecount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiCurrencyRecountCopyWith<$Res> {
  factory $MultiCurrencyRecountCopyWith(MultiCurrencyRecount value,
          $Res Function(MultiCurrencyRecount) then) =
      _$MultiCurrencyRecountCopyWithImpl<$Res, MultiCurrencyRecount>;
  @useResult
  $Res call(
      {String companyId,
      String locationId,
      String userId,
      String? storeId,
      DateTime recordDate,
      List<VaultRecount> currencyRecounts});
}

/// @nodoc
class _$MultiCurrencyRecountCopyWithImpl<$Res,
        $Val extends MultiCurrencyRecount>
    implements $MultiCurrencyRecountCopyWith<$Res> {
  _$MultiCurrencyRecountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiCurrencyRecount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? locationId = null,
    Object? userId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? currencyRecounts = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencyRecounts: null == currencyRecounts
          ? _value.currencyRecounts
          : currencyRecounts // ignore: cast_nullable_to_non_nullable
              as List<VaultRecount>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MultiCurrencyRecountImplCopyWith<$Res>
    implements $MultiCurrencyRecountCopyWith<$Res> {
  factory _$$MultiCurrencyRecountImplCopyWith(_$MultiCurrencyRecountImpl value,
          $Res Function(_$MultiCurrencyRecountImpl) then) =
      __$$MultiCurrencyRecountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyId,
      String locationId,
      String userId,
      String? storeId,
      DateTime recordDate,
      List<VaultRecount> currencyRecounts});
}

/// @nodoc
class __$$MultiCurrencyRecountImplCopyWithImpl<$Res>
    extends _$MultiCurrencyRecountCopyWithImpl<$Res, _$MultiCurrencyRecountImpl>
    implements _$$MultiCurrencyRecountImplCopyWith<$Res> {
  __$$MultiCurrencyRecountImplCopyWithImpl(_$MultiCurrencyRecountImpl _value,
      $Res Function(_$MultiCurrencyRecountImpl) _then)
      : super(_value, _then);

  /// Create a copy of MultiCurrencyRecount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? locationId = null,
    Object? userId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? currencyRecounts = null,
  }) {
    return _then(_$MultiCurrencyRecountImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencyRecounts: null == currencyRecounts
          ? _value._currencyRecounts
          : currencyRecounts // ignore: cast_nullable_to_non_nullable
              as List<VaultRecount>,
    ));
  }
}

/// @nodoc

class _$MultiCurrencyRecountImpl extends _MultiCurrencyRecount {
  const _$MultiCurrencyRecountImpl(
      {required this.companyId,
      required this.locationId,
      required this.userId,
      this.storeId,
      required this.recordDate,
      required final List<VaultRecount> currencyRecounts})
      : _currencyRecounts = currencyRecounts,
        super._();

  @override
  final String companyId;
  @override
  final String locationId;
  @override
  final String userId;
  @override
  final String? storeId;
  @override
  final DateTime recordDate;
  final List<VaultRecount> _currencyRecounts;
  @override
  List<VaultRecount> get currencyRecounts {
    if (_currencyRecounts is EqualUnmodifiableListView)
      return _currencyRecounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencyRecounts);
  }

  @override
  String toString() {
    return 'MultiCurrencyRecount(companyId: $companyId, locationId: $locationId, userId: $userId, storeId: $storeId, recordDate: $recordDate, currencyRecounts: $currencyRecounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiCurrencyRecountImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            const DeepCollectionEquality()
                .equals(other._currencyRecounts, _currencyRecounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyId,
      locationId,
      userId,
      storeId,
      recordDate,
      const DeepCollectionEquality().hash(_currencyRecounts));

  /// Create a copy of MultiCurrencyRecount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiCurrencyRecountImplCopyWith<_$MultiCurrencyRecountImpl>
      get copyWith =>
          __$$MultiCurrencyRecountImplCopyWithImpl<_$MultiCurrencyRecountImpl>(
              this, _$identity);
}

abstract class _MultiCurrencyRecount extends MultiCurrencyRecount {
  const factory _MultiCurrencyRecount(
          {required final String companyId,
          required final String locationId,
          required final String userId,
          final String? storeId,
          required final DateTime recordDate,
          required final List<VaultRecount> currencyRecounts}) =
      _$MultiCurrencyRecountImpl;
  const _MultiCurrencyRecount._() : super._();

  @override
  String get companyId;
  @override
  String get locationId;
  @override
  String get userId;
  @override
  String? get storeId;
  @override
  DateTime get recordDate;
  @override
  List<VaultRecount> get currencyRecounts;

  /// Create a copy of MultiCurrencyRecount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiCurrencyRecountImplCopyWith<_$MultiCurrencyRecountImpl>
      get copyWith => throw _privateConstructorUsedError;
}
