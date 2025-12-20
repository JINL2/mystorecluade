import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_history_item.freezed.dart';

/// Member info in session history
@freezed
class SessionHistoryMember with _$SessionHistoryMember {
  const factory SessionHistoryMember({
    required String oderId,
    required String userName,
    required String joinedAt,
    required bool isActive,
  }) = _SessionHistoryMember;
}

/// Scanned by info for item
@freezed
class ScannedByInfo with _$ScannedByInfo {
  const factory ScannedByInfo({
    required String userId,
    required String userName,
    required int quantity,
    required int quantityRejected,
  }) = _ScannedByInfo;
}

/// Item info in session history
@freezed
class SessionHistoryItemDetail with _$SessionHistoryItemDetail {
  const SessionHistoryItemDetail._();

  const factory SessionHistoryItemDetail({
    required String productId,
    required String productName,
    String? sku,

    /// Scanned by employees (from inventory_session_items)
    required int scannedQuantity,
    required int scannedRejected,
    required List<ScannedByInfo> scannedBy,

    /// Confirmed by manager (from receiving_items or counting_items)
    /// Null if session is still active (not submitted yet)
    int? confirmedQuantity,
    int? confirmedRejected,

    /// Counting specific fields
    int? quantityExpected,
    int? quantityDifference,
  }) = _SessionHistoryItemDetail;

  /// Check if manager has confirmed this item
  bool get hasConfirmed => confirmedQuantity != null;

  /// Check if manager changed the quantity (edited from scanned)
  bool get wasEdited => hasConfirmed && confirmedQuantity != scannedQuantity;

  /// Get the final quantity (confirmed if available, otherwise scanned)
  int get finalQuantity => confirmedQuantity ?? scannedQuantity;

  /// Get the final rejected (confirmed if available, otherwise scanned)
  int get finalRejected => confirmedRejected ?? scannedRejected;
}

/// Session history item entity from RPC response
@freezed
class SessionHistoryItem with _$SessionHistoryItem {
  const SessionHistoryItem._();

  const factory SessionHistoryItem({
    required String sessionId,
    required String sessionName,
    required String sessionType,
    required bool isActive,
    required bool isFinal,

    required String storeId,
    required String storeName,

    String? shipmentId,
    String? shipmentNumber,

    required String createdAt,
    String? completedAt,
    int? durationMinutes,

    required String createdBy,
    required String createdByName,

    required List<SessionHistoryMember> members,
    required int memberCount,

    required List<SessionHistoryItemDetail> items,

    /// Totals - Scanned by employees
    required int totalScannedQuantity,
    required int totalScannedRejected,

    /// Totals - Confirmed by manager (null if not submitted)
    int? totalConfirmedQuantity,
    int? totalConfirmedRejected,

    /// Counting specific - total difference from expected
    int? totalDifference,
  }) = _SessionHistoryItem;

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';

  /// Check if session has been submitted/confirmed
  bool get hasConfirmed => totalConfirmedQuantity != null;

  /// Get total items count
  int get totalItemsCount => items.length;

  /// Get final quantity (confirmed if available, otherwise scanned)
  int get totalQuantity => totalConfirmedQuantity ?? totalScannedQuantity;

  /// Get final rejected (confirmed if available, otherwise scanned)
  int get totalRejected => totalConfirmedRejected ?? totalScannedRejected;
}

/// Response wrapper for session history
@freezed
class SessionHistoryResponse with _$SessionHistoryResponse {
  const SessionHistoryResponse._();

  const factory SessionHistoryResponse({
    required List<SessionHistoryItem> sessions,
    required int totalCount,
    required int limit,
    required int offset,
  }) = _SessionHistoryResponse;

  bool get hasMore => offset + sessions.length < totalCount;
}
