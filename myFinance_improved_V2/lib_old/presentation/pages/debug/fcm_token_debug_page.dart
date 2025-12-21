import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../../core/themes/toss_spacing.dart';
import '../../widgets/common/toss_scaffold.dart';
import '../../widgets/common/toss_loading_view.dart';
import '../../widgets/toss/toss_primary_button.dart';
import '../../widgets/toss/toss_card.dart';
import '../../../core/notifications/repositories/notification_repository.dart';
import '../../../core/notifications/services/token_manager.dart';
import '../../../core/notifications/services/fcm_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myfinance_improved/core/themes/index.dart';
import 'package:myfinance_improved/core/themes/toss_border_radius.dart';
class FcmTokenDebugPage extends ConsumerStatefulWidget {
  const FcmTokenDebugPage({super.key});

  @override
  ConsumerState<FcmTokenDebugPage> createState() => _FcmTokenDebugPageState();
}

class _FcmTokenDebugPageState extends ConsumerState<FcmTokenDebugPage> {
  final _repository = NotificationRepository();
  final _tokenManager = TokenManager();
  final _fcmService = FcmService();
  final _supabase = Supabase.instance.client;
  
  Map<String, dynamic>? _diagnostics;
  Map<String, dynamic>? _tokenStatus;
  bool _isLoading = false;
  String? _currentFcmToken;
  List<Map<String, dynamic>> _storedTokens = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    
    try {
      // Get current FCM token
      _currentFcmToken = _fcmService.fcmToken;
      
      // Get token manager status
      _tokenStatus = _tokenManager.getTokenStatus();
      
      // Load stored tokens from database
      await _loadStoredTokens();
      
      setState(() {});
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _runDiagnostics() async {
    setState(() => _isLoading = true);
    
    try {
      final diagnostics = await _repository.verifyFcmTokenTable();
      setState(() {
        _diagnostics = diagnostics;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diagnostic failed: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadStoredTokens() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        final response = await _supabase
            .from('user_fcm_tokens')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        
        setState(() {
          _storedTokens = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      debugPrint('Error loading stored tokens: $e');
    }
  }

  Future<void> _forceTokenRefresh() async {
    setState(() => _isLoading = true);
    
    try {
      await _tokenManager.forceRefresh();
      
      // Reload data
      await _loadInitialData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token refresh initiated'),
          backgroundColor: TossColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Refresh failed: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testTokenStorage() async {
    setState(() => _isLoading = true);
    
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Not authenticated');
      }
      
      final testToken = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
      final result = await _repository.storeOrUpdateFcmToken(
        userId: userId,
        token: testToken,
        platform: 'test',
        deviceId: 'test_device',
        deviceModel: 'test_model',
        appVersion: '0.0.0',
      );
      
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test token stored successfully! ID: ${result.id}'),
            backgroundColor: TossColors.success,
          ),
        );
        
        // Clean up test token
        if (result.id != null && result.id!.isNotEmpty) {
          await _supabase
              .from('user_fcm_tokens')
              .delete()
              .eq('id', result.id!);
        }
            
        // Reload tokens
        await _loadStoredTokens();
      } else {
        throw Exception('Storage returned null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Test failed: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      appBar: AppBar(
        title: const Text('FCM Token Debug'),
        backgroundColor: TossColors.background,
        elevation: 0,
      ),
      body: _isLoading && _diagnostics == null
          ? const TossLoadingView()
          : SingleChildScrollView(
              padding: EdgeInsets.all(TossSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Current Status'),
                  _buildCurrentStatusCard(),
                  
                  const SizedBox(height: TossSpacing.space4),
                  
                  _buildSectionTitle('Actions'),
                  _buildActionButtons(),
                  
                  if (_diagnostics != null) ...[
                    const SizedBox(height: TossSpacing.space4),
                    _buildSectionTitle('Diagnostics'),
                    _buildDiagnosticsCard(),
                  ],
                  
                  if (_tokenStatus != null) ...[
                    const SizedBox(height: TossSpacing.space4),
                    _buildSectionTitle('Token Manager Status'),
                    _buildTokenStatusCard(),
                  ],
                  
                  if (_storedTokens.isNotEmpty) ...[
                    const SizedBox(height: TossSpacing.space4),
                    _buildSectionTitle('Stored Tokens'),
                    _buildStoredTokensList(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: TossSpacing.space2),
      child: Text(
        title,
        style: TossTextStyles.h3.copyWith(
          color: TossColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrentStatusCard() {
    final userId = _supabase.auth.currentUser?.id;
    final isAuthenticated = userId != null;
    
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow(
              'Authenticated',
              isAuthenticated ? 'Yes' : 'No',
              isAuthenticated ? TossColors.success : TossColors.error,
            ),
            if (isAuthenticated) ...[
              _buildStatusRow('User ID', userId!.substring(0, 8) + '...', TossColors.primary),
            ],
            _buildStatusRow(
              'FCM Token',
              _currentFcmToken != null ? 'Available' : 'Not Available',
              _currentFcmToken != null ? TossColors.success : TossColors.warning,
            ),
            if (_currentFcmToken != null) ...[
              const SizedBox(height: TossSpacing.space2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Token: ${_currentFcmToken!.substring(0, 20)}...',
                      style: TossTextStyles.caption.copyWith(
                        color: TossColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _currentFcmToken!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Token copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ],
            _buildStatusRow(
              'Stored Tokens',
              '${_storedTokens.length}',
              _storedTokens.isNotEmpty ? TossColors.success : TossColors.warning,
            ),
          ],
        ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TossTextStyles.body.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        TossPrimaryButton(
          text: 'Run Diagnostics',
          onPressed: _isLoading ? null : _runDiagnostics,
          isLoading: _isLoading,
          fullWidth: true,
          leadingIcon: const Icon(Icons.health_and_safety, color: TossColors.white),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossPrimaryButton(
          text: 'Test Token Storage',
          onPressed: _isLoading ? null : _testTokenStorage,
          isLoading: _isLoading,
          fullWidth: true,
          leadingIcon: const Icon(Icons.storage, color: TossColors.white),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossPrimaryButton(
          text: 'Force Token Refresh',
          onPressed: _isLoading ? null : _forceTokenRefresh,
          isLoading: _isLoading,
          fullWidth: true,
          leadingIcon: const Icon(Icons.refresh, color: TossColors.white),
        ),
        const SizedBox(height: TossSpacing.space2),
        TossPrimaryButton(
          text: 'Reload Data',
          onPressed: _isLoading ? null : _loadInitialData,
          isLoading: _isLoading,
          fullWidth: true,
          leadingIcon: const Icon(Icons.sync, color: TossColors.white),
        ),
      ],
    );
  }

  Widget _buildDiagnosticsCard() {
    if (_diagnostics == null) return const SizedBox.shrink();
    
    final tableExists = _diagnostics!['table_exists'] == true;
    final canSelect = _diagnostics!['user_select_works'] == true;
    final canInsert = _diagnostics!['insert_works'] == true;
    final hasRlsIssue = _diagnostics!['rls_issue'] == true;
    final hasColumnIssue = _diagnostics!['column_issue'] == true;
    final hasConstraintIssue = _diagnostics!['constraint_issue'] == true;
    final recommendations = _diagnostics!['recommendations'] as List<String>? ?? [];
    
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiagnosticRow('Table Exists', tableExists),
            if (tableExists) ...[
              _buildDiagnosticRow('Can Select', canSelect),
              _buildDiagnosticRow('Can Insert', canInsert),
              if (_diagnostics!['total_tokens'] != null)
                _buildStatusRow('Total Tokens', '${_diagnostics!['total_tokens']}', TossColors.primary),
              if (_diagnostics!['user_tokens'] != null)
                _buildStatusRow('User Tokens', '${_diagnostics!['user_tokens']}', TossColors.primary),
            ],
            if (hasRlsIssue)
              _buildWarningRow('RLS Policy Issue Detected'),
            if (hasColumnIssue)
              _buildWarningRow('Column Issue Detected'),
            if (hasConstraintIssue)
              _buildWarningRow('Constraint Issue Detected'),
            
            if (recommendations.isNotEmpty) ...[
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Recommendations:',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.textPrimary,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              ...recommendations.map((rec) => Padding(
                padding: EdgeInsets.only(left: TossSpacing.space2, top: TossSpacing.space1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(
                      child: Text(
                        rec,
                        style: TossTextStyles.caption.copyWith(
                          color: TossColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            ],
            
            if (_diagnostics!['insert_error'] != null) ...[
              const SizedBox(height: TossSpacing.space3),
              Text(
                'Error Details:',
                style: TossTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TossColors.error,
                ),
              ),
              const SizedBox(height: TossSpacing.space1),
              Container(
                padding: EdgeInsets.all(TossSpacing.space2),
                decoration: BoxDecoration(
                  color: TossColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.md),
                ),
                child: Text(
                  _diagnostics!['insert_error'].toString(),
                  style: TossTextStyles.caption.copyWith(
                    color: TossColors.error,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ],
        ),
    );
  }

  Widget _buildDiagnosticRow(String label, bool value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TossTextStyles.body.copyWith(
              color: TossColors.textSecondary,
            ),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? TossColors.success : TossColors.error,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TossSpacing.space1),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: TossColors.warning,
            size: 18,
          ),
          const SizedBox(width: TossSpacing.space2),
          Expanded(
            child: Text(
              text,
              style: TossTextStyles.body.copyWith(
                color: TossColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenStatusCard() {
    if (_tokenStatus == null) return const SizedBox.shrink();
    
    return TossCard(
      padding: EdgeInsets.all(TossSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow(
              'Tokens Match',
              _tokenStatus!['tokens_match']?.toString() ?? 'N/A',
              _tokenStatus!['tokens_match'] == true ? TossColors.success : TossColors.warning,
            ),
            _buildStatusRow(
              'Needs Validation',
              _tokenStatus!['needs_validation']?.toString() ?? 'N/A',
              _tokenStatus!['needs_validation'] == false ? TossColors.success : TossColors.warning,
            ),
            _buildStatusRow(
              'Needs Update',
              _tokenStatus!['needs_update']?.toString() ?? 'N/A',
              _tokenStatus!['needs_update'] == false ? TossColors.success : TossColors.warning,
            ),
            _buildStatusRow(
              'Pending Updates',
              '${_tokenStatus!['pending_updates'] ?? 0}',
              _tokenStatus!['pending_updates'] == 0 ? TossColors.success : TossColors.warning,
            ),
            if (_tokenStatus!['last_update'] != null)
              _buildStatusRow(
                'Last Update',
                _formatDateTime(_tokenStatus!['last_update']),
                TossColors.primary,
              ),
            if (_tokenStatus!['time_since_update'] != null)
              _buildStatusRow(
                'Minutes Since Update',
                '${_tokenStatus!['time_since_update']}',
                TossColors.primary,
              ),
          ],
        ),
    );
  }

  Widget _buildStoredTokensList() {
    return Column(
      children: _storedTokens.map((token) {
        final isActive = token['is_active'] == true;
        final platform = token['platform'] ?? 'unknown';
        final createdAt = token['created_at'] != null 
            ? DateTime.parse(token['created_at']) 
            : null;
        
        return Padding(
          padding: EdgeInsets.only(bottom: TossSpacing.space2),
          child: TossCard(
            child: ListTile(
            leading: Icon(
              isActive ? Icons.check_circle : Icons.cancel,
              color: isActive ? TossColors.success : TossColors.gray500,
            ),
            title: Text(
              'Platform: $platform',
              style: TossTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Token: ${(token['token'] as String).substring(0, 20)}...',
                  style: TossTextStyles.caption.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
                if (createdAt != null)
                  Text(
                    'Created: ${_formatDateTime(createdAt.toIso8601String())}',
                    style: TossTextStyles.caption,
                  ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: TossColors.error),
              onPressed: token['id'] != null 
                  ? () => _deleteToken(token['id'] as String)
                  : null,
            ),
          ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _deleteToken(String tokenId) async {
    try {
      await _supabase
          .from('user_fcm_tokens')
          .delete()
          .eq('id', tokenId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token deleted'),
          backgroundColor: TossColors.success,
        ),
      );
      
      await _loadStoredTokens();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
          backgroundColor: TossColors.error,
        ),
      );
    }
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateTimeStr);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
             '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeStr;
    }
  }
}