import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';
import '../validators/template_validator.dart';
import '../exceptions/template_business_exception.dart';
import '../exceptions/validation_exception.dart';
import '../exceptions/validation_error.dart';
import '../enums/template_enums.dart';
import '../value_objects/template_creation_data.dart';

/// Use case for creating a new transaction template
/// 
/// Orchestrates the template creation process including validation,
/// business rule checking, and persistence.
class CreateTemplateUseCase {
  final TemplateRepository _templateRepository;
  final TemplateValidator _templateValidator;

  const CreateTemplateUseCase({
    required TemplateRepository templateRepository,
    required TemplateValidator templateValidator,
  })  : _templateRepository = templateRepository,
        _templateValidator = templateValidator;

  /// Executes the template creation use case
  Future<CreateTemplateResult> execute(CreateTemplateCommand command) async {
    try {
      // 1. Check if template name already exists
      await _checkNameUniqueness(command);

      // 2. Create template entity from command
      final template = _createTemplateFromCommand(command);

      // 3. Validate entity internal consistency
      final entityValidation = template.validate();
      if (!entityValidation.isValid) {
        throw ValidationException.multipleFields(
          errors: entityValidation.errors.map((error) =>
            ValidationError(
              fieldName: 'template',
              fieldValue: '',
              validationRule: 'entity_validation',
              message: error,
            )
          ).toList(),
        );
      }

      // 🚨 ENHANCED: Additional template data JSONB validation according to DB requirements
      final dataValidationErrors = _validateTemplateDataStructure(template);
      if (dataValidationErrors.isNotEmpty) {
        throw ValidationException.multipleFields(
          errors: dataValidationErrors.map((error) =>
            ValidationError(
              fieldName: 'template_data',
              fieldValue: '',
              validationRule: 'data_structure_validation',
              message: error,
            )
          ).toList(),
        );
      }

      // 4. Validate against external policies (pure business rules)
      // ✅ ARCHITECTURE FIX: Permission checks removed from Domain Layer
      // Permission validation is UI Layer responsibility (canCreateTemplatesProvider)
      final templatePolicy = TemplatePolicy(
        enforceNamingConvention: true,
        namingPattern: r'^[A-Z][a-zA-Z0-9_]*$',
        forbiddenWords: ['test', 'temp', 'dummy'],
        requireDepartmentPrefix: false,
        departmentPrefixes: [],
        maxTemplatesPerUser: 50,
        maxCompanyTemplates: 1000,
      );

      final policyValidation = _templateValidator.validate(
        template,
        userId: command.createdBy ?? 'unknown',  // ✅ Use fallback for null createdBy
        // ✅ REMOVED: userPermissions parameter
        // Permission checks now happen in UI Layer before this UseCase is called
        templatePolicy: templatePolicy,
      );

      if (!policyValidation.isValid) {
        throw ValidationException.businessRule(
          ruleName: 'template_policy',
          ruleDescription: policyValidation.firstError ?? 'Policy validation failed',
          ruleContext: {
            'errors': policyValidation.errors,
            'warnings': policyValidation.warnings,
            'canBeShared': policyValidation.canBeShared,
          },
        );
      }

      // 4a. Additional validations that require external dependencies
      await _validateAccountAccess(command);

      await _validateTemplateQuotas(command);

      // 5. Validate template for QuickTransaction compatibility
      final quickValidation = _validateTemplateForQuickTransaction(template);
      if (quickValidation.hasWarnings && !command.allowWarnings) {
        throw ValidationException.businessRule(
          ruleName: 'quick_transaction_compatibility',
          ruleDescription: 'Template has complexity warnings for QuickTransaction',
          ruleContext: {
            'warnings': quickValidation.warnings,
            'hasComplexDebt': quickValidation.hasComplexDebt,
          },
        );
      }

      // 6. Check for similar templates
      await _checkForSimilarTemplates(template);

      // 6. Handle approval requirements
      final finalTemplate = _handleApprovalRequirements(
        template,
        policyValidation,
      );

      // 7. Create optimistic template for immediate UI update
      final optimisticTemplate = _buildOptimisticTemplate(
        templateData: command,
        finalTemplate: finalTemplate,
        policyValidation: policyValidation,
      );

      // 8. Save the template
      await _templateRepository.save(finalTemplate);

      // 9. Return success result with optimistic template
      return CreateTemplateResult.success(
        optimisticTemplate: optimisticTemplate,
        requiresApproval: policyValidation.requiresApproval,
        canBeShared: policyValidation.canBeShared,
        warnings: policyValidation.warnings,
      );

    } on ValidationException {
      rethrow;
    } on TemplateBusinessException {
      rethrow;
    } catch (e) {
      throw TemplateBusinessException(
        'Failed to create template: ${e.toString()}',
        errorCode: 'TEMPLATE_CREATION_FAILED',
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Checks if template name is unique within the company
  Future<void> _checkNameUniqueness(CreateTemplateCommand command) async {
    final nameExists = await _templateRepository.nameExists(
      command.name,
      command.companyId,
    );

    if (nameExists) {
      final existingTemplate = await _templateRepository.findByName(
        command.name,
        command.companyId,
      );
      
      throw TemplateBusinessException.nameAlreadyExists(
        templateName: command.name,
        existingTemplateId: existingTemplate?.id ?? 'unknown',
        companyId: command.companyId,
      );
    }
  }

  /// Creates template entity from command (DOMAIN-SIMPLIFIED)
  TransactionTemplate _createTemplateFromCommand(CreateTemplateCommand command) {
    return TransactionTemplate.create(
      name: command.name,
      templateDescription: command.templateDescription,
      data: command.data,  // Already validated Domain structure
      tags: command.tags,
      visibilityLevel: command.visibilityLevel,
      permission: command.permission,
      companyId: command.companyId,
      storeId: command.storeId,
      counterpartyId: command.counterpartyId,
      counterpartyCashLocationId: command.counterpartyCashLocationId,
      createdBy: command.createdBy,
    );
  }

  // 🗑️ REMOVED: _buildDataArrayFromCommand()
  // Domain Rule: UI Layer converts UI fields → Domain data structure
  // UseCase receives already validated data array from Domain objects

  /// Checks for similar templates and warns if found
  Future<void> _checkForSimilarTemplates(TransactionTemplate template) async {
    final similarTemplates = await _templateRepository.findSimilar(
      templateName: template.name,
      companyId: template.companyId,
      similarityThreshold: 0.8,
      limit: 3,
    );

    if (similarTemplates.isNotEmpty) {
      // For now, we just log this - in the future this could be a warning
      // or require user confirmation
    }
  }

  /// Handles approval requirements based on policy validation
  TransactionTemplate _handleApprovalRequirements(
    TransactionTemplate template,
    TemplatePolicyValidationResult policyValidation,
  ) {
    if (!policyValidation.requiresApproval) {
      return template;
    }

    // Template requires approval - mark appropriately
    // In a real system, this might involve setting a status field
    return template;
  }

  /// Validates template for QuickTransaction compatibility
  QuickBuilderValidation _validateTemplateForQuickTransaction(TransactionTemplate template) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Check for complex debt requirements (from original logic)
    bool hasComplexDebt = false;
    final data = template.data;
    
    for (var line in data) {
      final categoryTag = line['category_tag'] as String? ?? '';
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        // Check if this requires complex debt configuration
        final hasInterest = line['interest_rate'] != null && (line['interest_rate'] as num? ?? 0) > 0;
        final hasSpecificDates = line['due_date'] != null || line['issue_date'] != null;
        if (hasInterest || hasSpecificDates) {
          hasComplexDebt = true;
          warnings.add('Template contains complex debt configuration that will be simplified');
        }
      }
    }
    
    return QuickBuilderValidation(
      canProcess: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      hasComplexDebt: hasComplexDebt,
    );
  }

  /// Builds optimistic template for immediate UI update (from original)
  Map<String, dynamic> _buildOptimisticTemplate({
    required CreateTemplateCommand templateData,
    required TransactionTemplate finalTemplate,
    required TemplatePolicyValidationResult policyValidation,
  }) {
    return {
      'template_id': finalTemplate.templateId,
      'name': finalTemplate.name,
      'template_description': finalTemplate.templateDescription,
      'data': finalTemplate.data,
      'permission': finalTemplate.permission,
      'tags': finalTemplate.tags,
      'visibility_level': finalTemplate.visibilityLevel,
      'is_active': finalTemplate.isActive,
      'company_id': finalTemplate.companyId,
      'store_id': finalTemplate.storeId,
      'counterparty_id': templateData.counterpartyId,
      'counterparty_cash_location_id': finalTemplate.counterpartyCashLocationId,
      'created_at': finalTemplate.createdAt.toIso8601String(),
      'updated_at': finalTemplate.updatedAt.toIso8601String(),
      'updated_by': finalTemplate.updatedBy,
      'requires_approval': policyValidation.requiresApproval,
      'can_be_shared': policyValidation.canBeShared,
    };
  }

  /// 🚨 ENHANCED: Validates template data JSONB structure according to DB requirements
  /// 
  /// This method validates the actual data JSONB structure that will be stored in the database
  /// and used by insert_journal_with_everything RPC function
  List<String> _validateTemplateDataStructure(TransactionTemplate template) {
    final errors = <String>[];

    // 1. Basic data array validation
    if (template.data.isEmpty) {
      errors.add('📊 Template must have at least one journal line in data array');
      return errors;
    }

    double totalDebit = 0;
    double totalCredit = 0;
    int debitLineCount = 0;
    int creditLineCount = 0;

    // 2. Validate each journal line
    for (int i = 0; i < template.data.length; i++) {
      final line = template.data[i];
      final lineNum = i + 1;

      // Required fields validation
      if (line['account_id'] == null || line['account_id'].toString().trim().isEmpty) {
        errors.add('📋 Line $lineNum: account_id is required');
        continue;
      }

      // Debit/Credit validation
      final debitStr = line['debit']?.toString() ?? '0';
      final creditStr = line['credit']?.toString() ?? '0';
      
      final debit = double.tryParse(debitStr) ?? 0;
      final credit = double.tryParse(creditStr) ?? 0;

      if (debit < 0 || credit < 0) {
        errors.add('💰 Line $lineNum: debit and credit amounts cannot be negative');
      }

      if (debit > 0 && credit > 0) {
        errors.add('⚖️ Line $lineNum: a line cannot have both debit and credit amounts (one should be "0")');
      }

      // ✅ REMOVED: Template validation for debit/credit = 0
      // Templates can have all "0" amounts - actual amounts filled in when template is used
      // Validation removed: if (debit == 0 && credit == 0) { ... }

      totalDebit += debit;
      totalCredit += credit;
      if (debit > 0) debitLineCount++;
      if (credit > 0) creditLineCount++;

      // Account-specific object validation
      final accountId = line['account_id'].toString();
      final accountType = _getAccountType(accountId);

      // 3. Cash object validation
      if (accountType == AccountType.cash || accountType == AccountType.bank) {
        if (line['cash'] == null) {
          errors.add('💰 Line $lineNum: ${accountType.displayName} account requires cash object with cash_location_id');
        } else {
          final cashObj = line['cash'];
          if (cashObj is Map) {
            if (cashObj['cash_location_id'] == null || cashObj['cash_location_id'].toString().trim().isEmpty) {
              errors.add('💰 Line $lineNum: cash object requires cash_location_id');
            }
          } else {
            errors.add('💰 Line $lineNum: cash must be an object with cash_location_id');
          }
        }
      }

      // 4. Debt object validation
      if (accountType == AccountType.receivable || accountType == AccountType.payable) {
        if (line['debt'] == null) {
          errors.add('👥 Line $lineNum: ${accountType.displayName} account requires debt object with counterparty information');
        } else {
          final debtObj = line['debt'];
          if (debtObj is Map) {
            if (debtObj['counterparty_id'] == null || debtObj['counterparty_id'].toString().trim().isEmpty) {
              errors.add('👥 Line $lineNum: debt object requires counterparty_id');
            }
            if (debtObj['direction'] == null || debtObj['direction'].toString().trim().isEmpty) {
              errors.add('👥 Line $lineNum: debt object requires direction (receivable/payable)');
            } else {
              final direction = debtObj['direction'].toString();
              if (direction != 'receivable' && direction != 'payable') {
                errors.add('👥 Line $lineNum: debt direction must be "receivable" or "payable"');
              }
            }
            if (debtObj['category'] == null || debtObj['category'].toString().trim().isEmpty) {
              errors.add('👥 Line $lineNum: debt object requires category (sales/purchase/etc)');
            }

            // 🚨 ENHANCED: Internal transaction validation (mirror entry requirements)
            if (debtObj['linkedCounterparty_companyId'] != null &&
                debtObj['linkedCounterparty_companyId'].toString().trim().isNotEmpty) {

              // Internal transaction requires store ID
              if (debtObj['linkedCounterparty_store_id'] == null ||
                  debtObj['linkedCounterparty_store_id'].toString().trim().isEmpty) {
                errors.add('🔗 Line $lineNum: internal debt transaction requires linkedCounterparty_store_id for mirror entry');
              }

              // ✅ REMOVED: Company ID validation - Same company internal transactions allowed
              // Scenario: Store-to-store transfers within same company
              // linkedCounterparty_companyId CAN be same as template company_id

              // ✅ REMOVED: Category validation per user request
              // Categories are not restricted for internal transactions
            }
          } else {
            errors.add('👥 Line $lineNum: debt must be an object with counterparty_id, direction, and category');
          }
        }
      }

      // 5. Fixed asset object validation
      if (accountType == AccountType.asset && line['fix_asset'] != null) {
        final assetObj = line['fix_asset'];
        if (assetObj is Map) {
          if (assetObj['asset_name'] == null || assetObj['asset_name'].toString().trim().isEmpty) {
            errors.add('🏢 Line $lineNum: fix_asset object requires asset_name');
          }
          if (assetObj['acquisition_date'] == null || assetObj['acquisition_date'].toString().trim().isEmpty) {
            errors.add('🏢 Line $lineNum: fix_asset object requires acquisition_date');
          }
          if (assetObj['useful_life_years'] == null || assetObj['useful_life_years'].toString().trim().isEmpty) {
            errors.add('🏢 Line $lineNum: fix_asset object requires useful_life_years');
          }
        }
      }
    }

    // 6. Balance validation (critical for double-entry bookkeeping)
    // For templates with actual amounts (not all "0")
    if (totalDebit > 0 || totalCredit > 0) {
      if (totalDebit != totalCredit) {
        errors.add('⚖️ CRITICAL: Debit total (${totalDebit.toStringAsFixed(0)}) must equal credit total (${totalCredit.toStringAsFixed(0)})');
      }

      // 7. Structure validation - only for templates with amounts
      if (debitLineCount == 0) {
        errors.add('📊 Template must have at least one debit line');
      }
      if (creditLineCount == 0) {
        errors.add('📊 Template must have at least one credit line');
      }
    } else {
      // ✅ FIX: For templates with all "0" amounts, just check that we have at least 2 lines
      if (template.data.length < 2) {
        errors.add('📊 Template must have at least 2 lines (one for debit, one for credit)');
      }
    }

    return errors;
  }

  /// Helper method to determine account type from account ID (same logic as Template Entity)
  AccountType _getAccountType(String accountId) {
    final accountLower = accountId.toLowerCase();
    
    if (accountLower.contains('cash')) return AccountType.cash;
    if (accountLower.contains('payable')) return AccountType.payable;
    if (accountLower.contains('receivable')) return AccountType.receivable;
    if (accountLower.contains('bank')) return AccountType.bank;
    if (accountLower.contains('revenue')) return AccountType.revenue;
    if (accountLower.contains('expense')) return AccountType.expense;
    if (accountLower.contains('asset')) return AccountType.asset;
    if (accountLower.contains('liability')) return AccountType.liability;
    
    return AccountType.other;
  }

  /// Validates account access (moved from TemplateValidator)
  Future<void> _validateAccountAccess(CreateTemplateCommand command) async {
    final errors = <String>[];

    // Account access validation based on data array (Domain approach)
    for (final line in command.data) {
      final accountId = line['account_id']?.toString();
      if (accountId != null) {
        // TODO: Add actual account access service call
        // For now, we assume access is valid for all accounts in template data
      }
    }

    if (errors.isNotEmpty) {
      throw ValidationException.multipleFields(
        errors: errors.map((error) => 
          ValidationError(
            fieldName: 'account_access',
            fieldValue: '',
            validationRule: 'account_access_validation',
            message: error,
          )
        ).toList(),
      );
    }
  }

  /// Validates template quotas (moved from TemplateValidator)
  Future<void> _validateTemplateQuotas(CreateTemplateCommand command) async {
    final errors = <String>[];

    // Check user template quota - skip if createdBy is null
    if (command.createdBy != null) {
      final userTemplateCount = await _templateRepository.countUserTemplates(command.createdBy!);
      if (userTemplateCount >= 50) { // TODO: Get from policy
        errors.add('User has exceeded maximum number of templates allowed');
      }
    }

    // Check for similar templates
    final similarTemplates = await _templateRepository.findSimilar(
      templateName: command.name,
      companyId: command.companyId,
      similarityThreshold: 0.8,
      limit: 1,
    );
    
    if (similarTemplates.isNotEmpty) {
      errors.add('Similar template already exists - consider reusing existing template');
    }

    if (errors.isNotEmpty) {
      throw ValidationException.multipleFields(
        errors: errors.map((error) => 
          ValidationError(
            fieldName: 'template_quotas',
            fieldValue: '',
            validationRule: 'quota_validation',
            message: error,
          )
        ).toList(),
      );
    }
  }
}

/// Quick builder validation result (from original)
class QuickBuilderValidation {
  final bool canProcess;
  final List<String> errors;
  final List<String> warnings;
  final bool hasComplexDebt;

