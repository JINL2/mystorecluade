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
import 'package:image_picker/image_picker.dart';

import '../../data/providers/repository_providers.dart'; // ✅ Clean Architecture: Presentation → Data
import '../../domain/entities/template_attachment.dart';
import '../../domain/usecases/create_transaction_from_template_usecase.dart';
import '../../domain/usecases/update_template_usecase.dart';

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

// =============================================================================
// Attachment Providers
// =============================================================================

/// Upload attachments to an existing journal
final uploadTemplateAttachmentsProvider = Provider<Future<List<TemplateAttachment>> Function(String, String, String, List<XFile>)>(
  (ref) {
    return (String companyId, String journalId, String uploadedBy, List<XFile> files) async {
      final repository = ref.read(transactionRepositoryProvider);
      return await repository.uploadAttachments(
        companyId: companyId,
        journalId: journalId,
        uploadedBy: uploadedBy,
        files: files,
      );
    };
  },
);

/// Get journal attachments
final templateJournalAttachmentsProvider = FutureProvider.family<List<TemplateAttachment>, String>(
  (ref, journalId) async {
    if (journalId.isEmpty) return [];
    final repository = ref.watch(transactionRepositoryProvider);
    return await repository.getJournalAttachments(journalId);
  },
);

/// Delete an attachment
final deleteTemplateAttachmentProvider = Provider<Future<void> Function(String, String)>(
  (ref) {
    return (String attachmentId, String fileUrl) async {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteAttachment(
        attachmentId: attachmentId,
        fileUrl: fileUrl,
      );
    };
  },
);

// =============================================================================
// Template Update Provider
// =============================================================================

/// Provider for UpdateTemplateUseCase
///
/// **Dependency Flow**:
/// Presentation → Domain Use Case → Repository Interface ← Data Implementation
final updateTemplateUseCaseProvider = Provider<UpdateTemplateUseCase>((ref) {
  final templateRepository = ref.read(templateRepositoryProvider);
  return UpdateTemplateUseCase(
    templateRepository: templateRepository,
  );
});
