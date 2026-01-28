import '../../../../core/utils/datetime_utils.dart';
import '../entities/template_entity.dart';
import '../exceptions/template_business_exception.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/template_repository.dart';
import '../repositories/transaction_repository.dart';

/// Use case for deleting a transaction template
/// 
/// Orchestrates the template deletion process including safety checks,
/// usage validation, and cleanup operations.
class DeleteTemplateUseCase {
  final TemplateRepository _templateRepository;
  final TransactionRepository _transactionRepository;

  const DeleteTemplateUseCase({
    required TemplateRepository templateRepository,
    required TransactionRepository transactionRepository,
  })  : _templateRepository = templateRepository,
        _transactionRepository = transactionRepository;

  /// Executes the template deletion use case
  Future<DeleteTemplateResult> execute(DeleteTemplateCommand command) async {
    try {
      // 1. Find existing template
      final template = await _templateRepository.findById(command.templateId);
      if (template == null) {
        throw TemplateBusinessException.notFound(
          templateId: command.templateId,
        );
      }

      // 2. ✅ ARCHITECTURE FIX: Permission check removed from Domain Layer
      // Permission checking is UI responsibility (canDeleteTemplatesProvider)
      // Domain layer only handles business rules and data integrity

      // 3. Check if template is being used by existing transactions
      final usageCheck = await _checkTemplateUsage(template.templateId);
      if (usageCheck.hasActiveUsage && !command.forceDelete) {
        throw TemplateBusinessException.templateInUse(
          templateId: command.templateId,
          activeTransactionCount: usageCheck.activeTransactionCount,
          lastUsedDate: usageCheck.lastUsedDate,
        );
      }

      // 4. If forcing delete with active usage, handle cleanup
      if (command.forceDelete && usageCheck.hasActiveUsage) {
        await _handleForceDeleteCleanup(template, usageCheck, command);
      }

      // 5. Perform soft delete via RPC
      // Note: hardDelete option is currently not supported by RPC
      // RPC always performs soft delete (is_active = false)
      await _templateRepository.delete(
        templateId: template.templateId,
        userId: command.deletedBy,
        companyId: template.companyId,
        localTime: DateTime.now().toIso8601String(),
        timezone: DateTimeUtils.getLocalTimezone(),
      );

      // 6. Log deletion for audit purposes
      await _logTemplateDeletion(template, command);

      // 7. Return success result
      return DeleteTemplateResult.success(
        templateId: template.templateId,
        templateName: template.name,
        deletionType: command.hardDelete ? DeletionType.hard : DeletionType.soft,
        affectedTransactions: usageCheck.activeTransactionCount,
        warnings: _generateDeletionWarnings(usageCheck),
      );

    } on TemplateBusinessException {
      rethrow;
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw TemplateBusinessException(
        'Failed to delete template: ${e.toString()}',
        errorCode: 'TEMPLATE_DELETION_FAILED',
        context: {'templateId': command.templateId},
        innerException: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  /// ❌ REMOVED: Permission check moved to UI Layer
  ///
  /// Permission checking is NOT Domain Layer responsibility.
  /// UI Layer handles this via canDeleteTemplatesProvider.
  ///
  /// Domain Layer responsibilities:
  /// - Business rules validation
  /// - Data integrity checks
  /// - Template usage verification
  /// - Transaction consistency

  /// Checks template usage in transactions
  Future<TemplateUsageCheck> _checkTemplateUsage(String templateId) async {
    // Check for transactions using this template
    final transactions = await _transactionRepository.findByTemplateId(templateId);
    
    // Filter for active (non-completed, non-cancelled) transactions
    final activeTransactions = transactions.where((txn) => 
      !txn.status.isFinalState,
    ).toList();

    final lastUsedTransaction = transactions.isNotEmpty 
        ? transactions.reduce((a, b) => 
            a.transactionDate.isAfter(b.transactionDate) ? a : b,)
        : null;

    return TemplateUsageCheck(
      totalTransactionCount: transactions.length,
      activeTransactionCount: activeTransactions.length,
      hasActiveUsage: activeTransactions.isNotEmpty,
      lastUsedDate: lastUsedTransaction?.transactionDate,
      activeTransactionIds: activeTransactions.map((txn) => txn.id).toList(),
    );
  }

  /// Handles cleanup for force deletion
  Future<void> _handleForceDeleteCleanup(
    TransactionTemplate template,
    TemplateUsageCheck usageCheck,
    DeleteTemplateCommand command,
  ) async {
    if (!command.forceDelete) return;

    // For force delete, we might need to:
    // 1. Cancel pending transactions
    // 2. Archive completed transactions with template info
    // 3. Notify users about template removal

    for (final transactionId in usageCheck.activeTransactionIds) {
      final transaction = await _transactionRepository.findById(transactionId);
      if (transaction != null && transaction.status.canBeCancelled) {
        // Cancel pending transactions when template is force deleted
        final cancelledTransaction = transaction.cancel(
          cancelledBy: command.deletedBy,
        );
        await _transactionRepository.save(cancelledTransaction);
      }
    }
  }

  /// Logs template deletion for audit
  Future<void> _logTemplateDeletion(
    TransactionTemplate template,
    DeleteTemplateCommand command,
  ) async {
    // In real implementation, this would log to audit system
    // For now, this is a placeholder
  }

  /// Generates warnings for deletion
  List<String> _generateDeletionWarnings(TemplateUsageCheck usageCheck) {
    final warnings = <String>[];

    if (usageCheck.hasActiveUsage) {
      warnings.add('Template was used by ${usageCheck.activeTransactionCount} active transactions');
    }

    if (usageCheck.totalTransactionCount > 0) {
      warnings.add('Template was used by ${usageCheck.totalTransactionCount} total transactions');
    }

    if (usageCheck.lastUsedDate != null) {
      final daysSinceLastUse = DateTime.now().difference(usageCheck.lastUsedDate!).inDays;
      if (daysSinceLastUse < 30) {
        warnings.add('Template was used recently ($daysSinceLastUse days ago)');
      }
    }

    return warnings;
  }
}

/// Command for deleting a template
class DeleteTemplateCommand {
  final String templateId;
  final String deletedBy;
  final bool forceDelete;  // Delete even if template is in use
  final bool hardDelete;   // Permanently delete vs soft delete
  final String? reason;    // Reason for deletion
  final String? ipAddress;
  final String? userAgent;

  const DeleteTemplateCommand({
    required this.templateId,
    required this.deletedBy,
    this.forceDelete = false,
    this.hardDelete = false,
    this.reason,
    this.ipAddress,
    this.userAgent,
  });
}

/// Result of template deletion
class DeleteTemplateResult {
  final bool isSuccess;
  final String? templateId;
  final String? templateName;
  final DeletionType deletionType;
  final int affectedTransactions;
  final List<String> warnings;
  final String? errorMessage;

  const DeleteTemplateResult._({
    required this.isSuccess,
    this.templateId,
    this.templateName,
    this.deletionType = DeletionType.soft,
    this.affectedTransactions = 0,
    this.warnings = const [],
    this.errorMessage,
  });

  /// Factory constructor for success result
  factory DeleteTemplateResult.success({
    required String templateId,
    required String templateName,
    required DeletionType deletionType,
    int affectedTransactions = 0,
    List<String> warnings = const [],
  }) {
    return DeleteTemplateResult._(
      isSuccess: true,
      templateId: templateId,
      templateName: templateName,
      deletionType: deletionType,
      affectedTransactions: affectedTransactions,
      warnings: warnings,
    );
  }

  /// Factory constructor for failure result
  factory DeleteTemplateResult.failure({
    required String errorMessage,
  }) {
    return DeleteTemplateResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Template usage check result
class TemplateUsageCheck {
  final int totalTransactionCount;
  final int activeTransactionCount;
  final bool hasActiveUsage;
  final DateTime? lastUsedDate;
  final List<String> activeTransactionIds;

  const TemplateUsageCheck({
    required this.totalTransactionCount,
    required this.activeTransactionCount,
    required this.hasActiveUsage,
    this.lastUsedDate,
    required this.activeTransactionIds,
  });
}

/// Types of template deletion
enum DeletionType {
  soft,    // Mark as inactive, keep data
  hard,    // Permanently remove from database
}