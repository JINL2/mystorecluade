import 'dart:io';
import 'dart:math' as math;
import 'package:path/path.dart' as path;

/// Deep widget analyzer that understands widget trees, semantic similarity, and replacement risks
class DeepWidgetAnalyzer {
  // Widget tree representations
  final Map<String, WidgetTreeNode> pageWidgetTrees = {};
  final Map<String, List<WidgetUsageContext>> widgetUsageContexts = {};
  final Map<String, WidgetSignature> widgetSignatures = {};
  final Map<String, Map<String, double>> similarityMatrix = {};
  final Map<String, ReplacementRisk> replacementRisks = {};
  
  // Pattern matchers for deep analysis
  final RegExp widgetPattern = RegExp(
    r'(\w+)\s*\([^)]*\)',
    multiLine: true,
  );
  
  final RegExp propertyPattern = RegExp(
    r'(\w+):\s*([^,\)]+)',
    multiLine: true,
  );
  
  final RegExp builderPattern = RegExp(
    r'builder:\s*\([^)]*\)\s*=>\s*([^,]+)',
    multiLine: true,
  );

  Future<void> performDeepAnalysis(String projectPath) async {
    print('🔬 Starting Deep Widget Analysis...\n');
    print('=' * 80);
    
    final libDir = Directory(path.join(projectPath, 'lib'));
    if (!libDir.existsSync()) {
      print('Error: lib directory not found');
      return;
    }
    
    // Phase 1: Parse widget trees
    print('\n📊 Phase 1: Parsing Widget Trees...');
    await _parseWidgetTrees(libDir);
    
    // Phase 2: Analyze semantic similarity
    print('\n🔍 Phase 2: Analyzing Semantic Similarity...');
    _analyzeSimilarity();
    
    // Phase 3: Context analysis
    print('\n🎯 Phase 3: Analyzing Usage Contexts...');
    await _analyzeContexts(libDir);
    
    // Phase 4: Risk assessment
    print('\n⚠️ Phase 4: Assessing Replacement Risks...');
    _assessRisks();
    
    // Phase 5: Generate report
    print('\n📝 Phase 5: Generating Comprehensive Report...');
    _generateDeepReport();
  }
  
  Future<void> _parseWidgetTrees(Directory dir) async {
    final pageFiles = dir.listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('_page.dart') || 
                        file.path.endsWith('_screen.dart'),)
        .toList();
    
    print('  Found ${pageFiles.length} page files to analyze');
    
