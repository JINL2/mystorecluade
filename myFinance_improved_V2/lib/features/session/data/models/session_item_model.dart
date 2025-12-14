import '../../domain/entities/session_item.dart';

/// Data model for SessionItem with JSON serialization
class SessionItemModel extends SessionItem {
  const SessionItemModel({
    required super.itemId,
    required super.sessionId,
    required super.productId,
    required super.productName,
    super.sku,
    super.barcode,
    super.imageUrl,
    required super.quantity,
    super.unitPrice,
    required super.addedAt,
    super.notes,
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

  SessionItem toEntity() => this;
}
