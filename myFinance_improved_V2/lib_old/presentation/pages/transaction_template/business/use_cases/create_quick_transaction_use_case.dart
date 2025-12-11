/// Create Quick Transaction Use Case - Pure business logic for transaction creation
///
/// Purpose: Orchestrates quick transaction creation business logic
/// - Builds transaction lines from template data
/// - Handles cash location resolution
/// - Manages counterparty information
/// - Validates transaction data
/// - Coordinates with repository for persistence
///
/// Clean Architecture: BUSINESS LAYER (Pure business logic, no external dependencies)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/quick_builder_validation.dart';
import '../../data/repositories/quick_transaction_repository.dart';
import '../../../../providers/app_state_provider.dart';
import '../../../../providers/auth_provider.dart';

/// Use case for creating quick transactions from templates
class CreateQuickTransactionUseCase {
  final QuickTransactionRepository _repository;

  CreateQuickTransactionUseCase(this._repository);

  /// Create a transaction from a quick template
  Future<void> execute({
    required WidgetRef ref,
    required Map<String, dynamic> template,
    required double amount,
    String? description,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyCashLocationId,
  }) async {
    // Get required app state
    final appState = ref.read(appStateProvider);
    final user = ref.read(authStateProvider);
    
    if (user == null) throw Exception('User not authenticated');
    
    // Build transaction lines from template
    final transactionLines = await _buildQuickTransactionLines(
      template: template,
      amount: amount,
      selectedMyCashLocationId: selectedMyCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
    );
    
    // Extract main counterparty info
    final mainCounterpartyId = _extractMainCounterpartyId(template, selectedCounterpartyId);
    
    // Create transaction via repository
    await _repository.createTransaction(
      companyId: appState.companyChoosen,
      userId: user.id,
      storeId: appState.storeChoosen,
      amount: amount,
      description: description,
      transactionLines: transactionLines,
      counterpartyId: mainCounterpartyId,
      counterpartyCashLocationId: selectedCounterpartyCashLocationId,
    );
  }

  /// Build transaction lines from template data (Pure business logic)
  Future<List<Map<String, dynamic>>> _buildQuickTransactionLines({
    required Map<String, dynamic> template,
    required double amount,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
  }) async {
    final lines = <Map<String, dynamic>>[];
    final templateData = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};
    
    // Get cash location info if needed
    Map<String, dynamic>? myCashLocationData;
    if (selectedMyCashLocationId != null) {
      myCashLocationData = await _repository.getCashLocationData(selectedMyCashLocationId);
    } else {
      // Try to get from template tags
      final tagsCashLocations = tags['cash_locations'] as List? ?? [];
      if (tagsCashLocations.isNotEmpty) {
        final cashLocationId = tagsCashLocations.first as String?;
        if (cashLocationId != null && cashLocationId != 'none') {
          myCashLocationData = await _repository.getCashLocationData(cashLocationId);
        }
      }
    }
    
    // Build lines from template
    for (var templateLine in templateData) {
      final line = <String, dynamic>{
        'account_id': templateLine['account_id'],
        'description': templateLine['description'] ?? '',
      };
      
      // Set amounts (Business logic)
      if (templateLine['type'] == 'debit') {
        line['debit'] = amount.toString();
        line['credit'] = '0';
      } else {
        line['debit'] = '0';
        line['credit'] = amount.toString();
      }
      
      // Add counterparty info if present
      final counterpartyId = templateLine['counterparty_id'] ?? selectedCounterpartyId;
      if (counterpartyId != null) {
        line['counterparty_id'] = counterpartyId;
      }
      
      // Handle cash accounts
      if (templateLine['category_tag'] == 'cash' && myCashLocationData != null) {
        line['cash'] = {
          'cash_location_id': myCashLocationData['cash_location_id'],
          'cash_location_name': myCashLocationData['location_name'] ?? '',
        };
      }
      
      // For quick templates, skip complex debt configuration
      // Users can use detailed mode for debt tracking
      
      lines.add(line);
    }
    
    return lines;
  }

  /// Extract main counterparty ID from template (Pure business logic)
  String? _extractMainCounterpartyId(
    Map<String, dynamic> template,
    String? selectedCounterpartyId,
  ) {
    // Use selected counterparty if provided
    if (selectedCounterpartyId != null) {
      return selectedCounterpartyId;
    }
    
    // Use template's counterparty_id if available
    final templateCounterpartyId = template['counterparty_id'];
    if (templateCounterpartyId != null && templateCounterpartyId.toString().isNotEmpty) {
      return templateCounterpartyId.toString();
    }
    
    // Look for counterparty in template data
    final data = template['data'] as List? ?? [];
    for (var line in data) {
      final counterpartyId = line['counterparty_id'];
      if (counterpartyId != null && counterpartyId.toString().isNotEmpty) {
        return counterpartyId.toString();
      }
    }
    
    return null;
  }

  /// Validate that a template can be processed with quick transaction creation
  static QuickBuilderValidation validateTemplate(Map<String, dynamic> template) {
    final errors = <String>[];
    final warnings = <String>[];
    
    // Check for required template structure
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) {
      errors.add('Template has no transaction data');
    }
    
    // Check for complex debt requirements
    bool hasComplexDebt = false;
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
}

/// Provider for CreateQuickTransactionUseCase
final createQuickTransactionUseCaseProvider = Provider<CreateQuickTransactionUseCase>((ref) {
  final repository = ref.read(quickTransactionRepositoryProvider);
  return CreateQuickTransactionUseCase(repository);
});