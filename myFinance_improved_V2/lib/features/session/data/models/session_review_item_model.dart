import '../../domain/entities/session_review_item.dart';

/// Model for ScannedByUser with JSON serialization
class ScannedByUserModel {
  final String userId;
  final String userName;
  final int quantity;
  final int quantityRejected;

  const ScannedByUserModel({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.quantityRejected,
  });

  factory ScannedByUserModel.fromJson(Map<String, dynamic> json) {
    return ScannedByUserModel(
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'quantity': quantity,
      'quantity_rejected': quantityRejected,
    };
  }

  ScannedByUser toEntity() {
    return ScannedByUser(
      userId: userId,
      userName: userName,
      quantity: quantity,
      quantityRejected: quantityRejected,
    );
  }
}

/// Model for SessionReviewItem with JSON serialization
/// Supports v2 variants with variantId and displayName
class SessionReviewItemModel {
  final String productId;
  final String productName;
  final String? sku;
  final String? imageUrl;
  final String? brand;
  final String? category;
  final int totalQuantity;
  final int totalRejected;
  final int previousStock;
  final List<ScannedByUserModel> scannedBy;
  final String sessionType;
  // v2 variant fields
  final String? variantId;
  final String? variantName;
  final String? displayName;
  final String? variantSku;
  final String? displaySku;
  final bool hasVariants;

  const SessionReviewItemModel({
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    this.brand,
    this.category,
    required this.totalQuantity,
    required this.totalRejected,
    this.previousStock = 0,
    required this.scannedBy,
    this.sessionType = 'receiving',
    this.variantId,
    this.variantName,
    this.displayName,
    this.variantSku,
    this.displaySku,
    this.hasVariants = false,
  });

  factory SessionReviewItemModel.fromJson(Map<String, dynamic> json) {
    final scannedByList = (json['scanned_by'] as List<dynamic>?)
            ?.map((e) => ScannedByUserModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Handle image URL from various formats
    String? imageUrl;
    if (json['images'] is Map) {
      final images = json['images'] as Map<String, dynamic>;
      imageUrl = images['thumbnail']?.toString() ?? images['main_image']?.toString();
    } else if (json['image_urls'] is List) {
      final urls = json['image_urls'] as List;
      if (urls.isNotEmpty) imageUrl = urls.first.toString();
    } else {
      imageUrl = json['image_url']?.toString() ?? json['thumbnail']?.toString();
    }

    return SessionReviewItemModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      imageUrl: imageUrl,
      brand: json['brand']?.toString(),
      category: json['category']?.toString(),
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      previousStock: (json['previous_stock'] as num?)?.toInt() ??
                     (json['current_stock'] as num?)?.toInt() ?? 0,
      scannedBy: scannedByList,
      sessionType: json['session_type']?.toString() ?? 'receiving',
      // v2 variant fields
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
      variantSku: json['variant_sku']?.toString(),
      displaySku: json['display_sku']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'image_url': imageUrl,
      'brand': brand,
      'category': category,
      'total_quantity': totalQuantity,
      'total_rejected': totalRejected,
      'previous_stock': previousStock,
      'session_type': sessionType,
      'scanned_by': scannedBy.map((e) => e.toJson()).toList(),
      // v2 variant fields
      'variant_id': variantId,
      'variant_name': variantName,
      'display_name': displayName,
      'variant_sku': variantSku,
      'display_sku': displaySku,
      'has_variants': hasVariants,
    };
  }

  SessionReviewItem toEntity() {
    return SessionReviewItem(
      productId: productId,
      productName: productName,
      sku: sku,
      imageUrl: imageUrl,
      brand: brand,
      category: category,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
      previousStock: previousStock,
      scannedBy: scannedBy.map((e) => e.toEntity()).toList(),
      sessionType: sessionType,
      // v2 variant fields
      variantId: variantId,
      variantName: variantName,
      displayName: displayName,
      variantSku: variantSku,
      displaySku: displaySku,
      hasVariants: hasVariants,
    );
  }
}

/// Model for SessionReviewSummary with JSON serialization
class SessionReviewSummaryModel {
  final int totalProducts;
  final int totalQuantity;
  final int totalRejected;
  final int totalParticipants;

  const SessionReviewSummaryModel({
    required this.totalProducts,
    required this.totalQuantity,
    required this.totalRejected,
    this.totalParticipants = 0,
  });

