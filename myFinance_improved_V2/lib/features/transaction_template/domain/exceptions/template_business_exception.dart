import 'domain_exception.dart';

/// Exception thrown when template business logic rules are violated
/// 
/// Used for template-specific business logic errors such as:
/// - Invalid template configuration
/// - Template permission violations  
/// - Template policy conflicts
/// - Template creation/update failures
class TemplateBusinessException extends DomainException {
  const TemplateBusinessException(
    super.message, {
    super.errorCode,
    super.context,
    super.innerException,
  });

  /// Creates exception for template not found scenarios
  factory TemplateBusinessException.notFound({
    required String templateId,
  }) {
    return TemplateBusinessException(
      'Template not found',
      errorCode: 'TEMPLATE_NOT_FOUND',
      context: {'templateId': templateId},
    );
  }

  /// Creates exception for template permission violations
  factory TemplateBusinessException.permissionDenied(String operation) {
    return TemplateBusinessException(
      'Permission denied for template operation',
      errorCode: 'TEMPLATE_PERMISSION_DENIED',
      context: {'operation': operation},
    );
  }

  /// Creates exception for duplicate template names
  factory TemplateBusinessException.duplicateName(String templateName) {
    return TemplateBusinessException(
      'Template name already exists',
      errorCode: 'TEMPLATE_DUPLICATE_NAME',
      context: {'templateName': templateName},
    );
  }

  /// Creates exception for template name already exists scenarios
  factory TemplateBusinessException.nameAlreadyExists({
    required String templateName,
    required String existingTemplateId,
    required String companyId,
  }) {
    return TemplateBusinessException(
      'Template name "$templateName" already exists in this company',
      errorCode: 'TEMPLATE_NAME_EXISTS',
      context: {
        'templateName': templateName,
        'existingTemplateId': existingTemplateId,
        'companyId': companyId,
      },
    );
  }

  /// Creates exception for insufficient permissions scenarios
  factory TemplateBusinessException.insufficientPermissions({
    required String operation,
    required String userId,
    required String templateId,
  }) {
    return TemplateBusinessException(
      'Insufficient permissions to $operation template',
      errorCode: 'TEMPLATE_INSUFFICIENT_PERMISSIONS',
      context: {
        'operation': operation,
        'userId': userId,
        'templateId': templateId,
      },
    );
  }

  /// Creates exception for template in use scenarios (cannot delete)
  factory TemplateBusinessException.templateInUse({
    required String templateId,
    required int activeTransactionCount,
    DateTime? lastUsedDate,
  }) {
    final contextData = {
      'templateId': templateId,
      'activeTransactionCount': activeTransactionCount,
    };
    
    if (lastUsedDate != null) {
      contextData['lastUsedDate'] = lastUsedDate.toIso8601String();
    }
    
    return TemplateBusinessException(
      'Cannot delete template because it is currently in use by $activeTransactionCount transaction(s)',
      errorCode: 'TEMPLATE_IN_USE',
      context: contextData,
    );
  }

  @override
  TemplateBusinessException copyWith({
    String? message,
    String? errorCode,
    Map<String, dynamic>? context,
    Exception? innerException,
  }) {
    return TemplateBusinessException(
      message ?? this.message,
      errorCode: errorCode ?? this.errorCode,
      context: context ?? this.context,
      innerException: innerException ?? this.innerException,
    );
  }
}