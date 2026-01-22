import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment.freezed.dart';

/// Shipment status enum - matches RPC status values
enum ShipmentStatus {
  pending,
  process,
  complete,
  cancelled;

  String get label {
    switch (this) {
      case ShipmentStatus.pending:
        return 'Pending';
      case ShipmentStatus.process:
        return 'Processing';
      case ShipmentStatus.complete:
        return 'Complete';
      case ShipmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get labelEn {
    switch (this) {
      case ShipmentStatus.pending:
        return 'Pending';
      case ShipmentStatus.process:
        return 'Processing';
      case ShipmentStatus.complete:
        return 'Complete';
      case ShipmentStatus.cancelled:
        return 'Cancelled';
    }
  }

  static ShipmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return ShipmentStatus.pending;
      case 'process':
        return ShipmentStatus.process;
      case 'complete':
        return ShipmentStatus.complete;
      case 'cancelled':
        return ShipmentStatus.cancelled;
      default:
        return ShipmentStatus.pending;
    }
  }
}

/// Shipment Item entity
@freezed
class ShipmentItem with _$ShipmentItem {
  const ShipmentItem._();

  const factory ShipmentItem({
    required String itemId,
    required String shipmentId,
    String? orderItemId,
    String? productId,
    String? productName,
    String? sku,
    required double quantity,
    String? unit,
    double? unitPrice,
    double? totalAmount,
    String? notes,
    @Default(0) int sortOrder,
    DateTime? createdAtUtc,
  }) = _ShipmentItem;

  /// Calculate total amount if not provided
  double get calculatedTotal => totalAmount ?? (quantity * (unitPrice ?? 0));
}

/// Shipment entity (full detail)
@freezed
class Shipment with _$Shipment {
  const Shipment._();

  const factory Shipment({
    required String shipmentId,
    required String shipmentNumber,
    required String companyId,
    String? trackingNumber,
    DateTime? shippedDateUtc,
    String? supplierId,
    String? supplierName,
    Map<String, dynamic>? supplierInfo,
    @Default(ShipmentStatus.pending) ShipmentStatus status,
    String? notes,
    String? createdBy,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    // Items
    @Default([]) List<ShipmentItem> items,
  }) = _Shipment;

  /// Convenience getter for id (alias for shipmentId)
  String get id => shipmentId;

  /// Check if shipment is editable
  bool get isEditable => status == ShipmentStatus.pending;

  /// Check if shipment is in progress
  bool get isInProgress => status == ShipmentStatus.process;

  /// Check if shipment is completed
  bool get isCompleted => status == ShipmentStatus.complete;

  /// Total items count
  int get itemCount => items.length;

  /// Total amount from items
  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.calculatedTotal);
}

/// Shipment list item (lighter version for list view) - matches RPC response
@freezed
class ShipmentListItem with _$ShipmentListItem {
  const ShipmentListItem._();

  const factory ShipmentListItem({
    required String shipmentId,
    required String shipmentNumber,
    String? trackingNumber,
    DateTime? shippedDate,
    String? supplierId,
    String? supplierName,
    required ShipmentStatus status,
    @Default(0) int itemCount,
    @Default(0) double totalAmount,
    @Default(false) bool hasOrders,
    @Default(0) int linkedOrderCount,
    String? notes,
    DateTime? createdAt,
    String? createdBy,
  }) = _ShipmentListItem;

  /// Convenience getter for id (alias for shipmentId)
  String get id => shipmentId;
}

/// Paginated response for shipment list
@freezed
class PaginatedShipmentResponse with _$PaginatedShipmentResponse {
  const factory PaginatedShipmentResponse({
    required List<ShipmentListItem> data,
    required int totalCount,
    required int limit,
    required int offset,
  }) = _PaginatedShipmentResponse;
}

// =============================================================================
// Shipment Detail V2 Entities (for inventory_get_shipment_detail_v2 RPC)
// =============================================================================

