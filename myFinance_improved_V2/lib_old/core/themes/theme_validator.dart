import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'toss_colors.dart';
import 'toss_text_styles.dart';
import 'toss_border_radius.dart';
import 'theme_compatibility.dart';
import 'package:myfinance_improved/core/themes/index.dart';

/// Theme validator for runtime consistency checking
class ThemeValidator {
  static final ThemeValidator _instance = ThemeValidator._internal();
  
  factory ThemeValidator() => _instance;
  
  ThemeValidator._internal();
  
  /// Track validation results
  final List<ValidationIssue> _issues = [];
  final Map<String, int> _issueCount = {
    'color': 0,
    'text': 0,
    'spacing': 0,
    'radius': 0,
  };
  
  /// Validation configuration
  bool _isEnabled = !kReleaseMode; // Only in debug/profile
  bool _throwOnError = false;
  bool _logIssues = true;
  
  /// Get current issues
  List<ValidationIssue> get issues => List.unmodifiable(_issues);
  Map<String, int> get issueCount => Map.unmodifiable(_issueCount);
  
  /// Configure validator
  void configure({
    bool? enabled,
    bool? throwOnError,
    bool? logIssues,
  }) {
    _isEnabled = enabled ?? _isEnabled;
    _throwOnError = throwOnError ?? _throwOnError;
    _logIssues = logIssues ?? _logIssues;
  }
  
  /// Clear all issues
  void clearIssues() {
    _issues.clear();
    _issueCount.updateAll((key, value) => 0);
  }
  
  /// Validate a widget tree
  void validateWidget(Widget widget, {String? filePath, int? lineNumber}) {
    if (!_isEnabled) return;
    
    try {
      _validateWidgetRecursive(widget, filePath, lineNumber, 0);
    } catch (e) {
      if (_logIssues) {
        debugPrint('Theme validation error: $e');
      }
    }
  }
  
  /// Recursively validate widget tree
  void _validateWidgetRecursive(
    Widget widget,
    String? filePath,
    int? lineNumber,
    int depth,
  ) {
    if (depth > 50) return; // Prevent infinite recursion
    
    // Check specific widget types
    if (widget is Container) {
      _validateContainer(widget, filePath, lineNumber);
    } else if (widget is Text) {
      _validateText(widget, filePath, lineNumber);
    } else if (widget is Padding) {
      _validatePadding(widget, filePath, lineNumber);
    } else if (widget is DecoratedBox) {
      // Skip DecoratedBox validation for now
      // Could add: _validateDecoratedBox(widget, filePath, lineNumber);
    } else if (widget is Card) {
      _validateCard(widget, filePath, lineNumber);
    } else if (widget is ElevatedButton) {
      _validateElevatedButton(widget, filePath, lineNumber);
    } else if (widget is OutlinedButton) {
      _validateOutlinedButton(widget, filePath, lineNumber);
    } else if (widget is TextButton) {
      _validateTextButton(widget, filePath, lineNumber);
    } else if (widget is TextField) {
      _validateTextField(widget, filePath, lineNumber);
    } else if (widget is TextFormField) {
      _validateTextFormField(widget, filePath, lineNumber);
    }
    
    // Check children recursively
    if (widget is SingleChildRenderObjectWidget) {
      final child = (widget as dynamic).child;
      if (child != null && child is Widget) {
        _validateWidgetRecursive(child, filePath, lineNumber, depth + 1);
      }
    } else if (widget is MultiChildRenderObjectWidget) {
      final children = (widget as dynamic).children;
      if (children != null && children is List<Widget>) {
        for (final child in children) {
          _validateWidgetRecursive(child, filePath, lineNumber, depth + 1);
        }
      }
    }
  }
  
  /// Validate Container widget
  void _validateContainer(Container container, String? filePath, int? lineNumber) {
    final decoration = container.decoration;
    
    // Check color
    if (container.color != null) {
      _validateColor(container.color!, 'Container.color', filePath, lineNumber);
    }
    
    // Check padding
    if (container.padding != null && container.padding is EdgeInsets) {
      _validateEdgeInsets(container.padding! as EdgeInsets, 'Container.padding', filePath, lineNumber);
    }
    
    // Check margin
    if (container.margin != null && container.margin is EdgeInsets) {
      _validateEdgeInsets(container.margin! as EdgeInsets, 'Container.margin', filePath, lineNumber);
    }
    
    // Check decoration
    if (decoration is BoxDecoration) {
      _validateBoxDecoration(decoration, filePath, lineNumber);
    }
  }
  
