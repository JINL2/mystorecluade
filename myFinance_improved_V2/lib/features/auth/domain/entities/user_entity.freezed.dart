// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// User ID (matches auth.users.id from Supabase)
  @JsonKey(name: 'user_id')
  String get id => throw _privateConstructorUsedError;

  /// Email address (unique, required)
  String get email => throw _privateConstructorUsedError;

  /// First name (optional)
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;

  /// Last name (optional)
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;

  /// Account created timestamp
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Last login timestamp
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// Email verified flag
  @JsonKey(name: 'is_email_verified')
  bool get isEmailVerified =>
      throw _privateConstructorUsedError; // ============================================================
// Additional fields from UserModel (for database layer)
// ============================================================
  /// Phone number (optional, database-only field)
  @JsonKey(name: 'user_phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Profile image URL (optional, database-only field)
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;

  /// Preferred timezone (optional, database-only field)
  @JsonKey(name: 'preferred_timezone')
  String? get timezone => throw _privateConstructorUsedError;

  /// Last updated timestamp (database-only field)
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Soft delete flag (database-only field)
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String id,
      String email,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
      @JsonKey(name: 'is_email_verified') bool isEmailVerified,
      @JsonKey(name: 'user_phone_number') String? phoneNumber,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'preferred_timezone') String? timezone,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? isEmailVerified = null,
    Object? phoneNumber = freezed,
    Object? profileImage = freezed,
    Object? timezone = freezed,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String id,
      String email,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
      @JsonKey(name: 'is_email_verified') bool isEmailVerified,
      @JsonKey(name: 'user_phone_number') String? phoneNumber,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'preferred_timezone') String? timezone,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') bool isDeleted});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? createdAt = null,
    Object? lastLoginAt = freezed,
    Object? isEmailVerified = null,
    Object? phoneNumber = freezed,
    Object? profileImage = freezed,
    Object? timezone = freezed,
    Object? updatedAt = freezed,
    Object? isDeleted = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl(
      {@JsonKey(name: 'user_id') required this.id,
      required this.email,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'last_login_at') this.lastLoginAt,
      @JsonKey(name: 'is_email_verified') this.isEmailVerified = false,
      @JsonKey(name: 'user_phone_number') this.phoneNumber,
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'preferred_timezone') this.timezone,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'is_deleted') this.isDeleted = false})
      : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  /// User ID (matches auth.users.id from Supabase)
  @override
  @JsonKey(name: 'user_id')
  final String id;

  /// Email address (unique, required)
  @override
  final String email;

  /// First name (optional)
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;

  /// Last name (optional)
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;

  /// Account created timestamp
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Last login timestamp
  @override
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;

  /// Email verified flag
  @override
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
// ============================================================
// Additional fields from UserModel (for database layer)
// ============================================================
  /// Phone number (optional, database-only field)
  @override
  @JsonKey(name: 'user_phone_number')
  final String? phoneNumber;

  /// Profile image URL (optional, database-only field)
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;

  /// Preferred timezone (optional, database-only field)
  @override
  @JsonKey(name: 'preferred_timezone')
  final String? timezone;

  /// Last updated timestamp (database-only field)
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  /// Soft delete flag (database-only field)
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, createdAt: $createdAt, lastLoginAt: $lastLoginAt, isEmailVerified: $isEmailVerified, phoneNumber: $phoneNumber, profileImage: $profileImage, timezone: $timezone, updatedAt: $updatedAt, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      firstName,
      lastName,
      createdAt,
      lastLoginAt,
      isEmailVerified,
      phoneNumber,
      profileImage,
      timezone,
      updatedAt,
      isDeleted);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
      {@JsonKey(name: 'user_id') required final String id,
      required final String email,
      @JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'last_login_at') final DateTime? lastLoginAt,
      @JsonKey(name: 'is_email_verified') final bool isEmailVerified,
      @JsonKey(name: 'user_phone_number') final String? phoneNumber,
      @JsonKey(name: 'profile_image') final String? profileImage,
      @JsonKey(name: 'preferred_timezone') final String? timezone,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'is_deleted') final bool isDeleted}) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  /// User ID (matches auth.users.id from Supabase)
  @override
  @JsonKey(name: 'user_id')
  String get id;

  /// Email address (unique, required)
  @override
  String get email;

  /// First name (optional)
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;

  /// Last name (optional)
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;

  /// Account created timestamp
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Last login timestamp
  @override
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt;

  /// Email verified flag
  @override
  @JsonKey(name: 'is_email_verified')
  bool
      get isEmailVerified; // ============================================================
// Additional fields from UserModel (for database layer)
// ============================================================
  /// Phone number (optional, database-only field)
  @override
  @JsonKey(name: 'user_phone_number')
  String? get phoneNumber;

  /// Profile image URL (optional, database-only field)
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;

  /// Preferred timezone (optional, database-only field)
  @override
  @JsonKey(name: 'preferred_timezone')
  String? get timezone;

  /// Last updated timestamp (database-only field)
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Soft delete flag (database-only field)
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
