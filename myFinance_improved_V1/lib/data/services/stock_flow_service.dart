import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Provider for the stock flow service
final stockFlowServiceProvider = Provider<StockFlowService>((ref) {
  return StockFlowService();
});

// Provider for fetching stock flow data
final stockFlowProvider = FutureProvider.family<StockFlowResponse, StockFlowParams>((ref, params) async {
  final service = ref.read(stockFlowServiceProvider);
  return service.getLocationStockFlow(params);
});

// Parameters for the stock flow request
class StockFlowParams {
  final String companyId;
  final String storeId;
  final String cashLocationId;
  final int offset;
  final int limit;

  StockFlowParams({
    required this.companyId,
    required this.storeId,
    required this.cashLocationId,
    this.offset = 0,
    this.limit = 20,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockFlowParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId &&
          cashLocationId == other.cashLocationId &&
          offset == other.offset &&
          limit == other.limit;

  @override
  int get hashCode =>
      companyId.hashCode ^
      storeId.hashCode ^
      cashLocationId.hashCode ^
      offset.hashCode ^
      limit.hashCode;
}

// Service class for stock flow operations
class StockFlowService {
  final _supabase = Supabase.instance.client;

  Future<StockFlowResponse> getLocationStockFlow(StockFlowParams params) async {
    try {
      // Validate parameters
      if (params.cashLocationId.isEmpty) {
        throw Exception('Cash location ID is required');
      }
      if (params.companyId.isEmpty) {
        throw Exception('Company ID is required');
      }
      if (params.storeId.isEmpty) {
        throw Exception('Store ID is required');
      }
      
      final response = await _supabase.rpc(
        'get_location_stock_flow',
        params: {
          'p_company_id': params.companyId,
          'p_store_id': params.storeId,
          'p_cash_location_id': params.cashLocationId,
          'p_offset': params.offset,
          'p_limit': params.limit,
        },
      );

      if (response == null) {
        throw Exception('No data received from get_location_stock_flow');
      }

      return StockFlowResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch stock flow data: $e');
    }
  }
}

// Response models
class StockFlowResponse {
  final bool success;
  final StockFlowData? data;
  final PaginationInfo? pagination;

  StockFlowResponse({
    required this.success,
    this.data,
    this.pagination,
  });

  factory StockFlowResponse.fromJson(Map<String, dynamic> json) {
    return StockFlowResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? StockFlowData.fromJson(json['data']) : null,
      pagination: json['pagination'] != null ? PaginationInfo.fromJson(json['pagination']) : null,
    );
  }
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

  factory StockFlowData.fromJson(Map<String, dynamic> json) {
    return StockFlowData(
      locationSummary: json['location_summary'] != null 
          ? LocationSummary.fromJson(json['location_summary']) 
          : null,
      journalFlows: (json['journal_flows'] as List<dynamic>?)
          ?.map((e) => JournalFlow.fromJson(e))
          .toList() ?? [],
      actualFlows: (json['actual_flows'] as List<dynamic>?)
          ?.map((e) => ActualFlow.fromJson(e))
          .toList() ?? [],
    );
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

  factory LocationSummary.fromJson(Map<String, dynamic> json) {
    return LocationSummary(
      cashLocationId: json['cash_location_id'] ?? '',
      locationName: json['location_name'] ?? '',
      locationType: json['location_type'] ?? '',
      bankName: json['bank_name'],
      bankAccount: json['bank_account'],
      currencyCode: json['currency_code'] ?? '',
      currencyId: json['currency_id'] ?? '',
      baseCurrencySymbol: json['base_currency_symbol'] ?? json['currency_symbol'],
    );
  }
}

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
  });

  factory JournalFlow.fromJson(Map<String, dynamic> json) {
    return JournalFlow(
      flowId: json['flow_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      systemTime: json['system_time'] ?? '',
      balanceBefore: (json['balance_before'] ?? 0).toDouble(),
      flowAmount: (json['flow_amount'] ?? 0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0).toDouble(),
      journalId: json['journal_id'] ?? '',
      journalDescription: json['journal_description'] ?? '',
      journalType: json['journal_type'] ?? '',
      accountId: json['account_id'] ?? '',
      accountName: json['account_name'] ?? '',
      createdBy: CreatedBy.fromJson(json['created_by'] ?? {}),
    );
  }

  String getFormattedDate() {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.day}/${date.month}';
    } catch (e) {
      return createdAt;
    }
  }

  String getFormattedTime() {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
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

  factory ActualFlow.fromJson(Map<String, dynamic> json) {
    return ActualFlow(
      flowId: json['flow_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      systemTime: json['system_time'] ?? '',
      balanceBefore: (json['balance_before'] ?? 0).toDouble(),
      flowAmount: (json['flow_amount'] ?? 0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0).toDouble(),
      currency: CurrencyInfo.fromJson(json['currency'] ?? {}),
      createdBy: CreatedBy.fromJson(json['created_by'] ?? {}),
      currentDenominations: (json['current_denominations'] as List<dynamic>?)
          ?.map((e) => DenominationDetail.fromJson(e))
          .toList() ?? [],
    );
  }

  String getFormattedDate() {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.day}/${date.month}';
    } catch (e) {
      return createdAt;
    }
  }

  String getFormattedTime() {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
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

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) {
    return CurrencyInfo(
      currencyId: json['currency_id'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      symbol: json['symbol'] ?? '',
    );
  }
}

class CreatedBy {
  final String userId;
  final String fullName;

  CreatedBy({
    required this.userId,
    required this.fullName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      userId: json['user_id'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
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

  factory DenominationDetail.fromJson(Map<String, dynamic> json) {
    return DenominationDetail(
      denominationId: json['denomination_id'] ?? '',
      denominationValue: (json['denomination_value'] ?? 0).toDouble(),
      denominationType: json['denomination_type'] ?? '',
      previousQuantity: json['previous_quantity'] ?? 0,
      currentQuantity: json['current_quantity'] ?? 0,
      quantityChange: json['quantity_change'] ?? 0,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      currencySymbol: json['currency_symbol'],
    );
  }
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

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      offset: json['offset'] ?? 0,
      limit: json['limit'] ?? 20,
      totalJournalFlows: json['total_journal_flows'] ?? 0,
      totalActualFlows: json['total_actual_flows'] ?? 0,
      hasMore: json['has_more'] ?? false,
    );
  }
}