// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BankBalance {
  String? get balanceId =>
      throw _privateConstructorUsedError; // null for new records
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<Currency> get currencies =>
      throw _privateConstructorUsedError; // Each currency with totalAmount (no denominations used)
  /// Flag to indicate if user explicitly entered a value (including 0)
  /// Used to distinguish between "not entered" vs "explicitly set to 0"
  bool get isExplicitlySet => throw _privateConstructorUsedError;

  /// Create a copy of BankBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankBalanceCopyWith<BankBalance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankBalanceCopyWith<$Res> {
  factory $BankBalanceCopyWith(
          BankBalance value, $Res Function(BankBalance) then) =
      _$BankBalanceCopyWithImpl<$Res, BankBalance>;
  @useResult
  $Res call(
      {String? balanceId,
      String companyId,
      String? storeId,
      String locationId,
      String userId,
      DateTime recordDate,
      DateTime createdAt,
      List<Currency> currencies,
      bool isExplicitlySet});
}

/// @nodoc
class _$BankBalanceCopyWithImpl<$Res, $Val extends BankBalance>
    implements $BankBalanceCopyWith<$Res> {
  _$BankBalanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balanceId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
    Object? isExplicitlySet = null,
  }) {
    return _then(_value.copyWith(
      balanceId: freezed == balanceId
          ? _value.balanceId
          : balanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      isExplicitlySet: null == isExplicitlySet
          ? _value.isExplicitlySet
          : isExplicitlySet // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankBalanceImplCopyWith<$Res>
    implements $BankBalanceCopyWith<$Res> {
  factory _$$BankBalanceImplCopyWith(
          _$BankBalanceImpl value, $Res Function(_$BankBalanceImpl) then) =
      __$$BankBalanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? balanceId,
      String companyId,
      String? storeId,
      String locationId,
      String userId,
      DateTime recordDate,
      DateTime createdAt,
      List<Currency> currencies,
      bool isExplicitlySet});
}

/// @nodoc
class __$$BankBalanceImplCopyWithImpl<$Res>
    extends _$BankBalanceCopyWithImpl<$Res, _$BankBalanceImpl>
    implements _$$BankBalanceImplCopyWith<$Res> {
  __$$BankBalanceImplCopyWithImpl(
      _$BankBalanceImpl _value, $Res Function(_$BankBalanceImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankBalance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balanceId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currencies = null,
    Object? isExplicitlySet = null,
  }) {
    return _then(_$BankBalanceImpl(
      balanceId: freezed == balanceId
          ? _value.balanceId
          : balanceId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      locationId: null == locationId
          ? _value.locationId
          : locationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      isExplicitlySet: null == isExplicitlySet
          ? _value.isExplicitlySet
          : isExplicitlySet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BankBalanceImpl extends _BankBalance {
  const _$BankBalanceImpl(
      {this.balanceId,
      required this.companyId,
      this.storeId,
      required this.locationId,
      required this.userId,
      required this.recordDate,
      required this.createdAt,
      required final List<Currency> currencies,
      this.isExplicitlySet = false})
      : _currencies = currencies,
        super._();

  @override
  final String? balanceId;
// null for new records
  @override
  final String companyId;
  @override
  final String? storeId;
  @override
  final String locationId;
  @override
  final String userId;
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

// Each currency with totalAmount (no denominations used)
  /// Flag to indicate if user explicitly entered a value (including 0)
  /// Used to distinguish between "not entered" vs "explicitly set to 0"
  @override
  @JsonKey()
  final bool isExplicitlySet;

  @override
  String toString() {
    return 'BankBalance(balanceId: $balanceId, companyId: $companyId, storeId: $storeId, locationId: $locationId, userId: $userId, recordDate: $recordDate, createdAt: $createdAt, currencies: $currencies, isExplicitlySet: $isExplicitlySet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankBalanceImpl &&
            (identical(other.balanceId, balanceId) ||
                other.balanceId == balanceId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies) &&
            (identical(other.isExplicitlySet, isExplicitlySet) ||
                other.isExplicitlySet == isExplicitlySet));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      balanceId,
      companyId,
      storeId,
      locationId,
      userId,
      recordDate,
      createdAt,
      const DeepCollectionEquality().hash(_currencies),
      isExplicitlySet);

  /// Create a copy of BankBalance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankBalanceImplCopyWith<_$BankBalanceImpl> get copyWith =>
      __$$BankBalanceImplCopyWithImpl<_$BankBalanceImpl>(this, _$identity);
}

abstract class _BankBalance extends BankBalance {
  const factory _BankBalance(
      {final String? balanceId,
      required final String companyId,
      final String? storeId,
      required final String locationId,
      required final String userId,
      required final DateTime recordDate,
      required final DateTime createdAt,
      required final List<Currency> currencies,
      final bool isExplicitlySet}) = _$BankBalanceImpl;
  const _BankBalance._() : super._();

  @override
  String? get balanceId; // null for new records
  @override
  String get companyId;
  @override
  String? get storeId;
  @override
  String get locationId;
  @override
  String get userId;
  @override
  DateTime get recordDate;
  @override
  DateTime get createdAt;
  @override
  List<Currency>
      get currencies; // Each currency with totalAmount (no denominations used)
  /// Flag to indicate if user explicitly entered a value (including 0)
  /// Used to distinguish between "not entered" vs "explicitly set to 0"
  @override
  bool get isExplicitlySet;

  /// Create a copy of BankBalance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankBalanceImplCopyWith<_$BankBalanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
