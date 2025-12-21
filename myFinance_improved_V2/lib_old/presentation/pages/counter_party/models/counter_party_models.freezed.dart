// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_party_models.dart';

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
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
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
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', includeIfNull: false)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted =>
      throw _privateConstructorUsedError; // Additional fields for enhanced functionality
  @JsonKey(name: 'last_transaction_date')
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
      @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'last_transaction_date') DateTime? lastTransactionDate,
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
      @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
      CounterPartyType type,
      String? email,
      String? phone,
      String? address,
      String? notes,
      @JsonKey(name: 'is_internal') bool isInternal,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at', includeIfNull: false) DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'last_transaction_date') DateTime? lastTransactionDate,
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
      @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson) required this.type,
      this.email,
      this.phone,
      this.address,
      this.notes,
      @JsonKey(name: 'is_internal') this.isInternal = false,
      @JsonKey(name: 'linked_company_id') this.linkedCompanyId,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at', includeIfNull: false) this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(name: 'last_transaction_date') this.lastTransactionDate,
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
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
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
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at', includeIfNull: false)
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
// Additional fields for enhanced functionality
  @override
  @JsonKey(name: 'last_transaction_date')
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
      @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
      required final CounterPartyType type,
      final String? email,
      final String? phone,
      final String? address,
      final String? notes,
      @JsonKey(name: 'is_internal') final bool isInternal,
      @JsonKey(name: 'linked_company_id') final String? linkedCompanyId,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at', includeIfNull: false)
      final DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') final bool isDeleted,
      @JsonKey(name: 'last_transaction_date')
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
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
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
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at', includeIfNull: false)
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted; // Additional fields for enhanced functionality
  @override
  @JsonKey(name: 'last_transaction_date')
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

CounterPartyStats _$CounterPartyStatsFromJson(Map<String, dynamic> json) {
  return _CounterPartyStats.fromJson(json);
}

/// @nodoc
mixin _$CounterPartyStats {
  int get total => throw _privateConstructorUsedError;
  int get suppliers => throw _privateConstructorUsedError;
  int get customers => throw _privateConstructorUsedError;
  int get employees => throw _privateConstructorUsedError;
  int get teamMembers => throw _privateConstructorUsedError;
  int get myCompanies => throw _privateConstructorUsedError;
  int get others => throw _privateConstructorUsedError;
  int get activeCount => throw _privateConstructorUsedError;
  int get inactiveCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_additions')
  List<CounterParty> get recentAdditions => throw _privateConstructorUsedError;

  /// Serializes this CounterPartyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyStatsCopyWith<CounterPartyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyStatsCopyWith<$Res> {
  factory $CounterPartyStatsCopyWith(
          CounterPartyStats value, $Res Function(CounterPartyStats) then) =
      _$CounterPartyStatsCopyWithImpl<$Res, CounterPartyStats>;
  @useResult
  $Res call(
      {int total,
      int suppliers,
      int customers,
      int employees,
      int teamMembers,
      int myCompanies,
      int others,
      int activeCount,
      int inactiveCount,
      @JsonKey(name: 'recent_additions') List<CounterParty> recentAdditions});
}

/// @nodoc
class _$CounterPartyStatsCopyWithImpl<$Res, $Val extends CounterPartyStats>
    implements $CounterPartyStatsCopyWith<$Res> {
  _$CounterPartyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? suppliers = null,
    Object? customers = null,
    Object? employees = null,
    Object? teamMembers = null,
    Object? myCompanies = null,
    Object? others = null,
    Object? activeCount = null,
    Object? inactiveCount = null,
    Object? recentAdditions = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      suppliers: null == suppliers
          ? _value.suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as int,
      customers: null == customers
          ? _value.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as int,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as int,
      teamMembers: null == teamMembers
          ? _value.teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as int,
      myCompanies: null == myCompanies
          ? _value.myCompanies
          : myCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      others: null == others
          ? _value.others
          : others // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveCount: null == inactiveCount
          ? _value.inactiveCount
          : inactiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentAdditions: null == recentAdditions
          ? _value.recentAdditions
          : recentAdditions // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyStatsImplCopyWith<$Res>
    implements $CounterPartyStatsCopyWith<$Res> {
  factory _$$CounterPartyStatsImplCopyWith(_$CounterPartyStatsImpl value,
          $Res Function(_$CounterPartyStatsImpl) then) =
      __$$CounterPartyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int suppliers,
      int customers,
      int employees,
      int teamMembers,
      int myCompanies,
      int others,
      int activeCount,
      int inactiveCount,
      @JsonKey(name: 'recent_additions') List<CounterParty> recentAdditions});
}

