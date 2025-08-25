
/// Template completeness levels for optimal UX
enum TemplateCompleteness {
  complete,      // One-click creation ⚡
  amountOnly,    // Amount + Create 💰
  essential,     // 1-2 key selections 🎯
  complex        // Full form needed 📋
}

/// Quick template analysis for speed optimization
class QuickTemplateAnalyzer {
  static TemplateAnalysisResult analyze(Map<String, dynamic> template) {
    final result = TemplateAnalysisResult();
    final data = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};
    
    // Check what's missing
    int missingFields = 0;
    final List<String> missingItems = [];
    
    // 1. Check if amount is templated (rare)
    final hasTemplatedAmount = _hasTemplatedAmount(template);
    if (!hasTemplatedAmount) {
      missingFields++;
      missingItems.add('amount');
    }
    
    // 2. Check cash location requirements
    if (_needsCashLocationSelection(data, tags)) {
      missingFields++;
      missingItems.add('cash_location');
    }
    
    // 3. Check counterparty requirements  
    if (_needsCounterpartySelection(data, template)) {
      missingFields++;
      missingItems.add('counterparty_cash_location');
    }
    
    // 4. Check if debt configuration needed
    if (_hasDebtAccounts(data)) {
      missingFields++;
      missingItems.add('debt_config');
    }
    
    // Determine completeness level
    result.completeness = _determineCompleteness(missingFields, missingItems);
    result.missingFields = missingFields;
    result.missingItems = missingItems;
    result.quickActionText = _getQuickActionText(result.completeness);
    result.estimatedTime = _getEstimatedTime(result.completeness);
    
    return result;
  }
  
  static bool _hasTemplatedAmount(Map<String, dynamic> template) {
    // Check if template has a fixed amount (rare case)
    final baseAmount = template['base_amount'];
    return baseAmount != null && baseAmount != 0;
  }
  
  static bool _needsCashLocationSelection(List data, Map tags) {
    // Check if any cash account lacks cash_location_id
    for (var entry in data) {
      if (entry['category_tag'] == 'cash') {
        final cashLocationId = entry['cash_location_id'];
        if (cashLocationId == null || cashLocationId == '' || cashLocationId == 'none') {
          // Check if pre-selected in tags
          final tagsCashLocations = tags['cash_locations'] as List? ?? [];
          final hasPreselected = tagsCashLocations.isNotEmpty && 
              tagsCashLocations.first != null && 
              tagsCashLocations.first != 'none';
          if (!hasPreselected) return true;
        }
      }
    }
    return false;
  }
  
  static bool _needsCounterpartySelection(List data, Map<String, dynamic> template) {
    // Check for payable/receivable without counterparty cash location
    for (var entry in data) {
      final categoryTag = entry['category_tag'];
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        final entryCashLoc = entry['counterparty_cash_location_id'];
        final templateCashLoc = template['counterparty_cash_location_id'];
        
        if ((entryCashLoc == null || entryCashLoc == '' || entryCashLoc == 'none') && 
            (templateCashLoc == null || templateCashLoc == '' || templateCashLoc == 'none')) {
          return true;
        }
      }
    }
    return false;
  }
  
  static bool _hasDebtAccounts(List data) {
    return data.any((entry) => 
      entry['category_tag'] == 'payable' || entry['category_tag'] == 'receivable');
  }
  
  static TemplateCompleteness _determineCompleteness(int missing, List<String> items) {
    if (missing == 0) return TemplateCompleteness.complete;
    if (missing == 1 && items.contains('amount')) return TemplateCompleteness.amountOnly;
    if (missing <= 2 && !items.contains('debt_config')) return TemplateCompleteness.essential;
    return TemplateCompleteness.complex;
  }
  
  static String _getQuickActionText(TemplateCompleteness level) {
    switch (level) {
      case TemplateCompleteness.complete:
        return 'Create Now ⚡';
      case TemplateCompleteness.amountOnly:
        return 'Enter Amount & Create 💰';
      case TemplateCompleteness.essential:
        return 'Quick Setup 🎯';
      case TemplateCompleteness.complex:
        return 'Full Setup 📋';
    }
  }
  
  static String _getEstimatedTime(TemplateCompleteness level) {
    switch (level) {
      case TemplateCompleteness.complete:
        return '1 tap';
      case TemplateCompleteness.amountOnly:
        return '5 seconds';
      case TemplateCompleteness.essential:
        return '15 seconds';
      case TemplateCompleteness.complex:
        return '30+ seconds';
    }
  }
}

/// Analysis result for template completeness
class TemplateAnalysisResult {
  TemplateCompleteness completeness = TemplateCompleteness.complex;
  int missingFields = 0;
  List<String> missingItems = [];
  String quickActionText = '';
  String estimatedTime = '';
  
  bool get isQuickEligible => 
    completeness == TemplateCompleteness.complete || 
    completeness == TemplateCompleteness.amountOnly;
    
  bool get needsEssentialSetup => 
    completeness == TemplateCompleteness.essential;
    
  bool get needsFullSetup => 
    completeness == TemplateCompleteness.complex;
}