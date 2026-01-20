#!/usr/bin/env dart
// ignore_for_file: avoid_print

/// Text Style Abuse Detector
///
/// This script scans the codebase for problematic copyWith usage on text styles.
/// Run with: dart run tools/detect_text_style_abuse.dart
///
/// Usage:
///   dart run tools/detect_text_style_abuse.dart           # Scan all files
///   dart run tools/detect_text_style_abuse.dart --fix     # Show fix suggestions
///   dart run tools/detect_text_style_abuse.dart --report  # Generate report file

import 'dart:io';

/// Represents a detected text style abuse
class TextStyleAbuse {
  final String filePath;
  final int lineNumber;
  final String line;
  final String baseStyle;
  final List<String> overriddenProperties;
  final String severity; // 'error', 'warning', 'info'
  final String? suggestedFix;

  TextStyleAbuse({
    required this.filePath,
    required this.lineNumber,
    required this.line,
    required this.baseStyle,
    required this.overriddenProperties,
    required this.severity,
    this.suggestedFix,
  });

  @override
  String toString() {
    final props = overriddenProperties.join(', ');
    return '[$severity] $filePath:$lineNumber\n'
        '  Base style: $baseStyle\n'
        '  Overridden: $props\n'
        '  Line: ${line.trim()}\n'
        '${suggestedFix != null ? '  Fix: $suggestedFix\n' : ''}';
  }
}

/// Configuration for the detector
class DetectorConfig {
  /// Files/directories to exclude from scanning
  static const excludedPaths = [
    'lib/shared/themes/',
    'lib/core/themes/',
    '.g.dart',
    '.freezed.dart',
    'widgetbook/',
    'test/',
  ];

  /// Properties that are CRITICAL errors when overridden (defeat the theme purpose)
  static const criticalProperties = ['fontSize', 'fontWeight', 'letterSpacing', 'height'];

  /// Properties that are WARNINGS (might be intentional but should be reviewed)
  static const warningProperties = ['color'];

  /// Known text style patterns to detect
  static const textStylePatterns = [
    r'TossTextStyles\.\w+',
    r'Theme\.of\(context\)\.textTheme\.\w+',
    r'textTheme\.\w+',
  ];

  /// Semantic styles that should be used instead of copyWith
  static const semanticStyleMappings = {
    // fontSize overrides
    'body.copyWith(fontSize: 12': 'TossTextStyles.caption',
    'body.copyWith(fontSize: 16': 'TossTextStyles.subtitle',
    'caption.copyWith(fontSize: 14': 'TossTextStyles.body',

    // fontWeight overrides
    'body.copyWith(fontWeight: FontWeight.w600': 'TossTextStyles.bodyMedium',
    'body.copyWith(fontWeight: FontWeight.bold': 'TossTextStyles.bodyMedium',
    'body.copyWith(fontWeight: FontWeight.w500': 'TossTextStyles.listItemTitle',
    'label.copyWith(fontWeight: FontWeight.w600': 'TossTextStyles.button',

    // color overrides
    'body.copyWith(color: TossColors.gray600': 'TossTextStyles.bodySecondary',
    'body.copyWith(color: TossColors.gray500': 'TossTextStyles.bodyTertiary',
    'caption.copyWith(color: TossColors.gray600': 'TossTextStyles.secondaryText',
    'caption.copyWith(color: TossColors.gray500': 'TossTextStyles.gridHeader',
    'body.copyWith(color: TossColors.textSecondary': 'TossTextStyles.bodySecondary',

    // Combined overrides
    'body.copyWith(fontWeight: FontWeight.w600, color:': 'TossTextStyles.denominationValue',
    'caption.copyWith(color: TossColors.gray600, fontFamily:': 'Create a new semantic style',
  };
}

class TextStyleAbuseDetector {
  final List<TextStyleAbuse> abuses = [];
  final Map<String, int> abuseCounts = {};
  final Map<String, Set<String>> fileAbuses = {};

  bool showFix = false;
  bool generateReport = false;

