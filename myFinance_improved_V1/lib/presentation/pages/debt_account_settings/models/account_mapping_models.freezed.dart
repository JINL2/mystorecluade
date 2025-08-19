// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_mapping_models.dart';

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
  @JsonKey(name: 'linked_company_id')
  String get linkedCompanyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_account_id')
  String get linkedAccountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Additional fields for display purposes (joined data)
  @JsonKey(name: 'my_company_name', includeIfNull: false)
  String? get myCompanyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'my_account_name', includeIfNull: false)
  String? get myAccountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'counterparty_name', includeIfNull: false)
  String? get counterpartyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_company_name', includeIfNull: false)
  String? get linkedCompanyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'linked_account_name', includeIfNull: false)
  String? get linkedAccountName => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'linked_company_id') String linkedCompanyId,
      @JsonKey(name: 'linked_account_id') String linkedAccountId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'my_company_name', includeIfNull: false)
      String? myCompanyName,
      @JsonKey(name: 'my_account_name', includeIfNull: false)
      String? myAccountName,
      @JsonKey(name: 'counterparty_name', includeIfNull: false)
      String? counterpartyName,
      @JsonKey(name: 'linked_company_name', includeIfNull: false)
      String? linkedCompanyName,
      @JsonKey(name: 'linked_account_name', includeIfNull: false)
      String? linkedAccountName});
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
    Object? linkedCompanyId = null,
    Object? linkedAccountId = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? myCompanyName = freezed,
    Object? myAccountName = freezed,
    Object? counterpartyName = freezed,
    Object? linkedCompanyName = freezed,
    Object? linkedAccountName = freezed,
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
      linkedCompanyId: null == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedAccountId: null == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      myCompanyName: freezed == myCompanyName
          ? _value.myCompanyName
          : myCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountName: freezed == myAccountName
          ? _value.myAccountName
          : myAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountName: freezed == linkedAccountName
          ? _value.linkedAccountName
          : linkedAccountName // ignore: cast_nullable_to_non_nullable
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
      @JsonKey(name: 'linked_company_id') String linkedCompanyId,
      @JsonKey(name: 'linked_account_id') String linkedAccountId,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'my_company_name', includeIfNull: false)
      String? myCompanyName,
      @JsonKey(name: 'my_account_name', includeIfNull: false)
      String? myAccountName,
      @JsonKey(name: 'counterparty_name', includeIfNull: false)
      String? counterpartyName,
      @JsonKey(name: 'linked_company_name', includeIfNull: false)
      String? linkedCompanyName,
      @JsonKey(name: 'linked_account_name', includeIfNull: false)
      String? linkedAccountName});
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
    Object? linkedCompanyId = null,
    Object? linkedAccountId = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? myCompanyName = freezed,
    Object? myAccountName = freezed,
    Object? counterpartyName = freezed,
    Object? linkedCompanyName = freezed,
    Object? linkedAccountName = freezed,
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
      linkedCompanyId: null == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      linkedAccountId: null == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      myCompanyName: freezed == myCompanyName
          ? _value.myCompanyName
          : myCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      myAccountName: freezed == myAccountName
          ? _value.myAccountName
          : myAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyName: freezed == counterpartyName
          ? _value.counterpartyName
          : counterpartyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyName: freezed == linkedCompanyName
          ? _value.linkedCompanyName
          : linkedCompanyName // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountName: freezed == linkedAccountName
          ? _value.linkedAccountName
          : linkedAccountName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountMappingImpl extends _AccountMapping {
  const _$AccountMappingImpl(
      {@JsonKey(name: 'mapping_id') required this.mappingId,
      @JsonKey(name: 'my_company_id') required this.myCompanyId,
      @JsonKey(name: 'my_account_id') required this.myAccountId,
      @JsonKey(name: 'counterparty_id') required this.counterpartyId,
      @JsonKey(name: 'linked_company_id') required this.linkedCompanyId,
      @JsonKey(name: 'linked_account_id') required this.linkedAccountId,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'my_company_name', includeIfNull: false)
      this.myCompanyName,
      @JsonKey(name: 'my_account_name', includeIfNull: false)
      this.myAccountName,
      @JsonKey(name: 'counterparty_name', includeIfNull: false)
      this.counterpartyName,
      @JsonKey(name: 'linked_company_name', includeIfNull: false)
      this.linkedCompanyName,
      @JsonKey(name: 'linked_account_name', includeIfNull: false)
      this.linkedAccountName})
      : super._();

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
  @JsonKey(name: 'linked_company_id')
  final String linkedCompanyId;
  @override
  @JsonKey(name: 'linked_account_id')
  final String linkedAccountId;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Additional fields for display purposes (joined data)
  @override
  @JsonKey(name: 'my_company_name', includeIfNull: false)
  final String? myCompanyName;
  @override
  @JsonKey(name: 'my_account_name', includeIfNull: false)
  final String? myAccountName;
  @override
  @JsonKey(name: 'counterparty_name', includeIfNull: false)
  final String? counterpartyName;
  @override
  @JsonKey(name: 'linked_company_name', includeIfNull: false)
  final String? linkedCompanyName;
  @override
  @JsonKey(name: 'linked_account_name', includeIfNull: false)
  final String? linkedAccountName;

  @override
  String toString() {
    return 'AccountMapping(mappingId: $mappingId, myCompanyId: $myCompanyId, myAccountId: $myAccountId, counterpartyId: $counterpartyId, linkedCompanyId: $linkedCompanyId, linkedAccountId: $linkedAccountId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, myCompanyName: $myCompanyName, myAccountName: $myAccountName, counterpartyName: $counterpartyName, linkedCompanyName: $linkedCompanyName, linkedAccountName: $linkedAccountName)';
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
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.linkedAccountId, linkedAccountId) ||
                other.linkedAccountId == linkedAccountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.myCompanyName, myCompanyName) ||
                other.myCompanyName == myCompanyName) &&
            (identical(other.myAccountName, myAccountName) ||
                other.myAccountName == myAccountName) &&
            (identical(other.counterpartyName, counterpartyName) ||
                other.counterpartyName == counterpartyName) &&
            (identical(other.linkedCompanyName, linkedCompanyName) ||
                other.linkedCompanyName == linkedCompanyName) &&
            (identical(other.linkedAccountName, linkedAccountName) ||
                other.linkedAccountName == linkedAccountName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mappingId,
      myCompanyId,
      myAccountId,
      counterpartyId,
      linkedCompanyId,
      linkedAccountId,
      isActive,
      createdAt,
      updatedAt,
      myCompanyName,
      myAccountName,
      counterpartyName,
      linkedCompanyName,
      linkedAccountName);

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

