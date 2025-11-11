// lib/features/cash_ending/data/models/stock_flow_model.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/stock_flow.dart';

/// DTO Model for LocationSummary with fromJson factory and toEntity mapper
class LocationSummaryModel {
  final String cashLocationId;
  final String locationName;
  final String locationType;
  final String? bankName;
  final String? bankAccount;
  final String currencyCode;
  final String currencyId;
  final String? baseCurrencySymbol;

  LocationSummaryModel({
    required this.cashLocationId,
    required this.locationName,
    required this.locationType,
    this.bankName,
    this.bankAccount,
    required this.currencyCode,
    required this.currencyId,
    this.baseCurrencySymbol,
  });

  factory LocationSummaryModel.fromJson(Map<String, dynamic> json) {
    return LocationSummaryModel(
      cashLocationId: json['cash_location_id']?.toString() ?? '',
      locationName: json['location_name']?.toString() ?? '',
      locationType: json['location_type']?.toString() ?? '',
      bankName: json['bank_name']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyId: json['currency_id']?.toString() ?? '',
      baseCurrencySymbol: json['base_currency_symbol']?.toString() ?? json['currency_symbol']?.toString(),
    );
  }

  LocationSummary toEntity() {
    return LocationSummary(
      cashLocationId: cashLocationId,
      locationName: locationName,
      locationType: locationType,
      bankName: bankName,
      bankAccount: bankAccount,
      currencyCode: currencyCode,
      currencyId: currencyId,
      baseCurrencySymbol: baseCurrencySymbol,
    );
  }
}

/// DTO Model for ActualFlow with fromJson factory and toEntity mapper
class ActualFlowModel {
  final String flowId;
  final String createdAt;
  final String systemTime;
  final double balanceBefore;
  final double flowAmount;
  final double balanceAfter;
  final CurrencyInfoModel currency;
  final CreatedByModel createdBy;
  final List<DenominationDetailModel> currentDenominations;

