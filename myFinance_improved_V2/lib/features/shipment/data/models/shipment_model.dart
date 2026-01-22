import '../../domain/entities/shipment.dart';

/// Shipment Item Model - Data Layer
///
/// Handles JSON serialization/deserialization for ShipmentItem entity.
class ShipmentItemModel {
  final String itemId;
  final String shipmentId;
  final String? orderItemId;
  final String? productId;
  final String? productName;
  final String? sku;
  final double quantity;
  final String? unit;
  final double? unitPrice;
  final double? totalAmount;
  final String? notes;
  final int sortOrder;
  final DateTime? createdAtUtc;

  ShipmentItemModel({
    required this.itemId,
    required this.shipmentId,
    this.orderItemId,
    this.productId,
    this.productName,
    this.sku,
    required this.quantity,
    this.unit,
    this.unitPrice,
    this.totalAmount,
    this.notes,
    this.sortOrder = 0,
    this.createdAtUtc,
  });

  factory ShipmentItemModel.fromJson(Map<String, dynamic> json) {
    return ShipmentItemModel(
      itemId: json['item_id'] as String,
      shipmentId: json['shipment_id'] as String,
      orderItemId: json['order_item_id'] as String?,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      sku: json['sku'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAtUtc: json['created_at_utc'] != null
          ? DateTime.parse(json['created_at_utc'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'shipment_id': shipmentId,
      'order_item_id': orderItemId,
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'quantity': quantity,
      'unit': unit,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'notes': notes,
      'sort_order': sortOrder,
    };
  }

  /// Convert to domain entity
  ShipmentItem toEntity() {
    return ShipmentItem(
      itemId: itemId,
      shipmentId: shipmentId,
      orderItemId: orderItemId,
      productId: productId,
      productName: productName,
      sku: sku,
      quantity: quantity,
      unit: unit,
      unitPrice: unitPrice,
      totalAmount: totalAmount,
      notes: notes,
      sortOrder: sortOrder,
      createdAtUtc: createdAtUtc,
    );
  }

  /// Create from domain entity
  factory ShipmentItemModel.fromEntity(ShipmentItem entity) {
    return ShipmentItemModel(
      itemId: entity.itemId,
      shipmentId: entity.shipmentId,
      orderItemId: entity.orderItemId,
      productId: entity.productId,
      productName: entity.productName,
      sku: entity.sku,
      quantity: entity.quantity,
      unit: entity.unit,
      unitPrice: entity.unitPrice,
      totalAmount: entity.totalAmount,
      notes: entity.notes,
      sortOrder: entity.sortOrder,
      createdAtUtc: entity.createdAtUtc,
    );
  }
}

/// Shipment Model - Data Layer
///
/// Handles JSON serialization/deserialization for Shipment entity.
class ShipmentModel {
  final String shipmentId;
  final String shipmentNumber;
  final String companyId;
  final String? trackingNumber;
  final DateTime? shippedDateUtc;
  final String? supplierId;
  final String? supplierName;
  final Map<String, dynamic>? supplierInfo;
  final String status;
  final String? notes;
  final String? createdBy;
  final DateTime? createdAtUtc;
  final DateTime? updatedAtUtc;
  final List<ShipmentItemModel> items;

  ShipmentModel({
    required this.shipmentId,
    required this.shipmentNumber,
    required this.companyId,
    this.trackingNumber,
    this.shippedDateUtc,
    this.supplierId,
    this.supplierName,
    this.supplierInfo,
    this.status = 'pending',
    this.notes,
    this.createdBy,
    this.createdAtUtc,
    this.updatedAtUtc,
    this.items = const [],
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    // Parse supplier_info from JSONB
    Map<String, dynamic>? supplierInfo;
    if (json['supplier_info'] != null) {
      if (json['supplier_info'] is Map) {
        supplierInfo = Map<String, dynamic>.from(json['supplier_info'] as Map);
      }
    }

    // Parse items if included
    List<ShipmentItemModel> items = [];
    if (json['items'] != null && json['items'] is List) {
      items = (json['items'] as List)
          .map(
            (item) => ShipmentItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    return ShipmentModel(
      shipmentId: json['shipment_id'] as String,
      shipmentNumber: json['shipment_number'] as String,
      companyId: json['company_id'] as String,
      trackingNumber: json['tracking_number'] as String?,
      shippedDateUtc: json['shipped_date_utc'] != null
          ? DateTime.parse(json['shipped_date_utc'] as String)
          : null,
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      supplierInfo: supplierInfo,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAtUtc: json['created_at_utc'] != null
          ? DateTime.parse(json['created_at_utc'] as String)
          : null,
      updatedAtUtc: json['updated_at_utc'] != null
          ? DateTime.parse(json['updated_at_utc'] as String)
          : null,
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipment_id': shipmentId,
      'shipment_number': shipmentNumber,
      'company_id': companyId,
      'tracking_number': trackingNumber,
      'shipped_date_utc': shippedDateUtc?.toIso8601String(),
      'supplier_id': supplierId,
      'supplier_info': supplierInfo,
      'status': status,
      'notes': notes,
    };
  }

  /// Convert to domain entity
  Shipment toEntity() {
    return Shipment(
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      companyId: companyId,
      trackingNumber: trackingNumber,
      shippedDateUtc: shippedDateUtc,
      supplierId: supplierId,
      supplierName: supplierName,
      supplierInfo: supplierInfo,
      status: ShipmentStatus.fromString(status),
      notes: notes,
      createdBy: createdBy,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: updatedAtUtc,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  /// Create from domain entity
  factory ShipmentModel.fromEntity(Shipment entity) {
    return ShipmentModel(
      shipmentId: entity.shipmentId,
      shipmentNumber: entity.shipmentNumber,
      companyId: entity.companyId,
      trackingNumber: entity.trackingNumber,
      shippedDateUtc: entity.shippedDateUtc,
      supplierId: entity.supplierId,
      supplierName: entity.supplierName,
      supplierInfo: entity.supplierInfo,
      status: entity.status.name,
      notes: entity.notes,
      createdBy: entity.createdBy,
      createdAtUtc: entity.createdAtUtc,
      updatedAtUtc: entity.updatedAtUtc,
      items:
          entity.items.map((item) => ShipmentItemModel.fromEntity(item)).toList(),
    );
  }
}

/// Shipment List Item Model - matches RPC response
///
/// Model for inventory_get_shipment_list RPC response.
class ShipmentListItemModel {
  final String shipmentId;
  final String shipmentNumber;
  final String? trackingNumber;
  final DateTime? shippedDate;
  final String? supplierId;
  final String? supplierName;
  final String status;
  final int itemCount;
  final double totalAmount;
  final bool hasOrders;
  final int linkedOrderCount;
  final String? notes;
  final DateTime? createdAt;
  final String? createdBy;

  ShipmentListItemModel({
    required this.shipmentId,
    required this.shipmentNumber,
    this.trackingNumber,
    this.shippedDate,
    this.supplierId,
    this.supplierName,
    required this.status,
    this.itemCount = 0,
    this.totalAmount = 0,
    this.hasOrders = false,
    this.linkedOrderCount = 0,
    this.notes,
    this.createdAt,
    this.createdBy,
  });

  /// Parse from RPC response JSON
  factory ShipmentListItemModel.fromRpcJson(Map<String, dynamic> json) {
    return ShipmentListItemModel(
      shipmentId: json['shipment_id'] as String,
      shipmentNumber: json['shipment_number'] as String,
      trackingNumber: json['tracking_number'] as String?,
      shippedDate: json['shipped_date'] != null
          ? DateTime.parse(json['shipped_date'] as String)
          : null,
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      status: json['status'] as String? ?? 'pending',
      itemCount: json['item_count'] as int? ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      hasOrders: json['has_orders'] as bool? ?? false,
      linkedOrderCount: json['linked_order_count'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      createdBy: json['created_by'] as String?,
    );
  }

  /// Convert to domain entity
  ShipmentListItem toEntity() {
    return ShipmentListItem(
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      trackingNumber: trackingNumber,
      shippedDate: shippedDate,
      supplierId: supplierId,
      supplierName: supplierName,
      status: ShipmentStatus.fromString(status),
      itemCount: itemCount,
      totalAmount: totalAmount,
      hasOrders: hasOrders,
      linkedOrderCount: linkedOrderCount,
      notes: notes,
      createdAt: createdAt,
      createdBy: createdBy,
    );
  }
}

/// Paginated Shipment Response Model - matches RPC response
class PaginatedShipmentResponseModel {
  final List<ShipmentListItemModel> data;
  final int totalCount;
  final int limit;
  final int offset;

  PaginatedShipmentResponseModel({
    required this.data,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  /// Parse from RPC response JSON
  factory PaginatedShipmentResponseModel.fromRpcJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return PaginatedShipmentResponseModel(
      data: dataList
          .map(
            (item) =>
                ShipmentListItemModel.fromRpcJson(item as Map<String, dynamic>),
          )
          .toList(),
      totalCount: json['total_count'] as int? ?? 0,
      limit: json['limit'] as int? ?? 50,
      offset: json['offset'] as int? ?? 0,
    );
  }

  /// Convert to domain entity
  PaginatedShipmentResponse toEntity() {
    return PaginatedShipmentResponse(
      data: data.map((item) => item.toEntity()).toList(),
      totalCount: totalCount,
      limit: limit,
      offset: offset,
    );
  }
}

// =============================================================================
// Shipment Detail V2 Models (for inventory_get_shipment_detail_v2 RPC)
// =============================================================================

/// Supplier info model for shipment detail
class ShipmentSupplierInfoModel {
  final String? supplierId;
  final String? supplierName;
  final String? supplierPhone;
  final String? supplierEmail;
  final bool isRegisteredSupplier;

  ShipmentSupplierInfoModel({
    this.supplierId,
    this.supplierName,
    this.supplierPhone,
    this.supplierEmail,
    this.isRegisteredSupplier = false,
  });

  factory ShipmentSupplierInfoModel.fromJson(Map<String, dynamic> json) {
    return ShipmentSupplierInfoModel(
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      supplierPhone: json['supplier_phone'] as String?,
      supplierEmail: json['supplier_email'] as String?,
      isRegisteredSupplier: json['is_registered_supplier'] as bool? ?? false,
    );
  }

  ShipmentSupplierInfo toEntity() {
    return ShipmentSupplierInfo(
      supplierId: supplierId,
      supplierName: supplierName,
      supplierPhone: supplierPhone,
      supplierEmail: supplierEmail,
      isRegisteredSupplier: isRegisteredSupplier,
    );
  }
}

/// Shipment detail item model with variant support
class ShipmentDetailItemModel {
  final String itemId;
  final String? productId;
  final String? variantId;
  final String? productName;
  final String? variantName;
  final String? displayName;
  final bool hasVariants;
  final String? sku;
  final double quantityShipped;
  final double quantityReceived;
  final double quantityAccepted;
  final double quantityRejected;
  final double quantityRemaining;
  final double unitCost;
  final double totalAmount;
  final String? unit;
  final String? notes;
  final int sortOrder;

  ShipmentDetailItemModel({
    required this.itemId,
    this.productId,
    this.variantId,
    this.productName,
    this.variantName,
    this.displayName,
    this.hasVariants = false,
    this.sku,
    this.quantityShipped = 0,
    this.quantityReceived = 0,
    this.quantityAccepted = 0,
    this.quantityRejected = 0,
    this.quantityRemaining = 0,
    this.unitCost = 0,
    this.totalAmount = 0,
    this.unit,
    this.notes,
    this.sortOrder = 0,
  });

  factory ShipmentDetailItemModel.fromJson(Map<String, dynamic> json) {
    return ShipmentDetailItemModel(
      itemId: json['item_id'] as String,
      productId: json['product_id'] as String?,
      variantId: json['variant_id'] as String?,
      productName: json['product_name'] as String?,
      variantName: json['variant_name'] as String?,
      displayName: json['display_name'] as String?,
      hasVariants: json['has_variants'] as bool? ?? false,
      sku: json['sku'] as String?,
      quantityShipped: (json['quantity_shipped'] as num?)?.toDouble() ?? 0,
      quantityReceived: (json['quantity_received'] as num?)?.toDouble() ?? 0,
      quantityAccepted: (json['quantity_accepted'] as num?)?.toDouble() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toDouble() ?? 0,
      quantityRemaining: (json['quantity_remaining'] as num?)?.toDouble() ?? 0,
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
      notes: json['notes'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  ShipmentDetailItem toEntity() {
    return ShipmentDetailItem(
      itemId: itemId,
      productId: productId,
      variantId: variantId,
      productName: productName,
      variantName: variantName,
      displayName: displayName,
      hasVariants: hasVariants,
      sku: sku,
      quantityShipped: quantityShipped,
      quantityReceived: quantityReceived,
      quantityAccepted: quantityAccepted,
      quantityRejected: quantityRejected,
      quantityRemaining: quantityRemaining,
      unitCost: unitCost,
      totalAmount: totalAmount,
      unit: unit,
      notes: notes,
      sortOrder: sortOrder,
    );
  }
}

/// Receiving summary model for shipment detail
class ShipmentReceivingSummaryModel {
  final double totalShipped;
  final double totalReceived;
  final double totalAccepted;
  final double totalRejected;
  final double totalRemaining;
  final double progressPercentage;

  ShipmentReceivingSummaryModel({
    this.totalShipped = 0,
    this.totalReceived = 0,
    this.totalAccepted = 0,
    this.totalRejected = 0,
    this.totalRemaining = 0,
    this.progressPercentage = 0,
  });

  factory ShipmentReceivingSummaryModel.fromJson(Map<String, dynamic> json) {
    return ShipmentReceivingSummaryModel(
      totalShipped: (json['total_shipped'] as num?)?.toDouble() ?? 0,
      totalReceived: (json['total_received'] as num?)?.toDouble() ?? 0,
      totalAccepted: (json['total_accepted'] as num?)?.toDouble() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toDouble() ?? 0,
      totalRemaining: (json['total_remaining'] as num?)?.toDouble() ?? 0,
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0,
    );
  }

  ShipmentReceivingSummary toEntity() {
    return ShipmentReceivingSummary(
      totalShipped: totalShipped,
      totalReceived: totalReceived,
      totalAccepted: totalAccepted,
      totalRejected: totalRejected,
      totalRemaining: totalRemaining,
      progressPercentage: progressPercentage,
    );
  }
}

/// Linked order model for shipment detail
class ShipmentLinkedOrderModel {
  final String orderId;
  final String orderNumber;
  final String? orderDate;
  final String? orderStatus;

  ShipmentLinkedOrderModel({
    required this.orderId,
    required this.orderNumber,
    this.orderDate,
    this.orderStatus,
  });

  factory ShipmentLinkedOrderModel.fromJson(Map<String, dynamic> json) {
    return ShipmentLinkedOrderModel(
      orderId: json['order_id'] as String,
      orderNumber: json['order_number'] as String,
      orderDate: json['order_date'] as String?,
      orderStatus: json['order_status'] as String?,
    );
  }

  ShipmentLinkedOrder toEntity() {
    return ShipmentLinkedOrder(
      orderId: orderId,
      orderNumber: orderNumber,
      orderDate: orderDate,
      orderStatus: orderStatus,
    );
  }
}

/// Shipment detail model (from inventory_get_shipment_detail_v2 RPC)
class ShipmentDetailModel {
  // Header info
  final String shipmentId;
  final String shipmentNumber;
  final String? trackingNumber;
  final DateTime? shippedDate;
  final String status;
  final String? notes;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;
  // Supplier info
  final ShipmentSupplierInfoModel? supplierInfo;
  // Items
  final List<ShipmentDetailItemModel> items;
  // Receiving summary
  final ShipmentReceivingSummaryModel? receivingSummary;
  // Linked orders
  final bool hasOrders;
  final int orderCount;
  final List<ShipmentLinkedOrderModel> linkedOrders;
  // Actions
  final bool canCancel;

  ShipmentDetailModel({
    required this.shipmentId,
    required this.shipmentNumber,
    this.trackingNumber,
    this.shippedDate,
    required this.status,
    this.notes,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.supplierInfo,
    this.items = const [],
    this.receivingSummary,
    this.hasOrders = false,
    this.orderCount = 0,
    this.linkedOrders = const [],
    this.canCancel = false,
  });

  factory ShipmentDetailModel.fromRpcJson(Map<String, dynamic> json) {
    // Parse supplier info from flat fields (v2 RPC returns flat structure)
    ShipmentSupplierInfoModel? supplierInfo;
    if (json['supplier_name'] != null || json['supplier_id'] != null) {
      supplierInfo = ShipmentSupplierInfoModel(
        supplierId: json['supplier_id'] as String?,
        supplierName: json['supplier_name'] as String?,
        supplierPhone: json['supplier_phone'] as String?,
        supplierEmail: json['supplier_email'] as String?,
        isRegisteredSupplier: json['is_registered_supplier'] as bool? ?? false,
      );
    }

    // Parse items
    List<ShipmentDetailItemModel> items = [];
    if (json['items'] != null && json['items'] is List) {
      items = (json['items'] as List)
          .map((item) =>
              ShipmentDetailItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Parse receiving summary
    ShipmentReceivingSummaryModel? receivingSummary;
    if (json['receiving_summary'] != null) {
      receivingSummary = ShipmentReceivingSummaryModel.fromJson(
        json['receiving_summary'] as Map<String, dynamic>,
      );
    }

    // Parse linked orders (v2 uses 'orders' array directly in data)
    List<ShipmentLinkedOrderModel> linkedOrders = [];
    if (json['orders'] != null && json['orders'] is List) {
      linkedOrders = (json['orders'] as List)
          .map((order) =>
              ShipmentLinkedOrderModel.fromJson(order as Map<String, dynamic>))
          .toList();
    }

    return ShipmentDetailModel(
      shipmentId: json['shipment_id'] as String,
      shipmentNumber: json['shipment_number'] as String,
      trackingNumber: json['tracking_number'] as String?,
      shippedDate: json['shipped_date'] != null
          ? DateTime.parse(json['shipped_date'] as String)
          : null,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      createdBy: json['created_by'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      updatedBy: json['updated_by'] as String?,
      supplierInfo: supplierInfo,
      items: items,
      receivingSummary: receivingSummary,
      hasOrders: json['has_orders'] as bool? ?? false,
      orderCount: json['order_count'] as int? ?? 0,
      linkedOrders: linkedOrders,
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  ShipmentDetail toEntity() {
    return ShipmentDetail(
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      trackingNumber: trackingNumber,
      shippedDate: shippedDate,
      status: ShipmentStatus.fromString(status),
      notes: notes,
      createdAt: createdAt,
      createdBy: createdBy,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
      supplierInfo: supplierInfo?.toEntity(),
      items: items.map((item) => item.toEntity()).toList(),
      receivingSummary: receivingSummary?.toEntity(),
      hasOrders: hasOrders,
      orderCount: orderCount,
      linkedOrders: linkedOrders.map((order) => order.toEntity()).toList(),
      canCancel: canCancel,
    );
  }
}
