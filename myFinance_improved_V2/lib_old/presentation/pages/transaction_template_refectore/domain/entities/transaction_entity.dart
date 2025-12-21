import 'package:equatable/equatable.dart';
import '../value_objects/transaction_amount.dart';
import '../value_objects/transaction_status.dart';
import '../value_objects/transaction_metadata.dart';
import '../value_objects/transaction_context.dart';
import '../value_objects/transaction_counterparty.dart';
import '../value_objects/transaction_location.dart';
import '../validators/transaction_validation_result.dart';
import '../exceptions/transaction_business_exception.dart';

/// Core business entity representing a financial transaction
/// 
/// A transaction represents a completed or pending exchange of value between accounts.
/// This entity contains only the core business logic that the transaction itself can enforce.
class Transaction extends Equatable {
  /// Unique identifier for this transaction
  final String id;
  
  /// Reference to the template used to create this transaction (if any)
  final String? templateId;
  
  /// Account that is debited (money flows out)
  final String debitAccountId;
  
  /// Account that is credited (money flows in)
  final String creditAccountId;
  
  /// Transaction amount (always positive)
  final TransactionAmount amount;
  
  /// When the transaction occurred or is scheduled to occur
  final DateTime transactionDate;
  
  /// Optional description providing context
  final String? description;
  
  /// Current status of the transaction
  final TransactionStatus status;
  
  /// Counterparty information for external transactions
  final TransactionCounterparty? counterparty;
  
  /// Location context for cash transactions
  final TransactionLocation? location;
  
  /// Store information for debit/credit side distinction (Template mapping)
  final String? debitStoreId;     // Maps to selectedDebitStoreId
  final String? creditStoreId;    // Maps to selectedCreditStoreId
  
  /// Linked company/store IDs for internal counterparties (Production pattern)
  final String? linkedCompanyId;  // For internal counterparty company tracking
  final String? linkedStoreId;    // For internal counterparty store tracking
  
  /// Reference number for tracking and audit purposes
  final String? referenceNumber;
  
  /// Business context information
  final TransactionContext context;
  
  /// Transaction metadata for audit and tracking
  final TransactionMetadata metadata;

  const Transaction({
    required this.id,
    this.templateId,
    required this.debitAccountId,
    required this.creditAccountId,
    required this.amount,
    required this.transactionDate,
    this.description,
    required this.status,
    this.counterparty,
    this.location,
    this.debitStoreId,
    this.creditStoreId,
    this.linkedCompanyId,
    this.linkedStoreId,
    this.referenceNumber,
    required this.context,
    required this.metadata,
  });

  /// 🏛️ DOMAIN API: Convenient access to transaction ID
  /// This getter provides API compatibility while maintaining domain integrity
  String get transactionId => id;

  /// 🏛️ DOMAIN API: Convenient access to creator information
  /// This getter provides API compatibility while maintaining domain integrity
  String get createdBy => metadata.createdBy;

  /// Factory constructor for creating a new transaction from template
  factory Transaction.fromTemplate({
    required String templateId,
    required double amount,
    required DateTime transactionDate,
    String? description,
    String? referenceNumber,
    required String debitAccountId,
    required String creditAccountId,
    TransactionCounterparty? counterparty,
    TransactionLocation? location,
    String? debitStoreId,        
    String? creditStoreId,       
    String? linkedCompanyId,     
    String? linkedStoreId,       
    required String companyId,
    required String storeId,
    required String createdBy,
  }) {
    final transactionId = _generateTransactionId();
    
    return Transaction(
      id: transactionId,
      templateId: templateId,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      amount: TransactionAmount(amount),
      transactionDate: transactionDate,
      description: description,
      status: const TransactionStatus.pending(),
      counterparty: counterparty,
      location: location,
      debitStoreId: debitStoreId,      
      creditStoreId: creditStoreId,    
      linkedCompanyId: linkedCompanyId, 
      linkedStoreId: linkedStoreId,    
      referenceNumber: referenceNumber,
      context: TransactionContext(
        companyId: companyId,
        storeId: storeId,
      ),
      metadata: TransactionMetadata.create(
        createdBy: createdBy,
      ),
    );
  }

  /// Factory constructor for creating a manual transaction
  factory Transaction.manual({
    required String debitAccountId,
    required String creditAccountId,
    required double amount,
    required DateTime transactionDate,
    String? description,
    String? referenceNumber,
    TransactionCounterparty? counterparty,
    TransactionLocation? location,
    String? debitStoreId,        
    String? creditStoreId,       
    String? linkedCompanyId,     
    String? linkedStoreId,       
    required String companyId,
    required String storeId,
    required String createdBy,
  }) {
    final transactionId = _generateTransactionId();
    
    return Transaction(
      id: transactionId,
      templateId: null,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      amount: TransactionAmount(amount),
      transactionDate: transactionDate,
      description: description,
      status: const TransactionStatus.pending(),
      counterparty: counterparty,
      location: location,
      debitStoreId: debitStoreId,      
      creditStoreId: creditStoreId,    
      linkedCompanyId: linkedCompanyId, 
      linkedStoreId: linkedStoreId,    
      referenceNumber: referenceNumber,
      context: TransactionContext(
        companyId: companyId,
        storeId: storeId,
      ),
      metadata: TransactionMetadata.create(
        createdBy: createdBy,
      ),
    );
  }

