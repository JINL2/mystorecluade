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

CounterParty _$CounterPartyFromJson(Map<String, dynamic> json) {
  return _CounterParty.fromJson(json);
}

/// @nodoc
mixin _$CounterParty {
  @JsonKey(name: 'counterparty_id')
  String get counterpartyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
  CounterPartyType get type => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_internal')
  bool get isInternal => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'updated_at',
      includeIfNull: false,
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted =>
      throw _privateConstructorUsedError; // Additional fields for enhanced functionality
  @JsonKey(
      name: 'last_transaction_date',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get lastTransactionDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_transactions')
  int get totalTransactions => throw _privateConstructorUsedError;
  @JsonKey(name: 'balance')
  double get balance => throw _privateConstructorUsedError;

  /// Serializes this CounterParty to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'counterparty_id') String counterpartyId,
      @JsonKey(name: 'company_id') String companyId,
      String name,
      @JsonKey(
          fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      @JsonKey(
          name: 'updated_at',
          includeIfNull: false,
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(
          name: 'last_transaction_date',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? lastTransactionDate,
      @JsonKey(name: 'total_transactions') int totalTransactions,
      @JsonKey(name: 'balance') double balance});
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
      {@JsonKey(name: 'counterparty_id') String counterpartyId,
      @JsonKey(name: 'company_id') String companyId,
      String name,
      @JsonKey(
          fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      @JsonKey(
          name: 'updated_at',
          includeIfNull: false,
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(
          name: 'last_transaction_date',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? lastTransactionDate,
      @JsonKey(name: 'total_transactions') int totalTransactions,
      @JsonKey(name: 'balance') double balance});
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
@JsonSerializable()
class _$CounterPartyImpl extends _CounterParty {
  const _$CounterPartyImpl(
      {@JsonKey(name: 'counterparty_id') required this.counterpartyId,
      @JsonKey(name: 'company_id') required this.companyId,
      required this.name,
      @JsonKey(
          fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
      required this.type,
      this.email,
      this.phone,
      this.address,
      this.notes,
      @JsonKey(name: 'is_internal') this.isInternal = false,
      @JsonKey(name: 'linked_company_id') this.linkedCompanyId,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      required this.createdAt,
      @JsonKey(
          name: 'updated_at',
          includeIfNull: false,
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(
          name: 'last_transaction_date',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.lastTransactionDate,
      @JsonKey(name: 'total_transactions') this.totalTransactions = 0,
      @JsonKey(name: 'balance') this.balance = 0.0})
      : super._();

  factory _$CounterPartyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyImplFromJson(json);

  @override
  @JsonKey(name: 'counterparty_id')
  final String counterpartyId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  final String name;
  @override
  @JsonKey(fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
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
  @JsonKey(name: 'is_internal')
  final bool isInternal;
  @override
  @JsonKey(name: 'linked_company_id')
  final String? linkedCompanyId;
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      includeIfNull: false,
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
// Additional fields for enhanced functionality
  @override
  @JsonKey(
      name: 'last_transaction_date',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? lastTransactionDate;
  @override
  @JsonKey(name: 'total_transactions')
  final int totalTransactions;
  @override
  @JsonKey(name: 'balance')
  final double balance;

  @override
  String toString() {
    return 'CounterParty(counterpartyId: $counterpartyId, companyId: $companyId, name: $name, type: $type, email: $email, phone: $phone, address: $address, notes: $notes, isInternal: $isInternal, linkedCompanyId: $linkedCompanyId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted, lastTransactionDate: $lastTransactionDate, totalTransactions: $totalTransactions, balance: $balance)';
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyImplToJson(
      this,
    );
  }
}

abstract class _CounterParty extends CounterParty {
  const factory _CounterParty(
      {@JsonKey(name: 'counterparty_id') required final String counterpartyId,
      @JsonKey(name: 'company_id') required final String companyId,
      required final String name,
      @JsonKey(
          fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
      required final CounterPartyType type,
      final String? email,
      final String? phone,
      final String? address,
      final String? notes,
      @JsonKey(name: 'is_internal') final bool isInternal,
      @JsonKey(name: 'linked_company_id') final String? linkedCompanyId,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJson,
          toJson: _dateTimeToJson)
      required final DateTime createdAt,
      @JsonKey(
          name: 'updated_at',
          includeIfNull: false,
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') final bool isDeleted,
      @JsonKey(
          name: 'last_transaction_date',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? lastTransactionDate,
      @JsonKey(name: 'total_transactions') final int totalTransactions,
      @JsonKey(name: 'balance') final double balance}) = _$CounterPartyImpl;
  const _CounterParty._() : super._();

  factory _CounterParty.fromJson(Map<String, dynamic> json) =
      _$CounterPartyImpl.fromJson;

  @override
  @JsonKey(name: 'counterparty_id')
  String get counterpartyId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  String get name;
  @override
  @JsonKey(fromJson: counterPartyTypeFromJson, toJson: counterPartyTypeToJson)
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
  @JsonKey(name: 'is_internal')
  bool get isInternal;
  @override
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId;
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(
      name: 'created_at', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime get createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      includeIfNull: false,
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted; // Additional fields for enhanced functionality
  @override
  @JsonKey(
      name: 'last_transaction_date',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get lastTransactionDate;
  @override
  @JsonKey(name: 'total_transactions')
  int get totalTransactions;
  @override
  @JsonKey(name: 'balance')
  double get balance;

  /// Create a copy of CounterParty
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyImplCopyWith<_$CounterPartyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
