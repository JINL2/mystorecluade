// lib/features/cash_location/data/models/stock_flow_model.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/stock_flow.dart';

/// Data models for stock flow tracking
/// These models extend domain entities and add JSON serialization

class JournalFlowModel extends JournalFlow {
  JournalFlowModel({
    required super.flowId,
    required super.createdAt,
    required super.systemTime,
    required super.balanceBefore,
    required super.flowAmount,
    required super.balanceAfter,
    required super.journalId,
    required super.journalDescription,
    required super.journalType,
    required super.accountId,
    required super.accountName,
    required super.createdBy,
    super.counterAccount,
  });

  factory JournalFlowModel.fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    return JournalFlowModel(
      flowId: (json['flow_id'] ?? '').toString(),
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
      systemTime: systemTimeUtc.isNotEmpty ? DateTimeUtils.toLocal(systemTimeUtc).toIso8601String() : '',
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      flowAmount: (json['flow_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      journalId: (json['journal_id'] ?? '').toString(),
      journalDescription: (json['journal_description'] ?? '').toString(),
      journalType: (json['journal_type'] ?? '').toString(),
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      createdBy: CreatedByModel.fromJson((json['created_by'] ?? <String, dynamic>{}) as Map<String, dynamic>),
      counterAccount: json['counter_account'] != null && json['counter_account'] is Map<String, dynamic>
          ? CounterAccountModel.fromJson(json['counter_account'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActualFlowModel extends ActualFlow {
  ActualFlowModel({
    required super.flowId,
    required super.createdAt,
    required super.systemTime,
    required super.balanceBefore,
    required super.flowAmount,
    required super.balanceAfter,
    required super.currency,
    required super.createdBy,
    required super.currentDenominations,
  });

  factory ActualFlowModel.fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    return ActualFlowModel(
      flowId: (json['flow_id'] ?? '').toString(),
      createdAt: createdAtUtc.isNotEmpty ? DateTimeUtils.toLocal(createdAtUtc).toIso8601String() : '',
      systemTime: systemTimeUtc.isNotEmpty ? DateTimeUtils.toLocal(systemTimeUtc).toIso8601String() : '',
      balanceBefore: (json['balance_before'] as num?)?.toDouble() ?? 0.0,
      flowAmount: (json['flow_amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balance_after'] as num?)?.toDouble() ?? 0.0,
      currency: CurrencyInfoModel.fromJson((json['currency'] ?? <String, dynamic>{}) as Map<String, dynamic>),
      createdBy: CreatedByModel.fromJson((json['created_by'] ?? <String, dynamic>{}) as Map<String, dynamic>),
      currentDenominations: (json['current_denominations'] as List<dynamic>?)
          ?.map((e) => DenominationDetailModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class LocationSummaryModel extends LocationSummary {
  LocationSummaryModel({
    required super.cashLocationId,
    required super.locationName,
    required super.locationType,
    super.bankName,
    super.bankAccount,
    required super.currencyCode,
    required super.currencyId,
    super.baseCurrencySymbol,
  });

  factory LocationSummaryModel.fromJson(Map<String, dynamic> json) {
    return LocationSummaryModel(
      cashLocationId: (json['cash_location_id'] ?? '').toString(),
      locationName: (json['location_name'] ?? '').toString(),
      locationType: (json['location_type'] ?? '').toString(),
      bankName: json['bank_name']?.toString(),
      bankAccount: json['bank_account']?.toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyId: (json['currency_id'] ?? '').toString(),
      baseCurrencySymbol: json['base_currency_symbol']?.toString() ?? json['currency_symbol']?.toString(),
    );
  }
}

class CounterAccountModel extends CounterAccount {
  CounterAccountModel({
    required super.accountId,
    required super.accountName,
    required super.accountType,
    required super.debit,
    required super.credit,
    required super.description,
  });

  factory CounterAccountModel.fromJson(Map<String, dynamic> json) {
    return CounterAccountModel(
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      accountType: (json['account_type'] ?? '').toString(),
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
    );
  }
}

class CurrencyInfoModel extends CurrencyInfo {
  CurrencyInfoModel({
    required super.currencyId,
    required super.currencyCode,
    required super.currencyName,
    required super.symbol,
  });

  factory CurrencyInfoModel.fromJson(Map<String, dynamic> json) {
    return CurrencyInfoModel(
      currencyId: (json['currency_id'] ?? '').toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyName: (json['currency_name'] ?? '').toString(),
      symbol: (json['symbol'] ?? '').toString(),
    );
  }
}

class CreatedByModel extends CreatedBy {
  CreatedByModel({
    required super.userId,
    required super.fullName,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      userId: (json['user_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
    );
  }
}

class DenominationDetailModel extends DenominationDetail {
  DenominationDetailModel({
    required super.denominationId,
    required super.denominationValue,
    required super.denominationType,
    required super.previousQuantity,
    required super.currentQuantity,
    required super.quantityChange,
    required super.subtotal,
    super.currencySymbol,
  });

  factory DenominationDetailModel.fromJson(Map<String, dynamic> json) {
    return DenominationDetailModel(
      denominationId: (json['denomination_id'] ?? '').toString(),
      denominationValue: (json['denomination_value'] as num?)?.toDouble() ?? 0.0,
      denominationType: (json['denomination_type'] ?? '').toString(),
      previousQuantity: (json['previous_quantity'] as num?)?.toInt() ?? 0,
      currentQuantity: (json['current_quantity'] as num?)?.toInt() ?? 0,
      quantityChange: (json['quantity_change'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      currencySymbol: json['currency_symbol']?.toString(),
    );
  }
}

class StockFlowDataModel extends StockFlowData {
  StockFlowDataModel({
    super.locationSummary,
    required super.journalFlows,
    required super.actualFlows,
  });

  factory StockFlowDataModel.fromJson(Map<String, dynamic> json) {
    return StockFlowDataModel(
      locationSummary: json['location_summary'] != null
          ? LocationSummaryModel.fromJson(json['location_summary'] as Map<String, dynamic>)
          : null,
      journalFlows: (json['journal_flows'] as List<dynamic>?)
          ?.map((e) => JournalFlowModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      actualFlows: (json['actual_flows'] as List<dynamic>?)
          ?.map((e) => ActualFlowModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class PaginationInfoModel extends PaginationInfo {
  PaginationInfoModel({
    required super.offset,
    required super.limit,
    required super.totalJournalFlows,
    required super.totalActualFlows,
    required super.hasMore,
  });

  factory PaginationInfoModel.fromJson(Map<String, dynamic> json) {
    return PaginationInfoModel(
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalJournalFlows: (json['total_journal_flows'] as num?)?.toInt() ?? 0,
      totalActualFlows: (json['total_actual_flows'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class StockFlowResponseModel extends StockFlowResponse {
  StockFlowResponseModel({
    required super.success,
    super.data,
    super.pagination,
  });

  factory StockFlowResponseModel.fromJson(Map<String, dynamic> json) {
    return StockFlowResponseModel(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? StockFlowDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      pagination: json['pagination'] != null
          ? PaginationInfoModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}
