import '../entities/journal_entry.dart';
import '../repositories/cash_location_repository.dart';
import '../value_objects/cash_journal_params.dart';
import 'use_case.dart';

/// Use case for getting cash journal entries
class GetCashJournalUseCase implements UseCase<List<JournalEntry>, CashJournalParams> {
  final CashLocationRepository repository;

  GetCashJournalUseCase(this.repository);

  @override
  Future<List<JournalEntry>> call(CashJournalParams params) async {
    return repository.getCashJournal(
      companyId: params.companyId,
      storeId: params.storeId,
      locationType: params.locationType,
      offset: params.offset,
      limit: params.limit,
    );
  }
}