abstract class _AccountMapping extends AccountMapping {
  const factory _AccountMapping(
      {@JsonKey(name: 'mapping_id') required final String mappingId,
      @JsonKey(name: 'my_company_id') required final String myCompanyId,
      @JsonKey(name: 'my_account_id') required final String myAccountId,
      @JsonKey(name: 'counterparty_id') required final String counterpartyId,
      @JsonKey(name: 'linked_company_id') required final String linkedCompanyId,
      @JsonKey(name: 'linked_account_id') required final String linkedAccountId,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'my_company_name', includeIfNull: false)
      final String? myCompanyName,
      @JsonKey(name: 'my_account_name', includeIfNull: false)
      final String? myAccountName,
      @JsonKey(name: 'counterparty_name', includeIfNull: false)
      final String? counterpartyName,
      @JsonKey(name: 'linked_company_name', includeIfNull: false)
      final String? linkedCompanyName,
      @JsonKey(name: 'linked_account_name', includeIfNull: false)
      final String? linkedAccountName}) = _$AccountMappingImpl;
  const _AccountMapping._() : super._();

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
  @JsonKey(name: 'linked_company_id')
  String get linkedCompanyId;
  @override
  @JsonKey(name: 'linked_account_id')
  String get linkedAccountId;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime?
      get updatedAt; // Additional fields for display purposes (joined data)
  @override
  @JsonKey(name: 'my_company_name', includeIfNull: false)
  String? get myCompanyName;
  @override
  @JsonKey(name: 'my_account_name', includeIfNull: false)
  String? get myAccountName;
  @override
  @JsonKey(name: 'counterparty_name', includeIfNull: false)
  String? get counterpartyName;
  @override
  @JsonKey(name: 'linked_company_name', includeIfNull: false)
  String? get linkedCompanyName;
  @override
  @JsonKey(name: 'linked_account_name', includeIfNull: false)
  String? get linkedAccountName;

  /// Create a copy of AccountMapping
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMappingImplCopyWith<_$AccountMappingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountMappingFormData _$AccountMappingFormDataFromJson(
    Map<String, dynamic> json) {
  return _AccountMappingFormData.fromJson(json);
}

