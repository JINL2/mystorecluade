/// Use Case Providers - Presentation Layer
///
/// Purpose: Provides dependency injection for domain use cases
/// This file connects Presentation layer to Domain layer via Data layer implementations
///
/// Clean Architecture: PRESENTATION LAYER
/// - ✅ Can depend on Domain Layer (Use Cases)
/// - ✅ Can depend on Data Layer (Repository implementations)
/// - ✅ Provides dependency injection
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/repository_providers.dart'; // ✅ Clean Architecture: Presentation → Data
import '../../domain/usecases/create_transaction_from_template_usecase.dart';

/// Provider for CreateTransactionFromTemplateUseCase
///
/// **Dependency Flow**:
/// Presentation → Domain Use Case → Repository Interface ← Data Implementation
final createTransactionFromTemplateUseCaseProvider = Provider<CreateTransactionFromTemplateUseCase>((ref) {
  // Get repository implementation from Data layer
  final transactionRepository = ref.read(transactionRepositoryProvider);

  // Inject repository into Use Case
  return CreateTransactionFromTemplateUseCase(
    transactionRepository: transactionRepository,
  );
});
