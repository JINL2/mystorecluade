import '../entities/template_entity.dart';
import '../enums/template_enums.dart';

/// Policy-based validator for transaction templates
/// 
/// Contains pure business rules for:
/// - User permissions validation
/// - Company template policies
/// - Template naming conventions
/// Note: Account access validation moved to UseCase
class TemplateValidator {
  // No external dependencies - pure functions only

  const TemplateValidator();

  /// Validates a template against policies (pure business rules only)
  ///
  /// ✅ ARCHITECTURE FIX: Permission checks removed from Domain Layer
  /// Permission validation is UI Layer responsibility (canCreateTemplatesProvider, etc.)
  /// Domain layer only validates business rules and data integrity
  TemplatePolicyValidationResult validate(
    TransactionTemplate template, {
    required String userId,
    // ✅ REMOVED: userPermissions parameter (moved to UI Layer)
    required TemplatePolicy templatePolicy,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // ✅ REMOVED: Permission validation (moved to UI Layer)
    // Permission checks now happen in:
    // - application/providers/state_providers.dart (canCreateTemplatesProvider, etc.)
    // - presentation/pages/transaction_template_page.dart (UI controls)

    // ✅ KEEP: Business rule validation
    // Check naming conventions
    final namingResult = _validateNamingConventions(template, templatePolicy);
    errors.addAll(namingResult.errors);
    warnings.addAll(namingResult.warnings);

    // Check template limits (pure rules)
    final limitResult = _validateTemplateLimits(template, templatePolicy);
    errors.addAll(limitResult.errors);
    warnings.addAll(limitResult.warnings);

    // Note: Account access, duplicates moved to UseCase

    return TemplatePolicyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      canBeShared: _canBeSharedBusinessRules(template),
      requiresApproval: _requiresApproval(template),
    );
  }

  // ❌ DELETED: _validatePermissions() method
  // Permission validation moved to UI Layer:
  // - canCreateTemplatesProvider
  // - canCreateManagerTemplatesProvider
  // - canCreatePublicTemplatesProvider
  // - canDeleteTemplatesProvider

  /// Validates template naming conventions
  ValidationResult _validateNamingConventions(
    TransactionTemplate template,
    TemplatePolicy templatePolicy,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    final name = template.name.trim();

    // Check naming patterns
    if (templatePolicy.enforceNamingConvention) {
      if (!_matchesNamingPattern(name, templatePolicy.namingPattern)) {
        errors.add('Template name does not follow company naming conventions');
      }
    }

    // Check for forbidden words
    for (final forbiddenWord in templatePolicy.forbiddenWords) {
      if (name.toLowerCase().contains(forbiddenWord.toLowerCase())) {
        errors.add('Template name contains forbidden word: $forbiddenWord');
      }
    }

    // Check for required prefixes
    if (templatePolicy.requireDepartmentPrefix &&
        !_hasDepartmentPrefix(name, templatePolicy.departmentPrefixes)) {
      warnings.add('Template name should include department prefix');
    }

    // Check for professionalism
    if (_containsUnprofessionalTerms(name)) {
      warnings.add('Template name should be more professional');
    }

    return ValidationResult(errors: errors, warnings: warnings);
  }

  // NOTE: Account access validation moved to UseCase
  // This keeps domain/validators as pure functions only

  /// Validates template limits and quotas (pure rules only)
  ValidationResult _validateTemplateLimits(
    TransactionTemplate template,
    TemplatePolicy templatePolicy,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // NOTE: User quota and company limits checks moved to UseCase
    // These require DB queries which violate pure function principle

    // Check for template complexity (pure rule)
    final complexity = template.analyzeComplexity();
    if (complexity == FormComplexity.complex) {
      warnings.add('Complex template may require additional approval');
    }

    return ValidationResult(errors: errors, warnings: warnings);
  }

  // NOTE: Duplicate template validation moved to UseCase
  // This requires DB queries which violate pure function principle

