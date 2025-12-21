import 'product_model.dart';

// Purchase Order Models

class PurchaseOrder {
  final String id;
  final String orderNumber;
  final Supplier supplier;
  final List<PurchaseOrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double shippingCost;
  final double totalAmount;
  final OrderStatus status;
  final DateTime orderDate;
  final DateTime expectedDelivery;
  final DateTime? receivedDate;
  final PaymentTerms paymentTerms;
  final String? notes;
  
  PurchaseOrder({
    required this.id,
    required this.orderNumber,
    required this.supplier,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.shippingCost,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.expectedDelivery,
    this.receivedDate,
    required this.paymentTerms,
    this.notes,
  });
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  PurchaseOrder copyWith({
    String? id,
    String? orderNumber,
    Supplier? supplier,
    List<PurchaseOrderItem>? items,
    double? subtotal,
    double? taxAmount,
    double? shippingCost,
    double? totalAmount,
    OrderStatus? status,
    DateTime? orderDate,
    DateTime? expectedDelivery,
    DateTime? receivedDate,
    PaymentTerms? paymentTerms,
    String? notes,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      supplier: supplier ?? this.supplier,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      shippingCost: shippingCost ?? this.shippingCost,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      expectedDelivery: expectedDelivery ?? this.expectedDelivery,
      receivedDate: receivedDate ?? this.receivedDate,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      notes: notes ?? this.notes,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'supplier': supplier.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'shipping_cost': shippingCost,
      'total_amount': totalAmount,
      'status': status.name,
      'order_date': orderDate.toIso8601String(),
      'expected_delivery': expectedDelivery.toIso8601String(),
      'received_date': receivedDate?.toIso8601String(),
      'payment_terms': paymentTerms.name,
      'notes': notes,
    };
  }
  
  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'],
      orderNumber: json['order_number'],
      supplier: Supplier.fromJson(json['supplier']),
      items: (json['items'] as List).map((item) => PurchaseOrderItem.fromJson(item)).toList(),
      subtotal: json['subtotal'].toDouble(),
      taxAmount: json['tax_amount'].toDouble(),
      shippingCost: json['shipping_cost'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
      orderDate: DateTime.parse(json['order_date']),
      expectedDelivery: DateTime.parse(json['expected_delivery']),
      receivedDate: json['received_date'] != null ? DateTime.parse(json['received_date']) : null,
      paymentTerms: PaymentTerms.values.firstWhere((e) => e.name == json['payment_terms']),
      notes: json['notes'],
    );
  }
}

class PurchaseOrderItem {
  final Product product;
  final int quantity;
  final double unitCost;
  final int? receivedQuantity;
  final String? notes;
  
  PurchaseOrderItem({
    required this.product,
    required this.quantity,
    required this.unitCost,
    this.receivedQuantity,
    this.notes,
  });
  
  double get subtotal => quantity * unitCost;
  
  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'product': product.toJson(),
      'quantity': quantity,
      'unit_cost': unitCost,
      'received_quantity': receivedQuantity,
      'notes': notes,
    };
  }
  
  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitCost: json['unit_cost'].toDouble(),
      receivedQuantity: json['received_quantity'],
      notes: json['notes'],
    );
  }
}

class Supplier {
  final String id;
  final String name;
  final String? contact;
  final String? email;
  final String? phone;
  final String? address;
  final String? taxId;
  final PaymentTerms? defaultPaymentTerms;
  final double? rating;
  final int? totalOrders;
  final DateTime? lastOrderDate;
  
  Supplier({
    required this.id,
    required this.name,
    this.contact,
    this.email,
    this.phone,
    this.address,
    this.taxId,
    this.defaultPaymentTerms,
    this.rating,
    this.totalOrders,
    this.lastOrderDate,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'email': email,
      'phone': phone,
      'address': address,
      'tax_id': taxId,
      'default_payment_terms': defaultPaymentTerms?.name,
      'rating': rating,
      'total_orders': totalOrders,
      'last_order_date': lastOrderDate?.toIso8601String(),
    };
  }
  
  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      contact: json['contact'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      taxId: json['tax_id'],
      defaultPaymentTerms: json['default_payment_terms'] != null
          ? PaymentTerms.values.firstWhere((e) => e.name == json['default_payment_terms'])
          : null,
      rating: json['rating']?.toDouble(),
      totalOrders: json['total_orders'],
      lastOrderDate: json['last_order_date'] != null ? DateTime.parse(json['last_order_date']) : null,
    );
  }
}

enum OrderStatus {
  draft,
  submitted,
  approved,
  shipped,
  received,
  cancelled;
  
  String get displayName {
    switch (this) {
      case OrderStatus.draft:
        return 'Draft';
      case OrderStatus.submitted:
        return 'Submitted';
      case OrderStatus.approved:
        return 'Approved';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.received:
        return 'Received';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum PaymentTerms {
  immediate,
  net15,
  net30,
  net45,
  net60,
  custom;
  
  String get displayName {
    switch (this) {
      case PaymentTerms.immediate:
        return 'Immediate';
      case PaymentTerms.net15:
        return 'Net 15 Days';
      case PaymentTerms.net30:
        return 'Net 30 Days';
      case PaymentTerms.net45:
        return 'Net 45 Days';
      case PaymentTerms.net60:
        return 'Net 60 Days';
      case PaymentTerms.custom:
        return 'Custom Terms';
    }
  }
  
  int get days {
    switch (this) {
      case PaymentTerms.immediate:
        return 0;
      case PaymentTerms.net15:
        return 15;
      case PaymentTerms.net30:
        return 30;
      case PaymentTerms.net45:
        return 45;
      case PaymentTerms.net60:
        return 60;
      case PaymentTerms.custom:
        return 0;
    }
  }
}