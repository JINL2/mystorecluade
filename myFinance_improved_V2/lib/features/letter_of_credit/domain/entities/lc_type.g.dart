// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lc_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LCTypeImpl _$$LCTypeImplFromJson(Map<String, dynamic> json) => _$LCTypeImpl(
      lcTypeId: json['lc_type_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isRevocable: json['is_revocable'] as bool? ?? false,
      isConfirmed: json['is_confirmed'] as bool? ?? false,
      isTransferable: json['is_transferable'] as bool? ?? false,
      isRevolving: json['is_revolving'] as bool? ?? false,
      isStandby: json['is_standby'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LCTypeImplToJson(_$LCTypeImpl instance) =>
    <String, dynamic>{
      'lc_type_id': instance.lcTypeId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'is_revocable': instance.isRevocable,
      'is_confirmed': instance.isConfirmed,
      'is_transferable': instance.isTransferable,
      'is_revolving': instance.isRevolving,
      'is_standby': instance.isStandby,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
    };

_$LCPaymentTermImpl _$$LCPaymentTermImplFromJson(Map<String, dynamic> json) =>
    _$LCPaymentTermImpl(
      paymentTermId: json['payment_term_id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      requiresLc: json['requires_lc'] as bool? ?? false,
      requiresAdvance: json['requires_advance'] as bool? ?? false,
      advancePercent: (json['advance_percent'] as num?)?.toDouble(),
      creditDays: (json['credit_days'] as num?)?.toInt(),
      isActive: json['is_active'] as bool? ?? true,
      displayOrder: (json['display_order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$LCPaymentTermImplToJson(_$LCPaymentTermImpl instance) =>
    <String, dynamic>{
      'payment_term_id': instance.paymentTermId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'requires_lc': instance.requiresLc,
      'requires_advance': instance.requiresAdvance,
      'advance_percent': instance.advancePercent,
      'credit_days': instance.creditDays,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
    };