/// @nodoc
mixin _$AccountMappingFormData {
  String? get mappingId => throw _privateConstructorUsedError;
  String get myCompanyId => throw _privateConstructorUsedError;
  String? get myAccountId => throw _privateConstructorUsedError;
  String? get counterpartyId => throw _privateConstructorUsedError;
  String? get linkedCompanyId => throw _privateConstructorUsedError;
  String? get linkedAccountId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this AccountMappingFormData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountMappingFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountMappingFormDataCopyWith<AccountMappingFormData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountMappingFormDataCopyWith<$Res> {
  factory $AccountMappingFormDataCopyWith(AccountMappingFormData value,
          $Res Function(AccountMappingFormData) then) =
      _$AccountMappingFormDataCopyWithImpl<$Res, AccountMappingFormData>;
  @useResult
  $Res call(
      {String? mappingId,
      String myCompanyId,
      String? myAccountId,
      String? counterpartyId,
      String? linkedCompanyId,
      String? linkedAccountId,
      bool isActive});
}

/// @nodoc
class _$AccountMappingFormDataCopyWithImpl<$Res,
        $Val extends AccountMappingFormData>
    implements $AccountMappingFormDataCopyWith<$Res> {
  _$AccountMappingFormDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountMappingFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = freezed,
    Object? myCompanyId = null,
    Object? myAccountId = freezed,
    Object? counterpartyId = freezed,
    Object? linkedCompanyId = freezed,
    Object? linkedAccountId = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      mappingId: freezed == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as String?,
      myCompanyId: null == myCompanyId
          ? _value.myCompanyId
          : myCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      myAccountId: freezed == myAccountId
          ? _value.myAccountId
          : myAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountId: freezed == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountMappingFormDataImplCopyWith<$Res>
    implements $AccountMappingFormDataCopyWith<$Res> {
  factory _$$AccountMappingFormDataImplCopyWith(
          _$AccountMappingFormDataImpl value,
          $Res Function(_$AccountMappingFormDataImpl) then) =
      __$$AccountMappingFormDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? mappingId,
      String myCompanyId,
      String? myAccountId,
      String? counterpartyId,
      String? linkedCompanyId,
      String? linkedAccountId,
      bool isActive});
}

