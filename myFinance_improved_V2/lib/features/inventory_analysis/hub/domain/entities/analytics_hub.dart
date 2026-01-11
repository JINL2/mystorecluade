import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../sales/domain/entities/sales_dashboard.dart';
import '../../../supply_chain/domain/entities/supply_chain_status.dart';
import '../../../discrepancy/domain/entities/discrepancy_overview.dart';
import '../../../optimization/domain/entities/inventory_optimization.dart';

part 'analytics_hub.freezed.dart';

/// Summary card data for Hub page
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

/// Analytics Hub overall state
/// Aggregates 4 RPC results
@freezed
class AnalyticsHubData with _$AnalyticsHubData {
  const AnalyticsHubData._();

  const factory AnalyticsHubData({
    required SalesDashboard? salesDashboard,
    required SupplyChainStatus? supplyChainStatus,
    required DiscrepancyOverview? discrepancyOverview,
    required InventoryOptimization? inventoryOptimization,
  }) = _AnalyticsHubData;

  /// Sales analysis card data
  AnalyticsSummaryCard get salesCard {
    if (salesDashboard == null) {
      return const AnalyticsSummaryCard(
        title: 'Sales Analysis',
        status: 'insufficient',
        statusText: 'No data',
        primaryMetric: '-',
      );
    }

    final growth = salesDashboard!.growth;
    return AnalyticsSummaryCard(
      title: 'Sales Analysis',
      status: salesDashboard!.status,
      statusText: 'This month vs Last month',
      primaryMetric: '${growth.revenuePct >= 0 ? '+' : ''}${growth.revenuePct.toStringAsFixed(1)}% growth',
      secondaryMetric: _formatCurrency(salesDashboard!.thisMonth.revenue),
    );
  }

  /// Inventory optimization card data
  AnalyticsSummaryCard get optimizationCard {
    if (inventoryOptimization == null) {
      return const AnalyticsSummaryCard(
        title: 'Inventory Optimization',
        status: 'insufficient',
        statusText: 'No data',
        primaryMetric: '-',
      );
    }

    final opt = inventoryOptimization!;
    final criticalText = opt.criticalCount > 0 ? '${opt.criticalCount} urgent' : null;

    return AnalyticsSummaryCard(
      title: 'Inventory Optimization',
      status: opt.criticalCount > 0 ? 'critical' : opt.status,
      statusText: opt.statusText,
      primaryMetric: 'Score ${opt.overallScore}/100',
      secondaryMetric: criticalText,
    );
  }

  /// Supply chain analysis card data
  AnalyticsSummaryCard get supplyChainCard {
    if (supplyChainStatus == null) {
      return const AnalyticsSummaryCard(
        title: 'Supply Chain',
        status: 'insufficient',
        statusText: 'No data',
        primaryMetric: '-',
      );
    }

    final sc = supplyChainStatus!;
    return AnalyticsSummaryCard(
      title: 'Supply Chain',
      status: sc.status,
      statusText: sc.isEmpty ? 'Supply chain normal' : 'Problem products found',
      primaryMetric: sc.statusText,
      secondaryMetric: sc.isEmpty ? null : 'Based on integral',
    );
  }

  /// Inventory discrepancy card data
  AnalyticsSummaryCard get discrepancyCard {
    if (discrepancyOverview == null) {
      return const AnalyticsSummaryCard(
        title: 'Discrepancy',
        status: 'insufficient',
        statusText: 'No data',
        primaryMetric: '-',
      );
    }

    final disc = discrepancyOverview!;
    if (disc.isInsufficientData) {
      return AnalyticsSummaryCard(
        title: 'Discrepancy',
        status: 'insufficient',
        statusText: disc.message ?? 'Insufficient data',
        primaryMetric: '${disc.totalEvents} events',
        secondaryMetric: disc.minRequired,
      );
    }

    return AnalyticsSummaryCard(
      title: 'Discrepancy',
      status: disc.analysisStatus,
      statusText: '${disc.totalStores} stores analyzed',
      primaryMetric: _formatCurrency(disc.netValue),
      secondaryMetric: disc.abnormalStoreCount > 0
          ? '${disc.abnormalStoreCount} abnormal stores'
          : null,
    );
  }

  /// Currency formatting helper
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
