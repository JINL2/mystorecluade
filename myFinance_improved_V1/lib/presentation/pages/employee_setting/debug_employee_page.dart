import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/app_state_provider.dart';
import '../../../core/themes/toss_colors.dart';
import '../../../core/themes/toss_text_styles.dart';

class DebugEmployeePage extends ConsumerStatefulWidget {
  const DebugEmployeePage({super.key});

  @override
  ConsumerState<DebugEmployeePage> createState() => _DebugEmployeePageState();
}

class _DebugEmployeePageState extends ConsumerState<DebugEmployeePage> {
  String _debugInfo = 'Loading debug information...';
  
  @override
  void initState() {
    super.initState();
    _runDebugChecks();
  }
  
  Future<void> _runDebugChecks() async {
    final buffer = StringBuffer();
    
    try {
      // Check Supabase connection
      buffer.writeln('=== SUPABASE DEBUG INFO ===');
      final supabase = Supabase.instance.client;
      buffer.writeln('Supabase URL: ${supabase.supabaseUrl}');
      buffer.writeln('Auth Status: ${supabase.auth.currentUser != null ? "Authenticated" : "Not authenticated"}');
      buffer.writeln('User ID: ${supabase.auth.currentUser?.id ?? "No user"}');
      buffer.writeln('User Email: ${supabase.auth.currentUser?.email ?? "No email"}');
      buffer.writeln('');
      
      // Check app state
      buffer.writeln('=== APP STATE DEBUG ===');
      final appState = ref.read(appStateProvider);
      buffer.writeln('Company Chosen: "${appState.companyChoosen}"');
      buffer.writeln('Store Chosen: "${appState.storeChoosen}"');
      buffer.writeln('Company Chosen isEmpty: ${appState.companyChoosen.isEmpty}');
      buffer.writeln('');
      
      // Test currency_types table
      buffer.writeln('=== CURRENCY TYPES TEST ===');
      try {
        final currencyResponse = await supabase
            .from('currency_types')
            .select()
            .limit(3);
        buffer.writeln('Currency types query successful');
        buffer.writeln('Currency count: ${(currencyResponse as List).length}');
        if ((currencyResponse as List).isNotEmpty) {
          buffer.writeln('First currency: ${currencyResponse.first}');
        }
      } catch (e) {
        buffer.writeln('Currency types query failed: $e');
      }
      buffer.writeln('');
      
      // Test v_user_salary view
      buffer.writeln('=== V_USER_SALARY VIEW TEST ===');
      try {
        final salaryResponse = await supabase
            .from('v_user_salary')
            .select()
            .limit(3);
        buffer.writeln('v_user_salary query successful');
        buffer.writeln('Records count: ${(salaryResponse as List).length}');
        if ((salaryResponse as List).isNotEmpty) {
          buffer.writeln('First record: ${salaryResponse.first}');
          
          // Check for null values in first record
          final first = salaryResponse.first as Map<String, dynamic>;
          buffer.writeln('--- Field Analysis ---');
          first.forEach((key, value) {
            buffer.writeln('$key: $value (${value.runtimeType})');
          });
        } else {
          buffer.writeln('No records found in v_user_salary view');
        }
      } catch (e) {
        buffer.writeln('v_user_salary query failed: $e');
        buffer.writeln('This might indicate the view doesn\'t exist');
      }
      buffer.writeln('');
      
      // Test with specific company ID if available
      if (appState.companyChoosen.isNotEmpty) {
        buffer.writeln('=== COMPANY SPECIFIC TEST ===');
        try {
          final companyResponse = await supabase
              .from('v_user_salary')
              .select()
              .eq('company_id', appState.companyChoosen)
              .limit(3);
          buffer.writeln('Company specific query successful');
          buffer.writeln('Company records count: ${(companyResponse as List).length}');
          if ((companyResponse as List).isNotEmpty) {
            buffer.writeln('First company record: ${companyResponse.first}');
          }
        } catch (e) {
          buffer.writeln('Company specific query failed: $e');
        }
      } else {
        buffer.writeln('=== NO COMPANY SELECTED ===');
        buffer.writeln('Cannot test company-specific queries');
      }
      
    } catch (e) {
      buffer.writeln('Debug check failed: $e');
    }
    
    if (mounted) {
      setState(() {
        _debugInfo = buffer.toString();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Setting Debug'),
        backgroundColor: TossColors.background,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug Information',
              style: TossTextStyles.h3.copyWith(color: TossColors.gray900),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: TossColors.gray50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: TossColors.gray200),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugInfo,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: TossColors.gray900,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _runDebugChecks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TossColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text('Refresh Debug Info'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}