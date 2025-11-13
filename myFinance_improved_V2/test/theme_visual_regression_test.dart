import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:myfinance_improved/main.dart' as app;
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_button.dart';
import 'package:myfinance_improved/presentation/widgets/common/toss_card.dart';
import 'package:myfinance_improved/presentation/widgets/toss/toss_text_field.dart';

/// Visual regression testing suite for theme consistency
/// 
/// Features:
/// - Screenshot comparison across theme changes
/// - Component visual validation
/// - Responsive design testing
/// - Color accuracy verification
/// - Typography consistency checks
/// - Animation behavior validation
class ThemeVisualRegressionTest {
  static const String baselineDir = 'test/screenshots/baseline';
  static const String currentDir = 'test/screenshots/current';
  static const String diffDir = 'test/screenshots/diff';
  
  final IntegrationTestWidgetsFlutterBinding binding;
  final Map<String, Uint8List> _baselineScreenshots = {};
  final Map<String, Uint8List> _currentScreenshots = {};
  final List<VisualDifference> _differences = [];
  
  ThemeVisualRegressionTest(this.binding);
  
  /// Initialize visual regression testing
  Future<void> initialize() async {
    // Ensure screenshot directories exist
    await _ensureDirectoriesExist();
    
    // Load existing baseline screenshots
    await _loadBaselineScreenshots();
  }
  
  /// Run complete visual regression test suite
  Future<VisualTestReport> runFullTestSuite() async {
    final report = VisualTestReport();
    
    try {
      // Test theme components
      await _testThemeComponents(report);
      
      // Test responsive behavior
      await _testResponsiveBehavior(report);
      
      // Test dark/light mode consistency (if applicable)
      await _testThemeModeConsistency(report);
      
      // Test animation consistency
      await _testAnimationConsistency(report);
      
      // Test color accessibility
      await _testColorAccessibility(report);
      
      // Generate difference images
      await _generateDifferenceImages(report);
      
      report.isSuccess = _differences.isEmpty;
      report.summary = _generateSummary();
      
    } catch (e) {
      report.isSuccess = false;
      report.error = e.toString();
    }
    
    return report;
  }
  
  /// Test individual theme components
  Future<void> _testThemeComponents(VisualTestReport report) async {
    final components = [
      _buildButtonComponent(),
      _buildCardComponent(),
      _buildTextFieldComponent(),
      _buildTypographyShowcase(),
      _buildColorPalette(),
      _buildSpacingShowcase(),
      _buildBorderRadiusShowcase(),
    ];
    
    for (int i = 0; i < components.length; i++) {
      final component = components[i];
      final testName = _getComponentTestName(i);
      
      await _testComponent(
        testName: testName,
        widget: component,
        report: report,
      );
    }
  }
  