  factory SessionReviewSummaryModel.fromJson(Map<String, dynamic> json) {
    return SessionReviewSummaryModel(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      totalParticipants: (json['total_participants'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_products': totalProducts,
      'total_quantity': totalQuantity,
      'total_rejected': totalRejected,
      'total_participants': totalParticipants,
    };
  }

  SessionReviewSummary toEntity() {
    return SessionReviewSummary(
      totalProducts: totalProducts,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
      totalParticipants: totalParticipants,
    );
  }
}

/// Model for SessionParticipant with JSON serialization
class SessionParticipantModel {
  final String userId;
  final String userName;
  final String? userProfileImage;
  final int productCount;
  final int totalScanned;

  const SessionParticipantModel({
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.productCount,
    required this.totalScanned,
  });

  factory SessionParticipantModel.fromJson(Map<String, dynamic> json) {
    return SessionParticipantModel(
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      userProfileImage: json['user_profile_image']?.toString(),
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      totalScanned: (json['total_scanned'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_profile_image': userProfileImage,
      'product_count': productCount,
      'total_scanned': totalScanned,
    };
  }

  SessionParticipant toEntity() {
    return SessionParticipant(
      userId: userId,
      userName: userName,
      userProfileImage: userProfileImage,
      productCount: productCount,
      totalScanned: totalScanned,
    );
  }
}

/// Model for SessionReviewResponse with JSON serialization
class SessionReviewResponseModel {
  final String sessionId;
  final List<SessionReviewItemModel> items;
  final List<SessionParticipantModel> participants;
  final SessionReviewSummaryModel summary;

  const SessionReviewResponseModel({
    required this.sessionId,
    required this.items,
    required this.participants,
    required this.summary,
  });

  factory SessionReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final items = itemsJson
        .map((e) => SessionReviewItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    final participants = participantsJson
        .map((e) => SessionParticipantModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final summaryJson = json['summary'] as Map<String, dynamic>? ?? {};
    final summary = SessionReviewSummaryModel.fromJson(summaryJson);

    return SessionReviewResponseModel(
      sessionId: json['session_id']?.toString() ?? '',
      items: items,
      participants: participants,
      summary: summary,
    );
  }

  SessionReviewResponse toEntity() {
    return SessionReviewResponse(
      sessionId: sessionId,
      items: items.map((e) => e.toEntity()).toList(),
      participants: participants.map((e) => e.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

/// Model for StockChangeItem with JSON serialization
class StockChangeItemModel {
  final String productId;
  final String? sku;
  final String productName;
  final int quantityBefore;
  final int quantityReceived;
  final int quantityAfter;
  final bool needsDisplay;

  const StockChangeItemModel({
    required this.productId,
    this.sku,
    required this.productName,
    required this.quantityBefore,
    required this.quantityReceived,
    required this.quantityAfter,
    required this.needsDisplay,
  });

  factory StockChangeItemModel.fromJson(Map<String, dynamic> json) {
    return StockChangeItemModel(
      productId: json['product_id']?.toString() ?? '',
      sku: json['sku']?.toString(),
      productName: json['product_name']?.toString() ?? '',
      quantityBefore: (json['quantity_before'] as num?)?.toInt() ?? 0,
      quantityReceived: (json['quantity_received'] as num?)?.toInt() ?? 0,
      quantityAfter: (json['quantity_after'] as num?)?.toInt() ?? 0,
      needsDisplay: json['needs_display'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'sku': sku,
      'product_name': productName,
      'quantity_before': quantityBefore,
      'quantity_received': quantityReceived,
      'quantity_after': quantityAfter,
      'needs_display': needsDisplay,
    };
  }

  StockChangeItem toEntity() {
    return StockChangeItem(
      productId: productId,
      sku: sku,
      productName: productName,
      quantityBefore: quantityBefore,
      quantityReceived: quantityReceived,
      quantityAfter: quantityAfter,
      needsDisplay: needsDisplay,
    );
  }
}

/// Model for SessionSubmitResponse with JSON serialization
class SessionSubmitResponseModel {
  final String sessionType;
  final String receivingId;
  final String receivingNumber;
  final String sessionId;
  final bool isFinal;
  final int itemsCount;
  final int totalQuantity;
  final int totalRejected;
  final bool stockUpdated;
  final List<StockChangeItemModel> stockChanges;
  final int newDisplayCount;

  const SessionSubmitResponseModel({
    this.sessionType = 'receiving',
    required this.receivingId,
    required this.receivingNumber,
    required this.sessionId,
    required this.isFinal,
    required this.itemsCount,
    required this.totalQuantity,
    required this.totalRejected,
    required this.stockUpdated,
    this.stockChanges = const [],
    this.newDisplayCount = 0,
  });

  factory SessionSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    // Parse stock_changes array (receiving only)
    final stockChangesJson = json['stock_changes'] as List<dynamic>? ?? [];
    final stockChanges = stockChangesJson
        .map((e) => StockChangeItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionSubmitResponseModel(
      sessionType: json['session_type']?.toString() ?? 'receiving',
      receivingId: json['receiving_id']?.toString() ?? '',
      receivingNumber: json['receiving_number']?.toString() ?? '',
      sessionId: json['session_id']?.toString() ?? '',
      isFinal: json['is_final'] as bool? ?? false,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      stockUpdated: json['stock_updated'] as bool? ?? false,
      stockChanges: stockChanges,
      newDisplayCount: (json['new_display_count'] as num?)?.toInt() ?? 0,
    );
  }

  SessionSubmitResponse toEntity() {
    return SessionSubmitResponse(
      sessionType: sessionType,
      receivingId: receivingId,
      receivingNumber: receivingNumber,
      sessionId: sessionId,
      isFinal: isFinal,
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
      stockUpdated: stockUpdated,
      stockChanges: stockChanges.map((e) => e.toEntity()).toList(),
      newDisplayCount: newDisplayCount,
    );
  }
}
