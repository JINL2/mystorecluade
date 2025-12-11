// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_companies_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserCompaniesModel _$UserCompaniesModelFromJson(Map<String, dynamic> json) {
  return _UserCompaniesModel.fromJson(json);
}

/// @nodoc
mixin _$UserCompaniesModel {
  String get userId => throw _privateConstructorUsedError;
  String? get userFirstName => throw _privateConstructorUsedError;
  String? get userLastName => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  int? get companyCount => throw _privateConstructorUsedError;
  List<CompanyModel> get companies => throw _privateConstructorUsedError;

  /// Serializes this UserCompaniesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserCompaniesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCompaniesModelCopyWith<UserCompaniesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCompaniesModelCopyWith<$Res> {
  factory $UserCompaniesModelCopyWith(
          UserCompaniesModel value, $Res Function(UserCompaniesModel) then) =
      _$UserCompaniesModelCopyWithImpl<$Res, UserCompaniesModel>;
  @useResult
  $Res call(
      {String userId,
      String? userFirstName,
      String? userLastName,
      String? profileImage,
      int? companyCount,
      List<CompanyModel> companies});
}

/// @nodoc
class _$UserCompaniesModelCopyWithImpl<$Res, $Val extends UserCompaniesModel>
    implements $UserCompaniesModelCopyWith<$Res> {
  _$UserCompaniesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserCompaniesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userFirstName = freezed,
    Object? userLastName = freezed,
    Object? profileImage = freezed,
    Object? companyCount = freezed,
    Object? companies = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFirstName: freezed == userFirstName
          ? _value.userFirstName
          : userFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      userLastName: freezed == userLastName
          ? _value.userLastName
          : userLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      companyCount: freezed == companyCount
          ? _value.companyCount
          : companyCount // ignore: cast_nullable_to_non_nullable
              as int?,
      companies: null == companies
          ? _value.companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<CompanyModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserCompaniesModelImplCopyWith<$Res>
    implements $UserCompaniesModelCopyWith<$Res> {
  factory _$$UserCompaniesModelImplCopyWith(_$UserCompaniesModelImpl value,
          $Res Function(_$UserCompaniesModelImpl) then) =
      __$$UserCompaniesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? userFirstName,
      String? userLastName,
      String? profileImage,
      int? companyCount,
      List<CompanyModel> companies});
}

/// @nodoc
class __$$UserCompaniesModelImplCopyWithImpl<$Res>
    extends _$UserCompaniesModelCopyWithImpl<$Res, _$UserCompaniesModelImpl>
    implements _$$UserCompaniesModelImplCopyWith<$Res> {
  __$$UserCompaniesModelImplCopyWithImpl(_$UserCompaniesModelImpl _value,
      $Res Function(_$UserCompaniesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserCompaniesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userFirstName = freezed,
    Object? userLastName = freezed,
    Object? profileImage = freezed,
    Object? companyCount = freezed,
    Object? companies = null,
  }) {
    return _then(_$UserCompaniesModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      userFirstName: freezed == userFirstName
          ? _value.userFirstName
          : userFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      userLastName: freezed == userLastName
          ? _value.userLastName
          : userLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      companyCount: freezed == companyCount
          ? _value.companyCount
          : companyCount // ignore: cast_nullable_to_non_nullable
              as int?,
      companies: null == companies
          ? _value._companies
          : companies // ignore: cast_nullable_to_non_nullable
              as List<CompanyModel>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$UserCompaniesModelImpl extends _UserCompaniesModel {
  const _$UserCompaniesModelImpl(
      {required this.userId,
      this.userFirstName,
      this.userLastName,
      this.profileImage,
      this.companyCount,
      required final List<CompanyModel> companies})
      : _companies = companies,
        super._();

  factory _$UserCompaniesModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCompaniesModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String? userFirstName;
  @override
  final String? userLastName;
  @override
  final String? profileImage;
  @override
  final int? companyCount;
  final List<CompanyModel> _companies;
  @override
  List<CompanyModel> get companies {
    if (_companies is EqualUnmodifiableListView) return _companies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_companies);
  }

  @override
  String toString() {
    return 'UserCompaniesModel(userId: $userId, userFirstName: $userFirstName, userLastName: $userLastName, profileImage: $profileImage, companyCount: $companyCount, companies: $companies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCompaniesModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userFirstName, userFirstName) ||
                other.userFirstName == userFirstName) &&
            (identical(other.userLastName, userLastName) ||
                other.userLastName == userLastName) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.companyCount, companyCount) ||
                other.companyCount == companyCount) &&
            const DeepCollectionEquality()
                .equals(other._companies, _companies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      userFirstName,
      userLastName,
      profileImage,
      companyCount,
      const DeepCollectionEquality().hash(_companies));

  /// Create a copy of UserCompaniesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCompaniesModelImplCopyWith<_$UserCompaniesModelImpl> get copyWith =>
      __$$UserCompaniesModelImplCopyWithImpl<_$UserCompaniesModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCompaniesModelImplToJson(
      this,
    );
  }
}

