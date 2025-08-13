import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Test provider to check Supabase connectivity
final supabaseTestProvider = FutureProvider<String>((ref) async {
  try {
    final client = Supabase.instance.client;
    
    // Test 1: Check if client is initialized
    print('Supabase client initialized: ${client.auth.currentUser?.id ?? 'No user'}');
    
    // Test 2: Try a simple operation
    final response = await client.from('_realtime_schema').select('version').limit(1);
    print('Supabase connection test successful: $response');
    
    return 'Supabase connection working';
  } catch (e) {
    print('Supabase test error: $e');
    return 'Supabase error: $e';
  }
});

// Simplified test auth functions for debugging
class TestAuthProvider {
  static Future<void> testSignup() async {
    try {
      print('Testing signup with simple email...');
      
      final response = await Supabase.instance.client.auth.signUp(
        email: 'test+${DateTime.now().millisecondsSinceEpoch}@example.com',
        password: 'test123456',
      );
      
      print('Test signup result: user=${response.user?.id}, session=${response.session != null}');
      
      if (response.user != null) {
        print('✅ Signup working - User created: ${response.user!.email}');
      } else {
        print('❌ Signup failed - No user returned');
      }
    } catch (e) {
      print('❌ Test signup error: $e');
    }
  }
  
  static Future<void> testResetPassword() async {
    try {
      print('Testing password reset...');
      
      await Supabase.instance.client.auth.resetPasswordForEmail(
        'test@example.com',
      );
      
      print('✅ Password reset working - Email would be sent');
    } catch (e) {
      print('❌ Test password reset error: $e');
    }
  }
}