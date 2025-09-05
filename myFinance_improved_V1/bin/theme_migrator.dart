#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Automated theme migration tool
/// 
/// Usage:
///   dart bin/theme_migrator.dart --project-path lib/
///   dart bin/theme_migrator.dart --file-path lib/widgets/my_widget.dart
///   dart bin/theme_migrator.dart --dry-run --backup
class ThemeMigrator {
  final String projectPath;
  final bool dryRun;
  final bool createBackup;
  final bool verbose;
  final bool force;
  
  ThemeMigrator({
    required this.projectPath,
    this.dryRun = false,
    this.createBackup = true,
    this.verbose = false,
    this.force = false,
  });
  
  /// Color migration patterns
  static final Map<String, String> colorMigrations = {
    // Hardcoded hex colors
    'Color(0xFF0064FF)': 'TossColors.primary',
    'Color(0xFFFFFFFF)': 'TossColors.white',
    'Color(0xFF000000)': 'TossColors.black',
    'Color(0xFFF8F9FA)': 'TossColors.gray50',
    'Color(0xFFF1F3F5)': 'TossColors.gray100',
    'Color(0xFFE9ECEF)': 'TossColors.gray200',
    'Color(0xFFDEE2E6)': 'TossColors.gray300',
    'Color(0xFFCED4DA)': 'TossColors.gray400',
    'Color(0xFFADB5BD)': 'TossColors.gray500',
    'Color(0xFF6C757D)': 'TossColors.gray600',
    'Color(0xFF495057)': 'TossColors.gray700',
    'Color(0xFF343A40)': 'TossColors.gray800',
    'Color(0xFF212529)': 'TossColors.gray900',
    'Color(0xFF00C896)': 'TossColors.success',
    'Color(0xFFE3FFF4)': 'TossColors.successLight',
    'Color(0xFFFF5847)': 'TossColors.error',
    'Color(0xFFFFEFED)': 'TossColors.errorLight',
    'Color(0xFFFF9500)': 'TossColors.warning',
    'Color(0xFFFFF4E6)': 'TossColors.warningLight',
    'Color(0xFFF0F6FF)': 'TossColors.infoLight',
    'Color(0x8A000000)': 'TossColors.overlay',
    'Color(0x0A000000)': 'TossColors.shadow',
    'Color(0x00000000)': 'TossColors.transparent',
    
    // Material colors
    'Colors.blue': 'TossColors.primary',
    'Colors.red': 'TossColors.error',
    'Colors.green': 'TossColors.success',
    'Colors.orange': 'TossColors.warning',
    'Colors.grey': 'TossColors.gray500',
    'Colors.white': 'TossColors.white',
    'Colors.black': 'TossColors.black',
    'Colors.transparent': 'TossColors.transparent',
  };
  