abstract class _UserCompaniesModel extends UserCompaniesModel {
  const factory _UserCompaniesModel(
      {required final String userId,
      final String? userFirstName,
      final String? userLastName,
      final String? profileImage,
      final int? companyCount,
      required final List<CompanyModel> companies}) = _$UserCompaniesModelImpl;
  const _UserCompaniesModel._() : super._();

  factory _UserCompaniesModel.fromJson(Map<String, dynamic> json) =
      _$UserCompaniesModelImpl.fromJson;

  @override
  String get userId;
  @override
  String? get userFirstName;
  @override
  String? get userLastName;
  @override
  String? get profileImage;
  @override
  int? get companyCount;
  @override
  List<CompanyModel> get companies;

  /// Create a copy of UserCompaniesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserCompaniesModelImplCopyWith<_$UserCompaniesModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) {
  return _CompanyModel.fromJson(json);
}

/// @nodoc
mixin _$CompanyModel {
  String get companyId => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String? get companyCode => throw _privateConstructorUsedError;
  int? get storeCount => throw _privateConstructorUsedError;
  RoleModel? get role =>
      throw _privateConstructorUsedError; // ✅ Make nullable - some companies may not have role data
  List<StoreModel> get stores =>
      throw _privateConstructorUsedError; // ✅ Provide default empty list
  SubscriptionModel? get subscription => throw _privateConstructorUsedError;

  /// Serializes this CompanyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompanyModelCopyWith<CompanyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanyModelCopyWith<$Res> {
  factory $CompanyModelCopyWith(
          CompanyModel value, $Res Function(CompanyModel) then) =
      _$CompanyModelCopyWithImpl<$Res, CompanyModel>;
  @useResult
  $Res call(
      {String companyId,
      String companyName,
      String? companyCode,
      int? storeCount,
      RoleModel? role,
      List<StoreModel> stores,
      SubscriptionModel? subscription});

  $RoleModelCopyWith<$Res>? get role;
  $SubscriptionModelCopyWith<$Res>? get subscription;
}

