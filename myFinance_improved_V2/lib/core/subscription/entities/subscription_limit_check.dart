import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_limit_check.freezed.dart';

/// Subscription limit check result entity
///
/// Used for both cached (AppState-based) and fresh (RPC-based) limit checks.
/// Represents whether a user can add more resources based on their plan.
@freezed
class SubscriptionLimitCheck with _$SubscriptionLimitCheck {
  const factory SubscriptionLimitCheck({
    /// Whether the user can add more resources
    required bool canAdd,

    /// The user's current plan name ('free', 'basic', 'pro')
    required String planName,

    /// Maximum allowed count (null = unlimited for Pro plan)
    int? maxLimit,

    /// Current count of the resource
    required int currentCount,

    /// Type of resource being checked ('company', 'store', 'employee')
    @Default('') String checkType,
  }) = _SubscriptionLimitCheck;

  const SubscriptionLimitCheck._();

  /// Create from RPC response (check_subscription_limit)
  factory SubscriptionLimitCheck.fromJson(Map<String, dynamic> json) {
    return SubscriptionLimitCheck(
      canAdd: json['can_add'] as bool? ?? false,
      planName: json['plan_name'] as String? ?? 'free',
      maxLimit: json['max_limit'] as int?,
      currentCount: json['current_count'] as int? ?? 0,
      checkType: json['check_type'] as String? ?? '',
    );
  }

  /// Create from AppState (cached check)
  factory SubscriptionLimitCheck.fromCache({
    required bool canAdd,
    required String planName,
    required int? maxLimit,
    required int currentCount,
    required String checkType,
  }) {
    return SubscriptionLimitCheck(
      canAdd: canAdd,
      planName: planName,
      maxLimit: maxLimit,
      currentCount: currentCount,
      checkType: checkType,
    );
  }

  /// Check if the plan allows unlimited resources
  bool get isUnlimited => maxLimit == null || maxLimit == -1;

  /// Get limit display text (e.g., "2 / 3" or "5 / Unlimited")
  String get limitDisplayText {
    if (isUnlimited) {
      return '$currentCount / Unlimited';
    }
    return '$currentCount / $maxLimit';
  }

  /// Get upgrade message based on current plan
  String get upgradeMessage {
    switch (planName) {
      case 'free':
        return 'Upgrade to Basic or Pro for more capacity';
      case 'basic':
        return 'Upgrade to Pro for unlimited capacity';
      default:
        return '';
    }
  }

  /// Get resource-specific limit reached message
  String get limitReachedMessage {
    final resourceName = _getResourceDisplayName();
    if (isUnlimited) {
      return 'You can add more $resourceName';
    }
    return 'You\'ve reached the $resourceName limit ($currentCount/$maxLimit)';
  }

  /// Get resource display name
  String _getResourceDisplayName() {
    switch (checkType) {
      case 'company':
        return 'companies';
      case 'store':
        return 'stores';
      case 'employee':
        return 'employees';
      default:
        return 'resources';
    }
  }

  /// Get remaining count (-1 if unlimited)
  int get remainingCount {
    if (isUnlimited) return -1;
    return (maxLimit ?? 0) - currentCount;
  }

  /// Check if close to limit (80% or more used)
  bool get isCloseToLimit {
    if (isUnlimited) return false;
    if (maxLimit == null || maxLimit == 0) return false;
    return (currentCount / maxLimit!) >= 0.8;
  }
}
