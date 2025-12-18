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
  String? get transactionId =>
      throw _privateConstructorUsedError; // null for new records
  String get companyId => throw _privateConstructorUsedError;
  String? get storeId => throw _privateConstructorUsedError;
  String get locationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get recordDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  bool get isCredit =>
      throw _privateConstructorUsedError; // true for OUT (credit), false for IN (debit)
  List<Currency> get currencies => throw _privateConstructorUsedError;

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
      {String? transactionId,
      String companyId,
      String? storeId,
      String locationId,
      String userId,
      DateTime recordDate,
      DateTime createdAt,
      bool isCredit,
      List<Currency> currencies});
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
    Object? transactionId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? isCredit = null,
    Object? currencies = null,
  }) {
    return _then(_value.copyWith(
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
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
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      currencies: null == currencies
          ? _value.currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ) as $Val);
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
      {String? transactionId,
      String companyId,
      String? storeId,
      String locationId,
      String userId,
      DateTime recordDate,
      DateTime createdAt,
      bool isCredit,
      List<Currency> currencies});
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
    Object? transactionId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? isCredit = null,
    Object? currencies = null,
  }) {
    return _then(_$VaultTransactionImpl(
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
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
      isCredit: null == isCredit
          ? _value.isCredit
          : isCredit // ignore: cast_nullable_to_non_nullable
              as bool,
      currencies: null == currencies
          ? _value._currencies
          : currencies // ignore: cast_nullable_to_non_nullable
              as List<Currency>,
    ));
  }
}

/// @nodoc

class _$VaultTransactionImpl extends _VaultTransaction {
  const _$VaultTransactionImpl(
      {this.transactionId,
      required this.companyId,
      this.storeId,
      required this.locationId,
      required this.userId,
      required this.recordDate,
      required this.createdAt,
      required this.isCredit,
      required final List<Currency> currencies})
      : _currencies = currencies,
        super._();

  @override
  final String? transactionId;
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
  @override
  final bool isCredit;
// true for OUT (credit), false for IN (debit)
  final List<Currency> _currencies;
// true for OUT (credit), false for IN (debit)
  @override
  List<Currency> get currencies {
    if (_currencies is EqualUnmodifiableListView) return _currencies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currencies);
  }

  @override
  String toString() {
    return 'VaultTransaction(transactionId: $transactionId, companyId: $companyId, storeId: $storeId, locationId: $locationId, userId: $userId, recordDate: $recordDate, createdAt: $createdAt, isCredit: $isCredit, currencies: $currencies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultTransactionImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
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
            (identical(other.isCredit, isCredit) ||
                other.isCredit == isCredit) &&
            const DeepCollectionEquality()
                .equals(other._currencies, _currencies));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionId,
      companyId,
      storeId,
      locationId,
      userId,
      recordDate,
      createdAt,
      isCredit,
      const DeepCollectionEquality().hash(_currencies));

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
      {final String? transactionId,
      required final String companyId,
      final String? storeId,
      required final String locationId,
      required final String userId,
      required final DateTime recordDate,
      required final DateTime createdAt,
      required final bool isCredit,
      required final List<Currency> currencies}) = _$VaultTransactionImpl;
  const _VaultTransaction._() : super._();

  @override
  String? get transactionId; // null for new records
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
  bool get isCredit; // true for OUT (credit), false for IN (debit)
  @override
  List<Currency> get currencies;

  /// Create a copy of VaultTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultTransactionImplCopyWith<_$VaultTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