  const QuickBuilderValidation({
    required this.canProcess,
    required this.errors,
    required this.warnings,
    required this.hasComplexDebt,
  });

  bool get hasWarnings => warnings.isNotEmpty;
}

/// Command for creating a template (DOMAIN-BASED, SIMPLIFIED)
/// 
/// Clean Architecture Rule: Commands should only contain Domain concepts
/// UI-specific fields are converted to Domain structure before reaching UseCase
class CreateTemplateCommand {
  final String name;
  final String? templateDescription;
  final List<Map<String, dynamic>> data;  // Complete transaction lines
  final Map<String, dynamic> tags;
  final String visibilityLevel;
  final String permission;
  final String? counterpartyId;
  final String? counterpartyCashLocationId;
  final String companyId;
  final String storeId;
  final String? createdBy;  // ✅ Optional: DB may not have this field
  final bool allowWarnings;                      // For QuickTransaction compatibility

  const CreateTemplateCommand({
    required this.name,
    this.templateDescription,
    required this.data,
    this.tags = const {},
    required this.visibilityLevel,
    required this.permission,
    this.counterpartyId,
    this.counterpartyCashLocationId,
    required this.companyId,
    required this.storeId,
    this.createdBy,  // ✅ Optional
    this.allowWarnings = false,
  });
  
