// Test RPC function to debug get_unlinked_companies
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (you'll need to add your credentials)
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  await testRpcFunction();
}

Future<void> testRpcFunction() async {
  final supabase = Supabase.instance.client;
  
  print('=== Testing get_unlinked_companies RPC Function ===');
  
  try {
    // Test with sample parameters - replace with your actual values
    final testParams = {
      'p_user_id': 'YOUR_USER_ID',  // Replace with actual user ID
      'p_company_id': 'YOUR_COMPANY_ID',  // Replace with actual company ID
    };
    
    print('Calling RPC with params: $testParams');
    
    final response = await supabase.rpc('get_unlinked_companies', params: testParams);
    
    print('RPC Response Type: ${response.runtimeType}');
    print('RPC Response: $response');
    
    if (response is List) {
      print('Number of companies returned: ${response.length}');
      for (int i = 0; i < response.length; i++) {
        print('Company $i: ${response[i]}');
      }
    }
    
  } catch (e) {
    print('RPC Error: $e');
    print('Error Type: ${e.runtimeType}');
    
    // Let's also check if the RPC function exists
    try {
      final functions = await supabase.rpc('pg_get_functiondef', params: {
        'funcid': "get_unlinked_companies('uuid', 'uuid')"
      });
      print('Function definition: $functions');
    } catch (funcError) {
      print('Could not get function definition: $funcError');
    }
  }
}

// Alternative test - direct SQL query to understand the expected data structure
Future<void> testDirectQuery() async {
  final supabase = Supabase.instance.client;
  
  print('=== Testing Direct Company Query ===');
  
  try {
    // Get all companies for a user to understand data structure
    final companies = await supabase
        .from('companies')
        .select('company_id, company_name, created_by')
        .limit(5);
    
    print('Sample companies: $companies');
    
  } catch (e) {
    print('Direct query error: $e');
  }
}