import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/analytics_hub.dart';

part 'analytics_hub_state.freezed.dart';

/// Analytics Hub 페이지 상태
@freezed
class AnalyticsHubState with _$AnalyticsHubState {
  const AnalyticsHubState._();

  const factory AnalyticsHubState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    AnalyticsHubData? data,
    String? errorMessage,
  }) = _AnalyticsHubState;

  /// 데이터 로드 완료 여부
  bool get hasData => data != null;

  /// 에러 상태 여부
  bool get hasError => errorMessage != null;

  /// 초기 상태 (첫 로드 전)
  bool get isInitial => !isLoading && data == null && errorMessage == null;
}
