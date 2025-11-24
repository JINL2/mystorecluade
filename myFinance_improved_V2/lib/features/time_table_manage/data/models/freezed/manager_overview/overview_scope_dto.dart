import 'package:freezed_annotation/freezed_annotation.dart';

import '../common/date_range_dto.dart';

part 'overview_scope_dto.freezed.dart';
part 'overview_scope_dto.g.dart';

/// Overview Scope DTO
///
/// Defines the scope of the overview query.
///
/// Fields:
/// - companyId: The company identifier
/// - companyName: The company name
/// - totalStores: Total number of stores in the scope
/// - dateRange: The date range for the overview
@freezed
class OverviewScopeDto with _$OverviewScopeDto {
  const factory OverviewScopeDto({
    @JsonKey(name: 'company_id') @Default('') String companyId,
    @JsonKey(name: 'company_name') @Default('') String companyName,
    @JsonKey(name: 'total_stores') @Default(0) int totalStores,
    @JsonKey(name: 'date_range') required DateRangeDto dateRange,
  }) = _OverviewScopeDto;

  factory OverviewScopeDto.fromJson(Map<String, dynamic> json) =>
      _$OverviewScopeDtoFromJson(json);
}
