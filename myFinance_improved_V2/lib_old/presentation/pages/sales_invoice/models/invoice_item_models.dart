import 'package:flutter/material.dart';

// Invoice Item model for detailed invoice view
class InvoiceItem {
  final String itemId;
  final String productId;
  final String productName;
  final String sku;
  final String? barcode;
  final String? brand;
  final String? category;
  final String? unit;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final double? discountAmount;
  final double? discountPercentage;
  final double? taxAmount;
  final double? taxPercentage;
  final double totalAmount;
  final String? notes;

  InvoiceItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    required this.sku,
    this.barcode,
    this.brand,
    this.category,
    this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.discountAmount,
    this.discountPercentage,
    this.taxAmount,
    this.taxPercentage,
    required this.totalAmount,
    this.notes,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      itemId: json['item_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString(),
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      unit: json['unit']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      taxAmount: (json['tax_amount'] as num?)?.toDouble(),
      taxPercentage: (json['tax_percentage'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'brand': brand,
      'category': category,
      'unit': unit,
      'quantity': quantity,
      'unit_price': unitPrice,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'discount_percentage': discountPercentage,
      'tax_amount': taxAmount,
      'tax_percentage': taxPercentage,
      'total_amount': totalAmount,
      'notes': notes,
    };
  }

  // Helper getters
  bool get hasDiscount => discountAmount != null && discountAmount! > 0;
  bool get hasTax => taxAmount != null && taxAmount! > 0;
  double get effectivePrice => totalAmount / quantity;
}

// Response model for fetching invoice items
class InvoiceItemsResponse {
  final bool success;
  final List<InvoiceItem> items;
  final String? message;

  InvoiceItemsResponse({
    required this.success,
    required this.items,
    this.message,
  });

  factory InvoiceItemsResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceItemsResponse(
      success: (json['success'] as bool?) ?? false,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      message: json['message']?.toString(),
    );
  }
}