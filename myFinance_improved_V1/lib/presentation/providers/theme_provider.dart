import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/themes/index.dart';

/// Theme state with comprehensive error handling
class ThemeState {
  final ThemeMode mode;
  final double textScaleFactor;
  final bool useCompactMode;
  final Map<String, bool> featureFlags;
  final ThemeHealthStatus healthStatus;
  final List<ThemeInconsistency> inconsistencies;
  
  const ThemeState({
    this.mode = ThemeMode.light,
    this.textScaleFactor = 1.0,
    this.useCompactMode = false,
    this.featureFlags = const {},
    this.healthStatus = const ThemeHealthStatus(),
    this.inconsistencies = const [],
  });
  
  ThemeState copyWith({
    ThemeMode? mode,
    double? textScaleFactor,
    bool? useCompactMode,
    Map<String, bool>? featureFlags,
    ThemeHealthStatus? healthStatus,
    List<ThemeInconsistency>? inconsistencies,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      useCompactMode: useCompactMode ?? this.useCompactMode,
      featureFlags: featureFlags ?? this.featureFlags,
      healthStatus: healthStatus ?? this.healthStatus,
      inconsistencies: inconsistencies ?? this.inconsistencies,
    );
  }
  
  /// Check if new theme features are enabled
  bool isFeatureEnabled(String feature) {
    return featureFlags[feature] ?? false;
  }
}

/// Theme health monitoring
class ThemeHealthStatus {
  final int hardcodedColors;
  final int hardcodedTextStyles;
  final int hardcodedSpacing;
  final int hardcodedRadius;
  final DateTime lastChecked;
  final bool isHealthy;
  
  const ThemeHealthStatus({
    this.hardcodedColors = 0,
    this.hardcodedTextStyles = 0,
    this.hardcodedSpacing = 0,
    this.hardcodedRadius = 0,
    DateTime? lastChecked,
    this.isHealthy = true,
  }) : lastChecked = lastChecked ?? const DateTime(2024);
  
  int get totalIssues => 
      hardcodedColors + hardcodedTextStyles + hardcodedSpacing + hardcodedRadius;
  
  String get summary {
    if (totalIssues == 0) return 'Theme is healthy ✅';
    return 'Found $totalIssues theme inconsistencies ⚠️';
  }
}

/// Represents a theme inconsistency found in the codebase
class ThemeInconsistency {
  final String filePath;
  final int lineNumber;
  final String type; // 'color', 'text', 'spacing', 'radius'
  final String currentValue;
  final String suggestedValue;
  final String context;
  
  const ThemeInconsistency({
    required this.filePath,
    required this.lineNumber,
    required this.type,
    required this.currentValue,
    required this.suggestedValue,
    required this.context,
  });
  
  String get description {
    return '$type inconsistency at $filePath:$lineNumber\n'
           'Current: $currentValue\n'
           'Suggested: $suggestedValue';
  }
}

/// Theme provider with robust error handling
class ThemeNotifier extends StateNotifier<ThemeState> {
  final SharedPreferences _prefs;
  static const String _themeKey = 'theme_mode';
  static const String _scaleKey = 'text_scale';
  static const String _compactKey = 'compact_mode';
  static const String _featureFlagsKey = 'theme_features';
  
  ThemeNotifier(this._prefs) : super(const ThemeState()) {
    _loadThemePreferences();
    _validateThemeHealth();
  }
  
  /// Load saved theme preferences with error handling
  Future<void> _loadThemePreferences() async {
    try {
      // Load theme mode
      final themeModeIndex = _prefs.getInt(_themeKey) ?? 0;
      final themeMode = ThemeMode.values[themeModeIndex.clamp(0, ThemeMode.values.length - 1)];
      
      // Load text scale with validation
      final textScale = _prefs.getDouble(_scaleKey) ?? 1.0;
      final validScale = textScale.clamp(0.85, 1.3);
      
      // Load compact mode
      final compactMode = _prefs.getBool(_compactKey) ?? false;
      
      // Load feature flags
      final flagsJson = _prefs.getStringList(_featureFlagsKey) ?? [];
      final flags = Map<String, bool>.fromEntries(
        flagsJson.map((flag) {
          final parts = flag.split(':');
          return MapEntry(parts[0], parts[1] == 'true');
        }),
      );
      
      state = state.copyWith(
        mode: themeMode,
        textScaleFactor: validScale,
        useCompactMode: compactMode,
        featureFlags: flags,
      );
    } catch (e) {
      // Log error but don't crash - use defaults
      debugPrint('Error loading theme preferences: $e');
      _handleThemeError(e);
    }
  }
  
  /// Save theme preferences with error handling
  Future<bool> _saveThemePreferences() async {
    try {
      await _prefs.setInt(_themeKey, state.mode.index);
      await _prefs.setDouble(_scaleKey, state.textScaleFactor);
      await _prefs.setBool(_compactKey, state.useCompactMode);
      
      final flagsList = state.featureFlags.entries
          .map((e) => '${e.key}:${e.value}')
          .toList();
      await _prefs.setStringList(_featureFlagsKey, flagsList);
      
      return true;
    } catch (e) {
      debugPrint('Error saving theme preferences: $e');
      _handleThemeError(e);
      return false;
    }
  }
  
