import '../entities/transaction_entity.dart';
import '../enums/approval_level.dart';
import '../exceptions/transaction_business_exception.dart';
import '../exceptions/validation_error.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/transaction_repository.dart';
import '../validators/transaction_validator.dart';
import '../value_objects/transaction_amount.dart';
import '../value_objects/transaction_context.dart';
import '../value_objects/transaction_counterparty.dart';
import '../value_objects/transaction_location.dart';
import '../value_objects/transaction_metadata.dart';
import '../value_objects/transaction_status.dart';

/// Use case for creating a new transaction
/// 
/// Orchestrates the transaction creation process including validation,
/// business rule checking, and persistence.
class CreateTransactionUseCase {
  final TransactionRepository _transactionRepository;
  final TransactionValidator _transactionValidator;

  const CreateTransactionUseCase({
    required TransactionRepository transactionRepository,
    required TransactionValidator transactionValidator,
  })  : _transactionRepository = transactionRepository,
        _transactionValidator = transactionValidator;

  /// Executes the transaction creation use case
  Future<CreateTransactionResult> execute(CreateTransactionCommand command) async {
    try {
      // 1. Create transaction entity from command
      final transaction = _createTransactionFromCommand(command);

      // 2. Validate entity internal consistency
      final entityValidation = transaction.validate();
      if (!entityValidation.isValid) {
        throw ValidationException.multipleFields(
          errors: entityValidation.errors.map((error) => 
            ValidationError(
              fieldName: 'transaction',
              fieldValue: '',
              validationRule: 'entity_validation',
              message: error,
            ),
          ).toList(),
        );
      }

      // 3. Validate against external policies
      // TODO: Add proper policy validation with required parameters
      // For now, create a basic validation result to avoid compilation errors
      final policyValidation = _createBasicPolicyValidation(transaction);
      if (!policyValidation.isValid) {
        throw ValidationException.businessRule(
          ruleName: 'transaction_policy',
          ruleDescription: policyValidation.firstError ?? 'Policy validation failed',
          ruleContext: {
            'errors': policyValidation.errors,
            'warnings': policyValidation.warnings ?? [],
            'requiresApproval': policyValidation.requiresApproval ?? false,
          },
        );
      }

      // 4. Handle approval requirements
      final finalTransaction = _handleApprovalRequirements(
        transaction, 
        policyValidation,
      );

      // 5. Save the transaction
      await _transactionRepository.save(finalTransaction);

      // 6. Return success result
      return CreateTransactionResult.success(
        transaction: finalTransaction,
        requiresApproval: policyValidation.requiresApproval ?? false,
        approvalLevel: policyValidation.approvalLevel ?? ApprovalLevel.none,
        warnings: policyValidation.warnings ?? [],
      );

    } on ValidationException {
      rethrow;
    } on TransactionBusinessException {
      rethrow;
    } catch (e) {
      throw TransactionBusinessException(
        'Failed to create transaction: ${e.toString()}',
        errorCode: 'TRANSACTION_CREATION_FAILED',
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// Creates transaction entity from command
  Transaction _createTransactionFromCommand(CreateTransactionCommand command) {
    // Generate unique transaction ID
    final transactionId = _generateTransactionId();
    final now = DateTime.now();

    return Transaction(
      id: transactionId,
      templateId: command.templateId,
      debitAccountId: command.debitAccountId,
      creditAccountId: command.creditAccountId,
      amount: TransactionAmount.create(command.amount),
      transactionDate: command.transactionDate,
      description: command.description,
      status: const TransactionStatus.pending(),
      counterparty: command.counterparty,
      location: command.location,
      referenceNumber: command.referenceNumber,
      context: command.context,
      metadata: TransactionMetadata.create(
        createdBy: command.createdBy,
        ipAddress: command.ipAddress,
        userAgent: command.userAgent,
      ),
    );
  }

  /// Handles approval requirements based on policy validation
  Transaction _handleApprovalRequirements(
    Transaction transaction,
    _BasicPolicyValidationResult policyValidation,
  ) {
    if (!(policyValidation.requiresApproval ?? false)) {
      return transaction;
    }

    // Transaction requires approval - keep it pending
    return transaction.copyWith(
      updatedBy: transaction.metadata.createdBy,
    );
  }

  /// Generates a unique transaction ID
  String _generateTransactionId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return 'TXN-$timestamp';
  }

  /// TODO: Temporary basic policy validation to avoid compilation errors
  /// This should be replaced with proper TransactionValidator.validate() call
  /// when CompanyPolicy, ApprovalLimits, and other dependencies are properly implemented
  _BasicPolicyValidationResult _createBasicPolicyValidation(Transaction transaction) {
    // Basic validation - just check if amount is reasonable
    final errors = <String>[];
    
    if (transaction.amount.value > 10000) {
      errors.add('High value transaction requires approval');
    }
    
    return _BasicPolicyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: errors.isNotEmpty ? ['Transaction requires supervisor review'] : [],
      requiresApproval: errors.isNotEmpty,
      approvalLevel: errors.isNotEmpty ? ApprovalLevel.supervisor : ApprovalLevel.none,
    );
  }
}

/// Command for creating a transaction
class CreateTransactionCommand {
  final String? templateId;
  final String debitAccountId;
  final String creditAccountId;
  final double amount;
  final DateTime transactionDate;
  final String? description;
  final TransactionCounterparty? counterparty;
  final TransactionLocation? location;
  final String? referenceNumber;
  final TransactionContext context;
  final String createdBy;
  final String? ipAddress;
  final String? userAgent;

