import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trade_alert.dart';

part 'trade_alert_model.freezed.dart';
part 'trade_alert_model.g.dart';

/// Trade alert model from RPC
@freezed
class TradeAlertModel with _$TradeAlertModel {
  const TradeAlertModel._();

  const factory TradeAlertModel({
    @JsonKey(name: 'alert_id') required String id,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') required String entityId,
    @JsonKey(name: 'entity_number') String? entityNumber,
    @JsonKey(name: 'alert_type') required String alertType,
    required String title,
    String? message,
    @JsonKey(name: 'action_url') String? actionUrl,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'days_before_due') int? daysBeforeDue,
    @Default('medium') String priority,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'is_dismissed') @Default(false) bool isDismissed,
    @JsonKey(name: 'is_resolved') @Default(false) bool isResolved,
    @JsonKey(name: 'is_system_generated') @Default(true) bool isSystemGenerated,
    @JsonKey(name: 'assigned_to') String? assignedTo,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'dismissed_at') DateTime? dismissedAt,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
  }) = _TradeAlertModel;

  factory TradeAlertModel.fromJson(Map<String, dynamic> json) =>
      _$TradeAlertModelFromJson(json);

  /// Convert to domain entity
  TradeAlert toEntity() => TradeAlert(
        id: id,
        companyId: companyId,
        entityType: entityType,
        entityId: entityId,
        entityNumber: entityNumber,
        alertType: TradeAlertType.fromString(alertType) ?? TradeAlertType.actionRequired,
        title: title,
        message: message,
        actionUrl: actionUrl,
        dueDate: dueDate,
        daysBeforeDue: daysBeforeDue,
        priority: AlertPriority.fromString(priority),
        isRead: isRead,
        isDismissed: isDismissed,
        isResolved: isResolved,
        isSystemGenerated: isSystemGenerated,
        assignedTo: assignedTo,
        createdAt: createdAt,
        readAt: readAt,
        dismissedAt: dismissedAt,
        resolvedAt: resolvedAt,
      );
}

/// Alert list response
@freezed
class TradeAlertListResponse with _$TradeAlertListResponse {
  const TradeAlertListResponse._();

  const factory TradeAlertListResponse({
    required List<TradeAlertModel> alerts,
    required PaginationInfo pagination,
    @Default(0) int unreadCount,
  }) = _TradeAlertListResponse;

  factory TradeAlertListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final alertsList = (data['items'] as List<dynamic>? ?? [])
        .map((e) => TradeAlertModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return TradeAlertListResponse(
      alerts: alertsList,
      pagination: PaginationInfo.fromJson(
        data['pagination'] as Map<String, dynamic>? ?? {},
      ),
      unreadCount: data['unread_count'] as int? ??
          alertsList.where((a) => a.isRead == false).length,
    );
  }

  List<TradeAlert> toEntityList() => alerts.map((e) => e.toEntity()).toList();
}

/// Pagination info
@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    @Default(1) int page,
    @JsonKey(name: 'page_size') @Default(20) int pageSize,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @JsonKey(name: 'has_next') @Default(false) bool hasNext,
    @JsonKey(name: 'has_prev') @Default(false) bool hasPrev,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}
