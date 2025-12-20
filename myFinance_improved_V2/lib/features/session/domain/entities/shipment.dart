import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipment.freezed.dart';

/// Shipment entity for receiving operations
@freezed
class Shipment with _$Shipment {
  const Shipment._();

  const factory Shipment({
    required String shipmentId,
    required String shipmentNumber,
    String? trackingNumber,
    String? shippedDate,
    String? supplierId,
    required String supplierName,
    required String status,
    required int itemCount,
    required double totalAmount,
    required bool hasOrders,
    required int linkedOrderCount,
    String? notes,
    required String createdAt,
    required String createdBy,
  }) = _Shipment;

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
}

/// Response from getting shipment list
@freezed
class ShipmentListResponse with _$ShipmentListResponse {
  const ShipmentListResponse._();

  const factory ShipmentListResponse({
    required List<Shipment> shipments,
    required int totalCount,
    required int limit,
    required int offset,
  }) = _ShipmentListResponse;

  bool get hasMore => offset + shipments.length < totalCount;
}
