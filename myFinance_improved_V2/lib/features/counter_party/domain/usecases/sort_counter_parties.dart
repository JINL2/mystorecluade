import '../entities/counter_party.dart';
import '../value_objects/counter_party_filter.dart';

/// UseCase: Sort Counter Parties
///
/// Business Logic: Apply sorting to a list of counter parties based on
/// different criteria (name, type, date, internal/external status).
class SortCounterParties {
  /// Sort counter parties based on the provided sort option
  List<CounterParty> call(
    List<CounterParty> counterParties,
    CounterPartySortOption sortBy,
    bool ascending,
  ) {
    final sortedList = List<CounterParty>.from(counterParties);

    switch (sortBy) {
      case CounterPartySortOption.name:
        sortedList.sort((a, b) {
          final comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          return ascending ? comparison : -comparison;
        });
        break;

      case CounterPartySortOption.type:
        sortedList.sort((a, b) {
          final comparison = a.type.displayName.compareTo(b.type.displayName);
          return ascending ? comparison : -comparison;
        });
        break;

      case CounterPartySortOption.createdAt:
        sortedList.sort((a, b) {
          final comparison = a.createdAt.compareTo(b.createdAt);
          return ascending ? comparison : -comparison;
        });
        break;

      case CounterPartySortOption.isInternal:
        sortedList.sort((a, b) {
          final comparison =
              a.isInternal.toString().compareTo(b.isInternal.toString());
          return ascending ? comparison : -comparison;
        });
        break;
    }

    return sortedList;
  }
}
