import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_state_provider.dart';
import '../../pages/homepage/providers/homepage_providers.dart';

class DebugPanel extends ConsumerStatefulWidget {
  const DebugPanel({super.key});

  @override
  ConsumerState<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends ConsumerState<DebugPanel> {
  bool _showDebugPanel = false;
  bool _showApiDetails = false;
  bool _showAuthDetails = false;
  bool _showAppState = false;
  String _lastApiResult = 'No API test run yet';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final userCompanies = ref.watch(userCompaniesProvider);
    final appState = ref.watch(appStateProvider);

    return Column(
      children: [
        // Debug Toggle Button
        Container(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showDebugPanel = !_showDebugPanel;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TossColors.error,
              foregroundColor: TossColors.background,
            ),
            child: Text(
              _showDebugPanel ? 'Hide Debug Panel' : 'Show Debug Panel',
              style: TossTextStyles.caption,
            ),
          ),
        ),
        
        if (_showDebugPanel) ...[
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: TossColors.gray50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: TossColors.error, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  children: [
                    Text(
                      '🐛 DEBUG PANEL',
                      style: TossTextStyles.h3.copyWith(
                        color: TossColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Go Back Button
                    if (context.canPop()) ...[
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 20,
                        color: TossColors.primary,
                        style: IconButton.styleFrom(
                          backgroundColor: TossColors.primary.withOpacity(0.1),
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    // Close Panel Button
                    IconButton(
                      onPressed: () => setState(() => _showDebugPanel = false),
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                      color: TossColors.error,
                      style: IconButton.styleFrom(
                        backgroundColor: TossColors.error.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Quick Status
                _buildQuickStatus(authState, isAuthenticated, userCompanies),
                const SizedBox(height: 16),
                
                // Auth Details
                _buildToggleSection(
                  'Authentication Details',
                  _showAuthDetails,
                  (value) => setState(() => _showAuthDetails = value),
                  _buildAuthDetails(authState, isAuthenticated),
                ),
                const SizedBox(height: 12),
                
                // API Details
                _buildToggleSection(
                  'API & Data Details',
                  _showApiDetails,
                  (value) => setState(() => _showApiDetails = value),
                  _buildApiDetails(userCompanies),
                ),
                const SizedBox(height: 12),
                
                // App State
                _buildToggleSection(
                  'App State',
                  _showAppState,
                  (value) => setState(() => _showAppState = value),
                  _buildAppState(appState),
                ),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuickStatus(User? authState, bool isAuthenticated, AsyncValue userCompanies) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Quick Status',
            style: TossTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildStatusRow('Auth Status', isAuthenticated ? '✅ Authenticated' : '❌ Not Authenticated'),
          _buildStatusRow('User ID', authState?.id ?? 'No User'),
          _buildStatusRow('User Email', authState?.email ?? 'No Email'),
          _buildStatusRow('Data Status', _getDataStatus(userCompanies)),
        ],
      ),
    );
  }

  Widget _buildToggleSection(String title, bool isExpanded, Function(bool) onToggle, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: TossColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: TossColors.gray200),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TossTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: TossColors.gray600,
            ),
            onTap: () => onToggle(!isExpanded),
          ),
          if (isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: content,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthDetails(User? authState, bool isAuthenticated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusRow('Is Authenticated', isAuthenticated.toString()),
        _buildStatusRow('User Object', authState != null ? 'Present' : 'Null'),
        if (authState != null) ...[
          _buildStatusRow('User ID', authState.id),
          _buildStatusRow('Email', authState.email ?? 'No Email'),
          _buildStatusRow('Email Confirmed', authState.emailConfirmedAt != null ? 'Yes' : 'No'),
          _buildStatusRow('Created At', authState.createdAt.toString()),
          _buildStatusRow('Last Sign In', authState.lastSignInAt?.toString() ?? 'Never'),
          _buildStatusRow('User Metadata', authState.userMetadata?.toString() ?? 'Empty'),
        ],
        const SizedBox(height: 8),
        Text(
          'Supabase Client Status:',
          style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        _buildStatusRow('Current User', Supabase.instance.client.auth.currentUser?.id ?? 'None'),
        _buildStatusRow('Current Session', Supabase.instance.client.auth.currentSession?.accessToken != null ? 'Active' : 'None'),
      ],
    );
  }

  Widget _buildApiDetails(AsyncValue userCompanies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusRow('Data Loading State', _getDataStatus(userCompanies)),
        if (userCompanies is AsyncError) ...[
          const SizedBox(height: 8),
          Text(
            'Error Details:',
            style: TossTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: TossColors.error,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TossColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              userCompanies.error.toString(),
              style: TossTextStyles.caption.copyWith(color: TossColors.error),
            ),
          ),
        ],
        if (userCompanies is AsyncData) ...[
          const SizedBox(height: 8),
          Text(
            'Data Details:',
            style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
          ),
          _buildStatusRow('Companies Count', userCompanies.value?.companies.length.toString() ?? '0'),
          if (userCompanies.value?.companies.isNotEmpty ?? false) ...[
            for (int i = 0; i < (userCompanies.value?.companies.length ?? 0); i++)
              _buildStatusRow(
                'Company ${i + 1}',
                '${userCompanies.value!.companies[i].companyName} (${userCompanies.value!.companies[i].stores.length} stores)',
              ),
          ],
          const SizedBox(height: 8),
          Text(
            'API URL:',
            style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: TossColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'https://atkekzwgukdvucqntryo.supabase.co/rest/v1/rpc/get_user_companies_and_stores',
              style: TossTextStyles.caption,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Last API Test Result:',
            style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _lastApiResult.startsWith('ERROR:') 
                ? TossColors.error.withOpacity(0.1)
                : TossColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _lastApiResult,
              style: TossTextStyles.caption.copyWith(
                color: _lastApiResult.startsWith('ERROR:') 
                  ? TossColors.error
                  : TossColors.gray900,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAppState(AppState appState) {
    final selectedCompany = ref.read(appStateProvider.notifier).selectedCompany;
    final selectedStore = ref.read(appStateProvider.notifier).selectedStore;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App State Information
        Text(
          'Current State:',
          style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: TossColors.primary),
        ),
        _buildStatusRow('Selected Company', selectedCompany?.companyName ?? 'None'),
        if (selectedCompany != null) ...[
          _buildStatusRow('Company ID', selectedCompany.id),
          _buildStatusRow('Company Role', selectedCompany.role.roleName),
          _buildStatusRow('Company Stores', selectedCompany.stores.length.toString()),
        ],
        _buildStatusRow('Selected Store', selectedStore?.storeName ?? 'None'),
        if (selectedStore != null) ...[
          _buildStatusRow('Store ID', selectedStore.id),
        ],
        const SizedBox(height: 8),
        
        // Cache Information
        Text(
          'Cache Info:',
          style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: TossColors.success),
        ),
        _buildStatusRow('User Data Loaded', appState.user.isNotEmpty.toString()),
        _buildStatusRow('Categories Loaded', (appState.categoryFeatures as List).isNotEmpty.toString()),
        _buildStatusRow('Company Chosen', appState.companyChoosen.isEmpty ? 'None' : appState.companyChoosen),
        _buildStatusRow('Store Chosen', appState.storeChoosen.isEmpty ? 'None' : appState.storeChoosen),
        const SizedBox(height: 8),
        
        // Environment Information
        Text(
          'Environment:',
          style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: TossColors.gray600),
        ),
        _buildStatusRow('Flutter Debug Mode', true.toString()),
        _buildStatusRow('Platform', Theme.of(context).platform.name),
        _buildStatusRow('Screen Size', '${MediaQuery.of(context).size.width} x ${MediaQuery.of(context).size.height}'),
        _buildStatusRow('Device Pixel Ratio', MediaQuery.of(context).devicePixelRatio.toString()),
        _buildStatusRow('Supabase URL', 'https://atkekzwgukdvucqntryo.supabase.co'),
        
        // Navigation Information
        const SizedBox(height: 8),
        Text(
          'Navigation:',
          style: TossTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: TossColors.info),
        ),
        _buildStatusRow('Can Go Back', context.canPop().toString()),
        _buildStatusRow('Current Route', GoRouterState.of(context).matchedLocation),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            ref.invalidate(userCompaniesProvider);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.primary,
            foregroundColor: TossColors.background,
          ),
          child: Text('Refresh Data', style: TossTextStyles.caption),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final currentUser = ref.read(authStateProvider);
              if (currentUser == null) {
                throw Exception('No authenticated user');
              }
              
              final response = await Supabase.instance.client
                  .rpc('get_user_companies_and_stores', params: {'p_user_id': currentUser.id});
              print('=== DIRECT API TEST RESULT ===');
              print('Response Type: ${response.runtimeType}');
              print('Response: $response');
              print('Response is null: ${response == null}');
              
              if (response != null) {
                print('Response toString(): ${response.toString()}');
                if (response is List) {
                  print('Response is List with ${response.length} items');
                  if (response.isNotEmpty) {
                    print('First item: ${response.first}');
                    print('First item type: ${response.first.runtimeType}');
                    if (response.first is Map) {
                      print('First item keys: ${(response.first as Map).keys}');
                    }
                  }
                } else if (response is Map) {
                  print('Response is Map with keys: ${response.keys}');
                  print('Values:');
                  response.forEach((key, value) {
                    print('  $key: $value (${value.runtimeType})');
                    if (key == 'companies' && value is List) {
                      print('    Companies list has ${value.length} items');
                      if (value.isNotEmpty) {
                        print('    First company: ${value.first}');
                        if (value.first is Map) {
                          print('    First company keys: ${(value.first as Map).keys}');
                        }
                      }
                    }
                  });
                }
              }
              print('=== END API TEST RESULT ===');
              
              // Update UI with API result
              setState(() {
                if (response is Map) {
                  _lastApiResult = 'SUCCESS: Map with keys: ${response.keys}\n' +
                    'user_id: ${response['user_id']}\n' +
                    'user_first_name: ${response['user_first_name']}\n' +
                    'company_count: ${response['company_count']}\n' +
                    'companies: ${response['companies']?.length} items';
                } else if (response is List) {
                  _lastApiResult = 'SUCCESS: List with ${response.length} items\n' +
                    'First item: ${response.isNotEmpty ? response.first : 'None'}';
                } else {
                  _lastApiResult = 'SUCCESS: ${response.toString()}';
                }
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('API test completed. Check debug panel for results.'),
                  backgroundColor: TossColors.success,
                ),
              );
            } catch (e) {
              print('Direct API Test Error: $e');
              setState(() {
                _lastApiResult = 'ERROR: $e';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('API test failed: $e'),
                  backgroundColor: TossColors.error,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: TossColors.info,
            foregroundColor: TossColors.background,
          ),
          child: Text('Test API', style: TossTextStyles.caption),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TossTextStyles.caption.copyWith(
                color: TossColors.gray900,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _getDataStatus(AsyncValue userCompanies) {
    return userCompanies.when(
      data: (data) => '✅ Loaded (${data?.companies.length ?? 0} companies)',
      loading: () => '⏳ Loading...',
      error: (error, stack) => '❌ Error: ${error.toString()}',
    );
  }
}