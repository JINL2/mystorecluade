import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_dashboard.freezed.dart';

/// 월별 매출 데이터
@freezed
class MonthlyMetrics with _$MonthlyMetrics {
  const factory MonthlyMetrics({
    required num revenue,
    required num margin,
    required num marginRate,
    required int quantity,
  }) = _MonthlyMetrics;
}

/// 성장률 데이터
@freezed
class GrowthMetrics with _$GrowthMetrics {
  const factory GrowthMetrics({
    required num revenuePct,
    required num marginPct,
    required num quantityPct,
  }) = _GrowthMetrics;
}

/// 수익률 대시보드 종합 데이터
/// RPC: get_sales_dashboard 응답
@freezed
class SalesDashboard with _$SalesDashboard {
  const SalesDashboard._();

  const factory SalesDashboard({
    required MonthlyMetrics thisMonth,
    required MonthlyMetrics lastMonth,
    required GrowthMetrics growth,
  }) = _SalesDashboard;

  /// 사업 상태 판정
  /// - good: 매출/마진 모두 양수 성장
  /// - warning: 하나만 양수 성장
  /// - critical: 모두 음수 성장
  String get status {
    final revenueGood = growth.revenuePct > 0;
    final marginGood = growth.marginPct > 0;

    if (revenueGood && marginGood) return 'good';
    if (revenueGood || marginGood) return 'warning';
    return 'critical';
  }

  /// 주의사항 목록 생성
  List<String> get warnings {
    final List<String> result = [];

    if (growth.revenuePct < 0) {
      result.add('매출 ${growth.revenuePct.toStringAsFixed(1)}% 감소');
    }
    if (growth.marginPct < 0) {
      result.add('마진 ${growth.marginPct.toStringAsFixed(1)}% 감소');
    }
    if (growth.quantityPct < -20) {
      result.add('판매량 ${growth.quantityPct.toStringAsFixed(1)}% 급감');
    }
    if (thisMonth.marginRate < 50) {
      result.add('마진율 ${thisMonth.marginRate.toStringAsFixed(1)}% (목표 미달)');
    }

    return result;
  }
}
