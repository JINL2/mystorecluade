// lib/features/cash_location/domain/entities/stock_flow.dart

/// Domain entities for stock flow tracking in cash locations
/// These classes represent the core business logic for tracking
/// journal flows and actual cash flows

class JournalFlow {
  final String flowId;
  final String createdAt;
  final String systemTime;
  final double balanceBefore;
  final double flowAmount;
  final double balanceAfter;
  final String journalId;
  final String journalDescription;
  final String journalType;
  final String accountId;
  final String accountName;
  final CreatedBy createdBy;
  final CounterAccount? counterAccount;

  JournalFlow({
    required this.flowId,
    required this.createdAt,
    required this.systemTime,
    required this.balanceBefore,
    required this.flowAmount,
    required this.balanceAfter,
    required this.journalId,
    required this.journalDescription,
    required this.journalType,
    required this.accountId,
    required this.accountName,
    required this.createdBy,
    this.counterAccount,
  });

  String getFormattedDate() {
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.day}/${dateTime.month}';
    } catch (e) {
      return '';
    }
  }

  String getFormattedTime() {
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}

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

  ActualFlow({
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

  String getFormattedDate() {
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.day}/${dateTime.month}';
    } catch (e) {
      return '';
    }
  }

  String getFormattedTime() {
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}

class LocationSummary {
  final String cashLocationId;
  final String locationName;
  final String locationType;
  final String? bankName;
  final String? bankAccount;
  final String currencyCode;
  final String currencyId;
  final String? baseCurrencySymbol;

  LocationSummary({
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

class CounterAccount {
  final String accountId;
  final String accountName;
  final String accountType;
  final double debit;
  final double credit;
  final String description;

  CounterAccount({
    required this.accountId,
    required this.accountName,
    required this.accountType,
    required this.debit,
    required this.credit,
    required this.description,
  });
}

class CurrencyInfo {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  CurrencyInfo({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });
}

class CreatedBy {
  final String userId;
  final String fullName;

  CreatedBy({
    required this.userId,
    required this.fullName,
  });
}

class DenominationDetail {
  final String denominationId;
  final double denominationValue;
  final String denominationType;
  final int previousQuantity;
  final int currentQuantity;
  final int quantityChange;
  final double subtotal;
  final String? currencySymbol;

  DenominationDetail({
    required this.denominationId,
    required this.denominationValue,
    required this.denominationType,
    required this.previousQuantity,
    required this.currentQuantity,
    required this.quantityChange,
    required this.subtotal,
    this.currencySymbol,
  });
}

class StockFlowData {
  final LocationSummary? locationSummary;
  final List<JournalFlow> journalFlows;
  final List<ActualFlow> actualFlows;

  StockFlowData({
    this.locationSummary,
    required this.journalFlows,
    required this.actualFlows,
  });
}

class PaginationInfo {
  final int offset;
  final int limit;
  final int totalJournalFlows;
  final int totalActualFlows;
  final bool hasMore;

  PaginationInfo({
    required this.offset,
    required this.limit,
    required this.totalJournalFlows,
    required this.totalActualFlows,
    required this.hasMore,
  });
}

class StockFlowResponse {
  final bool success;
  final StockFlowData? data;
  final PaginationInfo? pagination;

  StockFlowResponse({
    required this.success,
    this.data,
    this.pagination,
  });
}
