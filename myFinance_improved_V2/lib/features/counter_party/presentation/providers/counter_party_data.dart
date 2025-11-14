import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_stats.dart';

part 'counter_party_data.freezed.dart';

/// Combined data model for optimized fetching
@freezed
class CounterPartyData with _$CounterPartyData {
  const CounterPartyData._();

  const factory CounterPartyData({
    required List<CounterParty> counterParties,
    required CounterPartyStats stats,
    required DateTime fetchedAt,
  }) = _CounterPartyData;

  /// Cache validity check (30 seconds)
  static const int _cacheValiditySeconds = 30;

  bool get isStale =>
      DateTime.now().difference(fetchedAt).inSeconds > _cacheValiditySeconds;
}