  /// Determines if template can be shared publicly (business rules only)
  ///
  /// ✅ ARCHITECTURE FIX: Permission checks removed
  /// This now only validates business rules, not user permissions
  /// Permission checks moved to UI Layer (canCreatePublicTemplatesProvider)
  bool _canBeSharedBusinessRules(TransactionTemplate template) {
    // ✅ BUSINESS RULE: Check if template contains sensitive information
    if (_containsSensitiveInformation(template)) {
      return false;
    }

    // ✅ BUSINESS RULE: Check if template structure is complete for sharing
    if (!_hasCompleteStructure(template)) {
      return false;
    }

    // ❌ REMOVED: Permission check (userPermissions.contains('create_public_template'))
    // This is now handled in UI Layer by canCreatePublicTemplatesProvider

    return true;
  }

  /// Checks if template has complete structure for sharing
  bool _hasCompleteStructure(TransactionTemplate template) {
    // Template must have name and description
    if (template.name.trim().isEmpty) {
      return false;
    }

    // Template must have valid data structure
    if (template.data.isEmpty) {
      return false;
    }

    return true;
  }

  /// Determines if template requires approval
  bool _requiresApproval(TransactionTemplate template) {
    // Manager-level templates require approval
    if (template.permission == 'manager') {
      return true;
    }

    // Public templates require approval
    if (template.visibilityLevel == 'public') {
      return true;
    }

    // Complex templates require approval
    if (template.analyzeComplexity() == FormComplexity.complex) {
      return true;
    }

    return false;
  }

  // Helper methods (pure business logic)
  bool _matchesNamingPattern(String name, String pattern) {
    // Check against company naming pattern
    return RegExp(pattern).hasMatch(name);
  }

  bool _hasDepartmentPrefix(String name, List<String> prefixes) {
    // Check if name starts with department code
    return prefixes.any((prefix) => 
        name.toLowerCase().startsWith(prefix.toLowerCase()));
  }

  bool _containsUnprofessionalTerms(String name) {
    final unprofessionalTerms = ['test', 'temp', 'xxx', 'dummy'];
    return unprofessionalTerms.any((term) => 
        name.toLowerCase().contains(term));
  }

  // NOTE: The following methods moved to UseCase:
  // - _exceedsUserTemplateQuota() -> requires DB query
  // - _exceedsCompanyTemplateLimit() -> requires DB query  
  // - _hasExactNameDuplicate() -> requires DB query
  // - _hasSimilarTemplate() -> requires DB query
  // - _hasIdenticalAccountPair() -> requires DB query
  // - _isHighRiskCombination() -> can be pure rule if needed

  bool _containsSensitiveInformation(TransactionTemplate template) {
    // Check if template contains sensitive data
    return false; // Simplified for example
  }
}

/// Result of template policy validation
class TemplatePolicyValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final bool canBeShared;
  final bool requiresApproval;

  const TemplatePolicyValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.canBeShared,
    required this.requiresApproval,
  });

  String? get firstError => errors.isEmpty ? null : errors.first;
  String? get firstWarning => warnings.isEmpty ? null : warnings.first;
  
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
}

/// Helper validation result class
class ValidationResult {
  final List<String> errors;
  final List<String> warnings;

  const ValidationResult({
    this.errors = const [],
    this.warnings = const [],
  });
}

/// Template policy configuration
class TemplatePolicy {
  final bool enforceNamingConvention;
  final String namingPattern;
  final List<String> forbiddenWords;
  final bool requireDepartmentPrefix;
  final List<String> departmentPrefixes;
  final int maxTemplatesPerUser;
  final int maxCompanyTemplates;

  const TemplatePolicy({
    required this.enforceNamingConvention,
    required this.namingPattern,
    required this.forbiddenWords,
    required this.requireDepartmentPrefix,
    required this.departmentPrefixes,
    required this.maxTemplatesPerUser,
    required this.maxCompanyTemplates,
  });
}

// NOTE: AccountAccessService moved to domain/services/ 
// This will be used by UseCase layer, not validators