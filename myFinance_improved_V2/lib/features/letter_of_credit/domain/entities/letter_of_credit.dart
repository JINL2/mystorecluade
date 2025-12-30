import 'package:freezed_annotation/freezed_annotation.dart';

part 'letter_of_credit.freezed.dart';

/// Letter of Credit status enum
enum LCStatus {
  draft,
  applied,
  issued,
  advised,
  confirmed,
  amended,
  documentsSubmitted,
  utilized,
  expired,
  closed,
  cancelled;

  String get label {
    switch (this) {
      case LCStatus.draft:
        return 'Draft';
      case LCStatus.applied:
        return 'Applied';
      case LCStatus.issued:
        return 'Issued';
      case LCStatus.advised:
        return 'Advised';
      case LCStatus.confirmed:
        return 'Confirmed';
      case LCStatus.amended:
        return 'Amended';
      case LCStatus.documentsSubmitted:
        return 'Docs Submitted';
      case LCStatus.utilized:
        return 'Utilized';
      case LCStatus.expired:
        return 'Expired';
      case LCStatus.closed:
        return 'Closed';
      case LCStatus.cancelled:
        return 'Cancelled';
    }
  }

  static LCStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return LCStatus.draft;
      case 'applied':
        return LCStatus.applied;
      case 'issued':
        return LCStatus.issued;
      case 'advised':
        return LCStatus.advised;
      case 'confirmed':
        return LCStatus.confirmed;
      case 'amended':
        return LCStatus.amended;
      case 'documents_submitted':
        return LCStatus.documentsSubmitted;
      case 'utilized':
        return LCStatus.utilized;
      case 'expired':
        return LCStatus.expired;
      case 'closed':
        return LCStatus.closed;
      case 'cancelled':
        return LCStatus.cancelled;
      default:
        return LCStatus.draft;
    }
  }

  /// Whether the LC is in an active state
  bool get isActive =>
      this == LCStatus.issued ||
      this == LCStatus.advised ||
      this == LCStatus.confirmed ||
      this == LCStatus.amended ||
      this == LCStatus.documentsSubmitted;

  /// Whether the LC can be utilized
  bool get canUtilize => isActive;

  /// Whether the LC is a final state
  bool get isFinal =>
      this == LCStatus.utilized ||
      this == LCStatus.expired ||
      this == LCStatus.closed ||
      this == LCStatus.cancelled;
}

/// LC Amendment status enum
enum LCAmendmentStatus {
  pending,
  approved,
  rejected;

  String get label {
    switch (this) {
      case LCAmendmentStatus.pending:
        return 'Pending';
      case LCAmendmentStatus.approved:
        return 'Approved';
      case LCAmendmentStatus.rejected:
        return 'Rejected';
    }
  }

  static LCAmendmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return LCAmendmentStatus.pending;
      case 'approved':
        return LCAmendmentStatus.approved;
      case 'rejected':
        return LCAmendmentStatus.rejected;
      default:
        return LCAmendmentStatus.pending;
    }
  }
}

/// Required Document for LC
@freezed
class LCRequiredDocument with _$LCRequiredDocument {
  const factory LCRequiredDocument({
    required String code,
    String? name,
    @Default(1) int copiesOriginal,
    @Default(1) int copiesCopy,
    String? notes,
  }) = _LCRequiredDocument;
}

/// LC Amendment entity
@freezed
class LCAmendment with _$LCAmendment {
  const LCAmendment._();

  const factory LCAmendment({
    required String amendmentId,
    required String lcId,
    required int amendmentNumber,
    DateTime? amendmentDateUtc,
    required String changesSummary,
    Map<String, dynamic>? changesDetail,
    double? amendmentFee,
    String? amendmentFeeCurrencyId,
    @Default(LCAmendmentStatus.pending) LCAmendmentStatus status,
    String? requestedBy,
    DateTime? requestedAtUtc,
    DateTime? processedAtUtc,
  }) = _LCAmendment;
}

/// Letter of Credit entity
@freezed
class LetterOfCredit with _$LetterOfCredit {
  const LetterOfCredit._();

