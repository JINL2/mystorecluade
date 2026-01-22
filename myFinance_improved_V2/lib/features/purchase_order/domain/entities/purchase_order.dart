import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_order.freezed.dart';

/// Order status enum (for inventory_purchase_orders)
enum OrderStatus {
  pending,
  process,
  complete,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.process:
        return 'Process';
      case OrderStatus.complete:
        return 'Complete';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'process':
        return OrderStatus.process;
      case 'complete':
        return OrderStatus.complete;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}

/// Receiving status enum (for inventory_purchase_orders)
enum ReceivingStatus {
  pending,
  process,
  complete;

  String get label {
    switch (this) {
      case ReceivingStatus.pending:
        return 'Pending';
      case ReceivingStatus.process:
        return 'Process';
      case ReceivingStatus.complete:
        return 'Complete';
    }
  }

  static ReceivingStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return ReceivingStatus.pending;
      case 'process':
        return ReceivingStatus.process;
      case 'complete':
        return ReceivingStatus.complete;
      default:
        return ReceivingStatus.pending;
    }
  }
}

/// POStatus enum - matches OrderStatus for consistency
enum POStatus {
  pending,
  process,
  complete,
  cancelled;

  String get label {
    switch (this) {
      case POStatus.pending:
        return 'Pending';
      case POStatus.process:
        return 'Process';
      case POStatus.complete:
        return 'Complete';
      case POStatus.cancelled:
        return 'Cancelled';
    }
  }

  static POStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return POStatus.pending;
      case 'process':
        return POStatus.process;
      case 'complete':
        return POStatus.complete;
      case 'cancelled':
        return POStatus.cancelled;
      default:
        return POStatus.pending;
    }
  }

  /// Convert from OrderStatus
  static POStatus fromOrderStatus(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.pending:
        return POStatus.pending;
      case OrderStatus.process:
        return POStatus.process;
      case OrderStatus.complete:
        return POStatus.complete;
      case OrderStatus.cancelled:
        return POStatus.cancelled;
    }
  }
}

/// Purchase Order Item entity
@freezed
class POItem with _$POItem {
  const POItem._();

  const factory POItem({
    required String itemId,
    required String poId,
    String? piItemId,
    String? productId,
    required String description,
    String? sku,
    String? hsCode,
    required double quantity,
    @Default(0) double shippedQuantity,
    String? unit,
    required double unitPrice,
    required double totalAmount,
    String? imageUrl,
    @Default(0) int sortOrder,
    DateTime? createdAtUtc,
  }) = _POItem;

  /// Line total (same as totalAmount)
  double get lineTotal => totalAmount;

  /// Remaining quantity to ship
  double get remainingQuantity => quantity - shippedQuantity;

  /// Check if fully shipped
  bool get isFullyShipped => shippedQuantity >= quantity;
}

/// Purchase Order entity
@freezed
class PurchaseOrder with _$PurchaseOrder {
  const PurchaseOrder._();

  const factory PurchaseOrder({
    required String poId,
    required String poNumber,
    required String companyId,
    String? storeId,
    String? piId,
    String? piNumber,
    /// Seller (our company) info for PDF generation
    Map<String, dynamic>? sellerInfo,
    /// Banking info for PDF (from cash_locations)
    List<Map<String, dynamic>>? bankingInfo,
    /// Selected bank account IDs (cash_location_ids) for PDF display
    @Default([]) List<String> bankAccountIds,
    String? buyerId,
    String? buyerName,
    String? buyerPoNumber,
    Map<String, dynamic>? buyerInfo,
    String? currencyId,
    @Default('USD') String currencyCode,
    @Default(0) double totalAmount,
    String? incotermsCode,
    String? incotermsPlace,
    String? paymentTermsCode,
    DateTime? orderDateUtc,
    DateTime? requiredShipmentDateUtc,
    @Default(true) bool partialShipmentAllowed,
    @Default(true) bool transshipmentAllowed,
    @Default(POStatus.pending) POStatus status,
    @Default(1) int version,
    @Default(0) double shippedPercent,
    String? notes,
    String? createdBy,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    @Default([]) List<POItem> items,
  }) = _PurchaseOrder;

  /// Convenience getter for id (alias for poId)
  String get id => poId;

  /// Check if PO is editable (only pending status)
  bool get isEditable => status == POStatus.pending;

  /// Check if PO can move to process
  bool get canProcess => status == POStatus.pending;

  /// Check if PO can be completed
  bool get canComplete => status == POStatus.process;

  /// Check if PO can be cancelled
  bool get canCancel => status != POStatus.complete && status != POStatus.cancelled;

  /// Check if PO is linked to PI
  bool get hasLinkedPI => piId != null;

  /// Days until required shipment
  int? get daysUntilShipment {
    if (requiredShipmentDateUtc == null) return null;
    return requiredShipmentDateUtc!.difference(DateTime.now()).inDays;
  }

  /// Item count
  int get itemCount => items.length;

  /// Formatted total amount
  String get formattedTotal => '$currencyCode ${totalAmount.toStringAsFixed(2)}';
}

/// Purchase Order list item (lighter version for list view)
/// Uses inventory_get_order_list RPC response structure
@freezed
class POListItem with _$POListItem {
  const POListItem._();

  const factory POListItem({
    required String poId,
    required String poNumber,
    String? piNumber,
    // Supplier info (from inventory system - orders TO suppliers)
    String? supplierId,
    String? supplierName,
    // Legacy buyer fields for UI compatibility
    String? buyerName,
    String? buyerPoNumber,
    required String currencyCode,
    required double totalAmount,
    required POStatus status,
    // New status fields from RPC
    @Default(OrderStatus.pending) OrderStatus orderStatus,
    @Default(ReceivingStatus.pending) ReceivingStatus receivingStatus,
    // Fulfillment percentage from RPC
    @Default(0) double shippedPercent,
    @Default(0) double fulfilledPercentage,
    DateTime? orderDateUtc,
    DateTime? requiredShipmentDateUtc,
    DateTime? createdAtUtc,
    @Default(0) int itemCount,
  }) = _POListItem;

  /// Convenience getter for id (alias for poId)
  String get id => poId;

  /// Display name - returns supplier name or buyer name for compatibility
  String? get displayName => supplierName ?? buyerName;

  /// Days until required shipment
  int? get daysUntilShipment {
    if (requiredShipmentDateUtc == null) return null;
    return requiredShipmentDateUtc!.difference(DateTime.now()).inDays;
  }

  /// Check if shipment is overdue
  bool get isShipmentOverdue {
    if (requiredShipmentDateUtc == null) return false;
    return DateTime.now().isAfter(requiredShipmentDateUtc!) &&
        status != POStatus.complete &&
        status != POStatus.cancelled;
  }
}
