import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_state.freezed.dart';
part 'subscription_state.g.dart';

/// Sync status for subscription data
enum SyncStatus {
  /// Unknown - initial state before any sync
  unknown,

  /// Syncing - currently fetching from server
  syncing,

  /// Synced - successfully synced with server
  synced,

  /// Stale - cache is past TTL but still usable
  stale,

  /// Error - sync failed
  error,

  /// Offline - device is offline, using cached data
  offline,
}

/// Subscription State Entity
///
/// Central state for user's subscription across the app.
/// Managed by SubscriptionStateNotifier with:
/// - RevenueCat SDK listener for purchase events
/// - Supabase Realtime for cross-device sync
/// - 1-hour TTL cache for offline support
///
/// NULL values for limits mean UNLIMITED (Pro plan)
/// -1 in domain entities also means unlimited
@freezed
class SubscriptionState with _$SubscriptionState {
  const SubscriptionState._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubscriptionState({
    /// User ID this subscription belongs to
    required String userId,

    /// Plan identifier from subscription_plans table
    @Default('') String planId,

    /// Plan name: 'free', 'basic', 'pro'
    @Default('free') String planName,

    /// Display name for UI: 'Free', 'Basic', 'Pro'
    @Default('Free') String displayName,

    /// Plan type: 'free' or 'paid' (billing category)
    @Default('free') String planType,

    /// Subscription status: 'active', 'canceled', 'expired', 'trial', 'grace_period'
    @Default('active') String status,

    /// Maximum companies allowed (null = unlimited)
    int? maxCompanies,

    /// Maximum stores allowed (null = unlimited)
    int? maxStores,

    /// Maximum employees allowed (null = unlimited)
    int? maxEmployees,

    /// AI requests daily limit (null = unlimited)
    int? aiDailyLimit,

    /// Monthly price for display
    @Default(0.0) double priceMonthly,

    /// List of enabled features
    @Default([]) List<String> features,

    /// When subscription was last synced from server
    DateTime? lastSyncedAt,

    /// Current sync status
    @Default(SyncStatus.unknown) SyncStatus syncStatus,

    /// RevenueCat customer ID (if available)
    String? revenueCatCustomerId,

    /// Trial end date (if on trial)
    DateTime? trialEndsAt,

    /// Current period end date (for paid subscriptions)
    DateTime? currentPeriodEndsAt,

    /// Error message (if syncStatus is error)
    String? errorMessage,
  }) = _SubscriptionState;

  /// Create from JSON (for cache deserialization)
  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  /// Create initial state for a user
  factory SubscriptionState.initial(String userId) => SubscriptionState(
        userId: userId,
        planName: 'free',
        displayName: 'Free',
        planType: 'free',
        status: 'active',
        syncStatus: SyncStatus.unknown,
      );

  /// Create from RPC response (get_user_subscription_state)
  factory SubscriptionState.fromRpc(String userId, Map<String, dynamic> data) {
    return SubscriptionState(
      userId: userId,
      planId: data['plan_id'] as String? ?? '',
      planName: data['plan_name'] as String? ?? 'free',
      displayName: data['display_name'] as String? ?? data['plan_name'] as String? ?? 'Free',
      planType: data['plan_type'] as String? ?? 'free',
      status: data['status'] as String? ?? 'active',
      // NULL from DB = unlimited, keep as null (converted to -1 when needed)
      maxCompanies: data['max_companies'] as int?,
      maxStores: data['max_stores'] as int?,
      maxEmployees: data['max_employees'] as int?,
      aiDailyLimit: data['ai_daily_limit'] as int?,
      priceMonthly: (data['price_monthly'] as num?)?.toDouble() ?? 0.0,
      features: (data['features'] as List<dynamic>?)
              ?.map((f) => f as String)
              .toList() ??
          [],
      lastSyncedAt: DateTime.now(),
      syncStatus: SyncStatus.synced,
      revenueCatCustomerId: data['revenuecat_customer_id'] as String?,
      trialEndsAt: data['trial_ends_at'] != null
          ? DateTime.tryParse(data['trial_ends_at'] as String)
          : null,
      currentPeriodEndsAt: data['current_period_ends_at'] != null
          ? DateTime.tryParse(data['current_period_ends_at'] as String)
          : null,
    );
  }

