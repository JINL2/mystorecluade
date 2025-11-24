import '../../domain/repositories/journal_repository.dart';
import '../datasources/journal_remote_datasource.dart';

/// Implementation of JournalRepository
/// Coordinates between domain layer and data sources
class JournalRepositoryImpl implements JournalRepository {
  final JournalRemoteDataSource _remoteDataSource;

  JournalRepositoryImpl({
    required JournalRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  }) async {
    try {
      return await _remoteDataSource.insertJournalWithEverything(
        baseAmount: baseAmount,
        companyId: companyId,
        createdBy: createdBy,
        description: description,
        entryDate: entryDate,
        lines: lines,
        counterpartyId: counterpartyId,
        ifCashLocationId: ifCashLocationId,
        storeId: storeId,
      );
    } catch (e) {
      // Re-throw with additional context
      throw Exception('Repository error: Failed to insert journal entry - $e');
    }
  }
}
