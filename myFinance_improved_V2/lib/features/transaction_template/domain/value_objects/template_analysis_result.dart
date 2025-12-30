/// Template Analysis Result - Template readiness and complexity analysis
///
/// Purpose: Contains analysis results for template readiness assessment:
/// - Complexity level based on FormComplexity enum
/// - Missing fields count for UX optimization
/// - Estimated completion time for user guidance
/// - Missing items list for targeted assistance
///
/// Used by QuickStatusIndicator and EssentialSelectors for optimal UX.
/// Clean Architecture: DOMAIN LAYER - Value Object
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../enums/template_enums.dart';

class TemplateAnalysisResult extends Equatable {
  /// Template complexity level based on missing fields and configuration
  final FormComplexity complexity;
  
  /// Number of missing essential fields (excluding amount)
  final int missingFields;
  
  /// List of specific missing items that need user input
  final List<String> missingItems;
  
  /// Estimated time to complete the template setup
  final String estimatedTime;
  
  /// Whether the template is ready for immediate use
  final bool isReady;
  
  /// Template score (0-100) indicating completeness
  final int completenessScore;

  const TemplateAnalysisResult({
    required this.complexity,
    required this.missingFields,
    required this.missingItems,
    required this.estimatedTime,
    required this.isReady,
    required this.completenessScore,
  });

  /// Factory constructor for analyzing a template map
  ///
  /// 🔧 ENHANCED: Integrated legacy analyzer logic for more accurate analysis
  /// Analyzes template data structure to determine what fields are missing
  factory TemplateAnalysisResult.analyze(Map<String, dynamic> template) {
    final missingItems = <String>[];
    final data = template['data'] as List? ?? [];
    final tags = template['tags'] as Map? ?? {};

    // 1. Check if amount is templated (rare case)
    final hasTemplatedAmount = _hasTemplatedAmount(template);
    if (!hasTemplatedAmount) {
      missingItems.add('amount');
    }

    // 2. Check cash location requirements by analyzing data entries
    if (_needsCashLocationSelection(data, tags)) {
      missingItems.add('cash_location');
    }

    // 3. Check counterparty requirements (payable/receivable accounts)
    // - Internal counterparty (has linked_company_id): needs counterparty_cash_location
    // - External counterparty (no linked_company_id): only needs counterparty selection
    final counterpartyRequirements = _analyzeCounterpartyRequirements(data, template);
    if (counterpartyRequirements.needsCounterparty) {
      missingItems.add('counterparty');
    }
    if (counterpartyRequirements.needsCounterpartyCashLocation) {
      missingItems.add('counterparty_cash_location');
    }

    // 4. Check if debt configuration is needed
    if (_hasDebtAccounts(data)) {
      missingItems.add('debt_config');
    }

    // ✅ FIXED: Determine complexity based on missing items (following legacy logic)
    // Amount is always validated separately, so we focus on other requirements
    FormComplexity complexity;
    final missingFieldCount = missingItems.length;

    // Count non-amount missing fields for better complexity assessment
    final nonAmountMissingItems = missingItems.where((item) => item != 'amount').toList();
    final nonAmountMissingCount = nonAmountMissingItems.length;

    if (missingItems.contains('debt_config')) {
      // Templates requiring debt configuration are always complex
      complexity = FormComplexity.complex;
    } else if (nonAmountMissingCount == 0) {
      // No additional fields needed beyond amount
      complexity = FormComplexity.simple;
    } else if (nonAmountMissingCount == 1) {
      // One additional field needed
      if (nonAmountMissingItems.contains('cash_location')) {
        complexity = FormComplexity.withCash;
      } else if (nonAmountMissingItems.any((item) => item.contains('counterparty'))) {
        complexity = FormComplexity.withCounterparty;
      } else {
        complexity = FormComplexity.simple;
      }
    } else if (nonAmountMissingCount == 2 &&
               nonAmountMissingItems.any((item) => item.contains('counterparty'))) {
      // Counterparty + counterparty_cash_location
      complexity = FormComplexity.withCounterparty;
    } else {
      // Multiple fields or complex requirements
      complexity = FormComplexity.complex;
    }

    // Calculate metrics
    final isReady = missingFieldCount == 0 || (missingFieldCount == 1 && missingItems.contains('amount'));
    final completenessScore = ((4 - missingFieldCount) / 4 * 100).clamp(0, 100).toInt();

    // Determine estimated time
    String estimatedTime;
    if (missingFieldCount == 0) {
      estimatedTime = '1 tap';
    } else if (missingFieldCount == 1 && missingItems.contains('amount')) {
      estimatedTime = '5 seconds';
    } else if (missingFieldCount <= 2) {
      estimatedTime = '15 seconds';
    } else {
      estimatedTime = '30+ seconds';
    }

    return TemplateAnalysisResult(
      complexity: complexity,
      missingFields: missingFieldCount,
      missingItems: missingItems,
      estimatedTime: estimatedTime,
      isReady: isReady,
      completenessScore: completenessScore,
    );
  }

