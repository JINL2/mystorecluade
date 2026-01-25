import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/purchase_order.dart';

part 'po_model.freezed.dart';

/// Purchase Order Item Model (DTO)
/// Supports both legacy trade PO items and new inventory order items with variants
@freezed
class POItemModel with _$POItemModel {
  const POItemModel._();

  const factory POItemModel({
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'po_id') required String poId,
    @JsonKey(name: 'pi_item_id') String? piItemId,
    @JsonKey(name: 'product_id') String? productId,
    // Variant support from inventory_get_order_detail_v2 RPC
    @JsonKey(name: 'variant_id') String? variantId,
    @JsonKey(name: 'product_name') String? productName,
    @JsonKey(name: 'variant_name') String? variantName,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'has_variants') @Default(false) bool hasVariants,
    required String description,
    String? sku,
    @JsonKey(name: 'hs_code') String? hsCode,
    @JsonKey(name: 'quantity_ordered') required double quantityOrdered,
    @JsonKey(name: 'quantity_shipped') @Default(0) double quantityShipped,
    String? unit,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
  }) = _POItemModel;

  factory POItemModel.fromJson(Map<String, dynamic> json) {
    return POItemModel(
      itemId: json['item_id'] as String? ?? '',
      poId: json['po_id'] as String? ?? '',
      piItemId: json['pi_item_id'] as String?,
      productId: json['product_id'] as String?,
      variantId: json['variant_id'] as String?,
      productName: json['product_name'] as String?,
      variantName: json['variant_name'] as String?,
      displayName: json['display_name'] as String?,
      hasVariants: json['has_variants'] as bool? ?? false,
      // Use display_name first, then description, then product_name
      description: json['description'] as String? ??
                   json['display_name'] as String? ??
                   json['product_name'] as String? ?? '',
      sku: json['sku'] as String?,
      hsCode: json['hs_code'] as String?,
      quantityOrdered: (json['quantity_ordered'] as num?)?.toDouble() ?? 0,
      quantityShipped: (json['quantity_shipped'] as num?)?.toDouble() ??
                       (json['quantity_fulfilled'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAtUtc: json['created_at_utc'] != null
          ? DateTime.tryParse(json['created_at_utc'] as String)
          : null,
    );
  }

  POItem toEntity() => POItem(
        itemId: itemId,
        poId: poId,
        piItemId: piItemId,
        productId: productId,
        description: description,
        sku: sku,
        hsCode: hsCode,
        quantity: quantityOrdered,
        shippedQuantity: quantityShipped,
        unit: unit,
        unitPrice: unitPrice,
        totalAmount: totalAmount,
        imageUrl: imageUrl,
        sortOrder: sortOrder,
        createdAtUtc: createdAtUtc,
      );
}

/// Purchase Order Model (DTO)
@freezed
class POModel with _$POModel {
  const POModel._();

  const factory POModel({
    @JsonKey(name: 'po_id') required String poId,
    @JsonKey(name: 'po_number') required String poNumber,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'pi_id') String? piId,
    @JsonKey(name: 'pi_number') String? piNumber,
    /// Seller (our company) info for PDF generation
    @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
    /// Banking info for PDF (from cash_locations)
    @JsonKey(name: 'banking_info') List<Map<String, dynamic>>? bankingInfo,
    /// Selected bank account IDs (cash_location_ids) for PDF display
    @JsonKey(name: 'bank_account_ids') @Default([]) List<String> bankAccountIds,
    @JsonKey(name: 'buyer_id') String? buyerId,
    @JsonKey(name: 'buyer_name') String? buyerName,
    @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
    @JsonKey(name: 'buyer_info') Map<String, dynamic>? buyerInfo,
    // Supplier info from inventory RPC
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    @JsonKey(name: 'is_registered_supplier') @Default(false) bool isRegisteredSupplier,
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'currency_code') @Default('USD') String currencyCode,
    @JsonKey(name: 'total_amount') @Default(0) double totalAmount,
    @JsonKey(name: 'incoterms_code') String? incotermsCode,
    @JsonKey(name: 'incoterms_place') String? incotermsPlace,
    @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
    @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
    @JsonKey(name: 'required_shipment_date_utc') DateTime? requiredShipmentDateUtc,
    @JsonKey(name: 'partial_shipment_allowed') @Default(true) bool partialShipmentAllowed,
    @JsonKey(name: 'transshipment_allowed') @Default(true) bool transshipmentAllowed,
    @Default('draft') String status,
    // New status fields from RPC
    @JsonKey(name: 'order_status') String? orderStatus,
    @JsonKey(name: 'receiving_status') String? receivingStatus,
    @Default(1) int version,
    @JsonKey(name: 'shipped_percent') @Default(0) double shippedPercent,
    String? notes,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
    @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
    @Default([]) List<POItemModel> items,
    // Shipment info from RPC
    @JsonKey(name: 'has_shipments') @Default(false) bool hasShipments,
    @JsonKey(name: 'shipment_count') @Default(0) int shipmentCount,
    // Action flags from RPC
    @JsonKey(name: 'can_cancel') @Default(false) bool canCancel,
  }) = _POModel;

  factory POModel.fromJson(Map<String, dynamic> json) {
    // Handle items if present in response
    final itemsJson = json['items'];
    List<POItemModel> items = [];
    if (itemsJson != null && itemsJson is List) {
      items = itemsJson
          .map((e) => POItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    // Parse order_date_utc - may come as order_date from RPC
    DateTime? orderDateUtc;
    final orderDateValue = json['order_date_utc'] ?? json['order_date'];
    if (orderDateValue != null) {
      if (orderDateValue is String) {
        orderDateUtc = DateTime.tryParse(orderDateValue);
      } else if (orderDateValue is DateTime) {
        orderDateUtc = orderDateValue;
      }
    }

    // Parse created_at_utc - may come as created_at from RPC
    DateTime? createdAtUtc;
    final createdAtValue = json['created_at_utc'] ?? json['created_at'];
    if (createdAtValue != null) {
      if (createdAtValue is String) {
        createdAtUtc = DateTime.tryParse(createdAtValue);
      } else if (createdAtValue is DateTime) {
        createdAtUtc = createdAtValue;
      }
    }

    return POModel(
      poId: json['po_id'] as String? ?? json['order_id'] as String? ?? '',
      poNumber: json['po_number'] as String? ?? json['order_number'] as String? ?? '',
      companyId: json['company_id'] as String? ?? '',
      storeId: json['store_id'] as String?,
      piId: json['pi_id'] as String?,
      piNumber: json['pi_number'] as String?,
      sellerInfo: json['seller_info'] as Map<String, dynamic>?,
      bankingInfo: (json['banking_info'] as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      bankAccountIds: (json['bank_account_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      buyerId: json['buyer_id'] as String?,
      buyerName: json['buyer_name'] as String?,
      buyerPoNumber: json['buyer_po_number'] as String?,
      buyerInfo: json['buyer_info'] as Map<String, dynamic>?,
      // Supplier info from inventory RPC
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      isRegisteredSupplier: json['is_registered_supplier'] as bool? ?? false,
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'USD',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      incotermsCode: json['incoterms_code'] as String?,
      incotermsPlace: json['incoterms_place'] as String?,
      paymentTermsCode: json['payment_terms_code'] as String?,
      orderDateUtc: orderDateUtc,
      requiredShipmentDateUtc: json['required_shipment_date_utc'] != null
          ? DateTime.tryParse(json['required_shipment_date_utc'] as String)
          : null,
      partialShipmentAllowed: json['partial_shipment_allowed'] as bool? ?? true,
      transshipmentAllowed: json['transshipment_allowed'] as bool? ?? true,
      status: json['status'] as String? ?? json['order_status'] as String? ?? 'draft',
      orderStatus: json['order_status'] as String?,
      receivingStatus: json['receiving_status'] as String?,
      version: json['version'] as int? ?? 1,
      shippedPercent: (json['shipped_percent'] as num?)?.toDouble() ??
                      (json['fulfilled_percentage'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAtUtc: createdAtUtc,
      updatedAtUtc: json['updated_at_utc'] != null
          ? DateTime.tryParse(json['updated_at_utc'] as String)
          : null,
      items: items,
      // Shipment info from RPC
      hasShipments: json['has_shipments'] as bool? ?? false,
      shipmentCount: (json['shipment_count'] as num?)?.toInt() ?? 0,
      // Action flags from RPC
      canCancel: json['can_cancel'] as bool? ?? false,
    );
  }

  PurchaseOrder toEntity() => PurchaseOrder(
        poId: poId,
        poNumber: poNumber,
        companyId: companyId,
        storeId: storeId,
        piId: piId,
        piNumber: piNumber,
        sellerInfo: sellerInfo,
        bankingInfo: bankingInfo,
        bankAccountIds: bankAccountIds,
        buyerId: buyerId,
        buyerName: buyerName ?? buyerInfo?['name'] as String?,
        buyerPoNumber: buyerPoNumber,
        buyerInfo: buyerInfo,
        currencyId: currencyId,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        incotermsCode: incotermsCode,
        incotermsPlace: incotermsPlace,
        paymentTermsCode: paymentTermsCode,
        orderDateUtc: orderDateUtc,
        requiredShipmentDateUtc: requiredShipmentDateUtc,
        partialShipmentAllowed: partialShipmentAllowed,
        transshipmentAllowed: transshipmentAllowed,
        status: POStatus.fromString(status),
        version: version,
        shippedPercent: shippedPercent,
        notes: notes,
        createdBy: createdBy,
        createdAtUtc: createdAtUtc,
        updatedAtUtc: updatedAtUtc,
        items: items.map((e) => e.toEntity()).toList(),
      );
}

/// Purchase Order List Item Model (lighter DTO for list view)
/// Uses inventory_get_order_list RPC response structure
@freezed
class POListItemModel with _$POListItemModel {
  const POListItemModel._();

  const factory POListItemModel({
    // RPC returns order_id, we map to poId for UI compatibility
    @JsonKey(name: 'order_id') required String poId,
    // RPC returns order_number, we map to poNumber for UI compatibility
    @JsonKey(name: 'order_number') required String poNumber,
    @JsonKey(name: 'pi_number') String? piNumber,
    // Supplier info from RPC (inventory orders to suppliers)
    @JsonKey(name: 'supplier_id') String? supplierId,
    @JsonKey(name: 'supplier_name') String? supplierName,
    // Legacy buyer fields - mapped from supplier for UI compatibility
    @JsonKey(name: 'buyer_name') String? buyerName,
    @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
    @JsonKey(name: 'currency_code') @Default('USD') String currencyCode,
    @JsonKey(name: 'total_amount') @Default(0) double totalAmount,
    // New status fields from RPC
    @JsonKey(name: 'order_status') @Default('draft') String orderStatus,
    @JsonKey(name: 'receiving_status') @Default('pending') String receivingStatus,
    // Fulfilled percentage from RPC
    @JsonKey(name: 'fulfilled_percentage') @Default(0) double fulfilledPercentage,
    // Legacy status field for compatibility
    @Default('draft') String status,
    @JsonKey(name: 'shipped_percent') @Default(0) double shippedPercent,
    @JsonKey(name: 'order_date') DateTime? orderDateUtc,
    @JsonKey(name: 'required_shipment_date_utc') DateTime? requiredShipmentDateUtc,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
  }) = _POListItemModel;

  factory POListItemModel.fromJson(Map<String, dynamic> json) {
    // Parse order_date which may come as string from RPC
    DateTime? orderDate;
    if (json['order_date'] != null) {
      if (json['order_date'] is String) {
        orderDate = DateTime.tryParse(json['order_date'] as String);
      } else if (json['order_date'] is DateTime) {
        orderDate = json['order_date'] as DateTime;
      }
    }

    return POListItemModel(
      poId: json['order_id'] as String? ?? json['po_id'] as String? ?? '',
      poNumber: json['order_number'] as String? ?? json['po_number'] as String? ?? '',
      piNumber: json['pi_number'] as String?,
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      buyerName: json['supplier_name'] as String? ?? json['buyer_name'] as String?,
      buyerPoNumber: json['buyer_po_number'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'USD',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      orderStatus: json['order_status'] as String? ?? 'draft',
      receivingStatus: json['receiving_status'] as String? ?? 'pending',
      fulfilledPercentage: (json['fulfilled_percentage'] as num?)?.toDouble() ?? 0,
      status: json['order_status'] as String? ?? json['status'] as String? ?? 'draft',
      shippedPercent: (json['fulfilled_percentage'] as num?)?.toDouble() ??
          (json['shipped_percent'] as num?)?.toDouble() ??
          0,
      orderDateUtc: orderDate,
      requiredShipmentDateUtc: json['required_shipment_date_utc'] != null
          ? DateTime.tryParse(json['required_shipment_date_utc'] as String)
          : null,
      createdAtUtc: json['created_at_utc'] != null
          ? DateTime.tryParse(json['created_at_utc'] as String)
          : null,
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );
  }

  POListItem toEntity() {
    final orderStatusEnum = OrderStatus.fromString(orderStatus);
    final receivingStatusEnum = ReceivingStatus.fromString(receivingStatus);

    return POListItem(
      poId: poId,
      poNumber: poNumber,
      piNumber: piNumber,
      supplierId: supplierId,
      supplierName: supplierName,
      // For UI compatibility, use supplier name as buyer name
      buyerName: supplierName ?? buyerName,
      buyerPoNumber: buyerPoNumber,
      currencyCode: currencyCode,
      totalAmount: totalAmount,
      // Convert OrderStatus to POStatus directly
      status: POStatus.fromOrderStatus(orderStatusEnum),
      orderStatus: orderStatusEnum,
      receivingStatus: receivingStatusEnum,
      shippedPercent: fulfilledPercentage > 0 ? fulfilledPercentage : shippedPercent,
      fulfilledPercentage: fulfilledPercentage,
      orderDateUtc: orderDateUtc,
      requiredShipmentDateUtc: requiredShipmentDateUtc,
      createdAtUtc: createdAtUtc,
      itemCount: itemCount,
    );
  }
}