/// @nodoc
class _$CompanyModelCopyWithImpl<$Res, $Val extends CompanyModel>
    implements $CompanyModelCopyWith<$Res> {
  _$CompanyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCode = freezed,
    Object? storeCount = freezed,
    Object? role = freezed,
    Object? stores = null,
    Object? subscription = freezed,
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
      storeCount: freezed == storeCount
          ? _value.storeCount
          : storeCount // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleModel?,
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StoreModel>,
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionModel?,
    ) as $Val);
  }

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoleModelCopyWith<$Res>? get role {
    if (_value.role == null) {
      return null;
    }

    return $RoleModelCopyWith<$Res>(_value.role!, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionModelCopyWith<$Res>? get subscription {
    if (_value.subscription == null) {
      return null;
    }

    return $SubscriptionModelCopyWith<$Res>(_value.subscription!, (value) {
      return _then(_value.copyWith(subscription: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompanyModelImplCopyWith<$Res>
    implements $CompanyModelCopyWith<$Res> {
  factory _$$CompanyModelImplCopyWith(
          _$CompanyModelImpl value, $Res Function(_$CompanyModelImpl) then) =
      __$$CompanyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String companyId,
      String companyName,
      String? companyCode,
      int? storeCount,
      RoleModel? role,
      List<StoreModel> stores,
      SubscriptionModel? subscription});

  @override
  $RoleModelCopyWith<$Res>? get role;
  @override
  $SubscriptionModelCopyWith<$Res>? get subscription;
}

/// @nodoc
class __$$CompanyModelImplCopyWithImpl<$Res>
    extends _$CompanyModelCopyWithImpl<$Res, _$CompanyModelImpl>
    implements _$$CompanyModelImplCopyWith<$Res> {
  __$$CompanyModelImplCopyWithImpl(
      _$CompanyModelImpl _value, $Res Function(_$CompanyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyId = null,
    Object? companyName = null,
    Object? companyCode = freezed,
    Object? storeCount = freezed,
    Object? role = freezed,
    Object? stores = null,
    Object? subscription = freezed,
  }) {
    return _then(_$CompanyModelImpl(
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
      storeCount: freezed == storeCount
          ? _value.storeCount
          : storeCount // ignore: cast_nullable_to_non_nullable
              as int?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as RoleModel?,
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<StoreModel>,
      subscription: freezed == subscription
          ? _value.subscription
          : subscription // ignore: cast_nullable_to_non_nullable
              as SubscriptionModel?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$CompanyModelImpl extends _CompanyModel {
  const _$CompanyModelImpl(
      {required this.companyId,
      required this.companyName,
      this.companyCode,
      this.storeCount,
      this.role,
      final List<StoreModel> stores = const [],
      this.subscription})
      : _stores = stores,
        super._();

  factory _$CompanyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompanyModelImplFromJson(json);

  @override
  final String companyId;
  @override
  final String companyName;
  @override
  final String? companyCode;
  @override
  final int? storeCount;
  @override
  final RoleModel? role;
// ✅ Make nullable - some companies may not have role data
  final List<StoreModel> _stores;
// ✅ Make nullable - some companies may not have role data
  @override
  @JsonKey()
  List<StoreModel> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

// ✅ Provide default empty list
  @override
  final SubscriptionModel? subscription;

  @override
  String toString() {
    return 'CompanyModel(companyId: $companyId, companyName: $companyName, companyCode: $companyCode, storeCount: $storeCount, role: $role, stores: $stores, subscription: $subscription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanyModelImpl &&
            (identical(other.companyId, companyId) ||
                other.companyId == companyId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.companyCode, companyCode) ||
                other.companyCode == companyCode) &&
            (identical(other.storeCount, storeCount) ||
                other.storeCount == storeCount) &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyId,
      companyName,
      companyCode,
      storeCount,
      role,
      const DeepCollectionEquality().hash(_stores),
      subscription);

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      __$$CompanyModelImplCopyWithImpl<_$CompanyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompanyModelImplToJson(
      this,
    );
  }
}

abstract class _CompanyModel extends CompanyModel {
  const factory _CompanyModel(
      {required final String companyId,
      required final String companyName,
      final String? companyCode,
      final int? storeCount,
      final RoleModel? role,
      final List<StoreModel> stores,
      final SubscriptionModel? subscription}) = _$CompanyModelImpl;
  const _CompanyModel._() : super._();

  factory _CompanyModel.fromJson(Map<String, dynamic> json) =
      _$CompanyModelImpl.fromJson;

  @override
  String get companyId;
  @override
  String get companyName;
  @override
  String? get companyCode;
  @override
  int? get storeCount;
  @override
  RoleModel?
      get role; // ✅ Make nullable - some companies may not have role data
  @override
  List<StoreModel> get stores; // ✅ Provide default empty list
  @override
  SubscriptionModel? get subscription;

  /// Create a copy of CompanyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompanyModelImplCopyWith<_$CompanyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) {
  return _StoreModel.fromJson(json);
}

/// @nodoc
mixin _$StoreModel {
  String get storeId => throw _privateConstructorUsedError;
  String get storeName => throw _privateConstructorUsedError;
  String? get storeCode => throw _privateConstructorUsedError;
  String? get storePhone => throw _privateConstructorUsedError;

  /// Serializes this StoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoreModelCopyWith<StoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoreModelCopyWith<$Res> {
  factory $StoreModelCopyWith(
          StoreModel value, $Res Function(StoreModel) then) =
      _$StoreModelCopyWithImpl<$Res, StoreModel>;
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      String? storeCode,
      String? storePhone});
}

/// @nodoc
class _$StoreModelCopyWithImpl<$Res, $Val extends StoreModel>
    implements $StoreModelCopyWith<$Res> {
  _$StoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
    Object? storePhone = freezed,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StoreModelImplCopyWith<$Res>
    implements $StoreModelCopyWith<$Res> {
  factory _$$StoreModelImplCopyWith(
          _$StoreModelImpl value, $Res Function(_$StoreModelImpl) then) =
      __$$StoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String storeId,
      String storeName,
      String? storeCode,
      String? storePhone});
}

/// @nodoc
class __$$StoreModelImplCopyWithImpl<$Res>
    extends _$StoreModelCopyWithImpl<$Res, _$StoreModelImpl>
    implements _$$StoreModelImplCopyWith<$Res> {
  __$$StoreModelImplCopyWithImpl(
      _$StoreModelImpl _value, $Res Function(_$StoreModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? storeName = null,
    Object? storeCode = freezed,
    Object? storePhone = freezed,
  }) {
    return _then(_$StoreModelImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      storeCode: freezed == storeCode
          ? _value.storeCode
          : storeCode // ignore: cast_nullable_to_non_nullable
              as String?,
      storePhone: freezed == storePhone
          ? _value.storePhone
          : storePhone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$StoreModelImpl extends _StoreModel {
  const _$StoreModelImpl(
      {required this.storeId,
      required this.storeName,
      this.storeCode,
      this.storePhone})
      : super._();

  factory _$StoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoreModelImplFromJson(json);

  @override
  final String storeId;
  @override
  final String storeName;
  @override
  final String? storeCode;
  @override
  final String? storePhone;

  @override
  String toString() {
    return 'StoreModel(storeId: $storeId, storeName: $storeName, storeCode: $storeCode, storePhone: $storePhone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoreModelImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.storeCode, storeCode) ||
                other.storeCode == storeCode) &&
            (identical(other.storePhone, storePhone) ||
                other.storePhone == storePhone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, storeId, storeName, storeCode, storePhone);

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoreModelImplCopyWith<_$StoreModelImpl> get copyWith =>
      __$$StoreModelImplCopyWithImpl<_$StoreModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoreModelImplToJson(
      this,
    );
  }
}

abstract class _StoreModel extends StoreModel {
  const factory _StoreModel(
      {required final String storeId,
      required final String storeName,
      final String? storeCode,
      final String? storePhone}) = _$StoreModelImpl;
  const _StoreModel._() : super._();

  factory _StoreModel.fromJson(Map<String, dynamic> json) =
      _$StoreModelImpl.fromJson;

  @override
  String get storeId;
  @override
  String get storeName;
  @override
  String? get storeCode;
  @override
  String? get storePhone;

  /// Create a copy of StoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoreModelImplCopyWith<_$StoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoleModel _$RoleModelFromJson(Map<String, dynamic> json) {
  return _RoleModel.fromJson(json);
}

/// @nodoc
mixin _$RoleModel {
  String? get roleId => throw _privateConstructorUsedError;
  String get roleName => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;

  /// Serializes this RoleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoleModelCopyWith<RoleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleModelCopyWith<$Res> {
  factory $RoleModelCopyWith(RoleModel value, $Res Function(RoleModel) then) =
      _$RoleModelCopyWithImpl<$Res, RoleModel>;
  @useResult
  $Res call({String? roleId, String roleName, List<String> permissions});
}

/// @nodoc
class _$RoleModelCopyWithImpl<$Res, $Val extends RoleModel>
    implements $RoleModelCopyWith<$Res> {
  _$RoleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = freezed,
    Object? roleName = null,
    Object? permissions = null,
  }) {
    return _then(_value.copyWith(
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleModelImplCopyWith<$Res>
    implements $RoleModelCopyWith<$Res> {
  factory _$$RoleModelImplCopyWith(
          _$RoleModelImpl value, $Res Function(_$RoleModelImpl) then) =
      __$$RoleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? roleId, String roleName, List<String> permissions});
}

/// @nodoc
class __$$RoleModelImplCopyWithImpl<$Res>
    extends _$RoleModelCopyWithImpl<$Res, _$RoleModelImpl>
    implements _$$RoleModelImplCopyWith<$Res> {
  __$$RoleModelImplCopyWithImpl(
      _$RoleModelImpl _value, $Res Function(_$RoleModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roleId = freezed,
    Object? roleName = null,
    Object? permissions = null,
  }) {
    return _then(_$RoleModelImpl(
      roleId: freezed == roleId
          ? _value.roleId
          : roleId // ignore: cast_nullable_to_non_nullable
              as String?,
      roleName: null == roleName
          ? _value.roleName
          : roleName // ignore: cast_nullable_to_non_nullable
              as String,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RoleModelImpl extends _RoleModel {
  const _$RoleModelImpl(
      {this.roleId,
      required this.roleName,
      required final List<String> permissions})
      : _permissions = permissions,
        super._();

  factory _$RoleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleModelImplFromJson(json);

  @override
  final String? roleId;
  @override
  final String roleName;
  final List<String> _permissions;
  @override
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  String toString() {
    return 'RoleModel(roleId: $roleId, roleName: $roleName, permissions: $permissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleModelImpl &&
            (identical(other.roleId, roleId) || other.roleId == roleId) &&
            (identical(other.roleName, roleName) ||
                other.roleName == roleName) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roleId, roleName,
      const DeepCollectionEquality().hash(_permissions));

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      __$$RoleModelImplCopyWithImpl<_$RoleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleModelImplToJson(
      this,
    );
  }
}

abstract class _RoleModel extends RoleModel {
  const factory _RoleModel(
      {final String? roleId,
      required final String roleName,
      required final List<String> permissions}) = _$RoleModelImpl;
  const _RoleModel._() : super._();

  factory _RoleModel.fromJson(Map<String, dynamic> json) =
      _$RoleModelImpl.fromJson;

  @override
  String? get roleId;
  @override
  String get roleName;
  @override
  List<String> get permissions;

  /// Create a copy of RoleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoleModelImplCopyWith<_$RoleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) {
  return _SubscriptionModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionModel {
  String get planId => throw _privateConstructorUsedError;
  String get planName => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String get planType => throw _privateConstructorUsedError;
  int get maxCompanies => throw _privateConstructorUsedError;
  int get maxStores => throw _privateConstructorUsedError;
  int get maxEmployees => throw _privateConstructorUsedError;
  int get aiDailyLimit => throw _privateConstructorUsedError;
  double get priceMonthly => throw _privateConstructorUsedError;
  List<String> get features => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionModelCopyWith<SubscriptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionModelCopyWith<$Res> {
  factory $SubscriptionModelCopyWith(
          SubscriptionModel value, $Res Function(SubscriptionModel) then) =
      _$SubscriptionModelCopyWithImpl<$Res, SubscriptionModel>;
  @useResult
  $Res call(
      {String planId,
      String planName,
      String? displayName,
      String planType,
      int maxCompanies,
      int maxStores,
      int maxEmployees,
      int aiDailyLimit,
      double priceMonthly,
      List<String> features});
}

/// @nodoc
class _$SubscriptionModelCopyWithImpl<$Res, $Val extends SubscriptionModel>
    implements $SubscriptionModelCopyWith<$Res> {
  _$SubscriptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? planName = null,
    Object? displayName = freezed,
    Object? planType = null,
    Object? maxCompanies = null,
    Object? maxStores = null,
    Object? maxEmployees = null,
    Object? aiDailyLimit = null,
    Object? priceMonthly = null,
    Object? features = null,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      maxCompanies: null == maxCompanies
          ? _value.maxCompanies
          : maxCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      maxStores: null == maxStores
          ? _value.maxStores
          : maxStores // ignore: cast_nullable_to_non_nullable
              as int,
      maxEmployees: null == maxEmployees
          ? _value.maxEmployees
          : maxEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      aiDailyLimit: null == aiDailyLimit
          ? _value.aiDailyLimit
          : aiDailyLimit // ignore: cast_nullable_to_non_nullable
              as int,
      priceMonthly: null == priceMonthly
          ? _value.priceMonthly
          : priceMonthly // ignore: cast_nullable_to_non_nullable
              as double,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionModelImplCopyWith<$Res>
    implements $SubscriptionModelCopyWith<$Res> {
  factory _$$SubscriptionModelImplCopyWith(_$SubscriptionModelImpl value,
          $Res Function(_$SubscriptionModelImpl) then) =
      __$$SubscriptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String planId,
      String planName,
      String? displayName,
      String planType,
      int maxCompanies,
      int maxStores,
      int maxEmployees,
      int aiDailyLimit,
      double priceMonthly,
      List<String> features});
}

/// @nodoc
class __$$SubscriptionModelImplCopyWithImpl<$Res>
    extends _$SubscriptionModelCopyWithImpl<$Res, _$SubscriptionModelImpl>
    implements _$$SubscriptionModelImplCopyWith<$Res> {
  __$$SubscriptionModelImplCopyWithImpl(_$SubscriptionModelImpl _value,
      $Res Function(_$SubscriptionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? planName = null,
    Object? displayName = freezed,
    Object? planType = null,
    Object? maxCompanies = null,
    Object? maxStores = null,
    Object? maxEmployees = null,
    Object? aiDailyLimit = null,
    Object? priceMonthly = null,
    Object? features = null,
  }) {
    return _then(_$SubscriptionModelImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      maxCompanies: null == maxCompanies
          ? _value.maxCompanies
          : maxCompanies // ignore: cast_nullable_to_non_nullable
              as int,
      maxStores: null == maxStores
          ? _value.maxStores
          : maxStores // ignore: cast_nullable_to_non_nullable
              as int,
      maxEmployees: null == maxEmployees
          ? _value.maxEmployees
          : maxEmployees // ignore: cast_nullable_to_non_nullable
              as int,
      aiDailyLimit: null == aiDailyLimit
          ? _value.aiDailyLimit
          : aiDailyLimit // ignore: cast_nullable_to_non_nullable
              as int,
      priceMonthly: null == priceMonthly
          ? _value.priceMonthly
          : priceMonthly // ignore: cast_nullable_to_non_nullable
              as double,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SubscriptionModelImpl extends _SubscriptionModel {
  const _$SubscriptionModelImpl(
      {required this.planId,
      required this.planName,
      this.displayName,
      required this.planType,
      this.maxCompanies = 1,
      this.maxStores = 1,
      this.maxEmployees = 5,
      this.aiDailyLimit = 2,
      this.priceMonthly = 0,
      final List<String> features = const []})
      : _features = features,
        super._();

  factory _$SubscriptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionModelImplFromJson(json);

  @override
  final String planId;
  @override
  final String planName;
  @override
  final String? displayName;
  @override
  final String planType;
  @override
  @JsonKey()
  final int maxCompanies;
  @override
  @JsonKey()
  final int maxStores;
  @override
  @JsonKey()
  final int maxEmployees;
  @override
  @JsonKey()
  final int aiDailyLimit;
  @override
  @JsonKey()
  final double priceMonthly;
  final List<String> _features;
  @override
  @JsonKey()
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  @override
  String toString() {
    return 'SubscriptionModel(planId: $planId, planName: $planName, displayName: $displayName, planType: $planType, maxCompanies: $maxCompanies, maxStores: $maxStores, maxEmployees: $maxEmployees, aiDailyLimit: $aiDailyLimit, priceMonthly: $priceMonthly, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionModelImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.maxCompanies, maxCompanies) ||
                other.maxCompanies == maxCompanies) &&
            (identical(other.maxStores, maxStores) ||
                other.maxStores == maxStores) &&
            (identical(other.maxEmployees, maxEmployees) ||
                other.maxEmployees == maxEmployees) &&
            (identical(other.aiDailyLimit, aiDailyLimit) ||
                other.aiDailyLimit == aiDailyLimit) &&
            (identical(other.priceMonthly, priceMonthly) ||
                other.priceMonthly == priceMonthly) &&
            const DeepCollectionEquality().equals(other._features, _features));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      planId,
      planName,
      displayName,
      planType,
      maxCompanies,
      maxStores,
      maxEmployees,
      aiDailyLimit,
      priceMonthly,
      const DeepCollectionEquality().hash(_features));

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      __$$SubscriptionModelImplCopyWithImpl<_$SubscriptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionModelImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionModel extends SubscriptionModel {
  const factory _SubscriptionModel(
      {required final String planId,
      required final String planName,
      final String? displayName,
      required final String planType,
      final int maxCompanies,
      final int maxStores,
      final int maxEmployees,
      final int aiDailyLimit,
      final double priceMonthly,
      final List<String> features}) = _$SubscriptionModelImpl;
  const _SubscriptionModel._() : super._();

  factory _SubscriptionModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionModelImpl.fromJson;

  @override
  String get planId;
  @override
  String get planName;
  @override
  String? get displayName;
  @override
  String get planType;
  @override
  int get maxCompanies;
  @override
  int get maxStores;
  @override
  int get maxEmployees;
  @override
  int get aiDailyLimit;
  @override
  double get priceMonthly;
  @override
  List<String> get features;

  /// Create a copy of SubscriptionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionModelImplCopyWith<_$SubscriptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
