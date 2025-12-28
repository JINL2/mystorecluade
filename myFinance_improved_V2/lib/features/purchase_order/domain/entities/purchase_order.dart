import 'package:freezed_annotation/freezed_annotation.dart';

part 'purchase_order.freezed.dart';

/// Purchase Order status enum
enum POStatus {
  draft,
  confirmed,
  inProduction,
  readyToShip,
  partiallyShipped,
  shipped,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case POStatus.draft:
        return 'Draft';
      case POStatus.confirmed:
        return 'Confirmed';
      case POStatus.inProduction:
        return 'In Production';
      case POStatus.readyToShip:
        return 'Ready to Ship';
      case POStatus.partiallyShipped:
        return 'Partially Shipped';
      case POStatus.shipped:
        return 'Shipped';
      case POStatus.completed:
        return 'Completed';
      case POStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get dbValue {
    switch (this) {
      case POStatus.draft:
        return 'draft';
      case POStatus.confirmed:
        return 'confirmed';
      case POStatus.inProduction:
        return 'in_production';
      case POStatus.readyToShip:
        return 'ready_to_ship';
      case POStatus.partiallyShipped:
        return 'partially_shipped';
      case POStatus.shipped:
        return 'shipped';
      case POStatus.completed:
        return 'completed';
      case POStatus.cancelled:
        return 'cancelled';
    }
  }

  static POStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return POStatus.draft;
      case 'confirmed':
        return POStatus.confirmed;
      case 'in_production':
        return POStatus.inProduction;
      case 'ready_to_ship':
        return POStatus.readyToShip;
      case 'partially_shipped':
        return POStatus.partiallyShipped;
      case 'shipped':
        return POStatus.shipped;
      case 'completed':
        return POStatus.completed;
      case 'cancelled':
        return POStatus.cancelled;
      default:
        return POStatus.draft;
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
    @Default(POStatus.draft) POStatus status,
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

  /// Check if PO is editable
  bool get isEditable => status == POStatus.draft;

  /// Check if PO can be confirmed
  bool get canConfirm => status == POStatus.draft;

  /// Check if PO can start production
  bool get canStartProduction => status == POStatus.confirmed;

  /// Check if PO is ready to ship
  bool get canMarkReadyToShip => status == POStatus.inProduction;

  /// Check if PO can be shipped
  bool get canShip => status == POStatus.readyToShip || status == POStatus.partiallyShipped;

  /// Check if PO can be completed
  bool get canComplete => status == POStatus.shipped;

  /// Check if PO can be cancelled
  bool get canCancel => status != POStatus.completed && status != POStatus.cancelled;

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
@freezed
class POListItem with _$POListItem {
  const POListItem._();

  const factory POListItem({
    required String poId,
    required String poNumber,
    String? piNumber,
    String? buyerName,
    String? buyerPoNumber,
    required String currencyCode,
    required double totalAmount,
    required POStatus status,
    @Default(0) double shippedPercent,
    DateTime? orderDateUtc,
    DateTime? requiredShipmentDateUtc,
    DateTime? createdAtUtc,
    @Default(0) int itemCount,
  }) = _POListItem;

  /// Convenience getter for id (alias for poId)
  String get id => poId;

  /// Days until required shipment
  int? get daysUntilShipment {
    if (requiredShipmentDateUtc == null) return null;
    return requiredShipmentDateUtc!.difference(DateTime.now()).inDays;
  }

  /// Check if shipment is overdue
  bool get isShipmentOverdue {
    if (requiredShipmentDateUtc == null) return false;
    return DateTime.now().isAfter(requiredShipmentDateUtc!) &&
        status != POStatus.shipped &&
        status != POStatus.completed;
  }
}
