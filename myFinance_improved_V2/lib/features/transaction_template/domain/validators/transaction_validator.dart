import '../entities/transaction_entity.dart';

/// External policy-based validator for transactions
///
/// ✅ ARCHITECTURE: Domain Layer - Pure Business Rules Only
///
/// Handles validation for:
/// - Company policies (business hours, transaction types, descriptions)
/// - Approval limits (amount thresholds, self-approval constraints)
/// - Business hours restrictions
/// - Transaction complexity
///
/// ❌ DOES NOT CONTAIN:
/// - User permission checks (moved to UI Layer)
/// - Account access validation (moved to UseCase)
/// - Database queries (moved to UseCase)
///
/// Permission checks now handled by:
/// - application/providers/state_providers.dart
/// - presentation/pages (UI controls)
class TransactionValidator {
  // No external dependencies - pure functions only

  const TransactionValidator();

  /// Validates a transaction against policies (pure business rules only)
  ///
  /// ✅ ARCHITECTURE FIX: Permission checks removed from Domain Layer
  /// Permission validation is UI Layer responsibility (canCreateTransactionsProvider, etc.)
  /// Domain layer only validates business rules and data integrity
  TransactionPolicyValidationResult validate(
    Transaction transaction, {
    required String userId,
    // ✅ REMOVED: userPermissions parameter (moved to UI Layer)
    required CompanyPolicy companyPolicy,
    required ApprovalLimits approvalLimits,
  }) {
    final errors = <String>[];
    final warnings = <String>[];

    // ✅ REMOVED: Permission validation (moved to UI Layer)
    // Permission checks now happen in:
    // - application/providers/state_providers.dart (canCreateTransactionsProvider, etc.)
    // - presentation/pages (UI controls)

    // ✅ KEEP: Business rule validation
    // Check approval limits
    final limitResult = _validateApprovalLimits(transaction, approvalLimits);
    errors.addAll(limitResult.errors);
    warnings.addAll(limitResult.warnings);

    // Check company policies
    final policyResult = _validateCompanyPolicies(transaction, companyPolicy);
    errors.addAll(policyResult.errors);
    warnings.addAll(policyResult.warnings);

    // Check business hours
    final hoursResult = _validateBusinessHours(transaction, companyPolicy);
    errors.addAll(hoursResult.errors);
    warnings.addAll(hoursResult.warnings);

    // Check self-approval limits (business rule, not permission)
    final selfApprovalResult = _validateSelfApprovalLimits(transaction, userId, approvalLimits);
    warnings.addAll(selfApprovalResult.warnings);

    // NOTE: Duplicate detection moved to UseCase (requires DB query)

    return TransactionPolicyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      requiresApproval: _requiresApproval(transaction, approvalLimits, companyPolicy),
      approvalLevel: _getRequiredApprovalLevel(transaction, approvalLimits),
    );
  }

  // ❌ DELETED: _validatePermissions() method
  // Permission validation moved to UI Layer:
  // - canCreateTransactionsProvider
  // - canCreateHighValueTransactionsProvider
  //
  // ✅ BUSINESS RULE: Self-approval limits (kept as business logic)

  /// Validates self-approval limits (business rule, not permission check)
  ///
  /// This is a business rule: "users cannot approve their own high-value transactions"
  /// It's different from permission checks which are: "does user have permission X?"
  ValidationResult _validateSelfApprovalLimits(
    Transaction transaction,
    String userId,
    ApprovalLimits approvalLimits,
  ) {
    final warnings = <String>[];

    // ✅ BUSINESS RULE: Check if user is trying to self-approve beyond their limit
    // This is NOT a permission check - it's a business constraint
    if (transaction.createdBy == userId &&
        transaction.amount.value > approvalLimits.selfApprovalLimit) {
      warnings.add('Transaction exceeds self-approval limit and will require additional approval');
    }

    return ValidationResult(errors: const [], warnings: warnings);
  }

  /// Validates against approval limits
  ValidationResult _validateApprovalLimits(
    Transaction transaction,
    ApprovalLimits approvalLimits,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check if amount exceeds company's maximum transaction limit
    if (transaction.amount.value > approvalLimits.companyMaximum) {
      errors.add('Transaction amount exceeds company maximum limit');
    }

    // NOTE: Daily/monthly limits and user limits moved to UseCase (require DB queries)

    return ValidationResult(errors: errors, warnings: warnings);
  }

  /// Validates against company policies
  ValidationResult _validateCompanyPolicies(
    Transaction transaction,
    CompanyPolicy companyPolicy,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    // Check if transaction type is allowed
    if (!companyPolicy.isTransactionTypeAllowed(transaction)) {
      errors.add('This type of transaction is not allowed by company policy');
    }

    // Check if description is required for this amount
    if (transaction.amount.value > companyPolicy.descriptionRequiredThreshold &&
        (transaction.description == null || transaction.description!.trim().isEmpty)) {
      errors.add('Description is required for transactions above ${companyPolicy.descriptionRequiredThreshold}');
    }

    // Check reference number requirements
    if (companyPolicy.requiresReferenceNumber(transaction) &&
        (transaction.referenceNumber == null || transaction.referenceNumber!.trim().isEmpty)) {
      errors.add('Reference number is required for this type of transaction');
    }

    // NOTE: Segregation of duties check moved to UseCase (requires user context)

    return ValidationResult(errors: errors, warnings: warnings);
  }

  /// Validates business hours restrictions
  ValidationResult _validateBusinessHours(
    Transaction transaction,
    CompanyPolicy companyPolicy,
  ) {
    final errors = <String>[];
    final warnings = <String>[];

    if (companyPolicy.enforceBusinessHours) {
      final transactionHour = transaction.transactionDate.hour;

      if (transactionHour < companyPolicy.businessHoursStart ||
          transactionHour >= companyPolicy.businessHoursEnd) {
        
        if (transaction.amount.value > companyPolicy.afterHoursLimit) {
          errors.add('High-value transactions are not allowed outside business hours');
        } else {
          warnings.add('Transaction is outside normal business hours');
        }
      }
    }

    return ValidationResult(errors: errors, warnings: warnings);
  }

  // NOTE: Duplicate detection moved to UseCase (requires DB query)

  /// Determines if transaction requires approval
  bool _requiresApproval(
    Transaction transaction,
    ApprovalLimits approvalLimits,
    CompanyPolicy companyPolicy,
  ) {
    // Requires approval for certain transaction types
    if (companyPolicy.requiresApprovalForTransactionType(transaction)) {
      return true;
    }

    // Requires approval outside business hours for high amounts
    if (companyPolicy.enforceBusinessHours) {
      final transactionHour = transaction.transactionDate.hour;
      if ((transactionHour < companyPolicy.businessHoursStart ||
           transactionHour >= companyPolicy.businessHoursEnd) &&
          transaction.amount.value > companyPolicy.afterHoursLimit) {
        return true;
      }
    }

    return false;
  }

  /// Gets required approval level
  String _getRequiredApprovalLevel(
    Transaction transaction,
    ApprovalLimits approvalLimits,
  ) {
    final amount = transaction.amount.value;

    if (amount > approvalLimits.executiveApprovalThreshold) {
      return ApprovalLevels.executive;
    } else if (amount > approvalLimits.managerApprovalThreshold) {
      return ApprovalLevels.manager;
    } else if (amount > approvalLimits.supervisorApprovalThreshold) {
      return ApprovalLevels.supervisor;
    } else {
      return ApprovalLevels.none;
    }
  }

  // NOTE: The following methods moved to UseCase:
  // - _canAccessAccount() -> requires external service call
  // - _exceedsDailyLimit() -> requires DB query
  // - _exceedsMonthlyLimit() -> requires DB query
  // - _violatesSegregationOfDuties() -> requires user context
  // - _isPotentialDuplicate() -> requires DB query
}