  /// TextStyle migration patterns
  static final List<TextStyleMigration> textStyleMigrations = [
    // Display styles
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*32[,\s)]'),
      replacement: 'TossTextStyles.display',
      description: 'fontSize: 32 → TossTextStyles.display',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*28[,\s)]'),
      replacement: 'TossTextStyles.h1',
      description: 'fontSize: 28 → TossTextStyles.h1',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*24[,\s)]'),
      replacement: 'TossTextStyles.h2',
      description: 'fontSize: 24 → TossTextStyles.h2',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*20[,\s)]'),
      replacement: 'TossTextStyles.h3',
      description: 'fontSize: 20 → TossTextStyles.h3',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*18[,\s)]'),
      replacement: 'TossTextStyles.h4',
      description: 'fontSize: 18 → TossTextStyles.h4',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*16[,\s)]'),
      replacement: 'TossTextStyles.bodyLarge',
      description: 'fontSize: 16 → TossTextStyles.bodyLarge',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*14[,\s)]'),
      replacement: 'TossTextStyles.body',
      description: 'fontSize: 14 → TossTextStyles.body',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*13[,\s)]'),
      replacement: 'TossTextStyles.bodySmall',
      description: 'fontSize: 13 → TossTextStyles.bodySmall',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*12[,\s)]'),
      replacement: 'TossTextStyles.caption',
      description: 'fontSize: 12 → TossTextStyles.caption',
    ),
    TextStyleMigration(
      pattern: RegExp(r'TextStyle\(\s*fontSize:\s*11[,\s)]'),
      replacement: 'TossTextStyles.small',
      description: 'fontSize: 11 → TossTextStyles.small',
    ),
  ];
  
  /// EdgeInsets migration patterns
  static final Map<String, String> edgeInsetsMigrations = {
    'EdgeInsets.all(0)': 'EdgeInsets.all(TossSpacing.space0)',
    'EdgeInsets.all(4)': 'EdgeInsets.all(TossSpacing.space1)',
    'EdgeInsets.all(8)': 'EdgeInsets.all(TossSpacing.space2)',
    'EdgeInsets.all(12)': 'EdgeInsets.all(TossSpacing.space3)',
    'EdgeInsets.all(16)': 'EdgeInsets.all(TossSpacing.space4)',
    'EdgeInsets.all(20)': 'EdgeInsets.all(TossSpacing.space5)',
    'EdgeInsets.all(24)': 'EdgeInsets.all(TossSpacing.space6)',
    'EdgeInsets.all(28)': 'EdgeInsets.all(TossSpacing.space7)',
    'EdgeInsets.all(32)': 'EdgeInsets.all(TossSpacing.space8)',
    'EdgeInsets.all(36)': 'EdgeInsets.all(TossSpacing.space9)',
    'EdgeInsets.all(40)': 'EdgeInsets.all(TossSpacing.space10)',
    'EdgeInsets.all(48)': 'EdgeInsets.all(TossSpacing.space12)',
    'EdgeInsets.all(56)': 'EdgeInsets.all(TossSpacing.space14)',
    'EdgeInsets.all(64)': 'EdgeInsets.all(TossSpacing.space16)',
    'EdgeInsets.all(80)': 'EdgeInsets.all(TossSpacing.space20)',
    'EdgeInsets.all(96)': 'EdgeInsets.all(TossSpacing.space24)',
  };
  
  /// BorderRadius migration patterns
  static final Map<String, String> borderRadiusMigrations = {
    'BorderRadius.circular(0)': 'BorderRadius.circular(TossBorderRadius.none)',
    'BorderRadius.circular(4)': 'BorderRadius.circular(TossBorderRadius.xs)',
    'BorderRadius.circular(6)': 'BorderRadius.circular(TossBorderRadius.sm)',
    'BorderRadius.circular(8)': 'BorderRadius.circular(TossBorderRadius.md)',
    'BorderRadius.circular(12)': 'BorderRadius.circular(TossBorderRadius.lg)',
    'BorderRadius.circular(16)': 'BorderRadius.circular(TossBorderRadius.xl)',
    'BorderRadius.circular(20)': 'BorderRadius.circular(TossBorderRadius.xxl)',
    'BorderRadius.circular(24)': 'BorderRadius.circular(TossBorderRadius.xxxl)',
    'BorderRadius.circular(999)': 'BorderRadius.circular(TossBorderRadius.full)',
  };
  
  /// Required imports to add
  static final Set<String> requiredImports = {
    "import 'package:myfinance_improved/core/themes/index.dart';",
  };
  
  /// Run migration
  Future<MigrationResult> migrate() async {
    print('🎨 Starting theme migration...');
    print('Project path: $projectPath');
    print('Dry run: $dryRun');
    print('Create backup: $createBackup');
    print('');
    
    final result = MigrationResult();
    
    // Find all Dart files
    final dartFiles = await _findDartFiles();
    print('Found ${dartFiles.length} Dart files');
    
    // Process each file
    for (final file in dartFiles) {
      try {
        final fileResult = await _migrateFile(file);
        result.merge(fileResult);
        
        if (verbose || fileResult.changesCount > 0) {
          print('${fileResult.changesCount > 0 ? "✓" : "–"} ${file.path} '
                '(${fileResult.changesCount} changes)');
        }
      } catch (e) {
        print('❌ Error processing ${file.path}: $e');
        result.errors.add(MigrationError(file.path, e.toString()));
      }
    }
    
    // Print summary
    print('');
    print('Migration complete!');
    print('Files processed: ${result.filesProcessed}');
    print('Files changed: ${result.filesChanged}');
    print('Total changes: ${result.totalChanges}');
    print('Errors: ${result.errors.length}');
    
    if (result.errors.isNotEmpty) {
      print('');
      print('Errors:');
      for (final error in result.errors) {
        print('  ${error.filePath}: ${error.message}');
      }
    }
    
    return result;
  }
  
  /// Find all Dart files in project
  Future<List<File>> _findDartFiles() async {
    final files = <File>[];
    final directory = Directory(projectPath);
    
    if (!await directory.exists()) {
      throw Exception('Project path does not exist: $projectPath');
    }
    
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        // Skip generated files
        if (entity.path.contains('.g.dart') || 
            entity.path.contains('.freezed.dart') ||
            entity.path.contains('.mocks.dart')) {
          continue;
        }
        files.add(entity);
      }
    }
    
    return files;
  }
  
  /// Migrate a single file
  Future<FileMigrationResult> _migrateFile(File file) async {
    final result = FileMigrationResult(file.path);
    
    String content = await file.readAsString();
    final originalContent = content;
    
    // Track if we need to add imports
    bool needsImports = false;
    
    // Migrate colors
    colorMigrations.forEach((pattern, replacement) {
      if (content.contains(pattern)) {
        content = content.replaceAll(pattern, replacement);
        result.colorChanges++;
        needsImports = true;
      }
    });
    
    // Migrate text styles
    for (final migration in textStyleMigrations) {
      if (migration.pattern.hasMatch(content)) {
        content = content.replaceAllMapped(migration.pattern, (match) {
          result.textStyleChanges++;
          needsImports = true;
          return migration.replacement;
        });
      }
    }
    
    // Migrate edge insets
    edgeInsetsMigrations.forEach((pattern, replacement) {
      if (content.contains(pattern)) {
        content = content.replaceAll(pattern, replacement);
        result.spacingChanges++;
        needsImports = true;
      }
    });
    
    // Migrate border radius
    borderRadiusMigrations.forEach((pattern, replacement) {
      if (content.contains(pattern)) {
        content = content.replaceAll(pattern, replacement);
        result.radiusChanges++;
        needsImports = true;
      }
    });
    
    // Add imports if needed
    if (needsImports && !content.contains("core/themes/index.dart")) {
      content = _addImports(content);
      result.importsAdded = true;
    }
    
    // Remove unused imports
    content = _removeUnusedImports(content);
    
    // Only write if changes were made
    if (content != originalContent) {
      result.hasChanges = true;
      
      if (!dryRun) {
        // Create backup
        if (createBackup) {
          final backupFile = File('${file.path}.backup');
          await backupFile.writeAsString(originalContent);
        }
        
        // Write migrated content
        await file.writeAsString(content);
      }
    }
    
    return result;
  }
  
  /// Add required imports to file
  String _addImports(String content) {
    final lines = content.split('\n');
    int importIndex = 0;
    
    // Find where to insert imports (after existing imports)
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('import ') || lines[i].startsWith("import '")) {
        importIndex = i + 1;
      } else if (lines[i].trim().isEmpty || lines[i].startsWith('//')) {
        continue;
      } else {
        break;
      }
    }
    
    // Insert required imports
    for (final import in requiredImports) {
      if (!content.contains(import)) {
        lines.insert(importIndex, import);
        importIndex++;
      }
    }
    
    return lines.join('\n');
  }
  
  /// Remove unused imports
  String _removeUnusedImports(String content) {
    // This is a simplified version - in practice you'd use AST analysis
    final lines = content.split('\n');
    final filteredLines = <String>[];
    
    for (final line in lines) {
      if (line.startsWith('import ')) {
        // Check if import is used
        final importPath = _extractImportPath(line);
        if (importPath != null && _isImportUsed(content, importPath)) {
          filteredLines.add(line);
        }
      } else {
        filteredLines.add(line);
      }
    }
    
    return filteredLines.join('\n');
  }
  
  /// Extract import path from import line
  String? _extractImportPath(String line) {
    final singleQuoteMatch = RegExp(r"import\s+'([^']+)'").firstMatch(line);
    if (singleQuoteMatch != null) return singleQuoteMatch.group(1);
    
    final doubleQuoteMatch = RegExp(r'import\s+"([^"]+)"').firstMatch(line);
    if (doubleQuoteMatch != null) return doubleQuoteMatch.group(1);
    
    return null;
  }
  
  /// Check if import is used in content
  bool _isImportUsed(String content, String importPath) {
    // Simplified check - look for references to the imported library
    if (importPath.contains('toss_colors')) {
      return content.contains('TossColors.');
    }
    if (importPath.contains('toss_text_styles')) {
      return content.contains('TossTextStyles.');
    }
    if (importPath.contains('toss_spacing')) {
      return content.contains('TossSpacing.');
    }
    if (importPath.contains('toss_border_radius')) {
      return content.contains('TossBorderRadius.');
    }
    return true; // Keep other imports
  }
}

