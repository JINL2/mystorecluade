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
