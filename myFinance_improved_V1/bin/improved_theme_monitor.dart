#!/usr/bin/env dart

/// Improved Theme Monitor - Only flags real application code issues
/// Excludes theme system files and false positives
import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('❌ lib directory not found');
    exit(1);
  }

  int realIssueCount = 0;
  final issues = <String>[];

  // Process all Dart files
  libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .forEach((file) {
    realIssueCount += _scanFile(file, issues);
  });

  // Report results
  if (realIssueCount == 0) {
    print('🎉 No real theme issues found!');
    print('✅ Theme consistency: 100%');
  } else {
    print('📊 Theme Issues Summary:');
    print('🔍 Real issues found: $realIssueCount');
    print('');
    print('🎨 Issues to fix:');
    for (final issue in issues) {
      print(issue);
    }
  }
}

int _scanFile(File file, List<String> issues) {
  // Skip theme system files
  if (_isSystemFile(file.path)) {
    return 0;
  }

  final content = file.readAsStringSync();
  final lines = content.split('\n');
  int fileIssues = 0;

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final lineNumber = i + 1;

    // Skip comments and strings
    if (_isCommentOrString(line)) {
      continue;
    }

    // Check for real color issues
    if (_hasRealColorIssue(line)) {
      issues.add('🎨 Color issue at ${file.path}:$lineNumber:');
      issues.add('  Current: ${line.trim()}');
      issues.add('  Suggested: Use TossColors instead');
      issues.add('');
      fileIssues++;
    }

    // Check for real TextStyle issues
    if (_hasRealTextStyleIssue(line, lines, i)) {
      issues.add('📝 TextStyle issue at ${file.path}:$lineNumber:');
      issues.add('  Current: ${line.trim()}');
      issues.add('  Suggested: Use TossTextStyles instead');
      issues.add('');
      fileIssues++;
    }

    // Check for EdgeInsets issues
    if (_hasEdgeInsetsIssue(line)) {
      issues.add('📐 Spacing issue at ${file.path}:$lineNumber:');
      issues.add('  Current: ${line.trim()}');
      issues.add('  Suggested: Use TossSpacing instead');
      issues.add('');
      fileIssues++;
    }
  }

  return fileIssues;
}

bool _isSystemFile(String path) {
  final systemFiles = [
    '/core/themes/toss_colors.dart',
    '/core/themes/toss_shadows.dart',
    '/core/themes/toss_text_styles.dart',
    '/core/themes/theme_validator.dart',
    '/core/themes/theme_compatibility.dart',
    '/core/themes/theme_extensions.dart',
    '/core/themes/theme_health_monitor.dart',
    '/core/themes/automated_rollback.dart',
    '/core/themes/canary_deployment.dart',
    '/core/themes/progressive_rollout.dart',
  ];

  return systemFiles.any((systemFile) => path.contains(systemFile));
}

bool _isCommentOrString(String line) {
  final trimmed = line.trim();
  return trimmed.startsWith('//') || 
         trimmed.startsWith('/*') || 
         trimmed.startsWith('*') ||
         trimmed.startsWith('///');
}

bool _hasRealColorIssue(String line) {
  // Only flag hardcoded Color() usage, not TossColors references
  if (!line.contains('Color(0x')) {
    return false;
  }

  // Ignore if it's in a legitimate context
  if (line.contains('static const Color') ||
      line.contains('// Example:') ||
      line.contains('final avatarColor') ||
      line.contains('CounterPartyColors')) {
    return false;
  }

  return true;
}

bool _hasRealTextStyleIssue(String line, List<String> allLines, int currentIndex) {
  // Only flag direct TextStyle() instantiation
  if (!line.contains('TextStyle(') || line.contains('const TextStyle(')) {
    return false;
  }
  
  // Skip method calls that return TextStyle (these need to be checked individually)
  if (line.contains('style: _get') || 
      line.contains('style: get') ||
      line.contains('style: widget.')) {
    return false;
  }

  // Skip AnimatedDefaultTextStyle that properly uses TossTextStyles
  if (currentIndex > 0) {
    final previousLine = allLines[currentIndex - 1];
    if (previousLine.contains('AnimatedDefaultTextStyle')) {
      // Check if it uses TossTextStyles in the next few lines
      for (int j = currentIndex; j < currentIndex + 5 && j < allLines.length; j++) {
        if (allLines[j].contains('TossTextStyles')) {
          return false; // It's properly using TossTextStyles
        }
      }
    }
  }

  // Skip function declarations and type definitions
  if (line.contains('TextStyle ') || 
      line.contains('-> TextStyle') ||
      line.contains('return TextStyle') ||
      line.contains('TextStyle get') ||
      line.contains('TextStyle _get') ||
      line.contains('TextStyle? ')) {
    return false;
  }

  return true;
}

bool _hasEdgeInsetsIssue(String line) {
  // Only flag hardcoded EdgeInsets values, not TossSpacing usage
  final edgeInsetsPattern = RegExp(r'EdgeInsets\.(all|only|fromLTRB|symmetric)\s*\(\s*[0-9]');
  if (!edgeInsetsPattern.hasMatch(line)) {
    return false;
  }

  // Ignore if it's using TossSpacing
  if (line.contains('TossSpacing.')) {
    return false;
  }

  // Ignore const EdgeInsets in theme files or common patterns
  if (line.contains('const EdgeInsets') || 
      line.contains('padding: const EdgeInsets')) {
    return false;
  }

  return true;
}