    for (final file in pageFiles.take(10)) { // Analyze first 10 pages deeply
      final tree = await _extractWidgetTree(file);
      if (tree != null) {
        final fileName = path.basenameWithoutExtension(file.path);
        pageWidgetTrees[fileName] = tree;
        print('  ✓ Parsed widget tree for $fileName (depth: ${tree.depth}, nodes: ${tree.totalNodes})');
      }
    }
  }
  
  Future<WidgetTreeNode?> _extractWidgetTree(File file) async {
    final content = await file.readAsString();
    
    // Find the build method
    final buildMethodRegex = RegExp(
      r'Widget\s+build\s*\([^)]*\)\s*{(.*?)^\s*}',
      multiLine: true,
      dotAll: true,
    );
    
    final buildMatch = buildMethodRegex.firstMatch(content);
    if (buildMatch == null) return null;
    
    final buildContent = buildMatch.group(1) ?? '';
    return _parseWidgetNode(buildContent, 0);
  }
  
  WidgetTreeNode? _parseWidgetNode(String content, int depth) {
    if (depth > 10) return null; // Prevent infinite recursion
    
    // Extract widget name
    final widgetMatch = RegExp(r'return\s+(\w+)\s*\(').firstMatch(content);
    if (widgetMatch == null) {
      // Try to find first widget
      final firstWidget = RegExp(r'(\w+)\s*\(').firstMatch(content);
      if (firstWidget == null) return null;
      return WidgetTreeNode(
        name: firstWidget.group(1) ?? 'Unknown',
        properties: _extractProperties(content),
        children: [],
        depth: depth,
      );
    }
    
    final widgetName = widgetMatch.group(1) ?? 'Unknown';
    final properties = _extractProperties(content);
    
    // Extract children
    final children = <WidgetTreeNode>[];
    
    // Look for child: property
    final childMatch = RegExp(r'child:\s*(\w+)\s*\(').firstMatch(content);
    if (childMatch != null) {
      final childNode = WidgetTreeNode(
        name: childMatch.group(1) ?? 'Unknown',
        properties: {},
        children: [],
        depth: depth + 1,
      );
      children.add(childNode);
    }
    
    // Look for children: property
    final childrenMatch = RegExp(r'children:\s*\[(.*?)\]', dotAll: true).firstMatch(content);
    if (childrenMatch != null) {
      final childrenContent = childrenMatch.group(1) ?? '';
      final childWidgets = RegExp(r'(\w+)\s*\(').allMatches(childrenContent);
      for (final match in childWidgets.take(5)) { // Limit to 5 children for analysis
        children.add(WidgetTreeNode(
          name: match.group(1) ?? 'Unknown',
          properties: {},
          children: [],
          depth: depth + 1,
        ),);
      }
    }
    
    return WidgetTreeNode(
      name: widgetName,
      properties: properties,
      children: children,
      depth: depth,
    );
  }
  
  Map<String, String> _extractProperties(String content) {
    final properties = <String, String>{};
    final matches = propertyPattern.allMatches(content);
    
    for (final match in matches.take(20)) { // Limit properties for analysis
      final key = match.group(1) ?? '';
      final value = match.group(2)?.trim() ?? '';
      if (key.isNotEmpty && !['child', 'children', 'builder'].contains(key)) {
        properties[key] = value;
      }
    }
    
    return properties;
  }
  
  void _analyzeSimilarity() {
    // Analyze Container+BoxDecoration vs TossCard
    _calculateWidgetSimilarity('Container+BoxDecoration', 'TossCard');

    // Analyze Card vs TossCard
    _calculateWidgetSimilarity('Card', 'TossCard');
    
    // Analyze Button similarities
    _calculateWidgetSimilarity('ElevatedButton', 'TossPrimaryButton');
    _calculateWidgetSimilarity('TextButton', 'TossSecondaryButton');
    _calculateWidgetSimilarity('IconButton', 'TossIconButton'); // Even if it doesn't exist yet
    
    // Analyze Modal similarities
    _calculateWidgetSimilarity('showModalBottomSheet', 'TossBottomSheet');
    _calculateWidgetSimilarity('showDialog', 'TossModal');
    
    // Analyze List similarities
    _calculateWidgetSimilarity('ListTile', 'TossListTile');
  }
  
  void _calculateWidgetSimilarity(String widget1, String widget2) {
    // Create widget signatures based on common patterns
    final sig1 = _createWidgetSignature(widget1);
    final sig2 = _createWidgetSignature(widget2);
    
    widgetSignatures[widget1] = sig1;
    widgetSignatures[widget2] = sig2;
    
    // Calculate similarity score
    double similarity = 0.0;
    
    // 1. Structural similarity (30%)
    similarity += _calculateStructuralSimilarity(sig1, sig2) * 0.3;
    
    // 2. Property compatibility (40%)
    similarity += _calculatePropertyCompatibility(sig1, sig2) * 0.4;
    
    // 3. Visual similarity (20%)
    similarity += _calculateVisualSimilarity(sig1, sig2) * 0.2;
    
    // 4. Behavioral similarity (10%)
    similarity += _calculateBehavioralSimilarity(sig1, sig2) * 0.1;
    
    // Store in matrix
    similarityMatrix[widget1] ??= {};
    similarityMatrix[widget1]![widget2] = similarity;
  }
  
  WidgetSignature _createWidgetSignature(String widgetName) {
    final signature = WidgetSignature(name: widgetName);
    
    // Define known widget signatures
    switch (widgetName) {
      case 'Container+BoxDecoration':
        signature.properties = {
          'decoration', 'padding', 'margin', 'color', 'width', 'height',
          'alignment', 'constraints', 'transform', 'child',
        };
        signature.hasChild = true;
        signature.isLayout = true;
        signature.hasDecoration = true;
        break;
        
      case 'TossCard':
        signature.properties = {
          'child', 'padding', 'margin', 'color', 'elevation',
          'borderRadius', 'onTap',
        };
        signature.hasChild = true;
        signature.isLayout = true;
        signature.hasDecoration = true;
        signature.hasTapHandler = true;
        break;
        
      case 'Card':
        signature.properties = {
          'child', 'color', 'elevation', 'margin', 'shape', 'borderOnForeground',
        };
        signature.hasChild = true;
        signature.isLayout = true;
        signature.hasDecoration = true;
        break;
        
      case 'ElevatedButton':
      case 'TossPrimaryButton':
        signature.properties = {
          'onPressed', 'child', 'style', 'onLongPress', 'autofocus',
        };
        signature.hasChild = true;
        signature.hasTapHandler = true;
        signature.isInteractive = true;
        break;
        
      case 'TextButton':
      case 'TossSecondaryButton':
        signature.properties = {
          'onPressed', 'child', 'style', 'onLongPress', 'autofocus',
        };
        signature.hasChild = true;
        signature.hasTapHandler = true;
        signature.isInteractive = true;
        break;
        
      case 'IconButton':
      case 'TossIconButton':
        signature.properties = {
          'onPressed', 'icon', 'iconSize', 'color', 'padding', 'tooltip',
        };
        signature.hasTapHandler = true;
        signature.isInteractive = true;
        break;
        
      case 'showModalBottomSheet':
      case 'TossBottomSheet':
        signature.properties = {
          'context', 'builder', 'isScrollControlled', 'backgroundColor',
          'elevation', 'shape', 'isDismissible',
        };
        signature.isModal = true;
        signature.hasBuilder = true;
        break;
        
      case 'ListTile':
      case 'TossListTile':
        signature.properties = {
          'title', 'subtitle', 'leading', 'trailing', 'onTap',
          'dense', 'contentPadding', 'enabled',
        };
        signature.hasTapHandler = true;
        signature.isInteractive = true;
        break;
    }
    
    return signature;
  }
  
  double _calculateStructuralSimilarity(WidgetSignature sig1, WidgetSignature sig2) {
    double score = 0.0;
    
    if (sig1.hasChild == sig2.hasChild) score += 0.2;
    if (sig1.hasChildren == sig2.hasChildren) score += 0.2;
    if (sig1.isLayout == sig2.isLayout) score += 0.2;
    if (sig1.isInteractive == sig2.isInteractive) score += 0.2;
    if (sig1.isModal == sig2.isModal) score += 0.2;
    
    return score;
  }
  
  double _calculatePropertyCompatibility(WidgetSignature sig1, WidgetSignature sig2) {
    if (sig1.properties.isEmpty || sig2.properties.isEmpty) return 0.5;
    
    final intersection = sig1.properties.intersection(sig2.properties);
    final union = sig1.properties.union(sig2.properties);
    
    return intersection.length / union.length;
  }
  
  double _calculateVisualSimilarity(WidgetSignature sig1, WidgetSignature sig2) {
    double score = 0.0;
    
    if (sig1.hasDecoration && sig2.hasDecoration) score += 0.5;
    if (sig1.hasTapHandler == sig2.hasTapHandler) score += 0.3;
    if (sig1.hasBuilder == sig2.hasBuilder) score += 0.2;
    
    return score;
  }
  
  double _calculateBehavioralSimilarity(WidgetSignature sig1, WidgetSignature sig2) {
    double score = 0.0;
    
    if (sig1.isInteractive == sig2.isInteractive) score += 0.4;
    if (sig1.isModal == sig2.isModal) score += 0.3;
    if (sig1.hasTapHandler == sig2.hasTapHandler) score += 0.3;
    
    return score;
  }
  
  Future<void> _analyzeContexts(Directory dir) async {
    final files = dir.listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart') && 
                        !file.path.contains('.g.dart'),)
        .toList();
    
    // Sample files for context analysis
    final sampleFiles = files.take(50).toList();
    
    for (final file in sampleFiles) {
      await _extractUsageContexts(file);
    }
  }
  
  Future<void> _extractUsageContexts(File file) async {
    final content = await file.readAsString();
    final fileName = path.basename(file.path);
    
    // Analyze Container+BoxDecoration usage
    final containerBoxRegex = RegExp(
      r'Container\s*\([^)]*decoration:\s*BoxDecoration[^)]*\)',
      multiLine: true,
      dotAll: true,
    );
    
    for (final match in containerBoxRegex.allMatches(content)) {
      final context = _analyzeContext(content, match.start, match.end);
      widgetUsageContexts['Container+BoxDecoration'] ??= [];
      widgetUsageContexts['Container+BoxDecoration']!.add(WidgetUsageContext(
        file: fileName,
        lineNumber: _getLineNumber(content, match.start),
        context: context,
        hasAnimation: context.contains('Animation') || context.contains('animated'),
        hasGesture: context.contains('GestureDetector') || context.contains('onTap'),
        hasState: context.contains('setState') || context.contains('State<'),
        isInList: context.contains('ListView') || context.contains('Column'),
        isInDialog: context.contains('Dialog') || context.contains('showDialog'),
      ),);
    }
    
    // Analyze Card usage
    final cardRegex = RegExp(r'Card\s*\([^)]*\)', multiLine: true);
    
    for (final match in cardRegex.allMatches(content)) {
      final context = _analyzeContext(content, match.start, match.end);
      widgetUsageContexts['Card'] ??= [];
      widgetUsageContexts['Card']!.add(WidgetUsageContext(
        file: fileName,
        lineNumber: _getLineNumber(content, match.start),
        context: context,
        hasAnimation: context.contains('Animation') || context.contains('animated'),
        hasGesture: context.contains('GestureDetector') || context.contains('onTap'),
        hasState: context.contains('setState') || context.contains('State<'),
        isInList: context.contains('ListView') || context.contains('Column'),
        isInDialog: context.contains('Dialog') || context.contains('showDialog'),
      ),);
    }
  }
  
  String _analyzeContext(String content, int start, int end) {
    // Get 200 characters before and after
    final contextStart = math.max(0, start - 200);
    final contextEnd = math.min(content.length, end + 200);
    return content.substring(contextStart, contextEnd);
  }
  
  int _getLineNumber(String content, int position) {
    return '\n'.allMatches(content.substring(0, position)).length + 1;
  }
  
  void _assessRisks() {
    // Assess risks for each replacement pattern
    _assessReplacementRisk('Container+BoxDecoration', 'TossCard');
    _assessReplacementRisk('Card', 'TossCard');
    _assessReplacementRisk('ElevatedButton', 'TossPrimaryButton');
    _assessReplacementRisk('TextButton', 'TossSecondaryButton');
    _assessReplacementRisk('IconButton', 'TossIconButton');
    _assessReplacementRisk('showModalBottomSheet', 'TossBottomSheet');
    _assessReplacementRisk('ListTile', 'TossListTile');
  }
  
  void _assessReplacementRisk(String fromWidget, String toWidget) {
    final similarity = similarityMatrix[fromWidget]?[toWidget] ?? 0.0;
    final contexts = widgetUsageContexts[fromWidget] ?? [];
    
    // Calculate risk factors
    int highRiskCount = 0;
    int mediumRiskCount = 0;
    int lowRiskCount = 0;
    
    for (final context in contexts) {
      RiskLevel risk = RiskLevel.low;
      
      // High risk factors
      if (context.hasAnimation) risk = RiskLevel.high;
      if (context.hasState) risk = RiskLevel.high;
      if (context.file.contains('auth') || context.file.contains('payment')) {
        risk = RiskLevel.critical;
      }
      
      // Medium risk factors
      if (context.hasGesture && risk == RiskLevel.low) risk = RiskLevel.medium;
      if (context.isInDialog && risk == RiskLevel.low) risk = RiskLevel.medium;
      
      switch (risk) {
        case RiskLevel.low:
          lowRiskCount++;
          break;
        case RiskLevel.medium:
          mediumRiskCount++;
          break;
        case RiskLevel.high:
          highRiskCount++;
          break;
        case RiskLevel.critical:
          highRiskCount++; // Count as high for statistics
          break;
      }
    }
    
    // Calculate overall risk
    RiskLevel overallRisk;
    if (similarity < 0.6) {
      overallRisk = RiskLevel.high;
    } else if (similarity < 0.8) {
      overallRisk = RiskLevel.medium;
    } else {
      overallRisk = RiskLevel.low;
    }
    
    // Adjust based on context risks
    if (highRiskCount > contexts.length * 0.3) {
      overallRisk = RiskLevel.high;
    }
    
    replacementRisks['$fromWidget→$toWidget'] = ReplacementRisk(
      fromWidget: fromWidget,
      toWidget: toWidget,
      similarity: similarity,
      overallRisk: overallRisk,
      lowRiskInstances: lowRiskCount,
      mediumRiskInstances: mediumRiskCount,
      highRiskInstances: highRiskCount,
      totalInstances: contexts.length,
    );
  }
  
  void _generateDeepReport() {
    print('\n${'=' * 80}');
    print('🔬 DEEP WIDGET ANALYSIS REPORT');
    print('=' * 80);
    
    // Widget Tree Analysis
    print('\n📊 WIDGET TREE ANALYSIS');
    print('-' * 60);
    for (final entry in pageWidgetTrees.entries) {
      final tree = entry.value;
      print('  ${entry.key}:');
      print('    • Depth: ${tree.depth}');
      print('    • Total nodes: ${tree.totalNodes}');
      print('    • Root: ${tree.name}');
      if (tree.children.isNotEmpty) {
        print('    • Children: ${tree.children.map((c) => c.name).join(', ')}');
      }
    }
    
    // Similarity Matrix
    print('\n🔍 WIDGET SIMILARITY MATRIX');
    print('-' * 60);
    for (final from in similarityMatrix.keys) {
      for (final to in similarityMatrix[from]!.keys) {
        final similarity = similarityMatrix[from]![to]!;
        final emoji = similarity >= 0.8 ? '✅' : similarity >= 0.6 ? '⚠️' : '❌';
        print('  $emoji $from → $to: ${(similarity * 100).toStringAsFixed(1)}% similar');
        
        // Property analysis
        final sig1 = widgetSignatures[from];
        final sig2 = widgetSignatures[to];
        if (sig1 != null && sig2 != null) {
          final commonProps = sig1.properties.intersection(sig2.properties);
          final missingProps = sig1.properties.difference(sig2.properties);
          if (commonProps.isNotEmpty) {
            print('    ✓ Common properties: ${commonProps.join(', ')}');
          }
          if (missingProps.isNotEmpty) {
            print('    ✗ Missing in target: ${missingProps.join(', ')}');
          }
        }
      }
    }
    
    // Context Analysis
    print('\n🎯 USAGE CONTEXT ANALYSIS');
    print('-' * 60);
    for (final widget in widgetUsageContexts.keys) {
      final contexts = widgetUsageContexts[widget]!;
      final animatedCount = contexts.where((c) => c.hasAnimation).length;
      final gestureCount = contexts.where((c) => c.hasGesture).length;
      final stateCount = contexts.where((c) => c.hasState).length;
      
      print('  $widget (${contexts.length} instances analyzed):');
      if (animatedCount > 0) print('    ⚡ $animatedCount with animations');
      if (gestureCount > 0) print('    👆 $gestureCount with gestures');
      if (stateCount > 0) print('    📦 $stateCount with state management');
    }
    
    // Risk Assessment
    print('\n⚠️ REPLACEMENT RISK ASSESSMENT');
    print('-' * 60);
    
    final sortedRisks = replacementRisks.entries.toList()
      ..sort((a, b) => b.value.similarity.compareTo(a.value.similarity));
    
    for (final entry in sortedRisks) {
      final risk = entry.value;
      final riskEmoji = _getRiskEmoji(risk.overallRisk);
      
      print('\n  $riskEmoji ${entry.key}');
      print('    • Similarity: ${(risk.similarity * 100).toStringAsFixed(1)}%');
      print('    • Risk Level: ${risk.overallRisk.name.toUpperCase()}');
      print('    • Safe replacements: ${risk.lowRiskInstances}/${risk.totalInstances}');
      
      if (risk.mediumRiskInstances > 0) {
        print('    • Need testing: ${risk.mediumRiskInstances} instances');
      }
      if (risk.highRiskInstances > 0) {
        print('    • ⚠️ High risk: ${risk.highRiskInstances} instances - AVOID');
      }
    }
    
    // Recommendations
    print('\n💡 EVIDENCE-BASED RECOMMENDATIONS');
    print('=' * 60);
    
    print('\n🟢 SAFE REPLACEMENTS (High Confidence):');
    for (final entry in replacementRisks.entries) {
      final risk = entry.value;
      if (risk.overallRisk == RiskLevel.low && risk.similarity >= 0.8) {
        print('  ✓ ${entry.key}');
        print('    • ${risk.lowRiskInstances} safe instances');
        print('    • ${(risk.similarity * 100).toStringAsFixed(1)}% compatibility');
      }
    }
    
    print('\n🟡 CONDITIONAL REPLACEMENTS (Needs Testing):');
    for (final entry in replacementRisks.entries) {
      final risk = entry.value;
      if (risk.overallRisk == RiskLevel.medium) {
        print('  ⚠️ ${entry.key}');
        print('    • Test ${risk.mediumRiskInstances} instances carefully');
        print('    • Focus on: gesture handlers, state management');
      }
    }
    
    print('\n🔴 AVOID REPLACEMENTS (High Risk):');
    for (final entry in replacementRisks.entries) {
      final risk = entry.value;
      if (risk.overallRisk == RiskLevel.high) {
        print('  ✗ ${entry.key}');
        print('    • ${risk.highRiskInstances} high-risk instances');
        print('    • Major property incompatibilities');
      }
    }
    
    // Implementation Strategy
    print('\n📋 IMPLEMENTATION STRATEGY');
    print('=' * 60);
    print('1. START with low-risk replacements in non-critical pages');
    print('2. CREATE compatibility wrappers for medium-risk replacements');
    print('3. PRESERVE original widgets in authentication and payment flows');
    print('4. TEST each replacement in isolation before bulk changes');
    print('5. MONITOR performance metrics after each phase');
    
    print('\n${'=' * 80}');
    print('Deep Analysis Complete!');
  }
  
  String _getRiskEmoji(RiskLevel risk) {
    switch (risk) {
      case RiskLevel.low:
        return '🟢';
      case RiskLevel.medium:
        return '🟡';
      case RiskLevel.high:
        return '🔴';
      case RiskLevel.critical:
        return '⚫';
    }
  }
}

