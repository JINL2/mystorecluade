import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../core/themes/index.dart';
import '../../../core/config/widget_migration_config.dart';
import '../../../core/helpers/widget_migration_helper.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_app_bar.dart';
import '../../widgets/toss/toss_card.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_secondary_button.dart';
import '../../helpers/navigation_helper.dart';

/// Widget Migration Monitor
/// 
/// Displays the status of widget migration and allows safe testing
/// of feature flags in debug mode only.
class WidgetMigrationMonitorPage extends StatefulWidget {
  const WidgetMigrationMonitorPage({super.key});

  @override
  State<WidgetMigrationMonitorPage> createState() => _WidgetMigrationMonitorPageState();
}

class _WidgetMigrationMonitorPageState extends State<WidgetMigrationMonitorPage> {
  Map<String, dynamic> _migrationStatus = {};
  
  // Local state for toggle switches (actual config is read-only)
  Map<String, bool> _widgetToggles = {};
  Map<String, bool> _pageToggles = {};
  
  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }
  
  void _refreshStatus() {
    setState(() {
      _migrationStatus = WidgetMigrationConfig.getMigrationStatus();
      
      // Initialize toggle states from config
      if (_migrationStatus['widgets'] != null) {
        _widgetToggles = Map<String, bool>.from(_migrationStatus['widgets']);
      }
      if (_migrationStatus['pages'] != null) {
        _pageToggles = Map<String, bool>.from(_migrationStatus['pages']);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final isDebugMode = kDebugMode;
    
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: '🔄 Widget Migration Monitor',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: TossColors.textPrimary),
          onPressed: () => NavigationHelper.safeGoBack(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Overview Card
            _buildStatusCard(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Widget Toggle Controls
            _buildWidgetControls(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Page-specific Controls
            _buildPageControls(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Test Buttons
            _buildTestSection(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Migration Statistics
            _buildStatisticsCard(),
            
            SizedBox(height: TossSpacing.space4),
            
            // Safety Information
            _buildSafetyCard(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusCard() {
    final isEnabled = _migrationStatus['enabled'] ?? false;
    final mode = _migrationStatus['mode'] ?? 'unknown';
    
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isEnabled ? Icons.check_circle : Icons.cancel,
                color: isEnabled ? TossColors.success : TossColors.error,
                size: 24,
              ),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Migration Status',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          _buildStatusRow('Master Switch', isEnabled ? 'Enabled' : 'Disabled', 
            isEnabled ? TossColors.success : TossColors.error),
          _buildStatusRow('Mode', mode.toUpperCase(), 
            mode == 'debug' ? TossColors.warning : TossColors.info),
          _buildStatusRow('Environment', kDebugMode ? 'DEBUG' : 'RELEASE',
            kDebugMode ? TossColors.success : TossColors.primary),
          
          if (!kDebugMode)
            Container(
              margin: EdgeInsets.only(top: TossSpacing.space3),
              padding: EdgeInsets.all(TossSpacing.space3),
              decoration: BoxDecoration(
                color: TossColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
                border: Border.all(color: TossColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: TossColors.error, size: 20),
                  SizedBox(width: TossSpacing.space2),
                  Expanded(
                    child: Text(
                      'Widget migration is disabled in release mode',
                      style: TossTextStyles.body.copyWith(
                        color: TossColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildWidgetControls() {
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎛️ Widget Feature Flags',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            'Toggle individual widget replacements (Debug Mode Only)',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          ..._widgetToggles.entries.map((entry) {
            final widgetName = entry.key;
            final isEnabled = entry.value;
            
            return _buildToggleRow(
              widgetName,
              isEnabled,
              (value) {
                setState(() {
                  _widgetToggles[widgetName] = value;
                });
                _showConfigNote();
              },
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildPageControls() {
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📄 Page-Specific Rollout',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            'Enable migration for specific pages',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.gray600,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          ..._pageToggles.entries.map((entry) {
            final pageName = entry.key;
            final isEnabled = entry.value;
            final isRisky = pageName == 'auth' || pageName == 'payments';
            
            return _buildToggleRow(
              pageName,
              isEnabled,
              isRisky ? null : (value) {
                setState(() {
                  _pageToggles[pageName] = value;
                });
                _showConfigNote();
              },
              warning: isRisky ? 'High risk - Keep disabled' : null,
            );
          }).toList(),
        ],
      ),
    );
  }
  
  Widget _buildTestSection() {
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🧪 Test Migration',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Row(
            children: [
              Expanded(
                child: TossPrimaryButton(
                  text: 'Test Inventory Page',
                  onPressed: () {
                    Navigator.pushNamed(context, '/inventory-v2');
                    _showSnackBar('Opening Inventory Page V2 with migration helpers');
                  },
                ),
              ),
              
              SizedBox(width: TossSpacing.space3),
              
              Expanded(
                child: TossSecondaryButton(
                  text: 'Original Page',
                  onPressed: () {
                    Navigator.pushNamed(context, '/inventory');
                    _showSnackBar('Opening original Inventory Page');
                  },
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          Text(
            '💡 Tip: Open both versions to compare behavior',
            style: TossTextStyles.caption.copyWith(
              color: TossColors.info,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatisticsCard() {
    // Calculate statistics
    final totalWidgets = 853; // From our analysis
    final replacedWidgets = 0; // Will increase as we migrate
    final percentage = (replacedWidgets / totalWidgets * 100).toStringAsFixed(1);
    
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Migration Progress',
            style: TossTextStyles.h3.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          _buildStatRow('Total Native Widgets', '$totalWidgets'),
          _buildStatRow('Widgets Replaced', '$replacedWidgets'),
          _buildStatRow('Progress', '$percentage%'),
          _buildStatRow('Estimated Completion', 'Not started'),
          
          SizedBox(height: TossSpacing.space3),
          
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: TossColors.gray200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: replacedWidgets / totalWidgets,
              child: Container(
                decoration: BoxDecoration(
                  color: TossColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSafetyCard() {
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: TossColors.warning, size: 24),
              SizedBox(width: TossSpacing.space2),
              Text(
                'Safety Guidelines',
                style: TossTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w700,
                  color: TossColors.warning,
                ),
              ),
            ],
          ),
          
          SizedBox(height: TossSpacing.space3),
          
          _buildSafetyItem('✅', 'Test in debug mode first'),
          _buildSafetyItem('✅', 'Enable one widget type at a time'),
          _buildSafetyItem('✅', 'Monitor performance after each change'),
          _buildSafetyItem('⚠️', 'Avoid auth and payment pages'),
          _buildSafetyItem('⚠️', 'Have rollback plan ready'),
          _buildSafetyItem('❌', 'Never force migration in production'),
          
          SizedBox(height: TossSpacing.space3),
          
          Container(
            padding: EdgeInsets.all(TossSpacing.space3),
            decoration: BoxDecoration(
              color: TossColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info, color: TossColors.info, size: 20),
                SizedBox(width: TossSpacing.space2),
                Expanded(
                  child: Text(
                    'Changes shown here are for preview only. Edit widget_migration_config.dart to apply changes.',
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods
  Widget _buildStatusRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TossSpacing.space2,
              vertical: TossSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TossBorderRadius.sm),
            ),
            child: Text(
              value,
              style: TossTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildToggleRow(String label, bool value, ValueChanged<bool>? onChanged, {String? warning}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TossTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (warning != null)
                  Text(
                    warning,
                    style: TossTextStyles.caption.copyWith(
                      color: TossColors.error,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: TossColors.primary,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.gray700,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSafetyItem(String icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 16)),
          SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              text,
              style: TossTextStyles.body.copyWith(
                color: TossColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showConfigNote() {
    _showSnackBar('Edit widget_migration_config.dart to apply changes permanently');
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: TossColors.info,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
      ),
    );
  }
}