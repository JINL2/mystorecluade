import '../entities/proforma_invoice.dart';

/// Parameters for PI list query
class PIListParams {
  final String companyId;
  final String? storeId;
  final List<PIStatus>? statuses;
  final String? counterpartyId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchQuery;
  final int page;
  final int pageSize;

  const PIListParams({
    required this.companyId,
    this.storeId,
    this.statuses,
    this.counterpartyId,
    this.dateFrom,
    this.dateTo,
    this.searchQuery,
    this.page = 1,
    this.pageSize = 20,
  });
}

/// Parameters for creating PI
class PICreateParams {
  final String companyId;
  final String? storeId;
  final String? counterpartyId;
  final Map<String, dynamic>? counterpartyInfo;
  final String? currencyId;
  final String? incotermsCode;
  final String? incotermsPlace;
  final String? portOfLoading;
  final String? portOfDischarge;
  final String? finalDestination;
  final String? countryOfOrigin;
  final String? paymentTermsCode;
  final String? paymentTermsDetail;
  final bool partialShipmentAllowed;
  final bool transshipmentAllowed;
  final String? shippingMethodCode;
  final DateTime? estimatedShipmentDate;
  final int? leadTimeDays;
  final DateTime? validityDate;
  final String? notes;
  final String? internalNotes;
  final String? termsAndConditions;
  final List<String> bankAccountIds;
  final List<PIItemParams> items;

  const PICreateParams({
    required this.companyId,
    this.storeId,
    this.counterpartyId,
    this.counterpartyInfo,
    this.currencyId,
    this.incotermsCode,
    this.incotermsPlace,
    this.portOfLoading,
    this.portOfDischarge,
    this.finalDestination,
    this.countryOfOrigin,
    this.paymentTermsCode,
    this.paymentTermsDetail,
    this.partialShipmentAllowed = true,
    this.transshipmentAllowed = true,
    this.shippingMethodCode,
    this.estimatedShipmentDate,
    this.leadTimeDays,
    this.validityDate,
    this.notes,
    this.internalNotes,
    this.termsAndConditions,
    this.bankAccountIds = const [],
    this.items = const [],
  });
}

/// Parameters for PI item
class PIItemParams {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final String? countryOfOrigin;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discountPercent;
  final String? packingInfo;

  const PIItemParams({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    this.countryOfOrigin,
    required this.quantity,
    this.unit,
    required this.unitPrice,
    this.discountPercent = 0,
    this.packingInfo,
  });
}

/// Paginated response
class PaginatedList<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedList({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

/// PI Repository interface
abstract class PIRepository {
  /// Get paginated list of PIs
  Future<PaginatedList<PIListItem>> getList(PIListParams params);

  /// Get PI detail by ID
  Future<ProformaInvoice> getById(String piId);

  /// Create new PI
  Future<ProformaInvoice> create(PICreateParams params);

  /// Update existing PI
  Future<ProformaInvoice> update(String piId, PICreateParams params);

  /// Delete PI (only draft status)
  Future<void> delete(String piId);

  /// Send PI to buyer (change status to SENT)
  Future<void> send(String piId);

  /// Mark PI as accepted
  Future<void> accept(String piId);

  /// Mark PI as rejected
  Future<void> reject(String piId, String? reason);

  /// Convert PI to PO
  Future<String> convertToPO(String piId);

  /// Duplicate PI
  Future<ProformaInvoice> duplicate(String piId);

  /// Generate PI number
  Future<String> generateNumber(String companyId);
}
