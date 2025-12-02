// Value Object: Pagination Parameters
// Encapsulates pagination configuration

class PaginationParams {
  // Constants
  static const int defaultPageNumber = 1;
  static const int defaultPageSize = 10;

  final int page;
  final int limit;

  const PaginationParams({
    this.page = defaultPageNumber,
    this.limit = defaultPageSize,
  });

  // Default pagination
  static const PaginationParams defaultParams = PaginationParams();

  // Calculate offset for database queries
  int get offset => (page - 1) * limit;

  // Next page
  PaginationParams nextPage() {
    return PaginationParams(
      page: page + 1,
      limit: limit,
    );
  }

  // Previous page
  PaginationParams previousPage() {
    return PaginationParams(
      page: page > 1 ? page - 1 : 1,
      limit: limit,
    );
  }

  // First page
  PaginationParams firstPage() {
    return PaginationParams(
      page: 1,
      limit: limit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginationParams &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode => page.hashCode ^ limit.hashCode;
}

// Pagination Result
class PaginationResult {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationResult({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationResult.fromTotal({
    required int page,
    required int limit,
    required int total,
  }) {
    assert(limit > 0, 'Limit must be greater than 0');

    // Fail-safe: use default limit if invalid
    final safeLimit = limit > 0 ? limit : 10;
    final totalPages = (total / safeLimit).ceil();

    return PaginationResult(
      page: page,
      limit: safeLimit,
      total: total,
      totalPages: totalPages > 0 ? totalPages : 1,
      hasNext: page < totalPages,
      hasPrevious: page > 1,
    );
  }
}
