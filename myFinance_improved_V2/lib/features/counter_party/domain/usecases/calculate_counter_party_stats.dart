import '../entities/counter_party.dart';
import '../entities/counter_party_stats.dart';
import '../value_objects/counter_party_type.dart';

/// UseCase: Calculate Counter Party Statistics
///
/// Business Logic: Efficiently calculate statistics from a list of counter parties.
/// This includes counts by type, active/inactive status, and recent additions.
class CalculateCounterPartyStats {
  /// Calculate statistics from a list of counter parties
  CounterPartyStats call(List<CounterParty> counterParties) {
    int total = 0;
    int suppliers = 0;
    int customers = 0;
    int employees = 0;
    int teamMembers = 0;
    int myCompanies = 0;
    int others = 0;
    int activeCount = 0;
    int inactiveCount = 0;
    final List<CounterParty> recentAdditions = [];

    for (final cp in counterParties) {
      total++;

      switch (cp.type) {
        case CounterPartyType.supplier:
          suppliers++;
          break;
        case CounterPartyType.customer:
          customers++;
          break;
        case CounterPartyType.employee:
          employees++;
          break;
        case CounterPartyType.teamMember:
          teamMembers++;
          break;
        case CounterPartyType.myCompany:
          myCompanies++;
          break;
        case CounterPartyType.other:
          others++;
          break;
      }

      if (cp.isDeleted) {
        inactiveCount++;
      } else {
        activeCount++;
      }

      if (recentAdditions.length < 5) {
        recentAdditions.add(cp);
      }
    }

    return CounterPartyStats(
      total: total,
      suppliers: suppliers,
      customers: customers,
      employees: employees,
      teamMembers: teamMembers,
      myCompanies: myCompanies,
      others: others,
      activeCount: activeCount,
      inactiveCount: inactiveCount,
      recentAdditions: recentAdditions,
    );
  }
}
