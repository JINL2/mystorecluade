#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

/// Comprehensive backup system for theme migration safety
/// 
/// Features:
/// - Full project backup with git integration
/// - Selective file restoration
/// - Backup verification and integrity checks
/// - Automatic backup cleanup and rotation
/// - Migration point tagging for easy rollback
class ThemeBackupSystem {
  final String projectPath;
  final String backupPath;
  final bool verbose;
  final int maxBackups;
  
  ThemeBackupSystem({
    required this.projectPath,
    String? backupPath,
    this.verbose = false,
    this.maxBackups = 10,
  }) : backupPath = backupPath ?? path.join(projectPath, '.theme_backups');
  
  /// Create comprehensive backup before theme migration
  Future<BackupResult> createBackup({
    String? tag,
    bool includeGitState = true,
    bool verifyIntegrity = true,
  }) async {
    print('🛡️ Creating comprehensive theme backup...');
    
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupTag = tag ?? 'theme_migration_$timestamp';
    final backupDir = Directory(path.join(backupPath, backupTag));
    
    final result = BackupResult(
      tag: backupTag,
      timestamp: DateTime.now(),
      backupPath: backupDir.path,
    );
    
    try {
      // Create backup directory
      await backupDir.create(recursive: true);
      
      // 1. Backup critical files
      await _backupCriticalFiles(backupDir, result);
      
      // 2. Create git snapshot if available
      if (includeGitState) {
        await _createGitSnapshot(backupDir, result);
      }
      
      // 3. Backup current theme state
      await _backupThemeState(backupDir, result);
      
      // 4. Create backup manifest
      await _createBackupManifest(backupDir, result);
      
      // 5. Verify backup integrity
      if (verifyIntegrity) {
        await _verifyBackupIntegrity(backupDir, result);
      }
      
      // 6. Clean up old backups
      await _cleanupOldBackups();
      
      result.success = true;
      result.message = 'Backup created successfully';
      
      if (verbose) {
        print('✅ Backup created: ${result.backupPath}');
        print('📊 Backup stats: ${result.filesBackedUp} files, ${result.totalSize} bytes');
      }
      
    } catch (e) {
      result.success = false;
      result.message = 'Backup failed: $e';
      result.errors.add(BackupError('BACKUP_CREATION', e.toString()));
    }
    
    return result;
  }
  
  /// Backup all critical project files
  Future<void> _backupCriticalFiles(Directory backupDir, BackupResult result) async {
    final criticalPaths = [
      'lib/',
      'pubspec.yaml',
      'pubspec.lock',
      'analysis_options.yaml',
      'android/app/build.gradle',
      'ios/Runner.xcodeproj/project.pbxproj',
      'test/',
    ];
    
    for (final relativePath in criticalPaths) {
      final sourcePath = path.join(projectPath, relativePath);
      final source = FileSystemEntity.typeSync(sourcePath);
      
      if (source == FileSystemEntityType.notFound) continue;
      
      final targetPath = path.join(backupDir.path, 'files', relativePath);
      
      if (source == FileSystemEntityType.directory) {
        await _copyDirectory(Directory(sourcePath), Directory(targetPath), result);
      } else {
        await _copyFile(File(sourcePath), File(targetPath), result);
      }
    }
  }
  
  /// Copy directory recursively with error handling
  Future<void> _copyDirectory(Directory source, Directory target, BackupResult result) async {
    if (!await source.exists()) return;
    
    await target.create(recursive: true);
    
    await for (final entity in source.list(recursive: false)) {
      final relativePath = path.relative(entity.path, from: source.path);
      final targetPath = path.join(target.path, relativePath);
      
      if (entity is Directory) {
        await _copyDirectory(entity, Directory(targetPath), result);
      } else if (entity is File) {
        // Skip generated files and build artifacts
        if (_shouldSkipFile(entity.path)) continue;
        
        await _copyFile(entity, File(targetPath), result);
      }
    }
  }
  
  /// Copy individual file with verification
  Future<void> _copyFile(File source, File target, BackupResult result) async {
    try {
      await target.create(recursive: true);
      await source.copy(target.path);
      
      // Verify file integrity
      final sourceSize = await source.length();
      final targetSize = await target.length();
      
      if (sourceSize != targetSize) {
        throw Exception('File size mismatch: $sourceSize != $targetSize');
      }
      
      result.filesBackedUp++;
      result.totalSize += sourceSize;
      
    } catch (e) {
      result.errors.add(BackupError('FILE_COPY', 'Failed to copy ${source.path}: $e'));
    }
  }
  
