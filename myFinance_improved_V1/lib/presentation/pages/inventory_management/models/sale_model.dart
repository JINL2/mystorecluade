import 'package:flutter/material.dart';
import 'product_model.dart';

class Sale {
  final String id;
  final String invoiceNumber;
  final DateTime saleDate;
  final String customerName;
  final String? customerPhone;
  final String? customerEmail;
  final List<SaleItem> items;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final SaleStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.saleDate,
    required this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.items,
    required this.subtotal,
    this.discountAmount = 0.0,
    required this.taxAmount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Sale copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? saleDate,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<SaleItem>? items,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? totalAmount,
    PaymentMethod? paymentMethod,
    SaleStatus? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sale(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      saleDate: saleDate ?? this.saleDate,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'sale_date': saleDate.toIso8601String(),
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'payment_method': paymentMethod.name,
      'status': status.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      saleDate: DateTime.parse(json['sale_date']),
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      items: (json['items'] as List).map((item) => SaleItem.fromJson(item)).toList(),
      subtotal: json['subtotal'].toDouble(),
      discountAmount: json['discount_amount']?.toDouble() ?? 0.0,
      taxAmount: json['tax_amount'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere((e) => e.name == json['payment_method']),
      status: SaleStatus.values.firstWhere((e) => e.name == json['status']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class SaleItem {
  final Product product;
  final int quantity;
  final double unitPrice;
  final double discount;
  final double totalPrice;

  SaleItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.totalPrice,
  });

  double get subtotal => (unitPrice * quantity) - discount;

  SaleItem copyWith({
    Product? product,
    int? quantity,
    double? unitPrice,
    double? discount,
    double? totalPrice,
  }) {
    return SaleItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product.id,
      'product': product.toJson(),
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount': discount,
      'total_price': totalPrice,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      discount: json['discount']?.toDouble() ?? 0.0,
      totalPrice: json['total_price'].toDouble(),
    );
  }
}

enum SaleStatus {
  pending,
  completed,
  refunded,
  cancelled;

  String get displayName {
    switch (this) {
      case SaleStatus.pending:
        return 'Pending';
      case SaleStatus.completed:
        return 'Completed';
      case SaleStatus.refunded:
        return 'Refunded';
      case SaleStatus.cancelled:
        return 'Cancelled';
    }
  }
}

enum PaymentMethod {
  cash,
  card,
  digital;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.digital:
        return 'Digital Payment';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.digital:
        return Icons.smartphone;
    }
  }
}