  /// Validate BoxDecoration
  void _validateBoxDecoration(BoxDecoration decoration, String? filePath, int? lineNumber) {
    // Check color
    if (decoration.color != null) {
      _validateColor(decoration.color!, 'BoxDecoration.color', filePath, lineNumber);
    }
    
    // Check border radius
    if (decoration.borderRadius is BorderRadius) {
      _validateBorderRadius(
        decoration.borderRadius! as BorderRadius,
        'BoxDecoration.borderRadius',
        filePath,
        lineNumber,
      );
    }
    
    // Check border
    if (decoration.border is Border) {
      final border = decoration.border! as Border;
      if (border.top.color != TossColors.transparent) {
        _validateColor(border.top.color, 'Border.color', filePath, lineNumber);
      }
    }
  }
  
  /// Validate Text widget
  void _validateText(Text text, String? filePath, int? lineNumber) {
    if (text.style != null) {
      _validateTextStyle(text.style!, 'Text.style', filePath, lineNumber);
    }
  }
  
  /// Validate TextStyle
  void _validateTextStyle(TextStyle style, String location, String? filePath, int? lineNumber) {
    // Check if it's using hardcoded values
    bool isHardcoded = false;
    String suggestion = '';
    
    // Check font size
    if (style.fontSize != null) {
      final fontSize = style.fontSize!;
      final suggestedStyle = _suggestTextStyle(fontSize, style.fontWeight);
      if (suggestedStyle != null) {
        isHardcoded = true;
        suggestion = 'Use $suggestedStyle instead of fontSize: $fontSize';
      }
    }
    
    // Check color
    if (style.color != null) {
      if (!ThemeCompatibility.isThemeColor(style.color!)) {
        final colorSuggestion = _suggestColor(style.color!);
        if (colorSuggestion != null) {
          _reportIssue(
            type: 'color',
            location: '$location.color',
            currentValue: style.color.toString(),
            suggestedValue: colorSuggestion,
            filePath: filePath,
            lineNumber: lineNumber,
          );
        }
      }
    }
    
    if (isHardcoded) {
      _reportIssue(
        type: 'text',
        location: location,
        currentValue: 'TextStyle with hardcoded values',
        suggestedValue: suggestion,
        filePath: filePath,
        lineNumber: lineNumber,
      );
    }
  }
  
  /// Validate Padding widget
  void _validatePadding(Padding padding, String? filePath, int? lineNumber) {
    if (padding.padding is EdgeInsets) {
      _validateEdgeInsets(padding.padding as EdgeInsets, 'Padding', filePath, lineNumber);
    }
  }
  
  /// Validate EdgeInsets
  void _validateEdgeInsets(EdgeInsets insets, String location, String? filePath, int? lineNumber) {
    // Check if values align with 4px grid
    final values = [insets.left, insets.top, insets.right, insets.bottom];
    
    for (final value in values) {
      if (value % 4 != 0) {
        _reportIssue(
          type: 'spacing',
          location: location,
          currentValue: 'EdgeInsets with non-grid value: $value',
          suggestedValue: 'Use TossSpacing values (4px grid)',
          filePath: filePath,
          lineNumber: lineNumber,
        );
        break;
      }
    }
  }
  
  /// Validate BorderRadius
  void _validateBorderRadius(BorderRadius radius, String location, String? filePath, int? lineNumber) {
    // Get the radius value (assuming circular)
    if (radius is BorderRadius) {
      final topLeft = radius.topLeft.x;
      if (!_isStandardRadius(topLeft)) {
        _reportIssue(
          type: 'radius',
          location: location,
          currentValue: 'BorderRadius.circular($topLeft)',
          suggestedValue: _suggestBorderRadius(topLeft) ?? 'Use TossBorderRadius constants',
          filePath: filePath,
          lineNumber: lineNumber,
        );
      }
    }
  }
  
  /// Validate Card widget
  void _validateCard(Card card, String? filePath, int? lineNumber) {
    if (card.color != null) {
      _validateColor(card.color!, 'Card.color', filePath, lineNumber);
    }
    
    if (card.elevation != null && card.elevation! > 0) {
      // Toss uses minimal shadows
      if (card.elevation! > 4) {
        _reportIssue(
          type: 'shadow',
          location: 'Card.elevation',
          currentValue: 'elevation: ${card.elevation}',
          suggestedValue: 'Use TossShadows.card (minimal elevation)',
          filePath: filePath,
          lineNumber: lineNumber,
        );
      }
    }
  }
  