  // ============================================================================
  // Computed Properties
  // ============================================================================

  /// Check if data is stale (past 1 hour TTL)
  bool get isStale {
    if (lastSyncedAt == null) return true;
    return DateTime.now().difference(lastSyncedAt!) > const Duration(hours: 1);
  }

  /// Check if this is a free plan
  bool get isFree => planName == 'free' || planType == 'free';

  /// Check if this is a paid plan
  bool get isPaid => planType == 'paid' || planName != 'free';

  /// Check if this is a Pro plan
  bool get isPro => planName == 'pro';

  /// Check if this is a Basic plan
  bool get isBasic => planName == 'basic';

  /// Check if subscription is active
  bool get isActive => status == 'active' || status == 'trial';

  /// Check if on trial
  bool get isOnTrial => status == 'trial';

  /// Check if in grace period
  bool get isInGracePeriod => status == 'grace_period';

  /// Check if companies are unlimited
  bool get hasUnlimitedCompanies => maxCompanies == null;

  /// Check if stores are unlimited
  bool get hasUnlimitedStores => maxStores == null;

  /// Check if employees are unlimited
  bool get hasUnlimitedEmployees => maxEmployees == null;

  /// Check if AI is unlimited
  bool get hasUnlimitedAI => aiDailyLimit == null;

  // ============================================================================
  // Limit Check Methods
  // ============================================================================

  /// Get max companies for domain layer (null → -1)
  int get maxCompaniesForDomain => maxCompanies ?? -1;

  /// Get max stores for domain layer (null → -1)
  int get maxStoresForDomain => maxStores ?? -1;

  /// Get max employees for domain layer (null → -1)
  int get maxEmployeesForDomain => maxEmployees ?? -1;

  /// Get AI daily limit for domain layer (null → -1)
  int get aiDailyLimitForDomain => aiDailyLimit ?? -1;

  /// Check if can add company
  bool canAddCompany(int currentCount) {
    if (hasUnlimitedCompanies) return true;
    return currentCount < (maxCompanies ?? 0);
  }

  /// Check if can add store
  bool canAddStore(int currentCount) {
    if (hasUnlimitedStores) return true;
    return currentCount < (maxStores ?? 0);
  }

  /// Check if can add employee
  bool canAddEmployee(int currentCount) {
    if (hasUnlimitedEmployees) return true;
    return currentCount < (maxEmployees ?? 0);
  }

  /// Check if can use AI
  bool canUseAI(int usedToday) {
    if (hasUnlimitedAI) return true;
    return usedToday < (aiDailyLimit ?? 0);
  }

  // ============================================================================
  // Display Helpers
  // ============================================================================

  /// Get limit display text for a resource type
  String getLimitDisplay(String type, int currentCount) {
    final limit = switch (type) {
      'company' => maxCompanies,
      'store' => maxStores,
      'employee' => maxEmployees,
      'ai' => aiDailyLimit,
      _ => null,
    };

    if (limit == null) {
      return '$currentCount / Unlimited';
    }
    return '$currentCount / $limit';
  }

  /// Get days until trial ends (-1 if not on trial)
  int get daysUntilTrialEnds {
    if (!isOnTrial || trialEndsAt == null) return -1;
    final diff = trialEndsAt!.difference(DateTime.now());
    return diff.inDays;
  }

  /// Get days until current period ends (-1 if unknown)
  int get daysUntilPeriodEnds {
    if (currentPeriodEndsAt == null) return -1;
    final diff = currentPeriodEndsAt!.difference(DateTime.now());
    return diff.inDays;
  }

  /// Convert to Map for caching
  Map<String, dynamic> toCacheMap() {
    return toJson();
  }
}
