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
import 'package:equatable/equatable.dart';
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
    if (_needsCounterpartySelection(data, template)) {
      missingItems.add('counterparty');
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
  static bool _needsCashLocationSelection(List data, Map tags) {
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

  /// Check for payable/receivable without counterparty cash location
  static bool _needsCounterpartySelection(List data, Map<String, dynamic> template) {
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

  /// Check if template has debt accounts (payable/receivable)
  static bool _hasDebtAccounts(List data) {
    return data.any((entry) =>
        entry['category_tag'] == 'payable' || entry['category_tag'] == 'receivable');
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