  /// Validates the transaction's internal consistency (self-contained rules only)
  TransactionValidationResult validate() {
    final errors = <String>[];

    // Validate amount (using value object validation)
    if (!amount.isValid) {
      errors.add('Transaction amount is invalid');
    }

    // Validate accounts are different
    if (debitAccountId == creditAccountId) {
      errors.add('Debit and credit accounts must be different');
    }

    // Validate required fields
    if (debitAccountId.trim().isEmpty || creditAccountId.trim().isEmpty) {
      errors.add('Both debit and credit accounts must be specified');
    }

    // Validate description length if provided
    if (description != null && description!.length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }

    // Validate reference number format if provided
    if (referenceNumber != null && referenceNumber!.length > 50) {
      errors.add('Reference number cannot exceed 50 characters');
    }

    // Validate metadata
    if (!metadata.isValid) {
      errors.addAll(metadata.getValidationErrors());
    }

    // Validate context
    if (!context.isValid) {
      errors.addAll(context.getValidationErrors());
    }

    return TransactionValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Checks if the transaction can be modified (internal state rules only)
  bool canBeModified() {
    return status.allowsModification;
  }

  /// Checks if the transaction can be cancelled (internal state rules only)
  bool canBeCancelled() {
    return status.canBeCancelled;
  }

  /// Checks if the transaction can be completed (internal state rules only)
  bool canBeCompleted() {
    return status.canBeCompleted;
  }

  /// Gets the net amount (currently same as amount - fees would be separate entities)
  TransactionAmount getNetAmount() {
    return amount;
  }

  /// Marks the transaction as completed
  Transaction complete({required String completedBy}) {
    if (!canBeCompleted()) {
      throw TransactionBusinessException.invalidStateTransition(
        fromState: status.displayName,
        toState: 'completed',
        transactionId: id,
      );
    }

    final newStatus = status.transitionTo(const TransactionStatus.completed());
    return _copyWith(
      status: newStatus,
      updatedBy: completedBy,
    );
  }

  /// Marks the transaction as cancelled
  Transaction cancel({required String cancelledBy}) {
    if (!canBeCancelled()) {
      throw TransactionBusinessException.invalidStateTransition(
        fromState: status.displayName,
        toState: 'cancelled',
        transactionId: id,
      );
    }

    final newStatus = status.transitionTo(const TransactionStatus.cancelled());
    return _copyWith(
      status: newStatus,
      updatedBy: cancelledBy,
    );
  }

  /// Updates transaction details (only if modifiable)
  Transaction update({
    TransactionAmount? amount,
    DateTime? transactionDate,
    String? description,
    String? referenceNumber,
    required String updatedBy,
  }) {
    if (!canBeModified()) {
      throw TransactionBusinessException.invalidStateTransition(
        fromState: status.displayName,
        toState: 'modified',
        transactionId: id,
      );
    }

    return _copyWith(
      amount: amount,
      transactionDate: transactionDate,
      description: description,
      referenceNumber: referenceNumber,
      updatedBy: updatedBy,
    );
  }

  /// 🏛️ DOMAIN API: Creates a copy with updated values (PUBLIC)
  /// This method provides API compatibility while maintaining domain integrity
  Transaction copyWith({
    String? id,
    String? templateId,
    String? debitAccountId,
    String? creditAccountId,
    TransactionAmount? amount,
    DateTime? transactionDate,
    String? description,
    TransactionStatus? status,
    TransactionCounterparty? counterparty,
    TransactionLocation? location,
    String? debitStoreId,     
    String? creditStoreId,    
    String? linkedCompanyId,  
    String? linkedStoreId,    
    String? referenceNumber,
    TransactionContext? context,
    String? updatedBy,
  }) {
    return _copyWith(
      id: id,
      templateId: templateId,
      debitAccountId: debitAccountId,
      creditAccountId: creditAccountId,
      amount: amount,
      transactionDate: transactionDate,
      description: description,
      status: status,
      counterparty: counterparty,
      location: location,
      debitStoreId: debitStoreId,
      creditStoreId: creditStoreId,
      linkedCompanyId: linkedCompanyId,
      linkedStoreId: linkedStoreId,
      referenceNumber: referenceNumber,
      context: context,
      updatedBy: updatedBy,
    );
  }

  /// Creates a copy with updated values (PRIVATE)
  Transaction _copyWith({
    String? id,
    String? templateId,
    String? debitAccountId,
    String? creditAccountId,
    TransactionAmount? amount,
    DateTime? transactionDate,
    String? description,
    TransactionStatus? status,
    TransactionCounterparty? counterparty,
    TransactionLocation? location,
    String? debitStoreId,     
    String? creditStoreId,    
    String? linkedCompanyId,  
    String? linkedStoreId,    
    String? referenceNumber,
    TransactionContext? context,
    String? updatedBy,
  }) {
    return Transaction(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      debitAccountId: debitAccountId ?? this.debitAccountId,
      creditAccountId: creditAccountId ?? this.creditAccountId,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      status: status ?? this.status,
      counterparty: counterparty ?? this.counterparty,
      location: location ?? this.location,
      debitStoreId: debitStoreId ?? this.debitStoreId,      
      creditStoreId: creditStoreId ?? this.creditStoreId,   
      linkedCompanyId: linkedCompanyId ?? this.linkedCompanyId, 
      linkedStoreId: linkedStoreId ?? this.linkedStoreId,  
      referenceNumber: referenceNumber ?? this.referenceNumber,
      context: context ?? this.context,
      metadata: metadata.updateWith(
        updatedBy: updatedBy,
      ),
    );
  }

  @override
  List<Object?> get props => [
        id,
        templateId,
        debitAccountId,
        creditAccountId,
        amount,
        transactionDate,
        description,
        status,
        counterparty,
        location,
        debitStoreId,     
        creditStoreId,    
        linkedCompanyId,  
        linkedStoreId,    
        referenceNumber,
        context,
        metadata,
      ];

  static String _generateTransactionId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return 'TXN-$timestamp';
  }
}