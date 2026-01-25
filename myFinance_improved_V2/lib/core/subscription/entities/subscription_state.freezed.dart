// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubscriptionState _$SubscriptionStateFromJson(Map<String, dynamic> json) {
  return _SubscriptionState.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionState {
  /// User ID this subscription belongs to
  String get userId => throw _privateConstructorUsedError;

  /// Plan identifier from subscription_plans table
  String get planId => throw _privateConstructorUsedError;

  /// Plan name: 'free', 'basic', 'pro'
  String get planName => throw _privateConstructorUsedError;

  /// Display name for UI: 'Free', 'Basic', 'Pro'
  String get displayName => throw _privateConstructorUsedError;

  /// Plan type: 'free' or 'paid' (billing category)
  String get planType => throw _privateConstructorUsedError;

  /// Subscription status: 'active', 'canceled', 'expired', 'trial', 'grace_period'
  String get status => throw _privateConstructorUsedError;

  /// Maximum companies allowed (null = unlimited)
  int? get maxCompanies => throw _privateConstructorUsedError;

  /// Maximum stores allowed (null = unlimited)
  int? get maxStores => throw _privateConstructorUsedError;

  /// Maximum employees allowed (null = unlimited)
  int? get maxEmployees => throw _privateConstructorUsedError;

  /// AI requests daily limit (null = unlimited)
  int? get aiDailyLimit => throw _privateConstructorUsedError;

  /// Monthly price for display
  double get priceMonthly => throw _privateConstructorUsedError;

  /// List of enabled features
  List<String> get features => throw _privateConstructorUsedError;

  /// When subscription was last synced from server
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Current sync status
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// RevenueCat customer ID (if available)
  String? get revenueCatCustomerId => throw _privateConstructorUsedError;

  /// Trial end date (if on trial)
  DateTime? get trialEndsAt => throw _privateConstructorUsedError;

  /// Current period end date (for paid subscriptions)
  DateTime? get currentPeriodEndsAt => throw _privateConstructorUsedError;

  /// Error message (if syncStatus is error)
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionStateCopyWith<SubscriptionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionStateCopyWith<$Res> {
  factory $SubscriptionStateCopyWith(
          SubscriptionState value, $Res Function(SubscriptionState) then) =
      _$SubscriptionStateCopyWithImpl<$Res, SubscriptionState>;
  @useResult
  $Res call(
      {String userId,
      String planId,
      String planName,
      String displayName,
      String planType,
      String status,
      int? maxCompanies,
      int? maxStores,
      int? maxEmployees,
      int? aiDailyLimit,
      double priceMonthly,
      List<String> features,
      DateTime? lastSyncedAt,
      SyncStatus syncStatus,
      String? revenueCatCustomerId,
      DateTime? trialEndsAt,
      DateTime? currentPeriodEndsAt,
      String? errorMessage});
}

/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res, $Val extends SubscriptionState>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? planId = null,
    Object? planName = null,
    Object? displayName = null,
    Object? planType = null,
    Object? status = null,
    Object? maxCompanies = freezed,
    Object? maxStores = freezed,
    Object? maxEmployees = freezed,
    Object? aiDailyLimit = freezed,
    Object? priceMonthly = null,
    Object? features = null,
    Object? lastSyncedAt = freezed,
    Object? syncStatus = null,
    Object? revenueCatCustomerId = freezed,
    Object? trialEndsAt = freezed,
    Object? currentPeriodEndsAt = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      maxCompanies: freezed == maxCompanies
          ? _value.maxCompanies
          : maxCompanies // ignore: cast_nullable_to_non_nullable
              as int?,
      maxStores: freezed == maxStores
          ? _value.maxStores
          : maxStores // ignore: cast_nullable_to_non_nullable
              as int?,
      maxEmployees: freezed == maxEmployees
          ? _value.maxEmployees
          : maxEmployees // ignore: cast_nullable_to_non_nullable
              as int?,
      aiDailyLimit: freezed == aiDailyLimit
          ? _value.aiDailyLimit
          : aiDailyLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      priceMonthly: null == priceMonthly
          ? _value.priceMonthly
          : priceMonthly // ignore: cast_nullable_to_non_nullable
              as double,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      revenueCatCustomerId: freezed == revenueCatCustomerId
          ? _value.revenueCatCustomerId
          : revenueCatCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      trialEndsAt: freezed == trialEndsAt
          ? _value.trialEndsAt
          : trialEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPeriodEndsAt: freezed == currentPeriodEndsAt
          ? _value.currentPeriodEndsAt
          : currentPeriodEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionStateImplCopyWith<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  factory _$$SubscriptionStateImplCopyWith(_$SubscriptionStateImpl value,
          $Res Function(_$SubscriptionStateImpl) then) =
      __$$SubscriptionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String planId,
      String planName,
      String displayName,
      String planType,
      String status,
      int? maxCompanies,
      int? maxStores,
      int? maxEmployees,
      int? aiDailyLimit,
      double priceMonthly,
      List<String> features,
      DateTime? lastSyncedAt,
      SyncStatus syncStatus,
      String? revenueCatCustomerId,
      DateTime? trialEndsAt,
      DateTime? currentPeriodEndsAt,
      String? errorMessage});
}

