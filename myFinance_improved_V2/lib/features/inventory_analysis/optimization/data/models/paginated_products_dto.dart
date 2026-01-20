import '../../domain/entities/paginated_products.dart';
import 'inventory_product_dto.dart';

/// PaginatedProducts DTO
/// get_reorder_products_paged RPC 응답에서 변환
class PaginatedProductsDto {
  final List<InventoryProductDto> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedProductsDto({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory PaginatedProductsDto.fromJson(Map<String, dynamic> json) {
    // items 파싱
    List<InventoryProductDto> items = [];
    final itemsJson = json['items'];
    if (itemsJson is List) {
      items = itemsJson
          .whereType<Map<String, dynamic>>()
          .map((e) => InventoryProductDto.fromJson(e))
          .toList();
    }

    return PaginatedProductsDto(
      items: items,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  PaginatedProducts toEntity() {
    return PaginatedProducts(
      items: items.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      page: page,
      pageSize: pageSize,
      hasMore: hasMore,
    );
  }
}
