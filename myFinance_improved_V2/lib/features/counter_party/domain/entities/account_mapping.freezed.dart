// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_mapping.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountMapping _$AccountMappingFromJson(Map<String, dynamic> json) {
  return _AccountMapping.fromJson(json);
}

/// @nodoc
mixin _$AccountMapping {
  @JsonKey(name: 'mapping_id')
  String get mappingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_company_id')
  String get myCompanyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_account_id')
  String get myAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty_id')
  String get counterpartyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_account_id')
  String get linkedAccountId => throw _privateConstructorUsedError;
  String get direction =>
      throw _privateConstructorUsedError; // 'bidirectional' by default
  @JsonKey(name: 'created_by')
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // From counterparties table via join
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId =>
      throw _privateConstructorUsedError; // Display fields (for UI) from RPC joins
  @JsonKey(name: 'my_account_name')
  String? get myAccountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_account_name')
  String? get linkedAccountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_company_name')
  String? get linkedCompanyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_account_type')
  String? get myAccountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_account_type')
  String? get linkedAccountType => throw _privateConstructorUsedError;

  /// Serializes this AccountMapping to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountMappingCopyWith<AccountMapping> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountMappingCopyWith<$Res> {
  factory $AccountMappingCopyWith(
          AccountMapping value, $Res Function(AccountMapping) then) =
      _$AccountMappingCopyWithImpl<$Res, AccountMapping>;
  @useResult
  $Res call(
      {@JsonKey(name: 'mapping_id') String mappingId,
      @JsonKey(name: 'my_company_id') String myCompanyId,
      @JsonKey(name: 'my_account_id') String myAccountId,
      @JsonKey(name: 'counterparty_id') String counterpartyId,
      @JsonKey(name: 'linked_account_id') String linkedAccountId,
      String direction,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'my_account_name') String? myAccountName,
      @JsonKey(name: 'linked_account_name') String? linkedAccountName,
      @JsonKey(name: 'linked_company_name') String? linkedCompanyName,
      @JsonKey(name: 'my_account_type') String? myAccountType,
      @JsonKey(name: 'linked_account_type') String? linkedAccountType});
}

/// @nodoc
class _$AccountMappingCopyWithImpl<$Res, $Val extends AccountMapping>
    implements $AccountMappingCopyWith<$Res> {
  _$AccountMappingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = null,
    Object? myCompanyId = null,
    Object? myAccountId = null,
    Object? counterpartyId = null,
    Object? linkedAccountId = null,
    Object? direction = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? linkedCompanyId = freezed,
    Object? myAccountName = freezed,
    Object? linkedAccountName = freezed,
    Object? linkedCompanyName = freezed,
    Object? myAccountType = freezed,
    Object? linkedAccountType = freezed,
  }) {
    return _then(_value.copyWith(
      mappingId: null == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as String,
      myCompanyId: null == myCompanyId
          ? _value.myCompanyId
          : myCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      myAccountId: null == myAccountId
          ? _value.myAccountId
          : myAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedAccountId: null == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountName: freezed == myAccountName
          ? _value.myAccountName
          : myAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountName: freezed == linkedAccountName
          ? _value.linkedAccountName
          : linkedAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountType: freezed == myAccountType
          ? _value.myAccountType
          : myAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountType: freezed == linkedAccountType
          ? _value.linkedAccountType
          : linkedAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountMappingImplCopyWith<$Res>
    implements $AccountMappingCopyWith<$Res> {
  factory _$$AccountMappingImplCopyWith(_$AccountMappingImpl value,
          $Res Function(_$AccountMappingImpl) then) =
      __$$AccountMappingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'mapping_id') String mappingId,
      @JsonKey(name: 'my_company_id') String myCompanyId,
      @JsonKey(name: 'my_account_id') String myAccountId,
      @JsonKey(name: 'counterparty_id') String counterpartyId,
      @JsonKey(name: 'linked_account_id') String linkedAccountId,
      String direction,
      @JsonKey(name: 'created_by') String? createdBy,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'linked_company_id') String? linkedCompanyId,
      @JsonKey(name: 'my_account_name') String? myAccountName,
      @JsonKey(name: 'linked_account_name') String? linkedAccountName,
      @JsonKey(name: 'linked_company_name') String? linkedCompanyName,
      @JsonKey(name: 'my_account_type') String? myAccountType,
      @JsonKey(name: 'linked_account_type') String? linkedAccountType});
}