/// @nodoc
class __$$AccountMappingFormDataImplCopyWithImpl<$Res>
    extends _$AccountMappingFormDataCopyWithImpl<$Res,
        _$AccountMappingFormDataImpl>
    implements _$$AccountMappingFormDataImplCopyWith<$Res> {
  __$$AccountMappingFormDataImplCopyWithImpl(
      _$AccountMappingFormDataImpl _value,
      $Res Function(_$AccountMappingFormDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountMappingFormData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mappingId = freezed,
    Object? myCompanyId = null,
    Object? myAccountId = freezed,
    Object? counterpartyId = freezed,
    Object? linkedCompanyId = freezed,
    Object? linkedAccountId = freezed,
    Object? isActive = null,
  }) {
    return _then(_$AccountMappingFormDataImpl(
      mappingId: freezed == mappingId
          ? _value.mappingId
          : mappingId // ignore: cast_nullable_to_non_nullable
              as String?,
      myCompanyId: null == myCompanyId
          ? _value.myCompanyId
          : myCompanyId // ignore: cast_nullable_to_non_nullable
              as String,
      myAccountId: freezed == myAccountId
          ? _value.myAccountId
          : myAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedCompanyId: freezed == linkedCompanyId
          ? _value.linkedCompanyId
          : linkedCompanyId // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedAccountId: freezed == linkedAccountId
          ? _value.linkedAccountId
          : linkedAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountMappingFormDataImpl implements _AccountMappingFormData {
  const _$AccountMappingFormDataImpl(
      {this.mappingId,
      required this.myCompanyId,
      this.myAccountId,
      this.counterpartyId,
      this.linkedCompanyId,
      this.linkedAccountId,
      this.isActive = true});

  factory _$AccountMappingFormDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountMappingFormDataImplFromJson(json);

  @override
  final String? mappingId;
  @override
  final String myCompanyId;
  @override
  final String? myAccountId;
  @override
  final String? counterpartyId;
  @override
  final String? linkedCompanyId;
  @override
  final String? linkedAccountId;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'AccountMappingFormData(mappingId: $mappingId, myCompanyId: $myCompanyId, myAccountId: $myAccountId, counterpartyId: $counterpartyId, linkedCompanyId: $linkedCompanyId, linkedAccountId: $linkedAccountId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountMappingFormDataImpl &&
            (identical(other.mappingId, mappingId) ||
                other.mappingId == mappingId) &&
            (identical(other.myCompanyId, myCompanyId) ||
                other.myCompanyId == myCompanyId) &&
            (identical(other.myAccountId, myAccountId) ||
                other.myAccountId == myAccountId) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.linkedCompanyId, linkedCompanyId) ||
                other.linkedCompanyId == linkedCompanyId) &&
            (identical(other.linkedAccountId, linkedAccountId) ||
                other.linkedAccountId == linkedAccountId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mappingId, myCompanyId,
      myAccountId, counterpartyId, linkedCompanyId, linkedAccountId, isActive);

  /// Create a copy of AccountMappingFormData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountMappingFormDataImplCopyWith<_$AccountMappingFormDataImpl>
      get copyWith => __$$AccountMappingFormDataImplCopyWithImpl<
          _$AccountMappingFormDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountMappingFormDataImplToJson(
      this,
    );
  }
}

abstract class _AccountMappingFormData implements AccountMappingFormData {
  const factory _AccountMappingFormData(
      {final String? mappingId,
      required final String myCompanyId,
      final String? myAccountId,
      final String? counterpartyId,
      final String? linkedCompanyId,
      final String? linkedAccountId,
      final bool isActive}) = _$AccountMappingFormDataImpl;

  factory _AccountMappingFormData.fromJson(Map<String, dynamic> json) =
      _$AccountMappingFormDataImpl.fromJson;

  @override
  String? get mappingId;
  @override
  String get myCompanyId;
  @override
  String? get myAccountId;
  @override
  String? get counterpartyId;
  @override
  String? get linkedCompanyId;
  @override
  String? get linkedAccountId;
  @override
  bool get isActive;

  /// Create a copy of AccountMappingFormData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMappingFormDataImplCopyWith<_$AccountMappingFormDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) {
  return _AccountInfo.fromJson(json);
}

/// @nodoc
mixin _$AccountInfo {
  @JsonKey(name: 'account_id')
  String get accountId => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_name')
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account_type')
  String? get accountType => throw _privateConstructorUsedError;
  @JsonKey(name: 'expense_nature')
  String? get expenseNature => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_tag')
  String? get categoryTag => throw _privateConstructorUsedError;
  @JsonKey(name: 'description', includeIfNull: false)
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this AccountInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountInfoCopyWith<AccountInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountInfoCopyWith<$Res> {
  factory $AccountInfoCopyWith(
          AccountInfo value, $Res Function(AccountInfo) then) =
      _$AccountInfoCopyWithImpl<$Res, AccountInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String? accountType,
      @JsonKey(name: 'expense_nature') String? expenseNature,
      @JsonKey(name: 'category_tag') String? categoryTag,
      @JsonKey(name: 'description', includeIfNull: false) String? description});
}

