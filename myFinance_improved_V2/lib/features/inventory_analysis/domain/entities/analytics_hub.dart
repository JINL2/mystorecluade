import 'package:freezed_annotation/freezed_annotation.dart';

import 'sales_dashboard.dart';
import 'supply_chain_status.dart';
import 'discrepancy_overview.dart';
import 'inventory_optimization.dart';

part 'analytics_hub.freezed.dart';

/// Hub 페이지용 카드 요약 데이터
@freezed
class AnalyticsSummaryCard with _$AnalyticsSummaryCard {
  const factory AnalyticsSummaryCard({
    required String title,
    required String status, // 'good', 'warning', 'critical', 'insufficient'
    required String statusText,
    required String primaryMetric,
    String? secondaryMetric,
  }) = _AnalyticsSummaryCard;
}

/// Analytics Hub 전체 상태
/// 4개 RPC 결과를 종합
@freezed
class AnalyticsHubData with _$AnalyticsHubData {
  const AnalyticsHubData._();

  const factory AnalyticsHubData({
    required SalesDashboard? salesDashboard,
    required SupplyChainStatus? supplyChainStatus,
    required DiscrepancyOverview? discrepancyOverview,
    required InventoryOptimization? inventoryOptimization,
  }) = _AnalyticsHubData;

  /// 수익률 분석 카드 데이터
  AnalyticsSummaryCard get salesCard {
    if (salesDashboard == null) {
      return const AnalyticsSummaryCard(
        title: '수익률 분석',
        status: 'insufficient',
        statusText: '데이터 없음',
        primaryMetric: '-',
      );
    }

    final growth = salesDashboard!.growth;
    return AnalyticsSummaryCard(
      title: '수익률 분석',
      status: salesDashboard!.status,
      statusText: '이번 달 vs 지난 달',
      primaryMetric: '${growth.revenuePct >= 0 ? '+' : ''}${growth.revenuePct.toStringAsFixed(1)}% 성장',
      secondaryMetric: _formatCurrency(salesDashboard!.thisMonth.revenue),
    );
  }

  /// 재고 최적화 카드 데이터
  AnalyticsSummaryCard get optimizationCard {
    if (inventoryOptimization == null) {
      return const AnalyticsSummaryCard(
        title: '재고 최적화',
        status: 'insufficient',
        statusText: '데이터 없음',
        primaryMetric: '-',
      );
    }

    final opt = inventoryOptimization!;
    final criticalText = opt.criticalCount > 0 ? '긴급 ${opt.criticalCount}개' : null;

    return AnalyticsSummaryCard(
      title: '재고 최적화',
      status: opt.criticalCount > 0 ? 'critical' : opt.status,
      statusText: opt.statusText,
      primaryMetric: '점수 ${opt.overallScore}/100',
      secondaryMetric: criticalText,
    );
  }

  /// 공급망 분석 카드 데이터
  AnalyticsSummaryCard get supplyChainCard {
    if (supplyChainStatus == null) {
      return const AnalyticsSummaryCard(
        title: '공급망 분석',
        status: 'insufficient',
        statusText: '데이터 없음',
        primaryMetric: '-',
      );
    }

    final sc = supplyChainStatus!;
    return AnalyticsSummaryCard(
      title: '공급망 분석',
      status: sc.status,
      statusText: sc.isEmpty ? '공급망 정상' : '문제 제품 발견',
      primaryMetric: sc.statusText,
      secondaryMetric: sc.isEmpty ? null : '적분값 기준',
    );
  }

  /// 재고 불일치 카드 데이터
  AnalyticsSummaryCard get discrepancyCard {
    if (discrepancyOverview == null) {
      return const AnalyticsSummaryCard(
        title: '재고 불일치',
        status: 'insufficient',
        statusText: '데이터 없음',
        primaryMetric: '-',
      );
    }

    final disc = discrepancyOverview!;
    if (disc.isInsufficientData) {
      return AnalyticsSummaryCard(
        title: '재고 불일치',
        status: 'insufficient',
        statusText: disc.message ?? '데이터 부족',
        primaryMetric: '${disc.totalEvents}건 이벤트',
        secondaryMetric: disc.minRequired,
      );
    }

    return AnalyticsSummaryCard(
      title: '재고 불일치',
      status: disc.analysisStatus,
      statusText: '${disc.totalStores}개 매장 분석',
      primaryMetric: _formatCurrency(disc.netValue),
      secondaryMetric: disc.abnormalStoreCount > 0
          ? '이상 ${disc.abnormalStoreCount}개 매장'
          : null,
    );
  }

  /// 금액 포맷팅 헬퍼
  static String _formatCurrency(num value) {
    if (value.abs() >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
