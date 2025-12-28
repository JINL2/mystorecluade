import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/purchase_order.dart';

part 'po_model.freezed.dart';
part 'po_model.g.dart';

/// Purchase Order Item Model (DTO)
@freezed
class POItemModel with _$POItemModel {
  const POItemModel._();

  const factory POItemModel({
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'po_id') required String poId,
    @JsonKey(name: 'pi_item_id') String? piItemId,
    @JsonKey(name: 'product_id') String? productId,
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

  factory POItemModel.fromJson(Map<String, dynamic> json) =>
      _$POItemModelFromJson(json);

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
    @JsonKey(name: 'buyer_id') String? buyerId,
    @JsonKey(name: 'buyer_name') String? buyerName,
    @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
    @JsonKey(name: 'buyer_info') Map<String, dynamic>? buyerInfo,
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
    @Default(1) int version,
    @JsonKey(name: 'shipped_percent') @Default(0) double shippedPercent,
    String? notes,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
    @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
    @Default([]) List<POItemModel> items,
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

    return POModel(
      poId: json['po_id'] as String,
      poNumber: json['po_number'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      piId: json['pi_id'] as String?,
      piNumber: json['pi_number'] as String?,
      sellerInfo: json['seller_info'] as Map<String, dynamic>?,
      buyerId: json['buyer_id'] as String?,
      buyerName: json['buyer_name'] as String?,
      buyerPoNumber: json['buyer_po_number'] as String?,
      buyerInfo: json['buyer_info'] as Map<String, dynamic>?,
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'USD',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      incotermsCode: json['incoterms_code'] as String?,
      incotermsPlace: json['incoterms_place'] as String?,
      paymentTermsCode: json['payment_terms_code'] as String?,
      orderDateUtc: json['order_date_utc'] != null
          ? DateTime.parse(json['order_date_utc'] as String)
          : null,
      requiredShipmentDateUtc: json['required_shipment_date_utc'] != null
          ? DateTime.parse(json['required_shipment_date_utc'] as String)
          : null,
      partialShipmentAllowed: json['partial_shipment_allowed'] as bool? ?? true,
      transshipmentAllowed: json['transshipment_allowed'] as bool? ?? true,
      status: json['status'] as String? ?? 'draft',
      version: json['version'] as int? ?? 1,
      shippedPercent: (json['shipped_percent'] as num?)?.toDouble() ?? 0,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
      createdAtUtc: json['created_at_utc'] != null
          ? DateTime.parse(json['created_at_utc'] as String)
          : null,
      updatedAtUtc: json['updated_at_utc'] != null
          ? DateTime.parse(json['updated_at_utc'] as String)
          : null,
      items: items,
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
@freezed
class POListItemModel with _$POListItemModel {
  const POListItemModel._();

  const factory POListItemModel({
    @JsonKey(name: 'po_id') required String poId,
    @JsonKey(name: 'po_number') required String poNumber,
    @JsonKey(name: 'pi_number') String? piNumber,
    @JsonKey(name: 'buyer_name') String? buyerName,
    @JsonKey(name: 'buyer_po_number') String? buyerPoNumber,
    @JsonKey(name: 'currency_code') @Default('USD') String currencyCode,
    @JsonKey(name: 'total_amount') @Default(0) double totalAmount,
    @Default('draft') String status,
    @JsonKey(name: 'shipped_percent') @Default(0) double shippedPercent,
    @JsonKey(name: 'order_date_utc') DateTime? orderDateUtc,
    @JsonKey(name: 'required_shipment_date_utc') DateTime? requiredShipmentDateUtc,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
  }) = _POListItemModel;

  factory POListItemModel.fromJson(Map<String, dynamic> json) =>
      _$POListItemModelFromJson(json);

  POListItem toEntity() => POListItem(
        poId: poId,
        poNumber: poNumber,
        piNumber: piNumber,
        buyerName: buyerName,
        buyerPoNumber: buyerPoNumber,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        status: POStatus.fromString(status),
        shippedPercent: shippedPercent,
        orderDateUtc: orderDateUtc,
        requiredShipmentDateUtc: requiredShipmentDateUtc,
        createdAtUtc: createdAtUtc,
        itemCount: itemCount,
      );
}
