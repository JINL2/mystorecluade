// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cash_ending.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CashEnding {
  String? get cashEndingId =>
      throw _privateConstructorUsedError; // null for new records
  String get companyId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<Currency> get currencies => throw _privateConstructorUsedError;

  /// Create a copy of CashEnding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashEndingCopyWith<CashEnding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashEndingCopyWith<$Res> {
  factory $CashEndingCopyWith(
          CashEnding value, $Res Function(CashEnding) then) =
      _$CashEndingCopyWithImpl<$Res, CashEnding>;
  @useResult
  $Res call(
      {String? cashEndingId,
      String companyId,
      String userId,
      String locationId,
      String? storeId,
      DateTime recordDate,
      DateTime createdAt,
      List<Currency> currencies});
}

/// @nodoc
class _$CashEndingCopyWithImpl<$Res, $Val extends CashEnding>
    implements $CashEndingCopyWith<$Res> {
  _$CashEndingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashEnding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashEndingId = freezed,
    Object? companyId = null,
    Object? userId = null,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
  }) {
    return _then(_value.copyWith(
      cashEndingId: freezed == cashEndingId
          ? _value.cashEndingId
          : cashEndingId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashEndingImplCopyWith<$Res>
    implements $CashEndingCopyWith<$Res> {
  factory _$$CashEndingImplCopyWith(
          _$CashEndingImpl value, $Res Function(_$CashEndingImpl) then) =
      __$$CashEndingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? cashEndingId,
      String companyId,
      String userId,
      String locationId,
      String? storeId,
      DateTime recordDate,
      DateTime createdAt,
      List<Currency> currencies});
}

/// @nodoc
class __$$CashEndingImplCopyWithImpl<$Res>
    extends _$CashEndingCopyWithImpl<$Res, _$CashEndingImpl>
    implements _$$CashEndingImplCopyWith<$Res> {
  __$$CashEndingImplCopyWithImpl(
      _$CashEndingImpl _value, $Res Function(_$CashEndingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashEnding
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cashEndingId = freezed,
    Object? companyId = null,
    Object? userId = null,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
  }) {
    return _then(_$CashEndingImpl(
      cashEndingId: freezed == cashEndingId
          ? _value.cashEndingId
          : cashEndingId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ));
  }
}

/// @nodoc

class _$CashEndingImpl extends _CashEnding {
  const _$CashEndingImpl(
      {this.cashEndingId,
      required this.companyId,
      required this.userId,
      required this.locationId,
      this.storeId,
      required this.recordDate,
      required this.createdAt,
      required final List<Currency> currencies})
      : _currencies = currencies,
        super._();

  @override
  final String? cashEndingId;
// null for new records
  @override
  final String companyId;
  @override
  final String userId;
  @override
  final String locationId;
  @override
  final String? storeId;
  @override
  final DateTime recordDate;
  @override
  final DateTime createdAt;
  final List<Currency> _currencies;
  @override
  List<Currency> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  @override
  String toString() {
    return 'CashEnding(cashEndingId: $cashEndingId, companyId: $companyId, userId: $userId, locationId: $locationId, storeId: $storeId, recordDate: $recordDate, createdAt: $createdAt, currencies: $currencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashEndingImpl &&
            (identical(other.cashEndingId, cashEndingId) ||
                other.cashEndingId == cashEndingId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cashEndingId,
      companyId,
      userId,
      locationId,
      storeId,
      recordDate,
      createdAt,
      const DeepCollectionEquality().hash(_currencies));

  /// Create a copy of CashEnding
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashEndingImplCopyWith<_$CashEndingImpl> get copyWith =>
      __$$CashEndingImplCopyWithImpl<_$CashEndingImpl>(this, _$identity);
}

abstract class _CashEnding extends CashEnding {
  const factory _CashEnding(
      {final String? cashEndingId,
      required final String companyId,
      required final String userId,
      required final String locationId,
      final String? storeId,
      required final DateTime recordDate,
      required final DateTime createdAt,
      required final List<Currency> currencies}) = _$CashEndingImpl;
  const _CashEnding._() : super._();

  @override
  String? get cashEndingId; // null for new records
  @override
  String get companyId;
  @override
  String get userId;
  @override
  String get locationId;
  @override
  String? get storeId;
  @override
  DateTime get recordDate;
  @override
  DateTime get createdAt;
  @override
  List<Currency> get currencies;

  /// Create a copy of CashEnding
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashEndingImplCopyWith<_$CashEndingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
