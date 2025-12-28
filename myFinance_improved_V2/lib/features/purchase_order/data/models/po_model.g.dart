// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'po_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$POItemModelImpl _$$POItemModelImplFromJson(Map<String, dynamic> json) =>
    _$POItemModelImpl(
      itemId: json['item_id'] as String,
      poId: json['po_id'] as String,
      piItemId: json['pi_item_id'] as String?,
      productId: json['product_id'] as String?,
      description: json['description'] as String,
      sku: json['sku'] as String?,
      hsCode: json['hs_code'] as String?,
      quantityOrdered: (json['quantity_ordered'] as num).toDouble(),
      quantityShipped: (json['quantity_shipped'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAtUtc: json['created_at_utc'] == null
          ? null
          : DateTime.parse(json['created_at_utc'] as String),
    );

Map<String, dynamic> _$$POItemModelImplToJson(_$POItemModelImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'po_id': instance.poId,
      'pi_item_id': instance.piItemId,
      'product_id': instance.productId,
      'description': instance.description,
      'sku': instance.sku,
      'hs_code': instance.hsCode,
      'quantity_ordered': instance.quantityOrdered,
      'quantity_shipped': instance.quantityShipped,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'total_amount': instance.totalAmount,
      'image_url': instance.imageUrl,
      'sort_order': instance.sortOrder,
      'created_at_utc': instance.createdAtUtc?.toIso8601String(),
    };

_$POListItemModelImpl _$$POListItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$POListItemModelImpl(
      poId: json['po_id'] as String,
      poNumber: json['po_number'] as String,
      piNumber: json['pi_number'] as String?,
      buyerName: json['buyer_name'] as String?,
      buyerPoNumber: json['buyer_po_number'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'USD',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? 'draft',
      shippedPercent: (json['shipped_percent'] as num?)?.toDouble() ?? 0,
      orderDateUtc: json['order_date_utc'] == null
          ? null
          : DateTime.parse(json['order_date_utc'] as String),
      requiredShipmentDateUtc: json['required_shipment_date_utc'] == null
          ? null
          : DateTime.parse(json['required_shipment_date_utc'] as String),
      createdAtUtc: json['created_at_utc'] == null
          ? null
          : DateTime.parse(json['created_at_utc'] as String),
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$POListItemModelImplToJson(
        _$POListItemModelImpl instance) =>
    <String, dynamic>{
      'po_id': instance.poId,
      'po_number': instance.poNumber,
      'pi_number': instance.piNumber,
      'buyer_name': instance.buyerName,
      'buyer_po_number': instance.buyerPoNumber,
      'currency_code': instance.currencyCode,
      'total_amount': instance.totalAmount,
      'status': instance.status,
      'shipped_percent': instance.shippedPercent,
      'order_date_utc': instance.orderDateUtc?.toIso8601String(),
      'required_shipment_date_utc':
          instance.requiredShipmentDateUtc?.toIso8601String(),
      'created_at_utc': instance.createdAtUtc?.toIso8601String(),
      'item_count': instance.itemCount,
    };
