import 'dart:io';
import 'package:path/path.dart' as path;

class WidgetAnalyzer {
  final Map<String, int> widgetUsageCount = {};
  final Map<String, List<String>> widgetUsageLocations = {};
  final Map<String, int> duplicatePatterns = {};
  final Map<String, int> hardcodedStyles = {};
  final List<String> inconsistencies = [];
  
  // Common widget imports to track
  final commonWidgetImports = [
    'toss_button.dart',
    'toss_card.dart',
    'toss_list_tile.dart',
    'toss_modal.dart',
    'toss_bottom_sheet.dart',
    'toss_chip.dart',
    'toss_dropdown.dart',
    'toss_primary_button.dart',
    'toss_secondary_button.dart',
    'toss_tab_bar.dart',
    'toss_selection_bottom_sheet.dart',
    'toss_keyboard_toolbar.dart',
    'toss_refresh_indicator.dart',
    'toss_time_picker.dart',
    'toss_app_bar.dart',
    'toss_date_picker.dart',
  ];
  
  // Widget patterns to analyze
  final widgetPatterns = {
    'TossButton': r'TossButton\s*\(',
    'TossPrimaryButton': r'TossPrimaryButton\s*\(',
    'TossSecondaryButton': r'TossSecondaryButton\s*\(',
    'TossCard': r'TossCard\s*\(',
    'TossListTile': r'TossListTile\s*\(',
    'TossModal': r'TossModal\s*\(',
    'TossBottomSheet': r'TossBottomSheet\s*\(',
    'TossChip': r'TossChip\s*\(',
    'TossDropdown': r'TossDropdown\s*\(',
    'TossTabBar': r'TossTabBar\s*\(',
    'TossAppBar': r'TossAppBar\s*\(',
    'TossDatePicker': r'TossDatePicker\s*\(',
    'TossKeyboardToolbar': r'TossKeyboardToolbar\s*\(',
    'TossRefreshIndicator': r'TossRefreshIndicator\s*\(',
    'TossTimePicker': r'TossTimePicker\s*\(',
    'SelectionBottomSheetCommon': r'SelectionBottomSheetCommon\s*\(',
  };
  
  // Patterns indicating potential widget duplication
  final duplicationPatterns = {
    'Container+BoxDecoration': r'Container\s*\([^)]*BoxDecoration',
    'Scaffold+AppBar': r'Scaffold\s*\([^)]*appBar:',
    'ElevatedButton': r'ElevatedButton\s*\(',
    'TextButton': r'TextButton\s*\(',
    'IconButton': r'IconButton\s*\(',
    'Card': r'Card\s*\(',
    'ListTile': r'ListTile\s*\(',
    'showModalBottomSheet': r'showModalBottomSheet\s*\(',
    'showDialog': r'showDialog\s*\(',
  };
  
  // Hardcoded style patterns
  final hardcodedPatterns = {
    'Colors.': r'Colors\.\w+',
    'TextStyle': r'TextStyle\s*\(',
    'EdgeInsets': r'EdgeInsets\.',
    'BorderRadius': r'BorderRadius\.',
    'BoxDecoration': r'BoxDecoration\s*\(',
    'fontSize:': r'fontSize:\s*[\d\.]+',
    'fontWeight:': r'fontWeight:\s*FontWeight\.',
    'color:': r'color:\s*Colors\.',
  };

  Future<void> analyzeProject(String projectPath) async {
    print('Starting Widget Usage Analysis...\n');
    print('=' * 60);
    
    final libDir = Directory(path.join(projectPath, 'lib'));
    if (!libDir.existsSync()) {
      print('Error: lib directory not found');
      return;
    }
    
    await _analyzeDirectory(libDir);
    _generateReport();
  }
  
  Future<void> _analyzeDirectory(Directory dir) async {
    final files = dir.listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart') && 
                        !file.path.contains('.g.dart') &&
                        !file.path.contains('.freezed.dart'),)
        .toList();
    
