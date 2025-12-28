// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IncotermModelImpl _$$IncotermModelImplFromJson(Map<String, dynamic> json) =>
    _$IncotermModelImpl(
      id: json['incoterm_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      transportMode: json['transport_mode'] as String? ?? 'any',
      riskTransferPoint: json['risk_transfer_point'] as String?,
      costTransferPoint: json['cost_transfer_point'] as String?,
      sellerResponsibilities:
          (json['seller_responsibilities'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      buyerResponsibilities: (json['buyer_responsibilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$IncotermModelImplToJson(_$IncotermModelImpl instance) =>
    <String, dynamic>{
      'incoterm_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'transport_mode': instance.transportMode,
      'risk_transfer_point': instance.riskTransferPoint,
      'cost_transfer_point': instance.costTransferPoint,
      'seller_responsibilities': instance.sellerResponsibilities,
      'buyer_responsibilities': instance.buyerResponsibilities,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$PaymentTermModelImpl _$$PaymentTermModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentTermModelImpl(
      id: json['payment_term_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      paymentTiming: json['payment_timing'] as String? ?? 'immediate',
      daysAfterShipment: (json['days_after_shipment'] as num?)?.toInt(),
      requiresLC: json['requires_lc'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$PaymentTermModelImplToJson(
        _$PaymentTermModelImpl instance) =>
    <String, dynamic>{
      'payment_term_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'payment_timing': instance.paymentTiming,
      'days_after_shipment': instance.daysAfterShipment,
      'requires_lc': instance.requiresLC,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$LCTypeModelImpl _$$LCTypeModelImplFromJson(Map<String, dynamic> json) =>
    _$LCTypeModelImpl(
      id: json['lc_type_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isRevocable: json['is_revocable'] as bool? ?? false,
      isConfirmed: json['is_confirmed'] as bool? ?? false,
      isTransferable: json['is_transferable'] as bool? ?? false,
      isRevolving: json['is_revolving'] as bool? ?? false,
      isStandby: json['is_standby'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$LCTypeModelImplToJson(_$LCTypeModelImpl instance) =>
    <String, dynamic>{
      'lc_type_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'is_revocable': instance.isRevocable,
      'is_confirmed': instance.isConfirmed,
      'is_transferable': instance.isTransferable,
      'is_revolving': instance.isRevolving,
      'is_standby': instance.isStandby,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$DocumentTypeModelImpl _$$DocumentTypeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DocumentTypeModelImpl(
      id: json['document_type_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      nameShort: json['name_short'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String,
      commonlyRequired: json['commonly_required'] as bool? ?? false,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$DocumentTypeModelImplToJson(
        _$DocumentTypeModelImpl instance) =>
    <String, dynamic>{
      'document_type_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'name_short': instance.nameShort,
      'description': instance.description,
      'category': instance.category,
      'commonly_required': instance.commonlyRequired,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$ShippingMethodModelImpl _$$ShippingMethodModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ShippingMethodModelImpl(
      id: json['shipping_method_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      transportDocumentCode: json['transport_document_code'] as String?,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ShippingMethodModelImplToJson(
        _$ShippingMethodModelImpl instance) =>
    <String, dynamic>{
      'shipping_method_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'transport_document_code': instance.transportDocumentCode,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };

_$FreightTermModelImpl _$$FreightTermModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FreightTermModelImpl(
      id: json['freight_term_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      payer: json['payer'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$FreightTermModelImplToJson(
        _$FreightTermModelImpl instance) =>
    <String, dynamic>{
      'freight_term_id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'payer': instance.payer,
      'sort_order': instance.sortOrder,
      'is_active': instance.isActive,
    };
