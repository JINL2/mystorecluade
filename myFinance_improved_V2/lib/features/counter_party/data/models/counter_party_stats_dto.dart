import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/counter_party_stats.dart';
import 'counter_party_dto.dart';

part 'counter_party_stats_dto.freezed.dart';
part 'counter_party_stats_dto.g.dart';

/// Counter Party Stats DTO for JSON serialization
@freezed
class CounterPartyStatsDto with _$CounterPartyStatsDto {
  const CounterPartyStatsDto._();

  const factory CounterPartyStatsDto({
    required int total,
    required int suppliers,
    required int customers,
    required int employees,
    required int teamMembers,
    required int myCompanies,
    required int others,
    required int activeCount,
    required int inactiveCount,
    @JsonKey(name: 'recent_additions') required List<CounterPartyDto> recentAdditions,
  }) = _CounterPartyStatsDto;

  factory CounterPartyStatsDto.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyStatsDtoFromJson(json);

  /// Convert to Domain Entity
  CounterPartyStats toEntity() => CounterPartyStats(
    total: total,
    suppliers: suppliers,
    customers: customers,
    employees: employees,
    teamMembers: teamMembers,
    myCompanies: myCompanies,
    others: others,
    activeCount: activeCount,
    inactiveCount: inactiveCount,
    recentAdditions: recentAdditions.map((dto) => dto.toEntity()).toList(),
  );

  /// Create DTO from Entity
  factory CounterPartyStatsDto.fromEntity(CounterPartyStats entity) => CounterPartyStatsDto(
    total: entity.total,
    suppliers: entity.suppliers,
    customers: entity.customers,
    employees: entity.employees,
    teamMembers: entity.teamMembers,
    myCompanies: entity.myCompanies,
    others: entity.others,
    activeCount: entity.activeCount,
    inactiveCount: entity.inactiveCount,
    recentAdditions: entity.recentAdditions.map((e) => CounterPartyDto.fromEntity(e)).toList(),
  );
}
