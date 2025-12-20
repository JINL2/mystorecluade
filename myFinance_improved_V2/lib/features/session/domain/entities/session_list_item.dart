import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_list_item.freezed.dart';

/// Session list item entity from RPC response
@freezed
class SessionListItem with _$SessionListItem {
  const SessionListItem._();

  const factory SessionListItem({
    required String sessionId,
    required String sessionName,
    required String sessionType,
    required String storeId,
    required String storeName,
    String? shipmentId,
    String? shipmentNumber,
    required bool isActive,
    required bool isFinal,
    required int memberCount,
    required String createdBy,
    required String createdByName,
    String? completedAt,
    required String createdAt,
  }) = _SessionListItem;

  bool get isCounting => sessionType == 'counting';
  bool get isReceiving => sessionType == 'receiving';
}

/// Response wrapper for session list
@freezed
class SessionListResponse with _$SessionListResponse {
  const SessionListResponse._();

  const factory SessionListResponse({
    required List<SessionListItem> sessions,
    required int totalCount,
    required int limit,
    required int offset,
  }) = _SessionListResponse;

  bool get hasMore => offset + sessions.length < totalCount;
}
