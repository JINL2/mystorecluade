// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PIItemModelImpl _$$PIItemModelImplFromJson(Map<String, dynamic> json) =>
    _$PIItemModelImpl(
      itemId: json['item_id'] as String,
      piId: json['pi_id'] as String,
      productId: json['product_id'] as String?,
      description: json['description'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      hsCode: json['hs_code'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String?,
      unitPrice: (json['unit_price'] as num).toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      packingInfo: json['packing_info'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAtUtc: json['created_at_utc'] == null
          ? null
          : DateTime.parse(json['created_at_utc'] as String),
    );

Map<String, dynamic> _$$PIItemModelImplToJson(_$PIItemModelImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'pi_id': instance.piId,
      'product_id': instance.productId,
      'description': instance.description,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'hs_code': instance.hsCode,
      'country_of_origin': instance.countryOfOrigin,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'discount_percent': instance.discountPercent,
      'discount_amount': instance.discountAmount,
      'total_amount': instance.totalAmount,
      'packing_info': instance.packingInfo,
      'sort_order': instance.sortOrder,
      'created_at_utc': instance.createdAtUtc?.toIso8601String(),
    };

_$PIModelImpl _$$PIModelImplFromJson(Map<String, dynamic> json) =>
    _$PIModelImpl(
      piId: json['pi_id'] as String,
      piNumber: json['pi_number'] as String,
      companyId: json['company_id'] as String,
      storeId: json['store_id'] as String?,
      counterpartyId: json['counterparty_id'] as String?,
      counterpartyName: json['counterparty_name'] as String?,
      counterpartyInfo: json['counterparty_info'] as Map<String, dynamic>?,
      sellerInfo: json['seller_info'] as Map<String, dynamic>?,
      currencyId: json['currency_id'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'USD',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      taxPercent: (json['tax_percent'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      incotermsCode: json['incoterms_code'] as String?,
      incotermsPlace: json['incoterms_place'] as String?,
      portOfLoading: json['port_of_loading'] as String?,
      portOfDischarge: json['port_of_discharge'] as String?,
      finalDestination: json['final_destination'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      paymentTermsCode: json['payment_terms_code'] as String?,
      paymentTermsDetail: json['payment_terms_detail'] as String?,
      partialShipmentAllowed: json['partial_shipment_allowed'] as bool? ?? true,
      transshipmentAllowed: json['transshipment_allowed'] as bool? ?? true,
      shippingMethodCode: json['shipping_method_code'] as String?,
      estimatedShipmentDate: json['estimated_shipment_date'] == null
          ? null
          : DateTime.parse(json['estimated_shipment_date'] as String),
      leadTimeDays: (json['lead_time_days'] as num?)?.toInt(),
      validityDate: json['validity_date'] == null
          ? null
          : DateTime.parse(json['validity_date'] as String),
      status: json['status'] as String? ?? 'draft',
      version: (json['version'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
      internalNotes: json['internal_notes'] as String?,
      termsAndConditions: json['terms_and_conditions'] as String?,
      createdBy: json['created_by'] as String?,
      createdAtUtc: json['created_at_utc'] == null
          ? null
          : DateTime.parse(json['created_at_utc'] as String),
      updatedAtUtc: json['updated_at_utc'] == null
          ? null
          : DateTime.parse(json['updated_at_utc'] as String),
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => PIItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      itemCount: (json['item_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PIModelImplToJson(_$PIModelImpl instance) =>
    <String, dynamic>{
      'pi_id': instance.piId,
      'pi_number': instance.piNumber,
      'company_id': instance.companyId,
      'store_id': instance.storeId,
      'counterparty_id': instance.counterpartyId,
      'counterparty_name': instance.counterpartyName,
      'counterparty_info': instance.counterpartyInfo,
      'seller_info': instance.sellerInfo,
      'currency_id': instance.currencyId,
      'currency_code': instance.currencyCode,
      'subtotal': instance.subtotal,
      'discount_percent': instance.discountPercent,
      'discount_amount': instance.discountAmount,
      'tax_percent': instance.taxPercent,
      'tax_amount': instance.taxAmount,
      'total_amount': instance.totalAmount,
      'incoterms_code': instance.incotermsCode,
      'incoterms_place': instance.incotermsPlace,
      'port_of_loading': instance.portOfLoading,
      'port_of_discharge': instance.portOfDischarge,
      'final_destination': instance.finalDestination,
      'country_of_origin': instance.countryOfOrigin,
      'payment_terms_code': instance.paymentTermsCode,
      'payment_terms_detail': instance.paymentTermsDetail,
      'partial_shipment_allowed': instance.partialShipmentAllowed,
      'transshipment_allowed': instance.transshipmentAllowed,
      'shipping_method_code': instance.shippingMethodCode,
      'estimated_shipment_date':
          instance.estimatedShipmentDate?.toIso8601String(),
      'lead_time_days': instance.leadTimeDays,
      'validity_date': instance.validityDate?.toIso8601String(),
      'status': instance.status,
      'version': instance.version,
      'notes': instance.notes,
      'internal_notes': instance.internalNotes,
      'terms_and_conditions': instance.termsAndConditions,
      'created_by': instance.createdBy,
      'created_at_utc': instance.createdAtUtc?.toIso8601String(),
      'updated_at_utc': instance.updatedAtUtc?.toIso8601String(),
      'items': instance.items,
      'item_count': instance.itemCount,
    };

_$PaginatedPIResponseImpl _$$PaginatedPIResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedPIResponseImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => PIModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$$PaginatedPIResponseImplToJson(
        _$PaginatedPIResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total_count': instance.totalCount,
      'page': instance.page,
      'page_size': instance.pageSize,
      'has_more': instance.hasMore,
    };
