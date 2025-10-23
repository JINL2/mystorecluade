/// Asset financial information value object
/// 고정자산의 재무 정보를 보관하는 불변 객체
class AssetFinancialInfo {
  final double acquisitionCost;
  final double salvageValue;
  final int usefulLifeYears;

  const AssetFinancialInfo({
    required this.acquisitionCost,
    required this.salvageValue,
    required this.usefulLifeYears,
  });

  /// 유효성 검증
  bool get isValid {
    return acquisitionCost > 0 &&
        salvageValue >= 0 &&
        usefulLifeYears > 0 &&
        salvageValue < acquisitionCost;
  }

  /// 감가상각 대상 금액 (취득가 - 잔존가치)
  double get depreciableAmount {
    return acquisitionCost - salvageValue;
  }

  /// Copy with method
  AssetFinancialInfo copyWith({
    double? acquisitionCost,
    double? salvageValue,
    int? usefulLifeYears,
  }) {
    return AssetFinancialInfo(
      acquisitionCost: acquisitionCost ?? this.acquisitionCost,
      salvageValue: salvageValue ?? this.salvageValue,
      usefulLifeYears: usefulLifeYears ?? this.usefulLifeYears,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AssetFinancialInfo &&
        other.acquisitionCost == acquisitionCost &&
        other.salvageValue == salvageValue &&
        other.usefulLifeYears == usefulLifeYears;
  }

  @override
  int get hashCode =>
      acquisitionCost.hashCode ^
      salvageValue.hashCode ^
      usefulLifeYears.hashCode;
}
