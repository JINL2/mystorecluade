import 'package:intl/intl.dart';

import '../../../cash_location/domain/constants/account_ids.dart';
import '../repositories/journal_repository.dart';

/// Parameters for creating an error adjustment journal entry
class CreateErrorAdjustmentParams {
  final double differenceAmount;
  final String companyId;
  final String userId;
  final String locationName;
  final String cashLocationId;
  final String? storeId;

  CreateErrorAdjustmentParams({
    required this.differenceAmount,
    required this.companyId,
    required this.userId,
    required this.locationName,
    required this.cashLocationId,
    this.storeId,
  });
}

/// Use case for creating error adjustment journal entry
/// This adjusts cash discrepancies by creating a journal entry
/// to match the book balance with the actual counted amount
class CreateErrorAdjustmentUseCase {
  final JournalRepository repository;

  CreateErrorAdjustmentUseCase(this.repository);

  Future<Map<String, dynamic>> call(CreateErrorAdjustmentParams params) async {
    // Use centralized account IDs
    const cashAccountId = AccountIds.cash;
    const errorAccountId = AccountIds.errorAdjustment;

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
        'description': 'Make error',
        'debit': isPositiveDifference ? absAmount : 0,
        'credit': isPositiveDifference ? 0 : absAmount,
        'cash': {
          'cash_location_id': params.cashLocationId,
        },
      },
      {
        'account_id': errorAccountId,
        'description': 'Make error',
        'debit': isPositiveDifference ? 0 : absAmount,
        'credit': isPositiveDifference ? absAmount : 0,
      },
    ];

    return repository.insertJournalWithEverything(
      baseAmount: absAmount,
      companyId: params.companyId,
      createdBy: params.userId,
      description: 'Make Error - ${params.locationName}',
      entryDate: entryDate,
      lines: lines,
      counterpartyId: null,
      ifCashLocationId: null,
      storeId: params.storeId,
    );
  }
}
