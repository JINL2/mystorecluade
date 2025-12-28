import 'package:supabase_flutter/supabase_flutter.dart';

/// Subscription Plans DataSource
///
/// 구독 플랜 정보를 Supabase에서 가져오는 DataSource
class SubscriptionDataSource {
  final _supabase = Supabase.instance.client;

  /// 활성화된 구독 플랜 목록 가져오기
  Future<List<Map<String, dynamic>>> getActiveSubscriptionPlans() async {
    try {
      final response = await _supabase
          .from('subscription_plans')
          .select()
          .eq('is_active', true)
          .order('sort_order');

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw Exception('Failed to get subscription plans: $e');
    }
  }

  /// 특정 플랜 이름으로 조회
  Future<Map<String, dynamic>?> getSubscriptionPlanByName(String planName) async {
    try {
      final response = await _supabase
          .from('subscription_plans')
          .select()
          .eq('plan_name', planName)
          .eq('is_active', true)
          .maybeSingle();

      return response;
    } catch (e) {
      return null;
    }
  }
}
