import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list_item.freezed.dart';

/// Session list item entity from RPC response
/// v2: Added status, supplierId, supplierName fields
@freezed
class SessionListItem with _$SessionListItem {
  const SessionListItem._();

  const factory SessionListItem({
    required String sessionId,
    required String sessionName,
    required String sessionType,
    /// Session status: 'in_progress', 'complete', 'cancelled'
    required String status,
    required String storeId,
    required String storeName,
    String? shipmentId,
    String? shipmentNumber,
    /// v2: Supplier info (via shipment connection)
    String? supplierId,
    String? supplierName,
    required bool isActive,
    required bool isFinal,
    required int memberCount,
    required String createdBy,
    required String createdByName,
    String? completedAt,
    required String createdAt,
  }) = _SessionListItem;

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';

  /// v2: Status helpers
  bool get isInProgress => status == 'in_progress';
  bool get isComplete => status == 'complete';
  bool get isCancelled => status == 'cancelled';
}

/// Response wrapper for session list
@freezed
class SessionListResponse with _$SessionListResponse {
  const SessionListResponse._();

  const factory SessionListResponse({
    required List<SessionListItem> sessions,
    required int totalCount,
    required int limit,
    required int offset,
  }) = _SessionListResponse;

  bool get hasMore => offset + sessions.length < totalCount;
}
