import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void testTemplateQuery() async {
  final supabase = Supabase.instance.client;
  
  print('Testing transaction_templates query...');
  
  try {
    // Test 1: Check if we're authenticated
    final user = supabase.auth.currentUser;
    print('Current user: ${user?.id}');
    
    if (user == null) {
      print('ERROR: Not authenticated!');
      return;
    }
    
    // Test 2: Try a simple query
    print('Attempting query...');
    final response = await supabase
        .from('transaction_templates')
        .select('template_id, name');
    
    print('Response type: ${response.runtimeType}');
    print('Response: $response');
    
    if (response is List) {
      print('Success! Got ${response.length} templates');
    } else {
      print('ERROR: Response is not a List!');
      print('Response details: $response');
    }
    
  } catch (e) {
    print('Exception occurred: $e');
    print('Exception type: ${e.runtimeType}');
    
    if (e is PostgrestException) {
      print('Postgrest error details:');
      print('  Message: ${e.message}');
      print('  Code: ${e.code}');
      print('  Details: ${e.details}');
      print('  Hint: ${e.hint}');
    }
  }
}

// Call this function from somewhere in your app
void runTest() {
  testTemplateQuery();
}