/// @nodoc
class _$AccountInfoCopyWithImpl<$Res, $Val extends AccountInfo>
    implements $AccountInfoCopyWith<$Res> {
  _$AccountInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = freezed,
    Object? expenseNature = freezed,
    Object? categoryTag = freezed,
    Object? description = freezed,
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
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountInfoImplCopyWith<$Res>
    implements $AccountInfoCopyWith<$Res> {
  factory _$$AccountInfoImplCopyWith(
          _$AccountInfoImpl value, $Res Function(_$AccountInfoImpl) then) =
      __$$AccountInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'account_name') String accountName,
      @JsonKey(name: 'account_type') String? accountType,
      @JsonKey(name: 'expense_nature') String? expenseNature,
      @JsonKey(name: 'category_tag') String? categoryTag,
      @JsonKey(name: 'description', includeIfNull: false) String? description});
}

/// @nodoc
class __$$AccountInfoImplCopyWithImpl<$Res>
    extends _$AccountInfoCopyWithImpl<$Res, _$AccountInfoImpl>
    implements _$$AccountInfoImplCopyWith<$Res> {
  __$$AccountInfoImplCopyWithImpl(
      _$AccountInfoImpl _value, $Res Function(_$AccountInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? accountName = null,
    Object? accountType = freezed,
    Object? expenseNature = freezed,
    Object? categoryTag = freezed,
    Object? description = freezed,
  }) {
    return _then(_$AccountInfoImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      accountType: freezed == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as String?,
      expenseNature: freezed == expenseNature
          ? _value.expenseNature
          : expenseNature // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryTag: freezed == categoryTag
          ? _value.categoryTag
          : categoryTag // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountInfoImpl implements _AccountInfo {
  const _$AccountInfoImpl(
      {@JsonKey(name: 'account_id') required this.accountId,
      @JsonKey(name: 'account_name') required this.accountName,
      @JsonKey(name: 'account_type') this.accountType,
      @JsonKey(name: 'expense_nature') this.expenseNature,
      @JsonKey(name: 'category_tag') this.categoryTag,
      @JsonKey(name: 'description', includeIfNull: false) this.description});

  factory _$AccountInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountInfoImplFromJson(json);

  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'account_name')
  final String accountName;
  @override
  @JsonKey(name: 'account_type')
  final String? accountType;
  @override
  @JsonKey(name: 'expense_nature')
  final String? expenseNature;
  @override
  @JsonKey(name: 'category_tag')
  final String? categoryTag;
  @override
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;

  @override
  String toString() {
    return 'AccountInfo(accountId: $accountId, accountName: $accountName, accountType: $accountType, expenseNature: $expenseNature, categoryTag: $categoryTag, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountInfoImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.expenseNature, expenseNature) ||
                other.expenseNature == expenseNature) &&
            (identical(other.categoryTag, categoryTag) ||
                other.categoryTag == categoryTag) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountId, accountName,
      accountType, expenseNature, categoryTag, description);

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      __$$AccountInfoImplCopyWithImpl<_$AccountInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountInfoImplToJson(
      this,
    );
  }
}

abstract class _AccountInfo implements AccountInfo {
  const factory _AccountInfo(
      {@JsonKey(name: 'account_id') required final String accountId,
      @JsonKey(name: 'account_name') required final String accountName,
      @JsonKey(name: 'account_type') final String? accountType,
      @JsonKey(name: 'expense_nature') final String? expenseNature,
      @JsonKey(name: 'category_tag') final String? categoryTag,
      @JsonKey(name: 'description', includeIfNull: false)
      final String? description}) = _$AccountInfoImpl;

  factory _AccountInfo.fromJson(Map<String, dynamic> json) =
      _$AccountInfoImpl.fromJson;

  @override
  @JsonKey(name: 'account_id')
  String get accountId;
  @override
  @JsonKey(name: 'account_name')
  String get accountName;
  @override
  @JsonKey(name: 'account_type')
  String? get accountType;
  @override
  @JsonKey(name: 'expense_nature')
  String? get expenseNature;
  @override
  @JsonKey(name: 'category_tag')
  String? get categoryTag;
  @override
  @JsonKey(name: 'description', includeIfNull: false)
  String? get description;

  /// Create a copy of AccountInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountInfoImplCopyWith<_$AccountInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyInfo _$CompanyInfoFromJson(Map<String, dynamic> json) {
  return _CompanyInfo.fromJson(json);
}

