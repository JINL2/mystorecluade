import '../../domain/entities/update_session_items_response.dart';

/// Response model for inventory_update_session_item RPC

/// Individual updated item result (Model)
class UpdatedItemModel {
  final String itemId;
  final String productId;
  final int quantity;
  final int quantityRejected;
  final String action; // 'updated' or 'inserted'
  final int consolidatedCount;

  const UpdatedItemModel({
    required this.itemId,
    required this.productId,
    required this.quantity,
    required this.quantityRejected,
    required this.action,
    required this.consolidatedCount,
  });

  factory UpdatedItemModel.fromJson(Map<String, dynamic> json) {
    return UpdatedItemModel(
      itemId: json['item_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
      action: json['action']?.toString() ?? 'updated',
      consolidatedCount: (json['consolidated_count'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isUpdated => action == 'updated';
  bool get isInserted => action == 'inserted';

  /// Convert to domain entity
  UpdatedItem toEntity() {
    return UpdatedItem(
      itemId: itemId,
      productId: productId,
      quantity: quantity,
      quantityRejected: quantityRejected,
      action: action,
      consolidatedCount: consolidatedCount,
    );
  }
}

/// Summary of update operation (Model)
class UpdateSummaryModel {
  final int totalUpdated;
  final int totalInserted;
  final int totalConsolidated;

  const UpdateSummaryModel({
    required this.totalUpdated,
    required this.totalInserted,
    required this.totalConsolidated,
  });

  factory UpdateSummaryModel.fromJson(Map<String, dynamic> json) {
    return UpdateSummaryModel(
      totalUpdated: (json['total_updated'] as num?)?.toInt() ?? 0,
      totalInserted: (json['total_inserted'] as num?)?.toInt() ?? 0,
      totalConsolidated: (json['total_consolidated'] as num?)?.toInt() ?? 0,
    );
  }

  int get totalProcessed => totalUpdated + totalInserted;

  /// Convert to domain entity
  UpdateSummary toEntity() {
    return UpdateSummary(
      totalUpdated: totalUpdated,
      totalInserted: totalInserted,
      totalConsolidated: totalConsolidated,
    );
  }
}

/// Response model for inventory_update_session_item RPC
class UpdateSessionItemsResponseModel {
  final bool success;
  final String sessionId;
  final String userId;
  final List<UpdatedItemModel> updated;
  final UpdateSummaryModel summary;
  final String? message;

  const UpdateSessionItemsResponseModel({
    required this.success,
    required this.sessionId,
    required this.userId,
    required this.updated,
    required this.summary,
    this.message,
  });

  factory UpdateSessionItemsResponseModel.fromJson(
    Map<String, dynamic> json,
    String? message,
  ) {
    final updatedList = json['updated'] as List<dynamic>? ?? [];
    final updated = updatedList
        .map((e) => UpdatedItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};

    return UpdateSessionItemsResponseModel(
      success: true,
      sessionId: json['session_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      updated: updated,
      summary: UpdateSummaryModel.fromJson(summaryJson),
      message: message,
    );
  }

  bool get hasUpdates => updated.isNotEmpty;
  int get itemsProcessed => summary.totalProcessed;

  /// Convert to domain entity
  UpdateSessionItemsResponse toEntity() {
    return UpdateSessionItemsResponse(
      success: success,
      sessionId: sessionId,
      userId: userId,
      updated: updated.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
      message: message,
    );
  }
}
