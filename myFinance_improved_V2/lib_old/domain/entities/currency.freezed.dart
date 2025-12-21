// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'currency.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return _Currency.fromJson(json);
}

/// @nodoc
mixin _$Currency {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get flagEmoji => throw _privateConstructorUsedError;
  String? get companyCurrencyId =>
      throw _privateConstructorUsedError; // Added for tracking company_currency relationship
  List<Denomination> get denominations => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Currency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyCopyWith<Currency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyCopyWith<$Res> {
  factory $CurrencyCopyWith(Currency value, $Res Function(Currency) then) =
      _$CurrencyCopyWithImpl<$Res, Currency>;
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String fullName,
      String symbol,
      String flagEmoji,
      String? companyCurrencyId,
      List<Denomination> denominations,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$CurrencyCopyWithImpl<$Res, $Val extends Currency>
    implements $CurrencyCopyWith<$Res> {
  _$CurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? fullName = null,
    Object? symbol = null,
    Object? flagEmoji = null,
    Object? companyCurrencyId = freezed,
    Object? denominations = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      companyCurrencyId: freezed == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyImplCopyWith<$Res>
    implements $CurrencyCopyWith<$Res> {
  factory _$$CurrencyImplCopyWith(
          _$CurrencyImpl value, $Res Function(_$CurrencyImpl) then) =
      __$$CurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String name,
      String fullName,
      String symbol,
      String flagEmoji,
      String? companyCurrencyId,
      List<Denomination> denominations,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$CurrencyImplCopyWithImpl<$Res>
    extends _$CurrencyCopyWithImpl<$Res, _$CurrencyImpl>
    implements _$$CurrencyImplCopyWith<$Res> {
  __$$CurrencyImplCopyWithImpl(
      _$CurrencyImpl _value, $Res Function(_$CurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? fullName = null,
    Object? symbol = null,
    Object? flagEmoji = null,
    Object? companyCurrencyId = freezed,
    Object? denominations = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CurrencyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      companyCurrencyId: freezed == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String?,
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<Denomination>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyImpl implements _Currency {
  const _$CurrencyImpl(
      {required this.id,
      required this.code,
      required this.name,
      required this.fullName,
      required this.symbol,
      required this.flagEmoji,
      this.companyCurrencyId,
      final List<Denomination> denominations = const [],
      this.createdAt,
      this.updatedAt})
      : _denominations = denominations;

  factory _$CurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String fullName;
  @override
  final String symbol;
  @override
  final String flagEmoji;
  @override
  final String? companyCurrencyId;
// Added for tracking company_currency relationship
  final List<Denomination> _denominations;
// Added for tracking company_currency relationship
  @override
  @JsonKey()
  List<Denomination> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Currency(id: $id, code: $code, name: $name, fullName: $fullName, symbol: $symbol, flagEmoji: $flagEmoji, companyCurrencyId: $companyCurrencyId, denominations: $denominations, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.companyCurrencyId, companyCurrencyId) ||
                other.companyCurrencyId == companyCurrencyId) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      code,
      name,
      fullName,
      symbol,
      flagEmoji,
      companyCurrencyId,
      const DeepCollectionEquality().hash(_denominations),
      createdAt,
      updatedAt);

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      __$$CurrencyImplCopyWithImpl<_$CurrencyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyImplToJson(
      this,
    );
  }
}

abstract class _Currency implements Currency {
  const factory _Currency(
      {required final String id,
      required final String code,
      required final String name,
      required final String fullName,
      required final String symbol,
      required final String flagEmoji,
      final String? companyCurrencyId,
      final List<Denomination> denominations,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$CurrencyImpl;

  factory _Currency.fromJson(Map<String, dynamic> json) =
      _$CurrencyImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String get fullName;
  @override
  String get symbol;
  @override
  String get flagEmoji;
  @override
  String?
      get companyCurrencyId; // Added for tracking company_currency relationship
  @override
  List<Denomination> get denominations;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of Currency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyImplCopyWith<_$CurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CurrencyType _$CurrencyTypeFromJson(Map<String, dynamic> json) {
  return _CurrencyType.fromJson(json);
}

/// @nodoc
mixin _$CurrencyType {
  String get currencyId => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  String get currencyName => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  String get flagEmoji => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CurrencyType to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CurrencyTypeCopyWith<CurrencyType> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CurrencyTypeCopyWith<$Res> {
  factory $CurrencyTypeCopyWith(
          CurrencyType value, $Res Function(CurrencyType) then) =
      _$CurrencyTypeCopyWithImpl<$Res, CurrencyType>;
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      String flagEmoji,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class _$CurrencyTypeCopyWithImpl<$Res, $Val extends CurrencyType>
    implements $CurrencyTypeCopyWith<$Res> {
  _$CurrencyTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CurrencyTypeImplCopyWith<$Res>
    implements $CurrencyTypeCopyWith<$Res> {
  factory _$$CurrencyTypeImplCopyWith(
          _$CurrencyTypeImpl value, $Res Function(_$CurrencyTypeImpl) then) =
      __$$CurrencyTypeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currencyId,
      String currencyCode,
      String currencyName,
      String symbol,
      String flagEmoji,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class __$$CurrencyTypeImplCopyWithImpl<$Res>
    extends _$CurrencyTypeCopyWithImpl<$Res, _$CurrencyTypeImpl>
    implements _$$CurrencyTypeImplCopyWith<$Res> {
  __$$CurrencyTypeImplCopyWithImpl(
      _$CurrencyTypeImpl _value, $Res Function(_$CurrencyTypeImpl) _then)
      : super(_value, _then);

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currencyId = null,
    Object? currencyCode = null,
    Object? currencyName = null,
    Object? symbol = null,
    Object? flagEmoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$CurrencyTypeImpl(
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyName: null == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      flagEmoji: null == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CurrencyTypeImpl implements _CurrencyType {
  const _$CurrencyTypeImpl(
      {required this.currencyId,
      required this.currencyCode,
      required this.currencyName,
      required this.symbol,
      required this.flagEmoji,
      this.isActive = true,
      this.createdAt});

  factory _$CurrencyTypeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CurrencyTypeImplFromJson(json);

  @override
  final String currencyId;
  @override
  final String currencyCode;
  @override
  final String currencyName;
  @override
  final String symbol;
  @override
  final String flagEmoji;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CurrencyType(currencyId: $currencyId, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, flagEmoji: $flagEmoji, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CurrencyTypeImpl &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, currencyId, currencyCode,
      currencyName, symbol, flagEmoji, isActive, createdAt);

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CurrencyTypeImplCopyWith<_$CurrencyTypeImpl> get copyWith =>
      __$$CurrencyTypeImplCopyWithImpl<_$CurrencyTypeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CurrencyTypeImplToJson(
      this,
    );
  }
}

abstract class _CurrencyType implements CurrencyType {
  const factory _CurrencyType(
      {required final String currencyId,
      required final String currencyCode,
      required final String currencyName,
      required final String symbol,
      required final String flagEmoji,
      final bool isActive,
      final DateTime? createdAt}) = _$CurrencyTypeImpl;

  factory _CurrencyType.fromJson(Map<String, dynamic> json) =
      _$CurrencyTypeImpl.fromJson;

  @override
  String get currencyId;
  @override
  String get currencyCode;
  @override
  String get currencyName;
  @override
  String get symbol;
  @override
  String get flagEmoji;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;

  /// Create a copy of CurrencyType
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CurrencyTypeImplCopyWith<_$CurrencyTypeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyCurrency _$CompanyCurrencyFromJson(Map<String, dynamic> json) {
  return _CompanyCurrency.fromJson(json);
}

/// @nodoc
mixin _$CompanyCurrency {
  String get companyCurrencyId =>
      throw _privateConstructorUsedError; // Primary key from company_currency table
  String get companyId => throw _privateConstructorUsedError;
  String get currencyId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Denormalized currency info for easier querying
  String? get currencyCode => throw _privateConstructorUsedError;
  String? get currencyName => throw _privateConstructorUsedError;
  String? get symbol => throw _privateConstructorUsedError;
  String? get flagEmoji => throw _privateConstructorUsedError;

  /// Serializes this CompanyCurrency to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyCurrency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyCurrencyCopyWith<CompanyCurrency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyCurrencyCopyWith<$Res> {
  factory $CompanyCurrencyCopyWith(
          CompanyCurrency value, $Res Function(CompanyCurrency) then) =
      _$CompanyCurrencyCopyWithImpl<$Res, CompanyCurrency>;
  @useResult
  $Res call(
      {String companyCurrencyId,
      String companyId,
      String currencyId,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? currencyCode,
      String? currencyName,
      String? symbol,
      String? flagEmoji});
}

/// @nodoc
class _$CompanyCurrencyCopyWithImpl<$Res, $Val extends CompanyCurrency>
    implements $CompanyCurrencyCopyWith<$Res> {
  _$CompanyCurrencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyCurrency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyCurrencyId = null,
    Object? companyId = null,
    Object? currencyId = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? symbol = freezed,
    Object? flagEmoji = freezed,
  }) {
    return _then(_value.copyWith(
      companyCurrencyId: null == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyCurrencyImplCopyWith<$Res>
    implements $CompanyCurrencyCopyWith<$Res> {
  factory _$$CompanyCurrencyImplCopyWith(_$CompanyCurrencyImpl value,
          $Res Function(_$CompanyCurrencyImpl) then) =
      __$$CompanyCurrencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyCurrencyId,
      String companyId,
      String currencyId,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? currencyCode,
      String? currencyName,
      String? symbol,
      String? flagEmoji});
}

/// @nodoc
class __$$CompanyCurrencyImplCopyWithImpl<$Res>
    extends _$CompanyCurrencyCopyWithImpl<$Res, _$CompanyCurrencyImpl>
    implements _$$CompanyCurrencyImplCopyWith<$Res> {
  __$$CompanyCurrencyImplCopyWithImpl(
      _$CompanyCurrencyImpl _value, $Res Function(_$CompanyCurrencyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyCurrency
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyCurrencyId = null,
    Object? companyId = null,
    Object? currencyId = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? currencyCode = freezed,
    Object? currencyName = freezed,
    Object? symbol = freezed,
    Object? flagEmoji = freezed,
  }) {
    return _then(_$CompanyCurrencyImpl(
      companyCurrencyId: null == companyCurrencyId
          ? _value.companyCurrencyId
          : companyCurrencyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currencyCode: freezed == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyName: freezed == currencyName
          ? _value.currencyName
          : currencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      symbol: freezed == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyCurrencyImpl implements _CompanyCurrency {
  const _$CompanyCurrencyImpl(
      {required this.companyCurrencyId,
      required this.companyId,
      required this.currencyId,
      this.isActive = true,
      this.createdAt,
      this.updatedAt,
      this.currencyCode,
      this.currencyName,
      this.symbol,
      this.flagEmoji});

  factory _$CompanyCurrencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyCurrencyImplFromJson(json);

  @override
  final String companyCurrencyId;
// Primary key from company_currency table
  @override
  final String companyId;
  @override
  final String currencyId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Denormalized currency info for easier querying
  @override
  final String? currencyCode;
  @override
  final String? currencyName;
  @override
  final String? symbol;
  @override
  final String? flagEmoji;

  @override
  String toString() {
    return 'CompanyCurrency(companyCurrencyId: $companyCurrencyId, companyId: $companyId, currencyId: $currencyId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, currencyCode: $currencyCode, currencyName: $currencyName, symbol: $symbol, flagEmoji: $flagEmoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyCurrencyImpl &&
            (identical(other.companyCurrencyId, companyCurrencyId) ||
                other.companyCurrencyId == companyCurrencyId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.currencyName, currencyName) ||
                other.currencyName == currencyName) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyCurrencyId,
      companyId,
      currencyId,
      isActive,
      createdAt,
      updatedAt,
      currencyCode,
      currencyName,
      symbol,
      flagEmoji);

  /// Create a copy of CompanyCurrency
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyCurrencyImplCopyWith<_$CompanyCurrencyImpl> get copyWith =>
      __$$CompanyCurrencyImplCopyWithImpl<_$CompanyCurrencyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyCurrencyImplToJson(
      this,
    );
  }
}

abstract class _CompanyCurrency implements CompanyCurrency {
  const factory _CompanyCurrency(
      {required final String companyCurrencyId,
      required final String companyId,
      required final String currencyId,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? currencyCode,
      final String? currencyName,
      final String? symbol,
      final String? flagEmoji}) = _$CompanyCurrencyImpl;

  factory _CompanyCurrency.fromJson(Map<String, dynamic> json) =
      _$CompanyCurrencyImpl.fromJson;

  @override
  String get companyCurrencyId; // Primary key from company_currency table
  @override
  String get companyId;
  @override
  String get currencyId;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Denormalized currency info for easier querying
  @override
  String? get currencyCode;
  @override
  String? get currencyName;
  @override
  String? get symbol;
  @override
  String? get flagEmoji;

  /// Create a copy of CompanyCurrency
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyCurrencyImplCopyWith<_$CompanyCurrencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
