import '../../domain/entities/template_entity.dart';
import '../dtos/template_dto.dart';

/// Template Mapper - Bidirectional conversion between DTO and Domain
///
/// Handles type-safe conversion with proper null handling and DateTime conversion
/// Maintains consistency with TemplateDataSource conversion logic
///
/// Clean Architecture: DATA LAYER - Mapper (separate from DTOs)
/// Purpose: Transforms data between DTO and Domain Entity
/// - DTO: Data structure for external communication (Supabase)
/// - Entity: Domain model for business logic

extension TemplateDtoToDomain on TemplateDto {
  /// Converts TemplateDto to TransactionTemplate domain entity
  TransactionTemplate toDomain() {
    return TransactionTemplate(
      templateId: templateId,
      name: name,
      templateDescription: templateDescription,
      data: data,
      tags: tags,
      visibilityLevel: visibilityLevel,
      permission: permission,
      companyId: companyId,

      /// 🔄 Handle null storeId from DB: null → empty string
      storeId: storeId ?? '',

      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      createdBy: createdBy,

      /// 📅 Convert ISO string to DateTime
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),

      updatedBy: updatedBy,
      isActive: isActive,
    );
  }
}

extension TransactionTemplateToDDto on TransactionTemplate {
  /// Converts TransactionTemplate domain entity to TemplateDto
  TemplateDto toDto() {
    return TemplateDto(
      templateId: templateId,
      name: name,
      templateDescription: templateDescription,
      data: data,
      tags: tags,
      visibilityLevel: visibilityLevel,
      permission: permission,
      companyId: companyId,

      /// 🔄 Handle empty storeId to DB: empty string → null
      /// Matches TemplateDataSource logic: storeId.isNotEmpty ? storeId : null
      storeId: storeId.isNotEmpty ? storeId : null,

      counterpartyId: counterpartyId,
      counterpartyCashLocationId: counterpartyCashLocationId,
      createdBy: createdBy,

      /// 📅 Convert DateTime to ISO string
      createdAt: createdAt.toIso8601String(),
      updatedAt: updatedAt.toIso8601String(),

      updatedBy: updatedBy,
      isActive: isActive,
    );
  }
}
