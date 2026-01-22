/// Parameters for creating a shipment (inventory_create_shipment_v3 RPC)
class CreateShipmentParams {
  final String companyId;
  final String userId;
  final List<CreateShipmentItemParams> items;
  final String time;
  final String timezone;
  final List<String>? orderIds;
  final String? counterpartyId;
  final Map<String, dynamic>? supplierInfo;
  final String? trackingNumber;
  final String? notes;
  final String? shipmentNumber;

  const CreateShipmentParams({
    required this.companyId,
    required this.userId,
    required this.items,
    required this.time,
    required this.timezone,
    this.orderIds,
    this.counterpartyId,
    this.supplierInfo,
    this.trackingNumber,
    this.notes,
    this.shipmentNumber,
  });
}

/// Parameters for a shipment item
class CreateShipmentItemParams {
  final String productId;
  final String? variantId;
  final double quantity;
  final String unit;
  final double unitPrice;

  const CreateShipmentItemParams({
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  /// Convert to JSON for RPC
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      if (variantId != null) 'variant_id': variantId,
      'quantity': quantity,
      'unit': unit,
      'unit_price': unitPrice,
    };
  }
}

/// Response from creating a shipment
class CreateShipmentResponse {
  final bool success;
  final String? shipmentId;
  final String? shipmentNumber;
  final String? error;

  const CreateShipmentResponse({
    required this.success,
    this.shipmentId,
    this.shipmentNumber,
    this.error,
  });

  factory CreateShipmentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return CreateShipmentResponse(
      success: json['success'] as bool? ?? false,
      shipmentId: data?['shipment_id'] as String?,
      shipmentNumber: data?['shipment_number'] as String?,
      error: json['error'] as String?,
    );
  }
}

/// Counterparty info for shipment creation
class CounterpartyInfo {
  final String counterpartyId;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String type;

  const CounterpartyInfo({
    required this.counterpartyId,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.type = 'supplier',
  });

  factory CounterpartyInfo.fromJson(Map<String, dynamic> json) {
    return CounterpartyInfo(
      counterpartyId: json['counterparty_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      type: json['type'] as String? ?? 'supplier',
    );
  }
}

/// Linkable order info for shipment creation
class LinkableOrder {
  final String orderId;
  final String orderNumber;
  final String? orderDate;
  final String? supplierName;
  final double totalAmount;
  final String status;

  const LinkableOrder({
    required this.orderId,
    required this.orderNumber,
    this.orderDate,
    this.supplierName,
    this.totalAmount = 0.0,
    this.status = 'pending',
  });

  factory LinkableOrder.fromJson(Map<String, dynamic> json) {
    return LinkableOrder(
      orderId: json['order_id'] as String? ?? '',
      orderNumber: json['order_number'] as String? ?? '',
      orderDate: json['order_date'] as String?,
      supplierName: json['supplier_name'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'pending',
    );
  }

  /// Display name for selection UI
  String get displayName =>
      '$orderNumber${supplierName != null && supplierName!.isNotEmpty ? ' - $supplierName' : ''}';

  /// Status display label
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'process':
        return 'Processing';
      default:
        return status;
    }
  }
}
