import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/revenue_period.dart';

part 'revenue_model.freezed.dart';
part 'revenue_model.g.dart';

/// Revenue Model - handles JSON serialization and domain conversion
///
/// Consolidates DTO and Mapper responsibilities:
/// - JSON serialization (via freezed + json_serializable)
/// - Conversion to/from domain entities
/// - Maps Supabase RPC response to domain Revenue entity
@freezed
class RevenueModel with _$RevenueModel {
  const RevenueModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RevenueModel({
    required double amount,
    required String currencySymbol,
    required String period,
    @Default(0.0) double comparisonAmount,
    String? comparisonPeriod,
    DateTime? lastUpdated,
    String? storeId,
    String? companyId,
  }) = _RevenueModel;

  /// Create from JSON (Supabase RPC response)
  factory RevenueModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueModelFromJson(json);

  /// Convert Model to Domain Entity
  Revenue toDomain() {
    return Revenue(
      amount: amount,
      currencyCode: currencySymbol,
      period: RevenuePeriod.fromString(period),
      previousAmount: comparisonAmount,
      lastUpdated: lastUpdated ?? DateTime.now(),
      storeId: storeId,
      companyId: companyId,
    );
  }

  /// Create Model from Domain Entity
  factory RevenueModel.fromDomain(Revenue entity) {
    return RevenueModel(
      amount: entity.amount,
      currencySymbol: entity.currencyCode,
      period: entity.period.name,
      comparisonAmount: entity.previousAmount,
      comparisonPeriod: entity.period.comparisonText,
      lastUpdated: entity.lastUpdated,
      storeId: entity.storeId,
      companyId: entity.companyId,
    );
  }
}
