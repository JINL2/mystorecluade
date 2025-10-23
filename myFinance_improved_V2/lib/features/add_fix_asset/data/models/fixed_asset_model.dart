import '../../domain/entities/fixed_asset.dart';
import '../../domain/value_objects/asset_financial_info.dart';

/// Fixed Asset Data Transfer Object (DTO) + Mapper
/// Supabase JSON <-> Domain Entity 변환
class FixedAssetModel {
  final String? assetId;
  final String assetName;
  final String acquisitionDate;
  final double acquisitionCost;
  final double salvageValue;
  final int usefulLifeYears;
  final String companyId;
  final String? storeId;
  final String? createdAt;
  final String status;

  const FixedAssetModel({
    this.assetId,
    required this.assetName,
    required this.acquisitionDate,
    required this.acquisitionCost,
    required this.salvageValue,
    required this.usefulLifeYears,
    required this.companyId,
    this.storeId,
    this.createdAt,
    this.status = 'active',
  });

  /// JSON → Model
  factory FixedAssetModel.fromJson(Map<String, dynamic> json) {
    return FixedAssetModel(
      assetId: json['asset_id'] as String?,
      assetName: json['asset_name'] as String,
      acquisitionDate: json['acquisition_date'] as String,
      acquisitionCost: ((json['acquisition_cost'] ?? 0) as num).toDouble(),
      salvageValue: ((json['salvage_value'] ?? 0) as num).toDouble(),
      usefulLifeYears: ((json['useful_life_years'] ?? 0) as num).toInt(),
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      createdAt: json['created_at'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      if (assetId != null) 'asset_id': assetId,
      'asset_name': assetName,
      'acquisition_date': acquisitionDate,
      'acquisition_cost': acquisitionCost,
      'salvage_value': salvageValue,
      'useful_life_years': usefulLifeYears,
      'company_id': companyId,
      'store_id': storeId,
      if (createdAt != null) 'created_at': createdAt,
      'status': status,
    };
  }

  /// Model → Domain Entity
  FixedAsset toEntity() {
    return FixedAsset(
      assetId: assetId,
      assetName: assetName,
      acquisitionDate: DateTime.parse(acquisitionDate),
      financialInfo: AssetFinancialInfo(
        acquisitionCost: acquisitionCost,
        salvageValue: salvageValue,
        usefulLifeYears: usefulLifeYears,
      ),
      companyId: companyId,
      storeId: storeId,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      status: status,
    );
  }

  /// Domain Entity → Model
  factory FixedAssetModel.fromEntity(FixedAsset entity) {
    return FixedAssetModel(
      assetId: entity.assetId,
      assetName: entity.assetName,
      acquisitionDate: entity.acquisitionDate.toIso8601String(),
      acquisitionCost: entity.financialInfo.acquisitionCost,
      salvageValue: entity.financialInfo.salvageValue,
      usefulLifeYears: entity.financialInfo.usefulLifeYears,
      companyId: entity.companyId,
      storeId: entity.storeId,
      createdAt: entity.createdAt?.toIso8601String(),
      status: entity.status,
    );
  }
}
