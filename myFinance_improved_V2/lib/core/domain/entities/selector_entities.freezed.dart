// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selector_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SelectorEntity _$SelectorEntityFromJson(Map<String, dynamic> json) {
  return _SelectorEntity.fromJson(json);
}

/// @nodoc
mixin _$SelectorEntity {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this SelectorEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectorEntityCopyWith<SelectorEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectorEntityCopyWith<$Res> {
  factory $SelectorEntityCopyWith(
          SelectorEntity value, $Res Function(SelectorEntity) then) =
      _$SelectorEntityCopyWithImpl<$Res, SelectorEntity>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? type,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$SelectorEntityCopyWithImpl<$Res, $Val extends SelectorEntity>
    implements $SelectorEntityCopyWith<$Res> {
  _$SelectorEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectorEntityImplCopyWith<$Res>
    implements $SelectorEntityCopyWith<$Res> {
  factory _$$SelectorEntityImplCopyWith(_$SelectorEntityImpl value,
          $Res Function(_$SelectorEntityImpl) then) =
      __$$SelectorEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? type,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$SelectorEntityImplCopyWithImpl<$Res>
    extends _$SelectorEntityCopyWithImpl<$Res, _$SelectorEntityImpl>
    implements _$$SelectorEntityImplCopyWith<$Res> {
  __$$SelectorEntityImplCopyWithImpl(
      _$SelectorEntityImpl _value, $Res Function(_$SelectorEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of SelectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$SelectorEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectorEntityImpl implements _SelectorEntity {
  const _$SelectorEntityImpl(
      {required this.id,
      required this.name,
      this.type,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData;

  factory _$SelectorEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectorEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? type;
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SelectorEntity(id: $id, name: $name, type: $type, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectorEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, transactionCount,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of SelectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectorEntityImplCopyWith<_$SelectorEntityImpl> get copyWith =>
      __$$SelectorEntityImplCopyWithImpl<_$SelectorEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectorEntityImplToJson(
      this,
    );
  }
}

abstract class _SelectorEntity implements SelectorEntity {
  const factory _SelectorEntity(
      {required final String id,
      required final String name,
      final String? type,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$SelectorEntityImpl;

  factory _SelectorEntity.fromJson(Map<String, dynamic> json) =
      _$SelectorEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get type;
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of SelectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectorEntityImplCopyWith<_$SelectorEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountData _$AccountDataFromJson(Map<String, dynamic> json) {
  return _AccountData.fromJson(json);
}

/// @nodoc
mixin _$AccountData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // asset, liability, equity, income, expense
  String? get categoryTag => throw _privateConstructorUsedError;
  String? get expenseNature =>
      throw _privateConstructorUsedError; // fixed, variable
  String? get accountCode =>
      throw _privateConstructorUsedError; // Account code (e.g., 5000-9999 for expense accounts)
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this AccountData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountDataCopyWith<AccountData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountDataCopyWith<$Res> {
  factory $AccountDataCopyWith(
          AccountData value, $Res Function(AccountData) then) =
      _$AccountDataCopyWithImpl<$Res, AccountData>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? categoryTag,
      String? expenseNature,
      String? accountCode,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$AccountDataCopyWithImpl<$Res, $Val extends AccountData>
    implements $AccountDataCopyWith<$Res> {
  _$AccountDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? categoryTag = freezed,
    Object? expenseNature = freezed,
    Object? accountCode = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      accountCode: freezed == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountDataImplCopyWith<$Res>
    implements $AccountDataCopyWith<$Res> {
  factory _$$AccountDataImplCopyWith(
          _$AccountDataImpl value, $Res Function(_$AccountDataImpl) then) =
      __$$AccountDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? categoryTag,
      String? expenseNature,
      String? accountCode,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$AccountDataImplCopyWithImpl<$Res>
    extends _$AccountDataCopyWithImpl<$Res, _$AccountDataImpl>
    implements _$$AccountDataImplCopyWith<$Res> {
  __$$AccountDataImplCopyWithImpl(
      _$AccountDataImpl _value, $Res Function(_$AccountDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? categoryTag = freezed,
    Object? expenseNature = freezed,
    Object? accountCode = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$AccountDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      accountCode: freezed == accountCode
          ? _value.accountCode
          : accountCode // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountDataImpl extends _AccountData {
  const _$AccountDataImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.categoryTag,
      this.expenseNature,
      this.accountCode,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData,
        super._();

  factory _$AccountDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
// asset, liability, equity, income, expense
  @override
  final String? categoryTag;
  @override
  final String? expenseNature;
// fixed, variable
  @override
  final String? accountCode;
// Account code (e.g., 5000-9999 for expense accounts)
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AccountData(id: $id, name: $name, type: $type, categoryTag: $categoryTag, expenseNature: $expenseNature, accountCode: $accountCode, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryTag, categoryTag) ||
                other.categoryTag == categoryTag) &&
            (identical(other.expenseNature, expenseNature) ||
                other.expenseNature == expenseNature) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      categoryTag,
      expenseNature,
      accountCode,
      transactionCount,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of AccountData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountDataImplCopyWith<_$AccountDataImpl> get copyWith =>
      __$$AccountDataImplCopyWithImpl<_$AccountDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountDataImplToJson(
      this,
    );
  }
}

abstract class _AccountData extends AccountData {
  const factory _AccountData(
      {required final String id,
      required final String name,
      required final String type,
      final String? categoryTag,
      final String? expenseNature,
      final String? accountCode,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$AccountDataImpl;
  const _AccountData._() : super._();

  factory _AccountData.fromJson(Map<String, dynamic> json) =
      _$AccountDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type; // asset, liability, equity, income, expense
  @override
  String? get categoryTag;
  @override
  String? get expenseNature; // fixed, variable
  @override
  String?
      get accountCode; // Account code (e.g., 5000-9999 for expense accounts)
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of AccountData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountDataImplCopyWith<_$AccountDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuickAccessAccount _$QuickAccessAccountFromJson(Map<String, dynamic> json) {
  return _QuickAccessAccount.fromJson(json);
}

/// @nodoc
mixin _$QuickAccessAccount {
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  String get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_count')
  int get usageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_used')
  DateTime get lastUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_score')
  double get usageScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'exists_in_system')
  bool get existsInSystem => throw _privateConstructorUsedError;

  /// Serializes this QuickAccessAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuickAccessAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickAccessAccountCopyWith<QuickAccessAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickAccessAccountCopyWith<$Res> {
  factory $QuickAccessAccountCopyWith(
          QuickAccessAccount value, $Res Function(QuickAccessAccount) then) =
      _$QuickAccessAccountCopyWithImpl<$Res, QuickAccessAccount>;
  @useResult
  $Res call(
      {@JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'usage_count') int usageCount,
      @JsonKey(name: 'last_used') DateTime lastUsed,
      @JsonKey(name: 'usage_score') double usageScore,
      @JsonKey(name: 'exists_in_system') bool existsInSystem});
}

/// @nodoc
class _$QuickAccessAccountCopyWithImpl<$Res, $Val extends QuickAccessAccount>
    implements $QuickAccessAccountCopyWith<$Res> {
  _$QuickAccessAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickAccessAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? usageCount = null,
    Object? lastUsed = null,
    Object? usageScore = null,
    Object? existsInSystem = null,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usageScore: null == usageScore
          ? _value.usageScore
          : usageScore // ignore: cast_nullable_to_non_nullable
              as double,
      existsInSystem: null == existsInSystem
          ? _value.existsInSystem
          : existsInSystem // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuickAccessAccountImplCopyWith<$Res>
    implements $QuickAccessAccountCopyWith<$Res> {
  factory _$$QuickAccessAccountImplCopyWith(_$QuickAccessAccountImpl value,
          $Res Function(_$QuickAccessAccountImpl) then) =
      __$$QuickAccessAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String accountType,
      @JsonKey(name: 'usage_count') int usageCount,
      @JsonKey(name: 'last_used') DateTime lastUsed,
      @JsonKey(name: 'usage_score') double usageScore,
      @JsonKey(name: 'exists_in_system') bool existsInSystem});
}

/// @nodoc
class __$$QuickAccessAccountImplCopyWithImpl<$Res>
    extends _$QuickAccessAccountCopyWithImpl<$Res, _$QuickAccessAccountImpl>
    implements _$$QuickAccessAccountImplCopyWith<$Res> {
  __$$QuickAccessAccountImplCopyWithImpl(_$QuickAccessAccountImpl _value,
      $Res Function(_$QuickAccessAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuickAccessAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? usageCount = null,
    Object? lastUsed = null,
    Object? usageScore = null,
    Object? existsInSystem = null,
  }) {
    return _then(_$QuickAccessAccountImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String,
      usageCount: null == usageCount
          ? _value.usageCount
          : usageCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usageScore: null == usageScore
          ? _value.usageScore
          : usageScore // ignore: cast_nullable_to_non_nullable
              as double,
      existsInSystem: null == existsInSystem
          ? _value.existsInSystem
          : existsInSystem // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuickAccessAccountImpl extends _QuickAccessAccount {
  const _$QuickAccessAccountImpl(
      {@JsonKey(name: 'account_id') required this.accountId,
      @JsonKey(name: 'account_name') required this.accountName,
      @JsonKey(name: 'account_type') required this.accountType,
      @JsonKey(name: 'usage_count') required this.usageCount,
      @JsonKey(name: 'last_used') required this.lastUsed,
      @JsonKey(name: 'usage_score') required this.usageScore,
      @JsonKey(name: 'exists_in_system') this.existsInSystem = true})
      : super._();

  factory _$QuickAccessAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuickAccessAccountImplFromJson(json);

  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey(name: 'account_type')
  final String accountType;
  @override
  @JsonKey(name: 'usage_count')
  final int usageCount;
  @override
  @JsonKey(name: 'last_used')
  final DateTime lastUsed;
  @override
  @JsonKey(name: 'usage_score')
  final double usageScore;
  @override
  @JsonKey(name: 'exists_in_system')
  final bool existsInSystem;

  @override
  String toString() {
    return 'QuickAccessAccount(accountId: $accountId, accountName: $accountName, accountType: $accountType, usageCount: $usageCount, lastUsed: $lastUsed, usageScore: $usageScore, existsInSystem: $existsInSystem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickAccessAccountImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed) &&
            (identical(other.usageScore, usageScore) ||
                other.usageScore == usageScore) &&
            (identical(other.existsInSystem, existsInSystem) ||
                other.existsInSystem == existsInSystem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountType, usageCount, lastUsed, usageScore, existsInSystem);

  /// Create a copy of QuickAccessAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickAccessAccountImplCopyWith<_$QuickAccessAccountImpl> get copyWith =>
      __$$QuickAccessAccountImplCopyWithImpl<_$QuickAccessAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuickAccessAccountImplToJson(
      this,
    );
  }
}

abstract class _QuickAccessAccount extends QuickAccessAccount {
  const factory _QuickAccessAccount(
          {@JsonKey(name: 'account_id') required final String accountId,
          @JsonKey(name: 'account_name') required final String accountName,
          @JsonKey(name: 'account_type') required final String accountType,
          @JsonKey(name: 'usage_count') required final int usageCount,
          @JsonKey(name: 'last_used') required final DateTime lastUsed,
          @JsonKey(name: 'usage_score') required final double usageScore,
          @JsonKey(name: 'exists_in_system') final bool existsInSystem}) =
      _$QuickAccessAccountImpl;
  const _QuickAccessAccount._() : super._();

  factory _QuickAccessAccount.fromJson(Map<String, dynamic> json) =
      _$QuickAccessAccountImpl.fromJson;

  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  @JsonKey(name: 'account_type')
  String get accountType;
  @override
  @JsonKey(name: 'usage_count')
  int get usageCount;
  @override
  @JsonKey(name: 'last_used')
  DateTime get lastUsed;
  @override
  @JsonKey(name: 'usage_score')
  double get usageScore;
  @override
  @JsonKey(name: 'exists_in_system')
  bool get existsInSystem;

  /// Create a copy of QuickAccessAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickAccessAccountImplCopyWith<_$QuickAccessAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CashLocationData _$CashLocationDataFromJson(Map<String, dynamic> json) {
  return _CashLocationData.fromJson(json);
}

/// @nodoc
mixin _$CashLocationData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get storeId =>
      throw _privateConstructorUsedError; // RPC returns camelCase
  String? get companyId =>
      throw _privateConstructorUsedError; // For explicit company ID from RPC
  bool get isCompanyWide => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  String? get currencyCode => throw _privateConstructorUsedError;
  String? get bankAccount => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get locationInfo => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this CashLocationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CashLocationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CashLocationDataCopyWith<CashLocationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CashLocationDataCopyWith<$Res> {
  factory $CashLocationDataCopyWith(
          CashLocationData value, $Res Function(CashLocationData) then) =
      _$CashLocationDataCopyWithImpl<$Res, CashLocationData>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? storeId,
      String? companyId,
      bool isCompanyWide,
      bool isDeleted,
      String? currencyCode,
      String? bankAccount,
      String? bankName,
      String? locationInfo,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$CashLocationDataCopyWithImpl<$Res, $Val extends CashLocationData>
    implements $CashLocationDataCopyWith<$Res> {
  _$CashLocationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CashLocationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
    Object? isCompanyWide = null,
    Object? isDeleted = null,
    Object? currencyCode = freezed,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? locationInfo = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompanyWide: null == isCompanyWide
          ? _value.isCompanyWide
          : isCompanyWide // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CashLocationDataImplCopyWith<$Res>
    implements $CashLocationDataCopyWith<$Res> {
  factory _$$CashLocationDataImplCopyWith(_$CashLocationDataImpl value,
          $Res Function(_$CashLocationDataImpl) then) =
      __$$CashLocationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? storeId,
      String? companyId,
      bool isCompanyWide,
      bool isDeleted,
      String? currencyCode,
      String? bankAccount,
      String? bankName,
      String? locationInfo,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$CashLocationDataImplCopyWithImpl<$Res>
    extends _$CashLocationDataCopyWithImpl<$Res, _$CashLocationDataImpl>
    implements _$$CashLocationDataImplCopyWith<$Res> {
  __$$CashLocationDataImplCopyWithImpl(_$CashLocationDataImpl _value,
      $Res Function(_$CashLocationDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CashLocationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? storeId = freezed,
    Object? companyId = freezed,
    Object? isCompanyWide = null,
    Object? isDeleted = null,
    Object? currencyCode = freezed,
    Object? bankAccount = freezed,
    Object? bankName = freezed,
    Object? locationInfo = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$CashLocationDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      storeId: freezed == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String?,
      companyId: freezed == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompanyWide: null == isCompanyWide
          ? _value.isCompanyWide
          : isCompanyWide // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccount: freezed == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CashLocationDataImpl extends _CashLocationData {
  const _$CashLocationDataImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.storeId,
      this.companyId,
      this.isCompanyWide = false,
      this.isDeleted = false,
      this.currencyCode,
      this.bankAccount,
      this.bankName,
      this.locationInfo,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData,
        super._();

  factory _$CashLocationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CashLocationDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String? storeId;
// RPC returns camelCase
  @override
  final String? companyId;
// For explicit company ID from RPC
  @override
  @JsonKey()
  final bool isCompanyWide;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final String? currencyCode;
  @override
  final String? bankAccount;
  @override
  final String? bankName;
  @override
  final String? locationInfo;
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CashLocationData(id: $id, name: $name, type: $type, storeId: $storeId, companyId: $companyId, isCompanyWide: $isCompanyWide, isDeleted: $isDeleted, currencyCode: $currencyCode, bankAccount: $bankAccount, bankName: $bankName, locationInfo: $locationInfo, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CashLocationDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.isCompanyWide, isCompanyWide) ||
                other.isCompanyWide == isCompanyWide) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.locationInfo, locationInfo) ||
                other.locationInfo == locationInfo) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      storeId,
      companyId,
      isCompanyWide,
      isDeleted,
      currencyCode,
      bankAccount,
      bankName,
      locationInfo,
      transactionCount,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of CashLocationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CashLocationDataImplCopyWith<_$CashLocationDataImpl> get copyWith =>
      __$$CashLocationDataImplCopyWithImpl<_$CashLocationDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CashLocationDataImplToJson(
      this,
    );
  }
}

abstract class _CashLocationData extends CashLocationData {
  const factory _CashLocationData(
      {required final String id,
      required final String name,
      required final String type,
      final String? storeId,
      final String? companyId,
      final bool isCompanyWide,
      final bool isDeleted,
      final String? currencyCode,
      final String? bankAccount,
      final String? bankName,
      final String? locationInfo,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$CashLocationDataImpl;
  const _CashLocationData._() : super._();

  factory _CashLocationData.fromJson(Map<String, dynamic> json) =
      _$CashLocationDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String? get storeId; // RPC returns camelCase
  @override
  String? get companyId; // For explicit company ID from RPC
  @override
  bool get isCompanyWide;
  @override
  bool get isDeleted;
  @override
  String? get currencyCode;
  @override
  String? get bankAccount;
  @override
  String? get bankName;
  @override
  String? get locationInfo;
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of CashLocationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CashLocationDataImplCopyWith<_$CashLocationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CounterpartyData _$CounterpartyDataFromJson(Map<String, dynamic> json) {
  return _CounterpartyData.fromJson(json);
}

/// @nodoc
mixin _$CounterpartyData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool get isInternal => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this CounterpartyData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterpartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterpartyDataCopyWith<CounterpartyData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterpartyDataCopyWith<$Res> {
  factory $CounterpartyDataCopyWith(
          CounterpartyData value, $Res Function(CounterpartyData) then) =
      _$CounterpartyDataCopyWithImpl<$Res, CounterpartyData>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? email,
      String? phone,
      bool isInternal,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$CounterpartyDataCopyWithImpl<$Res, $Val extends CounterpartyData>
    implements $CounterpartyDataCopyWith<$Res> {
  _$CounterpartyDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterpartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? isInternal = null,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterpartyDataImplCopyWith<$Res>
    implements $CounterpartyDataCopyWith<$Res> {
  factory _$$CounterpartyDataImplCopyWith(_$CounterpartyDataImpl value,
          $Res Function(_$CounterpartyDataImpl) then) =
      __$$CounterpartyDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? email,
      String? phone,
      bool isInternal,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$CounterpartyDataImplCopyWithImpl<$Res>
    extends _$CounterpartyDataCopyWithImpl<$Res, _$CounterpartyDataImpl>
    implements _$$CounterpartyDataImplCopyWith<$Res> {
  __$$CounterpartyDataImplCopyWithImpl(_$CounterpartyDataImpl _value,
      $Res Function(_$CounterpartyDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterpartyData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? email = freezed,
    Object? phone = freezed,
    Object? isInternal = null,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$CounterpartyDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isInternal: null == isInternal
          ? _value.isInternal
          : isInternal // ignore: cast_nullable_to_non_nullable
              as bool,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterpartyDataImpl extends _CounterpartyData {
  const _$CounterpartyDataImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.email,
      this.phone,
      this.isInternal = false,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData,
        super._();

  factory _$CounterpartyDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterpartyDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey()
  final bool isInternal;
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CounterpartyData(id: $id, name: $name, type: $type, email: $email, phone: $phone, isInternal: $isInternal, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterpartyDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isInternal, isInternal) ||
                other.isInternal == isInternal) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      email,
      phone,
      isInternal,
      transactionCount,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of CounterpartyData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterpartyDataImplCopyWith<_$CounterpartyDataImpl> get copyWith =>
      __$$CounterpartyDataImplCopyWithImpl<_$CounterpartyDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterpartyDataImplToJson(
      this,
    );
  }
}

abstract class _CounterpartyData extends CounterpartyData {
  const factory _CounterpartyData(
      {required final String id,
      required final String name,
      required final String type,
      final String? email,
      final String? phone,
      final bool isInternal,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$CounterpartyDataImpl;
  const _CounterpartyData._() : super._();

  factory _CounterpartyData.fromJson(Map<String, dynamic> json) =
      _$CounterpartyDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  bool get isInternal;
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of CounterpartyData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterpartyDataImplCopyWith<_$CounterpartyDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreData _$StoreDataFromJson(Map<String, dynamic> json) {
  return _StoreData.fromJson(json);
}

/// @nodoc
mixin _$StoreData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this StoreData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreDataCopyWith<StoreData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreDataCopyWith<$Res> {
  factory $StoreDataCopyWith(StoreData value, $Res Function(StoreData) then) =
      _$StoreDataCopyWithImpl<$Res, StoreData>;
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String? address,
      String? phone,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$StoreDataCopyWithImpl<$Res, $Val extends StoreData>
    implements $StoreDataCopyWith<$Res> {
  _$StoreDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreDataImplCopyWith<$Res>
    implements $StoreDataCopyWith<$Res> {
  factory _$$StoreDataImplCopyWith(
          _$StoreDataImpl value, $Res Function(_$StoreDataImpl) then) =
      __$$StoreDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String? address,
      String? phone,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$StoreDataImplCopyWithImpl<$Res>
    extends _$StoreDataCopyWithImpl<$Res, _$StoreDataImpl>
    implements _$$StoreDataImplCopyWith<$Res> {
  __$$StoreDataImplCopyWithImpl(
      _$StoreDataImpl _value, $Res Function(_$StoreDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? address = freezed,
    Object? phone = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$StoreDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StoreDataImpl extends _StoreData {
  const _$StoreDataImpl(
      {required this.id,
      required this.name,
      required this.code,
      this.address,
      this.phone,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData,
        super._();

  factory _$StoreDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'StoreData(id: $id, name: $name, code: $code, address: $address, phone: $phone, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, code, address, phone,
      transactionCount, const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of StoreData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreDataImplCopyWith<_$StoreDataImpl> get copyWith =>
      __$$StoreDataImplCopyWithImpl<_$StoreDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreDataImplToJson(
      this,
    );
  }
}

abstract class _StoreData extends StoreData {
  const factory _StoreData(
      {required final String id,
      required final String name,
      required final String code,
      final String? address,
      final String? phone,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$StoreDataImpl;
  const _StoreData._() : super._();

  factory _StoreData.fromJson(Map<String, dynamic> json) =
      _$StoreDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get code;
  @override
  String? get address;
  @override
  String? get phone;
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of StoreData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreDataImplCopyWith<_$StoreDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get additionalData =>
      throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? firstName,
      String? lastName,
      String? email,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value.additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? firstName,
      String? lastName,
      String? email,
      int transactionCount,
      Map<String, dynamic>? additionalData});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? transactionCount = null,
    Object? additionalData = freezed,
  }) {
    return _then(_$UserDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      additionalData: freezed == additionalData
          ? _value._additionalData
          : additionalData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl extends _UserData {
  const _$UserDataImpl(
      {required this.id,
      required this.name,
      this.firstName,
      this.lastName,
      this.email,
      this.transactionCount = 0,
      final Map<String, dynamic>? additionalData})
      : _additionalData = additionalData,
        super._();

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? email;
  @override
  @JsonKey()
  final int transactionCount;
  final Map<String, dynamic>? _additionalData;
  @override
  Map<String, dynamic>? get additionalData {
    final value = _additionalData;
    if (value == null) return null;
    if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, firstName: $firstName, lastName: $lastName, email: $email, transactionCount: $transactionCount, additionalData: $additionalData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._additionalData, _additionalData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      firstName,
      lastName,
      email,
      transactionCount,
      const DeepCollectionEquality().hash(_additionalData));

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  const factory _UserData(
      {required final String id,
      required final String name,
      final String? firstName,
      final String? lastName,
      final String? email,
      final int transactionCount,
      final Map<String, dynamic>? additionalData}) = _$UserDataImpl;
  const _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get email;
  @override
  int get transactionCount;
  @override
  Map<String, dynamic>? get additionalData;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelectorItem _$SelectorItemFromJson(Map<String, dynamic> json) {
  return _SelectorItem.fromJson(json);
}

/// @nodoc
mixin _$SelectorItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get iconPath => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  bool? get isSelected => throw _privateConstructorUsedError;
  Object? get data => throw _privateConstructorUsedError;

  /// Serializes this SelectorItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectorItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectorItemCopyWith<SelectorItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectorItemCopyWith<$Res> {
  factory $SelectorItemCopyWith(
          SelectorItem value, $Res Function(SelectorItem) then) =
      _$SelectorItemCopyWithImpl<$Res, SelectorItem>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? subtitle,
      String? iconPath,
      String? avatarUrl,
      bool? isSelected,
      Object? data});
}

/// @nodoc
class _$SelectorItemCopyWithImpl<$Res, $Val extends SelectorItem>
    implements $SelectorItemCopyWith<$Res> {
  _$SelectorItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectorItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? iconPath = freezed,
    Object? avatarUrl = freezed,
    Object? isSelected = freezed,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isSelected: freezed == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      data: freezed == data ? _value.data : data,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectorItemImplCopyWith<$Res>
    implements $SelectorItemCopyWith<$Res> {
  factory _$$SelectorItemImplCopyWith(
          _$SelectorItemImpl value, $Res Function(_$SelectorItemImpl) then) =
      __$$SelectorItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? subtitle,
      String? iconPath,
      String? avatarUrl,
      bool? isSelected,
      Object? data});
}

/// @nodoc
class __$$SelectorItemImplCopyWithImpl<$Res>
    extends _$SelectorItemCopyWithImpl<$Res, _$SelectorItemImpl>
    implements _$$SelectorItemImplCopyWith<$Res> {
  __$$SelectorItemImplCopyWithImpl(
      _$SelectorItemImpl _value, $Res Function(_$SelectorItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of SelectorItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? subtitle = freezed,
    Object? iconPath = freezed,
    Object? avatarUrl = freezed,
    Object? isSelected = freezed,
    Object? data = freezed,
  }) {
    return _then(_$SelectorItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      subtitle: freezed == subtitle
          ? _value.subtitle
          : subtitle // ignore: cast_nullable_to_non_nullable
              as String?,
      iconPath: freezed == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isSelected: freezed == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool?,
      data: freezed == data ? _value.data : data,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectorItemImpl implements _SelectorItem {
  const _$SelectorItemImpl(
      {required this.id,
      required this.title,
      this.subtitle,
      this.iconPath,
      this.avatarUrl,
      this.isSelected,
      this.data});

  factory _$SelectorItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectorItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? subtitle;
  @override
  final String? iconPath;
  @override
  final String? avatarUrl;
  @override
  final bool? isSelected;
  @override
  final Object? data;

  @override
  String toString() {
    return 'SelectorItem(id: $id, title: $title, subtitle: $subtitle, iconPath: $iconPath, avatarUrl: $avatarUrl, isSelected: $isSelected, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectorItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, subtitle, iconPath,
      avatarUrl, isSelected, const DeepCollectionEquality().hash(data));

  /// Create a copy of SelectorItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectorItemImplCopyWith<_$SelectorItemImpl> get copyWith =>
      __$$SelectorItemImplCopyWithImpl<_$SelectorItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectorItemImplToJson(
      this,
    );
  }
}

abstract class _SelectorItem implements SelectorItem {
  const factory _SelectorItem(
      {required final String id,
      required final String title,
      final String? subtitle,
      final String? iconPath,
      final String? avatarUrl,
      final bool? isSelected,
      final Object? data}) = _$SelectorItemImpl;

  factory _SelectorItem.fromJson(Map<String, dynamic> json) =
      _$SelectorItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get subtitle;
  @override
  String? get iconPath;
  @override
  String? get avatarUrl;
  @override
  bool? get isSelected;
  @override
  Object? get data;

  /// Create a copy of SelectorItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectorItemImplCopyWith<_$SelectorItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
