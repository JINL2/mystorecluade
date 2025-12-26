// lib/features/cash_location/domain/entities/stock_flow/stock_flow_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'actual_flow.dart';
import 'journal_flow.dart';
import 'shared_entities.dart';

part 'stock_flow_data.freezed.dart';

/// Aggregated stock flow data
@freezed
class StockFlowData with _$StockFlowData {
  const factory StockFlowData({
    LocationSummary? locationSummary,
    required List<JournalFlow> journalFlows,
    required List<ActualFlow> actualFlows,
  }) = _StockFlowData;
}

/// Pagination information for stock flow queries
@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    required int offset,
    required int limit,
    required int totalJournalFlows,
    required int totalActualFlows,
    required bool hasMore,
  }) = _PaginationInfo;
}

/// Response wrapper for stock flow API
@freezed
class StockFlowResponse with _$StockFlowResponse {
  const factory StockFlowResponse({
    required bool success,
    StockFlowData? data,
    PaginationInfo? pagination,
  }) = _StockFlowResponse;
}
