import '../../domain/entities/inventory_dashboard.dart';
import 'category_summary_dto.dart';
import 'inventory_health_dto.dart';
import 'inventory_product_dto.dart';
import 'threshold_info_dto.dart';

/// InventoryDashboard DTO
/// get_inventory_health_dashboard RPC 응답에서 변환
class InventoryDashboardDto {
  final InventoryHealthDto health;
  final ThresholdInfoDto thresholds;
  final List<CategorySummaryDto> topCategories;
  final List<InventoryProductDto> urgentProducts;
  final List<InventoryProductDto> abnormalProducts;

  const InventoryDashboardDto({
    required this.health,
    required this.thresholds,
    required this.topCategories,
    required this.urgentProducts,
    required this.abnormalProducts,
  });

  factory InventoryDashboardDto.fromJson(Map<String, dynamic> json) {
    // health 파싱
    final healthJson = json['health'];
    final health = healthJson is Map<String, dynamic>
        ? InventoryHealthDto.fromJson(healthJson)
        : InventoryHealthDto.fromJson({});

    // thresholds 파싱
    final thresholdsJson = json['thresholds'];
    final thresholds = thresholdsJson is Map<String, dynamic>
        ? ThresholdInfoDto.fromJson(thresholdsJson)
        : ThresholdInfoDto.fromJson({});

    // top_categories 파싱
    List<CategorySummaryDto> topCategories = [];
    final categoriesJson = json['top_categories'];
    if (categoriesJson is List) {
      topCategories = categoriesJson
          .whereType<Map<String, dynamic>>()
          .map((e) => CategorySummaryDto.fromJson(e))
          .toList();
    }

    // urgent_products 파싱
    List<InventoryProductDto> urgentProducts = [];
    final urgentJson = json['urgent_products'];
    if (urgentJson is List) {
      urgentProducts = urgentJson
          .whereType<Map<String, dynamic>>()
          .map((e) => InventoryProductDto.fromJson(e))
          .toList();
    }

    // abnormal_products 파싱
    List<InventoryProductDto> abnormalProducts = [];
    final abnormalJson = json['abnormal_products'];
    if (abnormalJson is List) {
      abnormalProducts = abnormalJson
          .whereType<Map<String, dynamic>>()
          .map((e) => InventoryProductDto.fromJson(e))
          .toList();
    }

    return InventoryDashboardDto(
      health: health,
      thresholds: thresholds,
      topCategories: topCategories,
      urgentProducts: urgentProducts,
      abnormalProducts: abnormalProducts,
    );
  }

  InventoryDashboard toEntity() {
    return InventoryDashboard(
      health: health.toEntity(),
      thresholds: thresholds.toEntity(),
      topCategories: topCategories.map((e) => e.toEntity()).toList(),
      urgentProducts: urgentProducts.map((e) => e.toEntity()).toList(),
      abnormalProducts: abnormalProducts.map((e) => e.toEntity()).toList(),
    );
  }
}
