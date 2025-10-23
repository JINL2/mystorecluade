import 'package:freezed_annotation/freezed_annotation.dart';
import 'counter_party.dart';

part 'counter_party_stats.freezed.dart';
part 'counter_party_stats.g.dart';

/// Counter Party Statistics Entity
@freezed
class CounterPartyStats with _$CounterPartyStats {
  const factory CounterPartyStats({
    required int total,
    required int suppliers,
    required int customers,
    required int employees,
    required int teamMembers,
    required int myCompanies,
    required int others,
    required int activeCount,
    required int inactiveCount,
    @JsonKey(name: 'recent_additions') required List<CounterParty> recentAdditions,
  }) = _CounterPartyStats;

  factory CounterPartyStats.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyStatsFromJson(json);

  factory CounterPartyStats.empty() => const CounterPartyStats(
    total: 0,
    suppliers: 0,
    customers: 0,
    employees: 0,
    teamMembers: 0,
    myCompanies: 0,
    others: 0,
    activeCount: 0,
    inactiveCount: 0,
    recentAdditions: [],
  );
}