/// @nodoc
class __$$AccountMappingImplCopyWithImpl<$Res>
    extends _$AccountMappingCopyWithImpl<$Res, _$AccountMappingImpl>
    implements _$$AccountMappingImplCopyWith<$Res> {
  __$$AccountMappingImplCopyWithImpl(
      _$AccountMappingImpl _value, $Res Function(_$AccountMappingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = null,
    Object? myCompanyId = null,
    Object? myAccountId = null,
    Object? counterpartyId = null,
    Object? linkedAccountId = null,
    Object? direction = null,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? linkedCompanyId = freezed,
    Object? myAccountName = freezed,
    Object? linkedAccountName = freezed,
    Object? linkedCompanyName = freezed,
    Object? myAccountType = freezed,
    Object? linkedAccountType = freezed,
  }) {
    return _then(_$AccountMappingImpl(
      mappingId: null == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as String,
      myCompanyId: null == myCompanyId
          ? _value.myCompanyId
          : myCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      myAccountId: null == myAccountId
          ? _value.myAccountId
          : myAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: null == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedAccountId: null == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountName: freezed == myAccountName
          ? _value.myAccountName
          : myAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountName: freezed == linkedAccountName
          ? _value.linkedAccountName
          : linkedAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountType: freezed == myAccountType
          ? _value.myAccountType
          : myAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountType: freezed == linkedAccountType
          ? _value.linkedAccountType
          : linkedAccountType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountMappingImpl implements _AccountMapping {
  const _$AccountMappingImpl(
      {@JsonKey(name: 'mapping_id') required this.mappingId,
      @JsonKey(name: 'my_company_id') required this.myCompanyId,
      @JsonKey(name: 'my_account_id') required this.myAccountId,
      @JsonKey(name: 'counterparty_id') required this.counterpartyId,
      @JsonKey(name: 'linked_account_id') required this.linkedAccountId,
      required this.direction,
      @JsonKey(name: 'created_by') this.createdBy,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'linked_company_id') this.linkedCompanyId,
      @JsonKey(name: 'my_account_name') this.myAccountName,
      @JsonKey(name: 'linked_account_name') this.linkedAccountName,
      @JsonKey(name: 'linked_company_name') this.linkedCompanyName,
      @JsonKey(name: 'my_account_type') this.myAccountType,
      @JsonKey(name: 'linked_account_type') this.linkedAccountType});

  factory _$AccountMappingImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountMappingImplFromJson(json);

  @override
  @JsonKey(name: 'mapping_id')
  final String mappingId;
  @override
  @JsonKey(name: 'my_company_id')
  final String myCompanyId;
  @override
  @JsonKey(name: 'my_account_id')
  final String myAccountId;
  @override
  @JsonKey(name: 'counterparty_id')
  final String counterpartyId;
  @override
  @JsonKey(name: 'linked_account_id')
  final String linkedAccountId;
  @override
  final String direction;
// 'bidirectional' by default
  @override
  @JsonKey(name: 'created_by')
  final String? createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
// From counterparties table via join
  @override
  @JsonKey(name: 'linked_company_id')
  final String? linkedCompanyId;
// Display fields (for UI) from RPC joins
  @override
  @JsonKey(name: 'my_account_name')
  final String? myAccountName;
  @override
  @JsonKey(name: 'linked_account_name')
  final String? linkedAccountName;
  @override
  @JsonKey(name: 'linked_company_name')
  final String? linkedCompanyName;
  @override
  @JsonKey(name: 'my_account_type')
  final String? myAccountType;
  @override
  @JsonKey(name: 'linked_account_type')
  final String? linkedAccountType;

  @override
  String toString() {
    return 'AccountMapping(mappingId: $mappingId, myCompanyId: $myCompanyId, myAccountId: $myAccountId, counterpartyId: $counterpartyId, linkedAccountId: $linkedAccountId, direction: $direction, createdBy: $createdBy, createdAt: $createdAt, linkedCompanyId: $linkedCompanyId, myAccountName: $myAccountName, linkedAccountName: $linkedAccountName, linkedCompanyName: $linkedCompanyName, myAccountType: $myAccountType, linkedAccountType: $linkedAccountType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountMappingImpl &&
            (identical(other.mappingId, mappingId) ||
                other.mappingId == mappingId) &&
            (identical(other.myCompanyId, myCompanyId) ||
                other.myCompanyId == myCompanyId) &&
            (identical(other.myAccountId, myAccountId) ||
                other.myAccountId == myAccountId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.linkedAccountId, linkedAccountId) ||
                other.linkedAccountId == linkedAccountId) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.myAccountName, myAccountName) ||
                other.myAccountName == myAccountName) &&
            (identical(other.linkedAccountName, linkedAccountName) ||
                other.linkedAccountName == linkedAccountName) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            (identical(other.myAccountType, myAccountType) ||
                other.myAccountType == myAccountType) &&
            (identical(other.linkedAccountType, linkedAccountType) ||
                other.linkedAccountType == linkedAccountType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mappingId,
      myCompanyId,
      myAccountId,
      counterpartyId,
      linkedAccountId,
      direction,
      createdBy,
      createdAt,
      linkedCompanyId,
      myAccountName,
      linkedAccountName,
      linkedCompanyName,
      myAccountType,
      linkedAccountType);

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountMappingImplCopyWith<_$AccountMappingImpl> get copyWith =>
      __$$AccountMappingImplCopyWithImpl<_$AccountMappingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountMappingImplToJson(
      this,
    );
  }
}

