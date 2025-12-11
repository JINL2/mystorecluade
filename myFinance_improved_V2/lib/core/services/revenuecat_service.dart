import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Entitlement identifier
  static const String _proEntitlementId = 'STOREBASE Pro';

  bool _isInitialized = false;

  /// RevenueCat SDK 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // 디버그 모드 설정
      await Purchases.setLogLevel(LogLevel.debug);

      // API Key 선택
      String apiKey;
      if (_useTestStore) {
        apiKey = _testApiKey;
        debugPrint('🧪 RevenueCat: Using TEST Store');
      } else if (Platform.isIOS) {
        apiKey = _appleApiKey;
        debugPrint('🍎 RevenueCat: Using Apple App Store');
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
      debugPrint('✅ RevenueCat initialized successfully');
    } catch (e) {
      debugPrint('❌ RevenueCat initialization failed: $e');
      rethrow;
    }
  }

  /// Supabase 사용자 ID로 RevenueCat 로그인
  ///
  /// Supabase user_id를 RevenueCat App User ID로 사용하여
  /// 구독 상태를 사용자별로 추적합니다.
  Future<void> loginUser(String supabaseUserId) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Supabase user_id를 RevenueCat App User ID로 사용
      LogInResult result = await Purchases.logIn(supabaseUserId);
      debugPrint(
          '✅ RevenueCat login: ${result.customerInfo.originalAppUserId}');

      // 기존 구독 정보 확인
      await _syncSubscriptionStatus(result.customerInfo);
    } catch (e) {
      debugPrint('❌ RevenueCat login failed: $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logoutUser() async {
    try {
      await Purchases.logOut();
      debugPrint('✅ RevenueCat logged out');
    } catch (e) {
      debugPrint('❌ RevenueCat logout failed: $e');
    }
  }

  /// 사용 가능한 패키지(상품) 목록 가져오기
  Future<List<Package>> getAvailablePackages() async {
    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        debugPrint(
            '📦 Available packages: ${offerings.current!.availablePackages.length}');
        for (var package in offerings.current!.availablePackages) {
          debugPrint(
              '  - ${package.packageType}: ${package.storeProduct.priceString}');
        }
        return offerings.current!.availablePackages;
      }

      debugPrint('⚠️ No offerings available');
      return [];
    } catch (e) {
      debugPrint('❌ Failed to get offerings: $e');
      return [];
    }
  }

  /// 구독 구매
  ///
  /// 구매 성공 시 RevenueCat Webhook이 Supabase Edge Function을 호출하여
  /// subscription_user 테이블을 업데이트합니다.
  Future<bool> purchasePackage(Package package) async {
    try {
      debugPrint('🛒 Purchasing package: ${package.packageType}');

      CustomerInfo customerInfo = await Purchases.purchasePackage(package);

      // 구매 후 구독 상태 동기화
      await _syncSubscriptionStatus(customerInfo);

      // Pro 권한 확인
      bool isPro = customerInfo.entitlements.active.containsKey(_proEntitlementId);
      debugPrint('✅ Purchase successful. Is Pro: $isPro');

      return isPro;
    } on PurchasesErrorCode catch (e) {
      if (e == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('ℹ️ Purchase cancelled by user');
        return false;
      }
      debugPrint('❌ Purchase failed: $e');
      rethrow;
    }
  }

  /// 구독 복원 (기기 변경 시)
  ///
  /// 사용자가 기기를 변경하거나 앱을 재설치한 경우
  /// 이전에 구매한 구독을 복원합니다.
  Future<bool> restorePurchases() async {
    try {
      debugPrint('🔄 Restoring purchases...');

      CustomerInfo customerInfo = await Purchases.restorePurchases();

      await _syncSubscriptionStatus(customerInfo);

      bool isPro = customerInfo.entitlements.active.containsKey(_proEntitlementId);
      debugPrint('✅ Restore successful. Is Pro: $isPro');

      return isPro;
    } catch (e) {
      debugPrint('❌ Restore failed: $e');
      return false;
    }
  }

  /// 현재 구독 상태 확인
  Future<bool> checkProStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey(_proEntitlementId);
    } catch (e) {
      debugPrint('❌ Failed to check pro status: $e');
      return false;
    }
  }

  /// 현재 고객 정보 가져오기
  Future<CustomerInfo?> getCustomerInfo() async {
    try {
      return await Purchases.getCustomerInfo();
    } catch (e) {
      debugPrint('❌ Failed to get customer info: $e');
      return null;
    }
  }

  /// 구독 상태를 Supabase와 동기화 (클라이언트 측 백업)
  ///
  /// 참고: 메인 동기화는 RevenueCat Webhook → Supabase Edge Function으로 처리됨
  /// 이 메서드는 클라이언트 측에서 로컬 상태를 업데이트하는 용도입니다.
  Future<void> _syncSubscriptionStatus(CustomerInfo customerInfo) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return;

      bool isPro = customerInfo.entitlements.active.containsKey(_proEntitlementId);

      // 구독 정보 로깅 (디버그용)
      debugPrint('📊 Subscription Status:');
      debugPrint('  - User ID: $userId');
      debugPrint('  - Is Pro: $isPro');
      debugPrint(
          '  - Active Entitlements: ${customerInfo.entitlements.active.keys}');

      if (isPro) {
        final entitlement = customerInfo.entitlements.active[_proEntitlementId]!;
        debugPrint('  - Product ID: ${entitlement.productIdentifier}');
        debugPrint('  - Expires: ${entitlement.expirationDate}');
        debugPrint('  - Will Renew: ${entitlement.willRenew}');
      }

      // 참고: 실제 DB 업데이트는 Webhook에서 처리
      // 여기서는 디버그 로깅만 수행
    } catch (e) {
      debugPrint('❌ Sync failed: $e');
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
}
