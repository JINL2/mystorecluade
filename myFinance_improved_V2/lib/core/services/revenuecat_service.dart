import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../monitoring/sentry_config.dart';

/// RevenueCat 인앱 구독 서비스
///
/// Storebase 앱의 인앱 구독 결제를 처리합니다.
/// - Apple App Store (iOS)
/// - Google Play Store (Android) - 추후 지원 예정
///
/// 비즈니스 로직:
/// 1. Owner(사업주)가 Pro 플랜 구독
/// 2. Owner가 소유한 모든 회사가 Pro 플랜 상속
/// 3. 해당 회사의 모든 직원이 Pro 기능 사용 가능
/// 4. 구독 만료 시 자동으로 Free 플랜으로 전환
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  // API Keys
  static const String _appleApiKey = 'appl_mkgwFcTQAArwXybZCrwiWdHcIpB';
  static const String _testApiKey = 'test_dAsXBNYaEmeEQZZnbocyYecotbR';

  // 개발 모드 여부 (true: Test Store 사용, false: 실제 App Store 사용)
  // StoreKit Configuration 테스트 시에는 false 사용 (Apple API Key 필요)
  // TODO: Production 배포 시 false로 유지
  static const bool _useTestStore = false;

  // Offering identifier
  static const String _offeringId = 'storebase';

  bool _isInitialized = false;

  /// RevenueCat SDK 초기화
  Future<void> initialize() async {
    debugPrint('🔵 [RevenueCat] initialize() called, isInitialized: $_isInitialized');
    if (_isInitialized) {
      debugPrint('🔵 [RevenueCat] Already initialized, skipping');
      return;
    }

    try {
      // 디버그 모드 설정
      await Purchases.setLogLevel(LogLevel.debug);

      // API Key 선택
      String apiKey;
      if (_useTestStore) {
        apiKey = _testApiKey;
      } else if (Platform.isIOS) {
        apiKey = _appleApiKey;
      } else if (Platform.isAndroid) {
        // TODO: Android Google Play 연동 시 추가
        throw Exception('Android is not yet supported');
      } else {
        throw Exception('Unsupported platform');
      }

      // SDK 초기화
      PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
      await Purchases.configure(configuration);

      _isInitialized = true;
      debugPrint('🔵 [RevenueCat] ✅ Initialization SUCCESS');
    } catch (e, stackTrace) {
      debugPrint('🔵 [RevenueCat] ❌ Initialization FAILED: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'RevenueCat initialization failed',
      );
      rethrow;
    }
  }

  /// Supabase 사용자 ID로 RevenueCat 로그인
  ///
  /// Supabase user_id를 RevenueCat App User ID로 사용하여
  /// 구독 상태를 사용자별로 추적합니다.
  Future<void> loginUser(String supabaseUserId) async {
    debugPrint('🔵 [RevenueCat] loginUser() called with userId: $supabaseUserId');
    if (!_isInitialized) {
      debugPrint('🔵 [RevenueCat] Not initialized, calling initialize()...');
      await initialize();
    }

    try {
      // Supabase user_id를 RevenueCat App User ID로 사용
      debugPrint('🔵 [RevenueCat] Calling Purchases.logIn()...');
      LogInResult result = await Purchases.logIn(supabaseUserId);
      debugPrint('🔵 [RevenueCat] ✅ Login SUCCESS, created: ${result.created}');
      debugPrint('🔵 [RevenueCat] Active entitlements: ${result.customerInfo.entitlements.active.keys.toList()}');

      // 기존 구독 정보 확인
      debugPrint('🔵 [RevenueCat] Syncing subscription status...');
      _logSubscriptionStatus(result.customerInfo);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'RevenueCat login failed',
        extra: {'userId': supabaseUserId},
      );
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
    } catch (_) {
      // Logout failure is not critical
    }
  }

  /// 사용 가능한 패키지(상품) 목록 가져오기
  ///
  /// RevenueCat의 'storebase' offering에서 패키지를 가져옵니다.
  /// Package identifiers: basic.monthly, basic.yearly, pro.monthly, pro.yearly
  Future<List<Package>> getAvailablePackages() async {
    debugPrint('🔵 [RevenueCat] getAvailablePackages() called');
    try {
      Offerings offerings = await Purchases.getOfferings();
      debugPrint('🔵 [RevenueCat] All offerings: ${offerings.all.keys.toList()}');

      // Use 'storebase' offering specifically
      final storebaseOffering = offerings.getOffering(_offeringId);
      debugPrint('🔵 [RevenueCat] Storebase offering found: ${storebaseOffering != null}');

      if (storebaseOffering != null) {
        final packages = storebaseOffering.availablePackages;
        debugPrint('🔵 [RevenueCat] ✅ Available packages (${packages.length}):');
        for (final pkg in packages) {
          debugPrint('   - ${pkg.identifier}: ${pkg.storeProduct.identifier} (${pkg.storeProduct.priceString})');
        }
        return packages;
      }

      // Fallback to current offering
      if (offerings.current != null) {
        debugPrint('🔵 [RevenueCat] Using fallback current offering');
        return offerings.current!.availablePackages;
      }

      debugPrint('🔵 [RevenueCat] ⚠️ No packages found');
      return [];
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Failed to get RevenueCat offerings',
      );
      return [];
    }
  }

  /// 구독 구매
  ///
  /// 구매 성공 시 RevenueCat Webhook이 Supabase Edge Function을 호출하여
  /// subscription_user 테이블을 업데이트합니다.
  Future<bool> purchasePackage(Package package) async {
    debugPrint('🟢 [RevenueCat] purchasePackage() called');
    debugPrint('🟢 [RevenueCat] Package: ${package.identifier}');
    debugPrint('🟢 [RevenueCat] Product: ${package.storeProduct.identifier}');
    debugPrint('🟢 [RevenueCat] Price: ${package.storeProduct.priceString}');
    try {
      debugPrint('🟢 [RevenueCat] Calling Purchases.purchasePackage()...');
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      debugPrint('🟢 [RevenueCat] ✅ Purchase SUCCESS!');
      debugPrint('🟢 [RevenueCat] Active entitlements after purchase: ${customerInfo.entitlements.active.keys.toList()}');

      // 구매 후 구독 상태 동기화
      debugPrint('🟢 [RevenueCat] Syncing subscription to DB...');
      _logSubscriptionStatus(customerInfo);

      // Basic 또는 Pro 권한 확인 (둘 중 하나라도 있으면 성공)
      final hasBasic = _hasEntitlementMatch(customerInfo, 'basic');
      final hasPro = _hasEntitlementMatch(customerInfo, 'pro');
      final hasSubscription = hasBasic || hasPro;
      debugPrint('🟢 [RevenueCat] hasBasic: $hasBasic, hasPro: $hasPro, hasSubscription: $hasSubscription');

      return hasSubscription;
    } on PurchasesErrorCode catch (e) {
      debugPrint('🟢 [RevenueCat] ❌ Purchase FAILED: $e');
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('🟢 [RevenueCat] User cancelled purchase');
        return false;
      }
      rethrow;
    }
  }

  /// 구독 복원 (기기 변경 시)
  ///
  /// 사용자가 기기를 변경하거나 앱을 재설치한 경우
  /// 이전에 구매한 구독을 복원합니다.
  Future<bool> restorePurchases() async {
    debugPrint('🟡 [RevenueCat] restorePurchases() called');
    try {
      debugPrint('🟡 [RevenueCat] Calling Purchases.restorePurchases()...');
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      debugPrint('🟡 [RevenueCat] ✅ Restore SUCCESS');
      debugPrint('🟡 [RevenueCat] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');

      _logSubscriptionStatus(customerInfo);

      // Basic 또는 Pro 권한 확인 (둘 중 하나라도 있으면 성공)
      final hasBasic = _hasEntitlementMatch(customerInfo, 'basic');
      final hasPro = _hasEntitlementMatch(customerInfo, 'pro');
      final hasSubscription = hasBasic || hasPro;
      debugPrint('🟡 [RevenueCat] hasBasic: $hasBasic, hasPro: $hasPro, hasSubscription: $hasSubscription');

      return hasSubscription;
    } catch (e) {
      debugPrint('🟡 [RevenueCat] ❌ Restore FAILED: $e');
      return false;
    }
  }

  /// Check if any entitlement key contains the target string
  bool _hasEntitlementMatch(CustomerInfo customerInfo, String target) {
    return customerInfo.entitlements.active.keys.any(
      (key) => key.toLowerCase().contains(target.toLowerCase()),
    );
  }

  // NOTE: 다음 함수들 제거됨 (2026-01-25)
  // - checkProStatus(), checkBasicStatus(), checkProOnlyStatus(), getCurrentTier()
  //
  // 이유: 구독 상태는 Supabase DB(subscription_user)가 Single Source of Truth
  // 향후 Stripe 웹 결제도 지원하므로 RevenueCat에서 직접 가져오면 안 됨
  // 대신 SubscriptionStateNotifier를 통해 DB 기반으로 조회할 것

  /// 현재 고객 정보 가져오기
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (_) {
      return null;
    }
  }

  /// Find entitlement entry by partial key match
  EntitlementInfo? _findEntitlementByKeyMatch(CustomerInfo customerInfo, String target) {
    try {
      final matchingKey = customerInfo.entitlements.active.keys.firstWhere(
        (key) => key.toLowerCase().contains(target.toLowerCase()),
      );
      return customerInfo.entitlements.active[matchingKey];
    } catch (e) {
      return null;
    }
  }

  /// RevenueCat 구독 상태 로깅 (디버그용)
  ///
  /// NOTE: DB 동기화는 Webhook이 전담합니다.
  /// 이 함수는 디버그 로깅만 수행합니다.
  void _logSubscriptionStatus(CustomerInfo customerInfo) {
    debugPrint('🟣 [RevenueCat] _logSubscriptionStatus() called');
    debugPrint('🟣 [RevenueCat] All entitlements: ${customerInfo.entitlements.all.keys.toList()}');
    debugPrint('🟣 [RevenueCat] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');

    // Check for entitlements containing 'basic' or 'pro' (partial match)
    final hasPro = _hasEntitlementMatch(customerInfo, 'pro');
    final hasBasic = _hasEntitlementMatch(customerInfo, 'basic');
    debugPrint('🟣 [RevenueCat] hasPro: $hasPro, hasBasic: $hasBasic');

    // Determine current tier
    String currentTier = 'free';
    if (hasPro) {
      currentTier = 'pro';
    } else if (hasBasic) {
      currentTier = 'basic';
    }
    debugPrint('🟣 [RevenueCat] Determined tier: $currentTier');

    // Get entitlement details (pro takes priority over basic)
    EntitlementInfo? entitlement;
    if (hasPro) {
      entitlement = _findEntitlementByKeyMatch(customerInfo, 'pro');
    } else if (hasBasic) {
      entitlement = _findEntitlementByKeyMatch(customerInfo, 'basic');
    }

    if (entitlement != null) {
      debugPrint('🟣 [RevenueCat] Entitlement details:');
      debugPrint('   - productId: ${entitlement.productIdentifier}');
      debugPrint('   - expiresAt: ${entitlement.expirationDate}');
      debugPrint('   - isTrial: ${entitlement.periodType == PeriodType.trial}');
      debugPrint('   - willRenew: ${entitlement.willRenew}');
      debugPrint('   - originalPurchaseDate: ${entitlement.originalPurchaseDate}');
    }

    // NOTE: DB 동기화는 RevenueCat Webhook이 처리합니다.
    // 앱에서는 로깅만 수행합니다.
    debugPrint('🟣 [RevenueCat] ✅ Status logged (DB sync via Webhook)');
  }

  // NOTE: syncSubscriptionToDatabase() 함수 제거됨 (2026-01-25)
  //
  // 이유: subscription_user 테이블은 RevenueCat Webhook(Edge Function)만
  // INSERT/UPDATE해야 합니다. 앱 클라이언트에서 직접 DB 조작 시 RLS 정책과
  // 충돌하며, Webhook이 Single Source of Truth입니다.
  //
  // 구독 상태 동기화는 다음 경로로 이루어집니다:
  // 1. RevenueCat → Webhook → Supabase DB
  // 2. Supabase Realtime → SubscriptionStateNotifier → UI
  //
  // 앱에서는 RevenueCat SDK의 CustomerInfo만 로컬에서 확인하고,
  // DB 업데이트는 Webhook에 전적으로 위임합니다.

  /// 구독 상태 변경 리스너 설정
  ///
  /// 구독 상태가 변경될 때마다 콜백이 호출됩니다.
  /// 앱에서 실시간으로 구독 상태를 반영하는 데 사용합니다.
  void addCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  /// 리스너 제거
  void removeCustomerInfoUpdateListener(void Function(CustomerInfo) listener) {
    Purchases.removeCustomerInfoUpdateListener(listener);
  }

  /// 특정 패키지 타입 가져오기
  Future<Package?> getPackageByType(PackageType type) async {
    final packages = await getAvailablePackages();
    try {
      return packages.firstWhere((p) => p.packageType == type);
    } catch (e) {
      return null;
    }
  }

  /// 월간 구독 패키지 가져오기
  Future<Package?> getMonthlyPackage() async {
    return getPackageByType(PackageType.monthly);
  }

  /// 연간 구독 패키지 가져오기
  Future<Package?> getAnnualPackage() async {
    return getPackageByType(PackageType.annual);
  }

  /// 평생 이용권 패키지 가져오기
  Future<Package?> getLifetimePackage() async {
    return getPackageByType(PackageType.lifetime);
  }

  /// 구독 상세 정보 가져오기 (Trial 포함)
  ///
  /// Returns comprehensive subscription details including:
  /// - Current tier (free, basic, pro)
  /// - Trial status and end date
  /// - Subscription expiration date
  /// - Auto-renewal status
  Future<SubscriptionDetailsData> getSubscriptionDetails() async {
    debugPrint('🔵 [RevenueCat] getSubscriptionDetails() called');
    try {
      final customerInfo = await Purchases.getCustomerInfo();

      // Determine tier
      final hasPro = _hasEntitlementMatch(customerInfo, 'pro');
      final hasBasic = _hasEntitlementMatch(customerInfo, 'basic');

      String tier = 'free';
      if (hasPro) {
        tier = 'pro';
      } else if (hasBasic) {
        tier = 'basic';
      }

      // Get entitlement details
      EntitlementInfo? entitlement;
      if (hasPro) {
        entitlement = _findEntitlementByKeyMatch(customerInfo, 'pro');
      } else if (hasBasic) {
        entitlement = _findEntitlementByKeyMatch(customerInfo, 'basic');
      }

      if (entitlement == null) {
        debugPrint('🔵 [RevenueCat] No active entitlement, returning free tier');
        return SubscriptionDetailsData.free();
      }

      final isOnTrial = entitlement.periodType == PeriodType.trial;
      final expirationDateStr = entitlement.expirationDate;
      final willRenew = entitlement.willRenew;
      final productId = entitlement.productIdentifier;

      // Parse dates
      DateTime? expirationDate;
      if (expirationDateStr != null) {
        expirationDate = DateTime.tryParse(expirationDateStr);
      }

      // For trial, trialEndDate = expirationDate
      DateTime? trialEndDate;
      if (isOnTrial && expirationDate != null) {
        trialEndDate = expirationDate;
      }

      final details = SubscriptionDetailsData(
        tier: tier,
        isOnTrial: isOnTrial,
        trialEndDate: trialEndDate,
        expirationDate: expirationDate,
        willRenew: willRenew,
        productId: productId,
      );

      debugPrint('🔵 [RevenueCat] SubscriptionDetails: $details');
      return details;
    } catch (e) {
      debugPrint('🔵 [RevenueCat] ❌ getSubscriptionDetails FAILED: $e');
      return SubscriptionDetailsData.free();
    }
  }

  // =========================================================================
  // Customer Center & Offer Code (2026 Best Practices)
  // =========================================================================

  /// RevenueCat Customer Center 표시
  ///
  /// Customer Center는 구독 관리 UI를 제공합니다:
  /// - 현재 구독 상태 확인
  /// - 구독 취소 (Exit Survey + Retention Offer 포함)
  /// - 환불 요청 (iOS)
  /// - 구독 변경
  ///
  /// RevenueCat Dashboard에서 Customer Center를 먼저 활성화해야 합니다.
  Future<void> presentCustomerCenter() async {
    debugPrint('🟢 [RevenueCat] presentCustomerCenter() called');
    try {
      await RevenueCatUI.presentCustomerCenter();
      debugPrint('🟢 [RevenueCat] ✅ Customer Center presented');
    } catch (e, stackTrace) {
      debugPrint('🟢 [RevenueCat] ❌ Customer Center FAILED: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Failed to present Customer Center',
      );
      rethrow;
    }
  }

  /// App Store Offer Code 입력 시트 표시 (iOS 14+)
  ///
  /// iOS의 App Store Offer Code 입력 시트를 표시합니다.
  /// 사용자가 세일즈 프로모션 코드(예: WELCOME2026)를 입력하면
  /// 해당 코드에 연결된 무료 구독이 적용됩니다.
  ///
  /// App Store Connect에서 먼저 Offer Code를 생성해야 합니다:
  /// 1. App Store Connect → 앱 선택 → 구독 → Offer Codes
  /// 2. Custom Code 생성 (예: WELCOME2026)
  /// 3. 무료 기간 설정 (예: 1개월 Free)
  Future<void> presentCodeRedemptionSheet() async {
    debugPrint('🟢 [RevenueCat] presentCodeRedemptionSheet() called');

    if (!Platform.isIOS) {
      debugPrint('🟢 [RevenueCat] ⚠️ Offer Code is iOS only');
      throw Exception('Offer Code redemption is only available on iOS');
    }

    try {
      await Purchases.presentCodeRedemptionSheet();
      debugPrint('🟢 [RevenueCat] ✅ Code Redemption Sheet presented');

      // 코드 적용 후 구독 상태 동기화
      final customerInfo = await Purchases.getCustomerInfo();
      _logSubscriptionStatus(customerInfo);
    } catch (e, stackTrace) {
      debugPrint('🟢 [RevenueCat] ❌ Code Redemption FAILED: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Failed to present Code Redemption Sheet',
      );
      rethrow;
    }
  }

  /// 테스터/인플루언서용 속성 설정
  ///
  /// RevenueCat Attributes에 테스터 정보를 태깅합니다.
  /// Dashboard에서 테스터 유저를 필터링하는 데 사용됩니다.
  ///
  /// [code] - 사용된 프로모션 코드 (예: 'WELCOME2026')
  /// [source] - 코드 출처 (예: 'sales', 'influencer', 'campaign')
  Future<void> setTesterAttributes({
    required String code,
    String source = 'manual',
  }) async {
    debugPrint('🟢 [RevenueCat] setTesterAttributes() called');
    debugPrint('   - code: $code');
    debugPrint('   - source: $source');

    try {
      await Purchases.setAttributes({
        'is_tester': 'true',
        'promo_code': code,
        'promo_source': source,
        'promo_redeemed_at': DateTime.now().toIso8601String(),
      });
      debugPrint('🟢 [RevenueCat] ✅ Tester attributes set');
    } catch (e) {
      debugPrint('🟢 [RevenueCat] ❌ setTesterAttributes FAILED: $e');
      // 실패해도 앱 동작에는 영향 없음
    }
  }
}

/// Data class for subscription details
///
/// Used by RevenueCatService.getSubscriptionDetails()
/// This is kept in the service file to avoid circular imports.
class SubscriptionDetailsData {
  final String tier;
  final bool isOnTrial;
  final DateTime? trialEndDate;
  final DateTime? expirationDate;
  final bool willRenew;
  final String? productId;

  const SubscriptionDetailsData({
    required this.tier,
    this.isOnTrial = false,
    this.trialEndDate,
    this.expirationDate,
    this.willRenew = false,
    this.productId,
  });

  factory SubscriptionDetailsData.free() =>
      const SubscriptionDetailsData(tier: 'free');

  @override
  String toString() {
    return 'SubscriptionDetailsData(tier: $tier, isOnTrial: $isOnTrial, '
        'trialEndDate: $trialEndDate, expirationDate: $expirationDate, '
        'willRenew: $willRenew, productId: $productId)';
  }
}
