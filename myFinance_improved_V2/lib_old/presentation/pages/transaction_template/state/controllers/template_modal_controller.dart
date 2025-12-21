/// Template Modal Controller - Smart routing between modal and page modes
///
/// Purpose: Automatically choose the best UI pattern based on template complexity:
/// - Simple templates → Modal bottom sheet for quick interactions
/// - Complex templates → Full page for better keyboard handling
/// - Adaptive strategy selection based on template analysis
/// - Integration with new business layer analyzers
/// - Consistent user experience across complexity levels
///
/// Usage: TemplateModalController.showTemplate(context, template)
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../business/analyzers/template_analyzer.dart';

enum TemplateModalStrategy {
  modal,        // Use modal bottom sheet
  page,         // Use full page
  adaptive,     // Choose automatically based on complexity
}

class TemplateModalController {
  /// Show template interface with smart strategy selection
  static Future<bool?> showTemplate({
    required BuildContext context,
    required Map<String, dynamic> template,
    TemplateModalStrategy strategy = TemplateModalStrategy.adaptive,
    bool isQuickMode = false,
  }) async {
    // Analyze template complexity using business layer
    final complexity = _analyzeTemplateComplexity(template);
    final shouldUsePage = _shouldUsePage(complexity, strategy);
    
    if (shouldUsePage) {
      // Use full page for better keyboard handling and complex interactions
      return await context.push<bool>(
        '/template-usage',
        extra: {'template': template, 'isQuick': isQuickMode},
      );
    } else {
      // Use modal for simple templates with quick interactions
      if (isQuickMode) {
        return await _showQuickTemplateBottomSheet(context, template);
      } else {
        return await _showTemplateUsageBottomSheet(context, template);
      }
    }
  }

  /// Analyze template complexity using business layer analyzers
  static TemplateComplexityScore _analyzeTemplateComplexity(Map<String, dynamic> template) {
    // Use the business layer template analyzer
    final requirements = TemplateFormAnalyzer.analyzeTemplate(template);
    int complexityScore = 0;
    List<String> complexityFactors = [];

    // Analyze various complexity factors based on requirements
    if (requirements.needsCounterparty) {
      complexityScore += 2;
      complexityFactors.add('counterparty_selection');
    }

    if (requirements.needsMyCashLocation) {
      complexityScore += 1;
      complexityFactors.add('cash_location_selection');
    }

    if (requirements.needsCounterpartyCashLocation) {
      complexityScore += 2;
      complexityFactors.add('counterparty_cash_location');
    }

    if (requirements.hasPayableReceivable) {
      complexityScore += 3;
      complexityFactors.add('debt_configuration');
    }

    // Analyze template structure
    final data = template['data'] as List? ?? [];
    if (data.length > 2) {
      complexityScore += 1;
      complexityFactors.add('multiple_entries');
    }

    // Check for multiple account types
    final accountTypes = data.map((e) => e['category_tag']).toSet();
    if (accountTypes.length > 2) {
      complexityScore += 1;
      complexityFactors.add('mixed_account_types');
    }

    // Check for complex counterparty requirements
    final hasComplexCounterparty = data.any((entry) => 
      entry['counterparty_id'] != null && 
      entry['counterparty_cash_location_id'] != null
    );
    if (hasComplexCounterparty) {
      complexityScore += 2;
      complexityFactors.add('complex_counterparty_setup');
    }

    // Check for mixed visibility or permissions
    final visibilityLevel = template['visibility_level'] as String?;
    if (visibilityLevel == 'private') {
      complexityScore += 1;
      complexityFactors.add('private_template');
    }

    return TemplateComplexityScore(
      score: complexityScore,
      factors: complexityFactors,
      level: _getComplexityLevel(complexityScore),
    );
  }

  /// Determine complexity level from score
  static ComplexityLevel _getComplexityLevel(int score) {
    if (score == 0) return ComplexityLevel.simple;
    if (score <= 2) return ComplexityLevel.moderate;
    if (score <= 4) return ComplexityLevel.complex;
    return ComplexityLevel.veryComplex;
  }

  /// Determine if page mode should be used based on complexity and strategy
  static bool _shouldUsePage(TemplateComplexityScore complexity, TemplateModalStrategy strategy) {
    switch (strategy) {
      case TemplateModalStrategy.modal:
        return false;
      case TemplateModalStrategy.page:
        return true;
      case TemplateModalStrategy.adaptive:
        // Use page for complex templates or when keyboard-heavy
        return complexity.level.index >= ComplexityLevel.complex.index ||
               complexity.factors.contains('debt_configuration') ||
               complexity.factors.contains('counterparty_cash_location') ||
               complexity.factors.contains('complex_counterparty_setup');
    }
  }

  /// Show quick template bottom sheet
  static Future<bool?> _showQuickTemplateBottomSheet(
    BuildContext context, 
    Map<String, dynamic> template,
  ) async {
    // TODO: Implement QuickTemplateBottomSheet.show when UI components are migrated
    // For now, fallback to page mode
    return await context.push<bool>(
      '/template-usage',
      extra: {'template': template, 'isQuick': true},
    );
  }

