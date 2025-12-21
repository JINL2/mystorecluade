import 'package:flutter/material.dart';
import '../../../core/themes/theme_validator.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_border_radius.dart';
import '../../widgets/toss/toss_button.dart';
import '../../widgets/toss/toss_card.dart';

/// Simple theme monitor for debug purposes
/// Tracks theme consistency without complex deployment infrastructure
class ThemeMonitorPage extends StatefulWidget {
  const ThemeMonitorPage({super.key});

  @override
  State<ThemeMonitorPage> createState() => _ThemeMonitorPageState();
}

class _ThemeMonitorPageState extends State<ThemeMonitorPage> {
  final _validator = ThemeValidator();
  ValidationReport? _report;
  bool _isScanning = false;
  String _statusMessage = '';
  
  @override
  void initState() {
    super.initState();
    _runQuickValidation();
  }
  
  Future<void> _runQuickValidation() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning theme usage...';
    });
    
    try {
      // Generate validation report
      final report = _validator.generateReport();
      
      setState(() {
        _report = report;
        _isScanning = false;
        _statusMessage = report.totalIssues == 0 
          ? '✅ No theme issues found' 
          : '⚠️ Found ${report.totalIssues} theme issues';
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Error: $e';
      });
    }
  }
  
  Future<void> _scanCodebase() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning entire codebase...';
    });
    
    try {
      final projectPath = '/Applications/XAMPP/xamppfiles/htdocs/mysite/mystorecluade/myFinance_improved_V1/lib';
      final report = await _validator.validateCodebase(projectPath);
      
      setState(() {
        _report = report;
        _isScanning = false;
        _statusMessage = 'Scan complete: ${report.totalIssues} issues found';
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Scan failed: $e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TossColors.background,
      appBar: AppBar(
        title: Text('Theme Monitor', style: TossTextStyles.h3),
        backgroundColor: TossColors.background,
        elevation: 0,
        foregroundColor: TossColors.textPrimary,
      ),
      body: ListView(
        padding: EdgeInsets.all(TossSpacing.paddingMD),
        children: [
          // Status Card
          TossCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _report == null 
                          ? TossColors.gray400
                          : _report!.totalIssues == 0 
                            ? TossColors.success 
                            : TossColors.warning,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: TossSpacing.space2),
                    Text(
                      'Theme Health',
                      style: TossTextStyles.h4,
                    ),
                  ],
                ),
                const SizedBox(height: TossSpacing.space3),
                Text(
                  _statusMessage,
                  style: TossTextStyles.body.copyWith(
                    color: TossColors.textSecondary,
                  ),
                ),
                if (_isScanning)
                  Padding(
                    padding: const EdgeInsets.only(top: TossSpacing.space3),
                    child: LinearProgressIndicator(
                      backgroundColor: TossColors.gray200,
                      valueColor: AlwaysStoppedAnimation(TossColors.primary),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Issues Summary
          if (_report != null) ...[
            TossCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Issues Summary',
                    style: TossTextStyles.h4,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  _buildIssueSummary('Colors', _report!.issuesByType['color'] ?? 0),
                  _buildIssueSummary('Text Styles', _report!.issuesByType['text'] ?? 0),
                  _buildIssueSummary('Spacing', _report!.issuesByType['spacing'] ?? 0),
                  _buildIssueSummary('Border Radius', _report!.issuesByType['radius'] ?? 0),
                ],
              ),
            ),
            
            const SizedBox(height: TossSpacing.space4),
          ],
          
          // Actions
          TossCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Actions',
                  style: TossTextStyles.h4,
                ),
                const SizedBox(height: TossSpacing.space3),
                TossPrimaryButton(
                  text: _isScanning ? 'Scanning...' : 'Quick Validation',
                  onPressed: _isScanning ? null : _runQuickValidation,
                ),
                const SizedBox(height: TossSpacing.space2),
                TossSecondaryButton(
                  text: 'Full Codebase Scan',
                  onPressed: _isScanning ? null : _scanCodebase,
                ),
                const SizedBox(height: TossSpacing.space2),
                TossSecondaryButton(
                  text: 'Clear Issues',
                  onPressed: () {
                    _validator.clearIssues();
                    setState(() {
                      _report = null;
                      _statusMessage = 'Issues cleared';
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: TossSpacing.space4),
          
          // Theme Info
          TossCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Theme',
                  style: TossTextStyles.h4,
                ),
                const SizedBox(height: TossSpacing.space3),
                _buildThemeInfo('Primary Color', TossColors.primary.value.toRadixString(16).toUpperCase()),
                _buildThemeInfo('Background', TossColors.background.value.toRadixString(16).toUpperCase()),
                _buildThemeInfo('Text Primary', TossColors.textPrimary.value.toRadixString(16).toUpperCase()),
                _buildThemeInfo('Border Color', TossColors.border.value.toRadixString(16).toUpperCase()),
              ],
            ),
          ),
          
          // Recent Issues
          if (_report != null && _report!.issues.isNotEmpty) ...[
            const SizedBox(height: TossSpacing.space4),
            TossCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Issues (Last 5)',
                    style: TossTextStyles.h4,
                  ),
                  const SizedBox(height: TossSpacing.space3),
                  ..._report!.issues.take(5).map((issue) => Padding(
                    padding: const EdgeInsets.only(bottom: TossSpacing.space2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.type.toUpperCase(),
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          issue.currentValue,
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.textSecondary,
                          ),
                        ),
                        Text(
                          '→ ${issue.suggestedValue}',
                          style: TossTextStyles.caption.copyWith(
                            color: TossColors.success,
                          ),
                        ),
                        const Divider(height: TossSpacing.space3),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildIssueSummary(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: count == 0 ? TossColors.success.withOpacity(0.1) : TossColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossSpacing.space1),
            ),
            child: Text(
              count.toString(),
              style: TossTextStyles.caption.copyWith(
                color: count == 0 ? TossColors.success : TossColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildThemeInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TossSpacing.space2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Row(
            children: [
              if (label.contains('Color') || label.contains('Background') || label.contains('Text') || label.contains('Border'))
                Container(
                  width: 16,
                  height: 16,
                  margin: EdgeInsets.only(right: TossSpacing.space2),
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF$value')),
                    borderRadius: BorderRadius.circular(TossBorderRadius.xs),
                    border: Border.all(color: TossColors.border),
                  ),
                ),
              Text(
                '#$value',
                style: TossTextStyles.caption.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}