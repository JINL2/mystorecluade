import 'package:equatable/equatable.dart';

/// Invoice Detail Item entity
class InvoiceDetailItem extends Equatable {
  final String invoiceItemId;
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? productImage;
  final String? brandName;
  final String? categoryName;
  final int quantity;
  final double unitPrice;
  final double unitCost;
  final double discountAmount;
  final double totalPrice;
  final double totalCost;

  const InvoiceDetailItem({
    required this.invoiceItemId,
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.productImage,
    this.brandName,
    this.categoryName,
    required this.quantity,
    required this.unitPrice,
    required this.unitCost,
    required this.discountAmount,
    required this.totalPrice,
    required this.totalCost,
  });

  /// Calculate profit for this item
  double get profit => totalPrice - totalCost;

  @override
  List<Object?> get props => [
        invoiceItemId,
        productId,
        productName,
        sku,
        barcode,
        productImage,
        brandName,
        categoryName,
        quantity,
        unitPrice,
        unitCost,
        discountAmount,
        totalPrice,
        totalCost,
      ];
}

/// Invoice Detail entity with full item information
class InvoiceDetail extends Equatable {
  final String invoiceId;
  final String invoiceNumber;
  final DateTime saleDate;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String? cashLocationId;
  final String? cashLocationName;
  final String? cashLocationType;
  final String storeId;
  final String storeName;
  final String storeCode;
  final String? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerType;
  final String? createdById;
  final String? createdByName;
  final String? createdByEmail;
  final String? createdByProfileImage;
  final DateTime createdAt;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final double totalCost;
  final double profit;
  final List<InvoiceDetailItem> items;

  const InvoiceDetail({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.saleDate,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.cashLocationId,
    this.cashLocationName,
    this.cashLocationType,
    required this.storeId,
    required this.storeName,
    required this.storeCode,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerType,
    this.createdById,
    this.createdByName,
    this.createdByEmail,
    this.createdByProfileImage,
    required this.createdAt,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.totalCost,
    required this.profit,
    required this.items,
  });

  /// Helper getters for status checking
  bool get isCompleted => status == 'completed';
  bool get isDraft => status == 'draft';
  bool get isCancelled => status == 'cancelled';

  /// Helper getters for payment status
  bool get isPaid => paymentStatus == 'paid';
  bool get isPending => paymentStatus == 'pending';

  /// Get total item count
  int get itemCount => items.length;

  /// Get total quantity
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get formatted time string (HH:mm)
  String get timeString {
    return '${saleDate.hour.toString().padLeft(2, '0')}:${saleDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        invoiceId,
        invoiceNumber,
        saleDate,
        status,
        paymentMethod,
        paymentStatus,
        cashLocationId,
        cashLocationName,
        cashLocationType,
        storeId,
        storeName,
        storeCode,
        customerId,
        customerName,
        customerPhone,
        customerType,
        createdById,
        createdByName,
        createdByEmail,
        createdByProfileImage,
        createdAt,
        subtotal,
        taxAmount,
        discountAmount,
        totalAmount,
        totalCost,
        profit,
        items,
      ];
}