/// @nodoc
class __$$CounterPartyStatsImplCopyWithImpl<$Res>
    extends _$CounterPartyStatsCopyWithImpl<$Res, _$CounterPartyStatsImpl>
    implements _$$CounterPartyStatsImplCopyWith<$Res> {
  __$$CounterPartyStatsImplCopyWithImpl(_$CounterPartyStatsImpl _value,
      $Res Function(_$CounterPartyStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? suppliers = null,
    Object? customers = null,
    Object? employees = null,
    Object? teamMembers = null,
    Object? myCompanies = null,
    Object? others = null,
    Object? activeCount = null,
    Object? inactiveCount = null,
    Object? recentAdditions = null,
  }) {
    return _then(_$CounterPartyStatsImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      suppliers: null == suppliers
          ? _value.suppliers
          : suppliers // ignore: cast_nullable_to_non_nullable
              as int,
      customers: null == customers
          ? _value.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as int,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as int,
      teamMembers: null == teamMembers
          ? _value.teamMembers
          : teamMembers // ignore: cast_nullable_to_non_nullable
              as int,
      myCompanies: null == myCompanies
          ? _value.myCompanies
          : myCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      others: null == others
          ? _value.others
          : others // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      inactiveCount: null == inactiveCount
          ? _value.inactiveCount
          : inactiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentAdditions: null == recentAdditions
          ? _value._recentAdditions
          : recentAdditions // ignore: cast_nullable_to_non_nullable
              as List<CounterParty>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyStatsImpl implements _CounterPartyStats {
  const _$CounterPartyStatsImpl(
      {required this.total,
      required this.suppliers,
      required this.customers,
      required this.employees,
      required this.teamMembers,
      required this.myCompanies,
      required this.others,
      required this.activeCount,
      required this.inactiveCount,
      @JsonKey(name: 'recent_additions')
      required final List<CounterParty> recentAdditions})
      : _recentAdditions = recentAdditions;

  factory _$CounterPartyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyStatsImplFromJson(json);

  @override
  final int total;
  @override
  final int suppliers;
  @override
  final int customers;
  @override
  final int employees;
  @override
  final int teamMembers;
  @override
  final int myCompanies;
  @override
  final int others;
  @override
  final int activeCount;
  @override
  final int inactiveCount;
  final List<CounterParty> _recentAdditions;
  @override
  @JsonKey(name: 'recent_additions')
  List<CounterParty> get recentAdditions {
    if (_recentAdditions is EqualUnmodifiableListView) return _recentAdditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentAdditions);
  }

  @override
  String toString() {
    return 'CounterPartyStats(total: $total, suppliers: $suppliers, customers: $customers, employees: $employees, teamMembers: $teamMembers, myCompanies: $myCompanies, others: $others, activeCount: $activeCount, inactiveCount: $inactiveCount, recentAdditions: $recentAdditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyStatsImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.suppliers, suppliers) ||
                other.suppliers == suppliers) &&
            (identical(other.customers, customers) ||
                other.customers == customers) &&
            (identical(other.employees, employees) ||
                other.employees == employees) &&
            (identical(other.teamMembers, teamMembers) ||
                other.teamMembers == teamMembers) &&
            (identical(other.myCompanies, myCompanies) ||
                other.myCompanies == myCompanies) &&
            (identical(other.others, others) || other.others == others) &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount) &&
            (identical(other.inactiveCount, inactiveCount) ||
                other.inactiveCount == inactiveCount) &&
            const DeepCollectionEquality()
                .equals(other._recentAdditions, _recentAdditions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      suppliers,
      customers,
      employees,
      teamMembers,
      myCompanies,
      others,
      activeCount,
      inactiveCount,
      const DeepCollectionEquality().hash(_recentAdditions));

  /// Create a copy of CounterPartyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyStatsImplCopyWith<_$CounterPartyStatsImpl> get copyWith =>
      __$$CounterPartyStatsImplCopyWithImpl<_$CounterPartyStatsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyStatsImplToJson(
      this,
    );
  }
}

