import '../../domain/entities/session_history_item.dart';

/// Model for SessionHistoryUser (V2)
class SessionHistoryUserModel {
  final String userId;
  final String firstName;
  final String lastName;
  final String? profileImage;

  const SessionHistoryUserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.profileImage,
  });

  factory SessionHistoryUserModel.fromJson(Map<String, dynamic> json) {
    return SessionHistoryUserModel(
      userId: json['user_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      profileImage: json['profile_image']?.toString(),
    );
  }

  SessionHistoryUser toEntity() {
    return SessionHistoryUser(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }

  /// Get full name
  String get fullName => '$firstName $lastName'.trim();
}

/// Model for SessionHistoryMember
class SessionHistoryMemberModel {
  final String oderId;
  final String userName;
  final String joinedAt;
  final bool isActive;
  final String? profileImage;
  final String? firstName;
  final String? lastName;

  const SessionHistoryMemberModel({
    required this.oderId,
    required this.userName,
    required this.joinedAt,
    required this.isActive,
    this.profileImage,
    this.firstName,
    this.lastName,
  });

  factory SessionHistoryMemberModel.fromJson(Map<String, dynamic> json) {
    // V2 uses object format, V1 uses flat format
    final firstName = json['first_name']?.toString();
    final lastName = json['last_name']?.toString();
    final userName = json['user_name']?.toString() ??
        (firstName != null && lastName != null ? '$firstName $lastName' : '');

    return SessionHistoryMemberModel(
      oderId: json['user_id']?.toString() ?? '',
      userName: userName,
      joinedAt: json['joined_at']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
      profileImage: json['profile_image']?.toString(),
      firstName: firstName,
      lastName: lastName,
    );
  }

  SessionHistoryMember toEntity() {
    return SessionHistoryMember(
      oderId: oderId,
      userName: userName,
      joinedAt: joinedAt,
      isActive: isActive,
      profileImage: profileImage,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

/// Model for ScannedByInfo
class ScannedByInfoModel {
  final String userId;
  final String userName;
  final int quantity;
  final int quantityRejected;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  const ScannedByInfoModel({
    required this.userId,
    required this.userName,
    required this.quantity,
    required this.quantityRejected,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory ScannedByInfoModel.fromJson(Map<String, dynamic> json) {
    // V2 uses object format with first_name, last_name, profile_image
    final firstName = json['first_name']?.toString();
    final lastName = json['last_name']?.toString();
    final userName = json['user_name']?.toString() ??
        (firstName != null && lastName != null ? '$firstName $lastName' : '');

    return ScannedByInfoModel(
      userId: json['user_id']?.toString() ?? '',
      userName: userName,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
      firstName: firstName,
      lastName: lastName,
      profileImage: json['profile_image']?.toString(),
    );
  }

  ScannedByInfo toEntity() {
    return ScannedByInfo(
      userId: userId,
      userName: userName,
      quantity: quantity,
      quantityRejected: quantityRejected,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }
}

/// Model for SessionHistoryItemDetail
/// v3: Supports variant fields for variant-level grouping
class SessionHistoryItemDetailModel {
  final String productId;
  final String productName;
  final String? sku;
  // v3 variant fields
  final String? variantId;
  final String? variantName;
  final String? displayName;
  final bool hasVariants;
  final String? variantSku;
  final String? displaySku;

  final int scannedQuantity;
  final int scannedRejected;
  final List<ScannedByInfoModel> scannedBy;
  final int? confirmedQuantity;
  final int? confirmedRejected;
  final int? quantityExpected;
  final int? quantityDifference;

  const SessionHistoryItemDetailModel({
    required this.productId,
    required this.productName,
    this.sku,
    this.variantId,
    this.variantName,
    this.displayName,
    this.hasVariants = false,
    this.variantSku,
    this.displaySku,
    required this.scannedQuantity,
    required this.scannedRejected,
    required this.scannedBy,
    this.confirmedQuantity,
    this.confirmedRejected,
    this.quantityExpected,
    this.quantityDifference,
  });

  factory SessionHistoryItemDetailModel.fromJson(Map<String, dynamic> json) {
    final scannedByList = (json['scanned_by'] as List<dynamic>? ?? [])
        .map((e) => ScannedByInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryItemDetailModel(
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      sku: json['sku']?.toString(),
      // v3 variant fields
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
      variantSku: json['variant_sku']?.toString(),
      displaySku: json['display_sku']?.toString(),
      scannedQuantity: (json['scanned_quantity'] as num?)?.toInt() ?? 0,
      scannedRejected: (json['scanned_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: scannedByList,
      confirmedQuantity: (json['confirmed_quantity'] as num?)?.toInt(),
      confirmedRejected: (json['confirmed_rejected'] as num?)?.toInt(),
      quantityExpected: (json['quantity_expected'] as num?)?.toInt(),
      quantityDifference: (json['quantity_difference'] as num?)?.toInt(),
    );
  }

  SessionHistoryItemDetail toEntity() {
    return SessionHistoryItemDetail(
      productId: productId,
      productName: productName,
      sku: sku,
      // v3 variant fields
      variantId: variantId,
      variantName: variantName,
      displayName: displayName,
      hasVariants: hasVariants,
      variantSku: variantSku,
      displaySku: displaySku,
      scannedQuantity: scannedQuantity,
      scannedRejected: scannedRejected,
      scannedBy: scannedBy.map((e) => e.toEntity()).toList(),
      confirmedQuantity: confirmedQuantity,
      confirmedRejected: confirmedRejected,
      quantityExpected: quantityExpected,
      quantityDifference: quantityDifference,
    );
  }
}

/// Model for StockSnapshotItem (V2)
/// v3: Supports variant fields
class StockSnapshotItemModel {
  final String productId;
  final String sku;
  final String productName;
  final int quantityBefore;
  final int quantityReceived;
  final int quantityAfter;
  final bool needsDisplay;
  // v3 variant fields
  final String? variantId;
  final String? variantName;
  final String? displayName;

  const StockSnapshotItemModel({
    required this.productId,
    required this.sku,
    required this.productName,
    required this.quantityBefore,
    required this.quantityReceived,
    required this.quantityAfter,
    required this.needsDisplay,
    this.variantId,
    this.variantName,
    this.displayName,
  });

  factory StockSnapshotItemModel.fromJson(Map<String, dynamic> json) {
    return StockSnapshotItemModel(
      productId: json['product_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      quantityBefore: (json['quantity_before'] as num?)?.toInt() ?? 0,
      quantityReceived: (json['quantity_received'] as num?)?.toInt() ?? 0,
      quantityAfter: (json['quantity_after'] as num?)?.toInt() ?? 0,
      needsDisplay: json['needs_display'] as bool? ?? false,
      // v3 variant fields
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
    );
  }

  StockSnapshotItem toEntity() {
    return StockSnapshotItem(
      productId: productId,
      sku: sku,
      productName: productName,
      quantityBefore: quantityBefore,
      quantityReceived: quantityReceived,
      quantityAfter: quantityAfter,
      needsDisplay: needsDisplay,
      // v3 variant fields
      variantId: variantId,
      variantName: variantName,
      displayName: displayName,
    );
  }
}

/// Model for ReceivingInfo (V2)
class ReceivingInfoModel {
  final String receivingId;
  final String receivingNumber;
  final String receivedAt;
  final List<StockSnapshotItemModel> stockSnapshot;
  final int newProductsCount;
  final int restockProductsCount;

  const ReceivingInfoModel({
    required this.receivingId,
    required this.receivingNumber,
    required this.receivedAt,
    required this.stockSnapshot,
    required this.newProductsCount,
    required this.restockProductsCount,
  });

  factory ReceivingInfoModel.fromJson(Map<String, dynamic> json) {
    final snapshotList = (json['stock_snapshot'] as List<dynamic>? ?? [])
        .map((e) => StockSnapshotItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ReceivingInfoModel(
      receivingId: json['receiving_id']?.toString() ?? '',
      receivingNumber: json['receiving_number']?.toString() ?? '',
      receivedAt: json['received_at']?.toString() ?? '',
      stockSnapshot: snapshotList,
      newProductsCount: (json['new_products_count'] as num?)?.toInt() ?? 0,
      restockProductsCount: (json['restock_products_count'] as num?)?.toInt() ?? 0,
    );
  }

  ReceivingInfo toEntity() {
    return ReceivingInfo(
      receivingId: receivingId,
      receivingNumber: receivingNumber,
      receivedAt: receivedAt,
      stockSnapshot: stockSnapshot.map((e) => e.toEntity()).toList(),
      newProductsCount: newProductsCount,
      restockProductsCount: restockProductsCount,
    );
  }
}

/// Model for MergedSessionItem (V2)
/// v3: Supports variant fields
class MergedSessionItemModel {
  final String productId;
  final String sku;
  final String productName;
  final int quantity;
  final int quantityRejected;
  final SessionHistoryUserModel scannedBy;
  // v3 variant fields
  final String? variantId;
  final String? variantName;
  final String? displayName;
  final bool hasVariants;

  const MergedSessionItemModel({
    required this.productId,
    required this.sku,
    required this.productName,
    required this.quantity,
    required this.quantityRejected,
    required this.scannedBy,
    this.variantId,
    this.variantName,
    this.displayName,
    this.hasVariants = false,
  });

  factory MergedSessionItemModel.fromJson(Map<String, dynamic> json) {
    return MergedSessionItemModel(
      productId: json['product_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: SessionHistoryUserModel.fromJson(
        json['scanned_by'] as Map<String, dynamic>? ?? {},
      ),
      // v3 variant fields
      variantId: json['variant_id']?.toString(),
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
    );
  }

  MergedSessionItem toEntity() {
    return MergedSessionItem(
      productId: productId,
      sku: sku,
      productName: productName,
      quantity: quantity,
      quantityRejected: quantityRejected,
      scannedBy: scannedBy.toEntity(),
      // v3 variant fields
      variantId: variantId,
      variantName: variantName,
      displayName: displayName,
      hasVariants: hasVariants,
    );
  }
}

/// Model for MergedSessionInfo (V2)
class MergedSessionInfoModel {
  final String sourceSessionId;
  final String sourceSessionName;
  final String sourceCreatedAt;
  final SessionHistoryUserModel sourceCreatedBy;
  final List<MergedSessionItemModel> items;
  final int itemsCount;
  final int totalQuantity;
  final int totalRejected;

  const MergedSessionInfoModel({
    required this.sourceSessionId,
    required this.sourceSessionName,
    required this.sourceCreatedAt,
    required this.sourceCreatedBy,
    required this.items,
    required this.itemsCount,
    required this.totalQuantity,
    required this.totalRejected,
  });

  factory MergedSessionInfoModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map((e) => MergedSessionItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return MergedSessionInfoModel(
      sourceSessionId: json['source_session_id']?.toString() ?? '',
      sourceSessionName: json['source_session_name']?.toString() ?? '',
      sourceCreatedAt: json['source_created_at']?.toString() ?? '',
      sourceCreatedBy: SessionHistoryUserModel.fromJson(
        json['source_created_by'] as Map<String, dynamic>? ?? {},
      ),
      items: itemsList,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
    );
  }

  MergedSessionInfo toEntity() {
    return MergedSessionInfo(
      sourceSessionId: sourceSessionId,
      sourceSessionName: sourceSessionName,
      sourceCreatedAt: sourceCreatedAt,
      sourceCreatedBy: sourceCreatedBy.toEntity(),
      items: items.map((e) => e.toEntity()).toList(),
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
    );
  }
}

/// Model for OriginalSessionInfo (V2)
class OriginalSessionInfoModel {
  final List<MergedSessionItemModel> items;
  final int itemsCount;
  final int totalQuantity;
  final int totalRejected;

  const OriginalSessionInfoModel({
    required this.items,
    required this.itemsCount,
    required this.totalQuantity,
    required this.totalRejected,
  });

  factory OriginalSessionInfoModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map((e) => MergedSessionItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OriginalSessionInfoModel(
      items: itemsList,
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
    );
  }

  OriginalSessionInfo toEntity() {
    return OriginalSessionInfo(
      items: items.map((e) => e.toEntity()).toList(),
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
    );
  }
}

/// v4: Model for ProductSourceInfo (source tracking for items_by_product)
class ProductSourceInfoModel {
  final String? sessionId;
  final String sessionName;
  final bool isOriginal;
  final int quantity;
  final int quantityRejected;
  final SessionHistoryUserModel scannedBy;

  const ProductSourceInfoModel({
    this.sessionId,
    required this.sessionName,
    required this.isOriginal,
    required this.quantity,
    required this.quantityRejected,
    required this.scannedBy,
  });

  factory ProductSourceInfoModel.fromJson(Map<String, dynamic> json) {
    return ProductSourceInfoModel(
      sessionId: json['session_id']?.toString(),
      sessionName: json['session_name']?.toString() ?? '',
      isOriginal: json['is_original'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantityRejected: (json['quantity_rejected'] as num?)?.toInt() ?? 0,
      scannedBy: SessionHistoryUserModel.fromJson(
        json['scanned_by'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  ProductSourceInfo toEntity() {
    return ProductSourceInfo(
      sessionId: sessionId,
      sessionName: sessionName,
      isOriginal: isOriginal,
      quantity: quantity,
      quantityRejected: quantityRejected,
      scannedBy: scannedBy.toEntity(),
    );
  }
}

/// v4: Model for ItemByProduct (product-level source tracking)
class ItemByProductModel {
  final String productId;
  final String? variantId;
  final String sku;
  final String productName;
  final String? variantName;
  final String? displayName;
  final bool hasVariants;
  final int totalQuantity;
  final int totalRejected;
  final List<ProductSourceInfoModel> sources;

  const ItemByProductModel({
    required this.productId,
    this.variantId,
    required this.sku,
    required this.productName,
    this.variantName,
    this.displayName,
    this.hasVariants = false,
    required this.totalQuantity,
    required this.totalRejected,
    required this.sources,
  });

  factory ItemByProductModel.fromJson(Map<String, dynamic> json) {
    final sourcesList = (json['sources'] as List<dynamic>? ?? [])
        .map((e) => ProductSourceInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ItemByProductModel(
      productId: json['product_id']?.toString() ?? '',
      variantId: json['variant_id']?.toString(),
      sku: json['sku']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
      hasVariants: json['has_variants'] as bool? ?? false,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      totalRejected: (json['total_rejected'] as num?)?.toInt() ?? 0,
      sources: sourcesList,
    );
  }

  ItemByProduct toEntity() {
    return ItemByProduct(
      productId: productId,
      variantId: variantId,
      sku: sku,
      productName: productName,
      variantName: variantName,
      displayName: displayName,
      hasVariants: hasVariants,
      totalQuantity: totalQuantity,
      totalRejected: totalRejected,
      sources: sources.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Model for MergeInfo (V2)
/// v4: Added itemsByProduct for product-level source tracking
class MergeInfoModel {
  final OriginalSessionInfoModel originalSession;
  final List<MergedSessionInfoModel> mergedSessions;
  final int totalMergedSessionsCount;
  /// v4: Product-level source tracking
  final List<ItemByProductModel> itemsByProduct;

  const MergeInfoModel({
    required this.originalSession,
    required this.mergedSessions,
    required this.totalMergedSessionsCount,
    this.itemsByProduct = const [],
  });

  factory MergeInfoModel.fromJson(Map<String, dynamic> json) {
    final mergedSessionsList = (json['merged_sessions'] as List<dynamic>? ?? [])
        .map((e) => MergedSessionInfoModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final itemsByProductList = (json['items_by_product'] as List<dynamic>? ?? [])
        .map((e) => ItemByProductModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return MergeInfoModel(
      originalSession: OriginalSessionInfoModel.fromJson(
        json['original_session'] as Map<String, dynamic>? ?? {},
      ),
      mergedSessions: mergedSessionsList,
      totalMergedSessionsCount:
          (json['total_merged_sessions_count'] as num?)?.toInt() ?? 0,
      itemsByProduct: itemsByProductList,
    );
  }

  MergeInfo toEntity() {
    return MergeInfo(
      originalSession: originalSession.toEntity(),
      mergedSessions: mergedSessions.map((e) => e.toEntity()).toList(),
      totalMergedSessionsCount: totalMergedSessionsCount,
      itemsByProduct: itemsByProduct.map((e) => e.toEntity()).toList(),
    );
  }
}

/// v4: Model for ZeroedItem (zeroed items in counting sessions)
class ZeroedItemModel {
  final String productId;
  final String? variantId;
  final String sku;
  final String productName;
  final String? variantName;
  final String? displayName;
  final int quantityBefore;

  const ZeroedItemModel({
    required this.productId,
    this.variantId,
    required this.sku,
    required this.productName,
    this.variantName,
    this.displayName,
    required this.quantityBefore,
  });

  factory ZeroedItemModel.fromJson(Map<String, dynamic> json) {
    return ZeroedItemModel(
      productId: json['product_id']?.toString() ?? '',
      variantId: json['variant_id']?.toString(),
      sku: json['sku']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      variantName: json['variant_name']?.toString(),
      displayName: json['display_name']?.toString(),
      quantityBefore: (json['quantity_before'] as num?)?.toInt() ?? 0,
    );
  }

  ZeroedItem toEntity() {
    return ZeroedItem(
      productId: productId,
      variantId: variantId,
      sku: sku,
      productName: productName,
      variantName: variantName,
      displayName: displayName,
      quantityBefore: quantityBefore,
    );
  }
}

/// v4: Model for CountingInfo (counting sessions - zeroed items tracking)
class CountingInfoModel {
  final int itemsZeroedCount;
  final List<ZeroedItemModel> zeroedItems;

  const CountingInfoModel({
    required this.itemsZeroedCount,
    required this.zeroedItems,
  });

  factory CountingInfoModel.fromJson(Map<String, dynamic> json) {
    final zeroedItemsList = (json['zeroed_items'] as List<dynamic>? ?? [])
        .map((e) => ZeroedItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return CountingInfoModel(
      itemsZeroedCount: (json['items_zeroed_count'] as num?)?.toInt() ?? 0,
      zeroedItems: zeroedItemsList,
    );
  }

  CountingInfo toEntity() {
    return CountingInfo(
      itemsZeroedCount: itemsZeroedCount,
      zeroedItems: zeroedItems.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Model for SessionHistoryItem
class SessionHistoryItemModel {
  final String sessionId;
  final String sessionName;
  final String sessionType;
  final bool isActive;
  final bool isFinal;
  final String storeId;
  final String storeName;
  final String? shipmentId;
  final String? shipmentNumber;
  final String createdAt;
  final String? completedAt;
  final int? durationMinutes;
  // V2: createdBy is now an object
  final String createdBy;
  final String createdByName;
  final String? createdByFirstName;
  final String? createdByLastName;
  final String? createdByProfileImage;
  final List<SessionHistoryMemberModel> members;
  final int memberCount;
  final List<SessionHistoryItemDetailModel> items;
  final int totalScannedQuantity;
  final int totalScannedRejected;
  final int? totalConfirmedQuantity;
  final int? totalConfirmedRejected;
  final int? totalDifference;
  // V2: Merge info
  final bool isMergedSession;
  final MergeInfoModel? mergeInfo;
  // V2: Receiving info
  final ReceivingInfoModel? receivingInfo;
  // v4: Counting info
  final CountingInfoModel? countingInfo;

  const SessionHistoryItemModel({
    required this.sessionId,
    required this.sessionName,
    required this.sessionType,
    required this.isActive,
    required this.isFinal,
    required this.storeId,
    required this.storeName,
    this.shipmentId,
    this.shipmentNumber,
    required this.createdAt,
    this.completedAt,
    this.durationMinutes,
    required this.createdBy,
    required this.createdByName,
    this.createdByFirstName,
    this.createdByLastName,
    this.createdByProfileImage,
    required this.members,
    required this.memberCount,
    required this.items,
    required this.totalScannedQuantity,
    required this.totalScannedRejected,
    this.totalConfirmedQuantity,
    this.totalConfirmedRejected,
    this.totalDifference,
    this.isMergedSession = false,
    this.mergeInfo,
    this.receivingInfo,
    this.countingInfo,
  });

  factory SessionHistoryItemModel.fromJson(Map<String, dynamic> json) {
    final membersList = (json['members'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryMemberModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryItemDetailModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // V2: Parse created_by object
    final createdByData = json['created_by'];
    String createdById;
    String createdByName;
    String? createdByFirstName;
    String? createdByLastName;
    String? createdByProfileImage;

    if (createdByData is Map<String, dynamic>) {
      // V2 format: created_by is an object
      createdById = createdByData['user_id']?.toString() ?? '';
      createdByFirstName = createdByData['first_name']?.toString();
      createdByLastName = createdByData['last_name']?.toString();
      createdByProfileImage = createdByData['profile_image']?.toString();
      createdByName = '$createdByFirstName $createdByLastName'.trim();
    } else {
      // V1 format: created_by is a string (user_id)
      createdById = createdByData?.toString() ?? '';
      createdByName = json['created_by_name']?.toString() ?? '';
      createdByFirstName = null;
      createdByLastName = null;
      createdByProfileImage = null;
    }

    // V2: Parse merge_info
    MergeInfoModel? mergeInfoModel;
    final mergeInfoData = json['merge_info'];
    if (mergeInfoData != null && mergeInfoData is Map<String, dynamic>) {
      mergeInfoModel = MergeInfoModel.fromJson(mergeInfoData);
    }

    // V2: Parse receiving_info
    ReceivingInfoModel? receivingInfoModel;
    final receivingInfoData = json['receiving_info'];
    if (receivingInfoData != null && receivingInfoData is Map<String, dynamic>) {
      receivingInfoModel = ReceivingInfoModel.fromJson(receivingInfoData);
    }

    // v4: Parse counting_info
    CountingInfoModel? countingInfoModel;
    final countingInfoData = json['counting_info'];
    if (countingInfoData != null && countingInfoData is Map<String, dynamic>) {
      countingInfoModel = CountingInfoModel.fromJson(countingInfoData);
    }

    return SessionHistoryItemModel(
      sessionId: json['session_id']?.toString() ?? '',
      sessionName: json['session_name']?.toString() ?? '',
      sessionType: json['session_type']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? false,
      isFinal: json['is_final'] as bool? ?? false,
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString() ?? '',
      shipmentId: json['shipment_id']?.toString(),
      shipmentNumber: json['shipment_number']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      completedAt: json['completed_at']?.toString(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      createdBy: createdById,
      createdByName: createdByName,
      createdByFirstName: createdByFirstName,
      createdByLastName: createdByLastName,
      createdByProfileImage: createdByProfileImage,
      members: membersList,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      items: itemsList,
      totalScannedQuantity: (json['total_scanned_quantity'] as num?)?.toInt() ?? 0,
      totalScannedRejected: (json['total_scanned_rejected'] as num?)?.toInt() ?? 0,
      totalConfirmedQuantity: (json['total_confirmed_quantity'] as num?)?.toInt(),
      totalConfirmedRejected: (json['total_confirmed_rejected'] as num?)?.toInt(),
      totalDifference: (json['total_difference'] as num?)?.toInt(),
      isMergedSession: json['is_merged_session'] as bool? ?? false,
      mergeInfo: mergeInfoModel,
      receivingInfo: receivingInfoModel,
      countingInfo: countingInfoModel,
    );
  }

  SessionHistoryItem toEntity() {
    return SessionHistoryItem(
      sessionId: sessionId,
      sessionName: sessionName,
      sessionType: sessionType,
      isActive: isActive,
      isFinal: isFinal,
      storeId: storeId,
      storeName: storeName,
      shipmentId: shipmentId,
      shipmentNumber: shipmentNumber,
      createdAt: createdAt,
      completedAt: completedAt,
      durationMinutes: durationMinutes,
      createdBy: createdBy,
      createdByName: createdByName,
      createdByFirstName: createdByFirstName,
      createdByLastName: createdByLastName,
      createdByProfileImage: createdByProfileImage,
      members: members.map((e) => e.toEntity()).toList(),
      memberCount: memberCount,
      items: items.map((e) => e.toEntity()).toList(),
      totalScannedQuantity: totalScannedQuantity,
      totalScannedRejected: totalScannedRejected,
      totalConfirmedQuantity: totalConfirmedQuantity,
      totalConfirmedRejected: totalConfirmedRejected,
      totalDifference: totalDifference,
      isMergedSession: isMergedSession,
      mergeInfo: mergeInfo?.toEntity(),
      receivingInfo: receivingInfo?.toEntity(),
      countingInfo: countingInfo?.toEntity(),
    );
  }
}

/// Model for SessionHistoryResponse
class SessionHistoryResponseModel {
  final List<SessionHistoryItemModel> sessions;
  final int totalCount;
  final int limit;
  final int offset;

  const SessionHistoryResponseModel({
    required this.sessions,
    required this.totalCount,
    required this.limit,
    required this.offset,
  });

  factory SessionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List<dynamic>? ?? [])
        .map((e) => SessionHistoryItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionHistoryResponseModel(
      sessions: dataList,
      totalCount: (json['total_count'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
      offset: (json['offset'] as num?)?.toInt() ?? 0,
    );
  }

  SessionHistoryResponse toEntity() {
    return SessionHistoryResponse(
      sessions: sessions.map((e) => e.toEntity()).toList(),
      totalCount: totalCount,
      limit: limit,
      offset: offset,
    );
  }
}
