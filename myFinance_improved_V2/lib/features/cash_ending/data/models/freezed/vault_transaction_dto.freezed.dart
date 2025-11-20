// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vault_transaction_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VaultTransactionDto _$VaultTransactionDtoFromJson(Map<String, dynamic> json) {
  return _VaultTransactionDto.fromJson(json);
}

/// @nodoc
mixin _$VaultTransactionDto {
  @JsonKey(name: 'transaction_id')
  String? get transactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_id')
  String? get storeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_id')
  String get locationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_id')
  String get currencyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'record_date')
  DateTime get recordDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'credit')
  bool get isCredit => throw _privateConstructorUsedError;
  List<DenominationDto> get denominations => throw _privateConstructorUsedError;

  /// Serializes this VaultTransactionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VaultTransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VaultTransactionDtoCopyWith<VaultTransactionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VaultTransactionDtoCopyWith<$Res> {
  factory $VaultTransactionDtoCopyWith(
          VaultTransactionDto value, $Res Function(VaultTransactionDto) then) =
      _$VaultTransactionDtoCopyWithImpl<$Res, VaultTransactionDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'credit') bool isCredit,
      List<DenominationDto> denominations});
}

/// @nodoc
class _$VaultTransactionDtoCopyWithImpl<$Res, $Val extends VaultTransactionDto>
    implements $VaultTransactionDtoCopyWith<$Res> {
  _$VaultTransactionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VaultTransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? isCredit = null,
    Object? denominations = null,
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
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
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
      denominations: null == denominations
          ? _value.denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VaultTransactionDtoImplCopyWith<$Res>
    implements $VaultTransactionDtoCopyWith<$Res> {
  factory _$$VaultTransactionDtoImplCopyWith(_$VaultTransactionDtoImpl value,
          $Res Function(_$VaultTransactionDtoImpl) then) =
      __$$VaultTransactionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'transaction_id') String? transactionId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'store_id') String? storeId,
      @JsonKey(name: 'location_id') String locationId,
      @JsonKey(name: 'currency_id') String currencyId,
      @JsonKey(name: 'created_by') String userId,
      @JsonKey(name: 'record_date') DateTime recordDate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'credit') bool isCredit,
      List<DenominationDto> denominations});
}

/// @nodoc
class __$$VaultTransactionDtoImplCopyWithImpl<$Res>
    extends _$VaultTransactionDtoCopyWithImpl<$Res, _$VaultTransactionDtoImpl>
    implements _$$VaultTransactionDtoImplCopyWith<$Res> {
  __$$VaultTransactionDtoImplCopyWithImpl(_$VaultTransactionDtoImpl _value,
      $Res Function(_$VaultTransactionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of VaultTransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionId = freezed,
    Object? companyId = null,
    Object? storeId = freezed,
    Object? locationId = null,
    Object? currencyId = null,
    Object? userId = null,
    Object? recordDate = null,
    Object? createdAt = null,
    Object? isCredit = null,
    Object? denominations = null,
  }) {
    return _then(_$VaultTransactionDtoImpl(
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
      currencyId: null == currencyId
          ? _value.currencyId
          : currencyId // ignore: cast_nullable_to_non_nullable
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
      denominations: null == denominations
          ? _value._denominations
          : denominations // ignore: cast_nullable_to_non_nullable
              as List<DenominationDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VaultTransactionDtoImpl extends _VaultTransactionDto {
  const _$VaultTransactionDtoImpl(
      {@JsonKey(name: 'transaction_id') this.transactionId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'store_id') this.storeId,
      @JsonKey(name: 'location_id') required this.locationId,
      @JsonKey(name: 'currency_id') required this.currencyId,
      @JsonKey(name: 'created_by') required this.userId,
      @JsonKey(name: 'record_date') required this.recordDate,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'credit') required this.isCredit,
      final List<DenominationDto> denominations = const []})
      : _denominations = denominations,
        super._();

  factory _$VaultTransactionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VaultTransactionDtoImplFromJson(json);

  @override
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'store_id')
  final String? storeId;
  @override
  @JsonKey(name: 'location_id')
  final String locationId;
  @override
  @JsonKey(name: 'currency_id')
  final String currencyId;
  @override
  @JsonKey(name: 'created_by')
  final String userId;
  @override
  @JsonKey(name: 'record_date')
  final DateTime recordDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'credit')
  final bool isCredit;
  final List<DenominationDto> _denominations;
  @override
  @JsonKey()
  List<DenominationDto> get denominations {
    if (_denominations is EqualUnmodifiableListView) return _denominations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_denominations);
  }

  @override
  String toString() {
    return 'VaultTransactionDto(transactionId: $transactionId, companyId: $companyId, storeId: $storeId, locationId: $locationId, currencyId: $currencyId, userId: $userId, recordDate: $recordDate, createdAt: $createdAt, isCredit: $isCredit, denominations: $denominations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VaultTransactionDtoImpl &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.locationId, locationId) ||
                other.locationId == locationId) &&
            (identical(other.currencyId, currencyId) ||
                other.currencyId == currencyId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.recordDate, recordDate) ||
                other.recordDate == recordDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isCredit, isCredit) ||
                other.isCredit == isCredit) &&
            const DeepCollectionEquality()
                .equals(other._denominations, _denominations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionId,
      companyId,
      storeId,
      locationId,
      currencyId,
      userId,
      recordDate,
      createdAt,
      isCredit,
      const DeepCollectionEquality().hash(_denominations));

  /// Create a copy of VaultTransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VaultTransactionDtoImplCopyWith<_$VaultTransactionDtoImpl> get copyWith =>
      __$$VaultTransactionDtoImplCopyWithImpl<_$VaultTransactionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VaultTransactionDtoImplToJson(
      this,
    );
  }
}

abstract class _VaultTransactionDto extends VaultTransactionDto {
  const factory _VaultTransactionDto(
      {@JsonKey(name: 'transaction_id') final String? transactionId,
      @JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'store_id') final String? storeId,
      @JsonKey(name: 'location_id') required final String locationId,
      @JsonKey(name: 'currency_id') required final String currencyId,
      @JsonKey(name: 'created_by') required final String userId,
      @JsonKey(name: 'record_date') required final DateTime recordDate,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'credit') required final bool isCredit,
      final List<DenominationDto> denominations}) = _$VaultTransactionDtoImpl;
  const _VaultTransactionDto._() : super._();

  factory _VaultTransactionDto.fromJson(Map<String, dynamic> json) =
      _$VaultTransactionDtoImpl.fromJson;

  @override
  @JsonKey(name: 'transaction_id')
  String? get transactionId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'store_id')
  String? get storeId;
  @override
  @JsonKey(name: 'location_id')
  String get locationId;
  @override
  @JsonKey(name: 'currency_id')
  String get currencyId;
  @override
  @JsonKey(name: 'created_by')
  String get userId;
  @override
  @JsonKey(name: 'record_date')
  DateTime get recordDate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'credit')
  bool get isCredit;
  @override
  List<DenominationDto> get denominations;

  /// Create a copy of VaultTransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VaultTransactionDtoImplCopyWith<_$VaultTransactionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