/// Text style migration pattern
class TextStyleMigration {
  final RegExp pattern;
  final String replacement;
  final String description;
  
  TextStyleMigration({
    required this.pattern,
    required this.replacement,
    required this.description,
  });
}

/// Migration result for a single file
class FileMigrationResult {
  final String filePath;
  bool hasChanges = false;
  int colorChanges = 0;
  int textStyleChanges = 0;
  int spacingChanges = 0;
  int radiusChanges = 0;
  bool importsAdded = false;
  
  FileMigrationResult(this.filePath);
  
  int get changesCount => 
      colorChanges + textStyleChanges + spacingChanges + radiusChanges;
}

/// Overall migration result
class MigrationResult {
  int filesProcessed = 0;
  int filesChanged = 0;
  int totalChanges = 0;
  final List<MigrationError> errors = [];
  
  void merge(FileMigrationResult fileResult) {
    filesProcessed++;
    if (fileResult.hasChanges) {
      filesChanged++;
    }
    totalChanges += fileResult.changesCount;
  }
}

/// Migration error
class MigrationError {
  final String filePath;
  final String message;
  
  MigrationError(this.filePath, this.message);
}

/// CLI entry point
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('project-path', 
        abbr: 'p', 
        defaultsTo: 'lib/',
        help: 'Path to the project directory')
    ..addFlag('dry-run',
        abbr: 'd',
        defaultsTo: false,
        help: 'Show what would be changed without making changes')
    ..addFlag('backup',
        abbr: 'b',
        defaultsTo: true,
        help: 'Create backup files')
    ..addFlag('verbose',
        abbr: 'v',
        defaultsTo: false,
        help: 'Show verbose output')
    ..addFlag('force',
        abbr: 'f',
        defaultsTo: false,
        help: 'Force migration even if backup fails')
    ..addFlag('help',
        abbr: 'h',
        help: 'Show this help message');

  try {
    final results = parser.parse(arguments);
    
    if (results['help'] as bool) {
      print('Theme Migrator - Automated theme consistency fixes');
      print('');
      print('Usage: dart bin/theme_migrator.dart [options]');
      print('');
      print(parser.usage);
      return;
    }
    
    final migrator = ThemeMigrator(
      projectPath: results['project-path'] as String,
      dryRun: results['dry-run'] as bool,
      createBackup: results['backup'] as bool,
      verbose: results['verbose'] as bool,
      force: results['force'] as bool,
    );
    
    final result = await migrator.migrate();
    
    exit(result.errors.isEmpty ? 0 : 1);
  } catch (e) {
    print('❌ Error: $e');
    print('');
    print('Use --help for usage information');
    exit(1);
  }
}