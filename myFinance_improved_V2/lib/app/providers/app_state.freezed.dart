// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppState {
// User Context
  Map<String, dynamic> get user => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  bool get isAuthenticated =>
      throw _privateConstructorUsedError; // Business Context
  String get companyChoosen => throw _privateConstructorUsedError;
  String get storeChoosen => throw _privateConstructorUsedError;
  String get companyName => throw _privateConstructorUsedError;
  String get storeName =>
      throw _privateConstructorUsedError; // Subscription Context (for currently selected company)
  Map<String, dynamic> get currentSubscription =>
      throw _privateConstructorUsedError;
  String get planType =>
      throw _privateConstructorUsedError; // 'free', 'basic', 'pro'
  int get maxCompanies => throw _privateConstructorUsedError;
  int get maxStores => throw _privateConstructorUsedError;
  int get maxEmployees => throw _privateConstructorUsedError;
  int get aiDailyLimit =>
      throw _privateConstructorUsedError; // Current Usage Counts (for subscription limit checks)
  int get currentCompanyCount => throw _privateConstructorUsedError;
  int get currentStoreCount => throw _privateConstructorUsedError;
  int get currentEmployeeCount => throw _privateConstructorUsedError;
  int get totalStoreCount =>
      throw _privateConstructorUsedError; // 전체 가게 수 (모든 회사)
  int get totalEmployeeCount =>
      throw _privateConstructorUsedError; // 전체 직원 수 (모든 회사)
