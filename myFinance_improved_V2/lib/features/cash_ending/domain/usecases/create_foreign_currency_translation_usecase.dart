import 'package:intl/intl.dart';

import '../../../../core/constants/account_ids.dart';
import '../repositories/journal_repository.dart';

/// Parameters for creating a foreign currency translation journal entry
class CreateForeignCurrencyTranslationParams {
  final double differenceAmount;
  final String companyId;
  final String userId;
  final String locationName;
  final String cashLocationId;
  final String? storeId;

  CreateForeignCurrencyTranslationParams({
    required this.differenceAmount,
    required this.companyId,
    required this.userId,
    required this.locationName,
    required this.cashLocationId,
    this.storeId,
  });
}

/// Use case for creating foreign currency translation journal entry
/// This adjusts foreign exchange differences by creating a journal entry
/// to account for currency translation gains/losses
class CreateForeignCurrencyTranslationUseCase {
  final JournalRepository repository;

  CreateForeignCurrencyTranslationUseCase(this.repository);

  Future<Map<String, dynamic>> call(
      CreateForeignCurrencyTranslationParams params) async {
    // Use centralized account IDs
    const cashAccountId = AccountIds.cash;
    const foreignCurrencyAccountId = AccountIds.foreignCurrencyTranslation;

    // Get current date
    final now = DateTime.now().toLocal();
    final entryDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(now);

    // Calculate absolute amount
    final absAmount = params.differenceAmount.abs();
    final isPositiveDifference = params.differenceAmount > 0;

    // Create journal lines
    final lines = [
      {
        'account_id': cashAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': params.cashLocationId,
        },
      },
      {
        'account_id': foreignCurrencyAccountId,
        'description': 'Foreign Currency Translation',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];

    return repository.insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: params.companyId,
      createdBy: params.userId,
      description: 'Foreign Currency Translation - ${params.locationName}',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: params.storeId,
    );
  }
}
