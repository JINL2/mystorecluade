import '../../domain/entities/shipment.dart';

/// Model for Shipment with JSON serialization
class ShipmentModel extends Shipment {
  const ShipmentModel({
    required super.shipmentId,
    required super.shipmentNumber,
    super.trackingNumber,
    super.shippedDate,
    super.supplierId,
    required super.supplierName,
    required super.status,
    required super.itemCount,
    required super.totalAmount,
    required super.hasOrders,
    required super.linkedOrderCount,
    super.notes,
    required super.createdAt,
    required super.createdBy,
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

  Shipment toEntity() => this;
}

/// Model for ShipmentListResponse with JSON serialization
class ShipmentListResponseModel extends ShipmentListResponse {
  const ShipmentListResponseModel({
    required super.shipments,
    required super.totalCount,
    required super.limit,
    required super.offset,
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
}
