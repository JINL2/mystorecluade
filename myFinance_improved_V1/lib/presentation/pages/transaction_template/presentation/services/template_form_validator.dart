/// Template Form Validator - Comprehensive validation for template creation wizard
///
/// Purpose: Centralized validation logic for all template creation steps:
/// - Step-by-step validation with detailed error messages
/// - Business rule validation for complex account relationships
/// - Real-time validation support for UI state management
/// - Integration with account category tags and counterparty requirements
///
/// Usage: TemplateFormValidator.validateStep2(formData)
import '../components/wizard/template_basic_info_form.dart';
import '../components/wizard/permissions_form.dart';

class TemplateFormValidator {
  
  /// Validate Step 1: Basic Information
  static ValidationResult validateStep1({
    required String name,
    String? description,
  }) {
    final errors = <String>[];
    
    if (name.trim().isEmpty) {
      errors.add('Template name is required');
    } else if (name.trim().length < 2) {
      errors.add('Template name must be at least 2 characters');
    } else if (name.trim().length > 100) {
      errors.add('Template name cannot exceed 100 characters');
    }
    
    if (description != null && description.trim().length > 500) {
      errors.add('Description cannot exceed 500 characters');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Validate Step 2: Transaction Details
  static ValidationResult validateStep2({
    required String? selectedDebitAccountId,
    required String? selectedCreditAccountId,
    required bool debitRequiresCounterparty,
    required bool creditRequiresCounterparty,
    required bool debitIsCashAccount,
    required bool creditIsCashAccount,
    String? selectedDebitCounterpartyId,
    Map<String, dynamic>? selectedDebitCounterpartyData,
    String? selectedCreditCounterpartyId,
    Map<String, dynamic>? selectedCreditCounterpartyData,
    String? selectedDebitStoreId,
    String? selectedCreditStoreId,
    String? selectedDebitCashLocationId,
    String? selectedCreditCashLocationId,
  }) {
    final errors = <String>[];
    
    // Basic validation: both accounts must be selected
    if (selectedDebitAccountId == null) {
      errors.add('Please select a debit account');
    }
    
    if (selectedCreditAccountId == null) {
      errors.add('Please select a credit account');
    }
    
    // Account combination validation
    if (selectedDebitAccountId == selectedCreditAccountId) {
      errors.add('Debit and credit accounts cannot be the same');
    }
    
    // Debit account counterparty validation
    if (debitRequiresCounterparty && selectedDebitCounterpartyId == null) {
      errors.add('Please select a counterparty for the debit account');
    }
    
    // Credit account counterparty validation
    if (creditRequiresCounterparty && selectedCreditCounterpartyId == null) {
      errors.add('Please select a counterparty for the credit account');
    }
    
    // Internal counterparty store validation
    if (_isInternalCounterparty(selectedDebitCounterpartyData) && selectedDebitStoreId == null) {
      errors.add('Please select a store for the debit counterparty');
    }
    
    if (_isInternalCounterparty(selectedCreditCounterpartyData) && selectedCreditStoreId == null) {
      errors.add('Please select a store for the credit counterparty');
    }
    
    // Business rule validation for internal cash transfers
    final debitCashLocationError = _validateInternalCashTransfer(
      isDebitSide: true,
      accountRequiresCounterparty: debitRequiresCounterparty,
      otherAccountIsCash: creditIsCashAccount,
      accountIsCash: debitIsCashAccount,
      otherAccountRequiresCounterparty: creditRequiresCounterparty,
      counterpartyData: selectedDebitCounterpartyData,
      selectedCashLocationId: selectedDebitCashLocationId,
    );
    
    if (debitCashLocationError != null) {
      errors.add(debitCashLocationError);
    }
    
    final creditCashLocationError = _validateInternalCashTransfer(
      isDebitSide: false,
      accountRequiresCounterparty: creditRequiresCounterparty,
      otherAccountIsCash: debitIsCashAccount,
      accountIsCash: creditIsCashAccount,
      otherAccountRequiresCounterparty: debitRequiresCounterparty,
      counterpartyData: selectedCreditCounterpartyData,
      selectedCashLocationId: selectedCreditCashLocationId,
    );
    
    if (creditCashLocationError != null) {
      errors.add(creditCashLocationError);
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Validate Step 3: Permissions
  static ValidationResult validateStep3({
    required String selectedVisibility,
    required String selectedPermission,
  }) {
    final errors = <String>[];
    
    if (!_isValidVisibility(selectedVisibility)) {
      errors.add('Please select a valid visibility level');
    }
    
    if (!_isValidPermission(selectedPermission)) {
      errors.add('Please select a valid permission level');
    }
    
    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Quick validation check for real-time UI updates
  static bool canProceedFromStep2({
    required String? selectedDebitAccountId,
    required String? selectedCreditAccountId,
    required bool debitRequiresCounterparty,
    required bool creditRequiresCounterparty,
    required bool debitIsCashAccount,
    required bool creditIsCashAccount,
    String? selectedDebitCounterpartyId,
    Map<String, dynamic>? selectedDebitCounterpartyData,
    String? selectedCreditCounterpartyId,
    Map<String, dynamic>? selectedCreditCounterpartyData,
    String? selectedDebitStoreId,
    String? selectedCreditStoreId,
    String? selectedDebitCashLocationId,
    String? selectedCreditCashLocationId,
  }) {
    final validation = validateStep2(
      selectedDebitAccountId: selectedDebitAccountId,
      selectedCreditAccountId: selectedCreditAccountId,
      debitRequiresCounterparty: debitRequiresCounterparty,
      creditRequiresCounterparty: creditRequiresCounterparty,
      debitIsCashAccount: debitIsCashAccount,
      creditIsCashAccount: creditIsCashAccount,
      selectedDebitCounterpartyId: selectedDebitCounterpartyId,
      selectedDebitCounterpartyData: selectedDebitCounterpartyData,
      selectedCreditCounterpartyId: selectedCreditCounterpartyId,
      selectedCreditCounterpartyData: selectedCreditCounterpartyData,
      selectedDebitStoreId: selectedDebitStoreId,
      selectedCreditStoreId: selectedCreditStoreId,
      selectedDebitCashLocationId: selectedDebitCashLocationId,
      selectedCreditCashLocationId: selectedCreditCashLocationId,
    );
    
    return validation.isValid;
  }
  
  /// Validate final form before submission
  static ValidationResult validateCompleteForm({
    required String name,
    String? description,
    required String? selectedDebitAccountId,
    required String? selectedCreditAccountId,
    required bool debitRequiresCounterparty,
    required bool creditRequiresCounterparty,
    required bool debitIsCashAccount,
    required bool creditIsCashAccount,
    String? selectedDebitCounterpartyId,
    Map<String, dynamic>? selectedDebitCounterpartyData,
    String? selectedCreditCounterpartyId,
    Map<String, dynamic>? selectedCreditCounterpartyData,
    String? selectedDebitStoreId,
    String? selectedCreditStoreId,
    String? selectedDebitCashLocationId,
    String? selectedCreditCashLocationId,
    required String selectedVisibility,
    required String selectedPermission,
  }) {
    final allErrors = <String>[];
    
    // Validate all steps
    final step1Result = validateStep1(name: name, description: description);
    allErrors.addAll(step1Result.errors);
    
    final step2Result = validateStep2(
      selectedDebitAccountId: selectedDebitAccountId,
      selectedCreditAccountId: selectedCreditAccountId,
      debitRequiresCounterparty: debitRequiresCounterparty,
      creditRequiresCounterparty: creditRequiresCounterparty,
      debitIsCashAccount: debitIsCashAccount,
      creditIsCashAccount: creditIsCashAccount,
      selectedDebitCounterpartyId: selectedDebitCounterpartyId,
      selectedDebitCounterpartyData: selectedDebitCounterpartyData,
      selectedCreditCounterpartyId: selectedCreditCounterpartyId,
      selectedCreditCounterpartyData: selectedCreditCounterpartyData,
      selectedDebitStoreId: selectedDebitStoreId,
      selectedCreditStoreId: selectedCreditStoreId,
      selectedDebitCashLocationId: selectedDebitCashLocationId,
      selectedCreditCashLocationId: selectedCreditCashLocationId,
    );
    allErrors.addAll(step2Result.errors);
    
    final step3Result = validateStep3(
      selectedVisibility: selectedVisibility,
      selectedPermission: selectedPermission,
    );
    allErrors.addAll(step3Result.errors);
    
    return ValidationResult(
      isValid: allErrors.isEmpty,
      errors: allErrors,
    );
  }
  
  // Private helper methods
  
  static bool _isInternalCounterparty(Map<String, dynamic>? counterpartyData) {
    return counterpartyData != null && counterpartyData['is_internal'] == true;
  }
  
  static String? _validateInternalCashTransfer({
    required bool isDebitSide,
    required bool accountRequiresCounterparty,
    required bool otherAccountIsCash,
    required bool accountIsCash,
    required bool otherAccountRequiresCounterparty,
    Map<String, dynamic>? counterpartyData,
    String? selectedCashLocationId,
  }) {
    if (!_isInternalCounterparty(counterpartyData)) {
      return null; // No validation needed for external counterparties
    }
    
    // Business rule: Internal transfers involving cash and debt/receivable
    // must specify counterparty cash location
    final isComplexInternalTransfer = (accountRequiresCounterparty && otherAccountIsCash) || 
                                     (accountIsCash && otherAccountRequiresCounterparty);
    
    if (isComplexInternalTransfer && selectedCashLocationId == null) {
      final side = isDebitSide ? 'debit' : 'credit';
      return 'Please select counterparty cash location for $side account (required for internal cash transfers)';
    }
    
    return null;
  }
  
  static bool _isValidVisibility(String visibility) {
    return visibility == 'Public' || visibility == 'Private';
  }
  
  static bool _isValidPermission(String permission) {
    return permission == 'Manager' || permission == 'Common';
  }
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  const ValidationResult({
    required this.isValid,
    required this.errors,
  });
  
  /// Get first error message for display
  String? get firstError => errors.isNotEmpty ? errors.first : null;
  
  /// Get formatted error list
  String get formattedErrors => errors.join('\n');
}