import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscription Plans DataSource
///
/// 구독 플랜 정보를 RPC를 통해 가져오는 DataSource
class SubscriptionDataSource {
  final _supabase = Supabase.instance.client;

  /// 활성화된 구독 플랜 목록 가져오기 (RPC 사용)
  ///
  /// Returns list of active subscription plans sorted by sort_order
  Future<List<Map<String, dynamic>>> getActiveSubscriptionPlans() async {
    try {
      final response = await _supabase.rpc<List<dynamic>?>(
        'my_page_get_subscription_plans',
      );

      if (response == null || response.isEmpty) return [];
      return List<Map<String, dynamic>>.from(
        response.map((item) => Map<String, dynamic>.from(item as Map)),
      );
    } catch (e) {
      throw Exception('Failed to get subscription plans: $e');
    }
  }

  /// 특정 플랜 이름으로 조회
  ///
  /// Uses cached data from getActiveSubscriptionPlans
  Future<Map<String, dynamic>?> getSubscriptionPlanByName(String planName) async {
    try {
      final plans = await getActiveSubscriptionPlans();
      return plans.firstWhere(
        (plan) => plan['plan_name'] == planName,
        orElse: () => <String, dynamic>{},
      );
    } catch (e) {
      return null;
    }
  }
}