/// @nodoc
class __$$SubscriptionStateImplCopyWithImpl<$Res>
    extends _$SubscriptionStateCopyWithImpl<$Res, _$SubscriptionStateImpl>
    implements _$$SubscriptionStateImplCopyWith<$Res> {
  __$$SubscriptionStateImplCopyWithImpl(_$SubscriptionStateImpl _value,
      $Res Function(_$SubscriptionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? planId = null,
    Object? planName = null,
    Object? displayName = null,
    Object? planType = null,
    Object? status = null,
    Object? maxCompanies = freezed,
    Object? maxStores = freezed,
    Object? maxEmployees = freezed,
    Object? aiDailyLimit = freezed,
    Object? priceMonthly = null,
    Object? features = null,
    Object? lastSyncedAt = freezed,
    Object? syncStatus = null,
    Object? revenueCatCustomerId = freezed,
    Object? trialEndsAt = freezed,
    Object? currentPeriodEndsAt = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SubscriptionStateImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      planName: null == planName
          ? _value.planName
          : planName // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      maxCompanies: freezed == maxCompanies
          ? _value.maxCompanies
          : maxCompanies // ignore: cast_nullable_to_non_nullable
              as int?,
      maxStores: freezed == maxStores
          ? _value.maxStores
          : maxStores // ignore: cast_nullable_to_non_nullable
              as int?,
      maxEmployees: freezed == maxEmployees
          ? _value.maxEmployees
          : maxEmployees // ignore: cast_nullable_to_non_nullable
              as int?,
      aiDailyLimit: freezed == aiDailyLimit
          ? _value.aiDailyLimit
          : aiDailyLimit // ignore: cast_nullable_to_non_nullable
              as int?,
      priceMonthly: null == priceMonthly
          ? _value.priceMonthly
          : priceMonthly // ignore: cast_nullable_to_non_nullable
              as double,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      revenueCatCustomerId: freezed == revenueCatCustomerId
          ? _value.revenueCatCustomerId
          : revenueCatCustomerId // ignore: cast_nullable_to_non_nullable
              as String?,
      trialEndsAt: freezed == trialEndsAt
          ? _value.trialEndsAt
          : trialEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPeriodEndsAt: freezed == currentPeriodEndsAt
          ? _value.currentPeriodEndsAt
          : currentPeriodEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SubscriptionStateImpl extends _SubscriptionState {
  const _$SubscriptionStateImpl(
      {required this.userId,
      this.planId = '',
      this.planName = 'free',
      this.displayName = 'Free',
      this.planType = 'free',
      this.status = 'active',
      this.maxCompanies,
      this.maxStores,
      this.maxEmployees,
      this.aiDailyLimit,
      this.priceMonthly = 0.0,
      final List<String> features = const [],
      this.lastSyncedAt,
      this.syncStatus = SyncStatus.unknown,
      this.revenueCatCustomerId,
      this.trialEndsAt,
      this.currentPeriodEndsAt,
      this.errorMessage})
      : _features = features,
        super._();

  factory _$SubscriptionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionStateImplFromJson(json);

  /// User ID this subscription belongs to
  @override
  final String userId;

  /// Plan identifier from subscription_plans table
  @override
  @JsonKey()
  final String planId;

  /// Plan name: 'free', 'basic', 'pro'
  @override
  @JsonKey()
  final String planName;

  /// Display name for UI: 'Free', 'Basic', 'Pro'
  @override
  @JsonKey()
  final String displayName;

  /// Plan type: 'free' or 'paid' (billing category)
  @override
  @JsonKey()
  final String planType;

  /// Subscription status: 'active', 'canceled', 'expired', 'trial', 'grace_period'
  @override
  @JsonKey()
  final String status;

  /// Maximum companies allowed (null = unlimited)
  @override
  final int? maxCompanies;

  /// Maximum stores allowed (null = unlimited)
  @override
  final int? maxStores;

  /// Maximum employees allowed (null = unlimited)
  @override
  final int? maxEmployees;

  /// AI requests daily limit (null = unlimited)
  @override
  final int? aiDailyLimit;

  /// Monthly price for display
  @override
  @JsonKey()
  final double priceMonthly;

  /// List of enabled features
  final List<String> _features;

  /// List of enabled features
  @override
  @JsonKey()
  List<String> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  /// When subscription was last synced from server
  @override
  final DateTime? lastSyncedAt;

  /// Current sync status
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  /// RevenueCat customer ID (if available)
  @override
  final String? revenueCatCustomerId;

  /// Trial end date (if on trial)
  @override
  final DateTime? trialEndsAt;

  /// Current period end date (for paid subscriptions)
  @override
  final DateTime? currentPeriodEndsAt;

  /// Error message (if syncStatus is error)
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SubscriptionState(userId: $userId, planId: $planId, planName: $planName, displayName: $displayName, planType: $planType, status: $status, maxCompanies: $maxCompanies, maxStores: $maxStores, maxEmployees: $maxEmployees, aiDailyLimit: $aiDailyLimit, priceMonthly: $priceMonthly, features: $features, lastSyncedAt: $lastSyncedAt, syncStatus: $syncStatus, revenueCatCustomerId: $revenueCatCustomerId, trialEndsAt: $trialEndsAt, currentPeriodEndsAt: $currentPeriodEndsAt, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionStateImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.planName, planName) ||
                other.planName == planName) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.status, status) || other.status == status) &&
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
            const DeepCollectionEquality().equals(other._features, _features) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.revenueCatCustomerId, revenueCatCustomerId) ||
                other.revenueCatCustomerId == revenueCatCustomerId) &&
            (identical(other.trialEndsAt, trialEndsAt) ||
                other.trialEndsAt == trialEndsAt) &&
            (identical(other.currentPeriodEndsAt, currentPeriodEndsAt) ||
                other.currentPeriodEndsAt == currentPeriodEndsAt) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      planId,
      planName,
      displayName,
      planType,
      status,
      maxCompanies,
      maxStores,
      maxEmployees,
      aiDailyLimit,
      priceMonthly,
      const DeepCollectionEquality().hash(_features),
      lastSyncedAt,
      syncStatus,
      revenueCatCustomerId,
      trialEndsAt,
      currentPeriodEndsAt,
      errorMessage);

  /// Create a copy of SubscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionStateImplCopyWith<_$SubscriptionStateImpl> get copyWith =>
      __$$SubscriptionStateImplCopyWithImpl<_$SubscriptionStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionStateImplToJson(
      this,
    );
  }
}

