// Domain Layer - Repository Providers
// Pure interface providers with no implementation details
// Implementation will be provided by the Data layer

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/journal_entry_repository.dart';

/// Journal Entry Repository Provider (Interface)
///
/// This is a pure domain-layer provider that defines the contract.
/// The actual implementation is provided by the data layer.
///
/// Usage in Presentation Layer:
/// ```dart
/// final repository = ref.watch(journalEntryRepositoryProvider);
/// await repository.getAccounts();
/// ```
final journalEntryRepositoryProvider = Provider<JournalEntryRepository>((ref) {
  throw UnimplementedError(
    'JournalEntryRepository implementation must be provided by the data layer. '
    'Make sure to override this provider with the actual implementation.',
  );
});
