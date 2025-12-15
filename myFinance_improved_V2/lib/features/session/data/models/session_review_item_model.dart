import '../../domain/entities/session_review_item.dart';

/// Model for ScannedByUser with JSON serialization
class ScannedByUserModel extends ScannedByUser {
  const ScannedByUserModel({
    required super.userId,
    required super.userName,
    required super.quantity,
    required super.quantityRejected,
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
}

/// Model for SessionReviewItem with JSON serialization
class SessionReviewItemModel extends SessionReviewItem {
  const SessionReviewItemModel({
    required super.productId,
    required super.productName,
    super.sku,
    required super.totalQuantity,
    required super.totalRejected,
    required super.scannedBy,
  });

  factory SessionReviewItemModel.fromJson(Map<String, dynamic> json) {
    final scannedByList = (json['scanned_by'] as List<dynamic>?)
            ?.map((e) => ScannedByUserModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SessionReviewItemModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: scannedByList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'sku': sku,
      'total_quantity': totalQuantity,
      'total_rejected': totalRejected,
      'scanned_by': scannedBy
          .map((e) => (e as ScannedByUserModel).toJson())
          .toList(),
    };
  }
}

/// Model for SessionReviewSummary with JSON serialization
class SessionReviewSummaryModel extends SessionReviewSummary {
  const SessionReviewSummaryModel({
    required super.totalProducts,
    required super.totalQuantity,
    required super.totalRejected,
    super.totalParticipants,
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
}

/// Model for SessionParticipant with JSON serialization
class SessionParticipantModel extends SessionParticipant {
  const SessionParticipantModel({
    required super.userId,
    required super.userName,
    super.userProfileImage,
    required super.productCount,
    required super.totalScanned,
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
}

/// Model for SessionReviewResponse with JSON serialization
class SessionReviewResponseModel extends SessionReviewResponse {
  const SessionReviewResponseModel({
    required super.sessionId,
    required super.items,
    required super.participants,
    required super.summary,
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
}

/// Model for SessionSubmitResponse with JSON serialization
class SessionSubmitResponseModel extends SessionSubmitResponse {
  const SessionSubmitResponseModel({
    required super.receivingId,
    required super.receivingNumber,
    required super.sessionId,
    required super.isFinal,
    required super.itemsCount,
    required super.totalQuantity,
    required super.totalRejected,
    required super.stockUpdated,
  });

  factory SessionSubmitResponseModel.fromJson(Map<String, dynamic> json) {
    return SessionSubmitResponseModel(
      receivingId: json['receiving_id']?.toString() ?? '',
      receivingNumber: json['receiving_number']?.toString() ?? '',
      sessionId: json['session_id']?.toString() ?? '',
      isFinal: json['is_final'] as bool? ?? false,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      stockUpdated: json['stock_updated'] as bool? ?? false,
    );
  }
}