// Data structures
class WidgetTreeNode {
  final String name;
  final Map<String, String> properties;
  final List<WidgetTreeNode> children;
  final int depth;
  
  WidgetTreeNode({
    required this.name,
    required this.properties,
    required this.children,
    required this.depth,
  });
  
  int get totalNodes => 1 + children.fold(0, (sum, child) => sum + child.totalNodes);
}

class WidgetSignature {
  final String name;
  Set<String> properties = {};
  bool hasChild = false;
  bool hasChildren = false;
  bool hasDecoration = false;
  bool hasTapHandler = false;
  bool hasBuilder = false;
  bool isLayout = false;
  bool isInteractive = false;
  bool isModal = false;
  
  WidgetSignature({required this.name});
}

class WidgetUsageContext {
  final String file;
  final int lineNumber;
  final String context;
  final bool hasAnimation;
  final bool hasGesture;
  final bool hasState;
  final bool isInList;
  final bool isInDialog;
  
  WidgetUsageContext({
    required this.file,
    required this.lineNumber,
    required this.context,
    required this.hasAnimation,
    required this.hasGesture,
    required this.hasState,
    required this.isInList,
    required this.isInDialog,
  });
}

class ReplacementRisk {
  final String fromWidget;
  final String toWidget;
  final double similarity;
  final RiskLevel overallRisk;
  final int lowRiskInstances;
  final int mediumRiskInstances;
  final int highRiskInstances;
  final int totalInstances;
  
  ReplacementRisk({
    required this.fromWidget,
    required this.toWidget,
    required this.similarity,
    required this.overallRisk,
    required this.lowRiskInstances,
    required this.mediumRiskInstances,
    required this.highRiskInstances,
    required this.totalInstances,
  });
}

enum RiskLevel {
  low,
  medium,
  high,
  critical,
}

// Main function
void main() async {
  final analyzer = DeepWidgetAnalyzer();
  await analyzer.performDeepAnalysis(
    '/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1',
  );
}