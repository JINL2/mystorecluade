import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_history_item.freezed.dart';

/// User info with profile image (used in created_by, members, scanned_by)
@freezed
class SessionHistoryUser with _$SessionHistoryUser {
  const factory SessionHistoryUser({
    required String userId,
    required String firstName,
    required String lastName,
    String? profileImage,
  }) = _SessionHistoryUser;
}

/// Member info in session history
@freezed
class SessionHistoryMember with _$SessionHistoryMember {
  const factory SessionHistoryMember({
    required String oderId,
    required String userName,
    required String joinedAt,
    required bool isActive,
    String? profileImage,
    // V2: Extended user info
    String? firstName,
    String? lastName,
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
    // V2: Extended user info
    String? firstName,
    String? lastName,
    String? profileImage,
  }) = _ScannedByInfo;
}

/// Item info in session history
/// v3: Supports variant fields for variant-level grouping
@freezed
class SessionHistoryItemDetail with _$SessionHistoryItemDetail {
  const SessionHistoryItemDetail._();

  const factory SessionHistoryItemDetail({
    required String productId,
    required String productName,
    String? sku,

    // v3 variant fields
    String? variantId,
    String? variantName,
    String? displayName,
    @Default(false) bool hasVariants,
    String? variantSku,
    String? displaySku,

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

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Display SKU for UI - uses displaySku if available, otherwise sku
  String? get effectiveSku => displaySku ?? sku;

  /// Check if manager has confirmed this item
  bool get hasConfirmed => confirmedQuantity != null;

  /// Check if manager changed the quantity (edited from scanned)
  bool get wasEdited => hasConfirmed && confirmedQuantity != scannedQuantity;

  /// Get the final quantity (confirmed if available, otherwise scanned)
  int get finalQuantity => confirmedQuantity ?? scannedQuantity;

  /// Get the final rejected (confirmed if available, otherwise scanned)
  int get finalRejected => confirmedRejected ?? scannedRejected;
}

/// Stock snapshot item for receiving sessions (V2)
/// v3: Supports variant fields
@freezed
class StockSnapshotItem with _$StockSnapshotItem {
  const StockSnapshotItem._();

  const factory StockSnapshotItem({
    required String productId,
    required String sku,
    required String productName,
    required int quantityBefore,
    required int quantityReceived,
    required int quantityAfter,
    /// true = new product (needs display), false = restock
    required bool needsDisplay,
    // v3 variant fields
    String? variantId,
    String? variantName,
    String? displayName,
  }) = _StockSnapshotItem;

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Check if this is a new product (was 0 stock before)
  bool get isNewProduct => needsDisplay;

  /// Check if this is a restock (had stock before)
  bool get isRestock => !needsDisplay;
}

/// Receiving info for receiving sessions (V2)
@freezed
class ReceivingInfo with _$ReceivingInfo {
  const ReceivingInfo._();

  const factory ReceivingInfo({
    required String receivingId,
    required String receivingNumber,
    required String receivedAt,
    required List<StockSnapshotItem> stockSnapshot,
    required int newProductsCount,
    required int restockProductsCount,
  }) = _ReceivingInfo;

  /// Get new products only
  List<StockSnapshotItem> get newProducts =>
      stockSnapshot.where((item) => item.needsDisplay).toList();

  /// Get restock products only
  List<StockSnapshotItem> get restockProducts =>
      stockSnapshot.where((item) => !item.needsDisplay).toList();
}

/// Merged item info (items from merged sessions)
/// v3: Supports variant fields
@freezed
class MergedSessionItem with _$MergedSessionItem {
  const MergedSessionItem._();

  const factory MergedSessionItem({
    required String productId,
    required String sku,
    required String productName,
    required int quantity,
    required int quantityRejected,
    required SessionHistoryUser scannedBy,
    // v3 variant fields
    String? variantId,
    String? variantName,
    String? displayName,
    @Default(false) bool hasVariants,
  }) = _MergedSessionItem;

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;
}

/// Merged session info
@freezed
class MergedSessionInfo with _$MergedSessionInfo {
  const factory MergedSessionInfo({
    required String sourceSessionId,
    required String sourceSessionName,
    required String sourceCreatedAt,
    required SessionHistoryUser sourceCreatedBy,
    required List<MergedSessionItem> items,
    required int itemsCount,
    required int totalQuantity,
    required int totalRejected,
  }) = _MergedSessionInfo;
}

/// Original session info (items originally in this session, not merged)
@freezed
class OriginalSessionInfo with _$OriginalSessionInfo {
  const factory OriginalSessionInfo({
    required List<MergedSessionItem> items,
    required int itemsCount,
    required int totalQuantity,
    required int totalRejected,
  }) = _OriginalSessionInfo;
}

/// Merge info for merged sessions (V2)
@freezed
class MergeInfo with _$MergeInfo {
  const factory MergeInfo({
    required OriginalSessionInfo originalSession,
    required List<MergedSessionInfo> mergedSessions,
    required int totalMergedSessionsCount,
  }) = _MergeInfo;
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

    /// V2: createdBy is now an object
    required String createdBy,
    required String createdByName,
    String? createdByFirstName,
    String? createdByLastName,
    String? createdByProfileImage,

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

    /// V2: Merge info
    @Default(false) bool isMergedSession,
    MergeInfo? mergeInfo,

    /// V2: Receiving info (receiving sessions only)
    ReceivingInfo? receivingInfo,
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

  /// V2: Check if has merge info
  bool get hasMergeInfo => isMergedSession && mergeInfo != null;

  /// V2: Check if has receiving info
  bool get hasReceivingInfo => isReceiving && receivingInfo != null;

  /// V2: Get new products count (receiving only)
  int get newProductsCount => receivingInfo?.newProductsCount ?? 0;

  /// V2: Get restock products count (receiving only)
  int get restockProductsCount => receivingInfo?.restockProductsCount ?? 0;
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