/// Result of transaction policy validation
class TransactionPolicyValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final bool requiresApproval;
  final String approvalLevel;

  const TransactionPolicyValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.requiresApproval,
    required this.approvalLevel,
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

/// Company policy configuration
class CompanyPolicy {
  final bool requiresSegregationOfDuties;
  final double descriptionRequiredThreshold;
  final bool enforceBusinessHours;
  final int businessHoursStart;
  final int businessHoursEnd;
  final double afterHoursLimit;

  const CompanyPolicy({
    required this.requiresSegregationOfDuties,
    required this.descriptionRequiredThreshold,
    required this.enforceBusinessHours,
    required this.businessHoursStart,
    required this.businessHoursEnd,
    required this.afterHoursLimit,
  });

  bool isTransactionTypeAllowed(Transaction transaction) {
    // Check if transaction type is allowed
    return true; // Simplified for example
  }

  bool requiresReferenceNumber(Transaction transaction) {
    // Check if reference number is required
    return transaction.amount.value > 1000; // Simplified for example
  }

  bool requiresApprovalForTransactionType(Transaction transaction) {
    // Check if this transaction type requires approval
    return false; // Simplified for example
  }
}

/// Approval limits configuration
class ApprovalLimits {
  final double selfApprovalLimit;
  final double highValueThreshold;
  final double companyMaximum;
  final double supervisorApprovalThreshold;
  final double managerApprovalThreshold;
  final double executiveApprovalThreshold;
  final Map<String, double> userLimits;

  const ApprovalLimits({
    required this.selfApprovalLimit,
    required this.highValueThreshold,
    required this.companyMaximum,
    required this.supervisorApprovalThreshold,
    required this.managerApprovalThreshold,
    required this.executiveApprovalThreshold,
    required this.userLimits,
  });

  double getUserLimit(String userId) {
    return userLimits[userId] ?? selfApprovalLimit;
  }
}

/// Approval level constants (matching original structure)
class ApprovalLevels {
  static const String none = 'none';
  static const String supervisor = 'supervisor';
  static const String manager = 'manager';
  static const String executive = 'executive';

  static String getDisplayName(String level) {
    switch (level) {
      case ApprovalLevels.none:
        return 'No Approval Required';
      case ApprovalLevels.supervisor:
        return 'Supervisor Approval';
      case ApprovalLevels.manager:
        return 'Manager Approval';
      case ApprovalLevels.executive:
        return 'Executive Approval';
      default:
        return 'Unknown Approval Level';
    }
  }
}