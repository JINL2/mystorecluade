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

/// @nodoc
mixin _$UserProfile {
  String get userId => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  String? get dateOfBirth => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String? get bankName => throw _privateConstructorUsedError;
  String? get bankAccountNumber => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Additional fields from relationships
  String? get companyName => throw _privateConstructorUsedError;
  String? get storeName => throw _privateConstructorUsedError;
  String? get roleName =>
      throw _privateConstructorUsedError; // Subscription info
  String get subscriptionPlan => throw _privateConstructorUsedError;
  String get subscriptionStatus => throw _privateConstructorUsedError;
  DateTime? get subscriptionExpiresAt => throw _privateConstructorUsedError;

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
      {String userId,
      String? firstName,
      String? lastName,
      String email,
      String? phoneNumber,
      String? dateOfBirth,
      String? profileImage,
      String? bankName,
      String? bankAccountNumber,
      bool isDeleted,
      DateTime? deletedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? companyName,
      String? storeName,
      String? roleName,
      String subscriptionPlan,
      String subscriptionStatus,
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
      {String userId,
      String? firstName,
      String? lastName,
      String email,
      String? phoneNumber,
      String? dateOfBirth,
      String? profileImage,
      String? bankName,
      String? bankAccountNumber,
      bool isDeleted,
      DateTime? deletedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? companyName,
      String? storeName,
      String? roleName,
      String subscriptionPlan,
      String subscriptionStatus,
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

class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      this.firstName,
      this.lastName,
      required this.email,
      this.phoneNumber,
      this.dateOfBirth,
      this.profileImage,
      this.bankName,
      this.bankAccountNumber,
      this.isDeleted = false,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.companyName,
      this.storeName,
      this.roleName,
      this.subscriptionPlan = 'Free',
      this.subscriptionStatus = 'active',
      this.subscriptionExpiresAt})
      : super._();

  @override
  final String userId;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  final String? dateOfBirth;
  @override
  final String? profileImage;
  @override
  final String? bankName;
  @override
  final String? bankAccountNumber;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Additional fields from relationships
  @override
  final String? companyName;
  @override
  final String? storeName;
  @override
  final String? roleName;
// Subscription info
  @override
  @JsonKey()
  final String subscriptionPlan;
  @override
  @JsonKey()
  final String subscriptionStatus;
  @override
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
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String userId,
      final String? firstName,
      final String? lastName,
      required final String email,
      final String? phoneNumber,
      final String? dateOfBirth,
      final String? profileImage,
      final String? bankName,
      final String? bankAccountNumber,
      final bool isDeleted,
      final DateTime? deletedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? companyName,
      final String? storeName,
      final String? roleName,
      final String subscriptionPlan,
      final String subscriptionStatus,
      final DateTime? subscriptionExpiresAt}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  @override
  String get userId;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String get email;
  @override
  String? get phoneNumber;
  @override
  String? get dateOfBirth;
  @override
  String? get profileImage;
  @override
  String? get bankName;
  @override
  String? get bankAccountNumber;
  @override
  bool get isDeleted;
  @override
  DateTime? get deletedAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Additional fields from relationships
  @override
  String? get companyName;
  @override
  String? get storeName;
  @override
  String? get roleName; // Subscription info
  @override
  String get subscriptionPlan;
  @override
  String get subscriptionStatus;
  @override
  DateTime? get subscriptionExpiresAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
