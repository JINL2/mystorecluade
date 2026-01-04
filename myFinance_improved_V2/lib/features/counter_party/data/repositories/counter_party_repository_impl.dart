import '../../domain/entities/counter_party.dart';
import '../../domain/entities/counter_party_deletion_validation.dart';
import '../../domain/repositories/counter_party_repository.dart';
import '../../domain/value_objects/counter_party_filter.dart';
import '../../domain/value_objects/counter_party_type.dart';
import '../datasources/counter_party_data_source.dart';
import '../models/counter_party_deletion_validation_dto.dart';
import '../models/counter_party_dto.dart';

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
      final sortColumn = filter?.sortBy.toColumnName() ?? 'is_internal';

      final data = await _dataSource.getCounterParties(
        companyId: companyId,
        typeFilters: typeFilters,
        isInternal: filter?.isInternal,
        createdAfter: filter?.createdAfter,
        createdBefore: filter?.createdBefore,
        sortColumn: sortColumn,
        ascending: filter?.ascending ?? false,
      );

      return data
          .map((json) => CounterPartyDto.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to load counterparties: $e');
    }
  }

  @override
  Future<CounterParty?> getCounterPartyById(String counterpartyId) async {
    try {
      final data = await _dataSource.getCounterPartyById(counterpartyId);
      if (data == null) return null;
      return CounterPartyDto.fromJson(data).toEntity();
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

      return CounterPartyDto.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Failed to create counter party: $e');
    }
  }

  @override
  Future<CounterParty> updateCounterParty({
    required String counterpartyId,
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
      // Internal counterparty는 isInternal/linkedCompanyId 변경 불가 (다른 필드는 수정 가능)
      final existing = await getCounterPartyById(counterpartyId);
      if (existing != null && existing.isInternal) {
        // 기존 internal 상태 유지
        isInternal = existing.isInternal;
        linkedCompanyId = existing.linkedCompanyId;
      }

      final data = await _dataSource.updateCounterParty(
        counterpartyId: counterpartyId,
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

      return CounterPartyDto.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Failed to update counter party: $e');
    }
  }

  @override
  Future<CounterPartyDeletionValidation> validateDeletion(
    String counterpartyId,
  ) async {
    try {
      final data = await _dataSource.validateDeletion(counterpartyId);
      return CounterPartyDeletionValidationDto.fromJson(data).toEntity();
    } catch (e) {
      throw Exception('Failed to validate counter party deletion: $e');
    }
  }

  @override
  Future<bool> deleteCounterParty(String counterpartyId) async {
    try {
      // Internal counterparty는 시스템이 자동 관리하므로 삭제 불가
      final existing = await getCounterPartyById(counterpartyId);
      if (existing != null && existing.isInternal) {
        throw Exception(
          'Internal counterparties are system-managed and cannot be deleted',
        );
      }

      // Validate before deletion - only check for unpaid debts
      final validation = await validateDeletion(counterpartyId);

      if (!validation.canDelete) {
        if (validation.hasUnpaidDebts) {
          throw Exception(
            'Cannot delete: Has ${validation.unpaidDebtCount} unpaid debts '
            'totaling ${validation.unpaidDebtAmount}',
          );
        }
        throw Exception('Cannot delete: ${validation.reason}');
      }

      // Soft delete - data remains but hidden from UI
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
}
