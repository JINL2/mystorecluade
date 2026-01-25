/// Subscription entity representing a company's subscription plan
///
/// Rich Domain Model with business logic for subscription checks
class Subscription {
  const Subscription({
    required this.planId,
    required this.planName,
    required this.displayName,
    required this.planType,
    required this.maxCompanies,
    required this.maxStores,
    required this.maxEmployees,
    required this.aiDailyLimit,
    required this.priceMonthly,
    required this.features,
  });

  final String planId;
  final String planName;
  final String displayName;
  final String planType; // 'free', 'basic', 'pro'
  final int maxCompanies;
  final int maxStores;
  final int maxEmployees;
  final int aiDailyLimit;
  final double priceMonthly;
  final List<String> features;

  // ============================================================================
  // Factory Constructors
  // ============================================================================

  /// Create Subscription from Map
  ///
  /// NULL values mean unlimited, converted to -1 for internal representation.
  factory Subscription.fromMap(Map<String, dynamic> map) {
    // NULL은 무제한을 의미 -> -1로 변환
    final maxEmployees = (map['max_employees'] as int?) ?? -1;
    final maxStores = (map['max_stores'] as int?) ?? -1;
    final maxCompanies = (map['max_companies'] as int?) ?? -1;

    return Subscription(
      planId: map['plan_id'] as String,
      planName: map['plan_name'] as String,
      displayName: (map['display_name'] as String?) ?? map['plan_name'] as String,
      planType: map['plan_type'] as String,
      maxCompanies: maxCompanies,
      maxStores: maxStores,
      maxEmployees: maxEmployees,
      aiDailyLimit: (map['ai_daily_limit'] as int?) ?? -1,  // null = 무제한 = -1
      priceMonthly: (map['price_monthly'] as num?)?.toDouble() ?? 0.0,
      features: (map['features'] as List<dynamic>?)
              ?.map((f) => f as String)
              .toList() ??
          [],
    );
  }

  /// Default free subscription
  factory Subscription.free() {
    return const Subscription(
      planId: '',
      planName: 'free',
      displayName: 'Free',
      planType: 'free',
      maxCompanies: 1,
      maxStores: 1,
      maxEmployees: 5,
      aiDailyLimit: 2,
      priceMonthly: 0,
      features: ['basic_reports', 'employee_management', 'inventory_basic'],
    );
  }

  // ============================================================================
  // Computed Properties (Business Logic)
  // ============================================================================

  /// Check if this is a free plan
  bool get isFree => planType == 'free';

  /// Check if this is a basic plan
  bool get isBasic => planType == 'basic';

  /// Check if this is a pro plan
  bool get isPro => planType == 'pro';

  /// Check if this is a paid plan
  bool get isPaid => planType != 'free';

  /// Check if stores are unlimited (-1 means unlimited)
  bool get hasUnlimitedStores => maxStores == -1;

  /// Check if employees are unlimited (-1 means unlimited)
  bool get hasUnlimitedEmployees => maxEmployees == -1;

  /// Check if AI is unlimited (-1 means unlimited)
  bool get hasUnlimitedAI => aiDailyLimit == -1;

  /// Check if companies are unlimited (-1 means unlimited)
  bool get hasUnlimitedCompanies => maxCompanies == -1;

  // ============================================================================
  // Business Methods
  // ============================================================================

  /// Check if adding a store would exceed limit
  bool canAddStore(int currentStoreCount) {
    if (hasUnlimitedStores) return true;
    return currentStoreCount < maxStores;
  }

  /// Check if adding an employee would exceed limit
  bool canAddEmployee(int currentEmployeeCount) {
    if (hasUnlimitedEmployees) return true;
    return currentEmployeeCount < maxEmployees;
  }

  /// Check if AI request is allowed (based on daily limit)
  bool canUseAI(int usedToday) {
    if (hasUnlimitedAI) return true;
    return usedToday < aiDailyLimit;
  }

  /// Get remaining AI requests for today
  int remainingAIRequests(int usedToday) {
    if (hasUnlimitedAI) return -1; // -1 indicates unlimited
    return (aiDailyLimit - usedToday).clamp(0, aiDailyLimit);
  }

  /// Check if feature is available in this plan
  bool hasFeature(String feature) {
    return features.contains(feature);
  }

  /// Get upgrade recommendation based on what user needs
  String? getUpgradeRecommendation({
    int? currentStores,
    int? currentEmployees,
    bool? needsUnlimitedAI,
  }) {
    if (isPro) return null; // Already on highest plan

    if (currentStores != null && !canAddStore(currentStores)) {
      return isBasic
          ? 'Upgrade to Pro for unlimited stores'
          : 'Upgrade to Basic for more stores';
    }

    if (currentEmployees != null && !canAddEmployee(currentEmployees)) {
      return 'Upgrade to Basic for unlimited employees';
    }

    if (needsUnlimitedAI == true && !hasUnlimitedAI) {
      return 'Upgrade to Basic for unlimited AI assistance';
    }

    return null;
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'plan_id': planId,
      'plan_name': planName,
      'display_name': displayName,
      'plan_type': planType,
      'max_companies': maxCompanies,
      'max_stores': maxStores,
      'max_employees': maxEmployees,
      'ai_daily_limit': aiDailyLimit,
      'price_monthly': priceMonthly,
      'features': features,
    };
  }

  // ============================================================================
  // Mock Factory (for skeleton loading)
  // ============================================================================

  static Subscription mock() => const Subscription(
        planId: 'mock-plan-id',
        planName: 'basic',
        displayName: 'Basic Plan',
        planType: 'basic',
        maxCompanies: 3,
        maxStores: 5,
        maxEmployees: 50,
        aiDailyLimit: 100,
        priceMonthly: 9.99,
        features: ['basic_reports', 'employee_management', 'inventory_basic'],
      );
}