/// @nodoc
mixin _$CompanyInfo {
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_code')
  String? get companyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this CompanyInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyInfoCopyWith<CompanyInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyInfoCopyWith<$Res> {
  factory $CompanyInfoCopyWith(
          CompanyInfo value, $Res Function(CompanyInfo) then) =
      _$CompanyInfoCopyWithImpl<$Res, CompanyInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_code') String? companyCode,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class _$CompanyInfoCopyWithImpl<$Res, $Val extends CompanyInfo>
    implements $CompanyInfoCopyWith<$Res> {
  _$CompanyInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCode = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyCode: freezed == companyCode
          ? _value.companyCode
          : companyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanyInfoImplCopyWith<$Res>
    implements $CompanyInfoCopyWith<$Res> {
  factory _$$CompanyInfoImplCopyWith(
          _$CompanyInfoImpl value, $Res Function(_$CompanyInfoImpl) then) =
      __$$CompanyInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'company_name') String companyName,
      @JsonKey(name: 'company_code') String? companyCode,
      @JsonKey(name: 'is_active') bool isActive});
}

/// @nodoc
class __$$CompanyInfoImplCopyWithImpl<$Res>
    extends _$CompanyInfoCopyWithImpl<$Res, _$CompanyInfoImpl>
    implements _$$CompanyInfoImplCopyWith<$Res> {
  __$$CompanyInfoImplCopyWithImpl(
      _$CompanyInfoImpl _value, $Res Function(_$CompanyInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCode = freezed,
    Object? isActive = null,
  }) {
    return _then(_$CompanyInfoImpl(
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      companyCode: freezed == companyCode
          ? _value.companyCode
          : companyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompanyInfoImpl implements _CompanyInfo {
  const _$CompanyInfoImpl(
      {@JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'company_name') required this.companyName,
      @JsonKey(name: 'company_code') this.companyCode,
      @JsonKey(name: 'is_active') this.isActive = true});

  factory _$CompanyInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyInfoImplFromJson(json);

  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  @JsonKey(name: 'company_code')
  final String? companyCode;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'CompanyInfo(companyId: $companyId, companyName: $companyName, companyCode: $companyCode, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyInfoImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyCode, companyCode) ||
                other.companyCode == companyCode) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, companyId, companyName, companyCode, isActive);

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyInfoImplCopyWith<_$CompanyInfoImpl> get copyWith =>
      __$$CompanyInfoImplCopyWithImpl<_$CompanyInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyInfoImplToJson(
      this,
    );
  }
}

abstract class _CompanyInfo implements CompanyInfo {
  const factory _CompanyInfo(
      {@JsonKey(name: 'company_id') required final String companyId,
      @JsonKey(name: 'company_name') required final String companyName,
      @JsonKey(name: 'company_code') final String? companyCode,
      @JsonKey(name: 'is_active') final bool isActive}) = _$CompanyInfoImpl;

