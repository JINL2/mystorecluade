/// Domain entity for update session items response
/// Clean Architecture: Domain layer entity - no dependencies on Data layer

/// Individual updated item result
class UpdatedItem {
  final String itemId;
  final String productId;
  final int quantity;
  final int quantityRejected;
  final String action; // 'updated' or 'inserted'
  final int consolidatedCount;

  const UpdatedItem({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.quantityRejected,
    required this.action,
    required this.consolidatedCount,
  });

  bool get isUpdated => action == 'updated';
  bool get isInserted => action == 'inserted';
}

/// Summary of update operation
class UpdateSummary {
  final int totalUpdated;
  final int totalInserted;
  final int totalConsolidated;

  const UpdateSummary({
    required this.totalUpdated,
    required this.totalInserted,
    required this.totalConsolidated,
  });

  int get totalProcessed => totalUpdated + totalInserted;
}

/// Response entity for update session items
class UpdateSessionItemsResponse {
  final bool success;
  final String sessionId;
  final String userId;
  final List<UpdatedItem> updated;
  final UpdateSummary summary;
  final String? message;

  const UpdateSessionItemsResponse({
    required this.success,
    required this.sessionId,
    required this.userId,
    required this.updated,
    required this.summary,
    this.message,
  });

  bool get hasUpdates => updated.isNotEmpty;
  int get itemsProcessed => summary.totalProcessed;
}