abstract class _AccountMapping implements AccountMapping {
  const factory _AccountMapping(
      {@JsonKey(name: 'mapping_id') required final String mappingId,
      @JsonKey(name: 'my_company_id') required final String myCompanyId,
      @JsonKey(name: 'my_account_id') required final String myAccountId,
      @JsonKey(name: 'counterparty_id') required final String counterpartyId,
      @JsonKey(name: 'linked_account_id') required final String linkedAccountId,
      required final String direction,
      @JsonKey(name: 'created_by') final String? createdBy,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'linked_company_id') final String? linkedCompanyId,
      @JsonKey(name: 'my_account_name') final String? myAccountName,
      @JsonKey(name: 'linked_account_name') final String? linkedAccountName,
      @JsonKey(name: 'linked_company_name') final String? linkedCompanyName,
      @JsonKey(name: 'my_account_type') final String? myAccountType,
      @JsonKey(name: 'linked_account_type')
      final String? linkedAccountType}) = _$AccountMappingImpl;

  factory _AccountMapping.fromJson(Map<String, dynamic> json) =
      _$AccountMappingImpl.fromJson;

  @override
  @JsonKey(name: 'mapping_id')
  String get mappingId;
  @override
  @JsonKey(name: 'my_company_id')
  String get myCompanyId;
  @override
  @JsonKey(name: 'my_account_id')
  String get myAccountId;
  @override
  @JsonKey(name: 'counterparty_id')
  String get counterpartyId;
  @override
  @JsonKey(name: 'linked_account_id')
  String get linkedAccountId;
  @override
  String get direction; // 'bidirectional' by default
  @override
  @JsonKey(name: 'created_by')
  String? get createdBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt; // From counterparties table via join
  @override
  @JsonKey(name: 'linked_company_id')
  String? get linkedCompanyId; // Display fields (for UI) from RPC joins
  @override
  @JsonKey(name: 'my_account_name')
  String? get myAccountName;
  @override
  @JsonKey(name: 'linked_account_name')
  String? get linkedAccountName;
  @override
  @JsonKey(name: 'linked_company_name')
  String? get linkedCompanyName;
  @override
  @JsonKey(name: 'my_account_type')
  String? get myAccountType;
  @override
  @JsonKey(name: 'linked_account_type')
  String? get linkedAccountType;

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMappingImplCopyWith<_$AccountMappingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
