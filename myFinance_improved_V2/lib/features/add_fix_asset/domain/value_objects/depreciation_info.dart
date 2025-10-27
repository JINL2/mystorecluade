/// Depreciation information value object
/// 감가상각 정보를 계산하고 보관하는 불변 객체
class DepreciationInfo {
  final double annualDepreciation;
  final double currentValue;
  final double depreciationRate;

  const DepreciationInfo({
    required this.annualDepreciation,
    required this.currentValue,
    required this.depreciationRate,
  });

  /// 정액법으로 감가상각 정보 계산
  /// Straight-line depreciation calculation
  factory DepreciationInfo.calculate({
    required double acquisitionCost,
    required double salvageValue,
    required int usefulLifeYears,
    required DateTime acquisitionDate,
  }) {
    // 연간 감가상각비 계산
    final annualDepreciation = usefulLifeYears > 0
        ? (acquisitionCost - salvageValue) / usefulLifeYears
        : 0.0;

    // 현재까지 경과한 연수 계산
    final yearsOwned = DateTime.now().difference(acquisitionDate).inDays / 365;

    // 누적 감가상각비 계산
    final totalDepreciation = annualDepreciation * yearsOwned;

    // 현재 가치 계산 (잔존가치 이하로 떨어지지 않음)
    final calculatedValue = acquisitionCost - totalDepreciation;
    final currentValue = calculatedValue > salvageValue ? calculatedValue : salvageValue;

    // 감가상각률 계산 (%)
    final depreciationRate = acquisitionCost > 0
        ? ((acquisitionCost - currentValue) / acquisitionCost * 100)
        : 0.0;

    return DepreciationInfo(
      annualDepreciation: annualDepreciation,
      currentValue: currentValue,
      depreciationRate: depreciationRate,
    );
  }

  /// 초기 상태 (계산 전)
  factory DepreciationInfo.initial() {
    return const DepreciationInfo(
      annualDepreciation: 0.0,
      currentValue: 0.0,
      depreciationRate: 0.0,
    );
  }
}
