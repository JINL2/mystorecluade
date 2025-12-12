/// Shipment entity for receiving operations
class Shipment {
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

  const Shipment({
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

  /// Get display text for the shipment (for selector)
  String get displayText => '$shipmentNumber - $supplierName';

  /// Get status display text
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'process':
        return 'In Transit';
      case 'complete':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Shipment && other.shipmentId == shipmentId;
  }

  @override
  int get hashCode => shipmentId.hashCode;
}

/// Response from getting shipment list
class ShipmentListResponse {
  final List<Shipment> shipments;
  final int totalCount;
  final int limit;
  final int offset;

  const ShipmentListResponse({
    required this.shipments,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });
}