abstract class _SubscriptionState extends SubscriptionState {
  const factory _SubscriptionState(
      {required final String userId,
      final String planId,
      final String planName,
      final String displayName,
      final String planType,
      final String status,
      final int? maxCompanies,
      final int? maxStores,
      final int? maxEmployees,
      final int? aiDailyLimit,
      final double priceMonthly,
      final List<String> features,
      final DateTime? lastSyncedAt,
      final SyncStatus syncStatus,
      final String? revenueCatCustomerId,
      final DateTime? trialEndsAt,
      final DateTime? currentPeriodEndsAt,
      final String? errorMessage}) = _$SubscriptionStateImpl;
  const _SubscriptionState._() : super._();

  factory _SubscriptionState.fromJson(Map<String, dynamic> json) =
      _$SubscriptionStateImpl.fromJson;

  /// User ID this subscription belongs to
  @override
  String get userId;

  /// Plan identifier from subscription_plans table
  @override
  String get planId;

  /// Plan name: 'free', 'basic', 'pro'
  @override
  String get planName;

  /// Display name for UI: 'Free', 'Basic', 'Pro'
  @override
  String get displayName;

  /// Plan type: 'free' or 'paid' (billing category)
  @override
  String get planType;

  /// Subscription status: 'active', 'canceled', 'expired', 'trial', 'grace_period'
  @override
  String get status;

  /// Maximum companies allowed (null = unlimited)
  @override
  int? get maxCompanies;

  /// Maximum stores allowed (null = unlimited)
  @override
  int? get maxStores;

  /// Maximum employees allowed (null = unlimited)
  @override
  int? get maxEmployees;

  /// AI requests daily limit (null = unlimited)
  @override
  int? get aiDailyLimit;

  /// Monthly price for display
  @override
  double get priceMonthly;

  /// List of enabled features
  @override
  List<String> get features;

  /// When subscription was last synced from server
  @override
  DateTime? get lastSyncedAt;

  /// Current sync status
  @override
  SyncStatus get syncStatus;

  /// RevenueCat customer ID (if available)
  @override
  String? get revenueCatCustomerId;

  /// Trial end date (if on trial)
  @override
  DateTime? get trialEndsAt;

  /// Current period end date (for paid subscriptions)
  @override
  DateTime? get currentPeriodEndsAt;

  /// Error message (if syncStatus is error)
  @override
  String? get errorMessage;

  /// Create a copy of SubscriptionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionStateImplCopyWith<_$SubscriptionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
