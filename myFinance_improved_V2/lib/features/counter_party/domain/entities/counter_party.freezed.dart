// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CounterParty {
  String get counterpartyId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CounterPartyType get type => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  String? get linkedCompanyId => throw _privateConstructorUsedError;
  String? get linkedCompanyName => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get lastTransactionDate => throw _privateConstructorUsedError;
  int get totalTransactions => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyCopyWith<CounterParty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyCopyWith<$Res> {
  factory $CounterPartyCopyWith(
          CounterParty value, $Res Function(CounterParty) then) =
      _$CounterPartyCopyWithImpl<$Res, CounterParty>;
  @useResult
  $Res call(
      {String counterpartyId,
      String companyId,
      String name,
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      bool isInternal,
      String? linkedCompanyId,
      String? linkedCompanyName,
      String? createdBy,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isDeleted,
      DateTime? lastTransactionDate,
      int totalTransactions,
      double balance});
}

/// @nodoc
class _$CounterPartyCopyWithImpl<$Res, $Val extends CounterParty>
    implements $CounterPartyCopyWith<$Res> {
  _$CounterPartyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? companyId = null,
    Object? name = null,
    Object? type = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
    Object? linkedCompanyName = freezed,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
    Object? lastTransactionDate = freezed,
    Object? totalTransactions = null,
    Object? balance = null,
  }) {
    return _then(_value.copyWith(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CounterPartyType,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyImplCopyWith<$Res>
    implements $CounterPartyCopyWith<$Res> {
  factory _$$CounterPartyImplCopyWith(
          _$CounterPartyImpl value, $Res Function(_$CounterPartyImpl) then) =
      __$$CounterPartyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String counterpartyId,
      String companyId,
      String name,
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      bool isInternal,
      String? linkedCompanyId,
      String? linkedCompanyName,
      String? createdBy,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isDeleted,
      DateTime? lastTransactionDate,
      int totalTransactions,
      double balance});
}

/// @nodoc
class __$$CounterPartyImplCopyWithImpl<$Res>
    extends _$CounterPartyCopyWithImpl<$Res, _$CounterPartyImpl>
    implements _$$CounterPartyImplCopyWith<$Res> {
  __$$CounterPartyImplCopyWithImpl(
      _$CounterPartyImpl _value, $Res Function(_$CounterPartyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = null,
    Object? companyId = null,
    Object? name = null,
    Object? type = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? notes = freezed,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
    Object? linkedCompanyName = freezed,
    Object? createdBy = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
    Object? lastTransactionDate = freezed,
    Object? totalTransactions = null,
    Object? balance = null,
  }) {
    return _then(_$CounterPartyImpl(
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CounterPartyType,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTransactionDate: freezed == lastTransactionDate
          ? _value.lastTransactionDate
          : lastTransactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalTransactions: null == totalTransactions
          ? _value.totalTransactions
          : totalTransactions // ignore: cast_nullable_to_non_nullable
              as int,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CounterPartyImpl extends _CounterParty {
  const _$CounterPartyImpl(
      {required this.counterpartyId,
      required this.companyId,
      required this.name,
      required this.type,
      this.email,
      this.phone,
      this.address,
      this.notes,
      this.isInternal = false,
      this.linkedCompanyId,
      this.linkedCompanyName,
      this.createdBy,
      required this.createdAt,
      this.updatedAt,
      this.isDeleted = false,
      this.lastTransactionDate,
      this.totalTransactions = 0,
      this.balance = 0.0})
      : super._();

  @override
  final String counterpartyId;
  @override
  final String companyId;
  @override
  final String name;
  @override
  final CounterPartyType type;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isInternal;
  @override
  final String? linkedCompanyId;
  @override
  final String? linkedCompanyName;
  @override
  final String? createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? lastTransactionDate;
  @override
  @JsonKey()
  final int totalTransactions;
  @override
  @JsonKey()
  final double balance;

  @override
  String toString() {
    return 'CounterParty(counterpartyId: $counterpartyId, companyId: $companyId, name: $name, type: $type, email: $email, phone: $phone, address: $address, notes: $notes, isInternal: $isInternal, linkedCompanyId: $linkedCompanyId, linkedCompanyName: $linkedCompanyName, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, lastTransactionDate: $lastTransactionDate, totalTransactions: $totalTransactions, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyImpl &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.lastTransactionDate, lastTransactionDate) ||
                other.lastTransactionDate == lastTransactionDate) &&
            (identical(other.totalTransactions, totalTransactions) ||
                other.totalTransactions == totalTransactions) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      counterpartyId,
      companyId,
      name,
      type,
      email,
      phone,
      address,
      notes,
      isInternal,
      linkedCompanyId,
      linkedCompanyName,
      createdBy,
      createdAt,
      updatedAt,
      isDeleted,
      lastTransactionDate,
      totalTransactions,
      balance);

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyImplCopyWith<_$CounterPartyImpl> get copyWith =>
      __$$CounterPartyImplCopyWithImpl<_$CounterPartyImpl>(this, _$identity);
}

abstract class _CounterParty extends CounterParty {
  const factory _CounterParty(
      {required final String counterpartyId,
      required final String companyId,
      required final String name,
      required final CounterPartyType type,
      final String? email,
      final String? phone,
      final String? address,
      final String? notes,
      final bool isInternal,
      final String? linkedCompanyId,
      final String? linkedCompanyName,
      final String? createdBy,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isDeleted,
      final DateTime? lastTransactionDate,
      final int totalTransactions,
      final double balance}) = _$CounterPartyImpl;
  const _CounterParty._() : super._();

  @override
  String get counterpartyId;
  @override
  String get companyId;
  @override
  String get name;
  @override
  CounterPartyType get type;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  String? get notes;
  @override
  bool get isInternal;
  @override
  String? get linkedCompanyId;
  @override
  String? get linkedCompanyName;
  @override
  String? get createdBy;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  bool get isDeleted;
  @override
  DateTime? get lastTransactionDate;
  @override
  int get totalTransactions;
  @override
  double get balance;

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyImplCopyWith<_$CounterPartyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