  const factory LetterOfCredit({
    required String lcId,
    required String lcNumber,
    required String companyId,
    String? storeId,

    // Related documents
    String? piId,
    String? piNumber,
    String? poId,
    String? poNumber,

    // LC Type
    @Default('irrevocable') String lcTypeCode,
    String? lcTypeName,

    // Parties
    String? applicantId,
    String? applicantName,
    Map<String, dynamic>? applicantInfo,
    Map<String, dynamic>? beneficiaryInfo,

    // Banks
    String? issuingBankId,
    String? issuingBankName,
    Map<String, dynamic>? issuingBankInfo,
    String? advisingBankId,
    String? advisingBankName,
    Map<String, dynamic>? advisingBankInfo,
    String? confirmingBankId,
    String? confirmingBankName,
    Map<String, dynamic>? confirmingBankInfo,

    // Amount
    String? currencyId,
    @Default('USD') String currencyCode,
    required double amount,
    @Default(0) double amountUtilized,
    @Default(0) double tolerancePlusPercent,
    @Default(0) double toleranceMinusPercent,

    // Dates
    DateTime? issueDateUtc,
    required DateTime expiryDateUtc,
    String? expiryPlace,
    DateTime? latestShipmentDateUtc,
    @Default(21) int presentationPeriodDays,

    // Payment terms
    String? paymentTermsCode,
    int? usanceDays,
    String? usanceFrom,

    // Trade terms
    String? incotermsCode,
    String? incotermsPlace,
    String? portOfLoading,
    String? portOfDischarge,
    String? shippingMethodCode,
    @Default(true) bool partialShipmentAllowed,
    @Default(true) bool transshipmentAllowed,

    // Documents & Conditions
    @Default([]) List<LCRequiredDocument> requiredDocuments,
    String? specialConditions,
    Map<String, dynamic>? additionalConditions,

    // Status
    @Default(LCStatus.draft) LCStatus status,
    @Default(1) int version,
    @Default(0) int amendmentCount,
    String? notes,
    String? internalNotes,
    String? createdBy,
    DateTime? createdAtUtc,
    DateTime? updatedAtUtc,

    // Amendments
    @Default([]) List<LCAmendment> amendments,
  }) = _LetterOfCredit;

  /// Convenience getter for id
  String get id => lcId;

  /// Available amount (amount minus utilized)
  double get availableAmount => amount - amountUtilized;

  /// Utilization percentage
  double get utilizationPercent =>
      amount > 0 ? (amountUtilized / amount) * 100 : 0;

  /// Maximum allowed amount with tolerance
  double get maxAllowedAmount => amount * (1 + tolerancePlusPercent / 100);

  /// Minimum allowed amount with tolerance
  double get minAllowedAmount => amount * (1 - toleranceMinusPercent / 100);

  /// Check if LC is editable
  bool get isEditable => status == LCStatus.draft;

  /// Check if LC can be issued
  bool get canIssue => status == LCStatus.draft || status == LCStatus.applied;

  /// Check if LC can be utilized
  bool get canUtilize => status.canUtilize && availableAmount > 0;

  /// Check if LC is expired
  bool get isExpired {
    return DateTime.now().isAfter(expiryDateUtc);
  }

  /// Days until expiry
  int get daysUntilExpiry {
    return expiryDateUtc.difference(DateTime.now()).inDays;
  }

  /// Days until latest shipment date
  int? get daysUntilShipment {
    if (latestShipmentDateUtc == null) return null;
    return latestShipmentDateUtc!.difference(DateTime.now()).inDays;
  }

  /// Check if shipment deadline is approaching (within 7 days)
  bool get isShipmentDeadlineApproaching {
    final days = daysUntilShipment;
    return days != null && days >= 0 && days <= 7;
  }

  /// Check if shipment deadline is overdue
  bool get isShipmentOverdue {
    if (latestShipmentDateUtc == null) return false;
    return DateTime.now().isAfter(latestShipmentDateUtc!) && status.canUtilize;
  }

  /// Formatted amount
  String get formattedAmount => '$currencyCode ${amount.toStringAsFixed(2)}';

  /// Formatted available amount
  String get formattedAvailableAmount =>
      '$currencyCode ${availableAmount.toStringAsFixed(2)}';
}

/// Letter of Credit list item (lighter version for list view)
@freezed
class LCListItem with _$LCListItem {
  const LCListItem._();

  const factory LCListItem({
    required String lcId,
    required String lcNumber,
    String? applicantName,
    String? issuingBankName,
    required String currencyCode,
    required double amount,
    @Default(0) double amountUtilized,
    required LCStatus status,
    required DateTime expiryDateUtc,
    DateTime? latestShipmentDateUtc,
    DateTime? createdAtUtc,
    String? piNumber,
    String? poNumber,
  }) = _LCListItem;

  /// Convenience getter for id
  String get id => lcId;

  /// Available amount
  double get availableAmount => amount - amountUtilized;

  /// Utilization percentage
  double get utilizationPercent =>
      amount > 0 ? (amountUtilized / amount) * 100 : 0;

  /// Days until expiry
  int get daysUntilExpiry {
    return expiryDateUtc.difference(DateTime.now()).inDays;
  }

  /// Check if expired
  bool get isExpired => DateTime.now().isAfter(expiryDateUtc);

  /// Check if expiry is approaching (within 14 days)
  bool get isExpiryApproaching {
    final days = daysUntilExpiry;
    return days >= 0 && days <= 14;
  }
}