  /// Validate button widgets
  void _validateElevatedButton(ElevatedButton button, String? filePath, int? lineNumber) {
    // Check style
    if (button.style != null) {
      final style = button.style!;
      // Would check background color, padding, etc.
    }
  }
  
  void _validateOutlinedButton(OutlinedButton button, String? filePath, int? lineNumber) {
    // Similar validation
  }
  
  void _validateTextButton(TextButton button, String? filePath, int? lineNumber) {
    // Similar validation
  }
  
  /// Validate TextField
  void _validateTextField(TextField field, String? filePath, int? lineNumber) {
    if (field.style != null) {
      _validateTextStyle(field.style!, 'TextField.style', filePath, lineNumber);
    }
  }
  
  /// Validate TextFormField
  void _validateTextFormField(TextFormField field, String? filePath, int? lineNumber) {
    // TextFormField doesn't have a style property directly accessible
    // It would need to be accessed through decoration.labelStyle etc.
  }
  
  /// Validate color
  void _validateColor(Color color, String location, String? filePath, int? lineNumber) {
    if (!ThemeCompatibility.isThemeColor(color)) {
      final suggestion = _suggestColor(color);
      if (suggestion != null) {
        _reportIssue(
          type: 'color',
          location: location,
          currentValue: color.toString(),
          suggestedValue: suggestion,
          filePath: filePath,
          lineNumber: lineNumber,
        );
      }
    }
  }
  
  /// Check if radius is standard
  bool _isStandardRadius(double radius) {
    return radius == TossBorderRadius.none ||
           radius == TossBorderRadius.xs ||
           radius == TossBorderRadius.sm ||
           radius == TossBorderRadius.md ||
           radius == TossBorderRadius.lg ||
           radius == TossBorderRadius.xl ||
           radius == TossBorderRadius.xxl ||
           radius == TossBorderRadius.xxxl ||
           radius == TossBorderRadius.full;
  }
  
  /// Suggest color replacement
  String? _suggestColor(Color color) {
    if (color == TossColors.primary) return 'TossColors.primary';
    if (color == TossColors.error) return 'TossColors.error';
    if (color == TossColors.success) return 'TossColors.success';
    if (color == TossColors.warning) return 'TossColors.warning';
    if (color == TossColors.gray500) return 'TossColors.gray500';
    if (color == TossColors.white) return 'TossColors.white';
    if (color == TossColors.black) return 'TossColors.black';
    
    // Check by value
    final colorValue = color.value;
    if (colorValue == 0xFF0064FF) return 'TossColors.primary';
    if (colorValue == 0xFFFFFFFF) return 'TossColors.white';
    if (colorValue == 0xFF000000) return 'TossColors.black';
    
    return null;
  }
  
  /// Suggest text style replacement
  String? _suggestTextStyle(double fontSize, FontWeight? fontWeight) {
    if (fontSize >= 32) return 'TossTextStyles.display';
    if (fontSize >= 28) return 'TossTextStyles.h1';
    if (fontSize >= 24) return 'TossTextStyles.h2';
    if (fontSize >= 20) return 'TossTextStyles.h3';
    if (fontSize >= 18) return 'TossTextStyles.h4';
    if (fontSize >= 16) return 'TossTextStyles.bodyLarge';
    if (fontSize >= 14) return 'TossTextStyles.body';
    if (fontSize >= 13) return 'TossTextStyles.bodySmall';
    if (fontSize >= 12) {
      if (fontWeight == FontWeight.w500 || fontWeight == FontWeight.w600) {
        return 'TossTextStyles.label';
      }
      return 'TossTextStyles.caption';
    }
    if (fontSize >= 11) return 'TossTextStyles.small';
    
    return null;
  }
  
  /// Suggest border radius replacement
  String? _suggestBorderRadius(double radius) {
    if (radius <= 0) return 'TossBorderRadius.none';
    if (radius <= 4) return 'TossBorderRadius.xs';
    if (radius <= 6) return 'TossBorderRadius.sm';
    if (radius <= 10) return 'TossBorderRadius.md';
    if (radius <= 14) return 'TossBorderRadius.lg';
    if (radius <= 18) return 'TossBorderRadius.xl';
    if (radius <= 22) return 'TossBorderRadius.xxl';
    if (radius <= 26) return 'TossBorderRadius.xxxl';
    if (radius >= 100) return 'TossBorderRadius.full';
    
    return null;
  }
  
