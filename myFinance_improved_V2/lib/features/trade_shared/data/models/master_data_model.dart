import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/incoterm.dart';

part 'master_data_model.freezed.dart';
part 'master_data_model.g.dart';

/// Incoterm model from database
@freezed
class IncotermModel with _$IncotermModel {
  const IncotermModel._();

  const factory IncotermModel({
    @JsonKey(name: 'incoterm_id') required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'transport_mode') @Default('any') String transportMode,
    @JsonKey(name: 'risk_transfer_point') String? riskTransferPoint,
    @JsonKey(name: 'cost_transfer_point') String? costTransferPoint,
    @JsonKey(name: 'seller_responsibilities') @Default([]) List<String> sellerResponsibilities,
    @JsonKey(name: 'buyer_responsibilities') @Default([]) List<String> buyerResponsibilities,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _IncotermModel;

  factory IncotermModel.fromJson(Map<String, dynamic> json) =>
      _$IncotermModelFromJson(json);

  Incoterm toEntity() => Incoterm(
        id: id,
        code: code,
        name: name,
        description: description,
        transportMode: transportMode,
        riskTransferPoint: riskTransferPoint,
        costTransferPoint: costTransferPoint,
        sellerResponsibilities: sellerResponsibilities,
        buyerResponsibilities: buyerResponsibilities,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// Payment term model from database
@freezed
class PaymentTermModel with _$PaymentTermModel {
  const PaymentTermModel._();

  const factory PaymentTermModel({
    @JsonKey(name: 'payment_term_id') required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'payment_timing') @Default('immediate') String paymentTiming,
    @JsonKey(name: 'days_after_shipment') int? daysAfterShipment,
    @JsonKey(name: 'requires_lc') @Default(false) bool requiresLC,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _PaymentTermModel;

  factory PaymentTermModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentTermModelFromJson(json);

  PaymentTerm toEntity() => PaymentTerm(
        id: id,
        code: code,
        name: name,
        description: description,
        paymentTiming: paymentTiming,
        daysAfterShipment: daysAfterShipment,
        requiresLC: requiresLC,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// L/C type model from database
@freezed
class LCTypeModel with _$LCTypeModel {
  const LCTypeModel._();

  const factory LCTypeModel({
    @JsonKey(name: 'lc_type_id') required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'is_revocable') @Default(false) bool isRevocable,
    @JsonKey(name: 'is_confirmed') @Default(false) bool isConfirmed,
    @JsonKey(name: 'is_transferable') @Default(false) bool isTransferable,
    @JsonKey(name: 'is_revolving') @Default(false) bool isRevolving,
    @JsonKey(name: 'is_standby') @Default(false) bool isStandby,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _LCTypeModel;

  factory LCTypeModel.fromJson(Map<String, dynamic> json) =>
      _$LCTypeModelFromJson(json);

  LCType toEntity() => LCType(
        id: id,
        code: code,
        name: name,
        description: description,
        isRevocable: isRevocable,
        isConfirmed: isConfirmed,
        isTransferable: isTransferable,
        isRevolving: isRevolving,
        isStandby: isStandby,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// Document type model from database
@freezed
class DocumentTypeModel with _$DocumentTypeModel {
  const DocumentTypeModel._();

  const factory DocumentTypeModel({
    @JsonKey(name: 'document_type_id') required String id,
    required String code,
    required String name,
    @JsonKey(name: 'name_short') String? nameShort,
    String? description,
    required String category,
    @JsonKey(name: 'commonly_required') @Default(false) bool commonlyRequired,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _DocumentTypeModel;

  factory DocumentTypeModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentTypeModelFromJson(json);

  TradeDocumentType toEntity() => TradeDocumentType(
        id: id,
        code: code,
        name: name,
        nameShort: nameShort,
        description: description,
        category: category,
        commonlyRequired: commonlyRequired,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// Shipping method model from database
@freezed
class ShippingMethodModel with _$ShippingMethodModel {
  const ShippingMethodModel._();

  const factory ShippingMethodModel({
    @JsonKey(name: 'shipping_method_id') required String id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'transport_document_code') String? transportDocumentCode,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _ShippingMethodModel;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingMethodModelFromJson(json);

  ShippingMethod toEntity() => ShippingMethod(
        id: id,
        code: code,
        name: name,
        description: description,
        transportDocumentCode: transportDocumentCode,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// Freight term model from database
@freezed
class FreightTermModel with _$FreightTermModel {
  const FreightTermModel._();

  const factory FreightTermModel({
    @JsonKey(name: 'freight_term_id') required String id,
    required String code,
    required String name,
    String? description,
    required String payer,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _FreightTermModel;

  factory FreightTermModel.fromJson(Map<String, dynamic> json) =>
      _$FreightTermModelFromJson(json);

  FreightTerm toEntity() => FreightTerm(
        id: id,
        code: code,
        name: name,
        description: description,
        payer: payer,
        sortOrder: sortOrder,
        isActive: isActive,
      );
}

/// All master data response
@freezed
class MasterDataResponse with _$MasterDataResponse {
  const MasterDataResponse._();

  const factory MasterDataResponse({
    @Default([]) List<IncotermModel> incoterms,
    @JsonKey(name: 'payment_terms') @Default([]) List<PaymentTermModel> paymentTerms,
    @JsonKey(name: 'lc_types') @Default([]) List<LCTypeModel> lcTypes,
    @JsonKey(name: 'document_types') @Default([]) List<DocumentTypeModel> documentTypes,
    @JsonKey(name: 'shipping_methods') @Default([]) List<ShippingMethodModel> shippingMethods,
    @JsonKey(name: 'freight_terms') @Default([]) List<FreightTermModel> freightTerms,
  }) = _MasterDataResponse;

  factory MasterDataResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return MasterDataResponse(
      incoterms: (data['incoterms'] as List<dynamic>? ?? [])
          .map((e) => IncotermModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentTerms: (data['payment_terms'] as List<dynamic>? ?? [])
          .map((e) => PaymentTermModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lcTypes: (data['lc_types'] as List<dynamic>? ?? [])
          .map((e) => LCTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      documentTypes: (data['document_types'] as List<dynamic>? ?? [])
          .map((e) => DocumentTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingMethods: (data['shipping_methods'] as List<dynamic>? ?? [])
          .map((e) => ShippingMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      freightTerms: (data['freight_terms'] as List<dynamic>? ?? [])
          .map((e) => FreightTermModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
