import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/validators/template_validator.dart';
import '../../domain/validators/transaction_validator.dart';
import '../../domain/entities/template_entity.dart';

/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/// 🎯 Validator Providers
/// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Template Validator Provider
final templateValidatorProvider = Provider<TemplateValidator>((ref) {
  return _MockTemplateValidator();
});

/// Transaction Validator Provider
final transactionValidatorProvider = Provider<TransactionValidator>((ref) {
  return const TransactionValidator();
});

/// Mock Template Validator - Provides basic validation for development
///
/// ✅ ARCHITECTURE FIX: Updated to match new validator signature
/// Permission checks removed - they now happen in UI Layer
class _MockTemplateValidator implements TemplateValidator {
  @override
  TemplatePolicyValidationResult validate(
    TransactionTemplate template, {
    required String userId,
    required TemplatePolicy templatePolicy,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // ✅ BUSINESS RULE: Basic validation only
    if (template.name.trim().isEmpty) {
      errors.add('Template name cannot be empty');
    }

    if (template.name.length > 100) {
      errors.add('Template name cannot exceed 100 characters');
    }

    if (template.templateDescription != null && template.templateDescription!.length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }

    return TemplatePolicyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      canBeShared: _canBeSharedBusinessRules(template),
      requiresApproval: template.permission == 'manager' || template.visibilityLevel == 'public',
    );
  }

  /// Business rule: Check if template can be shared
  bool _canBeSharedBusinessRules(TransactionTemplate template) {
    if (template.name.trim().isEmpty || template.data.isEmpty) {
      return false;
    }
    return true;
  }
}
