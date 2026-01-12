import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_review_item.freezed.dart';

/// User who scanned items in a session
@freezed
class ScannedByUser with _$ScannedByUser {
  const factory ScannedByUser({
    required String userId,
    required String userName,
    required int quantity,
    required int quantityRejected,
  }) = _ScannedByUser;
}

/// Individual item in session review
/// Supports v2 variants with variantId and displayName
@freezed
class SessionReviewItem with _$SessionReviewItem {
  const SessionReviewItem._();

  const factory SessionReviewItem({
    required String productId,
    required String productName,
    String? sku,
    String? imageUrl,
    String? brand,
    String? category,
    required int totalQuantity,
    required int totalRejected,
    @Default(0) int previousStock,
    required List<ScannedByUser> scannedBy,
    /// Session type: 'counting' or 'receiving'
    /// Used to calculate newStock and stockChange differently
    @Default('receiving') String sessionType,
    // v2 variant fields
    String? variantId,
    String? variantName,
    String? displayName,
    String? variantSku,
    String? displaySku,
    @Default(false) bool hasVariants,
  }) = _SessionReviewItem;

  /// Display name for UI - uses displayName if available, otherwise productName
  String get name => displayName ?? productName;

  /// Display SKU for UI - uses displaySku if available, otherwise sku
  String? get effectiveSku => displaySku ?? sku;

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;

  /// Get new stock after session
  /// Both counting and receiving add netQuantity to existing stock
  /// - Counting: previousStock + netQuantity (adding counted items to existing stock)
  /// - Receiving: previousStock + netQuantity (adding received items to existing stock)
  int get newStock => previousStock + netQuantity;

  /// Get stock change (difference between new and previous)
  int get stockChange => newStock - previousStock;
}

/// Summary of session items
@freezed
class SessionReviewSummary with _$SessionReviewSummary {
  const SessionReviewSummary._();

  const factory SessionReviewSummary({
    required int totalProducts,
    required int totalQuantity,
    required int totalRejected,
    @Default(0) int totalParticipants,
  }) = _SessionReviewSummary;

  /// Get net quantity (total - rejected)
  int get netQuantity => totalQuantity - totalRejected;
}

/// Session participant (from inventory_get_session_items RPC)
@freezed
class SessionParticipant with _$SessionParticipant {
  const factory SessionParticipant({
    required String userId,
    required String userName,
    String? userProfileImage,
    required int productCount,
    required int totalScanned,
  }) = _SessionParticipant;
}

/// Response wrapper for session review items
@freezed
class SessionReviewResponse with _$SessionReviewResponse {
  const factory SessionReviewResponse({
    required String sessionId,
    required List<SessionReviewItem> items,
    required List<SessionParticipant> participants,
    required SessionReviewSummary summary,
  }) = _SessionReviewResponse;
}

/// Item to submit in session
/// v3 supports variantId for variant products
@freezed
class SessionSubmitItem with _$SessionSubmitItem {
  const factory SessionSubmitItem({
    required String productId,
    /// Variant ID for variant products, null for simple products
    String? variantId,
    required int quantity,
    @Default(0) int quantityRejected,
  }) = _SessionSubmitItem;
}

/// Stock change item from submit response (V2)
/// Tracks before/after quantities for display tracking
@freezed
class StockChangeItem with _$StockChangeItem {
  const factory StockChangeItem({
    required String productId,
    String? sku,
    required String productName,
    required int quantityBefore,
    required int quantityReceived,
    required int quantityAfter,
    /// True if quantityBefore was 0 (new item needs display)
    required bool needsDisplay,
  }) = _StockChangeItem;
}

/// Response from session submit
@freezed
class SessionSubmitResponse with _$SessionSubmitResponse {
  const factory SessionSubmitResponse({
    @Default('receiving') String sessionType,
    required String receivingId,
    required String receivingNumber,
    required String sessionId,
    required bool isFinal,
    required int itemsCount,
    required int totalQuantity,
    required int totalRejected,
    required bool stockUpdated,
    /// Stock changes for each product (receiving only)
    @Default([]) List<StockChangeItem> stockChanges,
    /// Count of new items that need display (quantityBefore = 0)
    @Default(0) int newDisplayCount,
  }) = _SessionSubmitResponse;
}