abstract class _CounterPartyStats implements CounterPartyStats {
  const factory _CounterPartyStats(
          {required final int total,
          required final int suppliers,
          required final int customers,
          required final int employees,
          required final int teamMembers,
          required final int myCompanies,
          required final int others,
          required final int activeCount,
          required final int inactiveCount,
          @JsonKey(name: 'recent_additions')
          required final List<CounterParty> recentAdditions}) =
      _$CounterPartyStatsImpl;

  factory _CounterPartyStats.fromJson(Map<String, dynamic> json) =
      _$CounterPartyStatsImpl.fromJson;

  @override
  int get total;
  @override
  int get suppliers;
  @override
  int get customers;
  @override
  int get employees;
  @override
  int get teamMembers;
  @override
  int get myCompanies;
  @override
  int get others;
  @override
  int get activeCount;
  @override
  int get inactiveCount;
  @override
  @JsonKey(name: 'recent_additions')
  List<CounterParty> get recentAdditions;

  /// Create a copy of CounterPartyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyStatsImplCopyWith<_$CounterPartyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CounterPartyFormData _$CounterPartyFormDataFromJson(Map<String, dynamic> json) {
  return _CounterPartyFormData.fromJson(json);
}

/// @nodoc
mixin _$CounterPartyFormData {
  String? get counterpartyId => throw _privateConstructorUsedError;
  String get companyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  CounterPartyType get type => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  String? get linkedCompanyId => throw _privateConstructorUsedError;

  /// Serializes this CounterPartyFormData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyFormDataCopyWith<CounterPartyFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyFormDataCopyWith<$Res> {
  factory $CounterPartyFormDataCopyWith(CounterPartyFormData value,
          $Res Function(CounterPartyFormData) then) =
      _$CounterPartyFormDataCopyWithImpl<$Res, CounterPartyFormData>;
  @useResult
  $Res call(
      {String? counterpartyId,
      String companyId,
      String name,
      CounterPartyType type,
      String email,
      String phone,
      String address,
      String notes,
      bool isInternal,
      String? linkedCompanyId});
}

/// @nodoc
class _$CounterPartyFormDataCopyWithImpl<$Res,
        $Val extends CounterPartyFormData>
    implements $CounterPartyFormDataCopyWith<$Res> {
  _$CounterPartyFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = freezed,
    Object? companyId = null,
    Object? name = null,
    Object? type = null,
    Object? email = null,
    Object? phone = null,
    Object? address = null,
    Object? notes = null,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_value.copyWith(
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyFormDataImplCopyWith<$Res>
    implements $CounterPartyFormDataCopyWith<$Res> {
  factory _$$CounterPartyFormDataImplCopyWith(_$CounterPartyFormDataImpl value,
          $Res Function(_$CounterPartyFormDataImpl) then) =
      __$$CounterPartyFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? counterpartyId,
      String companyId,
      String name,
      CounterPartyType type,
      String email,
      String phone,
      String address,
      String notes,
      bool isInternal,
      String? linkedCompanyId});
}