  factory _CompanyInfo.fromJson(Map<String, dynamic> json) =
      _$CompanyInfoImpl.fromJson;

  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  @JsonKey(name: 'company_code')
  String? get companyCode;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of CompanyInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyInfoImplCopyWith<_$CompanyInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccountMappingResponse _$AccountMappingResponseFromJson(
    Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return AccountMappingResponseSuccess.fromJson(json);
    case 'error':
      return AccountMappingResponseError.fromJson(json);

    default:
      throw CheckedFromJsonException(
          json,
          'runtimeType',
          'AccountMappingResponse',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AccountMappingResponse {
  String? get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AccountMapping data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AccountMapping data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AccountMapping data, String? message)? success,
    TResult Function(String message, String? code)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AccountMappingResponseSuccess value) success,
    required TResult Function(AccountMappingResponseError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AccountMappingResponseSuccess value)? success,
    TResult? Function(AccountMappingResponseError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AccountMappingResponseSuccess value)? success,
    TResult Function(AccountMappingResponseError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AccountMappingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountMappingResponseCopyWith<AccountMappingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountMappingResponseCopyWith<$Res> {
  factory $AccountMappingResponseCopyWith(AccountMappingResponse value,
          $Res Function(AccountMappingResponse) then) =
      _$AccountMappingResponseCopyWithImpl<$Res, AccountMappingResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AccountMappingResponseCopyWithImpl<$Res,
        $Val extends AccountMappingResponse>
    implements $AccountMappingResponseCopyWith<$Res> {
  _$AccountMappingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountMappingResponse
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
abstract class _$$AccountMappingResponseSuccessImplCopyWith<$Res>
    implements $AccountMappingResponseCopyWith<$Res> {
  factory _$$AccountMappingResponseSuccessImplCopyWith(
          _$AccountMappingResponseSuccessImpl value,
          $Res Function(_$AccountMappingResponseSuccessImpl) then) =
      __$$AccountMappingResponseSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AccountMapping data, String? message});

  $AccountMappingCopyWith<$Res> get data;
}

/// @nodoc
class __$$AccountMappingResponseSuccessImplCopyWithImpl<$Res>
    extends _$AccountMappingResponseCopyWithImpl<$Res,
        _$AccountMappingResponseSuccessImpl>
    implements _$$AccountMappingResponseSuccessImplCopyWith<$Res> {
  __$$AccountMappingResponseSuccessImplCopyWithImpl(
      _$AccountMappingResponseSuccessImpl _value,
      $Res Function(_$AccountMappingResponseSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? message = freezed,
  }) {
    return _then(_$AccountMappingResponseSuccessImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as AccountMapping,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AccountMappingCopyWith<$Res> get data {
    return $AccountMappingCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountMappingResponseSuccessImpl
    implements AccountMappingResponseSuccess {
  const _$AccountMappingResponseSuccessImpl(
      {required this.data, this.message, final String? $type})
      : $type = $type ?? 'success';

  factory _$AccountMappingResponseSuccessImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AccountMappingResponseSuccessImplFromJson(json);

  @override
  final AccountMapping data;
  @override
  final String? message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AccountMappingResponse.success(data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountMappingResponseSuccessImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data, message);

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountMappingResponseSuccessImplCopyWith<
          _$AccountMappingResponseSuccessImpl>
      get copyWith => __$$AccountMappingResponseSuccessImplCopyWithImpl<
          _$AccountMappingResponseSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AccountMapping data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) {
    return success(data, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AccountMapping data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) {
    return success?.call(data, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AccountMapping data, String? message)? success,
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
    required TResult Function(AccountMappingResponseSuccess value) success,
    required TResult Function(AccountMappingResponseError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AccountMappingResponseSuccess value)? success,
    TResult? Function(AccountMappingResponseError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AccountMappingResponseSuccess value)? success,
    TResult Function(AccountMappingResponseError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountMappingResponseSuccessImplToJson(
      this,
    );
  }
}

abstract class AccountMappingResponseSuccess implements AccountMappingResponse {
  const factory AccountMappingResponseSuccess(
      {required final AccountMapping data,
      final String? message}) = _$AccountMappingResponseSuccessImpl;

  factory AccountMappingResponseSuccess.fromJson(Map<String, dynamic> json) =
      _$AccountMappingResponseSuccessImpl.fromJson;

  AccountMapping get data;
  @override
  String? get message;

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMappingResponseSuccessImplCopyWith<
          _$AccountMappingResponseSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AccountMappingResponseErrorImplCopyWith<$Res>
    implements $AccountMappingResponseCopyWith<$Res> {
  factory _$$AccountMappingResponseErrorImplCopyWith(
          _$AccountMappingResponseErrorImpl value,
          $Res Function(_$AccountMappingResponseErrorImpl) then) =
      __$$AccountMappingResponseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$AccountMappingResponseErrorImplCopyWithImpl<$Res>
    extends _$AccountMappingResponseCopyWithImpl<$Res,
        _$AccountMappingResponseErrorImpl>
    implements _$$AccountMappingResponseErrorImplCopyWith<$Res> {
  __$$AccountMappingResponseErrorImplCopyWithImpl(
      _$AccountMappingResponseErrorImpl _value,
      $Res Function(_$AccountMappingResponseErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$AccountMappingResponseErrorImpl(
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
class _$AccountMappingResponseErrorImpl implements AccountMappingResponseError {
  const _$AccountMappingResponseErrorImpl(
      {required this.message, this.code, final String? $type})
      : $type = $type ?? 'error';

  factory _$AccountMappingResponseErrorImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AccountMappingResponseErrorImplFromJson(json);

  @override
  final String message;
  @override
  final String? code;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AccountMappingResponse.error(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountMappingResponseErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountMappingResponseErrorImplCopyWith<_$AccountMappingResponseErrorImpl>
      get copyWith => __$$AccountMappingResponseErrorImplCopyWithImpl<
          _$AccountMappingResponseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AccountMapping data, String? message) success,
    required TResult Function(String message, String? code) error,
  }) {
    return error(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AccountMapping data, String? message)? success,
    TResult? Function(String message, String? code)? error,
  }) {
    return error?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AccountMapping data, String? message)? success,
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
    required TResult Function(AccountMappingResponseSuccess value) success,
    required TResult Function(AccountMappingResponseError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AccountMappingResponseSuccess value)? success,
    TResult? Function(AccountMappingResponseError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AccountMappingResponseSuccess value)? success,
    TResult Function(AccountMappingResponseError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountMappingResponseErrorImplToJson(
      this,
    );
  }
}

abstract class AccountMappingResponseError implements AccountMappingResponse {
  const factory AccountMappingResponseError(
      {required final String message,
      final String? code}) = _$AccountMappingResponseErrorImpl;

  factory AccountMappingResponseError.fromJson(Map<String, dynamic> json) =
      _$AccountMappingResponseErrorImpl.fromJson;

  @override
  String get message;
  String? get code;

  /// Create a copy of AccountMappingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountMappingResponseErrorImplCopyWith<_$AccountMappingResponseErrorImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MappingValidationResult {
  bool get isValid => throw _privateConstructorUsedError;
  Map<String, String>? get errors => throw _privateConstructorUsedError;

  /// Create a copy of MappingValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MappingValidationResultCopyWith<MappingValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MappingValidationResultCopyWith<$Res> {
  factory $MappingValidationResultCopyWith(MappingValidationResult value,
          $Res Function(MappingValidationResult) then) =
      _$MappingValidationResultCopyWithImpl<$Res, MappingValidationResult>;
  @useResult
  $Res call({bool isValid, Map<String, String>? errors});
}

/// @nodoc
class _$MappingValidationResultCopyWithImpl<$Res,
        $Val extends MappingValidationResult>
    implements $MappingValidationResultCopyWith<$Res> {
  _$MappingValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MappingValidationResult
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
abstract class _$$MappingValidationResultImplCopyWith<$Res>
    implements $MappingValidationResultCopyWith<$Res> {
  factory _$$MappingValidationResultImplCopyWith(
          _$MappingValidationResultImpl value,
          $Res Function(_$MappingValidationResultImpl) then) =
      __$$MappingValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid, Map<String, String>? errors});
}

/// @nodoc
class __$$MappingValidationResultImplCopyWithImpl<$Res>
    extends _$MappingValidationResultCopyWithImpl<$Res,
        _$MappingValidationResultImpl>
    implements _$$MappingValidationResultImplCopyWith<$Res> {
  __$$MappingValidationResultImplCopyWithImpl(
      _$MappingValidationResultImpl _value,
      $Res Function(_$MappingValidationResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of MappingValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? errors = freezed,
  }) {
    return _then(_$MappingValidationResultImpl(
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

class _$MappingValidationResultImpl implements _MappingValidationResult {
  const _$MappingValidationResultImpl(
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
    return 'MappingValidationResult(isValid: $isValid, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MappingValidationResultImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isValid, const DeepCollectionEquality().hash(_errors));

  /// Create a copy of MappingValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MappingValidationResultImplCopyWith<_$MappingValidationResultImpl>
      get copyWith => __$$MappingValidationResultImplCopyWithImpl<
          _$MappingValidationResultImpl>(this, _$identity);
}

abstract class _MappingValidationResult implements MappingValidationResult {
  const factory _MappingValidationResult(
      {required final bool isValid,
      final Map<String, String>? errors}) = _$MappingValidationResultImpl;

  @override
  bool get isValid;
  @override
  Map<String, String>? get errors;

  /// Create a copy of MappingValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MappingValidationResultImplCopyWith<_$MappingValidationResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
