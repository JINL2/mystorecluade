/// Template Modal Controller - Smart routing between modal and page modes
///
/// Purpose: Automatically choose the best UI pattern based on template complexity
/// Simple templates → Modal, Complex templates → Full page
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modals/template_usage_bottom_sheet.dart';
import '../modals/quick_template_bottom_sheet.dart';
import '../pages/template_usage_page.dart';
import '../../shared/services/template_analyzer.dart';

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
    // Analyze template complexity
    final complexity = _analyzeTemplateComplexity(template);
    final shouldUsePage = _shouldUsePage(complexity, strategy);
    
    if (shouldUsePage) {
      // Use full page for better keyboard handling
      return await context.push<bool>(
        '/template-usage',
        extra: {'template': template, 'isQuick': isQuickMode},
      );
    } else {
      // Use modal for simple templates
      if (isQuickMode) {
        return await QuickTemplateBottomSheet.show(context, template);
      } else {
        return await TemplateUsageBottomSheet.show(context, template);
      }
    }
  }

  static TemplateComplexityScore _analyzeTemplateComplexity(Map<String, dynamic> template) {
    final requirements = TemplateFormAnalyzer.analyzeTemplate(template);
    int complexityScore = 0;
    List<String> complexityFactors = [];

    // Analyze various complexity factors
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

    return TemplateComplexityScore(
      score: complexityScore,
      factors: complexityFactors,
      level: _getComplexityLevel(complexityScore),
    );
  }

  static ComplexityLevel _getComplexityLevel(int score) {
    if (score == 0) return ComplexityLevel.simple;
    if (score <= 2) return ComplexityLevel.moderate;
    if (score <= 4) return ComplexityLevel.complex;
    return ComplexityLevel.veryComplex;
  }

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
               complexity.factors.contains('counterparty_cash_location');
    }
  }
}

class TemplateComplexityScore {
  final int score;
  final List<String> factors;
  final ComplexityLevel level;

  TemplateComplexityScore({
    required this.score,
    required this.factors,
    required this.level,
  });
}

enum ComplexityLevel {
  simple,      // 0: Just amount needed
  moderate,    // 1-2: Basic selections
  complex,     // 3-4: Multiple selections + debt
  veryComplex, // 5+: Complex multi-step setup
}

/// Usage examples:
/// 
/// // Automatic strategy selection
/// TemplateModalController.showTemplate(
///   context: context,
///   template: template,
/// );
/// 
/// // Force page mode
/// TemplateModalController.showTemplate(
///   context: context,
///   template: template,
///   strategy: TemplateModalStrategy.page,
/// );
/// 
/// // Quick mode with auto-strategy
/// TemplateModalController.showTemplate(
///   context: context,
///   template: template,
///   isQuickMode: true,
/// );