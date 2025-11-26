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

  /// Convert to database column name
  /// This is a Domain concern - mapping business concepts to storage
  String toColumnName() {
    switch (this) {
      case CounterPartySortOption.name:
        return 'name';
      case CounterPartySortOption.type:
        return 'type';
      case CounterPartySortOption.createdAt:
        return 'created_at';
      case CounterPartySortOption.isInternal:
        return 'is_internal';
    }
  }
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
