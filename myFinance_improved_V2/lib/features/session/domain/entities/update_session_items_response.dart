import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_session_items_response.freezed.dart';

/// Individual updated item result
@freezed
class UpdatedItem with _$UpdatedItem {
  const UpdatedItem._();

  const factory UpdatedItem({
    required String itemId,
    required String productId,
    required int quantity,
    required int quantityRejected,
    required String action, // 'updated' or 'inserted'
    required int consolidatedCount,
  }) = _UpdatedItem;

  bool get isUpdated => action == 'updated';
  bool get isInserted => action == 'inserted';
}

/// Summary of update operation
@freezed
class UpdateSummary with _$UpdateSummary {
  const UpdateSummary._();

  const factory UpdateSummary({
    required int totalUpdated,
    required int totalInserted,
    required int totalConsolidated,
  }) = _UpdateSummary;

  int get totalProcessed => totalUpdated + totalInserted;
}

/// Response entity for update session items
@freezed
class UpdateSessionItemsResponse with _$UpdateSessionItemsResponse {
  const UpdateSessionItemsResponse._();

  const factory UpdateSessionItemsResponse({
    required bool success,
    required String sessionId,
    required String userId,
    required List<UpdatedItem> updated,
    required UpdateSummary summary,
    String? message,
  }) = _UpdateSessionItemsResponse;

  bool get hasUpdates => updated.isNotEmpty;
  int get itemsProcessed => summary.totalProcessed;
}