// Menu & Features Context (from get_categories_with_features RPC)
  List<dynamic> get categoryFeatures =>
      throw _privateConstructorUsedError; // Permission Context
  Set<String> get permissions => throw _privateConstructorUsedError;
  bool get hasAdminPermission =>
      throw _privateConstructorUsedError; // App Configuration Context
  String get themeMode => throw _privateConstructorUsedError;
  String get languageCode => throw _privateConstructorUsedError;
  bool get isOfflineMode =>
      throw _privateConstructorUsedError; // Loading States
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
  @useResult
  $Res call(
      {Map<String, dynamic> user,
      String userId,
      bool isAuthenticated,
      String companyChoosen,
      String storeChoosen,
      String companyName,
      String storeName,
      Map<String, dynamic> currentSubscription,
      String planType,
      int maxCompanies,
      int maxStores,
      int maxEmployees,
      int aiDailyLimit,
      int currentCompanyCount,
      int currentStoreCount,
      int currentEmployeeCount,
      int totalStoreCount,
      int totalEmployeeCount,
      List<dynamic> categoryFeatures,
      Set<String> permissions,
      bool hasAdminPermission,
      String themeMode,
      String languageCode,
      bool isOfflineMode,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? userId = null,
    Object? isAuthenticated = null,
    Object? companyChoosen = null,
    Object? storeChoosen = null,
    Object? companyName = null,
    Object? storeName = null,
    Object? currentSubscription = null,
    Object? planType = null,
    Object? maxCompanies = null,
    Object? maxStores = null,
    Object? maxEmployees = null,
    Object? aiDailyLimit = null,
    Object? currentCompanyCount = null,
    Object? currentStoreCount = null,
    Object? currentEmployeeCount = null,
    Object? totalStoreCount = null,
    Object? totalEmployeeCount = null,
    Object? categoryFeatures = null,
    Object? permissions = null,
    Object? hasAdminPermission = null,
    Object? themeMode = null,
    Object? languageCode = null,
    Object? isOfflineMode = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      companyChoosen: null == companyChoosen
          ? _value.companyChoosen
          : companyChoosen // ignore: cast_nullable_to_non_nullable
              as String,
      storeChoosen: null == storeChoosen
          ? _value.storeChoosen
          : storeChoosen // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      currentSubscription: null == currentSubscription
          ? _value.currentSubscription
          : currentSubscription // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      currentCompanyCount: null == currentCompanyCount
          ? _value.currentCompanyCount
          : currentCompanyCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentStoreCount: null == currentStoreCount
          ? _value.currentStoreCount
          : currentStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentEmployeeCount: null == currentEmployeeCount
          ? _value.currentEmployeeCount
          : currentEmployeeCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalStoreCount: null == totalStoreCount
          ? _value.totalStoreCount
          : totalStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalEmployeeCount: null == totalEmployeeCount
          ? _value.totalEmployeeCount
          : totalEmployeeCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryFeatures: null == categoryFeatures
          ? _value.categoryFeatures
          : categoryFeatures // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hasAdminPermission: null == hasAdminPermission
          ? _value.hasAdminPermission
          : hasAdminPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      isOfflineMode: null == isOfflineMode
          ? _value.isOfflineMode
          : isOfflineMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppStateImplCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$$AppStateImplCopyWith(
          _$AppStateImpl value, $Res Function(_$AppStateImpl) then) =
      __$$AppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> user,
      String userId,
      bool isAuthenticated,
      String companyChoosen,
      String storeChoosen,
      String companyName,
      String storeName,
      Map<String, dynamic> currentSubscription,
      String planType,
      int maxCompanies,
      int maxStores,
      int maxEmployees,
      int aiDailyLimit,
      int currentCompanyCount,
      int currentStoreCount,
      int currentEmployeeCount,
      int totalStoreCount,
      int totalEmployeeCount,
      List<dynamic> categoryFeatures,
      Set<String> permissions,
      bool hasAdminPermission,
      String themeMode,
      String languageCode,
      bool isOfflineMode,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$AppStateImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateImpl>
    implements _$$AppStateImplCopyWith<$Res> {
  __$$AppStateImplCopyWithImpl(
      _$AppStateImpl _value, $Res Function(_$AppStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? userId = null,
    Object? isAuthenticated = null,
    Object? companyChoosen = null,
    Object? storeChoosen = null,
    Object? companyName = null,
    Object? storeName = null,
    Object? currentSubscription = null,
    Object? planType = null,
    Object? maxCompanies = null,
    Object? maxStores = null,
    Object? maxEmployees = null,
    Object? aiDailyLimit = null,
    Object? currentCompanyCount = null,
    Object? currentStoreCount = null,
    Object? currentEmployeeCount = null,
    Object? totalStoreCount = null,
    Object? totalEmployeeCount = null,
    Object? categoryFeatures = null,
    Object? permissions = null,
    Object? hasAdminPermission = null,
    Object? themeMode = null,
    Object? languageCode = null,
    Object? isOfflineMode = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$AppStateImpl(
      user: null == user
          ? _value._user
          : user // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      isAuthenticated: null == isAuthenticated
          ? _value.isAuthenticated
          : isAuthenticated // ignore: cast_nullable_to_non_nullable
              as bool,
      companyChoosen: null == companyChoosen
          ? _value.companyChoosen
          : companyChoosen // ignore: cast_nullable_to_non_nullable
              as String,
      storeChoosen: null == storeChoosen
          ? _value.storeChoosen
          : storeChoosen // ignore: cast_nullable_to_non_nullable
              as String,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      currentSubscription: null == currentSubscription
          ? _value._currentSubscription
          : currentSubscription // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
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
      currentCompanyCount: null == currentCompanyCount
          ? _value.currentCompanyCount
          : currentCompanyCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentStoreCount: null == currentStoreCount
          ? _value.currentStoreCount
          : currentStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentEmployeeCount: null == currentEmployeeCount
          ? _value.currentEmployeeCount
          : currentEmployeeCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalStoreCount: null == totalStoreCount
          ? _value.totalStoreCount
          : totalStoreCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalEmployeeCount: null == totalEmployeeCount
          ? _value.totalEmployeeCount
          : totalEmployeeCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryFeatures: null == categoryFeatures
          ? _value._categoryFeatures
          : categoryFeatures // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hasAdminPermission: null == hasAdminPermission
          ? _value.hasAdminPermission
          : hasAdminPermission // ignore: cast_nullable_to_non_nullable
              as bool,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      isOfflineMode: null == isOfflineMode
          ? _value.isOfflineMode
          : isOfflineMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AppStateImpl implements _AppState {
  const _$AppStateImpl(
      {final Map<String, dynamic> user = const {},
      this.userId = '',
      this.isAuthenticated = false,
      this.companyChoosen = '',
      this.storeChoosen = '',
      this.companyName = '',
      this.storeName = '',
      final Map<String, dynamic> currentSubscription = const {},
      this.planType = 'free',
      this.maxCompanies = 1,
      this.maxStores = 1,
      this.maxEmployees = 5,
      this.aiDailyLimit = 2,
      this.currentCompanyCount = 0,
      this.currentStoreCount = 0,
      this.currentEmployeeCount = 0,
      this.totalStoreCount = 0,
      this.totalEmployeeCount = 0,
      final List<dynamic> categoryFeatures = const [],
      final Set<String> permissions = const {},
      this.hasAdminPermission = false,
      this.themeMode = 'light',
      this.languageCode = 'en',
      this.isOfflineMode = false,
      this.isLoading = false,
      this.error = null})
      : _user = user,
        _currentSubscription = currentSubscription,
        _categoryFeatures = categoryFeatures,
        _permissions = permissions;

// User Context
  final Map<String, dynamic> _user;
// User Context
  @override
  @JsonKey()
  Map<String, dynamic> get user {
    if (_user is EqualUnmodifiableMapView) return _user;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_user);
  }

  @override
  @JsonKey()
  final String userId;
  @override
  @JsonKey()
  final bool isAuthenticated;
// Business Context
  @override
  @JsonKey()
  final String companyChoosen;
  @override
  @JsonKey()
  final String storeChoosen;
  @override
  @JsonKey()
  final String companyName;
  @override
  @JsonKey()
  final String storeName;
// Subscription Context (for currently selected company)
  final Map<String, dynamic> _currentSubscription;
// Subscription Context (for currently selected company)
  @override
  @JsonKey()
  Map<String, dynamic> get currentSubscription {
    if (_currentSubscription is EqualUnmodifiableMapView)
      return _currentSubscription;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_currentSubscription);
  }

  @override
  @JsonKey()
  final String planType;
// 'free', 'basic', 'pro'
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
// Current Usage Counts (for subscription limit checks)
  @override
  @JsonKey()
  final int currentCompanyCount;
  @override
  @JsonKey()
  final int currentStoreCount;
  @override
  @JsonKey()
  final int currentEmployeeCount;
  @override
  @JsonKey()
  final int totalStoreCount;
// 전체 가게 수 (모든 회사)
  @override
  @JsonKey()
  final int totalEmployeeCount;
// 전체 직원 수 (모든 회사)
// Menu & Features Context (from get_categories_with_features RPC)
  final List<dynamic> _categoryFeatures;
// 전체 직원 수 (모든 회사)
// Menu & Features Context (from get_categories_with_features RPC)
  @override
  @JsonKey()
  List<dynamic> get categoryFeatures {
    if (_categoryFeatures is EqualUnmodifiableListView)
      return _categoryFeatures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryFeatures);
  }

// Permission Context
  final Set<String> _permissions;
// Permission Context
  @override
  @JsonKey()
  Set<String> get permissions {
    if (_permissions is EqualUnmodifiableSetView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_permissions);
  }

  @override
  @JsonKey()
  final bool hasAdminPermission;
// App Configuration Context
  @override
  @JsonKey()
  final String themeMode;
  @override
  @JsonKey()
  final String languageCode;
  @override
  @JsonKey()
  final bool isOfflineMode;
// Loading States
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;

  @override
  String toString() {
    return 'AppState(user: $user, userId: $userId, isAuthenticated: $isAuthenticated, companyChoosen: $companyChoosen, storeChoosen: $storeChoosen, companyName: $companyName, storeName: $storeName, currentSubscription: $currentSubscription, planType: $planType, maxCompanies: $maxCompanies, maxStores: $maxStores, maxEmployees: $maxEmployees, aiDailyLimit: $aiDailyLimit, currentCompanyCount: $currentCompanyCount, currentStoreCount: $currentStoreCount, currentEmployeeCount: $currentEmployeeCount, totalStoreCount: $totalStoreCount, totalEmployeeCount: $totalEmployeeCount, categoryFeatures: $categoryFeatures, permissions: $permissions, hasAdminPermission: $hasAdminPermission, themeMode: $themeMode, languageCode: $languageCode, isOfflineMode: $isOfflineMode, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateImpl &&
            const DeepCollectionEquality().equals(other._user, _user) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.companyChoosen, companyChoosen) ||
                other.companyChoosen == companyChoosen) &&
            (identical(other.storeChoosen, storeChoosen) ||
                other.storeChoosen == storeChoosen) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            const DeepCollectionEquality()
                .equals(other._currentSubscription, _currentSubscription) &&
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
            (identical(other.currentCompanyCount, currentCompanyCount) ||
                other.currentCompanyCount == currentCompanyCount) &&
            (identical(other.currentStoreCount, currentStoreCount) ||
                other.currentStoreCount == currentStoreCount) &&
            (identical(other.currentEmployeeCount, currentEmployeeCount) ||
                other.currentEmployeeCount == currentEmployeeCount) &&
            (identical(other.totalStoreCount, totalStoreCount) ||
                other.totalStoreCount == totalStoreCount) &&
            (identical(other.totalEmployeeCount, totalEmployeeCount) ||
                other.totalEmployeeCount == totalEmployeeCount) &&
            const DeepCollectionEquality()
                .equals(other._categoryFeatures, _categoryFeatures) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.hasAdminPermission, hasAdminPermission) ||
                other.hasAdminPermission == hasAdminPermission) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.isOfflineMode, isOfflineMode) ||
                other.isOfflineMode == isOfflineMode) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_user),
        userId,
        isAuthenticated,
        companyChoosen,
        storeChoosen,
        companyName,
        storeName,
        const DeepCollectionEquality().hash(_currentSubscription),
        planType,
        maxCompanies,
        maxStores,
        maxEmployees,
        aiDailyLimit,
        currentCompanyCount,
        currentStoreCount,
        currentEmployeeCount,
        totalStoreCount,
        totalEmployeeCount,
        const DeepCollectionEquality().hash(_categoryFeatures),
        const DeepCollectionEquality().hash(_permissions),
        hasAdminPermission,
        themeMode,
        languageCode,
        isOfflineMode,
        isLoading,
        error
      ]);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      __$$AppStateImplCopyWithImpl<_$AppStateImpl>(this, _$identity);
}

