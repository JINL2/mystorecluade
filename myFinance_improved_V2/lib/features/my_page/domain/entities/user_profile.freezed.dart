// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  String? get dateOfBirth => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_name')
  String? get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank_account_number')
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'deleted_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Additional fields from relationships
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String? get storeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_name')
  String? get roleName =>
      throw _privateConstructorUsedError; // Subscription info (can be extended later)
  @JsonKey(name: 'subscription_plan')
  String get subscriptionPlan => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_status')
  String get subscriptionStatus => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'subscription_expires_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get subscriptionExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String email,
      @JsonKey(name: 'user_phone_number') String? phoneNumber,
      @JsonKey(name: 'date_of_birth') String? dateOfBirth,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(
          name: 'deleted_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? deletedAt,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? updatedAt,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'role_name') String? roleName,
      @JsonKey(name: 'subscription_plan') String subscriptionPlan,
      @JsonKey(name: 'subscription_status') String subscriptionStatus,
      @JsonKey(
          name: 'subscription_expires_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? subscriptionExpiresAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = null,
    Object? phoneNumber = freezed,
    Object? dateOfBirth = freezed,
    Object? profileImage = freezed,
    Object? bankName = freezed,
    Object? bankAccountNumber = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? companyName = freezed,
    Object? storeName = freezed,
    Object? roleName = freezed,
    Object? subscriptionPlan = null,
    Object? subscriptionStatus = null,
    Object? subscriptionExpiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionPlan: null == subscriptionPlan
          ? _value.subscriptionPlan
          : subscriptionPlan // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String email,
      @JsonKey(name: 'user_phone_number') String? phoneNumber,
      @JsonKey(name: 'date_of_birth') String? dateOfBirth,
      @JsonKey(name: 'profile_image') String? profileImage,
      @JsonKey(name: 'bank_name') String? bankName,
      @JsonKey(name: 'bank_account_number') String? bankAccountNumber,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(
          name: 'deleted_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? deletedAt,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? updatedAt,
      @JsonKey(name: 'company_name') String? companyName,
      @JsonKey(name: 'store_name') String? storeName,
      @JsonKey(name: 'role_name') String? roleName,
      @JsonKey(name: 'subscription_plan') String subscriptionPlan,
      @JsonKey(name: 'subscription_status') String subscriptionStatus,
      @JsonKey(
          name: 'subscription_expires_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      DateTime? subscriptionExpiresAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = null,
    Object? phoneNumber = freezed,
    Object? dateOfBirth = freezed,
    Object? profileImage = freezed,
    Object? bankName = freezed,
    Object? bankAccountNumber = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? companyName = freezed,
    Object? storeName = freezed,
    Object? roleName = freezed,
    Object? subscriptionPlan = null,
    Object? subscriptionStatus = null,
    Object? subscriptionExpiresAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      bankAccountNumber: freezed == bankAccountNumber
          ? _value.bankAccountNumber
          : bankAccountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: freezed == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: freezed == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String?,
      subscriptionPlan: null == subscriptionPlan
          ? _value.subscriptionPlan
          : subscriptionPlan // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionExpiresAt: freezed == subscriptionExpiresAt
          ? _value.subscriptionExpiresAt
          : subscriptionExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      required this.email,
      @JsonKey(name: 'user_phone_number') this.phoneNumber,
      @JsonKey(name: 'date_of_birth') this.dateOfBirth,
      @JsonKey(name: 'profile_image') this.profileImage,
      @JsonKey(name: 'bank_name') this.bankName,
      @JsonKey(name: 'bank_account_number') this.bankAccountNumber,
      @JsonKey(name: 'is_deleted') this.isDeleted = false,
      @JsonKey(
          name: 'deleted_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.deletedAt,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.updatedAt,
      @JsonKey(name: 'company_name') this.companyName,
      @JsonKey(name: 'store_name') this.storeName,
      @JsonKey(name: 'role_name') this.roleName,
      @JsonKey(name: 'subscription_plan') this.subscriptionPlan = 'Free',
      @JsonKey(name: 'subscription_status') this.subscriptionStatus = 'active',
      @JsonKey(
          name: 'subscription_expires_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      this.subscriptionExpiresAt})
      : super._();

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String email;
  @override
  @JsonKey(name: 'user_phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  @JsonKey(name: 'bank_name')
  final String? bankName;
  @override
  @JsonKey(name: 'bank_account_number')
  final String? bankAccountNumber;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @override
  @JsonKey(
      name: 'deleted_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? deletedAt;
  @override
  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? updatedAt;
// Additional fields from relationships
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  @JsonKey(name: 'store_name')
  final String? storeName;
  @override
  @JsonKey(name: 'role_name')
  final String? roleName;
// Subscription info (can be extended later)
  @override
  @JsonKey(name: 'subscription_plan')
  final String subscriptionPlan;
  @override
  @JsonKey(name: 'subscription_status')
  final String subscriptionStatus;
  @override
  @JsonKey(
      name: 'subscription_expires_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  final DateTime? subscriptionExpiresAt;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, profileImage: $profileImage, bankName: $bankName, bankAccountNumber: $bankAccountNumber, isDeleted: $isDeleted, deletedAt: $deletedAt, createdAt: $createdAt, updatedAt: $updatedAt, companyName: $companyName, storeName: $storeName, roleName: $roleName, subscriptionPlan: $subscriptionPlan, subscriptionStatus: $subscriptionStatus, subscriptionExpiresAt: $subscriptionExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.bankAccountNumber, bankAccountNumber) ||
                other.bankAccountNumber == bankAccountNumber) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            (identical(other.subscriptionPlan, subscriptionPlan) ||
                other.subscriptionPlan == subscriptionPlan) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.subscriptionExpiresAt, subscriptionExpiresAt) ||
                other.subscriptionExpiresAt == subscriptionExpiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        firstName,
        lastName,
        email,
        phoneNumber,
        dateOfBirth,
        profileImage,
        bankName,
        bankAccountNumber,
        isDeleted,
        deletedAt,
        createdAt,
        updatedAt,
        companyName,
        storeName,
        roleName,
        subscriptionPlan,
        subscriptionStatus,
        subscriptionExpiresAt
      ]);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      required final String email,
      @JsonKey(name: 'user_phone_number') final String? phoneNumber,
      @JsonKey(name: 'date_of_birth') final String? dateOfBirth,
      @JsonKey(name: 'profile_image') final String? profileImage,
      @JsonKey(name: 'bank_name') final String? bankName,
      @JsonKey(name: 'bank_account_number') final String? bankAccountNumber,
      @JsonKey(name: 'is_deleted') final bool isDeleted,
      @JsonKey(
          name: 'deleted_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? deletedAt,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? createdAt,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? updatedAt,
      @JsonKey(name: 'company_name') final String? companyName,
      @JsonKey(name: 'store_name') final String? storeName,
      @JsonKey(name: 'role_name') final String? roleName,
      @JsonKey(name: 'subscription_plan') final String subscriptionPlan,
      @JsonKey(name: 'subscription_status') final String subscriptionStatus,
      @JsonKey(
          name: 'subscription_expires_at',
          fromJson: _dateTimeFromJsonNullable,
          toJson: _dateTimeToJsonNullable)
      final DateTime? subscriptionExpiresAt}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String get email;
  @override
  @JsonKey(name: 'user_phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'date_of_birth')
  String? get dateOfBirth;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  @JsonKey(name: 'bank_name')
  String? get bankName;
  @override
  @JsonKey(name: 'bank_account_number')
  String? get bankAccountNumber;
  @override
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;
  @override
  @JsonKey(
      name: 'deleted_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get deletedAt;
  @override
  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get createdAt;
  @override
  @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get updatedAt; // Additional fields from relationships
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  @JsonKey(name: 'store_name')
  String? get storeName;
  @override
  @JsonKey(name: 'role_name')
  String? get roleName; // Subscription info (can be extended later)
  @override
  @JsonKey(name: 'subscription_plan')
  String get subscriptionPlan;
  @override
  @JsonKey(name: 'subscription_status')
  String get subscriptionStatus;
  @override
  @JsonKey(
      name: 'subscription_expires_at',
      fromJson: _dateTimeFromJsonNullable,
      toJson: _dateTimeToJsonNullable)
  DateTime? get subscriptionExpiresAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