  /// Show template usage bottom sheet
  static Future<bool?> _showTemplateUsageBottomSheet(
    BuildContext context, 
    Map<String, dynamic> template,
  ) async {
    // TODO: Implement TemplateUsageBottomSheet.show when UI components are migrated
    // For now, fallback to page mode
    return await context.push<bool>(
      '/template-usage',
      extra: {'template': template, 'isQuick': false},
    );
  }

  /// Analyze template for quick mode suitability
  static bool isTemplateQuickModeReady(Map<String, dynamic> template) {
    final complexity = _analyzeTemplateComplexity(template);
    
    // Quick mode is suitable for simple to moderate complexity templates
    return complexity.level.index <= ComplexityLevel.moderate.index &&
           !complexity.factors.contains('debt_configuration') &&
           !complexity.factors.contains('complex_counterparty_setup');
  }

  /// Get complexity summary for UI display
  static String getComplexitySummary(Map<String, dynamic> template) {
    final complexity = _analyzeTemplateComplexity(template);
    
    switch (complexity.level) {
      case ComplexityLevel.simple:
        return 'Simple: Amount only';
      case ComplexityLevel.moderate:
        return 'Moderate: ${complexity.factors.length} selections needed';
      case ComplexityLevel.complex:
        return 'Complex: ${complexity.factors.length} configuration steps';
      case ComplexityLevel.veryComplex:
        return 'Advanced: Multi-step setup required';
    }
  }

  /// Get recommended interaction mode for template
  static String getRecommendedMode(Map<String, dynamic> template) {
    final complexity = _analyzeTemplateComplexity(template);
    final shouldUsePage = _shouldUsePage(complexity, TemplateModalStrategy.adaptive);
    
    if (shouldUsePage) {
      return 'Full page (better for complex setup)';
    } else {
      return 'Quick modal (simple interaction)';
    }
  }
}

/// Template complexity scoring system
class TemplateComplexityScore {
  final int score;
  final List<String> factors;
  final ComplexityLevel level;

  TemplateComplexityScore({
    required this.score,
    required this.factors,
    required this.level,
  });

  /// Get user-friendly description of complexity factors
  String get factorsDescription {
    if (factors.isEmpty) return 'No additional setup required';
    
    final friendlyFactors = factors.map((factor) {
      switch (factor) {
        case 'counterparty_selection':
          return 'counterparty selection';
        case 'cash_location_selection':
          return 'cash location';
        case 'counterparty_cash_location':
          return 'counterparty cash location';
        case 'debt_configuration':
          return 'debt/payment setup';
        case 'multiple_entries':
          return 'multiple transaction entries';
        case 'mixed_account_types':
          return 'mixed account types';
        case 'complex_counterparty_setup':
          return 'complex counterparty configuration';
        case 'private_template':
          return 'private template';
        default:
          return factor.replaceAll('_', ' ');
      }
    }).toList();

    if (friendlyFactors.length == 1) {
      return 'Requires ${friendlyFactors.first}';
    } else if (friendlyFactors.length == 2) {
      return 'Requires ${friendlyFactors.join(' and ')}';
    } else {
      final lastFactor = friendlyFactors.removeLast();
      return 'Requires ${friendlyFactors.join(', ')}, and $lastFactor';
    }
  }

  /// Check if template has specific complexity factor
  bool hasFactor(String factor) => factors.contains(factor);

  /// Get estimated time to complete
  String get estimatedTime {
    switch (level) {
      case ComplexityLevel.simple:
        return '< 30 seconds';
      case ComplexityLevel.moderate:
        return '1-2 minutes';
      case ComplexityLevel.complex:
        return '2-5 minutes';
      case ComplexityLevel.veryComplex:
        return '5+ minutes';
    }
  }
}

/// Template complexity levels
enum ComplexityLevel {
  simple,      // 0: Just amount needed
  moderate,    // 1-2: Basic selections
  complex,     // 3-4: Multiple selections + debt
  veryComplex, // 5+: Complex multi-step setup
}

/// Extension for complexity level utilities
extension ComplexityLevelExtension on ComplexityLevel {
  /// Get user-friendly name
  String get displayName {
    switch (this) {
      case ComplexityLevel.simple:
        return 'Simple';
      case ComplexityLevel.moderate:
        return 'Moderate';
      case ComplexityLevel.complex:
        return 'Complex';
      case ComplexityLevel.veryComplex:
        return 'Very Complex';
    }
  }

  /// Get color indicator for UI
  Color get indicatorColor {
    switch (this) {
      case ComplexityLevel.simple:
        return const Color(0xFF4CAF50); // Green
      case ComplexityLevel.moderate:
        return const Color(0xFF2196F3); // Blue
      case ComplexityLevel.complex:
        return const Color(0xFFFF9800); // Orange
      case ComplexityLevel.veryComplex:
        return const Color(0xFFF44336); // Red
    }
  }

  /// Check if complexity requires full page mode
  bool get requiresPageMode => index >= ComplexityLevel.complex.index;
}