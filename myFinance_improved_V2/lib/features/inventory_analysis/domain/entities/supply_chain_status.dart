import 'package:freezed_annotation/freezed_annotation.dart';

part 'supply_chain_status.freezed.dart';

/// 위험 수준 enum
enum RiskLevel {
  critical,
  warning,
  normal,
}

/// 공급망 문제 제품 데이터
/// Error Integral = 지연일수 × 평균 부족수량
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

  /// 위험도 라벨
  String get riskLabel {
    return switch (riskLevelType) {
      RiskLevel.critical => '심각',
      RiskLevel.warning => '주의',
      RiskLevel.normal => '정상',
    };
  }

  /// Error Integral 설명 문자열
  String get integralDescription =>
      '${shortageDays}일 × 평균 ${avgShortagePerDay.toStringAsFixed(1)}개 지연';
}

/// 공급망 상태 종합 데이터
/// RPC: get_supply_chain_status 응답
@freezed
class SupplyChainStatus with _$SupplyChainStatus {
  const SupplyChainStatus._();

  const factory SupplyChainStatus({
    required List<SupplyChainProduct> urgentProducts,
  }) = _SupplyChainStatus;

  /// Critical 제품 수
  int get criticalCount =>
      urgentProducts.where((p) => p.riskLevelType == RiskLevel.critical).length;

  /// Warning 제품 수
  int get warningCount =>
      urgentProducts.where((p) => p.riskLevelType == RiskLevel.warning).length;

  /// 전체 상태 판정
  String get status {
    if (criticalCount > 0) return 'critical';
    if (warningCount > 0) return 'warning';
    return 'good';
  }

  /// 데이터 없음 여부
  bool get isEmpty => urgentProducts.isEmpty;

  /// 상태 텍스트
  String get statusText {
    if (isEmpty) return '위험 제품 없음';
    if (criticalCount > 0) return '심각 $criticalCount개';
    if (warningCount > 0) return '주의 $warningCount개';
    return '정상';
  }
}
