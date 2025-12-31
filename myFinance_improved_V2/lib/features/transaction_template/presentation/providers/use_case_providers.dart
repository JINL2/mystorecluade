/// Use Case Providers - Presentation Layer
///
/// Purpose: Provides dependency injection for domain use cases
/// This file connects Presentation layer to Domain layer via Data layer implementations
///
/// Clean Architecture: PRESENTATION LAYER
/// - ✅ Can depend on Domain Layer (Use Cases)
/// - ✅ Can depend on Data Layer (Repository implementations)
/// - ✅ Provides dependency injection
///
/// Note: Transaction creation from template is handled by TemplateRpcService
///       via templateRpcServiceProvider in repository_providers.dart
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/providers/repository_providers.dart'; // ✅ Clean Architecture: Presentation → Data
import '../../domain/entities/template_attachment.dart';
import '../../domain/usecases/update_template_usecase.dart';

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