  /// Report a validation issue
  void _reportIssue({
    required String type,
    required String location,
    required String currentValue,
    required String suggestedValue,
    String? filePath,
    int? lineNumber,
  }) {
    final issue = ValidationIssue(
      type: type,
      location: location,
      currentValue: currentValue,
      suggestedValue: suggestedValue,
      filePath: filePath,
      lineNumber: lineNumber,
      timestamp: DateTime.now(),
    );
    
    _issues.add(issue);
    _issueCount[type] = (_issueCount[type] ?? 0) + 1;
    
    // Keep only last 1000 issues
    if (_issues.length > 1000) {
      _issues.removeAt(0);
    }
    
    if (_logIssues) {
      debugPrint('🎨 Theme Issue: ${issue.description}');
    }
    
    if (_throwOnError) {
      throw ThemeValidationException(issue.description);
    }
  }
  
  /// Generate validation report
  ValidationReport generateReport() {
    return ValidationReport(
      totalIssues: _issues.length,
      issuesByType: Map.from(_issueCount),
      issues: List.from(_issues),
      timestamp: DateTime.now(),
    );
  }
  
  /// Validate entire codebase (expensive operation)
  Future<ValidationReport> validateCodebase(String projectPath) async {
    if (kReleaseMode) {
      return ValidationReport(
        totalIssues: 0,
        issuesByType: {},
        issues: [],
        timestamp: DateTime.now(),
      );
    }
    
    clearIssues();
    
    final directory = Directory(projectPath);
    if (!await directory.exists()) {
      throw Exception('Project path does not exist: $projectPath');
    }
    
    await for (final file in directory.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        await _validateDartFile(file);
      }
    }
    
    return generateReport();
  }
  
  /// Validate a Dart file
  Future<void> _validateDartFile(File file) async {
    try {
      final content = await file.readAsString();
      final issues = _analyzeFileContent(content, file.path);
      
      for (final issue in issues) {
        _reportIssue(
          type: issue['type'] as String,
          location: issue['location'] as String,
          currentValue: issue['currentValue'] as String,
          suggestedValue: issue['suggestedValue'] as String,
          filePath: file.path,
          lineNumber: issue['lineNumber'] as int?,
        );
      }
    } catch (e) {
      if (_logIssues) {
        debugPrint('Error validating file ${file.path}: $e');
      }
    }
  }
  
  /// Check if line contains hardcoded color usage (not constructor/class names)
  bool _isHardcodedColorUsage(String line) {
    // Match actual Color instantiations, not class names or constructors
    return RegExp(r'Color\(0x[0-9A-Fa-f]+\)').hasMatch(line) ||
           (line.contains('Colors.') && !line.contains('class ') && !line.contains('._()'));
  }

  /// Check if line contains hardcoded TextStyle usage (not method signatures/widget names)
  bool _isHardcodedTextStyleUsage(String line) {
    // Only match actual TextStyle instantiations, exclude:
    // - Method signatures: "TextStyle methodName()"
    // - Method calls: "style: _getTextStyle()"
    // - Flutter widgets: "AnimatedDefaultTextStyle", "DefaultTextStyle"
    return line.contains('TextStyle(') && 
           !line.contains('TextStyle ') &&  // Not method signature
           !line.contains('_get') &&  // Not method call like _getDisplayTextStyle()
           !line.contains('AnimatedDefaultTextStyle') &&  // Not Flutter widget
           !line.contains('DefaultTextStyle');  // Not Flutter widget
  }

  /// Check if line contains hardcoded EdgeInsets usage
  bool _isHardcodedEdgeInsetsUsage(String line) {
    return RegExp(r'EdgeInsets\.\w+\(\d+').hasMatch(line);
  }

  /// Check if line contains hardcoded BorderRadius usage
  bool _isHardcodedBorderRadiusUsage(String line) {
    return RegExp(r'BorderRadius\.circular\(\d+').hasMatch(line);
  }

  /// Check if file is part of the theme system (should be excluded from validation)
  bool _isSystemFile(String path) {
    final systemFiles = [
      '/core/themes/toss_colors.dart',
      '/core/themes/toss_text_styles.dart', 
      '/core/themes/toss_spacing.dart',
      '/core/themes/toss_border_radius.dart',
      '/core/themes/toss_shadows.dart',
      '/core/themes/toss_animations.dart',
      '/core/themes/toss_icons.dart',
      '/core/themes/toss_design_system.dart',
      '/core/themes/app_theme.dart',
      '/core/themes/toss_page_styles.dart',
      '/core/themes/theme_validator.dart',
      '/core/themes/theme_compatibility.dart',
      '/core/themes/theme_extensions.dart',
      '/core/themes/index.dart',
      '/core/themes/widget_analyzer.dart',  // Theme analysis tool
    ];
    
    return systemFiles.any((systemFile) => path.contains(systemFile));
  }

  /// Analyze file content for theme issues
  List<Map<String, dynamic>> _analyzeFileContent(String content, String filePath) {
    // Skip validation for theme system files - they are supposed to contain raw values
    if (_isSystemFile(filePath)) {
      return [];
    }
    
    final issues = <Map<String, dynamic>>[];
    final lines = content.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;
      final trimmedLine = line.trim();
      
      // Skip comments and empty lines
      if (trimmedLine.isEmpty || 
          trimmedLine.startsWith('//') || 
          trimmedLine.startsWith('*') ||
          trimmedLine.startsWith('///')) {
        continue;
      }
      
      // Check for hardcoded colors (more precise patterns)
      if (_isHardcodedColorUsage(line) && !line.contains('TossColors')) {
        issues.add({
          'type': 'color',
          'location': 'Line $lineNumber',
          'currentValue': line.trim(),
          'suggestedValue': 'Use TossColors instead',
          'lineNumber': lineNumber,
        });
      }
      
      // Check for hardcoded TextStyle (more precise patterns)
      if (_isHardcodedTextStyleUsage(line) && !line.contains('TossTextStyles')) {
        issues.add({
          'type': 'text',
          'location': 'Line $lineNumber',
          'currentValue': line.trim(),
          'suggestedValue': 'Use TossTextStyles instead',
          'lineNumber': lineNumber,
        });
      }
      
      // Check for hardcoded EdgeInsets (skip if already using TossSpacing)
      if (_isHardcodedEdgeInsetsUsage(line) && !line.contains('TossSpacing')) {
        issues.add({
          'type': 'spacing',
          'location': 'Line $lineNumber',
          'currentValue': line.trim(),
          'suggestedValue': 'Use TossSpacing constants',
          'lineNumber': lineNumber,
        });
      }
      
      // Check for hardcoded BorderRadius (skip if already using TossBorderRadius)
      if (_isHardcodedBorderRadiusUsage(line) && !line.contains('TossBorderRadius')) {
        issues.add({
          'type': 'radius',
          'location': 'Line $lineNumber',
          'currentValue': line.trim(),
          'suggestedValue': 'Use TossBorderRadius constants',
          'lineNumber': lineNumber,
        });
      }
    }
    
    return issues;
  }
}