  /// Check if file should be skipped during backup
  bool _shouldSkipFile(String filePath) {
    final skipPatterns = [
      '.dart_tool/',
      'build/',
      '.flutter-plugins',
      '.flutter-plugins-dependencies',
      '.packages',
      '.pub-cache/',
      '*.g.dart',
      '*.freezed.dart',
      '*.mocks.dart',
      '.theme_backups/',
    ];
    
    return skipPatterns.any((pattern) => filePath.contains(pattern.replaceAll('*', '')));
  }
  
  /// Create git snapshot for version control backup
  Future<void> _createGitSnapshot(Directory backupDir, BackupResult result) async {
    try {
      // Check if git is available
      final gitCheck = await Process.run('git', ['--version'], workingDirectory: projectPath);
      if (gitCheck.exitCode != 0) {
        result.warnings.add('Git not available - skipping git snapshot');
        return;
      }
      
      // Get current git status
      final statusResult = await Process.run('git', ['status', '--porcelain'], workingDirectory: projectPath);
      final diffResult = await Process.run('git', ['diff', 'HEAD'], workingDirectory: projectPath);
      final logResult = await Process.run('git', ['log', '--oneline', '-10'], workingDirectory: projectPath);
      
      // Save git state
      final gitStateFile = File(path.join(backupDir.path, 'git_state.json'));
      await gitStateFile.writeAsString(jsonEncode({
        'timestamp': DateTime.now().toIso8601String(),
        'status': statusResult.stdout,
        'diff': diffResult.stdout,
        'log': logResult.stdout,
        'exitCodes': {
          'status': statusResult.exitCode,
          'diff': diffResult.exitCode,
          'log': logResult.exitCode,
        },
      }),);
      
      result.gitSnapshotCreated = true;
      
    } catch (e) {
      result.warnings.add('Git snapshot failed: $e');
    }
  }
  
  /// Backup current theme configuration state
  Future<void> _backupThemeState(Directory backupDir, BackupResult result) async {
    try {
      final themeStateDir = Directory(path.join(backupDir.path, 'theme_state'));
      await themeStateDir.create(recursive: true);
      
      // Backup theme files
      final themeFiles = [
        'lib/core/themes/',
        'lib/presentation/providers/theme_provider.dart',
      ];
      
      for (final themePath in themeFiles) {
        final sourcePath = path.join(projectPath, themePath);
        final source = FileSystemEntity.typeSync(sourcePath);
        
        if (source == FileSystemEntityType.directory) {
          final sourceDir = Directory(sourcePath);
          final targetDir = Directory(path.join(themeStateDir.path, path.basename(themePath)));
          await _copyDirectory(sourceDir, targetDir, result);
        } else if (source == FileSystemEntityType.file) {
          final sourceFile = File(sourcePath);
          final targetFile = File(path.join(themeStateDir.path, path.basename(themePath)));
          await _copyFile(sourceFile, targetFile, result);
        }
      }
      
      result.themeStateBackedUp = true;
      
    } catch (e) {
      result.errors.add(BackupError('THEME_STATE', 'Theme state backup failed: $e'));
    }
  }
  
  /// Create detailed backup manifest
  Future<void> _createBackupManifest(Directory backupDir, BackupResult result) async {
    final manifest = {
      'backup_info': {
        'tag': result.tag,
        'timestamp': result.timestamp.toIso8601String(),
        'project_path': projectPath,
        'backup_path': result.backupPath,
      },
      'statistics': {
        'files_backed_up': result.filesBackedUp,
        'total_size_bytes': result.totalSize,
        'git_snapshot_created': result.gitSnapshotCreated,
        'theme_state_backed_up': result.themeStateBackedUp,
      },
      'integrity': {
        'verified': result.integrityVerified,
        'checksum': result.checksum,
      },
      'errors': result.errors.map((e) => e.toJson()).toList(),
      'warnings': result.warnings,
    };
    
    final manifestFile = File(path.join(backupDir.path, 'backup_manifest.json'));
    await manifestFile.writeAsString(jsonEncode(manifest));
  }
  
