import 'package:freezed_annotation/freezed_annotation.dart';

part 'proforma_invoice.freezed.dart';

/// Proforma Invoice status enum
enum PIStatus {
  draft,
  sent,
  negotiating,
  accepted,
  rejected,
  converted,
  expired;

  String get label {
    switch (this) {
      case PIStatus.draft:
        return 'Draft';
      case PIStatus.sent:
        return 'Sent';
      case PIStatus.negotiating:
        return 'Negotiating';
      case PIStatus.accepted:
        return 'Accepted';
      case PIStatus.rejected:
        return 'Rejected';
      case PIStatus.converted:
        return 'Converted to PO';
      case PIStatus.expired:
        return 'Expired';
    }
  }

  static PIStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return PIStatus.draft;
      case 'sent':
        return PIStatus.sent;
      case 'negotiating':
        return PIStatus.negotiating;
      case 'accepted':
        return PIStatus.accepted;
      case 'rejected':
        return PIStatus.rejected;
      case 'converted':
        return PIStatus.converted;
      case 'expired':
        return PIStatus.expired;
      default:
        return PIStatus.draft;
    }
  }
}

/// Proforma Invoice Item entity
@freezed
class PIItem with _$PIItem {
  const PIItem._();

  const factory PIItem({
    required String itemId,
    required String piId,
    String? productId,
    required String description,
    String? sku,
    String? barcode,
    String? hsCode,
    String? countryOfOrigin,
    required double quantity,
    String? unit,
    required double unitPrice,
    @Default(0) double discountPercent,
    @Default(0) double discountAmount,
    required double totalAmount,
    String? packingInfo,
    String? imageUrl,
    @Default(0) int sortOrder,
    DateTime? createdAtUtc,
  }) = _PIItem;

  /// Line total (calculated from quantity * unitPrice with discount)
  double get lineTotal => quantity * unitPrice * (1 - discountPercent / 100);
}

/// Proforma Invoice entity
@freezed
class ProformaInvoice with _$ProformaInvoice {
  const ProformaInvoice._();

  const factory ProformaInvoice({
    required String piId,
    required String piNumber,
    required String companyId,
    String? storeId,
    String? counterpartyId,
    String? counterpartyName,
    Map<String, dynamic>? counterpartyInfo,
    Map<String, dynamic>? sellerInfo,
    String? currencyId,
    @Default('USD') String currencyCode,
    @Default(0) double subtotal,
    @Default(0) double discountPercent,
    @Default(0) double discountAmount,
    @Default(0) double taxPercent,
    @Default(0) double taxAmount,
    @Default(0) double totalAmount,
    String? incotermsCode,
    String? incotermsPlace,
    String? portOfLoading,
    String? portOfDischarge,
    String? finalDestination,
    String? countryOfOrigin,
    String? paymentTermsCode,
    String? paymentTermsDetail,
    @Default(true) bool partialShipmentAllowed,
    @Default(true) bool transshipmentAllowed,
    String? shippingMethodCode,
    DateTime? estimatedShipmentDate,
    int? leadTimeDays,
    DateTime? validityDate,
    @Default(PIStatus.draft) PIStatus status,
    @Default(1) int version,
    String? notes,
    String? internalNotes,
    String? termsAndConditions,
    String? createdBy,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,
    @Default([]) List<PIItem> items,
  }) = _ProformaInvoice;

  /// Convenience getter for id (alias for piId)
  String get id => piId;

  /// Check if PI is editable
  bool get isEditable => status == PIStatus.draft || status == PIStatus.negotiating;

  /// Check if PI can be sent
  bool get canSend => status == PIStatus.draft && items.isNotEmpty;

  /// Check if PI can be converted to PO
  bool get canConvertToPO => status == PIStatus.accepted;

  /// Check if PI is expired
  bool get isExpired {
    if (validityDate == null) return false;
    return DateTime.now().isAfter(validityDate!);
  }

  /// Days until expiry
  int? get daysUntilExpiry {
    if (validityDate == null) return null;
    return validityDate!.difference(DateTime.now()).inDays;
  }

  /// Item count
  int get itemCount => items.length;

  /// Formatted total amount
  String get formattedTotal => '$currencyCode ${totalAmount.toStringAsFixed(2)}';
}

/// Proforma Invoice list item (lighter version for list view)
@freezed
class PIListItem with _$PIListItem {
  const PIListItem._();

  const factory PIListItem({
    required String piId,
    required String piNumber,
    String? counterpartyName,
    required String currencyCode,
    required double totalAmount,
    required PIStatus status,
    DateTime? validityDate,
    DateTime? createdAtUtc,
    @Default(0) int itemCount,
  }) = _PIListItem;

  /// Convenience getter for id (alias for piId)
  String get id => piId;
}