/// @nodoc
class __$$CounterPartyFormDataImplCopyWithImpl<$Res>
    extends _$CounterPartyFormDataCopyWithImpl<$Res, _$CounterPartyFormDataImpl>
    implements _$$CounterPartyFormDataImplCopyWith<$Res> {
  __$$CounterPartyFormDataImplCopyWithImpl(_$CounterPartyFormDataImpl _value,
      $Res Function(_$CounterPartyFormDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counterpartyId = freezed,
    Object? companyId = null,
    Object? name = null,
    Object? type = null,
    Object? email = null,
    Object? phone = null,
    Object? address = null,
    Object? notes = null,
    Object? isInternal = null,
    Object? linkedCompanyId = freezed,
  }) {
    return _then(_$CounterPartyFormDataImpl(
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyFormDataImpl implements _CounterPartyFormData {
  const _$CounterPartyFormDataImpl(
      {this.counterpartyId,
      required this.companyId,
      this.name = '',
      this.type = CounterPartyType.other,
      this.email = '',
      this.phone = '',
      this.address = '',
      this.notes = '',
      this.isInternal = false,
      this.linkedCompanyId});

  factory _$CounterPartyFormDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyFormDataImplFromJson(json);

  @override
  final String? counterpartyId;
  @override
  final String companyId;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final CounterPartyType type;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final bool isInternal;
  @override
  final String? linkedCompanyId;

  @override
  String toString() {
    return 'CounterPartyFormData(counterpartyId: $counterpartyId, companyId: $companyId, name: $name, type: $type, email: $email, phone: $phone, address: $address, notes: $notes, isInternal: $isInternal, linkedCompanyId: $linkedCompanyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyFormDataImpl &&
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
                other.linkedCompanyId == linkedCompanyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, counterpartyId, companyId, name,
      type, email, phone, address, notes, isInternal, linkedCompanyId);

  /// Create a copy of CounterPartyFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyFormDataImplCopyWith<_$CounterPartyFormDataImpl>
      get copyWith =>
          __$$CounterPartyFormDataImplCopyWithImpl<_$CounterPartyFormDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyFormDataImplToJson(
      this,
    );
  }
}

abstract class _CounterPartyFormData implements CounterPartyFormData {
  const factory _CounterPartyFormData(
      {final String? counterpartyId,
      required final String companyId,
      final String name,
      final CounterPartyType type,
      final String email,
      final String phone,
      final String address,
      final String notes,
      final bool isInternal,
      final String? linkedCompanyId}) = _$CounterPartyFormDataImpl;

  factory _CounterPartyFormData.fromJson(Map<String, dynamic> json) =
      _$CounterPartyFormDataImpl.fromJson;

  @override
  String? get counterpartyId;
  @override
  String get companyId;
  @override
  String get name;
  @override
  CounterPartyType get type;
  @override
  String get email;
  @override
  String get phone;
  @override
  String get address;
  @override
  String get notes;
  @override
  bool get isInternal;
  @override
  String? get linkedCompanyId;

  /// Create a copy of CounterPartyFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyFormDataImplCopyWith<_$CounterPartyFormDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CounterPartyFilter _$CounterPartyFilterFromJson(Map<String, dynamic> json) {
  return _CounterPartyFilter.fromJson(json);
}

/// @nodoc
mixin _$CounterPartyFilter {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<CounterPartyType>? get types => throw _privateConstructorUsedError;
  CounterPartySortOption get sortBy => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;
  bool? get isInternal => throw _privateConstructorUsedError;
  DateTime? get createdAfter => throw _privateConstructorUsedError;
  DateTime? get createdBefore => throw _privateConstructorUsedError;
  bool get includeDeleted => throw _privateConstructorUsedError;

  /// Serializes this CounterPartyFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyFilterCopyWith<CounterPartyFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyFilterCopyWith<$Res> {
  factory $CounterPartyFilterCopyWith(
          CounterPartyFilter value, $Res Function(CounterPartyFilter) then) =
      _$CounterPartyFilterCopyWithImpl<$Res, CounterPartyFilter>;
  @useResult
  $Res call(
      {String? searchQuery,
      List<CounterPartyType>? types,
      CounterPartySortOption sortBy,
      bool ascending,
      bool? isInternal,
      DateTime? createdAfter,
      DateTime? createdBefore,
      bool includeDeleted});
}

/// @nodoc
class _$CounterPartyFilterCopyWithImpl<$Res, $Val extends CounterPartyFilter>
    implements $CounterPartyFilterCopyWith<$Res> {
  _$CounterPartyFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? types = freezed,
    Object? sortBy = null,
    Object? ascending = null,
    Object? isInternal = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? includeDeleted = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyType>?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as CounterPartySortOption,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      includeDeleted: null == includeDeleted
          ? _value.includeDeleted
          : includeDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyFilterImplCopyWith<$Res>
    implements $CounterPartyFilterCopyWith<$Res> {
  factory _$$CounterPartyFilterImplCopyWith(_$CounterPartyFilterImpl value,
          $Res Function(_$CounterPartyFilterImpl) then) =
      __$$CounterPartyFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? searchQuery,
      List<CounterPartyType>? types,
      CounterPartySortOption sortBy,
      bool ascending,
      bool? isInternal,
      DateTime? createdAfter,
      DateTime? createdBefore,
      bool includeDeleted});
}

/// @nodoc
class __$$CounterPartyFilterImplCopyWithImpl<$Res>
    extends _$CounterPartyFilterCopyWithImpl<$Res, _$CounterPartyFilterImpl>
    implements _$$CounterPartyFilterImplCopyWith<$Res> {
  __$$CounterPartyFilterImplCopyWithImpl(_$CounterPartyFilterImpl _value,
      $Res Function(_$CounterPartyFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? types = freezed,
    Object? sortBy = null,
    Object? ascending = null,
    Object? isInternal = freezed,
    Object? createdAfter = freezed,
    Object? createdBefore = freezed,
    Object? includeDeleted = null,
  }) {
    return _then(_$CounterPartyFilterImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<CounterPartyType>?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as CounterPartySortOption,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
      isInternal: freezed == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAfter: freezed == createdAfter
          ? _value.createdAfter
          : createdAfter // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBefore: freezed == createdBefore
          ? _value.createdBefore
          : createdBefore // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      includeDeleted: null == includeDeleted
          ? _value.includeDeleted
          : includeDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyFilterImpl implements _CounterPartyFilter {
  const _$CounterPartyFilterImpl(
      {this.searchQuery,
      final List<CounterPartyType>? types,
      this.sortBy = CounterPartySortOption.isInternal,
      this.ascending = false,
      this.isInternal,
      this.createdAfter,
      this.createdBefore,
      this.includeDeleted = true})
      : _types = types;

  factory _$CounterPartyFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyFilterImplFromJson(json);

  @override
  final String? searchQuery;
  final List<CounterPartyType>? _types;
  @override
  List<CounterPartyType>? get types {
    final value = _types;
    if (value == null) return null;
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final CounterPartySortOption sortBy;
  @override
  @JsonKey()
  final bool ascending;
  @override
  final bool? isInternal;
  @override
  final DateTime? createdAfter;
  @override
  final DateTime? createdBefore;
  @override
  @JsonKey()
  final bool includeDeleted;

  @override
  String toString() {
    return 'CounterPartyFilter(searchQuery: $searchQuery, types: $types, sortBy: $sortBy, ascending: $ascending, isInternal: $isInternal, createdAfter: $createdAfter, createdBefore: $createdBefore, includeDeleted: $includeDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyFilterImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.createdAfter, createdAfter) ||
                other.createdAfter == createdAfter) &&
            (identical(other.createdBefore, createdBefore) ||
                other.createdBefore == createdBefore) &&
            (identical(other.includeDeleted, includeDeleted) ||
                other.includeDeleted == includeDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_types),
      sortBy,
      ascending,
      isInternal,
      createdAfter,
      createdBefore,
      includeDeleted);

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyFilterImplCopyWith<_$CounterPartyFilterImpl> get copyWith =>
      __$$CounterPartyFilterImplCopyWithImpl<_$CounterPartyFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyFilterImplToJson(
      this,
    );
  }
}

abstract class _CounterPartyFilter implements CounterPartyFilter {
  const factory _CounterPartyFilter(
      {final String? searchQuery,
      final List<CounterPartyType>? types,
      final CounterPartySortOption sortBy,
      final bool ascending,
      final bool? isInternal,
      final DateTime? createdAfter,
      final DateTime? createdBefore,
      final bool includeDeleted}) = _$CounterPartyFilterImpl;

  factory _CounterPartyFilter.fromJson(Map<String, dynamic> json) =
      _$CounterPartyFilterImpl.fromJson;

  @override
  String? get searchQuery;
  @override
  List<CounterPartyType>? get types;
  @override
  CounterPartySortOption get sortBy;
  @override
  bool get ascending;
  @override
  bool? get isInternal;
  @override
  DateTime? get createdAfter;
  @override
  DateTime? get createdBefore;
  @override
  bool get includeDeleted;

  /// Create a copy of CounterPartyFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyFilterImplCopyWith<_$CounterPartyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ValidationResult {
  bool get isValid => throw _privateConstructorUsedError;
  Map<String, String>? get errors => throw _privateConstructorUsedError;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ValidationResultCopyWith<ValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationResultCopyWith<$Res> {
  factory $ValidationResultCopyWith(
          ValidationResult value, $Res Function(ValidationResult) then) =
      _$ValidationResultCopyWithImpl<$Res, ValidationResult>;
  @useResult
  $Res call({bool isValid, Map<String, String>? errors});
}

/// @nodoc
class _$ValidationResultCopyWithImpl<$Res, $Val extends ValidationResult>
    implements $ValidationResultCopyWith<$Res> {
  _$ValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationResultImplCopyWith<$Res>
    implements $ValidationResultCopyWith<$Res> {
  factory _$$ValidationResultImplCopyWith(_$ValidationResultImpl value,
          $Res Function(_$ValidationResultImpl) then) =
      __$$ValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid, Map<String, String>? errors});
}

/// @nodoc
class __$$ValidationResultImplCopyWithImpl<$Res>
    extends _$ValidationResultCopyWithImpl<$Res, _$ValidationResultImpl>
    implements _$$ValidationResultImplCopyWith<$Res> {
  __$$ValidationResultImplCopyWithImpl(_$ValidationResultImpl _value,
      $Res Function(_$ValidationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = freezed,
  }) {
    return _then(_$ValidationResultImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc

class _$ValidationResultImpl implements _ValidationResult {
  const _$ValidationResultImpl(
      {required this.isValid, final Map<String, String>? errors})
      : _errors = errors;

  @override
  final bool isValid;
  final Map<String, String>? _errors;
  @override
  Map<String, String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ValidationResult(isValid: $isValid, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isValid, const DeepCollectionEquality().hash(_errors));

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      __$$ValidationResultImplCopyWithImpl<_$ValidationResultImpl>(
          this, _$identity);
}

abstract class _ValidationResult implements ValidationResult {
  const factory _ValidationResult(
      {required final bool isValid,
      final Map<String, String>? errors}) = _$ValidationResultImpl;

  @override
  bool get isValid;
  @override
  Map<String, String>? get errors;

  /// Create a copy of ValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationResultImplCopyWith<_$ValidationResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CounterPartyResponse _$CounterPartyResponseFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return CounterPartyResponseSuccess.fromJson(json);
    case 'error':
      return CounterPartyResponseError.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'CounterPartyResponse',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$CounterPartyResponse {
  String? get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CounterParty data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CounterParty data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CounterParty data, String? message)? success,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CounterPartyResponseSuccess value) success,
    required TResult Function(CounterPartyResponseError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CounterPartyResponseSuccess value)? success,
    TResult? Function(CounterPartyResponseError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CounterPartyResponseSuccess value)? success,
    TResult Function(CounterPartyResponseError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this CounterPartyResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterPartyResponseCopyWith<CounterPartyResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterPartyResponseCopyWith<$Res> {
  factory $CounterPartyResponseCopyWith(CounterPartyResponse value,
          $Res Function(CounterPartyResponse) then) =
      _$CounterPartyResponseCopyWithImpl<$Res, CounterPartyResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$CounterPartyResponseCopyWithImpl<$Res,
        $Val extends CounterPartyResponse>
    implements $CounterPartyResponseCopyWith<$Res> {
  _$CounterPartyResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message!
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterPartyResponseSuccessImplCopyWith<$Res>
    implements $CounterPartyResponseCopyWith<$Res> {
  factory _$$CounterPartyResponseSuccessImplCopyWith(
          _$CounterPartyResponseSuccessImpl value,
          $Res Function(_$CounterPartyResponseSuccessImpl) then) =
      __$$CounterPartyResponseSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CounterParty data, String? message});

  $CounterPartyCopyWith<$Res> get data;
}

/// @nodoc
class __$$CounterPartyResponseSuccessImplCopyWithImpl<$Res>
    extends _$CounterPartyResponseCopyWithImpl<$Res,
        _$CounterPartyResponseSuccessImpl>
    implements _$$CounterPartyResponseSuccessImplCopyWith<$Res> {
  __$$CounterPartyResponseSuccessImplCopyWithImpl(
      _$CounterPartyResponseSuccessImpl _value,
      $Res Function(_$CounterPartyResponseSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$CounterPartyResponseSuccessImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CounterParty,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterPartyCopyWith<$Res> get data {
    return $CounterPartyCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyResponseSuccessImpl implements CounterPartyResponseSuccess {
  const _$CounterPartyResponseSuccessImpl(
      {required this.data, this.message, final String? $type})
      : $type = $type ?? 'success';

  factory _$CounterPartyResponseSuccessImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CounterPartyResponseSuccessImplFromJson(json);

  @override
  final CounterParty data;
  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CounterPartyResponse.success(data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyResponseSuccessImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data, message);

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyResponseSuccessImplCopyWith<_$CounterPartyResponseSuccessImpl>
      get copyWith => __$$CounterPartyResponseSuccessImplCopyWithImpl<
          _$CounterPartyResponseSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CounterParty data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) {
    return success(data, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CounterParty data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) {
    return success?.call(data, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CounterParty data, String? message)? success,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CounterPartyResponseSuccess value) success,
    required TResult Function(CounterPartyResponseError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CounterPartyResponseSuccess value)? success,
    TResult? Function(CounterPartyResponseError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CounterPartyResponseSuccess value)? success,
    TResult Function(CounterPartyResponseError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyResponseSuccessImplToJson(
      this,
    );
  }
}

abstract class CounterPartyResponseSuccess implements CounterPartyResponse {
  const factory CounterPartyResponseSuccess(
      {required final CounterParty data,
      final String? message}) = _$CounterPartyResponseSuccessImpl;

  factory CounterPartyResponseSuccess.fromJson(Map<String, dynamic> json) =
      _$CounterPartyResponseSuccessImpl.fromJson;

  CounterParty get data;
  @override
  String? get message;

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyResponseSuccessImplCopyWith<_$CounterPartyResponseSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CounterPartyResponseErrorImplCopyWith<$Res>
    implements $CounterPartyResponseCopyWith<$Res> {
  factory _$$CounterPartyResponseErrorImplCopyWith(
          _$CounterPartyResponseErrorImpl value,
          $Res Function(_$CounterPartyResponseErrorImpl) then) =
      __$$CounterPartyResponseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$CounterPartyResponseErrorImplCopyWithImpl<$Res>
    extends _$CounterPartyResponseCopyWithImpl<$Res,
        _$CounterPartyResponseErrorImpl>
    implements _$$CounterPartyResponseErrorImplCopyWith<$Res> {
  __$$CounterPartyResponseErrorImplCopyWithImpl(
      _$CounterPartyResponseErrorImpl _value,
      $Res Function(_$CounterPartyResponseErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$CounterPartyResponseErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterPartyResponseErrorImpl implements CounterPartyResponseError {
  const _$CounterPartyResponseErrorImpl(
      {required this.message, this.code, final String? $type})
      : $type = $type ?? 'error';

  factory _$CounterPartyResponseErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterPartyResponseErrorImplFromJson(json);

  @override
  final String message;
  @override
  final String? code;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'CounterPartyResponse.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterPartyResponseErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterPartyResponseErrorImplCopyWith<_$CounterPartyResponseErrorImpl>
      get copyWith => __$$CounterPartyResponseErrorImplCopyWithImpl<
          _$CounterPartyResponseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(CounterParty data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(CounterParty data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(CounterParty data, String? message)? success,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CounterPartyResponseSuccess value) success,
    required TResult Function(CounterPartyResponseError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CounterPartyResponseSuccess value)? success,
    TResult? Function(CounterPartyResponseError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CounterPartyResponseSuccess value)? success,
    TResult Function(CounterPartyResponseError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterPartyResponseErrorImplToJson(
      this,
    );
  }
}

abstract class CounterPartyResponseError implements CounterPartyResponse {
  const factory CounterPartyResponseError(
      {required final String message,
      final String? code}) = _$CounterPartyResponseErrorImpl;

  factory CounterPartyResponseError.fromJson(Map<String, dynamic> json) =
      _$CounterPartyResponseErrorImpl.fromJson;

  @override
  String get message;
  String? get code;

  /// Create a copy of CounterPartyResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterPartyResponseErrorImplCopyWith<_$CounterPartyResponseErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchOperationResult _$BatchOperationResultFromJson(Map<String, dynamic> json) {
  return _BatchOperationResult.fromJson(json);
}

/// @nodoc
mixin _$BatchOperationResult {
  int get totalCount => throw _privateConstructorUsedError;
  int get successCount => throw _privateConstructorUsedError;
  int get failureCount => throw _privateConstructorUsedError;
  List<String> get failedIds => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this BatchOperationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BatchOperationResultCopyWith<BatchOperationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchOperationResultCopyWith<$Res> {
  factory $BatchOperationResultCopyWith(BatchOperationResult value,
          $Res Function(BatchOperationResult) then) =
      _$BatchOperationResultCopyWithImpl<$Res, BatchOperationResult>;
  @useResult
  $Res call(
      {int totalCount,
      int successCount,
      int failureCount,
      List<String> failedIds,
      String? message});
}

/// @nodoc
class _$BatchOperationResultCopyWithImpl<$Res,
        $Val extends BatchOperationResult>
    implements $BatchOperationResultCopyWith<$Res> {
  _$BatchOperationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? failedIds = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedIds: null == failedIds
          ? _value.failedIds
          : failedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchOperationResultImplCopyWith<$Res>
    implements $BatchOperationResultCopyWith<$Res> {
  factory _$$BatchOperationResultImplCopyWith(_$BatchOperationResultImpl value,
          $Res Function(_$BatchOperationResultImpl) then) =
      __$$BatchOperationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalCount,
      int successCount,
      int failureCount,
      List<String> failedIds,
      String? message});
}

/// @nodoc
class __$$BatchOperationResultImplCopyWithImpl<$Res>
    extends _$BatchOperationResultCopyWithImpl<$Res, _$BatchOperationResultImpl>
    implements _$$BatchOperationResultImplCopyWith<$Res> {
  __$$BatchOperationResultImplCopyWithImpl(_$BatchOperationResultImpl _value,
      $Res Function(_$BatchOperationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalCount = null,
    Object? successCount = null,
    Object? failureCount = null,
    Object? failedIds = null,
    Object? message = freezed,
  }) {
    return _then(_$BatchOperationResultImpl(
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      successCount: null == successCount
          ? _value.successCount
          : successCount // ignore: cast_nullable_to_non_nullable
              as int,
      failureCount: null == failureCount
          ? _value.failureCount
          : failureCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedIds: null == failedIds
          ? _value._failedIds
          : failedIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchOperationResultImpl implements _BatchOperationResult {
  const _$BatchOperationResultImpl(
      {required this.totalCount,
      required this.successCount,
      required this.failureCount,
      required final List<String> failedIds,
      this.message})
      : _failedIds = failedIds;

  factory _$BatchOperationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchOperationResultImplFromJson(json);

  @override
  final int totalCount;
  @override
  final int successCount;
  @override
  final int failureCount;
  final List<String> _failedIds;
  @override
  List<String> get failedIds {
    if (_failedIds is EqualUnmodifiableListView) return _failedIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedIds);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'BatchOperationResult(totalCount: $totalCount, successCount: $successCount, failureCount: $failureCount, failedIds: $failedIds, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchOperationResultImpl &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.successCount, successCount) ||
                other.successCount == successCount) &&
            (identical(other.failureCount, failureCount) ||
                other.failureCount == failureCount) &&
            const DeepCollectionEquality()
                .equals(other._failedIds, _failedIds) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalCount, successCount,
      failureCount, const DeepCollectionEquality().hash(_failedIds), message);

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchOperationResultImplCopyWith<_$BatchOperationResultImpl>
      get copyWith =>
          __$$BatchOperationResultImplCopyWithImpl<_$BatchOperationResultImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchOperationResultImplToJson(
      this,
    );
  }
}

abstract class _BatchOperationResult implements BatchOperationResult {
  const factory _BatchOperationResult(
      {required final int totalCount,
      required final int successCount,
      required final int failureCount,
      required final List<String> failedIds,
      final String? message}) = _$BatchOperationResultImpl;

  factory _BatchOperationResult.fromJson(Map<String, dynamic> json) =
      _$BatchOperationResultImpl.fromJson;

  @override
  int get totalCount;
  @override
  int get successCount;
  @override
  int get failureCount;
  @override
  List<String> get failedIds;
  @override
  String? get message;

  /// Create a copy of BatchOperationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BatchOperationResultImplCopyWith<_$BatchOperationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
