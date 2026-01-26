import '../../domain/entities/account_mapping.dart';
import '../../domain/repositories/account_mapping_repository.dart';
import '../datasources/account_mapping_datasource.dart';
import '../models/account_mapping_dto.dart';

/// Account Mapping Repository Implementation
class AccountMappingRepositoryImpl implements AccountMappingRepository {
  final AccountMappingDataSource _dataSource;

  AccountMappingRepositoryImpl(this._dataSource);

  @override
  Future<List<AccountMapping>> getAccountMappings({
    required String counterpartyId,
  }) async {
    try {
      final data = await _dataSource.getAccountMappings(
        counterpartyId: counterpartyId,
      );

      return data
          .map((json) => AccountMappingDto.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to load account mappings: $e');
    }
  }

  @override
  Future<AccountMapping> createAccountMapping({
    required String myCompanyId,
    required String myAccountId,
    required String counterpartyId,
    required String linkedAccountId,
    String direction = 'bidirectional',
    String? createdBy,
  }) async {
    try {
      final data = await _dataSource.createAccountMapping(
        myCompanyId: myCompanyId,
        myAccountId: myAccountId,
        counterpartyId: counterpartyId,
        linkedAccountId: linkedAccountId,
        direction: direction,
        createdBy: createdBy,
      );

      final mappingType = data['type'] as String?;

      // Fetch the complete mapping data (always ordered by created_at DESC from RPC)
      final mappings = await getAccountMappings(counterpartyId: counterpartyId);

      if (mappings.isEmpty) {
        throw Exception('Created mapping not found after insert');
      }

      // Handle different response types
      if (mappingType == 'single_direction') {
        // Single direction: Internal transaction, one mapping created
        final mappingId = data['mapping_id'] as String;
        final newMapping = mappings.firstWhere(
          (m) => m.mappingId == mappingId,
          orElse: () => throw Exception('Created mapping not found with ID: $mappingId'),
        );
        return newMapping;
      } else if (mappingType == 'bidirectional') {
        // Bidirectional: Cross-company transaction, two mappings created
        // Return the most recent mapping (first in list since ordered by created_at DESC)
        return mappings.first;
      } else {
        // Fallback: try both methods for backward compatibility
        if (data.containsKey('mapping_id')) {
          final mappingId = data['mapping_id'] as String;
          final newMapping = mappings.firstWhere(
            (m) => m.mappingId == mappingId,
            orElse: () => mappings.first,
          );
          return newMapping;
        } else {
          return mappings.first;
        }
      }
    } catch (e) {
      // Provide clear error messages to the user
      final errorMsg = e.toString();
      if (errorMsg.contains('Duplicate mapping')) {
        throw Exception('This account mapping already exists for this counterparty');
      } else if (errorMsg.contains('Counterparty does not belong')) {
        throw Exception('Invalid counterparty: This counterparty belongs to a different company');
      } else if (errorMsg.contains('unique_violation') || errorMsg.contains('Database constraint')) {
        throw Exception('Cannot create mapping: This would create a duplicate entry');
      }
      throw Exception('Failed to create account mapping: $e');
    }
  }

  @override
  Future<bool> deleteAccountMapping({
    required String mappingId,
  }) async {
    return await _dataSource.deleteAccountMapping(
      mappingId: mappingId,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAvailableAccounts({
    required String companyId,
  }) async {
    return await _dataSource.getAvailableAccounts(
      companyId: companyId,
    );
  }

  @override
  Future<Map<String, dynamic>?> getLinkedCompanyInfo({
    required String counterpartyId,
  }) async {
    return await _dataSource.getLinkedCompanyInfo(
      counterpartyId: counterpartyId,
    );
  }
}
