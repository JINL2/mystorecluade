/// Template Form Analyzer Service
/// Extracted from template_usage_bottom_sheet.dart for proper separation of concerns

// Form complexity levels
enum FormComplexity {
  simple,        // Only amount input needed
  withCash,      // Need cash location selection
  withCounterparty, // Need counterparty's cash location
  complex        // Multiple selections needed
}

// Template form requirements analysis
class TemplateFormRequirements {
  bool hasPayableReceivable = false;
  bool hasCash = false;
  bool needsCounterparty = false;
  bool needsCounterpartyCashLocation = false;
  bool needsMyCashLocation = false;
  bool needsExchangeRate = false;
  FormComplexity complexity = FormComplexity.simple;
  
  bool get isSimple => complexity == FormComplexity.simple;
  bool get needsSelectors => complexity != FormComplexity.simple;
}

/// Template analyzer to determine form requirements
/// This service analyzes template data to determine what form fields are needed
class TemplateFormAnalyzer {
  /// Analyzes a template to determine what form requirements are needed
  static TemplateFormRequirements analyzeTemplate(Map<String, dynamic> template) {
    final requirements = TemplateFormRequirements();
    final data = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};
    
    // Check if we have pre-selected MY cash locations in tags
    final tagsCashLocations = tags['cash_locations'] as List? ?? [];
    final hasPreselectedMyCashLocation = tagsCashLocations.isNotEmpty && 
        tagsCashLocations.first != null && 
        tagsCashLocations.first != 'none' &&
        tagsCashLocations.first != '';
    
    // Analyze transaction type to determine what's needed
    int debitCashCount = 0;
    int creditCashCount = 0;
    bool hasPayableOrReceivable = false;
    
    for (var entry in data) {
      final categoryTag = entry['category_tag'] as String?;
      final transactionType = entry['type'] as String?; // 'debit' or 'credit'
      
      // Count cash accounts on each side
      if (categoryTag == 'cash') {
        requirements.hasCash = true;
        if (transactionType == 'debit') {
          debitCashCount++;
        } else if (transactionType == 'credit') {
          creditCashCount++;
        }
        
        // Check if MY cash location is missing for this cash account
        if ((entry['cash_location_id'] == null || 
             entry['cash_location_id'] == '' ||
             entry['cash_location_id'] == 'none') &&
            !hasPreselectedMyCashLocation) {
          requirements.needsMyCashLocation = true;
        }
      }
      
      // Check for payable/receivable accounts
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        requirements.hasPayableReceivable = true;
        hasPayableOrReceivable = true;
        
        // Check if counterparty info is missing
        if (entry['counterparty_id'] == null && template['counterparty_id'] == null) {
          requirements.needsCounterparty = true;
        }
      }
    }
    
    // Determine if we need counterparty cash location
    // ONLY for Cash-to-Cash transfers (both sides have cash accounts)
    // NOT for Receivable/Payable to/from Cash transactions
    if (debitCashCount > 0 && creditCashCount > 0 && !hasPayableOrReceivable) {
      // This is a pure cash-to-cash transfer
      // Check if counterparty cash location is missing
      final templateCounterpartyCashLoc = template['counterparty_cash_location_id'];
      if (templateCounterpartyCashLoc == null || 
          templateCounterpartyCashLoc == '' || 
          templateCounterpartyCashLoc == 'none') {
        // Check if this is an internal counterparty (only internal transfers need cash location)
        final counterpartyId = template['counterparty_id'];
        if (counterpartyId != null) {
          // We'll need to check if it's internal when building the form
          // For now, assume we might need it
          requirements.needsCounterpartyCashLocation = true;
        }
      }
    }
    
    // Determine overall form complexity
    requirements.complexity = _calculateComplexity(requirements);
    
    return requirements;
  }
  
  static FormComplexity _calculateComplexity(TemplateFormRequirements req) {
    int missingFields = 0;
    
    if (req.needsCounterparty) missingFields++;
    if (req.needsCounterpartyCashLocation) missingFields++;
    if (req.needsMyCashLocation) missingFields++;
    
    if (missingFields == 0) return FormComplexity.simple;
    if (missingFields == 1) {
      if (req.needsMyCashLocation) return FormComplexity.withCash;
      return FormComplexity.withCounterparty;
    }
    return FormComplexity.complex;
  }
  
  /// Validates template data structure
  static bool isValidTemplate(Map<String, dynamic> template) {
    // Basic validation
    if (template['name'] == null || template['name'].toString().isEmpty) {
      return false;
    }
    
    final data = template['data'] as List? ?? [];
    if (data.isEmpty) {
      return false;
    }
    
    // Validate each entry has required fields
    for (final entry in data) {
      final entryMap = entry as Map<String, dynamic>;
      if (entryMap['account_id'] == null || entryMap['account_id'].toString().isEmpty) {
        return false;
      }
      if (entryMap['type'] == null || entryMap['type'].toString().isEmpty) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Gets template complexity score for UI decisions
  static int getComplexityScore(Map<String, dynamic> template) {
    final requirements = analyzeTemplate(template);
    int score = 0;
    
    if (requirements.needsCounterparty) score += 2;
    if (requirements.needsMyCashLocation) score += 1;
    if (requirements.needsCounterpartyCashLocation) score += 2;
    if (requirements.hasPayableReceivable) score += 3;
    if (requirements.needsExchangeRate) score += 2;
    
    final data = template['data'] as List? ?? [];
    if (data.length > 2) score += 1;
    
    return score;
  }
}