/// Supplier info for shipment detail
@freezed
class ShipmentSupplierInfo with _$ShipmentSupplierInfo {
  const factory ShipmentSupplierInfo({
    String? supplierId,
    String? supplierName,
    String? supplierPhone,
    String? supplierEmail,
    @Default(false) bool isRegisteredSupplier,
  }) = _ShipmentSupplierInfo;
}

/// Shipment detail item with variant support
@freezed
class ShipmentDetailItem with _$ShipmentDetailItem {
  const ShipmentDetailItem._();

  const factory ShipmentDetailItem({
    required String itemId,
    String? productId,
    String? variantId,
    String? productName,
    String? variantName,
    String? displayName,
    @Default(false) bool hasVariants,
    String? sku,
    @Default(0) double quantityShipped,
    @Default(0) double quantityReceived,
    @Default(0) double quantityAccepted,
    @Default(0) double quantityRejected,
    @Default(0) double quantityRemaining,
    @Default(0) double unitCost,
    @Default(0) double totalAmount,
    String? unit,
    String? notes,
    @Default(0) int sortOrder,
  }) = _ShipmentDetailItem;

  /// Get effective display name (variant name or product name)
  String get effectiveDisplayName => displayName ?? productName ?? 'Unknown Product';

  /// Check if item is fully received
  bool get isFullyReceived => quantityRemaining <= 0;

  /// Progress percentage
  double get progressPercentage =>
      quantityShipped > 0 ? (quantityReceived / quantityShipped * 100) : 0;
}

/// Receiving summary for shipment detail
@freezed
class ShipmentReceivingSummary with _$ShipmentReceivingSummary {
  const ShipmentReceivingSummary._();

  const factory ShipmentReceivingSummary({
    @Default(0) double totalShipped,
    @Default(0) double totalReceived,
    @Default(0) double totalAccepted,
    @Default(0) double totalRejected,
    @Default(0) double totalRemaining,
    @Default(0) double progressPercentage,
  }) = _ShipmentReceivingSummary;

  /// Check if fully received
  bool get isFullyReceived => totalRemaining <= 0;
}

/// Linked order info for shipment detail
@freezed
class ShipmentLinkedOrder with _$ShipmentLinkedOrder {
  const factory ShipmentLinkedOrder({
    required String orderId,
    required String orderNumber,
    String? orderDate,
    String? orderStatus,
  }) = _ShipmentLinkedOrder;
}

/// Shipment detail entity (from inventory_get_shipment_detail_v2 RPC)
@freezed
class ShipmentDetail with _$ShipmentDetail {
  const ShipmentDetail._();

  const factory ShipmentDetail({
    // Header info
    required String shipmentId,
    required String shipmentNumber,
    String? trackingNumber,
    DateTime? shippedDate,
    required ShipmentStatus status,
    String? notes,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    String? updatedBy,
    // Supplier info
    ShipmentSupplierInfo? supplierInfo,
    // Items
    @Default([]) List<ShipmentDetailItem> items,
    // Receiving summary
    ShipmentReceivingSummary? receivingSummary,
    // Linked orders
    @Default(false) bool hasOrders,
    @Default(0) int orderCount,
    @Default([]) List<ShipmentLinkedOrder> linkedOrders,
    // Actions
    @Default(false) bool canCancel,
  }) = _ShipmentDetail;

  /// Convenience getter for id
  String get id => shipmentId;

  /// Total items count
  int get itemCount => items.length;

  /// Total amount from items
  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.totalAmount);

  /// Check if shipment is editable
  bool get isEditable => status == ShipmentStatus.pending;

  /// Check if shipment is in progress
  bool get isInProgress => status == ShipmentStatus.process;

  /// Check if shipment is completed
  bool get isCompleted => status == ShipmentStatus.complete;

  /// Check if shipment is cancelled
  bool get isCancelled => status == ShipmentStatus.cancelled;

  /// Supplier name shortcut
  String? get supplierName => supplierInfo?.supplierName;

  /// Check if shipment can be cancelled (based on status or RPC flag)
  /// Returns true if canCancel flag is true OR status is pending/process
  bool get isCancellable =>
      canCancel || status == ShipmentStatus.pending || status == ShipmentStatus.process;
}

