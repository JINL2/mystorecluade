import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/services/user_profile_service.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/toss_scaffold.dart';

class SupabaseConnectionTestPage extends ConsumerStatefulWidget {
  const SupabaseConnectionTestPage({super.key});

  @override
  ConsumerState<SupabaseConnectionTestPage> createState() => _SupabaseConnectionTestPageState();
}

class _SupabaseConnectionTestPageState extends ConsumerState<SupabaseConnectionTestPage> {
  final _supabase = Supabase.instance.client;
  final _userProfileService = UserProfileService();
  final _debugLogs = <String>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addLog('🔧 Debug page initialized');
    _runInitialDiagnostics();
  }

  void _addLog(String message) {
    setState(() {
      _debugLogs.add('${DateTime.now().toString().substring(11, 23)}: $message');
    });
    print('[DEBUG] $message');
  }

  void _clearLogs() {
    setState(() {
      _debugLogs.clear();
    });
  }

  Future<void> _runInitialDiagnostics() async {
    _addLog('🚀 Running initial diagnostics...');
    
    try {
      // Check Supabase connection
      final currentUser = _supabase.auth.currentUser;
      if (currentUser != null) {
        _addLog('✅ Auth user found: ${currentUser.email} (ID: ${currentUser.id})');
        _addLog('📊 Auth metadata: ${currentUser.userMetadata}');
      } else {
        _addLog('❌ No authenticated user found');
      }

      // Check database connection
      _addLog('🔍 Testing database connection...');
      final response = await _supabase
          .from('users')
          .select('count')
          .count(CountOption.exact);
      _addLog('✅ Database connected - Total users: ${response.count}');

    } catch (e, stackTrace) {
      _addLog('❌ Diagnostics failed: $e');
      _addLog('🔍 Stack trace: ${stackTrace.toString().substring(0, 200)}...');
    }
  }

  Future<void> _testDirectDatabaseQuery() async {
    _addLog('🔍 Testing direct database query...');
    setState(() => _isLoading = true);

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        _addLog('❌ No authenticated user for database query');
        return;
      }

      _addLog('📝 Querying users table for user_id: ${currentUser.id}');
      
      final userRecord = await _supabase
          .from('users')
          .select('*')
          .eq('user_id', currentUser.id)
          .maybeSingle();

      if (userRecord != null) {
        _addLog('✅ User record found:');
        _addLog('   • first_name: "${userRecord['first_name']}"');
        _addLog('   • last_name: "${userRecord['last_name']}"');
        _addLog('   • email: "${userRecord['email']}"');
        _addLog('   • created_at: ${userRecord['created_at']}');
      } else {
        _addLog('❌ No user record found in users table');
      }

    } catch (e, stackTrace) {
      _addLog('❌ Database query failed: $e');
      if (e is PostgrestException) {
        _addLog('   • Code: ${e.code}');
        _addLog('   • Message: ${e.message}');
        _addLog('   • Details: ${e.details}');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testProfileCreation() async {
    _addLog('🛠️ Testing profile creation with current auth data...');
    setState(() => _isLoading = true);

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        _addLog('❌ No authenticated user for profile creation');
        return;
      }

      _addLog('📊 Current user metadata: ${currentUser.userMetadata}');
      
      // Extract names from metadata
      final metadata = currentUser.userMetadata ?? {};
      final firstName = metadata['first_name'] as String? ?? 'Test';
      final lastName = metadata['last_name'] as String? ?? 'User';
      final email = currentUser.email ?? '';

      _addLog('📝 Attempting to create/update profile:');
      _addLog('   • User ID: ${currentUser.id}');
      _addLog('   • First Name: "$firstName"');
      _addLog('   • Last Name: "$lastName"');
      _addLog('   • Email: "$email"');

      final success = await _userProfileService.ensureUserProfile(
        userId: currentUser.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      if (success) {
        _addLog('✅ Profile operation completed successfully');
        _addLog('🔄 Refreshing database query...');
        await Future.delayed(const Duration(milliseconds: 500));
        await _testDirectDatabaseQuery();
      } else {
        _addLog('⚠️ Profile operation returned false (may already exist)');
      }

    } catch (e, stackTrace) {
      _addLog('❌ Profile creation failed: $e');
      _addLog('🔍 Stack trace: ${stackTrace.toString().substring(0, 300)}...');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testManualInsert() async {
    _addLog('✋ Testing manual database insert...');
    setState(() => _isLoading = true);

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        _addLog('❌ No authenticated user for manual insert');
        return;
      }

      final testData = {
        'user_id': currentUser.id,
        'first_name': 'Manual',
        'last_name': 'Test',
        'email': currentUser.email ?? 'test@example.com',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      _addLog('📝 Attempting manual insert with data: $testData');

      // Try insert with upsert to avoid conflicts
      final result = await _supabase
          .from('users')
          .upsert(testData)
          .select();

      _addLog('✅ Manual insert successful: $result');
      
      _addLog('🔄 Verifying insert...');
      await Future.delayed(const Duration(milliseconds: 500));
      await _testDirectDatabaseQuery();

    } catch (e, stackTrace) {
      _addLog('❌ Manual insert failed: $e');
      if (e is PostgrestException) {
        _addLog('   • Code: ${e.code}');
        _addLog('   • Message: ${e.message}');
        _addLog('   • Details: ${e.details}');
        _addLog('   • Hint: ${e.hint}');
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testAuthMetadataUpdate() async {
    _addLog('🔄 Testing auth metadata update...');
    setState(() => _isLoading = true);

    try {
      final currentUser = _supabase.auth.currentUser;
      if (currentUser == null) {
        _addLog('❌ No authenticated user for metadata update');
        return;
      }

      final newMetadata = {
        'first_name': 'Updated',
        'last_name': 'Metadata',
        'full_name': 'Updated Metadata',
        'test_timestamp': DateTime.now().toIso8601String(),
      };

      _addLog('📝 Updating user metadata: $newMetadata');

      await _supabase.auth.updateUser(
        UserAttributes(data: newMetadata),
      );

      _addLog('✅ Metadata updated successfully');
      
      _addLog('🔄 Checking updated auth user...');
      await Future.delayed(const Duration(seconds: 1));
      
      final updatedUser = _supabase.auth.currentUser;
      if (updatedUser != null) {
        _addLog('📊 Updated metadata: ${updatedUser.userMetadata}');
      }

    } catch (e, stackTrace) {
      _addLog('❌ Metadata update failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testAllUserTables() async {
    _addLog('📊 Checking all user-related tables...');
    setState(() => _isLoading = true);

    try {
      // Check auth.users table
      _addLog('🔍 Checking auth.users table...');
      final authUsers = await _supabase
          .from('users')
          .select('*')
          .limit(5);
      _addLog('✅ Found ${authUsers.length} records in users table');
      
      for (var user in authUsers) {
        _addLog('   • User: ${user['email']} | Names: "${user['first_name']}" "${user['last_name']}"');
      }

      // Test table permissions
      _addLog('🔐 Testing table permissions...');
      try {
        await _supabase.from('users').select('count').count();
        _addLog('✅ READ permission OK');
      } catch (e) {
        _addLog('❌ READ permission FAILED: $e');
      }

    } catch (e) {
      _addLog('❌ Table check failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testSignupFlow() async {
    _addLog('🚀 Testing complete signup flow...');
    setState(() => _isLoading = true);

    try {
      final authProvider = ref.read(authStateProvider.notifier);
      
      _addLog('📝 Testing signup with dummy credentials...');
      _addLog('⚠️ Note: This will create a test user if successful');
      
      final testEmail = 'debug.test.${DateTime.now().millisecondsSinceEpoch}@example.com';
      const testPassword = 'TestPassword123!';
      const testFirstName = 'Debug';
      const testLastName = 'Test';
      
      _addLog('   • Email: $testEmail');
      _addLog('   • First Name: $testFirstName');
      _addLog('   • Last Name: $testLastName');

      await authProvider.signUp(
        email: testEmail,
        password: testPassword,
        firstName: testFirstName,
        lastName: testLastName,
      );

      _addLog('✅ Signup completed - checking result...');
      
      await Future.delayed(const Duration(seconds: 2));
      await _testDirectDatabaseQuery();

    } catch (e, stackTrace) {
      _addLog('❌ Signup test failed: $e');
      _addLog('🔍 Stack trace: ${stackTrace.toString().substring(0, 200)}...');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _supabase.auth.currentUser;
    
    return TossScaffold(
      appBar: AppBar(
        title: const Text('Supabase Connection Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: currentUser != null ? Colors.green[50] : Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser != null ? '✅ Authenticated' : '❌ Not Authenticated',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: currentUser != null ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                    if (currentUser != null) ...[
                      const SizedBox(height: 8),
                      Text('Email: ${currentUser.email}'),
                      Text('User ID: ${currentUser.id}'),
                      if (currentUser.userMetadata?.isNotEmpty == true)
                        Text('Metadata: ${currentUser.userMetadata}'),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Buttons
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testDirectDatabaseQuery,
                  icon: const Icon(Icons.search),
                  label: const Text('Query Database'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testProfileCreation,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create Profile'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testManualInsert,
                  icon: const Icon(Icons.input),
                  label: const Text('Manual Insert'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testAuthMetadataUpdate,
                  icon: const Icon(Icons.update),
                  label: const Text('Update Metadata'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testAllUserTables,
                  icon: const Icon(Icons.table_chart),
                  label: const Text('Check Tables'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _testSignupFlow,
                  icon: const Icon(Icons.app_registration),
                  label: const Text('Test Signup'),
                ),
                ElevatedButton.icon(
                  onPressed: _clearLogs,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Logs'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Debug Logs
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.terminal, color: Colors.white),
                          const SizedBox(width: 8),
                          const Text(
                            'Debug Logs',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (_isLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _debugLogs.join('\n'),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}