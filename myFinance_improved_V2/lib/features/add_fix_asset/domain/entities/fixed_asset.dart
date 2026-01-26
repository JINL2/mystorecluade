import '../value_objects/asset_financial_info.dart';
import '../value_objects/depreciation_info.dart';

/// Fixed Asset domain entity
/// 고정자산 도메인 엔티티
class FixedAsset {
  final String? assetId;
  final String assetName;
  final DateTime acquisitionDate;
  final AssetFinancialInfo financialInfo;
  final String companyId;
  final String? storeId; // null = headquarters
  final String? accountId; // 계정 ID (고정자산 계정)
  final DateTime? createdAt;

  const FixedAsset({
    this.assetId,
    required this.assetName,
    required this.acquisitionDate,
    required this.financialInfo,
    required this.companyId,
    this.storeId,
    this.accountId,
    this.createdAt,
  });

  /// 감가상각 정보 계산
  DepreciationInfo calculateDepreciation() {
    return DepreciationInfo.calculate(
      acquisitionCost: financialInfo.acquisitionCost,
      salvageValue: financialInfo.salvageValue,
      usefulLifeYears: financialInfo.usefulLifeYears,
      acquisitionDate: acquisitionDate,
    );
  }

  /// 본사 자산 여부
  bool get isHeadquartersAsset => storeId == null || storeId!.isEmpty;

  /// 유효성 검증
  bool get isValid {
    return assetName.isNotEmpty &&
        companyId.isNotEmpty &&
        financialInfo.isValid;
  }

  /// Copy with method
  FixedAsset copyWith({
    String? assetId,
    String? assetName,
    DateTime? acquisitionDate,
    AssetFinancialInfo? financialInfo,
    String? companyId,
    String? storeId,
    String? accountId,
    DateTime? createdAt,
  }) {
    return FixedAsset(
      assetId: assetId ?? this.assetId,
      assetName: assetName ?? this.assetName,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      financialInfo: financialInfo ?? this.financialInfo,
      companyId: companyId ?? this.companyId,
      storeId: storeId ?? this.storeId,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FixedAsset &&
        other.assetId == assetId &&
        other.assetName == assetName &&
        other.acquisitionDate == acquisitionDate &&
        other.financialInfo == financialInfo &&
        other.companyId == companyId &&
        other.storeId == storeId &&
        other.accountId == accountId;
  }

  @override
  int get hashCode {
    return assetId.hashCode ^
        assetName.hashCode ^
        acquisitionDate.hashCode ^
        financialInfo.hashCode ^
        companyId.hashCode ^
        storeId.hashCode ^
        accountId.hashCode;
  }
}