  /// Check if template has a fixed amount (rare case)
  static bool _hasTemplatedAmount(Map<String, dynamic> template) {
    final baseAmount = template['base_amount'];
    return baseAmount != null && baseAmount != 0;
  }

  /// Check if any cash account lacks cash_location_id
  /// Also checks for expense account transactions with cash accounts
  static bool _needsCashLocationSelection(List data, Map tags) {
    // Check for expense account with cash account combination
    // Expense accounts have account_code 5000-9999
    bool hasExpenseAccountWithCode = false;
    bool hasCashAccount = false;

    for (var entry in data) {
      final categoryTag = entry['category_tag'];
      final accountCode = entry['account_code']?.toString();

      // Check for expense account by account_code (5000-9999)
      if (accountCode != null && accountCode.isNotEmpty) {
        final code = int.tryParse(accountCode);
        if (code != null && code >= 5000 && code <= 9999) {
          hasExpenseAccountWithCode = true;
        }
      }

      // Check for cash account
      if (categoryTag == 'cash') {
        hasCashAccount = true;
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

    // NEW: If expense account (with account_code) + cash account, ALWAYS show cash location selector
    // This allows user to select where the cash comes from for expense transactions
    // Only applies when account_code exists (new templates), legacy templates without account_code are skipped
    //
    // IMPORTANT: Even if cash_location_id is already set in template, we still show the selector
    // because expense transactions often need different cash sources each time (e.g., different wallets)
    if (hasExpenseAccountWithCode && hasCashAccount) {
      return true;
    }

    return false;
  }

  /// Analyze counterparty requirements based on template data
  /// Returns what's needed: counterparty selection, counterparty_cash_location, or both
  static _CounterpartyRequirements _analyzeCounterpartyRequirements(
    List data,
    Map<String, dynamic> template,
  ) {
    bool needsCounterparty = false;
    bool needsCounterpartyCashLocation = false;

    for (var entry in data) {
      final categoryTag = entry['category_tag'];
      if (categoryTag == 'payable' || categoryTag == 'receivable') {
        // Check if counterparty is already set
        final counterpartyId = entry['counterparty_id'] ?? template['counterparty_id'];
        final hasCounterparty = counterpartyId != null &&
            counterpartyId.toString().isNotEmpty &&
            counterpartyId.toString() != 'none';

        // Check if this is an internal counterparty (has linked_company_id)
        final linkedCompanyId = entry['linked_company_id'];
        final isInternal = linkedCompanyId != null &&
            linkedCompanyId.toString().isNotEmpty &&
            linkedCompanyId.toString() != 'none';

        // Check if counterparty_cash_location is already set
        final entryCashLoc = entry['counterparty_cash_location_id'];
        final templateCashLoc = template['counterparty_cash_location_id'];
        final hasCounterpartyCashLocation = (entryCashLoc != null &&
                entryCashLoc.toString().isNotEmpty &&
                entryCashLoc.toString() != 'none') ||
            (templateCashLoc != null &&
                templateCashLoc.toString().isNotEmpty &&
                templateCashLoc.toString() != 'none');

        // Determine what's needed
        if (isInternal) {
          // Internal counterparty: locked, but may need cash location
          if (!hasCounterpartyCashLocation) {
            needsCounterpartyCashLocation = true;
          }
          // Internal counterparty is locked - don't show counterparty selector
        } else {
          // External counterparty: ALWAYS show selector so user can change it
          // Similar to cash_location - user may want to select different counterparty each time
          needsCounterparty = true;
          // External counterparty doesn't need counterparty_cash_location
        }
      }
    }

    return _CounterpartyRequirements(
      needsCounterparty: needsCounterparty,
      needsCounterpartyCashLocation: needsCounterpartyCashLocation,
    );
  }

  /// Check if template has debt accounts (payable/receivable)
  static bool _hasDebtAccounts(List data) {
    return data.any((entry) =>
        entry['category_tag'] == 'payable' || entry['category_tag'] == 'receivable',);
  }

  /// Factory constructor for simple analysis based on complexity only
  factory TemplateAnalysisResult.fromComplexity(FormComplexity complexity) {
    List<String> missingItems;
    int missingFields;
    String estimatedTime;
    
    switch (complexity) {
      case FormComplexity.simple:
        missingItems = [];
        missingFields = 0;
        estimatedTime = '< 10 seconds';
        break;
      case FormComplexity.withCash:
        missingItems = ['cash_location'];
        missingFields = 1;
        estimatedTime = '< 20 seconds';
        break;
      case FormComplexity.withCounterparty:
        missingItems = ['counterparty', 'counterparty_cash_location'];
        missingFields = 2;
        estimatedTime = '< 30 seconds';
        break;
      case FormComplexity.complex:
        missingItems = ['cash_location', 'counterparty', 'counterparty_cash_location'];
        missingFields = 3;
        estimatedTime = '1-2 minutes';
        break;
    }
    
    final isReady = missingFields == 0;
    final completenessScore = ((4 - missingFields) / 4 * 100).clamp(0, 100).toInt();
    
    return TemplateAnalysisResult(
      complexity: complexity,
      missingFields: missingFields,
      missingItems: missingItems,
      estimatedTime: estimatedTime,
      isReady: isReady,
      completenessScore: completenessScore,
    );
  }

  /// Gets UI display title based on complexity
  ///
  /// 🔧 ENHANCED: User-friendly guidance messages
  String get displayTitle {
    // Special case: amount-only templates
    if (missingItems.length == 1 && missingItems.contains('amount')) {
      return 'Just enter amount';
    }

    if (isReady) {
      return 'Ready for instant creation';
    }

    // Show number of fields needed for essential/complex templates
    if (missingFields > 0 && missingFields <= 3) {
      return 'Just enter these:';
    }

    switch (complexity) {
      case FormComplexity.simple:
        return 'Ready to create';
      case FormComplexity.withCash:
        return 'Just enter these:';
      case FormComplexity.withCounterparty:
        return 'Just enter these:';
      case FormComplexity.complex:
        return 'Complex setup required';
    }
  }

  /// Gets detailed description for UI
  String get detailedDescription {
    if (isReady) {
      return 'Template is complete and ready for transaction creation';
    }
    
    switch (complexity) {
      case FormComplexity.simple:
        return 'Just enter the amount to create transaction';
      case FormComplexity.withCash:
        return 'Select cash location to proceed';
      case FormComplexity.withCounterparty:
        return 'Select counterparty and location details';
      case FormComplexity.complex:
        return '$missingFields selections needed before use';
    }
  }

  /// Gets priority for UI sorting (higher = more ready)
  int get priority {
    switch (complexity) {
      case FormComplexity.simple:
        return 4;
      case FormComplexity.withCash:
        return 3;
      case FormComplexity.withCounterparty:
        return 2;
      case FormComplexity.complex:
        return 1;
    }
  }

  /// Checks if template needs specific type of input
  bool needsCashLocation() => missingItems.contains('cash_location');
  bool needsCounterparty() => missingItems.contains('counterparty');
  bool needsCounterpartyCashLocation() => missingItems.contains('counterparty_cash_location');

  // ═══════════════════════════════════════════════════════════════════════════
  // RPC Type Analysis - For Direct RPC Integration
  // Added for TEMPLATE_USAGE_REFACTORING_PLAN.md implementation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Determine RPC type from template data structure
  ///
  /// Analyzes the template's data entries to determine which RPC strategy
  /// should be used for transaction creation.
  ///
  /// Returns: TemplateRpcType enum value
  static TemplateRpcType determineRpcType(Map<String, dynamic> template) {
    _debugLog('┌─────────────────────────────────────────────────────────────');
    _debugLog('│ TemplateAnalysisResult.determineRpcType()');
    _debugLog('├─────────────────────────────────────────────────────────────');
    _debugLog('│ template name: ${template['name']}');
    _debugLog('│ template id: ${template['id']}');

    final data = template['data'] as List? ?? [];
    _debugLog('│ data entries: ${data.length}');

    if (data.isEmpty) {
      _debugLog('│ ❌ Empty data array');
      _debugLog('│ Result: unknown');
      _debugLog('└─────────────────────────────────────────────────────────────');
      return TemplateRpcType.unknown;
    }

    // Collect category tags from all entries
    final categoryTags = <String>{};
    bool hasLinkedCompanyId = false;
    bool hasCashAccount = false;
    bool hasExpenseOrRevenue = false;

    _debugLog('│ Analyzing entries:');
    for (var i = 0; i < data.length; i++) {
      final entry = data[i];
      final categoryTag = entry['category_tag']?.toString();
      final linkedCompanyId = entry['linked_company_id'];
      final accountCode = entry['account_code']?.toString();

      _debugLog('│   [$i] category_tag: $categoryTag, linked_company_id: $linkedCompanyId, account_code: $accountCode');

      if (categoryTag != null && categoryTag.isNotEmpty) {
        categoryTags.add(categoryTag);
      }

      // Check for linked_company_id (internal transfer marker)
      if (linkedCompanyId != null &&
          linkedCompanyId.toString().isNotEmpty &&
          linkedCompanyId.toString() != 'none') {
        hasLinkedCompanyId = true;
        _debugLog('│       → Found linked_company_id!');
      }

      // Check for cash account
      if (categoryTag == 'cash') {
        hasCashAccount = true;
      }

      // Check for expense/revenue by account_code range
      if (accountCode != null && accountCode.isNotEmpty) {
        final code = int.tryParse(accountCode);
        if (code != null) {
          // Revenue: 4000-4999, Expense: 5000-9999
          if ((code >= 4000 && code <= 4999) || (code >= 5000 && code <= 9999)) {
            hasExpenseOrRevenue = true;
            _debugLog('│       → Found expense/revenue account (code: $code)');
          }
        }
      }
    }

    _debugLog('│ Analysis summary:');
    _debugLog('│   categoryTags: $categoryTags');
    _debugLog('│   hasLinkedCompanyId: $hasLinkedCompanyId');
    _debugLog('│   hasCashAccount: $hasCashAccount');
    _debugLog('│   hasExpenseOrRevenue: $hasExpenseOrRevenue');

    // Decision tree for RPC type
    _debugLog('│ Decision tree:');

    // 1. Internal transfer: has linked_company_id
    if (hasLinkedCompanyId) {
      _debugLog('│   ✓ Check 1: hasLinkedCompanyId → internal');
      _debugLog('│ Result: internal');
      _debugLog('└─────────────────────────────────────────────────────────────');
      return TemplateRpcType.internal;
    }
    _debugLog('│   ✗ Check 1: no linked_company_id');

    // 2. External debt: has payable/receivable without linked_company_id
    if (categoryTags.contains('payable') || categoryTags.contains('receivable')) {
      _debugLog('│   ✓ Check 2: has payable/receivable → externalDebt');
      _debugLog('│ Result: externalDebt');
      _debugLog('└─────────────────────────────────────────────────────────────');
      return TemplateRpcType.externalDebt;
    }
    _debugLog('│   ✗ Check 2: no payable/receivable');

    // 3. Cash-to-Cash: only cash accounts (no expense/revenue)
    if (hasCashAccount && !hasExpenseOrRevenue) {
      // Check if ALL entries are cash
      final allCash = data.every((entry) => entry['category_tag'] == 'cash');
      _debugLog('│   Check 3: hasCashAccount && !hasExpenseOrRevenue, allCash=$allCash');
      if (allCash) {
        _debugLog('│   ✓ Check 3: all entries are cash → cashCash');
        _debugLog('│ Result: cashCash');
        _debugLog('└─────────────────────────────────────────────────────────────');
        return TemplateRpcType.cashCash;
      }
    }
    _debugLog('│   ✗ Check 3: not all cash');

    // 4. Expense/Revenue + Cash: has expense/revenue account with cash
    if (hasExpenseOrRevenue && hasCashAccount) {
      _debugLog('│   ✓ Check 4: hasExpenseOrRevenue && hasCashAccount → expenseRevenueCash');
      _debugLog('│ Result: expenseRevenueCash');
      _debugLog('└─────────────────────────────────────────────────────────────');
      return TemplateRpcType.expenseRevenueCash;
    }
    _debugLog('│   ✗ Check 4: no expense/revenue + cash combo');

    // 5. Unknown: cannot determine
    _debugLog('│ ❌ No matching pattern found');
    _debugLog('│ Result: unknown');
    _debugLog('└─────────────────────────────────────────────────────────────');
    return TemplateRpcType.unknown;
  }

  /// Debug logging helper (only prints in debug mode)
  static void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[TemplateAnalysisResult] $message');
    }
  }

  /// Creates a copy with updated analysis
  TemplateAnalysisResult copyWith({
    FormComplexity? complexity,
    int? missingFields,
    List<String>? missingItems,
    String? estimatedTime,
    bool? isReady,
    int? completenessScore,
  }) {
    return TemplateAnalysisResult(
      complexity: complexity ?? this.complexity,
      missingFields: missingFields ?? this.missingFields,
      missingItems: missingItems ?? this.missingItems,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isReady: isReady ?? this.isReady,
      completenessScore: completenessScore ?? this.completenessScore,
    );
  }

  @override
  List<Object?> get props => [
        complexity,
        missingFields,
        missingItems,
        estimatedTime,
        isReady,
        completenessScore,
      ];

  @override
  String toString() => 'TemplateAnalysisResult('
      'complexity: $complexity, '
      'missingFields: $missingFields, '
      'isReady: $isReady)';
}

/// Helper class for counterparty requirements analysis
class _CounterpartyRequirements {
  final bool needsCounterparty;
  final bool needsCounterpartyCashLocation;

  const _CounterpartyRequirements({
    required this.needsCounterparty,
    required this.needsCounterpartyCashLocation,
  });
}