  /// Set theme mode with validation
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state.mode) return;
    
    try {
      state = state.copyWith(mode: mode);
      await _saveThemePreferences();
    } catch (e) {
      _handleThemeError(e);
      // Revert on error
      state = state.copyWith(mode: ThemeMode.light);
    }
  }
  
  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state.mode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
  
  /// Set text scale factor with bounds checking
  Future<void> setTextScaleFactor(double scale) async {
    // Validate scale range
    final validScale = scale.clamp(0.85, 1.3);
    
    if ((validScale - state.textScaleFactor).abs() < 0.01) return;
    
    try {
      state = state.copyWith(textScaleFactor: validScale);
      await _saveThemePreferences();
    } catch (e) {
      _handleThemeError(e);
    }
  }
  
  /// Toggle compact mode
  Future<void> toggleCompactMode() async {
    try {
      state = state.copyWith(useCompactMode: !state.useCompactMode);
      await _saveThemePreferences();
    } catch (e) {
      _handleThemeError(e);
    }
  }
  
  /// Enable/disable feature flags for gradual rollout
  Future<void> setFeatureFlag(String feature, bool enabled) async {
    try {
      final newFlags = Map<String, bool>.from(state.featureFlags);
      newFlags[feature] = enabled;
      
      state = state.copyWith(featureFlags: newFlags);
      await _saveThemePreferences();
    } catch (e) {
      _handleThemeError(e);
    }
  }
  
  /// Validate theme health across the app
  Future<void> _validateThemeHealth() async {
    try {
      // This would be called periodically to check theme consistency
      // In production, this might scan the codebase or use analytics
      
      final health = ThemeHealthStatus(
        hardcodedColors: 0, // Would be detected by analyzer
        hardcodedTextStyles: 0,
        hardcodedSpacing: 0,
        hardcodedRadius: 0,
        lastChecked: DateTime.now(),
        isHealthy: true,
      );
      
      state = state.copyWith(healthStatus: health);
    } catch (e) {
      _handleThemeError(e);
    }
  }
  
  /// Report theme inconsistency
  void reportInconsistency(ThemeInconsistency inconsistency) {
    final updated = List<ThemeInconsistency>.from(state.inconsistencies)
      ..add(inconsistency);
    
    // Keep only last 100 inconsistencies
    if (updated.length > 100) {
      updated.removeRange(0, updated.length - 100);
    }
    
    state = state.copyWith(inconsistencies: updated);
    
    // Update health status
    final health = state.healthStatus;
    ThemeHealthStatus newHealth;
    
    switch (inconsistency.type) {
      case 'color':
        newHealth = ThemeHealthStatus(
          hardcodedColors: health.hardcodedColors + 1,
          hardcodedTextStyles: health.hardcodedTextStyles,
          hardcodedSpacing: health.hardcodedSpacing,
          hardcodedRadius: health.hardcodedRadius,
          lastChecked: DateTime.now(),
          isHealthy: false,
        );
        break;
      case 'text':
        newHealth = ThemeHealthStatus(
          hardcodedColors: health.hardcodedColors,
          hardcodedTextStyles: health.hardcodedTextStyles + 1,
          hardcodedSpacing: health.hardcodedSpacing,
          hardcodedRadius: health.hardcodedRadius,
          lastChecked: DateTime.now(),
          isHealthy: false,
        );
        break;
      case 'spacing':
        newHealth = ThemeHealthStatus(
          hardcodedColors: health.hardcodedColors,
          hardcodedTextStyles: health.hardcodedTextStyles,
          hardcodedSpacing: health.hardcodedSpacing + 1,
          hardcodedRadius: health.hardcodedRadius,
          lastChecked: DateTime.now(),
          isHealthy: false,
        );
        break;
      case 'radius':
        newHealth = ThemeHealthStatus(
          hardcodedColors: health.hardcodedColors,
          hardcodedTextStyles: health.hardcodedTextStyles,
          hardcodedSpacing: health.hardcodedSpacing,
          hardcodedRadius: health.hardcodedRadius + 1,
          lastChecked: DateTime.now(),
          isHealthy: false,
        );
        break;
      default:
        newHealth = health;
    }
    
    state = state.copyWith(healthStatus: newHealth);
  }
  
  /// Clear all reported inconsistencies
  void clearInconsistencies() {
    state = state.copyWith(
      inconsistencies: [],
      healthStatus: const ThemeHealthStatus(),
    );
  }
  
  /// Handle theme errors gracefully
  void _handleThemeError(dynamic error) {
    debugPrint('Theme error: $error');
    // Could send to error reporting service
    // Could show user-friendly error message
    // Always fall back to safe defaults
  }
  
  /// Reset to defaults in case of critical error
  Future<void> resetToDefaults() async {
    state = const ThemeState();
    await _prefs.clear();
  }
}

/// Providers
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  throw UnimplementedError('Must override with SharedPreferences');
});

/// Helper provider for easy access to current theme data
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeState = ref.watch(themeProvider);
  
  // For now, return light theme
  // In future, this would return dark theme when mode is dark
  return AppTheme.lightTheme;
});

/// Provider for theme health monitoring
final themeHealthProvider = Provider<ThemeHealthStatus>((ref) {
  return ref.watch(themeProvider.select((state) => state.healthStatus));
});

/// Provider for feature flags
final themeFeatureFlagsProvider = Provider<Map<String, bool>>((ref) {
  return ref.watch(themeProvider.select((state) => state.featureFlags));
});