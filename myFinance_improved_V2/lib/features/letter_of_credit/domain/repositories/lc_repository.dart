import '../entities/letter_of_credit.dart';

/// Parameters for LC list query
class LCListParams {
  final String companyId;
  final String? storeId;
  final List<LCStatus>? statuses;
  final String? applicantId;
  final String? poId;
  final String? piId;
  final DateTime? expiryFrom;
  final DateTime? expiryTo;
  final String? searchQuery;
  final int page;
  final int pageSize;

  const LCListParams({
    required this.companyId,
    this.storeId,
    this.statuses,
    this.applicantId,
    this.poId,
    this.piId,
    this.expiryFrom,
    this.expiryTo,
    this.searchQuery,
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LCListParams) return false;
    return companyId == other.companyId &&
        storeId == other.storeId &&
        _listEquals(statuses, other.statuses) &&
        applicantId == other.applicantId &&
        poId == other.poId &&
        piId == other.piId &&
        expiryFrom == other.expiryFrom &&
        expiryTo == other.expiryTo &&
        searchQuery == other.searchQuery &&
        page == other.page &&
        pageSize == other.pageSize;
  }

  @override
  int get hashCode => Object.hash(
        companyId,
        storeId,
        statuses != null ? Object.hashAll(statuses!) : null,
        applicantId,
        poId,
        piId,
        expiryFrom,
        expiryTo,
        searchQuery,
        page,
        pageSize,
      );

  static bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Paginated LC response
class PaginatedLCResponse {
  final List<LCListItem> data;
  final int totalCount;
  final int page;
  final int pageSize;
  final bool hasMore;

  PaginatedLCResponse({
    required this.data,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

/// LC Repository interface
abstract class LCRepository {
  /// Get paginated list of LCs
  Future<PaginatedLCResponse> getList(LCListParams params);

  /// Get LC by ID
  Future<LetterOfCredit> getById(String lcId);

  /// Create new LC
  Future<LetterOfCredit> create(LCCreateParams params);

  /// Update LC
  Future<LetterOfCredit> update(
      String lcId, int version, Map<String, dynamic> updates);

  /// Delete LC (only draft)
  Future<void> delete(String lcId);

  /// Update LC status
  Future<void> updateStatus(String lcId, LCStatus newStatus, {String? notes});

  /// Add amendment to LC
  Future<LCAmendment> addAmendment(String lcId, LCAmendmentCreateParams params);

  /// Update amendment status
  Future<void> updateAmendmentStatus(
      String amendmentId, LCAmendmentStatus status);

  /// Record utilization (when shipment/CI is created)
  Future<void> recordUtilization(String lcId, double amount);

  /// Create LC from PO
  Future<String> createFromPO(String poId, {Map<String, dynamic>? options});
}

/// Parameters for LC creation
class LCCreateParams {
  final String companyId;
  final String? storeId;
  final String? piId;
  final String? poId;
  final String? lcTypeCode;
  final String? applicantId;
  final Map<String, dynamic>? applicantInfo;
  final Map<String, dynamic>? beneficiaryInfo;
  final String? issuingBankId;
  final Map<String, dynamic>? issuingBankInfo;
  final String? advisingBankId;
  final Map<String, dynamic>? advisingBankInfo;
  final String? confirmingBankId;
  final Map<String, dynamic>? confirmingBankInfo;
  final String? currencyId;
  final double amount;
  final double tolerancePlusPercent;
  final double toleranceMinusPercent;
  final DateTime? issueDateUtc;
  final DateTime expiryDateUtc;
  final String? expiryPlace;
  final DateTime? latestShipmentDateUtc;
  final int presentationPeriodDays;
  final String? paymentTermsCode;
  final int? usanceDays;
  final String? usanceFrom;
  final String? incotermsCode;
  final String? incotermsPlace;
  final String? portOfLoading;
  final String? portOfDischarge;
  final String? shippingMethodCode;
  final bool partialShipmentAllowed;
  final bool transshipmentAllowed;
  final List<LCRequiredDocumentParams> requiredDocuments;
  final String? specialConditions;
  final Map<String, dynamic>? additionalConditions;
  final String? notes;

  LCCreateParams({
    required this.companyId,
    this.storeId,
    this.piId,
    this.poId,
    this.lcTypeCode = 'irrevocable',
    this.applicantId,
    this.applicantInfo,
    this.beneficiaryInfo,
    this.issuingBankId,
    this.issuingBankInfo,
    this.advisingBankId,
    this.advisingBankInfo,
    this.confirmingBankId,
    this.confirmingBankInfo,
    this.currencyId,
    required this.amount,
    this.tolerancePlusPercent = 0,
    this.toleranceMinusPercent = 0,
    this.issueDateUtc,
    required this.expiryDateUtc,
    this.expiryPlace,
    this.latestShipmentDateUtc,
    this.presentationPeriodDays = 21,
    this.paymentTermsCode,
    this.usanceDays,
    this.usanceFrom,
    this.incotermsCode,
    this.incotermsPlace,
    this.portOfLoading,
    this.portOfDischarge,
    this.shippingMethodCode,
    this.partialShipmentAllowed = true,
    this.transshipmentAllowed = true,
    this.requiredDocuments = const [],
    this.specialConditions,
    this.additionalConditions,
    this.notes,
  });
}

/// Parameters for required document
class LCRequiredDocumentParams {
  final String code;
  final String? name;
  final int copiesOriginal;
  final int copiesCopy;
  final String? notes;

  LCRequiredDocumentParams({
    required this.code,
    this.name,
    this.copiesOriginal = 1,
    this.copiesCopy = 1,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        if (name != null) 'name': name,
        'copies_original': copiesOriginal,
        'copies_copy': copiesCopy,
        if (notes != null) 'notes': notes,
      };
}

/// Parameters for LC amendment creation
class LCAmendmentCreateParams {
  final String changesSummary;
  final Map<String, dynamic>? changesDetail;
  final double? amendmentFee;
  final String? amendmentFeeCurrencyId;

  LCAmendmentCreateParams({
    required this.changesSummary,
    this.changesDetail,
    this.amendmentFee,
    this.amendmentFeeCurrencyId,
  });
}