  ActualFlowModel({
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

  factory ActualFlowModel.fromJson(Map<String, dynamic> json) {
    // Convert UTC timestamps from DB to local time ISO strings
    final createdAtUtc = json['created_at']?.toString() ?? '';
    final systemTimeUtc = json['system_time']?.toString() ?? '';

    final createdAtLocal = createdAtUtc.isNotEmpty
        ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String()
        : '';
    final systemTimeLocal = systemTimeUtc.isNotEmpty
        ? DateTimeUtils.toLocal(systemTimeUtc).toIso8601String()
        : '';

    return ActualFlowModel(
      flowId: json['flow_id']?.toString() ?? '',
      createdAt: createdAtLocal,
      systemTime: systemTimeLocal,
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      flowAmount: (json['flow_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      currency: CurrencyInfoModel.fromJson((json['currency'] as Map<String, dynamic>?) ?? {}),
      createdBy: CreatedByModel.fromJson((json['created_by'] as Map<String, dynamic>?) ?? {}),
      currentDenominations: (json['current_denominations'] as List<dynamic>?)
              ?.map((e) => DenominationDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  ActualFlow toEntity() {
    return ActualFlow(
      flowId: flowId,
      createdAt: createdAt,
      systemTime: systemTime,
      balanceBefore: balanceBefore,
      flowAmount: flowAmount,
      balanceAfter: balanceAfter,
      currency: currency.toEntity(),
      createdBy: createdBy.toEntity(),
      currentDenominations:
          currentDenominations.map((d) => d.toEntity()).toList(),
    );
  }
}

/// DTO Model for CurrencyInfo
class CurrencyInfoModel {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  CurrencyInfoModel({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  factory CurrencyInfoModel.fromJson(Map<String, dynamic> json) {
    return CurrencyInfoModel(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
    );
  }

  CurrencyInfo toEntity() {
    return CurrencyInfo(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
    );
  }
}

/// DTO Model for CreatedBy
class CreatedByModel {
  final String userId;
  final String fullName;

  CreatedByModel({
    required this.userId,
    required this.fullName,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
    );
  }

  CreatedBy toEntity() {
    return CreatedBy(
      userId: userId,
      fullName: fullName,
    );
  }
}

/// DTO Model for DenominationDetail
class DenominationDetailModel {
  final String denominationId;
  final double denominationValue;
  final String denominationType;
  final int? previousQuantity;   // Nullable - RPC returns null for non-comparative data
  final int? currentQuantity;    // Nullable - RPC returns null for non-comparative data
  final int? quantityChange;     // Nullable - RPC returns null for non-comparative data
  final double subtotal;
  final String? currencySymbol;

  DenominationDetailModel({
    required this.denominationId,
    required this.denominationValue,
    required this.denominationType,
    this.previousQuantity,
    this.currentQuantity,
    this.quantityChange,
    required this.subtotal,
    this.currencySymbol,
  });

  factory DenominationDetailModel.fromJson(Map<String, dynamic> json) {
    // Parse nullable int fields - keep null if RPC returned null
    final prevQty = json['previous_quantity'];
    final currQty = json['current_quantity'];
    final qtyChange = json['quantity_change'];

    return DenominationDetailModel(
      denominationId: json['denomination_id']?.toString() ?? '',
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      denominationType: json['denomination_type']?.toString() ?? '',
      previousQuantity: prevQty != null ? (prevQty as num).toInt() : null,
      currentQuantity: currQty != null ? (currQty as num).toInt() : null,
      quantityChange: qtyChange != null ? (qtyChange as num).toInt() : null,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol']?.toString(),
    );
  }

  DenominationDetail toEntity() {
    return DenominationDetail(
      denominationId: denominationId,
      denominationValue: denominationValue,
      denominationType: denominationType,
      previousQuantity: previousQuantity,
      currentQuantity: currentQuantity,
      quantityChange: quantityChange,
      subtotal: subtotal,
      currencySymbol: currencySymbol,
    );
  }
}

/// DTO Model for PaginationInfo
class PaginationInfoModel {
  final int offset;
  final int limit;
  final int totalJournalFlows;
  final int totalActualFlows;
  final bool hasMore;

  PaginationInfoModel({
    required this.offset,
    required this.limit,
    required this.totalJournalFlows,
    required this.totalActualFlows,
    required this.hasMore,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      offset: (json['offset'] as int?) ?? 0,
      limit: (json['limit'] as int?) ?? 20,
      totalJournalFlows: (json['total_journal_flows'] as int?) ?? 0,
      totalActualFlows: (json['total_actual_flows'] as int?) ?? 0,
      hasMore: (json['has_more'] as bool?) ?? false,
    );
  }

  PaginationInfo toEntity() {
    return PaginationInfo(
      offset: offset,
      limit: limit,
      totalJournalFlows: totalJournalFlows,
      totalActualFlows: totalActualFlows,
      hasMore: hasMore,
    );
  }
}

/// Response wrapper for stock flow data
class StockFlowResponseModel {
  final bool success;
  final StockFlowDataModel? data;
  final PaginationInfoModel? pagination;

  StockFlowResponseModel({
    required this.success,
    this.data,
    this.pagination,
  });

  factory StockFlowResponseModel.fromJson(Map<String, dynamic> json) {
    return StockFlowResponseModel(
      success: (json['success'] as bool?) ?? false,
      data: json['data'] != null
          ? StockFlowDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      pagination: json['pagination'] != null
          ? PaginationInfoModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Stock flow data container
class StockFlowDataModel {
  final LocationSummaryModel? locationSummary;
  final List<ActualFlowModel> actualFlows;

  StockFlowDataModel({
    this.locationSummary,
    required this.actualFlows,
  });

  factory StockFlowDataModel.fromJson(Map<String, dynamic> json) {
    return StockFlowDataModel(
      locationSummary: json['location_summary'] != null
          ? LocationSummaryModel.fromJson(json['location_summary'] as Map<String, dynamic>)
          : null,
      actualFlows: (json['actual_flows'] as List<dynamic>?)
              ?.map((e) => ActualFlowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
