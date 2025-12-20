import '../../domain/entities/session_item.dart';

/// Data model for SessionItem with JSON serialization
class SessionItemModel {
  final String itemId;
  final String sessionId;
  final String productId;
  final String productName;
  final String? sku;
  final String? barcode;
  final String? imageUrl;
  final int quantity;
  final double? unitPrice;
  final DateTime addedAt;
  final String? notes;

  const SessionItemModel({
    required this.itemId,
    required this.sessionId,
    required this.productId,
    required this.productName,
    this.sku,
    this.barcode,
    this.imageUrl,
    required this.quantity,
    this.unitPrice,
    required this.addedAt,
    this.notes,
  });

  factory SessionItemModel.fromJson(Map<String, dynamic> json) {
    return SessionItemModel(
      itemId: json['item_id']?.toString() ?? json['id']?.toString() ?? '',
      sessionId: json['session_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
      imageUrl: json['image_url']?.toString() ?? json['thumbnail']?.toString(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      addedAt: json['added_at'] != null
          ? DateTime.parse(json['added_at'].toString())
          : DateTime.now(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'session_id': sessionId,
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'barcode': barcode,
      'image_url': imageUrl,
      'quantity': quantity,
      'unit_price': unitPrice,
      'added_at': addedAt.toIso8601String(),
      'notes': notes,
    };
  }

  SessionItem toEntity() {
    return SessionItem(
      itemId: itemId,
      sessionId: sessionId,
      productId: productId,
      productName: productName,
      sku: sku,
      barcode: barcode,
      imageUrl: imageUrl,
      quantity: quantity,
      unitPrice: unitPrice,
      addedAt: addedAt,
      notes: notes,
    );
  }
}