/// Validation issue representation
class ValidationIssue {
  final String type;
  final String location;
  final String currentValue;
  final String suggestedValue;
  final String? filePath;
  final int? lineNumber;
  final DateTime timestamp;
  
  ValidationIssue({
    required this.type,
    required this.location,
    required this.currentValue,
    required this.suggestedValue,
    this.filePath,
    this.lineNumber,
    required this.timestamp,
  });
  
  String get description {
    final locationStr = filePath != null
        ? '$filePath${lineNumber != null ? ":$lineNumber" : ""}'
        : location;
    return '$type issue at $locationStr:\n'
           '  Current: $currentValue\n'
           '  Suggested: $suggestedValue';
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'location': location,
      'currentValue': currentValue,
      'suggestedValue': suggestedValue,
      'filePath': filePath,
      'lineNumber': lineNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Validation report
class ValidationReport {
  final int totalIssues;
  final Map<String, int> issuesByType;
  final List<ValidationIssue> issues;
  final DateTime timestamp;
  
  ValidationReport({
    required this.totalIssues,
    required this.issuesByType,
    required this.issues,
    required this.timestamp,
  });
  
  String get summary {
    if (totalIssues == 0) {
      return '✅ No theme issues found!';
    }
    
    final buffer = StringBuffer();
    buffer.writeln('⚠️ Found $totalIssues theme issues:');
    issuesByType.forEach((type, count) {
      buffer.writeln('  - $type: $count');
    });
    
    return buffer.toString();
  }
  
  Map<String, dynamic> toJson() {
    return {
      'totalIssues': totalIssues,
      'issuesByType': issuesByType,
      'issues': issues.map((i) => i.toJson()).toList(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Theme validation exception
class ThemeValidationException implements Exception {
  final String message;
  
  ThemeValidationException(this.message);
  
  @override
  String toString() => 'ThemeValidationException: $message';
}