abstract class _AppState implements AppState {
  const factory _AppState(
      {final Map<String, dynamic> user,
      final String userId,
      final bool isAuthenticated,
      final String companyChoosen,
      final String storeChoosen,
      final String companyName,
      final String storeName,
      final Map<String, dynamic> currentSubscription,
      final String planType,
      final int maxCompanies,
      final int maxStores,
      final int maxEmployees,
      final int aiDailyLimit,
      final int currentCompanyCount,
      final int currentStoreCount,
      final int currentEmployeeCount,
      final int totalStoreCount,
      final int totalEmployeeCount,
      final List<dynamic> categoryFeatures,
      final Set<String> permissions,
      final bool hasAdminPermission,
      final String themeMode,
      final String languageCode,
      final bool isOfflineMode,
      final bool isLoading,
      final String? error}) = _$AppStateImpl;

// User Context
  @override
  Map<String, dynamic> get user;
  @override
  String get userId;
  @override
  bool get isAuthenticated; // Business Context
  @override
  String get companyChoosen;
  @override
  String get storeChoosen;
  @override
  String get companyName;
  @override
  String get storeName; // Subscription Context (for currently selected company)
  @override
  Map<String, dynamic> get currentSubscription;
  @override
  String get planType; // 'free', 'basic', 'pro'
  @override
  int get maxCompanies;
  @override
  int get maxStores;
  @override
  int get maxEmployees;
  @override
  int get aiDailyLimit; // Current Usage Counts (for subscription limit checks)
  @override
  int get currentCompanyCount;
  @override
  int get currentStoreCount;
  @override
  int get currentEmployeeCount;
  @override
  int get totalStoreCount; // 전체 가게 수 (모든 회사)
  @override
  int get totalEmployeeCount; // 전체 직원 수 (모든 회사)
// Menu & Features Context (from get_categories_with_features RPC)
  @override
  List<dynamic> get categoryFeatures; // Permission Context
  @override
  Set<String> get permissions;
  @override
  bool get hasAdminPermission; // App Configuration Context
  @override
  String get themeMode;
  @override
  String get languageCode;
  @override
  bool get isOfflineMode; // Loading States
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