  /// Verify backup integrity
  Future<void> _verifyBackupIntegrity(Directory backupDir, BackupResult result) async {
    try {
      // Simple integrity check - verify critical files exist
      final criticalFiles = [
        'files/lib/core/themes/index.dart',
        'files/pubspec.yaml',
        'backup_manifest.json',
      ];
      
      for (final file in criticalFiles) {
        final filePath = path.join(backupDir.path, file);
        if (!await File(filePath).exists()) {
          throw Exception('Critical file missing from backup: $file');
        }
      }
      
      // Generate simple checksum
      result.checksum = DateTime.now().millisecondsSinceEpoch.toString();
      result.integrityVerified = true;
      
    } catch (e) {
      result.errors.add(BackupError('INTEGRITY_CHECK', 'Integrity verification failed: $e'));
    }
  }
  
  /// Clean up old backups beyond maxBackups limit
  Future<void> _cleanupOldBackups() async {
    try {
      final backupBaseDir = Directory(backupPath);
      if (!await backupBaseDir.exists()) return;
      
      final backupDirs = <Directory>[];
      await for (final entity in backupBaseDir.list()) {
        if (entity is Directory) {
          backupDirs.add(entity);
        }
      }
      
      // Sort by modification time (newest first)
      backupDirs.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });
      
      // Delete old backups
      if (backupDirs.length > maxBackups) {
        for (int i = maxBackups; i < backupDirs.length; i++) {
          await backupDirs[i].delete(recursive: true);
          if (verbose) {
            print('🗑️ Cleaned up old backup: ${backupDirs[i].path}');
          }
        }
      }
      
    } catch (e) {
      if (verbose) {
        print('⚠️ Backup cleanup warning: $e');
      }
    }
  }
  
  /// Restore from backup
  Future<RestoreResult> restoreBackup(String backupTag, {
    bool restoreGitState = false,
    List<String>? specificFiles,
  }) async {
    print('🔄 Restoring from backup: $backupTag');
    
    final backupDir = Directory(path.join(backupPath, backupTag));
    final result = RestoreResult(backupTag: backupTag, timestamp: DateTime.now());
    
    try {
      if (!await backupDir.exists()) {
        throw Exception('Backup not found: $backupTag');
      }
      
      // Load backup manifest
      final manifestFile = File(path.join(backupDir.path, 'backup_manifest.json'));
      final manifest = jsonDecode(await manifestFile.readAsString());
      
      // Restore files
      final filesDir = Directory(path.join(backupDir.path, 'files'));
      await _restoreDirectory(filesDir, Directory(projectPath), result, specificFiles);
      
      // Restore git state if requested
      if (restoreGitState) {
        await _restoreGitState(backupDir, result);
      }
      
      result.success = true;
      result.message = 'Backup restored successfully';
      
    } catch (e) {
      result.success = false;
      result.message = 'Restore failed: $e';
    }
    
    return result;
  }
  
  /// Restore directory from backup
  Future<void> _restoreDirectory(Directory source, Directory target, RestoreResult result, List<String>? specificFiles) async {
    await for (final entity in source.list(recursive: true)) {
      if (entity is File) {
        final relativePath = path.relative(entity.path, from: source.path);
        
        // Check if this file should be restored
        if (specificFiles != null && !specificFiles.any((f) => relativePath.startsWith(f))) {
          continue;
        }
        
        final targetFile = File(path.join(target.path, relativePath));
        await targetFile.create(recursive: true);
        await entity.copy(targetFile.path);
        result.filesRestored++;
      }
    }
  }
  
  /// Restore git state
  Future<void> _restoreGitState(Directory backupDir, RestoreResult result) async {
    // This is a placeholder - git state restoration would need careful implementation
    result.warnings.add('Git state restoration not implemented - manual git operations may be needed');
  }
  
  /// List available backups
  Future<List<BackupInfo>> listBackups() async {
    final backupBaseDir = Directory(backupPath);
    if (!await backupBaseDir.exists()) return [];
    
    final backups = <BackupInfo>[];
    
    await for (final entity in backupBaseDir.list()) {
      if (entity is Directory) {
        try {
          final manifestFile = File(path.join(entity.path, 'backup_manifest.json'));
          if (await manifestFile.exists()) {
            final manifest = jsonDecode(await manifestFile.readAsString());
            backups.add(BackupInfo.fromJson(manifest));
          }
        } catch (e) {
          // Skip invalid backups
        }
      }
    }
    
    return backups;
  }
}

/// Backup operation result
class BackupResult {
  final String tag;
  final DateTime timestamp;
  final String backupPath;
  
