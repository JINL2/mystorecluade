import 'package:freezed_annotation/freezed_annotation.dart';
import 'counter_party_type.dart';

part 'counter_party_filter.freezed.dart';
part 'counter_party_filter.g.dart';

/// Sort Options
enum CounterPartySortOption {
  name('Name'),
  type('Type'),
  createdAt('Created Date'),
  isInternal('Internal/External');

  final String displayName;
  const CounterPartySortOption(this.displayName);
}

/// Filter Options Model
@freezed
class CounterPartyFilter with _$CounterPartyFilter {
  const factory CounterPartyFilter({
    String? searchQuery,
    List<CounterPartyType>? types,
    @Default(CounterPartySortOption.isInternal) CounterPartySortOption sortBy,
    @Default(false) bool ascending,
    bool? isInternal,
    DateTime? createdAfter,
    DateTime? createdBefore,
    @Default(true) bool includeDeleted,
  }) = _CounterPartyFilter;

  factory CounterPartyFilter.fromJson(Map<String, dynamic> json) =>
      _$CounterPartyFilterFromJson(json);
}
