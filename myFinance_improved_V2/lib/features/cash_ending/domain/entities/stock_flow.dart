// lib/features/cash_ending/domain/entities/stock_flow.dart

/// Domain entity for location summary
class LocationSummary {
  final String cashLocationId;
  final String locationName;
  final String locationType;
  final String? bankName;
  final String? bankAccount;
  final String currencyCode;
  final String currencyId;
  final String? baseCurrencySymbol;

  const LocationSummary({
    required this.cashLocationId,
    required this.locationName,
    required this.locationType,
    this.bankName,
    this.bankAccount,
    required this.currencyCode,
    required this.currencyId,
    this.baseCurrencySymbol,
  });
}

/// Domain entity for actual cash flow
class ActualFlow {
  final String flowId;
  final String createdAt;
  final String systemTime;
  final double balanceBefore;
  final double flowAmount;
  final double balanceAfter;
  final CurrencyInfo currency;
  final CreatedBy createdBy;
  final List<DenominationDetail> currentDenominations;

  const ActualFlow({
    required this.flowId,
    required this.createdAt,
    required this.systemTime,
    required this.balanceBefore,
    required this.flowAmount,
    required this.balanceAfter,
    required this.currency,
    required this.createdBy,
    required this.currentDenominations,
  });

  // ✅ Formatting logic moved to Presentation Extension
  // See: presentation/extensions/stock_flow_presentation_extension.dart
}

/// Currency information
class CurrencyInfo {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  const CurrencyInfo({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });
}

/// User who created the flow
class CreatedBy {
  final String userId;
  final String fullName;

  const CreatedBy({
    required this.userId,
    required this.fullName,
  });
}

/// Denomination detail for actual flow
class DenominationDetail {
  final String denominationId;
  final double denominationValue;
  final String denominationType;
  final int? previousQuantity;   // Nullable - only present for comparative counts
  final int? currentQuantity;    // Nullable - only present for comparative counts
  final int? quantityChange;     // Nullable - only present for comparative counts
  final double subtotal;
  final String? currencySymbol;

  const DenominationDetail({
    required this.denominationId,
    required this.denominationValue,
    required this.denominationType,
    this.previousQuantity,
    this.currentQuantity,
    this.quantityChange,
    required this.subtotal,
    this.currencySymbol,
  });

  /// Check if this denomination has comparative data (previous vs current)
  bool get hasComparativeData =>
      previousQuantity != null &&
      currentQuantity != null &&
      quantityChange != null;
}

/// Pagination information
class PaginationInfo {
  final int offset;
  final int limit;
  final int totalJournalFlows;
  final int totalActualFlows;
  final bool hasMore;

  const PaginationInfo({
    required this.offset,
    required this.limit,
    required this.totalJournalFlows,
    required this.totalActualFlows,
    required this.hasMore,
  });
}