  /// Create from Domain TemplateCreationData (SIMPLIFIED)
  /// 
  /// Domain Rule: UseCase accepts only validated Domain objects
  /// UI Layer handles conversion from UI fields → Domain data structure
  factory CreateTemplateCommand.fromTemplateCreationData(
    TemplateCreationData data,
    String companyId,
    String storeId,
    String createdBy,
  ) {
    return CreateTemplateCommand(
      name: data.name,
      templateDescription: data.templateDescription,  // Fixed field name
      data: data.data,  // Already structured JSON array
      tags: data.tags,
      visibilityLevel: data.visibilityLevel,
      permission: data.permission,
      counterpartyId: data.counterpartyId,
      counterpartyCashLocationId: data.counterpartyCashLocationId,
      companyId: companyId,
      storeId: storeId,
      createdBy: createdBy,
    );
  }
}

/// Result of template creation (matching original TemplateCreationResult)
class CreateTemplateResult {
  final bool isSuccess;
  final Map<String, dynamic>? optimisticTemplate;  // Original expects Map
  final bool requiresApproval;
  final bool canBeShared;
  final List<String> warnings;
  final String? error;                             // Original field name

  const CreateTemplateResult._({
    required this.isSuccess,
    this.optimisticTemplate,
    this.requiresApproval = false,
    this.canBeShared = true,
    this.warnings = const [],
    this.error,
  });

  /// Getter for compatibility
  String? get errorMessage => error;

  /// Factory constructor for success result
  factory CreateTemplateResult.success({
    required Map<String, dynamic> optimisticTemplate,
    bool requiresApproval = false,
    bool canBeShared = true,
    List<String> warnings = const [],
  }) {
    return CreateTemplateResult._(
      isSuccess: true,
      optimisticTemplate: optimisticTemplate,
      requiresApproval: requiresApproval,
      canBeShared: canBeShared,
      warnings: warnings,
    );
  }

  /// Factory constructor for failure result
  factory CreateTemplateResult.failure({
    required String errorMessage,
  }) {
    return CreateTemplateResult._(
      isSuccess: false,
      error: errorMessage,
    );
  }
}