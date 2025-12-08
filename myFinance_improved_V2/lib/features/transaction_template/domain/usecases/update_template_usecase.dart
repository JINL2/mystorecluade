/// Update Template Use Case - Domain Layer
///
/// Purpose: Handles template update business logic
/// - Validates update command
/// - Updates template in repository
/// - Returns result with success/failure status
///
/// Clean Architecture: DOMAIN LAYER - Use Cases
library;

import '../exceptions/template_business_exception.dart';
import '../repositories/template_repository.dart';

/// Command for updating a template
class UpdateTemplateCommand {
  final String templateId;
  final String? name;
  final String? templateDescription;
  final bool? requiredAttachment;
  final String? visibilityLevel;
  final String? permission; // Admin/General permission UUID
  final List<Map<String, dynamic>>? data; // Updated entry data
  final String updatedBy;

  const UpdateTemplateCommand({
    required this.templateId,
    this.name,
    this.templateDescription,
    this.requiredAttachment,
    this.visibilityLevel,
    this.permission,
    this.data,
    required this.updatedBy,
  });

  /// Check if any field is being updated
  bool get hasUpdates =>
      name != null ||
      templateDescription != null ||
      requiredAttachment != null ||
      visibilityLevel != null ||
      permission != null ||
      data != null;
}

/// Result of template update
class UpdateTemplateResult {
  final bool isSuccess;
  final String? templateId;
  final String? error;

  const UpdateTemplateResult._({
    required this.isSuccess,
    this.templateId,
    this.error,
  });

  factory UpdateTemplateResult.success({required String templateId}) {
    return UpdateTemplateResult._(
      isSuccess: true,
      templateId: templateId,
    );
  }

  factory UpdateTemplateResult.failure({required String error}) {
    return UpdateTemplateResult._(
      isSuccess: false,
      error: error,
    );
  }
}

/// Use case for updating a transaction template
class UpdateTemplateUseCase {
  final TemplateRepository _templateRepository;

  const UpdateTemplateUseCase({
    required TemplateRepository templateRepository,
  }) : _templateRepository = templateRepository;

  /// Executes the template update use case
  Future<UpdateTemplateResult> execute(UpdateTemplateCommand command) async {
    try {
      // 1. Validate command has updates
      if (!command.hasUpdates) {
        return UpdateTemplateResult.failure(
          error: 'No fields to update',
        );
      }

      // 2. Find existing template
      final template = await _templateRepository.findById(command.templateId);
      if (template == null) {
        throw TemplateBusinessException.notFound(
          templateId: command.templateId,
        );
      }

      // 3. Validate name if provided
      if (command.name != null && command.name!.trim().isEmpty) {
        return UpdateTemplateResult.failure(
          error: 'Template name cannot be empty',
        );
      }

      // 4. Build updated template
      final updatedTemplate = template.copyWith(
        name: command.name ?? template.name,
        templateDescription: command.templateDescription ?? template.templateDescription,
        requiredAttachment: command.requiredAttachment ?? template.requiredAttachment,
        visibilityLevel: command.visibilityLevel ?? template.visibilityLevel,
        permission: command.permission ?? template.permission,
        data: command.data ?? template.data,
        updatedBy: command.updatedBy,
        updatedAt: DateTime.now(),
      );

      // 5. Save updated template
      await _templateRepository.save(updatedTemplate);

      // 6. Return success
      return UpdateTemplateResult.success(
        templateId: command.templateId,
      );
    } on TemplateBusinessException catch (e) {
      return UpdateTemplateResult.failure(error: e.message);
    } catch (e) {
      return UpdateTemplateResult.failure(
        error: 'Failed to update template: ${e.toString()}',
      );
    }
  }
}
