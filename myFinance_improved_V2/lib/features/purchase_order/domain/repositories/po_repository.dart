import '../entities/purchase_order.dart';

/// Parameters for PO list query using inventory_get_order_list RPC
class POListParams {
  final String companyId;
  final String? storeId;
  // Legacy status filter - will be converted to orderStatuses
  final List<POStatus>? statuses;
  // New RPC status filters
  final List<OrderStatus>? orderStatuses;
  final List<ReceivingStatus>? receivingStatuses;
  // Supplier filter (was counterpartyId/buyerId)
  final String? supplierId;
  final String? counterpartyId; // Legacy alias for supplierId
  final bool? hasLc;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? searchQuery;
  final String? timezone;
  final int page;
  final int pageSize;

  POListParams({
    required this.companyId,
    this.storeId,
    this.statuses,
    this.orderStatuses,
    this.receivingStatuses,
    this.supplierId,
    this.counterpartyId,
    this.hasLc,
    this.dateFrom,
    this.dateTo,
    this.searchQuery,
    this.timezone,
    this.page = 1,
    this.pageSize = 20,
  });

  /// Get effective supplier ID (supplierId or legacy counterpartyId)
  String? get effectiveSupplierId => supplierId ?? counterpartyId;
}

/// Paginated PO response
class PaginatedPOResponse {
  final List<POListItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedPOResponse({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

/// PO Repository interface
abstract class PORepository {
  /// Get paginated list of POs
  Future<PaginatedPOResponse> getList(POListParams params);

  /// Get PO by ID
  Future<PurchaseOrder> getById(String poId);

  /// Create new PO
  Future<PurchaseOrder> create(POCreateParams params);

  /// Update PO
  Future<PurchaseOrder> update(String poId, int version, Map<String, dynamic> updates);

  /// Delete PO (only draft)
  Future<void> delete(String poId);

  /// Confirm PO (draft -> confirmed)
  Future<void> confirm(String poId);

  /// Update PO status
  Future<void> updateStatus(String poId, POStatus newStatus, {String? notes});

  /// Convert PI to PO
  Future<String> convertFromPI(String piId, {Map<String, dynamic>? options});

  /// Generate PO number
  Future<String> generateNumber(String companyId);

  /// Close order (cancel order and all linked shipments/sessions)
  Future<Map<String, dynamic>> closeOrder({
    required String orderId,
    required String userId,
    required String companyId,
    String timezone = 'Asia/Ho_Chi_Minh',
  });

  /// Get accepted PIs available for conversion to PO
  Future<List<AcceptedPIForConversion>> getAcceptedPIsForConversion();
}

/// DTO for accepted PI available for conversion to PO
class AcceptedPIForConversion {
  final String piId;
  final String piNumber;
  final String buyerName;
  final double totalAmount;
  final String currencyCode;
  final String currencySymbol;

  const AcceptedPIForConversion({
    required this.piId,
    required this.piNumber,
    required this.buyerName,
    required this.totalAmount,
    required this.currencyCode,
    required this.currencySymbol,
  });
}

/// Parameters for PO creation
class POCreateParams {
  final String companyId;
  final String? storeId;
  final String? piId;
  final String? counterpartyId;
  final String? buyerPoNumber;
  final Map<String, dynamic>? buyerInfo;
  final String? currencyId;
  final String? incotermsCode;
  final String? incotermsPlace;
  final String? paymentTermsCode;
  final DateTime? orderDateUtc;
  final DateTime? requiredShipmentDateUtc;
  final bool partialShipmentAllowed;
  final bool transshipmentAllowed;
  final String? notes;
  final List<POItemCreateParams> items;
  final List<String> bankAccountIds;

  POCreateParams({
    required this.companyId,
    this.storeId,
    this.piId,
    this.counterpartyId,
    this.buyerPoNumber,
    this.buyerInfo,
    this.currencyId,
    this.incotermsCode,
    this.incotermsPlace,
    this.paymentTermsCode,
    this.orderDateUtc,
    this.requiredShipmentDateUtc,
    this.partialShipmentAllowed = true,
    this.transshipmentAllowed = true,
    this.notes,
    this.items = const [],
    this.bankAccountIds = const [],
  });
}

/// Parameters for PO item creation
class POItemCreateParams {
  final String? productId;
  final String description;
  final String? sku;
  final String? hsCode;
  final double quantity;
  final String? unit;
  final double unitPrice;
  final double discountPercent;

  POItemCreateParams({
    this.productId,
    required this.description,
    this.sku,
    this.hsCode,
    required this.quantity,
    this.unit,
    required this.unitPrice,
    this.discountPercent = 0,
  });
}