    for (final file in files) {
      await _analyzeFile(file);
    }
  }
  
  Future<void> _analyzeFile(File file) async {
    final content = await file.readAsString();
    final fileName = path.basename(file.path);
    final relativePath = path.relative(file.path);
    
    // Check widget usage
    for (final entry in widgetPatterns.entries) {
      final matches = RegExp(entry.value).allMatches(content);
      if (matches.isNotEmpty) {
        widgetUsageCount[entry.key] = (widgetUsageCount[entry.key] ?? 0) + matches.length;
        widgetUsageLocations[entry.key] ??= [];
        widgetUsageLocations[entry.key]!.add('$relativePath (${matches.length}x)');
      }
    }
    
    // Check for potential duplications
    for (final entry in duplicationPatterns.entries) {
      final matches = RegExp(entry.value).allMatches(content);
      if (matches.isNotEmpty) {
        duplicatePatterns[entry.key] = (duplicatePatterns[entry.key] ?? 0) + matches.length;
      }
    }
    
    // Check for hardcoded styles
    for (final entry in hardcodedPatterns.entries) {
      final matches = RegExp(entry.value).allMatches(content);
      if (matches.isNotEmpty) {
        hardcodedStyles[entry.key] = (hardcodedStyles[entry.key] ?? 0) + matches.length;
      }
    }
    
    // Check for missing widget imports
    bool usesTossWidgets = widgetPatterns.values.any((pattern) => 
        RegExp(pattern).hasMatch(content),);
    bool hasTossImport = commonWidgetImports.any((import) => 
        content.contains(import),);
    
    if (usesTossWidgets && !hasTossImport && !fileName.contains('toss_')) {
      inconsistencies.add('Missing Toss widget import in $relativePath');
    }
  }
  
  void _generateReport() {
    print('\n📊 WIDGET USAGE ANALYSIS REPORT');
    print('=' * 60);
    
    // Widget Usage Statistics
    print('\n✅ Common Widget Usage:');
    print('-' * 40);
    final sortedUsage = widgetUsageCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedUsage) {
      print('  ${entry.key}: ${entry.value} occurrences');
      if (entry.value < 5) {
        print('    ⚠️  Low usage - consider if this widget is necessary');
      }
    }
    
    // Unused widgets
    print('\n❌ Potentially Unused Widgets:');
    print('-' * 40);
    for (final widgetName in widgetPatterns.keys) {
      if (!widgetUsageCount.containsKey(widgetName)) {
        print('  $widgetName - Not found in codebase');
      }
    }
    
    // Duplication Opportunities
    print('\n🔄 Duplication Patterns (Opportunities for Common Widgets):');
    print('-' * 40);
    final sortedDuplicates = duplicatePatterns.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedDuplicates) {
      print('  ${entry.key}: ${entry.value} instances');
      if (entry.value > 10) {
        print('    💡 High duplication - strong candidate for common widget');
      }
    }
    
    // Hardcoded Styles
    print('\n⚠️  Hardcoded Styles (Should Use Theme):');
    print('-' * 40);
    final sortedHardcoded = hardcodedStyles.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    int totalHardcoded = 0;
    for (final entry in sortedHardcoded) {
      print('  ${entry.key}: ${entry.value} instances');
      totalHardcoded += entry.value;
    }
    print('  Total: $totalHardcoded hardcoded style instances');
    
    // Inconsistencies
    if (inconsistencies.isNotEmpty) {
      print('\n🔍 Inconsistencies Found:');
      print('-' * 40);
      for (final issue in inconsistencies.take(10)) {
        print('  $issue');
      }
      if (inconsistencies.length > 10) {
        print('  ... and ${inconsistencies.length - 10} more');
      }
    }
    
    // Recommendations
    print('\n💡 RECOMMENDATIONS:');
    print('=' * 60);
    
    // Calculate metrics
    final totalWidgetUsage = widgetUsageCount.values.fold(0, (a, b) => a + b);
    final avgUsagePerWidget = totalWidgetUsage / (widgetUsageCount.isNotEmpty ? widgetUsageCount.length : 1);
    
    print('📈 Metrics:');
    print('  • Total Toss widget usage: $totalWidgetUsage');
    print('  • Average usage per widget: ${avgUsagePerWidget.toStringAsFixed(1)}');
    print('  • Hardcoded styles to fix: $totalHardcoded');
    print('  • Duplication opportunities: ${duplicatePatterns.length}');
    
    print('\n🎯 Priority Actions:');
    
    // High duplication areas
    final highDuplication = sortedDuplicates.where((e) => e.value > 20).toList();
    if (highDuplication.isNotEmpty) {
      print('\n1. Create common widgets for high-duplication patterns:');
      for (final entry in highDuplication.take(3)) {
        print('   • ${entry.key}: ${entry.value} instances');
        if (entry.key == 'Container+BoxDecoration') {
          print('     → Consider using TossCard or creating TossContainer');
        } else if (entry.key == 'ElevatedButton') {
          print('     → Migrate to TossPrimaryButton');
        } else if (entry.key == 'TextButton') {
          print('     → Migrate to TossSecondaryButton');
        } else if (entry.key == 'Card') {
          print('     → Migrate to TossCard');
        } else if (entry.key == 'ListTile') {
          print('     → Migrate to TossListTile');
        }
      }
    }
    
    // Low usage widgets
    final lowUsage = sortedUsage.where((e) => e.value < 3).toList();
    if (lowUsage.isNotEmpty) {
      print('\n2. Review low-usage widgets for potential removal:');
      for (final entry in lowUsage) {
        print('   • ${entry.key}: only ${entry.value} uses');
      }
    }
    
    // Hardcoded styles
    if (totalHardcoded > 100) {
      print('\n3. Replace hardcoded styles with theme references:');
      print('   • ${hardcodedStyles['Colors.'] ?? 0} hardcoded colors → Use TossColors');
      print('   • ${hardcodedStyles['TextStyle'] ?? 0} inline TextStyles → Use theme.textTheme');
      print('   • ${hardcodedStyles['EdgeInsets'] ?? 0} hardcoded padding → Use theme constants');
    }
    
    print('\n🚀 Potential Impact:');
    final reductionPotential = ((duplicatePatterns.values.fold(0, (a, b) => a + b) / 
                                (totalWidgetUsage + duplicatePatterns.values.fold(0, (a, b) => a + b))) * 100);
    print('  • Code reduction potential: ${reductionPotential.toStringAsFixed(1)}%');
    print('  • Consistency improvement: High');
    print('  • Maintenance benefit: Significant');
    
    print('\n${'=' * 60}');
    print('Analysis Complete!');
  }
}

// Usage example
void main() async {
  final analyzer = WidgetAnalyzer();
  await analyzer.analyzeProject('/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1');
}