import 'package:freezed_annotation/freezed_annotation.dart';

import 'inventory_product.dart';

part 'paginated_products.freezed.dart';

/// 페이지네이션 상품 목록 Entity
/// get_reorder_products_paged RPC 응답
@freezed
class PaginatedProducts with _$PaginatedProducts {
  const PaginatedProducts._();

  const factory PaginatedProducts({
    /// 상품 목록
    required List<InventoryProduct> items,

    /// 전체 개수
    required int totalCount,

    /// 현재 페이지 (0-indexed)
    required int page,

    /// 페이지 크기
    required int pageSize,

    /// 더 있는지
    required bool hasMore,
  }) = _PaginatedProducts;

  /// 총 페이지 수
  int get totalPages => (totalCount / pageSize).ceil();

  /// 현재 페이지 (1-indexed, 표시용)
  int get displayPage => page + 1;

  /// 빈 목록인지
  bool get isEmpty => items.isEmpty;

  /// 첫 페이지인지
  bool get isFirstPage => page == 0;

  /// 마지막 페이지인지
  bool get isLastPage => !hasMore;

  /// Mock 데이터 (스켈레톤용)
  static PaginatedProducts mock() => PaginatedProducts(
        items: InventoryProduct.mockList(10),
        totalCount: 0,
        page: 0,
        pageSize: 20,
        hasMore: false,
      );

  /// 빈 결과
  static PaginatedProducts empty() => const PaginatedProducts(
        items: [],
        totalCount: 0,
        page: 0,
        pageSize: 20,
        hasMore: false,
      );
}
