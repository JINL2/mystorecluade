// lib/features/cash_location/data/models/stock_flow_model.dart

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/stock_flow.dart';

/// Data models for stock flow tracking
/// Since domain entities use Freezed, we use their factory constructors directly

class JournalFlowModel {
  static JournalFlow fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    return JournalFlow(
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

class ActualFlowModel {
  static ActualFlow fromJson(Map<String, dynamic> json) {
    // Convert UTC datetime strings from database to local time ISO8601 strings
    final createdAtUtc = (json['created_at'] ?? '').toString();
    final systemTimeUtc = (json['system_time'] ?? '').toString();

    return ActualFlow(
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

class LocationSummaryModel {
  static LocationSummary fromJson(Map<String, dynamic> json) {
    return LocationSummary(
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

class CounterAccountModel {
  static CounterAccount fromJson(Map<String, dynamic> json) {
    return CounterAccount(
      accountId: (json['account_id'] ?? '').toString(),
      accountName: (json['account_name'] ?? '').toString(),
      accountType: (json['account_type'] ?? '').toString(),
      debit: (json['debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['credit'] as num?)?.toDouble() ?? 0.0,
      description: (json['description'] ?? '').toString(),
    );
  }
}

class CurrencyInfoModel {
  static CurrencyInfo fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      currencyId: (json['currency_id'] ?? '').toString(),
      currencyCode: (json['currency_code'] ?? '').toString(),
      currencyName: (json['currency_name'] ?? '').toString(),
      symbol: (json['symbol'] ?? '').toString(),
    );
  }
}

class CreatedByModel {
  static CreatedBy fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userId: (json['user_id'] ?? '').toString(),
      fullName: (json['full_name'] ?? '').toString(),
    );
  }
}

class DenominationDetailModel {
  static DenominationDetail fromJson(Map<String, dynamic> json) {
    return DenominationDetail(
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

class StockFlowDataModel {
  static StockFlowData fromJson(Map<String, dynamic> json) {
    return StockFlowData(
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

class PaginationInfoModel {
  static PaginationInfo fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalJournalFlows: (json['total_journal_flows'] as num?)?.toInt() ?? 0,
      totalActualFlows: (json['total_actual_flows'] as num?)?.toInt() ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}

class StockFlowResponseModel {
  static StockFlowResponse fromJson(Map<String, dynamic> json) {
    return StockFlowResponse(
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