  /// Test component with visual comparison
  Future<void> _testComponent({
    required String testName,
    required Widget widget,
    required VisualTestReport report,
    Size? customSize,
  }) async {
    await binding.runTest(
      () async {
        // Build the test widget
        final testWidget = MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            backgroundColor: TossColors.background,
            body: Center(child: widget),
          ),
        );
        
        await binding.pumpWidget(testWidget);
        await binding.pumpAndSettle();
        
        // Take screenshot
        final screenshot = await binding.takeScreenshot(testName);
        _currentScreenshots[testName] = screenshot;
        
        // Compare with baseline
        if (_baselineScreenshots.containsKey(testName)) {
          final diff = await _compareScreenshots(
            testName,
            _baselineScreenshots[testName]!,
            screenshot,
          );
          
          if (diff != null) {
            _differences.add(diff);
            report.failures.add(ComponentTestFailure(
              componentName: testName,
              difference: diff,
            ),);
          } else {
            report.successes.add(testName);
          }
        } else {
          // No baseline - save as baseline
          await _saveBaselineScreenshot(testName, screenshot);
          report.newBaselines.add(testName);
        }
      },
    );
  }
  
  /// Test responsive behavior across different screen sizes
  Future<void> _testResponsiveBehavior(VisualTestReport report) async {
    final screenSizes = [
      const Size(375, 667),   // iPhone SE
      const Size(414, 896),   // iPhone 11
      const Size(768, 1024),  // iPad
      const Size(1920, 1080), // Desktop
    ];
    
    final testWidget = _buildResponsiveTestWidget();
    
    for (final size in screenSizes) {
      binding.window.physicalSizeTestValue = size * binding.window.devicePixelRatio;
      binding.window.devicePixelRatioTestValue = 1.0;
      
      await _testComponent(
        testName: 'responsive_${size.width.toInt()}x${size.height.toInt()}',
        widget: testWidget,
        report: report,
        customSize: size,
      );
    }
  }
  
  /// Test theme mode consistency
  Future<void> _testThemeModeConsistency(VisualTestReport report) async {
    // Test light mode components
    await _testThemeModeComponents('light', AppTheme.lightTheme, report);
    
    // If dark mode is implemented, test it too
    // await _testThemeModeComponents('dark', AppTheme.darkTheme, report);
  }
  
  /// Test theme mode specific components
  Future<void> _testThemeModeComponents(String mode, ThemeData theme, VisualTestReport report) async {
    final components = [
      _buildButtonComponent(),
      _buildCardComponent(),
      _buildTextFieldComponent(),
    ];
    
    for (int i = 0; i < components.length; i++) {
      await binding.runTest(
        () async {
          final testWidget = MaterialApp(
            theme: theme,
            home: Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Center(child: components[i]),
            ),
          );
          
          await binding.pumpWidget(testWidget);
          await binding.pumpAndSettle();
          
          final testName = '${mode}_mode_component_$i';
          final screenshot = await binding.takeScreenshot(testName);
          _currentScreenshots[testName] = screenshot;
          
          if (_baselineScreenshots.containsKey(testName)) {
            final diff = await _compareScreenshots(
              testName,
              _baselineScreenshots[testName]!,
              screenshot,
            );
            
            if (diff != null) {
              _differences.add(diff);
              report.failures.add(ComponentTestFailure(
                componentName: testName,
                difference: diff,
              ),);
            }
          } else {
            await _saveBaselineScreenshot(testName, screenshot);
            report.newBaselines.add(testName);
          }
        },
      );
    }
  }
  
  /// Test animation consistency
  Future<void> _testAnimationConsistency(VisualTestReport report) async {
    await binding.runTest(
      () async {
        final testWidget = MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: _buildAnimationTestWidget(),
            ),
          ),
        );
        
        await binding.pumpWidget(testWidget);
        
        // Test animation at different stages
        final animationFrames = [0, 0.25, 0.5, 0.75, 1.0];
        
        for (final frame in animationFrames) {
          await binding.pump(Duration(milliseconds: (frame * 1000).toInt()));
          
          final testName = 'animation_frame_${(frame * 100).toInt()}';
          final screenshot = await binding.takeScreenshot(testName);
          _currentScreenshots[testName] = screenshot;
          
          if (_baselineScreenshots.containsKey(testName)) {
            final diff = await _compareScreenshots(
              testName,
              _baselineScreenshots[testName]!,
              screenshot,
            );
            
            if (diff != null) {
              _differences.add(diff);
            }
          } else {
            await _saveBaselineScreenshot(testName, screenshot);
            report.newBaselines.add(testName);
          }
        }
      },
    );
  }
  
  /// Test color accessibility
  Future<void> _testColorAccessibility(VisualTestReport report) async {
    final colorTests = [
      _buildContrastTestWidget(),
      _buildColorBlindnessTestWidget(),
    ];
    
    for (int i = 0; i < colorTests.length; i++) {
      await _testComponent(
        testName: 'accessibility_color_test_$i',
        widget: colorTests[i],
        report: report,
      );
    }
  }
  
  /// Compare two screenshots and return difference if any
  Future<VisualDifference?> _compareScreenshots(
    String testName,
    Uint8List baseline,
    Uint8List current,
  ) async {
    // Simple byte comparison first
    if (_areScreenshotsIdentical(baseline, current)) {
      return null;
    }
    
    // Calculate difference metrics
    final diffPercentage = _calculateDifferencePercentage(baseline, current);
    
    // Generate difference image
    final diffImage = await _generateDifferenceImage(baseline, current);
    
    return VisualDifference(
      testName: testName,
      differencePercentage: diffPercentage,
      diffImage: diffImage,
      baseline: baseline,
      current: current,
    );
  }
  
  /// Check if two screenshots are identical
  bool _areScreenshotsIdentical(Uint8List baseline, Uint8List current) {
    if (baseline.length != current.length) return false;
    
    for (int i = 0; i < baseline.length; i++) {
      if (baseline[i] != current[i]) return false;
    }
    
    return true;
  }
  
  /// Calculate difference percentage between screenshots
  double _calculateDifferencePercentage(Uint8List baseline, Uint8List current) {
    if (baseline.length != current.length) return 100.0;
    
    int differentPixels = 0;
    int totalPixels = baseline.length ~/ 4; // Assuming RGBA format
    
    for (int i = 0; i < baseline.length; i += 4) {
      final baselinePixel = [
        baseline[i],
        baseline[i + 1],
        baseline[i + 2],
        baseline[i + 3],
      ];
      
      final currentPixel = [
        current[i],
        current[i + 1],
        current[i + 2],
        current[i + 3],
      ];
      
      // Calculate color distance
      final distance = _calculateColorDistance(baselinePixel, currentPixel);
      
      // Consider pixels different if color distance > threshold
      if (distance > 10) {
        differentPixels++;
      }
    }
    
    return (differentPixels / totalPixels) * 100;
  }
  
  /// Calculate color distance between two pixels
  double _calculateColorDistance(List<int> pixel1, List<int> pixel2) {
    final rDiff = pixel1[0] - pixel2[0];
    final gDiff = pixel1[1] - pixel2[1];
    final bDiff = pixel1[2] - pixel2[2];
    final aDiff = pixel1[3] - pixel2[3];
    
    return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff + aDiff * aDiff);
  }
  
  /// Generate difference image highlighting changes
  Future<Uint8List> _generateDifferenceImage(Uint8List baseline, Uint8List current) async {
    // This is a simplified version - in practice, you'd use image processing libraries
    final diffImage = Uint8List.fromList(current);
    
    for (int i = 0; i < baseline.length; i += 4) {
      if (i + 3 < baseline.length && i + 3 < current.length) {
        final distance = _calculateColorDistance(
          [baseline[i], baseline[i + 1], baseline[i + 2], baseline[i + 3]],
          [current[i], current[i + 1], current[i + 2], current[i + 3]],
        );
        
        if (distance > 10) {
          // Highlight different pixels in red
          diffImage[i] = 255;     // Red
          diffImage[i + 1] = 0;   // Green
          diffImage[i + 2] = 0;   // Blue
          diffImage[i + 3] = 255; // Alpha
        }
      }
    }
    
    return diffImage;
  }
  
  /// Generate difference images for all detected differences
  Future<void> _generateDifferenceImages(VisualTestReport report) async {
    final diffDirectory = Directory(diffDir);
    if (!await diffDirectory.exists()) {
      await diffDirectory.create(recursive: true);
    }
    
    for (final diff in _differences) {
      // Save difference image
      final diffFile = File('$diffDir/${diff.testName}_diff.png');
      await diffFile.writeAsBytes(diff.diffImage);
      
      // Save current screenshot
      final currentFile = File('$currentDir/${diff.testName}_current.png');
      await currentFile.writeAsBytes(diff.current);
      
      // Copy baseline for easy comparison
      final baselineFile = File('$diffDir/${diff.testName}_baseline.png');
      await baselineFile.writeAsBytes(diff.baseline);
    }
  }
  
  /// Ensure screenshot directories exist
  Future<void> _ensureDirectoriesExist() async {
    final dirs = [baselineDir, currentDir, diffDir];
    
    for (final dir in dirs) {
      final directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  }
  
  /// Load existing baseline screenshots
  Future<void> _loadBaselineScreenshots() async {
    final baselineDirectory = Directory(baselineDir);
    
    if (await baselineDirectory.exists()) {
      await for (final file in baselineDirectory.list()) {
        if (file is File && file.path.endsWith('.png')) {
          final fileName = file.path.split('/').last.replaceAll('.png', '');
          _baselineScreenshots[fileName] = await file.readAsBytes();
        }
      }
    }
  }
  
  /// Save baseline screenshot
  Future<void> _saveBaselineScreenshot(String testName, Uint8List screenshot) async {
    final file = File('$baselineDir/$testName.png');
    await file.writeAsBytes(screenshot);
    _baselineScreenshots[testName] = screenshot;
  }
  
  /// Generate test summary
  String _generateSummary() {
    final totalTests = _currentScreenshots.length;
    final failedTests = _differences.length;
    final passedTests = totalTests - failedTests;
    
    return 'Visual Regression Test Summary:\n'
           'Total Tests: $totalTests\n'
           'Passed: $passedTests\n'
           'Failed: $failedTests\n'
           'Success Rate: ${((passedTests / totalTests) * 100).toStringAsFixed(1)}%';
  }
  
  /// Get component test name
  String _getComponentTestName(int index) {
    final names = [
      'button_component',
      'card_component',
      'text_field_component',
      'typography_showcase',
      'color_palette',
      'spacing_showcase',
      'border_radius_showcase',
    ];
    
    return index < names.length ? names[index] : 'component_$index';
  }
  
  /// Build test widgets
  Widget _buildButtonComponent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TossButton.primary(
          text: 'Primary Button',
          onPressed: () {},
        ),
        SizedBox(height: TossSpacing.space2),
        TossButton.secondary(
          text: 'Secondary Button',
          onPressed: () {},
        ),
        SizedBox(height: TossSpacing.space2),
        TossButton.text(
          text: 'Text Button',
          onPressed: () {},
        ),
      ],
    );
  }
  
  Widget _buildCardComponent() {
    return TossCard(
      child: Padding(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Title',
              style: TossTextStyles.h3,
            ),
            SizedBox(height: TossSpacing.space2),
            Text(
              'This is a sample card content to test visual consistency.',
              style: TossTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextFieldComponent() {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TossTextField(
            hintText: 'Enter text here',
            labelText: 'Sample Input',
          ),
          SizedBox(height: TossSpacing.space3),
          TossTextField(
            hintText: 'Error state',
            labelText: 'Error Input',
            errorText: 'This field has an error',
          ),
        ],
      ),
    );
  }
  
  Widget _buildTypographyShowcase() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Display Text', style: TossTextStyles.display),
          Text('Heading 1', style: TossTextStyles.h1),
          Text('Heading 2', style: TossTextStyles.h2),
          Text('Heading 3', style: TossTextStyles.h3),
          Text('Body Large', style: TossTextStyles.bodyLarge),
          Text('Body Text', style: TossTextStyles.body),
          Text('Caption Text', style: TossTextStyles.caption),
          Text('Small Text', style: TossTextStyles.small),
        ],
      ),
    );
  }
  
  Widget _buildColorPalette() {
    final colors = [
      {'name': 'Primary', 'color': TossColors.primary},
      {'name': 'Success', 'color': TossColors.success},
      {'name': 'Error', 'color': TossColors.error},
      {'name': 'Warning', 'color': TossColors.warning},
      {'name': 'Gray 500', 'color': TossColors.gray500},
    ];
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: colors.map((colorInfo) => Container(
          margin: EdgeInsets.only(right: TossSpacing.space2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colorInfo['color'] as Color,
                  borderRadius: BorderRadius.circular(TossSpacing.space2),
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                colorInfo['name'] as String,
                style: TossTextStyles.caption,
              ),
            ],
          ),
        ),).toList(),
      ),
    );
  }
  
  Widget _buildSpacingShowcase() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSpacingExample('Space 1', TossSpacing.space1),
          _buildSpacingExample('Space 2', TossSpacing.space2),
          _buildSpacingExample('Space 4', TossSpacing.space4),
          _buildSpacingExample('Space 6', TossSpacing.space6),
        ],
      ),
    );
  }
  
  Widget _buildSpacingExample(String label, double spacing) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TossTextStyles.caption),
        Container(
          width: spacing,
          height: 20,
          margin: EdgeInsets.symmetric(horizontal: TossSpacing.space2),
          decoration: BoxDecoration(
            color: TossColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBorderRadiusShowcase() {
    final radiusValues = [
      {'name': 'XS', 'value': TossBorderRadius.xs},
      {'name': 'SM', 'value': TossBorderRadius.sm},
      {'name': 'MD', 'value': TossBorderRadius.md},
      {'name': 'LG', 'value': TossBorderRadius.lg},
      {'name': 'XL', 'value': TossBorderRadius.xl},
    ];
    
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: radiusValues.map((radiusInfo) => Container(
          margin: EdgeInsets.only(right: TossSpacing.space3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(radiusInfo['value'] as double),
                ),
              ),
              SizedBox(height: TossSpacing.space1),
              Text(
                radiusInfo['name'] as String,
                style: TossTextStyles.caption,
              ),
            ],
          ),
        ),).toList(),
      ),
    );
  }
  
  Widget _buildResponsiveTestWidget() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Responsive Test', style: TossTextStyles.h2),
          SizedBox(height: TossSpacing.space4),
          Wrap(
            spacing: TossSpacing.space2,
            runSpacing: TossSpacing.space2,
            children: List.generate(6, (index) => TossButton.primary(
              text: 'Button ${index + 1}',
              onPressed: () {},
            ),),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimationTestWidget() {
    return AnimatedContainer(
      duration: TossAnimations.normal,
      curve: TossAnimations.standard,
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: TossColors.primary,
        borderRadius: BorderRadius.circular(TossBorderRadius.lg),
      ),
    );
  }
  
  Widget _buildContrastTestWidget() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Test text contrast on different backgrounds
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.primary,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              'White text on primary background',
              style: TossTextStyles.body.copyWith(color: TossColors.white),
            ),
          ),
          SizedBox(height: TossSpacing.space2),
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.gray100,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Text(
              'Dark text on light background',
              style: TossTextStyles.body.copyWith(color: TossColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildColorBlindnessTestWidget() {
    return Container(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Test color combinations that should be distinguishable
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TossColors.success,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(Icons.check, color: TossColors.white),
          ),
          SizedBox(width: TossSpacing.space2),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TossColors.error,
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Icon(Icons.close, color: TossColors.white),
          ),
        ],
      ),
    );
  }
}