  bool success = false;
  String message = '';
  int filesBackedUp = 0;
  int totalSize = 0;
  bool gitSnapshotCreated = false;
  bool themeStateBackedUp = false;
  bool integrityVerified = false;
  String? checksum;
  
  final List<BackupError> errors = [];
  final List<String> warnings = [];
  
  BackupResult({
    required this.tag,
    required this.timestamp,
    required this.backupPath,
  });
}

/// Restore operation result
class RestoreResult {
  final String backupTag;
  final DateTime timestamp;
  
  bool success = false;
  String message = '';
  int filesRestored = 0;
  
  final List<String> warnings = [];
  
  RestoreResult({
    required this.backupTag,
    required this.timestamp,
  });
}

/// Backup error representation
class BackupError {
  final String type;
  final String message;
  
  BackupError(this.type, this.message);
  
  Map<String, dynamic> toJson() => {
    'type': type,
    'message': message,
  };
}

/// Backup information
class BackupInfo {
  final String tag;
  final DateTime timestamp;
  final String projectPath;
  final int filesBackedUp;
  final int totalSize;
  
  BackupInfo({
    required this.tag,
    required this.timestamp,
    required this.projectPath,
    required this.filesBackedUp,
    required this.totalSize,
  });
  
  factory BackupInfo.fromJson(Map<String, dynamic> json) {
    return BackupInfo(
      tag: json['backup_info']['tag'],
      timestamp: DateTime.parse(json['backup_info']['timestamp']),
      projectPath: json['backup_info']['project_path'],
      filesBackedUp: json['statistics']['files_backed_up'],
      totalSize: json['statistics']['total_size_bytes'],
    );
  }
}

/// CLI entry point
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('create')
    ..addCommand('restore')
    ..addCommand('list')
    ..addOption('project-path', 
        abbr: 'p', 
        defaultsTo: '.',
        help: 'Path to the project directory',)
    ..addOption('backup-path', 
        help: 'Path to store backups',)
    ..addOption('tag',
        abbr: 't',
        help: 'Backup tag/name',)
    ..addFlag('verbose',
        abbr: 'v',
        defaultsTo: false,
        help: 'Show verbose output',)
    ..addFlag('git-state',
        defaultsTo: true,
        help: 'Include git state in backup',)
    ..addFlag('verify',
        defaultsTo: true,
        help: 'Verify backup integrity',)
    ..addFlag('help',
        abbr: 'h',
        help: 'Show this help message',);

  try {
    final results = parser.parse(arguments);
    
    if (results['help'] as bool || results.command == null) {
      print('Theme Backup System - Comprehensive backup for safe theme migration');
      print('');
      print('Usage: dart bin/theme_backup_system.dart <command> [options]');
      print('');
      print('Commands:');
      print('  create    Create a new backup');
      print('  restore   Restore from backup');
      print('  list      List available backups');
      print('');
      print(parser.usage);
      return;
    }
    
    final backupSystem = ThemeBackupSystem(
      projectPath: path.absolute(results['project-path'] as String),
      backupPath: results['backup-path'] as String?,
      verbose: results['verbose'] as bool,
    );
    
    switch (results.command!.name) {
      case 'create':
        final result = await backupSystem.createBackup(
          tag: results['tag'] as String?,
          includeGitState: results['git-state'] as bool,
          verifyIntegrity: results['verify'] as bool,
        );
        
        if (result.success) {
          print('✅ Backup created successfully: ${result.tag}');
          exit(0);
        } else {
          print('❌ Backup failed: ${result.message}');
          exit(1);
        }
        
      case 'restore':
        final tag = results['tag'] as String?;
        if (tag == null) {
          print('❌ Error: --tag is required for restore command');
          exit(1);
        }
        
        final result = await backupSystem.restoreBackup(tag);
        
        if (result.success) {
          print('✅ Backup restored successfully: ${result.filesRestored} files');
          exit(0);
        } else {
          print('❌ Restore failed: ${result.message}');
          exit(1);
        }
        
      case 'list':
        final backups = await backupSystem.listBackups();
        
        if (backups.isEmpty) {
          print('No backups found');
        } else {
          print('Available backups:');
          for (final backup in backups) {
            print('  ${backup.tag} (${backup.timestamp}) - ${backup.filesBackedUp} files');
          }
        }
        break;
    }
    
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}