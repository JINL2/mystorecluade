import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Entitlement identifiers (from RevenueCat)
  // Note: RevenueCat uses format like 'storebase.pro.monthly', 'storebase.basic.monthly'
  // We check for partial matches containing 'basic' or 'pro'
  static const String _basicEntitlementId = 'basic';
  static const String _proEntitlementId = 'pro';

  /// Check if entitlement key contains the target identifier
  static bool _hasEntitlement(Map<String, dynamic> entitlements, String targetId) {
    return entitlements.keys.any((key) => key.toLowerCase().contains(targetId.toLowerCase()));
  }

  /// Get entitlement by partial match
  static MapEntry<String, dynamic>? _getEntitlement(Map<String, dynamic> entitlements, String targetId) {
    try {
      return entitlements.entries.firstWhere(
        (entry) => entry.key.toLowerCase().contains(targetId.toLowerCase()),
      );
    } catch (e) {
      return null;
    }
  }

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
      await _syncSubscriptionStatus(result.customerInfo);
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
      await _syncSubscriptionStatus(customerInfo);

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

      await _syncSubscriptionStatus(customerInfo);

      bool isPro = customerInfo.entitlements.active.containsKey(_proEntitlementId);
      debugPrint('🟡 [RevenueCat] isPro after restore: $isPro');

      return isPro;
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

  /// 현재 구독 상태 확인 (Basic 또는 Pro)
  Future<bool> checkProStatus() async {
    debugPrint('🔵 [RevenueCat] checkProStatus() called');
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // Check if user has any entitlement containing 'basic' or 'pro'
      final hasBasic = _hasEntitlementMatch(customerInfo, 'basic');
      final hasPro = _hasEntitlementMatch(customerInfo, 'pro');
      debugPrint('🔵 [RevenueCat] checkProStatus - hasBasic: $hasBasic, hasPro: $hasPro');
      debugPrint('🔵 [RevenueCat] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
      return hasBasic || hasPro;
    } catch (e) {
      debugPrint('🔵 [RevenueCat] ❌ checkProStatus FAILED: $e');
      return false;
    }
  }

  /// Check if user has Basic entitlement
  Future<bool> checkBasicStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return _hasEntitlementMatch(customerInfo, 'basic');
    } catch (_) {
      return false;
    }
  }

  /// Check if user has Pro entitlement specifically
  Future<bool> checkProOnlyStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return _hasEntitlementMatch(customerInfo, 'pro');
    } catch (_) {
      return false;
    }
  }

  /// Get current subscription tier: 'free', 'basic', or 'pro'
  Future<String> getCurrentTier() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // Pro takes priority over basic
      if (_hasEntitlementMatch(customerInfo, 'pro')) {
        return 'pro';
      } else if (_hasEntitlementMatch(customerInfo, 'basic')) {
        return 'basic';
      }
      return 'free';
    } catch (_) {
      return 'free';
    }
  }

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

  /// 구독 상태를 Supabase와 동기화
  ///
  /// 이 메서드는 두 가지 역할을 합니다:
  /// 1. RevenueCat 상태를 Supabase DB에 직접 동기화 (Webhook 백업)
  /// 2. 로컬 상태 업데이트용 로깅
  ///
  /// Webhook이 실패하거나 Xcode 환경에서 작동하지 않을 때 백업으로 작동합니다.
  Future<void> _syncSubscriptionStatus(CustomerInfo customerInfo) async {
    debugPrint('🟣 [RevenueCat] _syncSubscriptionStatus() called');
    debugPrint('🟣 [RevenueCat] All entitlements: ${customerInfo.entitlements.all.keys.toList()}');
    debugPrint('🟣 [RevenueCat] Active entitlements: ${customerInfo.entitlements.active.keys.toList()}');
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) {
        debugPrint('🟣 [RevenueCat] ⚠️ No userId, skipping sync');
        return;
      }
      debugPrint('🟣 [RevenueCat] userId: $userId');

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

      String? productId;
      String? expiresAt;
      bool isTrial = false;

      // Get entitlement details (pro takes priority over basic)
      EntitlementInfo? entitlement;
      if (hasPro) {
        entitlement = _findEntitlementByKeyMatch(customerInfo, 'pro');
      } else if (hasBasic) {
        entitlement = _findEntitlementByKeyMatch(customerInfo, 'basic');
      }

      String? originalPurchaseDate;
      bool? willRenew;

      if (entitlement != null) {
        productId = entitlement.productIdentifier;
        expiresAt = entitlement.expirationDate;
        isTrial = entitlement.periodType == PeriodType.trial;
        originalPurchaseDate = entitlement.originalPurchaseDate;
        willRenew = entitlement.willRenew;
        debugPrint('🟣 [RevenueCat] Entitlement details:');
        debugPrint('   - productId: $productId');
        debugPrint('   - expiresAt: $expiresAt');
        debugPrint('   - isTrial: $isTrial');
        debugPrint('   - willRenew: $willRenew');
        debugPrint('   - originalPurchaseDate: $originalPurchaseDate');
      }

      // ✅ Supabase DB에 구독 상태 동기화 (Webhook 백업)
      debugPrint('🟣 [RevenueCat] Calling syncSubscriptionToDatabase()...');
      await syncSubscriptionToDatabase(
        userId: userId,
        planType: currentTier,
        productId: productId,
        expiresAt: expiresAt,
        isTrial: isTrial,
        willRenew: willRenew,
        trialStartDate: isTrial ? originalPurchaseDate : null,
        trialEndDate: isTrial ? expiresAt : null,
      );
      debugPrint('🟣 [RevenueCat] ✅ Sync to DB completed');
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Subscription sync failed',
      );
    }
  }

  /// Supabase DB에 구독 상태를 직접 업데이트
  ///
  /// Webhook이 작동하지 않는 환경(Xcode StoreKit)에서도
  /// DB를 최신 상태로 유지합니다.
  ///
  /// planType: 'free', 'basic', or 'pro'
  /// willRenew: 자동 갱신 여부 (취소하면 false)
  Future<void> syncSubscriptionToDatabase({
    required String userId,
    required String planType,
    String? productId,
    String? expiresAt,
    bool isTrial = false,
    bool? willRenew,  // null이면 isActive로 기본값 설정
    String? trialStartDate,  // Trial 시작일 (originalPurchaseDate)
    String? trialEndDate,    // Trial 종료일 (expirationDate during trial)
  }) async {
    debugPrint('🟠 [RevenueCat] syncSubscriptionToDatabase() called');
    debugPrint('🟠 [RevenueCat] Params:');
    debugPrint('   - userId: $userId');
    debugPrint('   - planType: $planType');
    debugPrint('   - productId: $productId');
    debugPrint('   - expiresAt: $expiresAt');
    debugPrint('   - isTrial: $isTrial');
    debugPrint('   - willRenew: $willRenew');
    try {
      final supabase = Supabase.instance.client;

      // Plan IDs from subscription_plans table
      const planIds = {
        'free': '499b821f-c0c3-4eaf-ba4e-c5aaaf9759be',
        'basic': 'c484321e-99c6-4cd7-af77-e74c325acede',
        'pro': '29e2647b-082b-45e9-b228-ac78fc87daec',
      };

      final planId = planIds[planType] ?? planIds['free']!;
      final isActive = planType != 'free';
      final autoRenew = willRenew ?? isActive;  // willRenew가 명시되지 않으면 isActive 사용
      final now = DateTime.now().toUtc();

      // Determine billing cycle from product ID
      String billingCycle = 'monthly';
      if (productId != null) {
        if (productId.contains('yearly') || productId.contains('annual')) {
          billingCycle = 'yearly';
        }
      }

      // Parse expiration date
      // ⚠️ Sandbox에서는 RevenueCat이 실제 기간(1달/1년)으로 반환하지만
      // 실제 갱신은 5분/1시간마다 발생함. DB에는 RevenueCat 값 그대로 저장.
      // (Sandbox 테스트 시 이 점 참고)
      DateTime? expirationDate;
      if (expiresAt != null) {
        expirationDate = DateTime.tryParse(expiresAt);

        // 🧪 DEBUG: Sandbox 환경에서는 실제 갱신 주기로 조정 (옵션)
        // Monthly = 5분, Annual = 1시간
        // 주석 해제하면 Sandbox 테스트 시 실제 갱신 시간 반영
        /*
        if (kDebugMode && expirationDate != null) {
          final isAnnual = productId?.contains('yearly') == true ||
                          productId?.contains('annual') == true;
          if (isAnnual) {
            expirationDate = now.add(const Duration(hours: 1));
          } else {
            expirationDate = now.add(const Duration(minutes: 5));
          }
          debugPrint('  - [Sandbox] Adjusted expiration: $expirationDate');
        }
        */
      }

      // Determine status: active, trialing, or canceled (based on willRenew)
      String status;
      if (!isActive) {
        status = 'canceled';
      } else if (isTrial) {
        status = 'trialing';
      } else if (autoRenew) {
        status = 'active';
      } else {
        status = 'canceled';  // 취소 예정 (만료일까지 사용 가능)
      }

      // Check if user already has a subscription record
      debugPrint('🟠 [RevenueCat] Checking existing subscription record...');
      final existingRecord = await supabase
          .from('subscription_user')
          .select('subscription_id')
          .eq('user_id', userId)
          .maybeSingle();
      debugPrint('🟠 [RevenueCat] Existing record: ${existingRecord != null ? 'YES' : 'NO'}');

      // Parse trial dates
      DateTime? trialStart;
      DateTime? trialEnd;
      if (isTrial) {
        trialStart = trialStartDate != null ? DateTime.tryParse(trialStartDate) : now;
        trialEnd = trialEndDate != null ? DateTime.tryParse(trialEndDate) : expirationDate;
      }

      if (existingRecord != null) {
        // Update existing record
        debugPrint('🟠 [RevenueCat] Updating existing subscription_user record...');
        await supabase.from('subscription_user').update({
          'plan_id': planId,
          'status': status,
          'billing_cycle': billingCycle,
          'current_period_end': expirationDate?.toIso8601String(),
          'expiration_date': expirationDate?.toIso8601String(),
          'trial_start': isTrial ? trialStart?.toIso8601String() : null,
          'trial_end': isTrial ? trialEnd?.toIso8601String() : null,
          'revenuecat_product_id': productId,
          'revenuecat_store': Platform.isIOS ? 'APP_STORE' : 'PLAY_STORE',
          'is_sandbox': kDebugMode,
          'auto_renew_status': autoRenew,
          'payment_provider': Platform.isIOS ? 'revenuecat_apple' : 'revenuecat_google',
          'updated_at': now.toIso8601String(),
        }).eq('user_id', userId);
        debugPrint('🟠 [RevenueCat] ✅ subscription_user UPDATE completed');
      } else {
        // Insert new record
        debugPrint('🟠 [RevenueCat] Inserting new subscription_user record...');
        await supabase.from('subscription_user').insert({
          'user_id': userId,
          'plan_id': planId,
          'status': status,
          'billing_cycle': billingCycle,
          'current_period_start': trialStart?.toIso8601String() ?? now.toIso8601String(),
          'current_period_end': expirationDate?.toIso8601String(),
          'trial_start': isTrial ? trialStart?.toIso8601String() : null,
          'trial_end': isTrial ? trialEnd?.toIso8601String() : null,
          'expiration_date': expirationDate?.toIso8601String(),
          'revenuecat_app_user_id': userId,
          'revenuecat_product_id': productId,
          'revenuecat_store': Platform.isIOS ? 'APP_STORE' : 'PLAY_STORE',
          'is_sandbox': kDebugMode,
          'auto_renew_status': autoRenew,
          'payment_provider': Platform.isIOS ? 'revenuecat_apple' : 'revenuecat_google',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
        debugPrint('🟠 [RevenueCat] ✅ subscription_user INSERT completed');
      }

      // 2. companies 테이블도 업데이트 (이 유저가 소유한 회사들)
      // companies 테이블은 inherited_plan_id (UUID)를 사용
      debugPrint('🟠 [RevenueCat] Updating companies table for owner...');
      await supabase.from('companies').update({
        'inherited_plan_id': planId,
        'plan_updated_at': now.toIso8601String(),
        'updated_at': now.toIso8601String(),
      }).eq('owner_id', userId);
      debugPrint('🟠 [RevenueCat] ✅ companies UPDATE completed');
      debugPrint('🟠 [RevenueCat] ===== DB SYNC COMPLETE =====');
    } catch (e, stackTrace) {
      debugPrint('🟠 [RevenueCat] ❌ DB sync FAILED: $e');
      // 실패해도 앱은 계속 작동 (RevenueCat이 source of truth)
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'Failed to sync subscription to DB',
        extra: {'userId': userId, 'planType': planType},
      );
    }
  }

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
      await _syncSubscriptionStatus(customerInfo);
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
