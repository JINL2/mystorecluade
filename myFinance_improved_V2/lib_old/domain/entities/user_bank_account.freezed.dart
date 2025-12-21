// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_bank_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserBankAccount _$UserBankAccountFromJson(Map<String, dynamic> json) {
  return _UserBankAccount.fromJson(json);
}

/// @nodoc
mixin _$UserBankAccount {
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_id')
  String get companyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_bank_name')
  String? get userBankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_account_number')
  String? get userAccountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserBankAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBankAccountCopyWith<UserBankAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBankAccountCopyWith<$Res> {
  factory $UserBankAccountCopyWith(
          UserBankAccount value, $Res Function(UserBankAccount) then) =
      _$UserBankAccountCopyWithImpl<$Res, UserBankAccount>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'user_bank_name') String? userBankName,
      @JsonKey(name: 'user_account_number') String? userAccountNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserBankAccountCopyWithImpl<$Res, $Val extends UserBankAccount>
    implements $UserBankAccountCopyWith<$Res> {
  _$UserBankAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? companyId = null,
    Object? userBankName = freezed,
    Object? userAccountNumber = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userBankName: freezed == userBankName
          ? _value.userBankName
          : userBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAccountNumber: freezed == userAccountNumber
          ? _value.userAccountNumber
          : userAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserBankAccountImplCopyWith<$Res>
    implements $UserBankAccountCopyWith<$Res> {
  factory _$$UserBankAccountImplCopyWith(_$UserBankAccountImpl value,
          $Res Function(_$UserBankAccountImpl) then) =
      __$$UserBankAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'company_id') String companyId,
      @JsonKey(name: 'user_bank_name') String? userBankName,
      @JsonKey(name: 'user_account_number') String? userAccountNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserBankAccountImplCopyWithImpl<$Res>
    extends _$UserBankAccountCopyWithImpl<$Res, _$UserBankAccountImpl>
    implements _$$UserBankAccountImplCopyWith<$Res> {
  __$$UserBankAccountImplCopyWithImpl(
      _$UserBankAccountImpl _value, $Res Function(_$UserBankAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? companyId = null,
    Object? userBankName = freezed,
    Object? userAccountNumber = freezed,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserBankAccountImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      companyId: null == companyId
          ? _value.companyId
          : companyId // ignore: cast_nullable_to_non_nullable
              as String,
      userBankName: freezed == userBankName
          ? _value.userBankName
          : userBankName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAccountNumber: freezed == userAccountNumber
          ? _value.userAccountNumber
          : userAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBankAccountImpl extends _UserBankAccount {
  const _$UserBankAccountImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'company_id') required this.companyId,
      @JsonKey(name: 'user_bank_name') this.userBankName,
      @JsonKey(name: 'user_account_number') this.userAccountNumber,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$UserBankAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBankAccountImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'company_id')
  final String companyId;
  @override
  @JsonKey(name: 'user_bank_name')
  final String? userBankName;
  @override
  @JsonKey(name: 'user_account_number')
  final String? userAccountNumber;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserBankAccount(id: $id, userId: $userId, companyId: $companyId, userBankName: $userBankName, userAccountNumber: $userAccountNumber, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBankAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.userBankName, userBankName) ||
                other.userBankName == userBankName) &&
            (identical(other.userAccountNumber, userAccountNumber) ||
                other.userAccountNumber == userAccountNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      userId,
      companyId,
      userBankName,
      userAccountNumber,
      description,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBankAccountImplCopyWith<_$UserBankAccountImpl> get copyWith =>
      __$$UserBankAccountImplCopyWithImpl<_$UserBankAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBankAccountImplToJson(
      this,
    );
  }
}

abstract class _UserBankAccount extends UserBankAccount {
  const factory _UserBankAccount(
          {@JsonKey(name: 'id') final int? id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'company_id') required final String companyId,
          @JsonKey(name: 'user_bank_name') final String? userBankName,
          @JsonKey(name: 'user_account_number') final String? userAccountNumber,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserBankAccountImpl;
  const _UserBankAccount._() : super._();

  factory _UserBankAccount.fromJson(Map<String, dynamic> json) =
      _$UserBankAccountImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'company_id')
  String get companyId;
  @override
  @JsonKey(name: 'user_bank_name')
  String? get userBankName;
  @override
  @JsonKey(name: 'user_account_number')
  String? get userAccountNumber;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserBankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBankAccountImplCopyWith<_$UserBankAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