/// Visual difference representation
class VisualDifference {
  final String testName;
  final double differencePercentage;
  final Uint8List diffImage;
  final Uint8List baseline;
  final Uint8List current;
  
  VisualDifference({
    required this.testName,
    required this.differencePercentage,
    required this.diffImage,
    required this.baseline,
    required this.current,
  });
  
  bool get isSignificant => differencePercentage > 0.1; // 0.1% threshold
}

/// Component test failure
class ComponentTestFailure {
  final String componentName;
  final VisualDifference difference;
  
  ComponentTestFailure({
    required this.componentName,
    required this.difference,
  });
}

/// Visual test report
class VisualTestReport {
  bool isSuccess = true;
  String? error;
  String summary = '';
  final List<String> successes = [];
  final List<ComponentTestFailure> failures = [];
  final List<String> newBaselines = [];
  
  int get totalTests => successes.length + failures.length + newBaselines.length;
  int get passedTests => successes.length;
  int get failedTests => failures.length;
  double get successRate => totalTests == 0 ? 0.0 : (passedTests / totalTests) * 100;
}

/// Helper function to calculate square root (simplified)
double sqrt(num value) {
  if (value < 0) return double.nan;
  if (value == 0) return 0.0;
  
  double x = value.toDouble();
  double prev = 0.0;
  
  while ((x - prev).abs() > 0.001) {
    prev = x;
    x = (x + value / x) / 2;
  }
  
  return x;
}