  Future<void> scan(String directory) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      print('Directory not found: $directory');
      return;
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        if (_shouldExclude(entity.path)) continue;
        await _scanFile(entity);
      }
    }
  }

  bool _shouldExclude(String path) {
    for (final excluded in DetectorConfig.excludedPaths) {
      if (path.contains(excluded)) return true;
    }
    return false;
  }

  Future<void> _scanFile(File file) async {
    final lines = await file.readAsLines();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      // Check for copyWith usage on text styles
      final abuse = _detectAbuse(file.path, lineNumber, line);
      if (abuse != null) {
        abuses.add(abuse);

        // Track counts
        abuseCounts[abuse.baseStyle] = (abuseCounts[abuse.baseStyle] ?? 0) + 1;
        for (final prop in abuse.overriddenProperties) {
          final key = '${abuse.baseStyle}.$prop';
          abuseCounts[key] = (abuseCounts[key] ?? 0) + 1;
        }

        // Track by file
        fileAbuses.putIfAbsent(file.path, () => {});
        fileAbuses[file.path]!.add('$lineNumber: ${abuse.overriddenProperties.join(", ")}');
      }
    }
  }

  TextStyleAbuse? _detectAbuse(String filePath, int lineNumber, String line) {
    // Skip if no copyWith
    if (!line.contains('.copyWith(')) return null;

    // Find the base style being copied
    String? baseStyle;
    for (final pattern in DetectorConfig.textStylePatterns) {
      final regex = RegExp('($pattern)\\.copyWith\\(');
      final match = regex.firstMatch(line);
      if (match != null) {
        baseStyle = match.group(1);
        break;
      }
    }

    if (baseStyle == null) return null;

    // Extract overridden properties
    final overriddenProperties = <String>[];
    final copyWithContent = _extractCopyWithContent(line);

    for (final prop in [...DetectorConfig.criticalProperties, ...DetectorConfig.warningProperties]) {
      if (copyWithContent.contains('$prop:')) {
        overriddenProperties.add(prop);
      }
    }

    if (overriddenProperties.isEmpty) return null;

    // Determine severity
    final hasCritical = overriddenProperties.any(
      (p) => DetectorConfig.criticalProperties.contains(p)
    );
    final severity = hasCritical ? 'error' : 'warning';

    // Find suggested fix
    String? suggestedFix;
    if (showFix) {
      suggestedFix = _findSuggestedFix(baseStyle, copyWithContent);
    }

    return TextStyleAbuse(
      filePath: filePath,
      lineNumber: lineNumber,
      line: line,
      baseStyle: baseStyle,
      overriddenProperties: overriddenProperties,
      severity: severity,
      suggestedFix: suggestedFix,
    );
  }

  String _extractCopyWithContent(String line) {
    final start = line.indexOf('.copyWith(');
    if (start == -1) return '';

    int depth = 0;
    int end = start;

    for (int i = start; i < line.length; i++) {
      if (line[i] == '(') depth++;
      if (line[i] == ')') {
        depth--;
        if (depth == 0) {
          end = i + 1;
          break;
        }
      }
    }

    return line.substring(start, end);
  }

  String? _findSuggestedFix(String baseStyle, String copyWithContent) {
    // Normalize the pattern for matching
    final normalized = '$baseStyle$copyWithContent'
        .replaceAll(' ', '')
        .replaceAll('\n', '');

    for (final entry in DetectorConfig.semanticStyleMappings.entries) {
      final pattern = entry.key.replaceAll(' ', '');
      if (normalized.contains(pattern)) {
        return 'Use ${entry.value} instead';
      }
    }

    // Suggest creating a new semantic style
    return 'Consider creating a semantic style in TossTextStyles';
  }

  void printSummary() {
    print('\n${'=' * 60}');
    print('TEXT STYLE ABUSE DETECTION REPORT');
    print('${'=' * 60}\n');

    // Count by severity
    final errors = abuses.where((a) => a.severity == 'error').length;
    final warnings = abuses.where((a) => a.severity == 'warning').length;

    print('Summary:');
    print('  Total issues found: ${abuses.length}');
    print('  Errors (fontSize/fontWeight overrides): $errors');
    print('  Warnings (color overrides): $warnings');
    print('  Files affected: ${fileAbuses.length}');
    print('');

    // Most abused styles
    print('Most Overridden Base Styles:');
    final sortedStyles = abuseCounts.entries
        .where((e) => !e.key.contains('.'))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedStyles.take(10)) {
      print('  ${entry.key}: ${entry.value} times');
    }
    print('');

    // Most overridden properties
    print('Most Overridden Properties:');
    final propCounts = <String, int>{};
    for (final abuse in abuses) {
      for (final prop in abuse.overriddenProperties) {
        propCounts[prop] = (propCounts[prop] ?? 0) + 1;
      }
    }

    final sortedProps = propCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedProps) {
      final isCritical = DetectorConfig.criticalProperties.contains(entry.key);
      final marker = isCritical ? '🔴' : '🟡';
      print('  $marker ${entry.key}: ${entry.value} times');
    }
    print('');

    // Files with most abuses
    print('Files with Most Issues:');
    final sortedFiles = fileAbuses.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    for (final entry in sortedFiles.take(10)) {
      final relativePath = entry.key.replaceFirst(RegExp(r'^.*lib/'), 'lib/');
      print('  $relativePath: ${entry.value.length} issues');
    }
    print('');
  }

  void printDetails() {
    print('\nDetailed Issues:');
    print('-' * 60);

    // Group by file
    final byFile = <String, List<TextStyleAbuse>>{};
    for (final abuse in abuses) {
      byFile.putIfAbsent(abuse.filePath, () => []);
      byFile[abuse.filePath]!.add(abuse);
    }

    for (final entry in byFile.entries) {
      final relativePath = entry.key.replaceFirst(RegExp(r'^.*lib/'), 'lib/');
      print('\n📁 $relativePath');

      for (final abuse in entry.value) {
        final icon = abuse.severity == 'error' ? '🔴' : '🟡';
        print('  $icon Line ${abuse.lineNumber}: ${abuse.baseStyle}.copyWith(${abuse.overriddenProperties.join(", ")})');
        if (abuse.suggestedFix != null) {
          print('     ✨ ${abuse.suggestedFix}');
        }
      }
    }
  }

  Future<void> generateReportFile() async {
    final buffer = StringBuffer();

    buffer.writeln('# Text Style Abuse Report');
    buffer.writeln('');
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('');

    buffer.writeln('## Summary');
    buffer.writeln('');
    buffer.writeln('| Metric | Count |');
    buffer.writeln('|--------|-------|');
    buffer.writeln('| Total Issues | ${abuses.length} |');
    buffer.writeln('| Errors (Critical) | ${abuses.where((a) => a.severity == 'error').length} |');
    buffer.writeln('| Warnings | ${abuses.where((a) => a.severity == 'warning').length} |');
    buffer.writeln('| Files Affected | ${fileAbuses.length} |');
    buffer.writeln('');

    buffer.writeln('## Action Required');
    buffer.writeln('');
    buffer.writeln('### Critical (Must Fix)');
    buffer.writeln('These override `fontSize` or `fontWeight`, defeating the theme system:');
    buffer.writeln('');

    for (final abuse in abuses.where((a) => a.severity == 'error')) {
      final relativePath = abuse.filePath.replaceFirst(RegExp(r'^.*lib/'), 'lib/');
      buffer.writeln('- `$relativePath:${abuse.lineNumber}`: ${abuse.baseStyle} → ${abuse.overriddenProperties.join(", ")}');
    }

    buffer.writeln('');
    buffer.writeln('### Warnings (Review)');
    buffer.writeln('These override `color` only - may be intentional:');
    buffer.writeln('');

    for (final abuse in abuses.where((a) => a.severity == 'warning').take(50)) {
      final relativePath = abuse.filePath.replaceFirst(RegExp(r'^.*lib/'), 'lib/');
      buffer.writeln('- `$relativePath:${abuse.lineNumber}`: ${abuse.baseStyle} → ${abuse.overriddenProperties.join(", ")}');
    }

    buffer.writeln('');
    buffer.writeln('## Recommended Semantic Styles to Create');
    buffer.writeln('');
    buffer.writeln('Based on the patterns found, consider adding these to `TossTextStyles`:');
    buffer.writeln('');

    // Analyze common patterns
    final patterns = <String, int>{};
    for (final abuse in abuses) {
      final pattern = '${abuse.baseStyle}.copyWith(${abuse.overriddenProperties.join(", ")})';
      patterns[pattern] = (patterns[pattern] ?? 0) + 1;
    }

    final sortedPatterns = patterns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedPatterns.take(20)) {
      buffer.writeln('- `${entry.key}` (${entry.value} occurrences)');
    }

    final reportFile = File('tools/text_style_abuse_report.md');
    await reportFile.writeAsString(buffer.toString());
    print('\n📄 Report saved to: ${reportFile.path}');
  }
}

void main(List<String> args) async {
  final detector = TextStyleAbuseDetector();

  detector.showFix = args.contains('--fix');
  detector.generateReport = args.contains('--report');

  print('🔍 Scanning for text style abuses...\n');

  await detector.scan('lib');

  detector.printSummary();

  if (detector.abuses.isNotEmpty) {
    detector.printDetails();
  }

  if (detector.generateReport) {
    await detector.generateReportFile();
  }

  // Exit with error code if critical issues found
  final errorCount = detector.abuses.where((a) => a.severity == 'error').length;
  if (errorCount > 0) {
    print('\n⚠️  Found $errorCount critical text style abuses!');
    print('Run with --fix to see suggested replacements.');
    exit(1);
  }
}
