// Presentation Providers
// Riverpod providers for UI state management

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../../domain/entities/journal_entry.dart';
import '../../domain/entities/transaction_line.dart';

// Journal Entry State Provider (immutable)
final journalEntryStateProvider = StateProvider<JournalEntry>((ref) {
  return JournalEntry(
    entryDate: DateTime.now(),
    transactionLines: const [],
  );
});

// Helper providers for computed values
final totalDebitsProvider = Provider<double>((ref) {
  final journalEntry = ref.watch(journalEntryStateProvider);
  return journalEntry.totalDebits;
});

final totalCreditsProvider = Provider<double>((ref) {
  final journalEntry = ref.watch(journalEntryStateProvider);
  return journalEntry.totalCredits;
});

final differenceProvider = Provider<double>((ref) {
  final journalEntry = ref.watch(journalEntryStateProvider);
  return journalEntry.difference;
});

final isBalancedProvider = Provider<bool>((ref) {
  final journalEntry = ref.watch(journalEntryStateProvider);
  return journalEntry.isBalanced;
});

final canSubmitProvider = Provider<bool>((ref) {
  final journalEntry = ref.watch(journalEntryStateProvider);
  return journalEntry.canSubmit();
});

// Fetch accounts
final journalAccountsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(journalEntryRepositoryProvider);
  return await repository.getAccounts();
});

// Fetch counterparties (family provider for company-specific data)
final journalCounterpartiesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, companyId) async {
    if (companyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCounterparties(companyId);
  },
);

// Fetch counterparty stores
final journalCounterpartyStoresProvider = FutureProvider.family<List<Map<String, dynamic>>, String?>(
  (ref, linkedCompanyId) async {
    if (linkedCompanyId == null || linkedCompanyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCounterpartyStores(linkedCompanyId);
  },
);

// Fetch cash locations
final journalCashLocationsProvider = FutureProvider.family<List<Map<String, dynamic>>, ({String companyId, String? storeId})>(
  (ref, params) async {
    if (params.companyId.isEmpty) return [];
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getCashLocations(
      companyId: params.companyId,
      storeId: params.storeId,
    );
  },
);

// Check account mapping
final checkAccountMappingProvider = Provider<Future<Map<String, dynamic>?> Function(String, String, String)>(
  (ref) {
    return (String companyId, String counterpartyId, String accountId) async {
      final repository = ref.read(journalEntryRepositoryProvider);
      return await repository.checkAccountMapping(
        companyId: companyId,
        counterpartyId: counterpartyId,
        accountId: accountId,
      );
    };
  },
);

// Fetch exchange rates
final exchangeRatesProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, companyId) async {
    if (companyId.isEmpty) {
      throw Exception('Company ID is required');
    }
    final repository = ref.watch(journalEntryRepositoryProvider);
    return await repository.getExchangeRates(companyId);
  },
);

// Submit journal entry
final submitJournalEntryProvider = Provider<Future<void> Function(JournalEntry, String, String, String?)>(
  (ref) {
    return (JournalEntry journalEntry, String userId, String companyId, String? storeId) async {
      if (!journalEntry.canSubmit()) {
        throw Exception('Journal entry is not balanced or incomplete');
      }

      final repository = ref.read(journalEntryRepositoryProvider);
      await repository.submitJournalEntry(
        journalEntry: journalEntry,
        userId: userId,
        companyId: companyId,
        storeId: storeId,
      );
    };
  },
);

// Helper functions for updating journal entry state
extension JournalEntryStateExtension on StateController<JournalEntry> {
  void addTransactionLine(TransactionLine line) {
    state = state.addTransactionLine(line);
  }

  void removeTransactionLine(int index) {
    state = state.removeTransactionLine(index);
  }

  void updateTransactionLine(int index, TransactionLine line) {
    state = state.updateTransactionLine(index, line);
  }

  void setEntryDate(DateTime date) {
    state = state.copyWith(entryDate: date);
  }

  void setOverallDescription(String? description) {
    state = state.copyWith(overallDescription: description);
  }

  void setSelectedCompany(String? companyId) {
    state = state.copyWith(selectedCompanyId: companyId);
  }

  void setSelectedStore(String? storeId) {
    state = state.copyWith(selectedStoreId: storeId);
  }

  void setCounterpartyCashLocation(String? cashLocationId) {
    state = state.copyWith(counterpartyCashLocationId: cashLocationId);
  }

  void clear() {
    state = state.clear();
  }
}