/// Integration test entry points
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Theme Visual Regression Tests', () {
    late ThemeVisualRegressionTest visualTest;
    
    setUpAll(() async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;
      visualTest = ThemeVisualRegressionTest(binding);
      await visualTest.initialize();
    });
    
    testWidgets('Full Visual Regression Test Suite', (tester) async {
      final report = await visualTest.runFullTestSuite();
      
      // Print report
      print(report.summary);
      
      if (report.failures.isNotEmpty) {
        print('\nFailed Tests:');
        for (final failure in report.failures) {
          print('- ${failure.componentName}: ${failure.difference.differencePercentage.toStringAsFixed(2)}% different');
        }
      }
      
      if (report.newBaselines.isNotEmpty) {
        print('\nNew Baselines Created:');
        for (final baseline in report.newBaselines) {
          print('- $baseline');
        }
      }
      
      // Test should pass if no significant visual regressions
      final significantFailures = report.failures
          .where((f) => f.difference.isSignificant)
          .toList();
      
      expect(significantFailures, isEmpty, 
        reason: 'Found ${significantFailures.length} significant visual regressions',);
    });
    
    testWidgets('Button Component Visual Test', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      
      // Test individual button component
      await visualTest._testComponent(
        testName: 'individual_button_test',
        widget: visualTest._buildButtonComponent(),
        report: VisualTestReport(),
      );
      
      expect(visualTest._differences.where((d) => d.testName == 'individual_button_test'), isEmpty);
    });
    
    testWidgets('Typography Consistency Test', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      
      // Test typography showcase
      await visualTest._testComponent(
        testName: 'individual_typography_test',
        widget: visualTest._buildTypographyShowcase(),
        report: VisualTestReport(),
      );
      
      expect(visualTest._differences.where((d) => d.testName == 'individual_typography_test'), isEmpty);
    });
    
    testWidgets('Color Palette Consistency Test', (tester) async {
      await app.main();
      await tester.pumpAndSettle();
      
      // Test color palette
      await visualTest._testComponent(
        testName: 'individual_color_test',
        widget: visualTest._buildColorPalette(),
        report: VisualTestReport(),
      );
      
      expect(visualTest._differences.where((d) => d.testName == 'individual_color_test'), isEmpty);
    });
  });
}