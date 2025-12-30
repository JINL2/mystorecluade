import 'package:freezed_annotation/freezed_annotation.dart';

part 'lc_type.freezed.dart';
part 'lc_type.g.dart';

/// LC Type entity from trade_lc_types table
@freezed
class LCType with _$LCType {
  const factory LCType({
    @JsonKey(name: 'lc_type_id') required String lcTypeId,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'is_revocable') @Default(false) bool isRevocable,
    @JsonKey(name: 'is_confirmed') @Default(false) bool isConfirmed,
    @JsonKey(name: 'is_transferable') @Default(false) bool isTransferable,
    @JsonKey(name: 'is_revolving') @Default(false) bool isRevolving,
    @JsonKey(name: 'is_standby') @Default(false) bool isStandby,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _LCType;

  factory LCType.fromJson(Map<String, dynamic> json) => _$LCTypeFromJson(json);
}

/// LC Document Type (hardcoded - no DB table)
class LCDocumentType {
  final String code;
  final String name;
  final String? description;
  final bool isRequired;

  const LCDocumentType({
    required this.code,
    required this.name,
    this.description,
    this.isRequired = false,
  });
}

/// Standard LC Document Types
const List<LCDocumentType> lcDocumentTypes = [
  LCDocumentType(
    code: 'commercial_invoice',
    name: 'Commercial Invoice',
    description: 'Invoice for goods being shipped',
    isRequired: true,
  ),
  LCDocumentType(
    code: 'packing_list',
    name: 'Packing List',
    description: 'Detailed list of items and packages',
    isRequired: true,
  ),
  LCDocumentType(
    code: 'bill_of_lading',
    name: 'Bill of Lading',
    description: 'Transport document issued by carrier',
    isRequired: true,
  ),
  LCDocumentType(
    code: 'certificate_of_origin',
    name: 'Certificate of Origin',
    description: 'Document certifying country of manufacture',
  ),
  LCDocumentType(
    code: 'insurance_certificate',
    name: 'Insurance Certificate',
    description: 'Proof of marine/cargo insurance',
  ),
  LCDocumentType(
    code: 'inspection_certificate',
    name: 'Inspection Certificate',
    description: 'Third-party inspection report',
  ),
  LCDocumentType(
    code: 'weight_certificate',
    name: 'Weight Certificate',
    description: 'Official weight measurement document',
  ),
  LCDocumentType(
    code: 'quality_certificate',
    name: 'Quality Certificate',
    description: 'Quality assurance documentation',
  ),
  LCDocumentType(
    code: 'beneficiary_certificate',
    name: 'Beneficiary Certificate',
    description: 'Statement from beneficiary',
  ),
  LCDocumentType(
    code: 'phytosanitary_certificate',
    name: 'Phytosanitary Certificate',
    description: 'Plant health certificate for agricultural goods',
  ),
  LCDocumentType(
    code: 'fumigation_certificate',
    name: 'Fumigation Certificate',
    description: 'Proof of fumigation treatment',
  ),
  LCDocumentType(
    code: 'health_certificate',
    name: 'Health Certificate',
    description: 'Health/sanitary certificate for food products',
  ),
];

/// Payment Term entity for LC-specific terms
@freezed
class LCPaymentTerm with _$LCPaymentTerm {
  const factory LCPaymentTerm({
    @JsonKey(name: 'payment_term_id') required String paymentTermId,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'requires_lc') @Default(false) bool requiresLc,
    @JsonKey(name: 'requires_advance') @Default(false) bool requiresAdvance,
    @JsonKey(name: 'advance_percent') double? advancePercent,
    @JsonKey(name: 'credit_days') int? creditDays,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') int? displayOrder,
  }) = _LCPaymentTerm;

  factory LCPaymentTerm.fromJson(Map<String, dynamic> json) =>
      _$LCPaymentTermFromJson(json);
}
