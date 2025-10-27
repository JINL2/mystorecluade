import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_stats.dart';
import '../../domain/repositories/counter_party_repository.dart';
import '../../domain/value_objects/counter_party_filter.dart';
import '../../domain/value_objects/counter_party_type.dart';
import '../datasources/counter_party_data_source.dart';

/// Counter Party Repository Implementation
class CounterPartyRepositoryImpl implements CounterPartyRepository {
  final CounterPartyDataSource _dataSource;

  CounterPartyRepositoryImpl(this._dataSource);

  @override
  Future<List<CounterParty>> getCounterParties({
    required String companyId,
    CounterPartyFilter? filter,
  }) async {
    try {
      final typeFilters = filter?.types?.map((t) => t.displayName).toList();
      final sortColumn = _getSortColumn(filter?.sortBy);

      final data = await _dataSource.getCounterParties(
        companyId: companyId,
        typeFilters: typeFilters,
        isInternal: filter?.isInternal,
        createdAfter: filter?.createdAfter,
        createdBefore: filter?.createdBefore,
        sortColumn: sortColumn,
        ascending: filter?.ascending ?? false,
      );

      return data.map((json) => CounterParty.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load counterparties: $e');
    }
  }

  @override
  Future<CounterPartyStats> getCounterPartyStats({
    required String companyId,
  }) async {
    try {
      final data = await _dataSource.getCounterParties(
        companyId: companyId,
        sortColumn: 'created_at',
        ascending: false,
      );

      final counterParties = data.map((json) => CounterParty.fromJson(json)).toList();

      // Calculate statistics
      return CounterPartyStats(
        total: counterParties.length,
        suppliers: counterParties.where((cp) => cp.type == CounterPartyType.supplier).length,
        customers: counterParties.where((cp) => cp.type == CounterPartyType.customer).length,
        employees: counterParties.where((cp) => cp.type == CounterPartyType.employee).length,
        teamMembers: counterParties.where((cp) => cp.type == CounterPartyType.teamMember).length,
        myCompanies: counterParties.where((cp) => cp.type == CounterPartyType.myCompany).length,
        others: counterParties.where((cp) => cp.type == CounterPartyType.other).length,
        activeCount: counterParties.where((cp) => !cp.isDeleted).length,
        inactiveCount: counterParties.where((cp) => cp.isDeleted).length,
        recentAdditions: counterParties.take(5).toList(),
      );
    } catch (e) {
      throw Exception('Failed to load statistics: $e');
    }
  }

  @override
  Future<CounterParty?> getCounterPartyById(String counterpartyId) async {
    try {
      final data = await _dataSource.getCounterPartyById(counterpartyId);
      if (data == null) return null;
      return CounterParty.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load counter party: $e');
    }
  }

  @override
  Future<CounterParty> createCounterParty({
    required String companyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  }) async {
    try {
      final data = await _dataSource.createCounterParty(
        companyId: companyId,
        name: name,
        type: type.displayName,
        email: email?.isEmpty == true ? null : email,
        phone: phone?.isEmpty == true ? null : phone,
        address: address?.isEmpty == true ? null : address,
        notes: notes?.isEmpty == true ? null : notes,
        isInternal: isInternal,
        linkedCompanyId: linkedCompanyId,
      );

      return CounterParty.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create counter party: $e');
    }
  }

  @override
  Future<CounterParty> updateCounterParty({
    required String counterpartyId,
    required String name,
    required CounterPartyType type,
    String? email,
    String? phone,
    String? address,
    String? notes,
    bool isInternal = false,
    String? linkedCompanyId,
  }) async {
    try {
      final data = await _dataSource.updateCounterParty(
        counterpartyId: counterpartyId,
        name: name,
        type: type.displayName,
        email: email?.isEmpty == true ? null : email,
        phone: phone?.isEmpty == true ? null : phone,
        address: address?.isEmpty == true ? null : address,
        notes: notes?.isEmpty == true ? null : notes,
        isInternal: isInternal,
        linkedCompanyId: linkedCompanyId,
      );

      return CounterParty.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update counter party: $e');
    }
  }

  @override
  Future<bool> deleteCounterParty(String counterpartyId) async {
    try {
      await _dataSource.deleteCounterParty(counterpartyId);
      return true;
    } catch (e) {
      throw Exception('Failed to delete counter party: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUnlinkedCompanies({
    required String userId,
    required String companyId,
  }) async {
    return await _dataSource.getUnlinkedCompanies(
      userId: userId,
      companyId: companyId,
    );
  }

  String _getSortColumn(CounterPartySortOption? option) {
    switch (option) {
      case CounterPartySortOption.name:
        return 'name';
      case CounterPartySortOption.type:
        return 'type';
      case CounterPartySortOption.createdAt:
        return 'created_at';
      case CounterPartySortOption.isInternal:
      case null:
        return 'is_internal';
    }
  }
}
