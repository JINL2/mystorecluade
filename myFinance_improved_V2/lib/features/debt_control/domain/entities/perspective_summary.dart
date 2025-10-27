import 'package:freezed_annotation/freezed_annotation.dart';

part 'perspective_summary.freezed.dart';

/// Perspective-aware debt summary
@freezed
class PerspectiveSummary with _$PerspectiveSummary {
  const factory PerspectiveSummary({
    required String perspectiveType,
    required String entityId,
    required String entityName,
    required double totalReceivable,
    required double totalPayable,
    required double netPosition,
    required double internalReceivable,
    required double internalPayable,
    required double internalNetPosition,
    required double externalReceivable,
    required double externalPayable,
    required double externalNetPosition,
    @Default([]) List<StoreAggregate> storeAggregates,
    required int counterpartyCount,
    required int transactionCount,
    required double collectionRate,
    required int criticalCount,
  }) = _PerspectiveSummary;

  const PerspectiveSummary._();

  /// Check if perspective is company-level
  bool get isCompanyPerspective => perspectiveType == 'company';

  /// Check if perspective is store-level
  bool get isStorePerspective => perspectiveType == 'store';

  /// Get internal debt ratio
  double get internalDebtRatio {
    final total = totalReceivable + totalPayable;
    if (total == 0) return 0;
    final internalTotal = internalReceivable + internalPayable;
    return (internalTotal / total) * 100;
  }

  /// Get external debt ratio
  double get externalDebtRatio {
    final total = totalReceivable + totalPayable;
    if (total == 0) return 0;
    final externalTotal = externalReceivable + externalPayable;
    return (externalTotal / total) * 100;
  }

  /// Check if summary is healthy
  bool get isHealthy => netPosition >= 0 && criticalCount == 0;
}

/// Store aggregate for company-level view
@freezed
class StoreAggregate with _$StoreAggregate {
  const factory StoreAggregate({
    required String storeId,
    required String storeName,
    required double receivable,
    required double payable,
    required double netPosition,
    required int counterpartyCount,
    required bool isHeadquarters,
  }) = _StoreAggregate;

  const StoreAggregate._();

  /// Check if store has positive position
  bool get hasPositivePosition => netPosition >= 0;

  /// Check if store is headquarters
  bool get isHQ => isHeadquarters;
}
