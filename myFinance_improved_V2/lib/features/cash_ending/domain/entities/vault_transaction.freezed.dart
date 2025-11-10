// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$VaultTransaction {
  String? get vaultTransactionId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  bool get isCredit => throw _privateConstructorUsedError;
  bool get isDebit => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  Currency get currency => throw _privateConstructorUsedError;

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultTransactionCopyWith<VaultTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultTransactionCopyWith<$Res> {
  factory $VaultTransactionCopyWith(
          VaultTransaction value, $Res Function(VaultTransaction) then) =
      _$VaultTransactionCopyWithImpl<$Res, VaultTransaction>;
  @useResult
  $Res call(
      {String? vaultTransactionId,
      String companyId,
      String userId,
      String locationId,
      String? storeId,
      String currencyId,
      bool isCredit,
      bool isDebit,
      DateTime recordDate,
      DateTime createdAt,
      Currency currency});

  $CurrencyCopyWith<$Res> get currency;
}

/// @nodoc
class _$VaultTransactionCopyWithImpl<$Res, $Val extends VaultTransaction>
    implements $VaultTransactionCopyWith<$Res> {
  _$VaultTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultTransactionId = freezed,
    Object? companyId = null,
    Object? userId = null,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? currencyId = null,
    Object? isCredit = null,
    Object? isDebit = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currency = null,
  }) {
    return _then(_value.copyWith(
      vaultTransactionId: freezed == vaultTransactionId
          ? _value.vaultTransactionId
          : vaultTransactionId // ignore: cast_nullable_to_non_nullable
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
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency,
    ) as $Val);
  }

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CurrencyCopyWith<$Res> get currency {
    return $CurrencyCopyWith<$Res>(_value.currency, (value) {
      return _then(_value.copyWith(currency: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VaultTransactionImplCopyWith<$Res>
    implements $VaultTransactionCopyWith<$Res> {
  factory _$$VaultTransactionImplCopyWith(_$VaultTransactionImpl value,
          $Res Function(_$VaultTransactionImpl) then) =
      __$$VaultTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? vaultTransactionId,
      String companyId,
      String userId,
      String locationId,
      String? storeId,
      String currencyId,
      bool isCredit,
      bool isDebit,
      DateTime recordDate,
      DateTime createdAt,
      Currency currency});

  @override
  $CurrencyCopyWith<$Res> get currency;
}

/// @nodoc
class __$$VaultTransactionImplCopyWithImpl<$Res>
    extends _$VaultTransactionCopyWithImpl<$Res, _$VaultTransactionImpl>
    implements _$$VaultTransactionImplCopyWith<$Res> {
  __$$VaultTransactionImplCopyWithImpl(_$VaultTransactionImpl _value,
      $Res Function(_$VaultTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vaultTransactionId = freezed,
    Object? companyId = null,
    Object? userId = null,
    Object? locationId = null,
    Object? storeId = freezed,
    Object? currencyId = null,
    Object? isCredit = null,
    Object? isDebit = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? currency = null,
  }) {
    return _then(_$VaultTransactionImpl(
      vaultTransactionId: freezed == vaultTransactionId
          ? _value.vaultTransactionId
          : vaultTransactionId // ignore: cast_nullable_to_non_nullable
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
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      isDebit: null == isDebit
          ? _value.isDebit
          : isDebit // ignore: cast_nullable_to_non_nullable
              as bool,
      recordDate: null == recordDate
          ? _value.recordDate
          : recordDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as Currency,
    ));
  }
}

/// @nodoc

class _$VaultTransactionImpl extends _VaultTransaction {
  const _$VaultTransactionImpl(
      {this.vaultTransactionId,
      required this.companyId,
      required this.userId,
      required this.locationId,
      this.storeId,
      required this.currencyId,
      required this.isCredit,
      required this.isDebit,
      required this.recordDate,
      required this.createdAt,
      required this.currency})
      : super._();

  @override
  final String? vaultTransactionId;
  @override
  final String companyId;
  @override
  final String userId;
  @override
  final String locationId;
  @override
  final String? storeId;
  @override
  final String currencyId;
  @override
  final bool isCredit;
  @override
  final bool isDebit;
  @override
  final DateTime recordDate;
  @override
  final DateTime createdAt;
  @override
  final Currency currency;

  @override
  String toString() {
    return 'VaultTransaction(vaultTransactionId: $vaultTransactionId, companyId: $companyId, userId: $userId, locationId: $locationId, storeId: $storeId, currencyId: $currencyId, isCredit: $isCredit, isDebit: $isDebit, recordDate: $recordDate, createdAt: $createdAt, currency: $currency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultTransactionImpl &&
            (identical(other.vaultTransactionId, vaultTransactionId) ||
                other.vaultTransactionId == vaultTransactionId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.isCredit, isCredit) ||
                other.isCredit == isCredit) &&
            (identical(other.isDebit, isDebit) || other.isDebit == isDebit) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.currency, currency) ||
                other.currency == currency));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      vaultTransactionId,
      companyId,
      userId,
      locationId,
      storeId,
      currencyId,
      isCredit,
      isDebit,
      recordDate,
      createdAt,
      currency);

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultTransactionImplCopyWith<_$VaultTransactionImpl> get copyWith =>
      __$$VaultTransactionImplCopyWithImpl<_$VaultTransactionImpl>(
          this, _$identity);
}

abstract class _VaultTransaction extends VaultTransaction {
  const factory _VaultTransaction(
      {final String? vaultTransactionId,
      required final String companyId,
      required final String userId,
      required final String locationId,
      final String? storeId,
      required final String currencyId,
      required final bool isCredit,
      required final bool isDebit,
      required final DateTime recordDate,
      required final DateTime createdAt,
      required final Currency currency}) = _$VaultTransactionImpl;
  const _VaultTransaction._() : super._();

  @override
  String? get vaultTransactionId;
  @override
  String get companyId;
  @override
  String get userId;
  @override
  String get locationId;
  @override
  String? get storeId;
  @override
  String get currencyId;
  @override
  bool get isCredit;
  @override
  bool get isDebit;
  @override
  DateTime get recordDate;
  @override
  DateTime get createdAt;
  @override
  Currency get currency;

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultTransactionImplCopyWith<_$VaultTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
