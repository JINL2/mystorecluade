import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/proforma_invoice.dart';

part 'pi_model.freezed.dart';
part 'pi_model.g.dart';

/// PI Item Model (for JSON serialization)
@freezed
class PIItemModel with _$PIItemModel {
  const PIItemModel._();

  const factory PIItemModel({
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'pi_id') required String piId,
    @JsonKey(name: 'product_id') String? productId,
    required String description,
    String? sku,
    String? barcode,
    @JsonKey(name: 'hs_code') String? hsCode,
    @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
    required double quantity,
    String? unit,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'discount_percent') @Default(0) double discountPercent,
    @JsonKey(name: 'discount_amount') @Default(0) double discountAmount,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'packing_info') String? packingInfo,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
  }) = _PIItemModel;

  factory PIItemModel.fromJson(Map<String, dynamic> json) =>
      _$PIItemModelFromJson(json);

  /// Convert to entity
  PIItem toEntity() => PIItem(
        itemId: itemId,
        piId: piId,
        productId: productId,
        description: description,
        sku: sku,
        barcode: barcode,
        hsCode: hsCode,
        countryOfOrigin: countryOfOrigin,
        quantity: quantity,
        unit: unit,
        unitPrice: unitPrice,
        discountPercent: discountPercent,
        discountAmount: discountAmount,
        totalAmount: totalAmount,
        packingInfo: packingInfo,
        imageUrl: imageUrl,
        sortOrder: sortOrder,
        createdAtUtc: createdAtUtc,
      );
}

/// Proforma Invoice Model (for JSON serialization)
@freezed
class PIModel with _$PIModel {
  const PIModel._();

  const factory PIModel({
    @JsonKey(name: 'pi_id') required String piId,
    @JsonKey(name: 'pi_number') required String piNumber,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'store_id') String? storeId,
    @JsonKey(name: 'counterparty_id') String? counterpartyId,
    @JsonKey(name: 'counterparty_name') String? counterpartyName,
    @JsonKey(name: 'counterparty_info') Map<String, dynamic>? counterpartyInfo,
    @JsonKey(name: 'seller_info') Map<String, dynamic>? sellerInfo,
    /// Banking info for PDF (from cash_locations)
    @JsonKey(name: 'banking_info') List<Map<String, dynamic>>? bankingInfo,
    /// Selected bank account IDs (cash_location_ids) for PDF display
    @JsonKey(name: 'bank_account_ids') @Default([]) List<String> bankAccountIds,
    @JsonKey(name: 'currency_id') String? currencyId,
    @JsonKey(name: 'currency_code') @Default('USD') String currencyCode,
    @Default(0) double subtotal,
    @JsonKey(name: 'discount_percent') @Default(0) double discountPercent,
    @JsonKey(name: 'discount_amount') @Default(0) double discountAmount,
    @JsonKey(name: 'tax_percent') @Default(0) double taxPercent,
    @JsonKey(name: 'tax_amount') @Default(0) double taxAmount,
    @JsonKey(name: 'total_amount') @Default(0) double totalAmount,
    @JsonKey(name: 'incoterms_code') String? incotermsCode,
    @JsonKey(name: 'incoterms_place') String? incotermsPlace,
    @JsonKey(name: 'port_of_loading') String? portOfLoading,
    @JsonKey(name: 'port_of_discharge') String? portOfDischarge,
    @JsonKey(name: 'final_destination') String? finalDestination,
    @JsonKey(name: 'country_of_origin') String? countryOfOrigin,
    @JsonKey(name: 'payment_terms_code') String? paymentTermsCode,
    @JsonKey(name: 'payment_terms_detail') String? paymentTermsDetail,
    @JsonKey(name: 'partial_shipment_allowed') @Default(true) bool partialShipmentAllowed,
    @JsonKey(name: 'transshipment_allowed') @Default(true) bool transshipmentAllowed,
    @JsonKey(name: 'shipping_method_code') String? shippingMethodCode,
    @JsonKey(name: 'estimated_shipment_date') DateTime? estimatedShipmentDate,
    @JsonKey(name: 'lead_time_days') int? leadTimeDays,
    @JsonKey(name: 'validity_date') DateTime? validityDate,
    @Default('draft') String status,
    @Default(1) int version,
    String? notes,
    @JsonKey(name: 'internal_notes') String? internalNotes,
    @JsonKey(name: 'terms_and_conditions') String? termsAndConditions,
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'created_at_utc') DateTime? createdAtUtc,
    @JsonKey(name: 'updated_at_utc') DateTime? updatedAtUtc,
    @Default([]) List<PIItemModel> items,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
  }) = _PIModel;

  factory PIModel.fromJson(Map<String, dynamic> json) => _$PIModelFromJson(json);

  /// Convert to entity
  ProformaInvoice toEntity() => ProformaInvoice(
        piId: piId,
        piNumber: piNumber,
        companyId: companyId,
        storeId: storeId,
        counterpartyId: counterpartyId,
        counterpartyName: counterpartyName,
        counterpartyInfo: counterpartyInfo,
        sellerInfo: sellerInfo,
        bankingInfo: bankingInfo,
        bankAccountIds: bankAccountIds,
        currencyId: currencyId,
        currencyCode: currencyCode,
        subtotal: subtotal,
        discountPercent: discountPercent,
        discountAmount: discountAmount,
        taxPercent: taxPercent,
        taxAmount: taxAmount,
        totalAmount: totalAmount,
        incotermsCode: incotermsCode,
        incotermsPlace: incotermsPlace,
        portOfLoading: portOfLoading,
        portOfDischarge: portOfDischarge,
        finalDestination: finalDestination,
        countryOfOrigin: countryOfOrigin,
        paymentTermsCode: paymentTermsCode,
        paymentTermsDetail: paymentTermsDetail,
        partialShipmentAllowed: partialShipmentAllowed,
        transshipmentAllowed: transshipmentAllowed,
        shippingMethodCode: shippingMethodCode,
        estimatedShipmentDate: estimatedShipmentDate,
        leadTimeDays: leadTimeDays,
        validityDate: validityDate,
        status: PIStatus.fromString(status),
        version: version,
        notes: notes,
        internalNotes: internalNotes,
        termsAndConditions: termsAndConditions,
        createdBy: createdBy,
        createdAtUtc: createdAtUtc,
        updatedAtUtc: updatedAtUtc,
        items: items.map((e) => e.toEntity()).toList(),
      );

  /// Convert to list item entity
  PIListItem toListItem() => PIListItem(
        piId: piId,
        piNumber: piNumber,
        counterpartyName: counterpartyName,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        status: PIStatus.fromString(status),
        validityDate: validityDate,
        createdAtUtc: createdAtUtc,
        itemCount: itemCount > 0 ? itemCount : items.length,
      );
}

/// Paginated PI response model
@freezed
class PaginatedPIResponse with _$PaginatedPIResponse {
  const PaginatedPIResponse._();

  const factory PaginatedPIResponse({
    required List<PIModel> data,
    @JsonKey(name: 'total_count') required int totalCount,
    required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _PaginatedPIResponse;

  factory PaginatedPIResponse.fromJson(Map<String, dynamic> json) =>
      _$PaginatedPIResponseFromJson(json);
}
