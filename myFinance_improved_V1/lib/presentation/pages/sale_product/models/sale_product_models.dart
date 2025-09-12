import 'package:flutter/material.dart';
import 'package:myfinance_improved/core/themes/index.dart';

// Cart Item Model
class CartItem {
  final String id;
  final String productId;
  final String sku;
  final String name;
  final String? image;
  final double price;
  int quantity;
  final int available;
  final int customerOrdered;

  CartItem({
    required this.id,
    required this.productId,
    required this.sku,
    required this.name,
    this.image,
    required this.price,
    required this.quantity,
    required this.available,
    this.customerOrdered = 0,
  });

  double get subtotal => price * quantity;

  CartItem copyWith({
    String? id,
    String? productId,
    String? sku,
    String? name,
    String? image,
    double? price,
    int? quantity,
    int? available,
    int? customerOrdered,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      available: available ?? this.available,
      customerOrdered: customerOrdered ?? this.customerOrdered,
    );
  }
}

// Invoice Model
class SaleInvoice {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final String? customerId;
  final String customerName;
  final String? customerPhone;
  final String? priceBookId;
  final String priceBookName;
  final List<CartItem> items;
  final double subtotal;
  final double discountPercentage;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final InvoiceStatus status;
  final PaymentMethod? paymentMethod;
  final double paidAmount;
  final double changeAmount;
  final DeliveryInfo? deliveryInfo;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SaleInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    this.customerId,
    required this.customerName,
    this.customerPhone,
    this.priceBookId,
    required this.priceBookName,
    required this.items,
    required this.subtotal,
    this.discountPercentage = 0,
    this.discountAmount = 0,
    this.taxAmount = 0,
    required this.total,
    this.status = InvoiceStatus.draft,
    this.paymentMethod,
    this.paidAmount = 0,
    this.changeAmount = 0,
    this.deliveryInfo,
    required this.createdAt,
    this.updatedAt,
  });

  factory SaleInvoice.empty() {
    final now = DateTime.now();
    return SaleInvoice(
      id: '',
      invoiceNumber: '',
      date: now,
      customerName: 'Guest',
      priceBookName: 'General price book',
      items: [],
      subtotal: 0,
      total: 0,
      createdAt: now,
    );
  }

  SaleInvoice copyWith({
    String? id,
    String? invoiceNumber,
    DateTime? date,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? priceBookId,
    String? priceBookName,
    List<CartItem>? items,
    double? subtotal,
    double? discountPercentage,
    double? discountAmount,
    double? taxAmount,
    double? total,
    InvoiceStatus? status,
    PaymentMethod? paymentMethod,
    double? paidAmount,
    double? changeAmount,
    DeliveryInfo? deliveryInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SaleInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      priceBookId: priceBookId ?? this.priceBookId,
      priceBookName: priceBookName ?? this.priceBookName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: paidAmount ?? this.paidAmount,
      changeAmount: changeAmount ?? this.changeAmount,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double calculateTotal() {
    final discounted = subtotal - (subtotal * discountPercentage / 100) - discountAmount;
    return discounted + taxAmount;
  }

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

// Invoice Status
enum InvoiceStatus {
  draft,
  pending,
  paid,
  cancelled,
  refunded;

  String get displayName {
    switch (this) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
      case InvoiceStatus.refunded:
        return 'Refunded';
    }
  }

  Color get color {
    switch (this) {
      case InvoiceStatus.draft:
        return TossColors.gray500;
      case InvoiceStatus.pending:
        return TossColors.warning;
      case InvoiceStatus.paid:
        return TossColors.success;
      case InvoiceStatus.cancelled:
        return TossColors.error;
      case InvoiceStatus.refunded:
        return TossColors.primary;
    }
  }
}

// Payment Method
enum PaymentMethod {
  cash,
  bankTransfer,
  card,
  digitalWallet,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank transfer';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.digitalWallet:
        return 'Digital Wallet';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.digitalWallet:
        return Icons.phone_android;
      case PaymentMethod.other:
        return Icons.payment;
    }
  }
}

// Delivery Info
class DeliveryInfo {
  final bool isDelivery;
  final String? address;
  final String? district;
  final String? city;
  final String? phone;
  final String? recipientName;
  final DateTime? deliveryDate;
  final String? notes;

  DeliveryInfo({
    required this.isDelivery,
    this.address,
    this.district,
    this.city,
    this.phone,
    this.recipientName,
    this.deliveryDate,
    this.notes,
  });

  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    return parts.join(', ');
  }

  DeliveryInfo copyWith({
    bool? isDelivery,
    String? address,
    String? district,
    String? city,
    String? phone,
    String? recipientName,
    DateTime? deliveryDate,
    String? notes,
  }) {
    return DeliveryInfo(
      isDelivery: isDelivery ?? this.isDelivery,
      address: address ?? this.address,
      district: district ?? this.district,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      recipientName: recipientName ?? this.recipientName,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      notes: notes ?? this.notes,
    );
  }
}

// Sales Summary
class SalesSummary {
  final DateTime date;
  final int totalTransactions;
  final double totalRevenue;
  final double totalDiscount;
  final double totalTax;
  final int totalItems;
  final Map<PaymentMethod, double> paymentBreakdown;
  final List<SaleInvoice> recentSales;

  SalesSummary({
    required this.date,
    required this.totalTransactions,
    required this.totalRevenue,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalItems,
    required this.paymentBreakdown,
    required this.recentSales,
  });

  double get averageTransactionValue => 
      totalTransactions > 0 ? totalRevenue / totalTransactions : 0;
}