  const CreateTransactionCommand({
    this.templateId,
    required this.debitAccountId,
    required this.creditAccountId,
    required this.amount,
    required this.transactionDate,
    this.description,
    this.counterparty,
    this.location,
    this.referenceNumber,
    required this.context,
    required this.createdBy,
    this.ipAddress,
    this.userAgent,
  });

  /// Factory constructor for creating from template
  factory CreateTransactionCommand.fromTemplate({
    required String templateId,
    required double amount,
    required DateTime transactionDate,
    String? description,
    String? referenceNumber,
    required String debitAccountId,
    required String creditAccountId,
    TransactionCounterparty? counterparty,
    TransactionLocation? location,
    required TransactionContext context,
    required String createdBy,
    String? ipAddress,
    String? userAgent,
  }) {
    return CreateTransactionCommand(
      templateId: templateId,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      amount: amount,
      transactionDate: transactionDate,
      description: description,
      referenceNumber: referenceNumber,
      counterparty: counterparty,
      location: location,
      context: context,
      createdBy: createdBy,
      ipAddress: ipAddress,
      userAgent: userAgent,
    );
  }
}

/// Result of transaction creation
class CreateTransactionResult {
  final bool isSuccess;
  final Transaction? transaction;
  final bool requiresApproval;
  final ApprovalLevel approvalLevel;
  final List<String> warnings;
  final String? errorMessage;

  const CreateTransactionResult._({
    required this.isSuccess,
    this.transaction,
    this.requiresApproval = false,
    this.approvalLevel = ApprovalLevel.none,
    this.warnings = const [],
    this.errorMessage,
  });

  /// Factory constructor for success result
  factory CreateTransactionResult.success({
    required Transaction transaction,
    bool requiresApproval = false,
    ApprovalLevel approvalLevel = ApprovalLevel.none,
    List<String> warnings = const [],
  }) {
    return CreateTransactionResult._(
      isSuccess: true,
      transaction: transaction,
      requiresApproval: requiresApproval,
      approvalLevel: approvalLevel,
      warnings: warnings,
    );
  }

  /// Factory constructor for failure result
  factory CreateTransactionResult.failure({
    required String errorMessage,
  }) {
    return CreateTransactionResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// TODO: Temporary basic policy validation result
/// This should be replaced with proper TransactionPolicyValidationResult
/// when external policy validation types are properly implemented
class _BasicPolicyValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String>? warnings;
  final bool? requiresApproval;
  final ApprovalLevel? approvalLevel;

  const _BasicPolicyValidationResult({
    required this.isValid,
    required this.errors,
    this.warnings,
    this.requiresApproval,
    this.approvalLevel,
  });

  String? get firstError => errors.isEmpty ? null : errors.first;
}