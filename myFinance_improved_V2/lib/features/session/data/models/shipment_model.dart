import '../../domain/entities/shipment.dart';

/// Model for Shipment with JSON serialization
class ShipmentModel {
  final String shipmentId;
  final String shipmentNumber;
  final String? trackingNumber;
  final String? shippedDate;
  final String? supplierId;
  final String supplierName;
  final String status;
  final int itemCount;
  final double totalAmount;
  final bool hasOrders;
  final int linkedOrderCount;
  final String? notes;
  final String createdAt;
  final String createdBy;

  const ShipmentModel({
    required this.shipmentId,
    required this.shipmentNumber,
    this.trackingNumber,
    this.shippedDate,
    this.supplierId,
    required this.supplierName,
    required this.status,
    required this.itemCount,
    required this.totalAmount,
    required this.hasOrders,
    required this.linkedOrderCount,
    this.notes,
    required this.createdAt,
    required this.createdBy,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      shipmentId: json['shipment_id']?.toString() ?? '',
      shipmentNumber: json['shipment_number']?.toString() ?? '',
      trackingNumber: json['tracking_number']?.toString(),
      shippedDate: json['shipped_date']?.toString(),
      supplierId: json['supplier_id']?.toString(),
      supplierName: json['supplier_name']?.toString() ?? 'Unknown',
      status: json['status']?.toString() ?? 'pending',
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      hasOrders: json['has_orders'] as bool? ?? false,
      linkedOrderCount: (json['linked_order_count'] as num?)?.toInt() ?? 0,
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? '',
    );
  }

  Shipment toEntity() {
    return Shipment(
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      trackingNumber: trackingNumber,
      shippedDate: shippedDate,
      supplierId: supplierId,
      supplierName: supplierName,
      status: status,
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

/// Model for ShipmentListResponse with JSON serialization
class ShipmentListResponseModel {
  final List<ShipmentModel> shipments;
  final int totalCount;
  final int limit;
  final int offset;

  const ShipmentListResponseModel({
    required this.shipments,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  factory ShipmentListResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    final shipments = dataList
        .map((item) => ShipmentModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ShipmentListResponseModel(
      shipments: shipments,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }

  ShipmentListResponse toEntity() {
    return ShipmentListResponse(
      shipments: shipments.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      limit: limit,
      offset: offset,
    );
  }
}
