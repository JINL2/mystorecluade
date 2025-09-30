/// Quick Template Validator - Business logic for quick template validation
///
/// Purpose: Centralizes validation logic for quick templates:
/// - Amount validation with proper formatting
/// - Completeness-based requirement validation
/// - Essential selection validation
/// - Form state validation
///
/// Usage: QuickTemplateValidator.validate(analysis, form, selections)
import '../utils/quick_template_analyzer.dart';

class QuickTemplateValidator {
  /// Validates if a quick template form can proceed with submission
  static QuickValidationResult validate({
    required TemplateAnalysisResult analysis,
    required String amountText,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyCashLocationId,
    bool isDetailedMode = false,
  }) {
    final errors = <String>[];
    
    // Amount validation
    final amountResult = _validateAmount(amountText);
    if (!amountResult.isValid) {
      errors.addAll(amountResult.errors);
    }
    
    // Completeness-based validation
    final completenessResult = _validateCompleteness(
      analysis: analysis,
      selectedMyCashLocationId: selectedMyCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
      selectedCounterpartyCashLocationId: selectedCounterpartyCashLocationId,
      isDetailedMode: isDetailedMode,
    );
    if (!completenessResult.isValid) {
      errors.addAll(completenessResult.errors);
    }
    
    return QuickValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      amountValue: amountResult.amountValue,
    );
  }
  
  static _AmountValidationResult _validateAmount(String amountText) {
    if (amountText.isEmpty) {
      return _AmountValidationResult(
        isValid: false,
        errors: ['Please enter an amount'],
      );
    }
    
    final cleanAmount = amountText.replaceAll(',', '');
    final amount = double.tryParse(cleanAmount);
    
    if (amount == null) {
      return _AmountValidationResult(
        isValid: false,
        errors: ['Please enter a valid amount'],
      );
    }
    
    if (amount <= 0) {
      return _AmountValidationResult(
        isValid: false,
        errors: ['Amount must be greater than 0'],
      );
    }
    
    return _AmountValidationResult(
      isValid: true,
      errors: [],
      amountValue: amount,
    );
  }
  
  static _CompletenessValidationResult _validateCompleteness({
    required TemplateAnalysisResult analysis,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyCashLocationId,
    bool isDetailedMode = false,
  }) {
    final errors = <String>[];
    
    switch (analysis.completeness) {
      case TemplateCompleteness.complete:
        // No additional requirements
        break;
        
      case TemplateCompleteness.amountOnly:
        // Only amount needed, already validated above
        break;
        
      case TemplateCompleteness.essential:
        // Check essential requirements
        if (analysis.missingItems.contains('cash_location') && 
            selectedMyCashLocationId == null) {
          errors.add('Please select a cash location');
        }
        
        if (analysis.missingItems.contains('counterparty') && 
            selectedCounterpartyId == null) {
          errors.add('Please select a counterparty');
        }
        
        if (analysis.missingItems.contains('counterparty_cash_location') && 
            selectedCounterpartyCashLocationId == null) {
          errors.add('Please select counterparty cash location');
        }
        break;
        
      case TemplateCompleteness.complex:
        // For complex templates, require detailed mode
        if (!isDetailedMode) {
          errors.add('Complex templates require detailed mode');
        }
        break;
    }
    
    return _CompletenessValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
  
  /// Quick check if form can proceed (for real-time UI updates)
  static bool canProceed({
    required TemplateAnalysisResult analysis,
    required String amountText,
    String? selectedMyCashLocationId,
    String? selectedCounterpartyId,
    String? selectedCounterpartyCashLocationId,
    bool isDetailedMode = false,
  }) {
    final result = validate(
      analysis: analysis,
      amountText: amountText,
      selectedMyCashLocationId: selectedMyCashLocationId,
      selectedCounterpartyId: selectedCounterpartyId,
      selectedCounterpartyCashLocationId: selectedCounterpartyCashLocationId,
      isDetailedMode: isDetailedMode,
    );
    return result.isValid;
  }
}

class QuickValidationResult {
  final bool isValid;
  final List<String> errors;
  final double? amountValue;
  
  const QuickValidationResult({
    required this.isValid,
    required this.errors,
    this.amountValue,
  });
}

class _AmountValidationResult {
  final bool isValid;
  final List<String> errors;
  final double? amountValue;
  
  const _AmountValidationResult({
    required this.isValid,
    required this.errors,
    this.amountValue,
  });
}

class _CompletenessValidationResult {
  final bool isValid;
  final List<String> errors;
  
  const _CompletenessValidationResult({
    required this.isValid,
    required this.errors,
  });
}