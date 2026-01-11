import 'package:freezed_annotation/freezed_annotation.dart';

part 'supply_chain_status.freezed.dart';

/// Risk level enum
enum RiskLevel {
  critical,
  warning,
  normal,
}

/// Supply chain problem product data
/// Error Integral = shortage_days × avg_shortage_per_day
@freezed
class SupplyChainProduct with _$SupplyChainProduct {
  const SupplyChainProduct._();

  const factory SupplyChainProduct({
    required String productId,
    required String productName,
    required int shortageDays,
    required num avgShortagePerDay,
    required num totalShortage,
    required num errorIntegral,
    required String riskLevel, // 'Critical', 'Warning', 'Normal'
  }) = _SupplyChainProduct;

  RiskLevel get riskLevelType {
    return switch (riskLevel) {
      'Critical' => RiskLevel.critical,
      'Warning' => RiskLevel.warning,
      _ => RiskLevel.normal,
    };
  }

  /// Risk label
  String get riskLabel {
    return switch (riskLevelType) {
      RiskLevel.critical => 'Critical',
      RiskLevel.warning => 'Warning',
      RiskLevel.normal => 'Normal',
    };
  }

  /// Error Integral description
  String get integralDescription =>
      '${shortageDays} days × avg ${avgShortagePerDay.toStringAsFixed(1)} shortage';
}

/// Supply chain status aggregate data
/// RPC: get_supply_chain_status response
@freezed
class SupplyChainStatus with _$SupplyChainStatus {
  const SupplyChainStatus._();

  const factory SupplyChainStatus({
    required List<SupplyChainProduct> urgentProducts,
  }) = _SupplyChainStatus;

  /// Critical product count
  int get criticalCount =>
      urgentProducts.where((p) => p.riskLevelType == RiskLevel.critical).length;

  /// Warning product count
  int get warningCount =>
      urgentProducts.where((p) => p.riskLevelType == RiskLevel.warning).length;

  /// Overall status
  String get status {
    if (criticalCount > 0) return 'critical';
    if (warningCount > 0) return 'warning';
    return 'good';
  }

  /// Whether data is empty
  bool get isEmpty => urgentProducts.isEmpty;

  /// Status text
  String get statusText {
    if (isEmpty) return 'No risk products';
    if (criticalCount > 0) return '$criticalCount critical';
    if (warningCount > 0) return '$warningCount warning';
    return 'Normal';
  }
}
